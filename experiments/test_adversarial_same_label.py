"""Adversarial finite-dimensional audit; floating-point evidence, not a proof.

Uses SVD (not an inverse Gram matrix) for ill-conditioned synthesis maps.
Optional primal AND dual SDPs compute full, ancilla-assisted measurement
channel diamond distance. No tensor-product input restriction is imposed.
"""
from __future__ import annotations

import json
import math
from pathlib import Path
import numpy as np
from test_spectral_threshold_rate import family as threshold_family

RNG = np.random.default_rng(2026103107)
OUT = Path(__file__).resolve().parents[1] / "research/local_validation"
TOL = 5e-7


def herm(a):
    return (a + a.conj().T) / 2


def op(a):
    return float(np.linalg.norm(a, 2))


def root(a):
    vals, vecs = np.linalg.eigh(herm(a))
    return (vecs * np.sqrt(np.maximum(vals, 0))) @ vecs.conj().T


def random_povm(d, m):
    xs = [RNG.normal(size=(d, d)) + 1j * RNG.normal(size=(d, d))
          for _ in range(m)]
    raw = [x @ x.conj().T for x in xs]
    vals, vecs = np.linalg.eigh(sum(raw))
    inv = (vecs / np.sqrt(vals)) @ vecs.conj().T
    return [herm(inv @ e @ inv) for e in raw]


def mixed(ranks, residual, noise):
    d, m = sum(ranks) + residual, len(ranks)
    base = [np.zeros((d, d), complex) for _ in ranks]
    start = 0
    residual_effects = random_povm(residual, m) if residual else None
    for j, rank in enumerate(ranks):
        base[j][start:start+rank, start:start+rank] = np.eye(rank)
        start += rank
        if residual:
            base[j][-residual:, -residual:] = residual_effects[j]
    other = random_povm(d, m)
    effects = [(1-noise)*e + noise*f for e, f in zip(base, other)]
    # Complex rotations test basis covariance, including degenerate sectors.
    z = RNG.normal(size=(d, d)) + 1j*RNG.normal(size=(d, d))
    q, _ = np.linalg.qr(z)
    return [herm(q @ e @ q.conj().T) for e in effects]


def lifted_simplex(m, alpha, rank=1):
    """Exact spectral-sector family with prescribed alpha; delta decreases as 1/m."""
    s = alpha**2 / m
    lam = 1 - 2/m
    mu = (1/m - lam*s)/(1-s)
    b = ((m-1)/m - lam*(1-s) - mu*s)/(m-2)
    u = np.ones(m)/math.sqrt(m)
    effects = []
    for j in range(m):
        w = (np.eye(m)[:, j] - u/math.sqrt(m))/math.sqrt(1-1/m)
        v = math.sqrt(s)*u + math.sqrt(1-s)*w
        z = math.sqrt(1-s)*u - math.sqrt(s)*w
        e = lam*np.outer(v, v) + mu*np.outer(z, z)
        e += b*(np.eye(m)-np.outer(u, u)-np.outer(w, w))
        effects.append(np.kron(e, np.eye(rank)))
    return effects, 2.2/m


