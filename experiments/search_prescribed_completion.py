"""Adaptive paired search for prescribed and weighted POVM completions.

The optimizer uses system-only distances and maximally entangled witnesses
as inexpensive scores. Finalists are evaluated by full primal/dual SDPs.
All numbers and feasibility repairs are floating-point diagnostics, not
interval certificates, universal proofs, or evidence of literature priority.
"""
from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
import hashlib
from itertools import product
import json
import math
from pathlib import Path
import subprocess
import time

import numpy as np

from test_theorem_v1_contract import (
    HypothesisError, assert_contract, build_rounding, coefficient_two_bound, hermitian,
    inverse_psd_sqrt, measurement_diamond_sdp, mixed_povm, operator_norm,
    psd_sqrt, validate_povm,
)

ROOT = Path(__file__).resolve().parents[1]
GEOMETRIES = [
    ([1, 1, 1], 0), ([1, 1, 1], 1), ([2, 1, 1], 1),
    ([2, 2, 1], 1), ([1, 1, 1, 1], 1), ([2, 1, 1, 1], 1),
]
OBJECTIVES = ("ratio", "unweighted_advantage", "weighted_advantage")
THRESHOLD_BUFFER = 1e-7


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def trace_norm(a):
    return float(np.abs(np.linalg.eigvalsh(hermitian(a))).sum())


def cheap_distance(differences):
    # max_rho sum_j |tr(D_j rho)| = max_sign lambda_max(sum sign_j D_j).
    # This is an exact system-only optimization, up to numerical error.
    system = max(float(np.linalg.eigvalsh(
        sum(sign * a for sign, a in zip(signs, differences)))[-1])
        for signs in product((-1, 1), repeat=len(differences)))
    entangled = sum(trace_norm(a) for a in differences) / len(differences[0])
    return max(system, entangled), system, entangled


def weighted_completion(data):
    left, _, right = np.linalg.svd(
        data.synthesis @ data.sector_square_root, full_matrices=False)
    u = left @ right
    projections, effects = [], []
    offset = 0
    r = data.residual_projector
    for basis, e in zip(data.bases, data.effects):
        rank = basis.shape[1]
        block = u[:, offset:offset + rank]
        q = hermitian(block @ block.conj().T)
        projections.append(q)
        effects.append(hermitian(q + r @ e @ r))
        offset += rank
    return effects, projections


def normalized_effects(factors):
    m, d, _ = factors.shape
    stack = factors.reshape(m * d, d)
    inv = inverse_psd_sqrt(stack.conj().T @ stack)
    stack = stack @ inv
    normalized = stack.reshape(m, d, d)
    effects = [hermitian(a.conj().T @ a) for a in normalized]
    return normalized, effects


def choose_threshold(effects, ranks):
    spectra = [np.linalg.eigvalsh(e) for e in effects]
    delta = max(1.0 - spectrum[-rank]
                for spectrum, rank in zip(spectra, ranks)) + THRESHOLD_BUFFER
    if not 0 < delta < 0.5:
        raise HypothesisError("no admissible threshold for requested ranks")
    threshold = 1 - delta
    if any(np.count_nonzero(spectrum >= threshold) != rank
           for spectrum, rank in zip(spectra, ranks)):
        raise HypothesisError("threshold does not select the requested full sectors")
    return float(delta), min(float(np.min(np.abs(spectrum-threshold)))
                             for spectrum in spectra)


@dataclass
class Candidate:
    factors: np.ndarray
    row: dict


