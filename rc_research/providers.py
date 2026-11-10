from __future__ import annotations

import json
import multiprocessing
import os
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from .domain import PROPOSAL_SCHEMA, Problem, parse_proposal


def research_prompt(root: Path, problem: Problem, experiences: list[dict]) -> str:
    payload = {
        "task": "Prove the fixed Lean theorem. Return JSON with proof and rationale strings. "
                "The proof is a tactic body without its initial by. Learn from the compiler feedback. "
                "Use imports already available through RCProof. Do not change the goal. "
                "No comments, quoted strings, commands, metaprogramming, native_decide, sorry or added axioms. "
                "A failed attempt is acceptable. A claim of success without a checked proof is insufficient.",
        "problem_id": problem.id, "statement": problem.statement,
        "provenance": problem.provenance, "tags": problem.tags,
        "context": [], "prior_attempts_and_verified_examples": [],
    }
    # Preserve the complete fixed goal and bound context for local models.
    remaining = 30000 - len(json.dumps(payload, ensure_ascii=False)) - 1000
    limits = {"problem_id": 80, "statement": 4000, "provenance": 1000,
              "proof": 4000, "status": 80, "feedback": 2000}
    for experience in experiences:
        item = {key: str(experience.get(key) or "")[:limit] for key, limit in limits.items()}
        size = len(json.dumps(item, ensure_ascii=False))
        if size > remaining:
            break
        payload["prior_attempts_and_verified_examples"].append(item)
        remaining -= size
    for name in problem.context:
        path = (root / name).resolve()
        if root.resolve() not in path.parents or path.suffix not in {".lean", ".md"}:
            raise ValueError("Context paths must be repository Lean or Markdown files")
        if remaining < 300:
            break
        item = {"path": name, "excerpt": path.read_text(encoding="utf-8")[:min(8000, remaining - 200)]}
        size = len(json.dumps(item, ensure_ascii=False))
        if size > remaining:
            break
        payload["context"].append(item)
        remaining -= size
    return json.dumps(payload, ensure_ascii=False)


def _request_json(url: str, data: dict, headers: dict, timeout: float) -> dict:
    request = Request(url, json.dumps(data).encode(),
                      headers={"Content-Type": "application/json", **headers}, method="POST")
    try:
        with urlopen(request, timeout=timeout) as response:
            raw = response.read(2_000_001)
    except HTTPError as error:
        # Avoid logging response bodies, which can contain request details.
        raise RuntimeError(f"Model endpoint returned HTTP {error.code}") from None
    except URLError as error:
        raise RuntimeError(f"Model endpoint unavailable: {error.reason}") from None
    if len(raw) > 2_000_000:
        raise ValueError("Model response exceeded the response limit")
    return json.loads(raw)


def _request_worker(connection, url, data, headers, timeout):
    try:
        connection.send((True, _request_json(url, data, headers, timeout)))
    except Exception as error:
        connection.send((False, str(error)))
    finally:
        connection.close()


def post_json(url: str, data: dict, headers: dict, timeout: float) -> dict:
    """Enforce a total request deadline, including a stalled response body."""
    if timeout <= 0:
        raise RuntimeError("Model-call wall-clock budget exhausted")
    context = multiprocessing.get_context("spawn")
    receiver, sender = context.Pipe(duplex=False)
    process = context.Process(target=_request_worker, args=(sender, url, data, headers, timeout), daemon=True)
    process.start()
    sender.close()
    try:
        if not receiver.poll(timeout):
            raise RuntimeError("Model call exceeded its wall-clock budget")
        success, result = receiver.recv()
        if not success:
            raise RuntimeError(result)
        return result
    except EOFError:
        raise RuntimeError("Model request worker ended without a response") from None
    finally:
        receiver.close()
        if process.is_alive():
            process.terminate()
        process.join(timeout=3)
        if process.is_alive():
            process.kill()
            process.join()


class ModelProvider:
    def __init__(self, provider: str, model: str, max_output_tokens: int,
                 ollama_url: str = "http://127.0.0.1:11434"):
        if provider not in {"openai", "ollama"}:
            raise ValueError("Unknown model provider")
        if not model:
            raise ValueError("Choose a model with --model or RC_RESEARCH_MODEL")
        if provider == "openai" and not os.environ.get("OPENAI_API_KEY"):
            raise RuntimeError("OPENAI_API_KEY is unset. Configure it locally or use the tactics backend")
        self.provider = provider
        self.model = model
        self.max_output_tokens = max_output_tokens
        self.ollama_url = ollama_url.rstrip("/")

    def propose(self, prompt: str, timeout: float) -> tuple[dict, dict]:
        if self.provider == "openai":
            data = post_json("https://api.openai.com/v1/responses", {
                "model": self.model, "input": prompt, "store": False,
                "max_output_tokens": self.max_output_tokens,
                "text": {"format": {"type": "json_schema", "name": "lean_proposal",
                                    "strict": True, "schema": PROPOSAL_SCHEMA}},
            }, {"Authorization": "Bearer " + os.environ["OPENAI_API_KEY"]}, timeout)
            if data.get("status") != "completed":
                raise RuntimeError("Model response incomplete or failed")
            texts = [item["text"] for output in data.get("output", [])
                     if output.get("type") == "message" for item in output.get("content", [])
                     if item.get("type") == "output_text"]
            if not texts:
                raise ValueError("No structured proof returned, or the model refused")
            return parse_proposal("".join(texts)), data.get("usage", {})
        data = post_json(self.ollama_url + "/api/generate", {
            "model": self.model, "prompt": prompt, "stream": False,
            "format": PROPOSAL_SCHEMA,
            "options": {"num_predict": self.max_output_tokens, "num_ctx": 16384},
        }, {}, timeout)
        if not data.get("done") or data.get("done_reason") == "length":
            raise RuntimeError("Local model response incomplete")
        return parse_proposal(data["response"]), {
            "input_tokens": data.get("prompt_eval_count", 0),
            "output_tokens": data.get("eval_count", 0),
        }
