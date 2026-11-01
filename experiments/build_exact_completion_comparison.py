"""Prepare rational certificates from two previously retained numerical cases.

NumPy is used only to propose data. The independent standard-library checker
does every acceptance calculation with exact fractions.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


def pack(a, denominator=10**16, hermitian=False):
    a = np.asarray(a)
    if hermitian:
        a = (a+a.conj().T)/2
    real = [[int(round(float(x.real)*denominator)) for x in row] for row in a]
    imag = [[int(round(float(x.imag)*denominator)) for x in row] for row in a]
    if hermitian:
        for i in range(len(a)):
            imag[i][i] = 0
            for j in range(i+1, len(a)):
                real[j][i] = real[i][j]
                imag[j][i] = -imag[i][j]
    return {"denominator": denominator, "real": real, "imag": imag}


def floating(packed):
    return (np.array(packed["real"], dtype=float)
            + 1j*np.array(packed["imag"], dtype=float))/packed["denominator"]


def polar_data(a):
    left, singular, right = np.linalg.svd(a, full_matrices=False)
    return {
        "isometry": pack(left @ right),
        "positive_factor": pack((right.conj().T*singular) @ right, hermitian=True),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path,
                        default=ROOT/"research/exact_comparison_2026-11-01")
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    base = ROOT/"research/paired_search_2026-11-01"
    summary = json.loads((base/"summary.json").read_text(encoding="utf-8"))
    by_id = {r["id"]: r for r in summary["finalists"]}
    specs = [
        (1676, "373/1000", "47/50", "unweighted"),
        (2003, "123/500", "23/25", "weighted"),
    ]
    cases = []
    for identifier, delta_text, alpha_lower, closer in specs:
        from fractions import Fraction
        delta = float(Fraction(delta_text))
        source = base/by_id[identifier]["artifact"]
        with np.load(source, allow_pickle=False) as saved:
            heads = [pack(e, 10**14, True) for e in saved["effects"][:-1]]
            effects = [floating(p) for p in heads]
            effects.append(np.eye(len(effects[0]))-sum(effects))
            models, columns, weights, ranks = [], [], [], []
            denominator = 10**16
            for effect in effects:
                values, vectors = np.linalg.eigh(effect)
                mask = values >= 1-delta
                ranks.append(int(mask.sum()))
                packed_vectors = pack(vectors, denominator)
                rounded_values = [int(round(float(x)*denominator)) for x in values]
                rounded_roots = [int(round(float(np.sqrt(max(0., x)))*denominator))
                                 for x in values]
                models.append({
                    "vectors": packed_vectors, "denominator": denominator,
                    "eigenvalues": rounded_values, "root_weights": rounded_roots,
                })
                columns.append(floating(packed_vectors)[:, mask])
                weights += [rounded_roots[i]/denominator for i in np.where(mask)[0]]
            t = np.concatenate(columns, axis=1)
            case = {
                "id": identifier, "dimension": len(effects[0]), "outcomes": len(effects),
                "effects_head": heads, "delta": delta_text, "ranks": ranks,
                "alpha_reference_lower": alpha_lower, "spectral_models": models,
                "unweighted_polar": polar_data(t),
                "weighted_polar": polar_data(t @ np.diag(weights)),
                "sdp_padding": "1/10000000", "expected_closer": closer,
                "source_artifact": source.relative_to(ROOT).as_posix(),
                "source_artifact_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            }
            for field, prefix in (("unweighted", "u"), ("weighted", "w")):
                dual = math.ceil(by_id[identifier][field]["dual"]*10**9)
                case[field] = {
                    "effects": [pack(f, 10**14, True) for f in saved[field]],
                    "rho": pack(saved[prefix+"_rho"], 10**12, True),
                    "x": [pack(x, 10**12, True) for x in saved[prefix+"_x"]],
                    "y": [pack(y, 10**12, True) for y in saved[prefix+"_y"]],
                    "dual_upper": f"{dual}/1000000000",
                }
            cases.append(case)
    result = {
        "format": "rational-completion-comparison-v1",
        "definition": "The first m-1 effects are the exact encoded rational matrices; the last is I minus their sum. These are new exact measurements, not claims that floating-point search inputs were exact.",
        "cases": cases,
    }
    (output/"certificates.json").write_text(json.dumps(result, indent=2)+"\n", encoding="utf-8")
    print(f"Wrote {len(cases)} proposed rational certificates to {output}")


if __name__ == "__main__":
    main()