def evaluate(factors, ranks, identifier, geometry, parent, objective, step):
    normalized, effects = normalized_effects(factors)
    validate_povm(effects, tol=1e-10)
    delta, margin = choose_threshold(effects, ranks)
    data = build_rounding(effects, delta)
    weighted, wq = weighted_completion(data)
    unweighted = data.completed_effects
    bound = coefficient_two_bound(data)
    nu, su, eu = cheap_distance([e-f for e, f in zip(effects, unweighted)])
    nw, sw, ew = cheap_distance([e-f for e, f in zip(effects, weighted)])
    alpha = min(1.0, data.alpha)
    raw_bound = 2*(math.sqrt(max(0.0, 1-alpha**2)) + math.sqrt(delta))
    scores = {
        "ratio": nu / bound if raw_bound < 2 else -1.0,
        "unweighted_advantage": nw-nu,
        "weighted_advantage": nu-nw,
    }
    row = {
        "id": identifier, "geometry": geometry, "parent": parent,
        "objective": objective, "step": float(step), "dimension": len(effects[0]),
        "outcomes": len(effects), "alpha": data.alpha, "delta": delta,
        "threshold_margin": margin, "bound": bound, "raw_bound": raw_bound,
        "informative": raw_bound < 2, "u_proxy": nu, "w_proxy": nw,
        "u_system": su, "w_system": sw, "u_entangled": eu, "w_entangled": ew,
        "completion_difference": max(operator_norm(u-w)
                                     for u, w in zip(unweighted, weighted)),
        "u_sector_movement": max(operator_norm(p-q)
                                for p, q in zip(data.projectors, data.sector_projectors)),
        "w_sector_movement": max(operator_norm(p-q)
                                for p, q in zip(data.projectors, wq)),
        **scores,
    }
    return Candidate(normalized, row)


class DiamondSolver:
    """Parameterized measurement-channel SDP, retaining both solution matrices."""

    def __init__(self, dimension, outcomes):
        import cvxpy as cp
        self.cp, self.d = cp, dimension
        self.diff = [cp.Parameter((dimension, dimension), hermitian=True)
                     for _ in range(outcomes)]
        self.rho = cp.Variable((dimension, dimension), hermitian=True)
        self.x = [cp.Variable((dimension, dimension), hermitian=True)
                  for _ in range(outcomes)]
        self.y = [cp.Variable((dimension, dimension), hermitian=True)
                  for _ in range(outcomes)]
        self.t = cp.Variable()
        pc = [self.rho >> 0, cp.trace(self.rho) == 1]
        dc = [self.t*np.eye(dimension)-sum(self.y) >> 0]
        for a, x, y in zip(self.diff, self.x, self.y):
            pc += [self.rho-x >> 0, self.rho+x >> 0]
            dc += [y-a >> 0, y+a >> 0]
        self.primal = cp.Problem(
            cp.Maximize(sum(cp.real(cp.trace(a @ x))
                            for a, x in zip(self.diff, self.x))), pc)
        self.dual = cp.Problem(cp.Minimize(self.t), dc)

    def solve(self, original, rounded, force_solver=None):
        cp, d = self.cp, self.d
        differences = [hermitian((e-f).T) for e, f in zip(original, rounded)]
        for param, a in zip(self.diff, differences):
            param.value = a
        options = [
            # A cross-check uses a realistic interior-point tolerance; tight
            # main solves can fall back to SCS. All residuals are still checked.
            dict(solver="CLARABEL",
                 tol_gap_abs=1e-7 if force_solver == "CLARABEL" else 1e-10,
                 tol_gap_rel=1e-7 if force_solver == "CLARABEL" else 1e-10,
                 tol_feas=1e-7 if force_solver == "CLARABEL" else 1e-10,
                 max_iter=400),
            dict(solver="SCS", eps=2e-9, max_iters=200000),
        ]
        failures = []
        for option in options:
            if force_solver and option["solver"] != force_solver:
                continue
            try:
                pv = self.primal.solve(**option, warm_start=False,
                                       canon_backend=cp.SCIPY_CANON_BACKEND)
                dv = self.dual.solve(**option, warm_start=False,
                                     canon_backend=cp.SCIPY_CANON_BACKEND)
                allowed = (cp.OPTIMAL, cp.OPTIMAL_INACCURATE) if force_solver else (cp.OPTIMAL,)
                # An alternate solver's status alone is not a certificate.
                # Accept its arrays only after the same independent feasibility,
                # gap, and identity-shift repair checks used below.
                if self.primal.status not in allowed or self.dual.status not in allowed:
                    raise RuntimeError(f"statuses {self.primal.status}/{self.dual.status}")
                rho = hermitian(self.rho.value)
                xs = [hermitian(x.value) for x in self.x]
                ys = [hermitian(y.value) for y in self.y]
                floor = lambda a: float(np.linalg.eigvalsh(hermitian(a))[0])
                pviolation = max(0., -floor(rho),
                    *[-floor(rho+sign*x) for x in xs for sign in (-1, 1)])
                dviolation = max(0., -floor(dv*np.eye(d)-sum(ys)),
                    *[-floor(y+sign*a) for y, a in zip(ys, differences)
                      for sign in (-1, 1)])
                violation = max(pviolation, dviolation, abs(np.trace(rho).real-1))
                if abs(pv-dv) > 3e-6 or violation > 3e-6:
                    raise RuntimeError(f"gap/feasibility {abs(pv-dv)}/{violation}")
                # Repair feasibility by scalar identity shifts. These operations
                # use floating-point eigenvalues: they are NOT interval proofs.
                cushion = 1e-9
                eps = pviolation+cushion
                scale = float(np.trace(rho).real+d*eps)
                repaired_rho = (rho+eps*np.eye(d))/scale
                repaired_x = [x/scale for x in xs]
                repaired_y = [
                    y+(max(0., -floor(y-a), -floor(y+a))+cushion)*np.eye(d)
                    for y, a in zip(ys, differences)]
                lower = sum(float(np.trace(a @ x).real)
                            for a, x in zip(differences, repaired_x))
                upper = float(np.linalg.eigvalsh(sum(repaired_y))[-1])+cushion
                root = psd_sqrt(repaired_rho)
                witness = sum(trace_norm(root @ a @ root) for a in differences)
                lower = max(lower, witness)
                if lower > upper+1e-7:
                    raise RuntimeError("repaired primal/witness exceeds repaired dual")
                info = {
                    "solver": option["solver"], "primal": float(pv), "dual": float(dv),
                    "solver_options": option,
                    "primal_status": self.primal.status,
                    "dual_status": self.dual.status,
                    "gap": float(abs(pv-dv)), "feasibility_violation": violation,
                    "numerical_lower": lower, "numerical_upper": upper,
                    "reference_witness": witness, "repair_cushion": cushion,
                    "fallback_history": failures,
                }
                arrays = {"rho": rho, "x": np.array(xs), "y": np.array(ys),
                          "repaired_rho": repaired_rho,
                          "repaired_x": np.array(repaired_x),
                          "repaired_y": np.array(repaired_y)}
                return info, arrays
            except (cp.error.SolverError, RuntimeError) as exc:
                failures.append(f"{option['solver']}: {exc}")
        raise RuntimeError(f"SDP failed: {failures}")


