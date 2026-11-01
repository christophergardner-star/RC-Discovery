"""Deliberately corrupt exact comparison certificates and require rejection."""
from copy import deepcopy
import hashlib
import json
from math import lcm
from pathlib import Path
import subprocess
import sys

import verify_exact_completion_comparison as checker
from verify_exact_completion_comparison import verify_case

ROOT = Path(__file__).resolve().parents[1]
DIRECTORY = ROOT/"research/exact_comparison_2026-11-01"


def sylvester_bareiss(a):
    """Independent exact positivity test using integer principal determinants."""
    assert a == checker.transpose(a)
    denominator = lcm(*(x.denominator for row in a for x in row))
    integral = [[int(x*denominator) for x in row] for row in a]
    for size in range(1, len(a)+1):
        b = [row[:size] for row in integral[:size]]
        previous = 1
        for k in range(size-1):
            pivot = b[k][k]
            assert pivot != 0
            for i in range(k+1, size):
                for j in range(k+1, size):
                    numerator = b[i][j]*pivot-b[i][k]*b[k][j]
                    quotient, remainder = divmod(numerator, previous)
                    assert remainder == 0
                    b[i][j] = quotient
            previous = pivot
        assert b[-1][-1] > 0


def main():
    cases = json.loads((DIRECTORY/"certificates.json").read_text(encoding="utf-8"))["cases"]
    original = cases[0]
    changes = [
        ("negative_effect", lambda c: c["effects_head"][0]["real"][0].__setitem__(
            0, -c["effects_head"][0]["denominator"])),
        ("wrong_sector_rank", lambda c: c["ranks"].__setitem__(0, 1)),
        ("invalid_threshold", lambda c: c.__setitem__("delta", "0")),
        ("false_packing_lower_bound", lambda c: c.__setitem__("alpha_reference_lower", "1")),
        ("nonunitary_spectral_model", lambda c: c["spectral_models"][0]["vectors"]["real"][0].__setitem__(
            0, 10*c["spectral_models"][0]["vectors"]["denominator"])),
        ("broken_polar_factor", lambda c: c["unweighted_polar"]["isometry"]["real"][0].__setitem__(
            0, 10*c["unweighted_polar"]["isometry"]["denominator"])),
        ("infeasible_primal", lambda c: c["weighted"]["x"][0]["real"][0].__setitem__(
            0, 10*c["weighted"]["x"][0]["denominator"])),
        ("false_dual_bound", lambda c: c["unweighted"].__setitem__("dual_upper", "0")),
        ("missing_effect", lambda c: c["weighted"]["effects"].pop()),
        ("reversed_conclusion", lambda c: c.__setitem__("expected_closer", "weighted")),
    ]
    results = []
    for name, mutation in changes:
        candidate = deepcopy(original)
        mutation(candidate)
        try:
            verify_case(candidate)
        except AssertionError:
            results.append({"name": name, "result": "REJECTED"})
        else:
            raise RuntimeError(f"Corrupt certificate was accepted: {name}")
    command = [sys.executable, "-O", str(ROOT/"experiments/verify_exact_completion_comparison.py")]
    process = subprocess.run(command, capture_output=True, text=True)
    assert process.returncode != 0 and "without -O" in process.stderr
    results.append({"name": "optimized_python_disables_assertions", "result": "REJECTED"})
    original_pd = checker.positive_definite
    checked_matrices = 0
    def audited_pd(a):
        nonlocal checked_matrices
        sylvester_bareiss(a)
        checked_matrices += 1
        return original_pd(a)
    checker.positive_definite = audited_pd
    try:
        for case in cases:
            verify_case(case)
    finally:
        checker.positive_definite = original_pd
    report = {
        "result": "PASS", "expected_rejections": results,
        "independent_integer_Bareiss_positive_matrices": checked_matrices,
        "checker_text_sha256": hashlib.sha256(
            (ROOT/"experiments/verify_exact_completion_comparison.py").read_text(
                encoding="utf-8").encode("utf-8")).hexdigest(),
    }
    (DIRECTORY/"negative_controls.json").write_text(
        json.dumps(report, indent=2)+"\n", encoding="utf-8")
    print(f"PASS {len(results)} expected rejections; "
          f"{checked_matrices} positive matrices independently checked by integer Bareiss determinants.")


if __name__ == "__main__":
    main()
