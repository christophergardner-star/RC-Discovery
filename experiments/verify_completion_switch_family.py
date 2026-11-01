"""Exact endpoint and whole-interval checks for the four-dimensional family.

Only the Python standard library and the repository's rational matrix checker
are imported. The analytical bridge is in theory/completion_switch_family.md.
"""
from __future__ import annotations
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/"research/completion_switch_family_2026-11-01"
A = [[32, 0, 3, 1], [0, 2, 2, 2], [3, 2, 4, 4], [1, 2, 4, 8]]
B0 = [[4, 2, -2, 0], [2, 34, -3, -1], [-2, -3, 2, -2], [0, -1, -2, 12]]


def family_effects(t):
    b = [row.copy() for row in B0]
    assert t.denominator == 1
    b[0][3] = b[3][0] = t.numerator
    e = [c.unpack({"denominator": 40, "real": matrix,
                   "imag": [[0]*4 for _ in range(4)]}) for matrix in (A, b)]
    e.append(c.sub(c.eye(8), c.sum_matrices(e)))
    return e


def verify_family(document):
    assert document["format"] == "completion-switch-family-v1"
    family = document["family"]
    assert family == {"denominator": 40, "A": A, "B_constant": B0,
                      "interval": ["2", "4"], "delta": "1/4",
                      "varying_entries_zero_based": [[0, 3], [3, 0]]}
    assert len(document["cases"]) == 2
    endpoints = [family_effects(F(2)), family_effects(F(4))]
    endpoint_results = []
    for case, t, expected in zip(document["cases"], (2, 4), ("unweighted", "weighted")):
        assert F(case["parameter"]) == t
        assert case["dimension"] == 4 and case["outcomes"] == 3
        assert case["ranks"] == [1, 1, 1] and F(case["delta"]) == F(1, 4)
        assert case["expected_closer"] == expected
        actual = [c.unpack(p) for p in case["effects_head"]]
        actual.append(c.sub(c.eye(8), c.sum_matrices(actual)))
        assert actual == family_effects(F(t))
        endpoint_results.append(c.verify_case(case))
    for es in endpoints:
        for e in es:
            c.positive_definite(e)
    # Affinity and positivity at both ends prove positivity on the whole interval.
    threshold = F(3, 4)
    betas = []
    for j in range(3):
        a_values = [es[j][j][j] for es in endpoints]
        beta_values = [c.trace(es[j])/2-es[j][j][j] for es in endpoints]
        assert a_values[0] == a_values[1]
        assert beta_values[0] == beta_values[1]
        assert 0 <= beta_values[0] < threshold < a_values[0] <= 1
        betas.append(beta_values[0])
    assert len(document["uniform_vectors"]) == 3
    vectors, reports = [], []
    synthesis_error = F(0)
    for j, model in enumerate(document["uniform_vectors"]):
        z = c.unpack(model["vector"])
        assert len(z) == 8 and all(len(row) == 2 for row in z)
        mu = F(model["eigenvalue"])
        assert betas[j] < mu <= 1
        eta = c.op_bound(c.sub(c.mul(c.transpose(z), z), c.eye(2)))
        assert eta < F(1, 2)
        residuals = []
        for es in endpoints:
            residual = c.sub(c.mul(es[j], z), c.scale(mu, z))
            squared = c.trace(c.mul(c.transpose(residual), residual))/2
            residuals.append(c.ceil_root(squared, 10**12))
        residual_bound = max(residuals)+2*eta
        p = residual_bound/(mu-betas[j])
        assert 0 <= p < F(1, 4)
        synthesis_error += p+p*p+eta
        vectors.append(z)
        reports.append({
            "low_spectrum_upper": betas[j], "reference_eigenvalue": mu,
            "gram_error": eta, "uniform_vector_residual": residual_bound,
            "uniform_projector_error": p,
        })
    t0 = [[z[row][0] for z in vectors]+[z[row][1] for z in vectors] for row in range(8)]
    assert F(document["uniform_reference_lower"]) == F(927, 1000)
    _, _, alpha_lower, polar_report = c.polar_error(
        t0, synthesis_error, document["uniform_polar"], F(927, 1000))
    assert alpha_lower > F(9, 10)
    theorem_bound = 1+2*c.ceil_root(F(19, 100))
    assert theorem_bound < 2
    return {
        "result": "PASS", "interval": ["2", "4"], "endpoint_results": endpoint_results,
        "uniform_spectral_ranks": [1, 1, 1], "uniform_spectral_data": reports,
        "uniform_synthesis_error": synthesis_error,
        "reference_perturbation": polar_report["reference_perturbation"],
        "uniform_alpha_lower": alpha_lower,
        "uniform_alpha_exceeds": F(9, 10),
        "uniform_theorem_bound_upper": theorem_bound,
        "conclusion": "Endpoint orderings are opposite; every parameter in [2,4] satisfies the informative theorem hypotheses. Continuity implies at least one equality point in (2,4).",
    }


def main():
    source = OUT/"certificates.json"
    text = source.read_text(encoding="utf-8")
    result = verify_family(json.loads(text))
    report = {
        "arithmetic": "Exact integers and fractions; no numerical acceptance tests.",
        "scope": "Exact finite certificates plus analytic whole-interval and continuity arguments; not a full Lean proof or novelty finding.",
        "certificate_text_sha256": hashlib.sha256(text.encode("utf-8")).hexdigest(),
        "source_text_sha256": {
            str(p.relative_to(ROOT)).replace("\\", "/"): hashlib.sha256(
                p.read_text(encoding="utf-8").encode("utf-8")).hexdigest()
            for p in (Path(__file__).resolve(), ROOT/"experiments/verify_exact_completion_comparison.py",
                      ROOT/"theory/completion_switch_family.md",
                      ROOT/"theory/exact_completion_comparison.md")
        },
        **c.serializable(result),
    }
    (OUT/"verification.json").write_text(json.dumps(report, indent=2)+"\n", encoding="utf-8")
    for row in result["endpoint_results"]:
        print(f"PASS exact endpoint {row['id']}: {row['closer']} closer; "
              f"separation >= {c.interval(row['strict_separation'])['lower']}")
    print("PASS entire interval: alpha lower", c.interval(result["uniform_alpha_lower"]),
          "; theorem upper", c.interval(result["uniform_theorem_bound_upper"]))


if __name__ == "__main__":
    main()
