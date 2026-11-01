"""Corruption controls and an independent determinant audit for the family."""
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import subprocess
import sys

import verify_completion_switch_family as family
import verify_exact_completion_comparison as c
from check_exact_certificate_negative_controls import sylvester_bareiss

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/"research/completion_switch_family_2026-11-01"


def main():
    original = json.loads((OUT/"certificates.json").read_text(encoding="utf-8"))
    mutations = [
        ("wrong_family_matrix", lambda d: d["family"]["A"][0].__setitem__(0, 31)),
        ("changed_interval", lambda d: d["family"].__setitem__("interval", ["1", "4"])),
        ("missing_endpoint", lambda d: d["cases"].pop()),
        ("wrong_endpoint_input", lambda d: d["cases"][0]["effects_head"][1]["real"][0].__setitem__(3, 3)),
        ("reversed_ordering", lambda d: d["cases"][0].__setitem__("expected_closer", "weighted")),
        ("invalid_uniform_vector", lambda d: d["uniform_vectors"][0]["vector"]["real"][0].__setitem__(
            0, 10*d["uniform_vectors"][0]["vector"]["denominator"])),
        ("invalid_uniform_reference_value", lambda d: d["uniform_vectors"][1].__setitem__("eigenvalue", "0")),
        ("false_uniform_packing_reference", lambda d: d.__setitem__("uniform_reference_lower", "1")),
        ("broken_uniform_polar", lambda d: d["uniform_polar"]["positive_factor"]["real"][0].__setitem__(0, 0)),
    ]
    rejections = []
    for name, mutation in mutations:
        proposed = deepcopy(original)
        mutation(proposed)
        try:
            family.verify_family(proposed)
        except AssertionError:
            rejections.append(name)
        else:
            raise RuntimeError(f"Corrupt family was accepted: {name}")
    process = subprocess.run(
        [sys.executable, "-O", str(ROOT/"experiments/verify_completion_switch_family.py")],
        capture_output=True, text=True)
    assert process.returncode != 0 and "without -O" in process.stderr
    rejections.append("optimized_python")
    saved = c.positive_definite
    count = 0
    def audited(a):
        nonlocal count
        sylvester_bareiss(a)
        count += 1
        return saved(a)
    c.positive_definite = audited
    try:
        family.verify_family(original)
    finally:
        c.positive_definite = saved
    result = {
        "result": "PASS", "expected_rejections": rejections,
        "independent_integer_determinant_positivity_checks": count,
        "checker_text_sha256": hashlib.sha256(
            (ROOT/"experiments/verify_completion_switch_family.py").read_text(
                encoding="utf-8").encode("utf-8")).hexdigest(),
    }
    (OUT/"audit.json").write_text(json.dumps(result, indent=2)+"\n", encoding="utf-8")
    print(f"PASS {len(rejections)} expected rejections; "
          f"{count} independent integer-determinant positivity checks.")


if __name__ == "__main__":
    main()
