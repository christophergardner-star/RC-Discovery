"""Check retained search witnesses by explicit reference-assisted measurement.

This evaluates the physical conditional output matrices, as well as the
saved SDP constraints. It performs no optimization. Checks are numerical,
not interval arithmetic or a formal proof.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def hermitian(a):
    return (a+a.conj().T)/2


def minimum(a):
    return float(np.linalg.eigvalsh(hermitian(a))[0])


def verify_distance(effects, target, arrays, prefix, reported):
    d = len(effects[0])
    rho = arrays[prefix+"_repaired_rho"]
    xs = arrays[prefix+"_repaired_x"]
    ys = arrays[prefix+"_repaired_y"]
    assert np.linalg.norm(rho-rho.conj().T, 2) < 1e-10
    assert abs(np.trace(rho)-1) < 1e-10
    differences = [(e-f).T for e, f in zip(effects, target)]
    floors = [minimum(rho)]
    for a, x, y in zip(differences, xs, ys):
        for sign in (-1, 1):
            floors += [minimum(rho+sign*x), minimum(y+sign*a)]
    floors.append(minimum(reported["numerical_upper"]*np.eye(d)-sum(ys)))
    assert min(floors) >= -1e-10, floors
    primal = sum(float(np.trace(a @ x).real) for a, x in zip(differences, xs))

    values, vectors = np.linalg.eigh(hermitian(rho))
    root = (vectors*np.sqrt(np.maximum(0., values))) @ vectors.conj().T
    # A[i,a] is the amplitude of |i>_input |a>_reference.
    amplitudes = root.T
    assert abs(np.vdot(amplitudes, amplitudes)-1) < 1e-10
    distance, original_trace, target_trace = 0., 0., 0.
    physical_floors = []
    for e, f in zip(effects, target):
        original_block = np.einsum("ki,ia,kb->ab", e, amplitudes, amplitudes.conj())
        target_block = np.einsum("ki,ia,kb->ab", f, amplitudes, amplitudes.conj())
        physical_floors += [minimum(original_block), minimum(target_block)]
        original_trace += float(np.trace(original_block).real)
        target_trace += float(np.trace(target_block).real)
        distance += float(np.abs(np.linalg.eigvalsh(
            hermitian(original_block-target_block))).sum())
    assert min(physical_floors) >= -1e-10
    assert abs(original_trace-1) < 1e-10 and abs(target_trace-1) < 1e-10
    assert abs(distance-reported["reference_witness"]) < 1e-9
    assert abs(max(primal, distance)-reported["numerical_lower"]) < 1e-9
    assert distance <= reported["numerical_upper"]+1e-9
    return {
        "physical_reference_distance": distance,
        "minimum_repaired_constraint_eigenvalue": min(floors),
        "minimum_conditional_state_eigenvalue": min(physical_floors),
        "numerical_lower": max(primal, distance),
        "numerical_upper": reported["numerical_upper"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path,
                        default=ROOT/"research/paired_search_2026-11-01")
    args = parser.parse_args()
    directory = args.directory.resolve()
    summary_path = directory/"summary.json"
    summary = json.loads(summary_path.read_text(encoding="utf-8"))
    for relative, expected in summary["source_sha256"].items():
        actual = hashlib.sha256((ROOT/relative).read_text(
            encoding="utf-8").encode("utf-8")).hexdigest()
        assert actual == expected, relative
    assert digest(directory/"search_trace.csv") == summary["trace_sha256"]
    for name, expected in summary["artifacts_sha256"].items():
        assert digest(directory/name) == expected, name
    results = []
    lookup = {r["id"]: r for r in summary["finalists"]}
    for case in summary["finalists"]:
        with np.load(directory/case["artifact"], allow_pickle=False) as saved:
            for field, prefix in (("unweighted", "u"), ("weighted", "w")):
                check = verify_distance(
                    saved["effects"], saved[field], saved, prefix, case[field])
                results.append({"id": case["id"], "construction": field,
                                "stage": "main", **check})
    for cross in summary["cross_solver_rechecks"]:
        if cross.get("result") != "PASS":
            continue
        case = lookup[cross["id"]]
        with np.load(directory/case["artifact"], allow_pickle=False) as saved:
            with np.load(directory/f"cross_{case['id']:05d}.npz", allow_pickle=False) as cert:
                for field, prefix in (("unweighted", "u"), ("weighted", "w")):
                    check = verify_distance(
                        saved["effects"], saved[field], cert, prefix, cross[field])
                    results.append({"id": case["id"], "construction": field,
                                    "stage": "alternate_solver", **check})
    flips = [r["id"] for r in summary["finalists"]
             if abs(r["w_system"]-r["u_system"]) > 1e-6
             and abs(r["weighted"]["primal"]-r["unweighted"]["primal"]) > 1e-6
             and (r["w_system"]-r["u_system"])*(
                 r["weighted"]["primal"]-r["unweighted"]["primal"]) < 0]
    report = {
        "result": "PASS", "scope": "Floating-point artifact, constraint, and physical witness checks.",
        "summary_text_sha256": hashlib.sha256(summary_path.read_text(
            encoding="utf-8").encode("utf-8")).hexdigest(),
        "verifier_source_sha256": hashlib.sha256(Path(__file__).read_text(
            encoding="utf-8").encode("utf-8")).hexdigest(),
        "source_hash_kind": "SHA256 of UTF-8 text with LF-normalized line endings",
        "source_and_artifact_hashes_match": True,
        "physical_reference_witnesses_checked": len(results),
        "system_vs_reference_order_reversals": flips,
        "checks": results,
    }
    (directory/"artifact_checks.json").write_text(
        json.dumps(report, indent=2)+"\n", encoding="utf-8")
    print(f"PASS {len(results)} physical reference witnesses; "
          f"all saved constraints and hashes; {len(flips)} ordering reversals.")


if __name__ == "__main__":
    main()
