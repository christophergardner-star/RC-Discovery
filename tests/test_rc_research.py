from dataclasses import asdict
import json
import os
from pathlib import Path
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import tempfile
import threading
import time
import sys
import unittest
from unittest.mock import patch

from rc_research.domain import Problem, digest, parse_proposal, validate_proof
from rc_research.engine import Budget, run_research
from rc_research.memory import Memory, workspace_lock
from rc_research.providers import ModelProvider, post_json, research_prompt
from rc_research.verifier import Verdict, run_process


class ResearchTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.problem = Problem("fixed_goal", "(x : ℝ) : 0 ≤ x^2", "train", ("real",), (), "Calibration")

    def tearDown(self):
        self.temporary.cleanup()

    def memory(self):
        return Memory(self.root / "memory.sqlite3")

    def verdict(self, accepted):
        return Verdict(accepted, "verified" if accepted else "failed", "compiler feedback", 1, "hash", "")

    def test_rejects_command_injection_and_unfinished_proofs(self):
        for proof in ["sorry", "exact sorryAx _", "run_tac do pure ()", "end RCSearch",
                      "set_option maxHeartbeats 0", 'exact (by_elab IO.println "oops")',
                      "simp -- hidden", "native_decide", "exact «sorry»"]:
            with self.subTest(proof=proof), self.assertRaises(ValueError):
                validate_proof(proof)
        validate_proof("intro x\nnlinarith [sq_nonneg x]")

    def test_response_schema_checked_locally(self):
        with self.assertRaises(ValueError):
            parse_proposal(json.dumps({"proof": "rfl", "rationale": "x", "change_goal": True}))
        self.assertEqual(parse_proposal('{"proof":"rfl","rationale":"reflexivity"}')["proof"], "rfl")

    def test_learning_persists_and_is_environment_scoped(self):
        memory = self.memory()
        for proof, success in [("rfl", False), ("simp_all", True), ("positivity", False),
                               ("nlinarith", False), ("aesop", False), ("exact?", False)]:
            memory.record("unit", self.problem, "environment-a", digest(proof), proof, "", self.verdict(success), {})
        self.assertEqual(memory.choose(self.problem, "environment-a", set()), "simp_all")
        self.assertEqual(memory.choose(self.problem, "environment-a", set(), explore=False), "simp_all")
        self.assertTrue(memory.solved(self.problem, "environment-a"))
        self.assertFalse(memory.solved(self.problem, "environment-b"))
        memory.close()
        reopened = self.memory()
        self.assertEqual(reopened.choose(self.problem, "environment-a", set()), "simp_all")
        reopened.close()

    def test_holdout_results_do_not_become_strategies_or_feedback(self):
        memory = self.memory()
        holdout = Problem("unseen", self.problem.statement, "holdout", ("real",), (), "Held out")
        memory.record("eval", holdout, "env", "secret", "exact hidden_answer", "", self.verdict(True), {})
        self.assertNotIn("exact hidden_answer", memory.strategies("env"))
        self.assertEqual(memory.experiences(self.problem, "env"), [])
        memory.close()

    def test_failed_proofs_cannot_enter_verified_strategy_memory(self):
        memory = self.memory()
        memory.record("unit", self.problem, "env", "bad", "exact invalid_answer", "", self.verdict(False), {})
        self.assertNotIn("exact invalid_answer", memory.strategies("env"))
        self.assertFalse(memory.solved(self.problem, "env"))
        memory.close()

    def test_negative_budget_rejected(self):
        with self.assertRaises(ValueError):
            Budget(max_model_calls=-1).validate()
        with self.assertRaises(ValueError):
            Budget(max_seconds=0).validate()

    def test_live_status_can_read_while_writer_holds_run_lock(self):
        memory = self.memory()
        memory.record("unit", self.problem, "env", "recipe", "positivity", "", self.verdict(True), {})
        with workspace_lock(self.root / "research.lock"):
            reader = Memory(self.root / "memory.sqlite3", readonly=True)
            self.assertEqual(reader.summary("env")["current_splits"][0]["solved"], 1)
            reader.close()
        self.assertEqual(memory.experiences(self.problem, "env")[0]["statement"], self.problem.statement)
        memory.close()

    def test_prompt_preserves_goal_and_bounds_large_experiences(self):
        experiences = [{"problem_id": "prior", "statement": "x" * 20000,
                        "proof": "x" * 24000, "feedback": "error" * 10000, "status": "failed"}] * 4
        prompt = research_prompt(self.root, self.problem, experiences)
        self.assertEqual(json.loads(prompt)["statement"], self.problem.statement)
        self.assertLess(len(prompt), 30000)

    def test_state_lock_blocks_a_second_writer_and_releases(self):
        lock = self.root / "state.lock"
        with workspace_lock(lock):
            with self.assertRaises(OSError):
                with workspace_lock(lock):
                    self.fail("A second writer acquired the same state lock")
        with workspace_lock(lock):
            pass

    def test_owned_process_timeout_and_keyboard_interrupt(self):
        started = time.monotonic()
        code, output = run_process([sys.executable, "-c", "import time; time.sleep(20)"], self.root, 0.1)
        self.assertEqual(code, 124)
        self.assertLess(time.monotonic() - started, 5)
        with patch("rc_research.verifier.subprocess.Popen") as constructor, \
                patch("rc_research.verifier.subprocess.run"), \
                patch("rc_research.verifier.os.killpg", create=True):
            constructor.return_value.pid = 12345
            constructor.return_value.communicate.side_effect = [KeyboardInterrupt(), ("stopped", None)]
            with self.assertRaises(KeyboardInterrupt):
                run_process(["test-process"], self.root, 1)
            constructor.return_value.kill.assert_called_once()

    def test_openai_payload_and_incomplete_response(self):
        data = {"status": "completed", "output": [{"type": "message", "content": [
            {"type": "output_text", "text": '{"proof":"positivity","rationale":"square"}'}]}],
            "usage": {"output_tokens": 12}}
        with patch.dict("os.environ", {"OPENAI_API_KEY": "unit-test-placeholder"}), \
                patch("rc_research.providers.post_json", return_value=data) as request:
            provider = ModelProvider("openai", "explicit-model", 2048)
            proposal, usage = provider.propose("goal", 5)
            self.assertEqual(proposal["proof"], "positivity")
            self.assertEqual(usage["output_tokens"], 12)
            payload = request.call_args.args[1]
            self.assertFalse(payload["store"])
            self.assertTrue(payload["text"]["format"]["strict"])
            self.assertEqual(payload["max_output_tokens"], 2048)
        with patch.dict("os.environ", {"OPENAI_API_KEY": "unit-test-placeholder"}), \
                patch("rc_research.providers.post_json", return_value={"status": "incomplete"}):
            with self.assertRaises(RuntimeError):
                ModelProvider("openai", "explicit-model", 2048).propose("goal", 5)

    def test_ollama_structured_payload(self):
        data = {"done": True, "response": '{"proof":"rfl","rationale":"test"}'}
        with patch("rc_research.providers.post_json", return_value=data) as request:
            proposal, _ = ModelProvider("ollama", "local-model", 512).propose("goal", 5)
            self.assertEqual(proposal["proof"], "rfl")
            self.assertFalse(request.call_args.args[1]["stream"])
            self.assertEqual(request.call_args.args[1]["format"]["type"], "object")

    def test_model_revision_receives_failure_and_obeys_call_budget(self):
        registry = self.root / "problems.json"
        registry.write_text(json.dumps({"problems": [asdict(self.problem)]}), encoding="utf-8")
        prompts = []
        prior = Memory(self.root / "state/memory.sqlite3")
        with prior.db:
            prior.db.execute("INSERT INTO runs VALUES (?,?,NULL,?,?,?,?,?)", (
                "stale-run", "2026-01-01", "running", "old-environment", "old-registry", "tactics", "{}"))
        prior.close()

        class Provider:
            def __init__(self, *args):
                pass

            def propose(self, prompt, timeout):
                prompts.append(json.loads(prompt))
                return {"proof": "rfl" if len(prompts) == 1 else "positivity", "rationale": "revise"}, {}

        class Verifier:
            def __init__(self, root):
                pass

            def verify(self, problem, proof, folder, timeout):
                accepted = proof == "positivity"
                return Verdict(accepted, "verified" if accepted else "failed", "fixed-goal compiler error", 0.1, "hash", "")

        with patch("rc_research.engine.ModelProvider", Provider), \
                patch("rc_research.engine.LeanVerifier", Verifier), \
                patch("rc_research.engine.environment_fingerprint", return_value="test-environment"):
            report = run_research(self.root, registry, self.root / "state", "ollama", "unit-model",
                                  Budget(max_attempts=5, max_model_calls=2), "train")
        self.assertEqual(report["status"], "completed")
        self.assertEqual(report["model_calls"], 2)
        self.assertEqual(prompts[1]["statement"], self.problem.statement)
        self.assertEqual(prompts[1]["prior_attempts_and_verified_examples"][0]["status"], "failed")
        recovered = Memory(self.root / "state/memory.sqlite3", readonly=True)
        self.assertEqual(recovered.db.execute("SELECT status FROM runs WHERE id='stale-run'").fetchone()[0], "interrupted")
        recovered.close()

    def test_http_transport_and_total_deadline(self):
        class Handler(BaseHTTPRequestHandler):
            def do_POST(self):
                length = int(self.headers["Content-Length"])
                request = json.loads(self.rfile.read(length))
                if request.get("stall"):
                    time.sleep(3)
                response = json.dumps({"received": request["value"]}).encode()
                try:
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(response)
                except OSError:
                    pass

            def log_message(self, *args):
                pass

        server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        server.daemon_threads = True
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        url = f"http://127.0.0.1:{server.server_port}/test"
        try:
            self.assertEqual(post_json(url, {"value": 42}, {}, 5), {"received": 42})
            started = time.monotonic()
            with self.assertRaises(RuntimeError):
                post_json(url, {"value": 42, "stall": True}, {}, 0.25)
            self.assertLess(time.monotonic() - started, 2)
        finally:
            server.shutdown()
            server.server_close()


if __name__ == "__main__":
    unittest.main()