def numerical_order(unweighted, weighted):
    # Require separation well above the SDP acceptance tolerance.
    if unweighted["numerical_upper"]+1e-6 < weighted["numerical_lower"]:
        return "unweighted_closer"
    if weighted["numerical_upper"]+1e-6 < unweighted["numerical_lower"]:
        return "weighted_closer"
    return "unresolved_at_margin"


def controls():
    solver = DiamondSolver(2, 2)
    p = [np.diag([1., 0.]), np.diag([0., 1.])]
    values = {}
    for name, target, expected in (("zero", p, 0.), ("two", p[::-1], 2.)):
        result, _ = solver.solve(p, target)
        assert abs(result["primal"]-expected) < 1e-7
        values[name] = result
    binary = [np.diag([.9, .1, .5]), np.diag([.1, .9, .5])]
    data = build_rounding(binary, .11)
    weighted, _ = weighted_completion(data)
    assert max(operator_norm(a-b) for a, b in
               zip(weighted, data.completed_effects)) < 1e-12
    diff = [np.array([[.1, .04j], [-.04j, -.2]])]
    diff.append(-diff[0])
    proxy, _, _ = cheap_distance(diff)
    assert abs(proxy-2*operator_norm(diff[0])) < 1e-12
    values["binary_completions_identical"] = True
    values["system_distance_binary_identity"] = True
    return values


