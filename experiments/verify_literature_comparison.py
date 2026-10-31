"""Check the explicit reductions in the theorem-level literature comparison.

Rational calculations check finite examples and substitutions exactly.
Matrix identities and primal/dual SDPs are floating-point diagnostics, not
formal proofs or certified interval bounds. The general arguments are in
literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md.

Run from the repository root with the audit virtual environment.
"""
from __future__ import annotations

from fractions import Fraction as F
import hashlib
from itertools import product
import json
from pathlib import Path
import subprocess

import numpy as np

from test_adversarial_same_label import lifted_simplex
from test_theorem_v1_contract import (
    build_rounding,
    hermitian,
    measurement_diamond_sdp,
    mixed_povm,
    operator_norm,
)

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research/literature_comparison/validation.json"
SEED = 2026103141
TOL = 2e-8


def diagonal_distance(first, second):
    """Exact diamond norm for two channels measuring diagonal effects."""
    return max(sum(abs(a[k] - b[k]) for a, b in zip(first, second))
               for k in range(len(first[0])))


def rational_checks():
    substitutions = 0
    for alpha, d, maximum in product(
        (F(1, 100), F(1, 4), F(1, 2), F(1)),
        (F(1, 2), F(3, 4), F(1)),
        (F(1, 2), F(1), F(3, 2), F(2)),
    ):
        if maximum < alpha:
            continue
        a = (maximum - alpha) / (maximum + alpha)
        b = (1 - d) / (1 + d)
        scale = (maximum + alpha) * (1 + d) / 4
        assert 1-a-b == (4*alpha*d-(maximum-alpha)*(1-d))/(
            (maximum+alpha)*(1+d))
        assert scale*(1-a)*(1-b) == alpha*d
        assert (a+b <= 1) == ((maximum-alpha)*(1-d) <= 4*alpha*d)
        substitutions += 1
    # Include the equality endpoint of the old Jordan-product condition.
    alpha, d, maximum = F(1, 10), F(1, 2), F(1, 2)
    assert (maximum-alpha)*(1-d) == 4*alpha*d
    assert ((maximum-alpha)/(maximum+alpha)+(1-d)/(1+d)) == 1

    separation = []
    inverse_examples = []
    for t in (F(1, 10000), F(1, 100), F(1, 10), F(1, 4), F(49, 100)):
        effects = [(1-t, t, F(1, 2)), (t, 1-t, F(1, 2))]
        rounded = [(F(1), F(0), F(1, 2)), (F(0), F(1), F(1, 2))]
        assert all(0 <= x <= 1 for row in effects for x in row)
        assert all(sum(row[k] for row in effects) == 1 for k in range(3))
        sectors = [[k for k, x in enumerate(row) if x >= 1-t]
                   for row in effects]
        assert sectors == [[0], [1]]
        assert diagonal_distance(effects, rounded) == 2*t
        defect = max(1-sum(row[k]**2 for row in effects) for k in range(3))
        assert defect == F(1, 2)
        pvm_distances = []
        for diagonal in product((F(0), F(1)), repeat=3):
            pvm = [diagonal, tuple(1-x for x in diagonal)]
            pvm_distances.append(diagonal_distance(effects, pvm))
        assert min(pvm_distances) == 1
        # The report proves the lower bound for ALL projections, including
        # non-diagonal ones, via eigenvalue perturbation. This enumeration
        # checks attainability and diagonal examples, not that universal step.
        separation.append({
            "t": str(t), "alpha": "1", "delta": str(t),
            "movement": str(2*t), "near_projectivity_defect": str(defect),
            "minimum_over_diagonal_pvms": "1",
        })

        matrix = ((1-t, t), (t, 1-t))
        inverse = (((1-t)/(1-2*t), -t/(1-2*t)),
                   (-t/(1-2*t), (1-t)/(1-2*t)))
        assert all(sum(matrix[i][k]*inverse[k][j] for k in range(2))
                   == int(i == j) for i, j in product(range(2), repeat=2))
        assert inverse[1][0] < 0
        inverse_examples.append({"t": str(t), "negative_entry": str(inverse[1][0])})

    trace_examples = []
    for dimension in (4, 16, 64, 256):
        first = tuple(F(int(k < 2)) for k in range(dimension))
        second = tuple(F(int(k == 0)) for k in range(dimension))
        effects = [first, tuple(1-x for x in first)]
        rounded = [second, tuple(1-x for x in second)]
        normalized_l2_squared = sum(
            (a-b)**2 for row1, row2 in zip(effects, rounded)
            for a, b in zip(row1, row2)) / dimension
        assert normalized_l2_squared == F(2, dimension)
        assert diagonal_distance(effects, rounded) == 2
        trace_examples.append({
            "dimension": dimension, "normalized_l2_squared": str(normalized_l2_squared),
            "diamond_distance": "2",
        })
    return {
        "jordan_substitutions": substitutions,
        "jordan_equality_endpoint": True,
        "residual_separation": separation,
        "nonpositive_inverse": inverse_examples,
        "trace_to_uniform_obstruction": trace_examples,
    }