def rounded(effects, delta):
    d = len(effects[0])
    assert op(sum(effects)-np.eye(d)) < TOL
    bases, roots, margins = [], [], []
    for e in effects:
        vals, vecs = np.linalg.eigh(herm(e))
        assert vals.min() >= -TOL and vals.max() <= 1+TOL
        # No artificial tolerance enlarging the spectral interval.
        basis = vecs[:, vals >= 1-delta]
        if basis.shape[1] == 0:
            raise ValueError("nonzero label without a near-unit sector")
        bases.append(basis)
        roots.append(root(e))
        margins.append(float(np.min(abs(vals-(1-delta)))))
    t = np.concatenate(bases, axis=1)
    if t.shape[1] > d:
        raise ValueError("synthesis map cannot be injective: total rank > d")
    left, sv, right = np.linalg.svd(t, full_matrices=False)
    if sv[-1] < 1e-10:
        raise ValueError("numerically singular synthesis map")
    u = left @ right
    h = (right.conj().T * sv) @ right
    r = herm(np.eye(d)-u @ u.conj().T)
    k = t.shape[1]
    jmap = np.zeros((len(effects)*d, k), complex)
    dblock = np.zeros((k, k), complex)
    fs, offset = [], 0
    for label, basis in enumerate(bases):
        rank = basis.shape[1]
        jmap[label*d:(label+1)*d, offset:offset+rank] = basis
        dblock[offset:offset+rank, offset:offset+rank] = (
            basis.conj().T @ roots[label] @ basis)
        uj = u[:, offset:offset+rank]
        fs.append(herm(uj @ uj.conj().T + r @ effects[label] @ r))
        offset += rank
    w = np.vstack(roots)
    v = jmap @ u.conj().T + w @ r
    eps = op(w @ u-jmap)
    implementation = max(op(v[j*d:(j+1)*d].conj().T @
                            v[j*d:(j+1)*d]-f) for j, f in enumerate(fs))
    errors = {
        "J_star_WR": op(jmap.conj().T @ w @ r),
        "overlap": op(jmap.conj().T @ w @ u-dblock @ h),
        "isometry": op(v.conj().T @ v-np.eye(d)),
        "implementation": implementation,
        "movement_identity": abs(op(v-w)-eps),
        "epsilon_square_identity": abs(eps**2-op(2*np.eye(k)-h @ dblock-dblock @ h)),
        "normalization": op(sum(fs)-np.eye(d)),
    }
    assert max(errors.values()) < TOL, errors
    residual_radius = max(op(r @ e @ r) for e in effects)
    assert residual_radius <= 1-delta+TOL
    alpha = float(sv[-1])
    bound = 4*(math.sqrt(max(0, 1-alpha**2))+math.sqrt(delta))
    assert 2*eps <= bound+TOL
    # Ancilla-assisted witnesses: rho is the reduced state of a purification.
    differences = [herm((e-f).T) for e, f in zip(effects, fs)]
    witness = 0.
    for mode in range(6):
        rank = 1 if mode < 2 else d
        x = RNG.normal(size=(d, rank))+1j*RNG.normal(size=(d, rank))
        rho = x @ x.conj().T
        rho /= np.trace(rho)
        sr = root(rho)
        value = sum(float(np.abs(np.linalg.eigvalsh(herm(sr @ e @ sr))).sum())
                    for e in differences)
        witness = max(witness, value)
    assert witness <= min(2., 2*eps, bound)+TOL
    return {"d": d, "m": len(effects), "ranks": [b.shape[1] for b in bases],
            "delta": delta, "alpha": alpha, "epsilon": eps, "bound": bound,
            "residual_gap": 1-residual_radius, "errors": errors,
            "threshold_margin": min(margins), "ancilla_witness": witness}, differences


