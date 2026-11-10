"""Optional integration tests using the real pinned project and Lean kernel."""
import os
from pathlib import Path
import tempfile
import unittest

from rc_research.domain import Problem
from rc_research.verifier import LeanVerifier, run_process

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(os.environ.get("RC_RESEARCH_LEAN_TESTS") == "1", "Set RC_RESEARCH_LEAN_TESTS=1 for real Lean checks")
class LeanIntegrationTests(unittest.TestCase):
    def setUp(self):
        state = ROOT / "research/local_validation/rc_research"
        state.mkdir(parents=True, exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(dir=state)
        self.folder = Path(self.temporary.name)
        self.verifier = LeanVerifier(ROOT)

    def tearDown(self):
        self.temporary.cleanup()

    def test_correct_proof_is_accepted(self):
        problem = Problem("positive", "(x : ℝ) : 0 ≤ x^2", "train", ("real",), (), "Integration")
        verdict = self.verifier.verify(problem, "positivity", self.folder, 90)
        self.assertTrue(verdict.accepted, verdict.feedback)

    def test_false_claim_is_rejected_by_kernel(self):
        problem = Problem("false_claim", ": False", "train", ("logic",), (), "Negative control")
        verdict = self.verifier.verify(problem, "exact True.intro", self.folder, 90)
        self.assertFalse(verdict.accepted)
        self.assertIn("Type mismatch", verdict.feedback)

    def test_transitive_extra_axiom_is_rejected(self):
        problem = Problem("extra_axiom", ": False", "train", ("logic",), (), "Negative control")
        source, marker = self.verifier.source(problem, "exact injected")
        # Trusted test harness corrupts the environment to test the actual gate.
        source = source.replace("namespace RCSearch\n", "namespace RCSearch\naxiom injected : False\n", 1)
        path = self.folder / "ExtraAxiom.lean"
        path.write_text(source, encoding="utf-8")
        code, output = run_process([self.verifier.lake, "env", "lean", str(path)], ROOT / "lean", 90)
        self.assertNotEqual(code, 0)
        self.assertIn("Forbidden axiom RCSearch.injected", output)
        self.assertNotIn(marker, output)


if __name__ == "__main__":
    unittest.main()
