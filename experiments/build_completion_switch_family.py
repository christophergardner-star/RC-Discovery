"""Propose exact endpoint and uniform certificates for a one-parameter family.

Numerical routines propose witnesses only. verify_completion_switch_family.py
checks the retained proof data with exact standard-library arithmetic.
"""
from __future__ import annotations
from fractions import Fraction as F
import json
import math
from pathlib import Path
import numpy as np
from build_exact_completion_comparison import pack, floating, polar_data
from test_theorem_v1_contract import build_rounding
from search_prescribed_completion import weighted_completion, DiamondSolver

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/"research/completion_switch_family_2026-11-01"
A = [[32, 0, 3, 1], [0, 2, 2, 2], [3, 2, 4, 4], [1, 2, 4, 8]]
B0 = [[4, 2, -2, 0], [2, 34, -3, -1], [-2, -3, 2, -2], [0, -1, -2, 12]]


def packed_effects(t):
    assert isinstance(t, int)
    b = [row.copy() for row in B0]
    b[0][3] = b[3][0] = t
    return [{"denominator": 40, "real": a, "imag": [[0]*4 for _ in range(4)]}
            for a in (A, b)]


def effects(t):
    a, b = np.array(A, dtype=float), np.array(B0, dtype=float)
    b[0, 3] = b[3, 0] = float(t)
    return [a/40, b/40, np.eye(4)-(a+b)/40]


def endpoint_certificate(t, solver):
    es = effects(t)
    data = build_rounding(es, .25)
    weighted, _ = weighted_completion(data)
    models, columns, roots = [], [], []
    denominator = 10**16
    for e in es:
        values, vectors = np.linalg.eigh(e)
        selected = values > .75
        assert selected.sum() == 1
        z = pack(vectors)
        values_int = [int(round(float(x)*denominator)) for x in values]
        roots_int = [int(round(float(np.sqrt(x))*denominator)) for x in values]
        models.append({"vectors": z, "denominator": denominator,
                       "eigenvalues": values_int, "root_weights": roots_int})
        columns.append(floating(z)[:, selected])
        roots += [roots_int[i]/denominator for i in np.where(selected)[0]]
    t0 = np.concatenate(columns, axis=1)
    case = {
        "id": f"t={t}", "parameter": str(t), "dimension": 4, "outcomes": 3,
        "effects_head": packed_effects(t), "delta": "1/4", "ranks": [1, 1, 1],
        "alpha_reference_lower": "9/10", "spectral_models": models,
        "unweighted_polar": polar_data(t0),
        "weighted_polar": polar_data(t0 @ np.diag(roots)),
        "sdp_padding": "1/10000000",
        "expected_closer": "unweighted" if t == 2 else "weighted",
    }
    numerical = {}
    for field, target in (("unweighted", data.completed_effects), ("weighted", weighted)):
        info, arrays = solver.solve(es, target)
        numerical[field] = info
        case[field] = {
            "effects": [pack(f, 10**14, True) for f in target],
            "rho": pack(arrays["rho"], 10**12, True),
            "x": [pack(x, 10**12, True) for x in arrays["x"]],
            "y": [pack(y, 10**12, True) for y in arrays["y"]],
            "dual_upper": f"{math.ceil(info['dual']*10**9)}/1000000000",
        }
    return case, numerical


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    solver = DiamondSolver(4, 3)
    cases, endpoints = [], {}
    for t in (2, 4):
        case, numerical = endpoint_certificate(t, solver)
        cases.append(case)
        endpoints[str(t)] = numerical
        print(f"Prepared t={t} endpoints.", flush=True)
    vectors, uniform = [], []
    for e in effects(3):
        values, z = np.linalg.eigh(e)
        v = pack(z[:, -1:])
        vectors.append(floating(v))
        uniform.append({"vector": v,
                        "eigenvalue": f"{int(round(float(values[-1])*10**16))}/{10**16}"})
    result = {
        "format": "completion-switch-family-v1",
        "family": {"denominator": 40, "A": A, "B_constant": B0,
                   "interval": ["2", "4"], "delta": "1/4",
                   "varying_entries_zero_based": [[0, 3], [3, 0]]},
        "cases": cases, "uniform_vectors": uniform,
        "uniform_polar": polar_data(np.concatenate(vectors, axis=1)),
        "uniform_reference_lower": "927/1000",
    }
    (OUT/"certificates.json").write_text(json.dumps(result, indent=2)+"\n", encoding="utf-8")
    curve = []
    for k in range(8, 17):
        t = F(k, 4)
        es = effects(t)
        data = build_rounding(es, .25)
        weighted, _ = weighted_completion(data)
        if t.denominator == 1 and str(t) in endpoints:
            pair = endpoints[str(t)]
        else:
            u, _ = solver.solve(es, data.completed_effects)
            w, _ = solver.solve(es, weighted)
            pair = {"unweighted": u, "weighted": w}
        curve.append({"t": str(t), **pair,
                      "weighted_minus_unweighted": pair["weighted"]["primal"]-pair["unweighted"]["primal"]})
        print(f"Numerical t={t}: weighted minus unweighted "
              f"{curve[-1]['weighted_minus_unweighted']:.9g}", flush=True)
    (OUT/"numerical_curve.json").write_text(
        json.dumps({"scope": "Numerical illustration only; exact conclusions use certificates.",
                    "points": curve}, indent=2)+"\n", encoding="utf-8")


if __name__ == "__main__":
    main()