def diamond_sdp(differences, cp):
    """Primal: max sum tr(Dj Xj), -rho <= Xj <= rho, tr rho=1.
    Dual: min t, Yj >= +/-Dj, sum Yj <= t I.
    Dj = (Ej-Fj)^T are the classical-output Choi blocks.
    """
    d = len(differences[0])
    rho = cp.Variable((d, d), hermitian=True)
    xs = [cp.Variable((d, d), hermitian=True) for _ in differences]
    constraints = [rho >> 0, cp.trace(rho) == 1]
    for x in xs:
        constraints += [rho-x >> 0, rho+x >> 0]
    primal = cp.Problem(cp.Maximize(sum(cp.real(cp.trace(e @ x))
                                       for e, x in zip(differences, xs))), constraints)
    ys = [cp.Variable((d, d), hermitian=True) for _ in differences]
    tau = cp.Variable()
    dual_constraints = [tau*np.eye(d)-sum(ys) >> 0]
    for y, e in zip(ys, differences):
        dual_constraints += [y-e >> 0, y+e >> 0]
    dual = cp.Problem(cp.Minimize(tau), dual_constraints)
    opts = dict(solver="CLARABEL", canon_backend=cp.SCIPY_CANON_BACKEND,
                tol_gap_abs=1e-9, tol_feas=1e-9,
                tol_gap_rel=1e-9, max_iter=300)
    p, q = primal.solve(**opts), dual.solve(**opts)
    if primal.status != cp.OPTIMAL or dual.status != cp.OPTIMAL:
        opts = dict(solver="SCS", canon_backend=cp.SCIPY_CANON_BACKEND,
                    eps=1e-8, max_iters=100000)
        p, q = primal.solve(**opts), dual.solve(**opts)
    assert primal.status == cp.OPTIMAL and dual.status == cp.OPTIMAL
    feasibility = max(0., -float(np.linalg.eigvalsh(herm(rho.value)).min()),
                      abs(float(np.trace(rho.value).real)-1))
    for x in xs:
        for sign in [-1, 1]:
            feasibility = max(feasibility, -float(np.linalg.eigvalsh(
                herm(rho.value+sign*x.value)).min()))
    for y, e in zip(ys, differences):
        for sign in [-1, 1]:
            feasibility = max(feasibility, -float(np.linalg.eigvalsh(
                herm(y.value+sign*e)).min()))
    feasibility = max(feasibility, -float(np.linalg.eigvalsh(
        herm(q*np.eye(d)-sum(y.value for y in ys))).min()))
    assert abs(p-q) < 2e-6 and feasibility < 2e-6
    return {"solver": opts["solver"], "primal": p, "dual": q, "gap": abs(p-q),
            "feasibility_violation": feasibility}


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    cases, sdp_candidates = [], []
    for ranks in ([1, 1], [1, 1, 1], [2, 2], [1, 5, 2], [3, 3, 3],
                  [1]*16, [1]*32):
        for residual in (0, 2, 5):
            for noise in (1e-8, 1e-5, .001, .02, .15, .4):
                for trial in range(3):
                    # Threshold strictly below the guaranteed sector eigenvalue.
                    delta = min(.49, 1.1*noise)
                    row, diff = rounded(mixed(ranks, residual, noise), delta)
                    row["family"] = "random_mixture"
                    cases.append(row)
                    if row["d"] <= 6 and residual == 2 and trial == 0 and noise in (.001, .15):
                        sdp_candidates.append((len(cases)-1, diff))
        print("random ranks", ranks, "checked", len(cases), flush=True)
    for m in (8, 16, 32, 64):
        for alpha in (1e-7, 1e-4, .01, .2, .8):
            effects, delta = lifted_simplex(m, alpha)
            row, diff = rounded(effects, delta)
            row["family"] = "lifted_simplex"
            row["requested_alpha"] = alpha
            assert abs(row["alpha"]-alpha) < 2e-7
            cases.append(row)
            if m == 8 and alpha in (.01, .2):
                sdp_candidates.append((len(cases)-1, diff))
    for alpha in (1e-5, .3):
        effects, delta = lifted_simplex(8, alpha, rank=3)
        row, _ = rounded(effects, delta)
        row["family"] = "degenerate_lifted_simplex"
        cases.append(row)
    for delta in (1e-2, 1e-4, 1e-6, 1e-8):
        effects, _ = threshold_family(delta)
        # Avoid a floating-point threshold ambiguity in this analytic family.
        row, diff = rounded(effects, delta*(1+1e-6))
        row["family"] = "sqrt_delta"
        cases.append(row)
        sdp_candidates.append((len(cases)-1, diff))
    for delta in (.01, .2, .49):
        residual = 1-delta-1e-8
        effects = [np.diag([1, 0, residual]), np.diag([0, 1, 1-residual])]
        row, _ = rounded(effects, delta)
        row["family"] = "extreme_residual"
        cases.append(row)
    # Endpoint inclusion and just-below exclusion are deliberately unrotated.
    delta = .1
    effects = [np.diag([1-delta, 0., .5]), np.diag([delta, 1., .5])]
    row, _ = rounded(effects, delta)
    row["family"] = "threshold_endpoint"
    cases.append(row)
    rejected = []
    bad = [
        ("missing_sector", [np.eye(2)/2, np.eye(2)/2], .1),
        ("just_below_threshold",
         [np.diag([np.nextafter(.9, 0), 0., .5]),
          np.diag([1-np.nextafter(.9, 0), 1., .5])], .1),
    ]
    # Trine POVM has three near-unit sectors (threshold .6) in dimension two.
    vectors = [np.array([math.cos(a), math.sin(a)]) for a in (0, 2*math.pi/3, 4*math.pi/3)]
    bad.append(("singular_synthesis", [2/3*np.outer(v, v) for v in vectors], .4))
    for name, effects, delta in bad:
        try:
            rounded(effects, delta)
        except ValueError as exc:
            rejected.append({"name": name, "reason": str(exc)})
        else:
            raise AssertionError("invalid hypothesis accepted: "+name)
    result = {"seed": 2026103107, "tolerance": TOL, "cases": cases,
              "expected_rejections": rejected, "sdp": []}
    try:
        import cvxpy as cp
    except (ImportError, OSError) as exc:
        result["sdp_unavailable"] = str(exc)
    else:
        # Independent normalizations: zero distance and perfectly distinct labels.
        anchors = ([np.zeros((2, 2)), np.zeros((2, 2))],
                   [np.eye(2), -np.eye(2)])
        for differences, expected in zip(anchors, (0., 2.)):
            solved = diamond_sdp(differences, cp)
            assert abs(solved["primal"]-expected) < 2e-6
        for index, differences in sdp_candidates:
            solved = diamond_sdp(differences, cp)
            row = cases[index]
            assert solved["primal"] <= min(2., 2*row["epsilon"], row["bound"])+2e-6
            assert row["ancilla_witness"] <= solved["dual"]+2e-6
            result["sdp"].append({"case": index, **solved})
            print("SDP", index, solved, flush=True)
    result["max_identity_error"] = max(max(r["errors"].values()) for r in cases)
    result["minimum_alpha"] = min(r["alpha"] for r in cases)
    result["max_dimension"] = max(r["d"] for r in cases)
    (OUT / "adversarial.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("PASS", len(cases), "valid cases;", len(rejected), "expected rejections;",
          len(result["sdp"]), "SDPs; max identity error", result["max_identity_error"])


if __name__ == "__main__":
    main()