def weighted_case(effects, delta, name):
    data = build_rounding(effects, delta)
    t = data.synthesis
    w = data.measurement_isometry
    j = data.labelled_inclusion
    r = data.residual_projector
    a = t @ data.sector_square_root
    left, singular, right = np.linalg.svd(a, full_matrices=False)
    u = left @ right
    absolute = (right.conj().T*singular) @ right
    v = j @ u.conj().T + w @ r
    n, rank = t.shape
    errors = {
        "factorization": operator_norm(a-w.conj().T @ j),
        "polar_isometry": operator_norm(u.conj().T @ u-np.eye(rank)),
        "same_range": operator_norm(u @ u.conj().T-data.total_projector),
        "hybrid_isometry": operator_norm(v.conj().T @ v-np.eye(n)),
        "overlap_identity": operator_norm(
            w.conj().T @ v-(u @ absolute @ u.conj().T+r)),
    }
    lower = min(1.0, data.alpha)*np.sqrt(1-delta)
    overlap = w.conj().T @ v
    floor = float(np.linalg.eigvalsh(hermitian(overlap)).min())
    assert operator_norm(overlap-overlap.conj().T) < TOL
    assert float(singular[-1]) >= lower-TOL
    assert floor >= lower-TOL
    movement_bound = 2*np.sqrt(max(0.0, 1-lower**2))
    sector_bound = movement_bound/2
    rounded = []
    offset = 0
    for label, basis in enumerate(data.bases):
        size = basis.shape[1]
        block = u[:, offset:offset+size]
        q = block @ block.conj().T
        effect = hermitian(q+r @ effects[label] @ r)
        rounded.append(effect)
        vb = v[label*n:(label+1)*n]
        errors[f"compression_{label}"] = operator_norm(vb.conj().T @ vb-effect)
        assert operator_norm(data.projectors[label]-q) <= sector_bound+TOL
        assert operator_norm(r @ effects[label] @ r) <= 1-delta+TOL
        offset += size
    errors["normalization"] = operator_norm(sum(rounded)-np.eye(n))
    assert max(errors.values()) < TOL, (name, errors)
    changed = max(operator_norm(x-y)
                  for x, y in zip(rounded, data.completed_effects))
    width_condition = (
        (float(data.singular_values[0])-data.alpha)*(1-np.sqrt(1-delta))
        <= 4*data.alpha*np.sqrt(1-delta))
    return ({
        "name": name, "dimension": n, "outcomes": len(effects),
        "alpha": data.alpha, "delta": delta, "movement_bound": movement_bound,
        "overlap_floor": floor, "required_floor": lower,
        "max_identity_error": max(errors.values()),
        "difference_from_unweighted_completion": changed,
        "unweighted_width_condition": bool(width_condition),
    }, rounded)


def main():
    rng = np.random.default_rng(SEED)
    exact = rational_checks()
    cases = []
    sdp_inputs = []
    for ranks, residual, noise, trial in product(
        ([1, 1], [1, 1, 1], [2, 1, 2], [2, 2]),
        (0, 2), (1e-6, .02, .15, .35), range(3),
    ):
        effects = mixed_povm(ranks, residual, noise, rng)
        name = f"ranks={ranks};residual={residual};noise={noise};trial={trial}"
        row, rounded = weighted_case(effects, 1.1*noise, name)
        cases.append(row)
        if trial == 0 and noise == .15 and ranks in ([1, 1], [1, 1, 1]):
            sdp_inputs.append((effects, rounded, row))
    for m, alpha in product((8, 16), (1e-5, .01, .5)):
        effects, delta = lifted_simplex(m, alpha)
        row, _ = weighted_case(effects, delta, f"simplex_m={m};alpha={alpha}")
        cases.append(row)
    for name, effects in (
        ("single_label", [np.eye(3)]),
        ("zero_label", [np.diag([1., 0.]), np.diag([0., 1.]), np.zeros((2, 2))]),
    ):
        row, _ = weighted_case(effects, .01, name)
        cases.append(row)

    assert any(not row["unweighted_width_condition"] for row in cases)
    assert max(row["difference_from_unweighted_completion"] for row in cases) > 1e-6
    sdps = []
    # Two exact analytical anchors also check the measurement SDP convention.
    t = .01
    effects = [np.diag([1-t, t, .5]), np.diag([t, 1-t, .5])]
    rounded = [np.diag([1., 0., .5]), np.diag([0., 1., .5])]
    pvm = [np.diag([1., 0., 0.]), np.diag([0., 1., 1.])]
    for name, target, expected in (
        ("residual_rounding_anchor", rounded, 2*t),
        ("pvm_separation_anchor", pvm, 1.0),
    ):
        result = measurement_diamond_sdp(effects, target)
        assert abs(float(result["primal"])-expected) < 3e-6
        sdps.append({"name": name, "expected": expected, **result})
    for effects, rounded, row in sdp_inputs:
        result = measurement_diamond_sdp(effects, rounded)
        assert float(result["dual"]) <= row["movement_bound"]+3e-6
        sdps.append({"name": row["name"], "bound": row["movement_bound"], **result})
    sources = [
        Path(__file__).resolve(),
        ROOT / "experiments/test_theorem_v1_contract.py",
        ROOT / "experiments/test_adversarial_same_label.py",
        ROOT / "theory/THEOREM_V1_FREEZE.md",
    ]
    output = {
        "seed": SEED, "tolerance": TOL,
        "scope": "Exact finite rational checks plus floating-point diagnostics; not a novelty or formal proof certificate.",
        "starting_commit": subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        "source_hashes": {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in sources},
        "exact_checks": exact, "weighted_cases": cases, "sdp_results": sdps,
        "max_identity_error": max(row["max_identity_error"] for row in cases),
        "max_completion_difference": max(row["difference_from_unweighted_completion"]
                                         for row in cases),
        "width_condition_failing_cases": sum(
            not row["unweighted_width_condition"] for row in cases),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(output, indent=2)+"\n", encoding="utf-8")
    print(f"PASS: {exact['jordan_substitutions']} rational substitutions; "
          f"5 residual/inverse families; 4 metric examples; "
          f"{len(cases)} weighted constructions; {len(sdps)} primal/dual SDPs.")
    print(f"Max identity residual: {output['max_identity_error']:.3g}; "
          f"weighted/unweighted difference: {output['max_completion_difference']:.3g}.")
    print(f"Output: {OUT}")


if __name__ == "__main__":
    main()
