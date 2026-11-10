from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import time
import uuid

from .domain import digest, load_problems
from .memory import Memory, workspace_lock
from .providers import ModelProvider, research_prompt
from .verifier import LeanVerifier, Verdict, environment_fingerprint


@dataclass(frozen=True)
class Budget:
    max_attempts: int = 12
    max_seconds: float = 300
    proof_timeout: float = 60
    max_model_calls: int = 4
    max_output_tokens: int = 4096

    def validate(self):
        if not 1 <= self.max_attempts <= 10000 or not 1 <= self.max_seconds <= 86400:
            raise ValueError("Attempt and wall-clock budgets are outside supported limits")
        if not 1 <= self.proof_timeout <= 600 or not 0 <= self.max_model_calls <= 10000:
            raise ValueError("Invalid verifier or model-call budget")
        if not 128 <= self.max_output_tokens <= 32000:
            raise ValueError("Invalid model output token cap")


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def run_research(root: Path, registry: Path, state: Path, provider: str,
                 model: str, budget: Budget, split: str, problem_id: str | None = None,
                 ollama_url: str = "http://127.0.0.1:11434") -> dict:
    budget.validate()
    if split not in {"train", "holdout", "research"}:
        raise ValueError("Invalid split")
    problems = [problem for problem in load_problems(registry)
                if problem.split == split and (problem_id is None or problem.id == problem_id)]
    if not problems:
        raise ValueError("No matching problems")
    model_provider = None if provider == "tactics" else ModelProvider(
        provider, model, budget.max_output_tokens, ollama_url)
    verifier = LeanVerifier(root)
    environment = environment_fingerprint(root)
    registry_hash = digest(registry.read_text(encoding="utf-8"))
    state = state.resolve()
    with workspace_lock(state / "research.lock"):
        memory = Memory(state / "memory.sqlite3")
        run_id = uuid.uuid4().hex
        folder = state / "runs" / run_id
        folder.mkdir(parents=True)
        started = time.monotonic()
        deadline = started + budget.max_seconds
        config = asdict(budget) | {"split": split, "model": model, "problem_id": problem_id}
        with memory.db:
            # Holding the OS lock proves earlier running entries lost their writer.
            memory.db.execute("UPDATE runs SET finished=?,status='interrupted' WHERE status='running'", (utc_now(),))
            memory.db.execute("INSERT INTO runs VALUES (?,?,NULL,?,?,?,?,?)", (
                run_id, utc_now(), "running", environment, registry_hash, provider, json.dumps(config)))
        attempts = 0
        calls = 0
        accepted = []
        seen = {problem.id: set() for problem in problems}
        exhausted = set()
        result_status = "budget_exhausted"
        def is_solved(problem):
            # Each holdout invocation evaluates the frozen policy afresh.
            return problem.id in accepted if split == "holdout" else memory.solved(problem, environment)
        try:
            while attempts < budget.max_attempts and time.monotonic() < deadline:
                if environment_fingerprint(root) != environment or digest(registry.read_text(encoding="utf-8")) != registry_hash:
                    raise RuntimeError("Trusted source or problem registry changed during the run")
                available = [problem for problem in problems if problem.id not in exhausted
                             and not is_solved(problem)]
                if not available:
                    result_status = "completed" if all(is_solved(problem) for problem in problems) else "search_exhausted"
                    break
                # Round-robin curriculum prevents one hard goal consuming the whole run.
                problem = available[attempts % len(available)]
                attempt_folder = folder / f"attempt-{attempts + 1:05d}"
                attempt_folder.mkdir(exist_ok=True)
                proof = ""
                rationale = "Adaptive local tactic policy"
                usage = {}
                strategy = "provider_error"
                proposal_started = time.monotonic()
                try:
                    if model_provider is None:
                        selected = memory.choose(problem, environment, seen[problem.id], explore=split != "holdout")
                        if selected is None:
                            exhausted.add(problem.id)
                            continue
                        proof = selected
                    else:
                        if calls >= budget.max_model_calls:
                            break
                        # Each request consumes a call, including transport failures.
                        calls += 1
                        experiences = memory.experiences(problem, environment)
                        prompt = research_prompt(root, problem, experiences)
                        (attempt_folder / "prompt.json").write_text(prompt, encoding="utf-8")
                        proposal, usage = model_provider.propose(prompt, min(90, deadline - time.monotonic()))
                        proof, rationale = proposal["proof"], proposal["rationale"]
                    strategy = digest(proof)
                    seen[problem.id].add(proof)
                    (attempt_folder / "proposal.json").write_text(
                        json.dumps({"proof": proof, "rationale": rationale, "usage": usage}, indent=2), encoding="utf-8")
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        verdict = Verdict(False, "timeout", "Run wall-clock budget exhausted", 0, digest(proof), "")
                    else:
                        verdict = verifier.verify(problem, proof, attempt_folder, min(budget.proof_timeout, remaining))
                    if environment_fingerprint(root) != environment:
                        raise RuntimeError("Trusted source changed while checking the proof")
                except (ValueError, RuntimeError, OSError) as error:
                    verdict = Verdict(False, "provider_or_validation_error", str(error),
                                      time.monotonic() - proposal_started, digest(proof), "")
                memory.record(run_id, problem, environment, strategy, proof, rationale, verdict, usage)
                attempts += 1
                if verdict.accepted:
                    accepted.append(problem.id)
                print(json.dumps({"attempt": attempts, "problem": problem.id,
                                  "status": verdict.status, "seconds": round(verdict.seconds, 2)}, ensure_ascii=False), flush=True)
            solved = [problem.id for problem in problems if is_solved(problem)]
            if len(solved) == len(problems):
                result_status = "completed"
            report = {"run_id": run_id, "status": result_status, "provider": provider,
                      "model": model, "environment": environment, "registry_hash": registry_hash,
                      "attempts": attempts, "model_calls": calls, "accepted_this_run": accepted,
                      "solved_in_current_environment": solved,
                      "remaining": [problem.id for problem in problems if problem.id not in solved],
                      "seconds": round(time.monotonic() - started, 2), "budget": config,
                      "scope": "Acceptance means the fixed Lean statement compiled and passed its transitive axiom gate. Novelty and scientific significance require separate review."}
            (folder / "report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
            return report
        finally:
            with memory.db:
                memory.db.execute("UPDATE runs SET finished=?,status=? WHERE id=?",
                                  (utc_now(), result_status if 'report' in locals() else "interrupted_or_failed", run_id))
            memory.close()