def replay(directory):
    summary = json.loads((directory/"summary.json").read_text(encoding="utf-8"))
    rows = []
    for result in summary["finalists"]:
        path = directory/result["artifact"]
        assert sha(path) == result["artifact_sha256"]
        with np.load(path, allow_pickle=False) as saved:
            effects = list(saved["effects"])
            data = build_rounding(effects, result["delta"])
            weighted, _ = weighted_completion(data)
            assert np.max(np.abs(saved["unweighted"]-data.completed_effects)) < 1e-10
            assert np.max(np.abs(saved["weighted"]-weighted)) < 1e-10
        # Independent existing implementation, separate CVXPY problems.
        u = measurement_diamond_sdp(effects, data.completed_effects)
        w = measurement_diamond_sdp(effects, weighted)
        assert abs(u["primal"]-result["unweighted"]["primal"]) < 3e-6
        assert abs(w["primal"]-result["weighted"]["primal"]) < 3e-6
        rows.append({"id": result["id"], "unweighted": u, "weighted": w})
        print(f"Replay {result['id']}: PASS", flush=True)
    (directory/"replay.json").write_text(
        json.dumps({"scope": "Independent implementation, same floating-point inputs.",
                    "results": rows, "result": "PASS"}, indent=2)+"\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=2026110101)
    parser.add_argument("--initial", type=int, default=32)
    parser.add_argument("--iterations", type=int, default=160)
    parser.add_argument("--finalists", type=int, default=1,
                        help="Finalists per objective and geometry, plus map-difference leader.")
    parser.add_argument("--output", type=Path,
                        default=ROOT/"research/paired_search_2026-11-01")
    parser.add_argument("--replay", type=Path)
    args = parser.parse_args()
    if args.replay:
        replay(args.replay.resolve())
        return
    if min(args.initial, args.iterations, args.finalists) < 1:
        parser.error("search counts must be positive")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    if (output/"summary.json").exists():
        parser.error("output already contains a completed run; choose another directory")
    started = time.monotonic()
    rng = np.random.default_rng(args.seed)
    control_results = controls()
    trace, rejections, chosen = [], {}, {}
    identifier = 0
    for geometry, (ranks, residual) in enumerate(GEOMETRIES):
        initial = []
        d, m = sum(ranks)+residual, len(ranks)
        attempts = 0
        while len(initial) < args.initial:
            attempts += 1
            if attempts > args.initial*30:
                raise RuntimeError("unable to seed geometry")
            noise = float(np.exp(rng.uniform(math.log(.005), math.log(.65))))
            effects = mixed_povm(ranks, residual, noise, rng)
            factors = np.array([psd_sqrt(e) for e in effects])
            try:
                node = evaluate(factors, ranks, identifier, geometry, -1, "initial", noise)
            except HypothesisError as exc:
                rejections[str(exc)] = rejections.get(str(exc), 0)+1
                continue
            identifier += 1
            trace.append(node.row)
            initial.append(node)
        leaders = {metric: max(initial, key=lambda n: n.row[metric])
                   for metric in (*OBJECTIVES, "completion_difference")}
        for objective in OBJECTIVES:
            pool = sorted(initial, key=lambda n: n.row[objective], reverse=True)[:8]
            for iteration in range(args.iterations):
                # Occasionally return to a seed; otherwise mutate an elite.
                parent = (initial[rng.integers(len(initial))]
                          if rng.random() < .12 else pool[rng.integers(len(pool))])
                step = float(np.exp(rng.uniform(math.log(.001), math.log(.32))))
                perturb = (rng.normal(size=parent.factors.shape)
                           + 1j*rng.normal(size=parent.factors.shape))/math.sqrt(2*m*d)
                perturb *= np.exp(rng.uniform(-1, 1, size=(m, 1, 1)))
                try:
                    node = evaluate(parent.factors+step*perturb, ranks, identifier,
                                    geometry, parent.row["id"], objective, step)
                except HypothesisError as exc:
                    rejections[str(exc)] = rejections.get(str(exc), 0)+1
                    continue
                identifier += 1
                trace.append(node.row)
                for metric in leaders:
                    if node.row[metric] > leaders[metric].row[metric]:
                        leaders[metric] = node
                if node.row["ratio"] > 1+1e-6:
                    chosen[node.row["id"]] = node
                if node.row[objective] > pool[-1].row[objective]:
                    pool.append(node)
                    pool.sort(key=lambda n: n.row[objective], reverse=True)
                    pool = pool[:8]
            for node in pool[:args.finalists]:
                chosen[node.row["id"]] = node
            print(f"Geometry {geometry} d={d} m={m} {objective}: "
                  f"{pool[0].row[objective]:.8g}", flush=True)
        for node in leaders.values():
            chosen[node.row["id"]] = node
    with (output/"search_trace.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(trace[0]))
        writer.writeheader()
        writer.writerows(trace)
    results, solvers = [], {}
    for node in chosen.values():
        row = node.row
        _, effects = normalized_effects(node.factors)
        data = build_rounding(effects, row["delta"])
        weighted, weighted_sectors = weighted_completion(data)
        contract = assert_contract(data, tol=1e-10)
        # Recheck original and both target POVMs before expensive optimization.
        for family in (effects, data.completed_effects, weighted):
            validate_povm(family, tol=1e-10)
        weighted_repeatability_error = max(
            operator_norm(f @ q-(q if i == j else np.zeros_like(q)))
            for i, f in enumerate(weighted) for j, q in enumerate(weighted_sectors))
        assert weighted_repeatability_error < 1e-10
        key = (row["dimension"], row["outcomes"])
        if key not in solvers:
            solvers[key] = DiamondSolver(*key)
        solver = solvers[key]
        u, ua = solver.solve(effects, data.completed_effects)
        w, wa = solver.solve(effects, weighted)
        assert row["u_proxy"] <= u["numerical_upper"]+1e-7
        assert row["w_proxy"] <= w["numerical_upper"]+1e-7
        artifact = f"case_{row['id']:05d}.npz"
        np.savez_compressed(output/artifact, factors=node.factors,
                            effects=np.array(effects),
                            unweighted=np.array(data.completed_effects),
                            weighted=np.array(weighted),
                            **{f"u_{k}": v for k, v in ua.items()},
                            **{f"w_{k}": v for k, v in wa.items()})
        result = {
            **row, "ranks": GEOMETRIES[row["geometry"]][0],
            "unweighted": u, "weighted": w,
            "numerical_order": numerical_order(u, w),
            "sdp_ratio_lower": u["numerical_lower"]/row["bound"],
            "sdp_ratio_upper": u["numerical_upper"]/row["bound"],
            "candidate_violation": u["numerical_lower"] > row["bound"]+1e-6,
            "artifact": artifact, "artifact_sha256": sha(output/artifact),
            "unweighted_contract": contract,
            "weighted_repeatability_error": weighted_repeatability_error,
        }
        results.append(result)
        (output/"finalists.partial.json").write_text(
            json.dumps(results, indent=2)+"\n", encoding="utf-8")
        print(f"SDP {len(results)}/{len(chosen)} case {row['id']}: "
              f"u={u['primal']:.9f} w={w['primal']:.9f} "
              f"ratio={result['sdp_ratio_lower']:.6f} {result['numerical_order']}", flush=True)
    # Cross-solver rechecks of each observed ordering and the ratio leader.
    cross_ids = {max(results, key=lambda r: r["sdp_ratio_lower"])["id"]}
    informative = [r for r in results if r["informative"]]
    if informative:
        cross_ids.add(max(informative, key=lambda r: r["sdp_ratio_lower"])["id"])
    for ordering in ("unweighted_closer", "weighted_closer"):
        subset = [r for r in results if r["numerical_order"] == ordering]
        if subset:
            cross_ids.add(max(subset, key=lambda r: abs(
                r["unweighted"]["primal"]-r["weighted"]["primal"]))["id"])
        subset = [r for r in informative if r["numerical_order"] == ordering]
        if subset:
            cross_ids.add(max(subset, key=lambda r: abs(
                r["unweighted"]["primal"]-r["weighted"]["primal"]))["id"])
    cross = []
    for result in results:
        if result["id"] not in cross_ids:
            continue
        with np.load(output/result["artifact"], allow_pickle=False) as saved:
            solver = solvers[(result["dimension"], result["outcomes"])]
            other_u = "CLARABEL" if result["unweighted"]["solver"] == "SCS" else "SCS"
            other_w = "CLARABEL" if result["weighted"]["solver"] == "SCS" else "SCS"
            try:
                u, ua = solver.solve(list(saved["effects"]), list(saved["unweighted"]), other_u)
                w, wa = solver.solve(list(saved["effects"]), list(saved["weighted"]), other_w)
            except RuntimeError as exc:
                cross.append({"id": result["id"], "result": "UNRESOLVED", "error": str(exc)})
                print(f"Alternate-solver recheck {result['id']}: unresolved ({exc})", flush=True)
                continue
            np.savez_compressed(output/f"cross_{result['id']:05d}.npz",
                                **{f"u_{k}": v for k, v in ua.items()},
                                **{f"w_{k}": v for k, v in wa.items()})
        assert abs(u["primal"]-result["unweighted"]["primal"]) < 3e-6
        assert abs(w["primal"]-result["weighted"]["primal"]) < 3e-6
        order = numerical_order(u, w)
        assert order == result["numerical_order"]
        cross.append({"id": result["id"], "result": "PASS", "unweighted": u, "weighted": w,
                      "numerical_order": order})
        print(f"Alternate-solver recheck {result['id']} ({other_u}/{other_w}): {order}", flush=True)
    source_paths = [Path(__file__), ROOT/"experiments/test_theorem_v1_contract.py",
                    ROOT/"theory/THEOREM_V1_FREEZE.md"]
    summary = {
        "scope": "Adaptive finite floating-point search; repaired numerical brackets are not interval certificates.",
        "starting_commit": subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        "seed": args.seed, "initial_per_geometry": args.initial,
        "iterations_per_objective_geometry": args.iterations,
        "geometries": GEOMETRIES, "threshold_buffer": THRESHOLD_BUFFER,
        "threshold_rule": "Smallest threshold error selecting requested full sectors, plus buffer.",
        "valid_evaluations": len(trace), "rejections": rejections,
        "attempted_evaluations": len(trace)+sum(rejections.values()),
        "informative_evaluations": sum(r["informative"] for r in trace),
        "maximum_proxy_ratio": max(r["ratio"] for r in trace),
        "proxy_violation_candidates": [r["id"] for r in trace if r["ratio"] > 1+1e-6],
        "controls": control_results, "finalists": results, "cross_solver_rechecks": cross,
        "maximum_sdp_ratio": max(r["sdp_ratio_lower"] for r in results),
        "maximum_informative_sdp_ratio": max(
            (r["sdp_ratio_lower"] for r in informative), default=None),
        "informative_finalists": len(informative),
        "ordering_counts": {order: sum(r["numerical_order"] == order for r in results)
                            for order in ("unweighted_closer", "weighted_closer",
                                          "unresolved_at_margin")},
        "candidate_violations": [r["id"] for r in results if r["candidate_violation"]],
        "elapsed_seconds": time.monotonic()-started,
        "source_hash_kind": "SHA256 of UTF-8 text with LF-normalized line endings",
        "source_sha256": {str(p.resolve().relative_to(ROOT)).replace("\\", "/"):
                          hashlib.sha256(p.read_text(encoding="utf-8").encode("utf-8")).hexdigest()
                          for p in source_paths},
        "artifacts_sha256": {p.name: sha(p) for p in sorted(output.glob("*.npz"))},
        "trace_sha256": sha(output/"search_trace.csv"),
        "versions": {},
    }
    import importlib.metadata
    for package in ("numpy", "scipy", "cvxpy", "clarabel", "scs"):
        summary["versions"][package] = importlib.metadata.version(package)
    (output/"summary.json").write_text(json.dumps(summary, indent=2)+"\n", encoding="utf-8")
    (output/"finalists.partial.json").unlink()
    print(json.dumps({k: summary[k] for k in (
        "valid_evaluations", "ordering_counts", "maximum_sdp_ratio",
        "candidate_violations", "elapsed_seconds")}, indent=2), flush=True)


if __name__ == "__main__":
    main()
