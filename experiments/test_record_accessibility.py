"""Sharp record-accessibility lemma and repaired certificate: numerical audit.

Analytic arguments are in research/CERTIFICATE_PROGRESS_2026-10-31.md.
SDPs include ancillas and independently check primal/dual feasibility.
This finite floating-point audit is not a proof or interval certificate.
"""
from __future__ import annotations
import json
import math
from pathlib import Path
import numpy as np
import cvxpy as cp

OUT = Path(__file__).resolve().parents[1] / "research/local_validation"
RNG = np.random.default_rng(2026103119)
TOL = 3e-6


def herm(x):
    return (x+x.conj().T)/2


def trace_norm(x):
    return float(np.abs(np.linalg.eigvalsh(herm(x))).sum())


def apply(effects, records, rho):
    return herm(sum(np.trace(e@rho).real*s for e, s in zip(effects, records)))


def choi(effects, outputs):
    return herm(sum(np.kron(v, e.T) for e, v in zip(effects, outputs)))


def diamond(j, d):
    rho = cp.Variable((d, d), hermitian=True)
    x = cp.Variable((d*d, d*d), hermitian=True)
    lifted = cp.kron(np.eye(d), rho)
    primal = cp.Problem(cp.Maximize(cp.real(cp.trace(j@x))),
                        [rho >> 0, cp.trace(rho) == 1,
                         lifted-x >> 0, lifted+x >> 0])
    y = cp.Variable((d*d, d*d), hermitian=True)
    tau = cp.Variable()
    ptr = sum(y[a*d:(a+1)*d, a*d:(a+1)*d] for a in range(d))
    dual = cp.Problem(cp.Minimize(tau),
                      [y-j >> 0, y+j >> 0, tau*np.eye(d)-ptr >> 0])
    opts = dict(solver="CLARABEL", canon_backend=cp.SCIPY_CANON_BACKEND,
                tol_gap_abs=1e-9, tol_feas=1e-9, tol_gap_rel=1e-9,
                max_iter=300)
    p, q = primal.solve(**opts), dual.solve(**opts)
    if primal.status != cp.OPTIMAL or dual.status != cp.OPTIMAL:
        opts = dict(solver="SCS", canon_backend=cp.SCIPY_CANON_BACKEND,
                    eps=1e-8, max_iters=100000)
        p, q = primal.solve(**opts), dual.solve(**opts)
    assert primal.status == cp.OPTIMAL and dual.status == cp.OPTIMAL
    rv = rho.value
    lv = np.kron(np.eye(d), rv)
    pv = sum(y.value[a*d:(a+1)*d, a*d:(a+1)*d] for a in range(d))
    matrices = [rv, lv-x.value, lv+x.value, y.value-j, y.value+j,
                q*np.eye(d)-pv]
    violation = max(0., abs(float(np.trace(rv).real)-1),
                    *[-float(np.linalg.eigvalsh(herm(a)).min()) for a in matrices])
    assert abs(p-q) < TOL and violation < TOL, (p, q, violation)
    return {"primal": float(p), "dual": float(q), "gap": float(abs(p-q)),
            "feasibility_violation": violation, "solver": opts["solver"]}


def random_povm(d):
    mats = [RNG.normal(size=(d, d))+1j*RNG.normal(size=(d, d)) for _ in range(d)]
    raw = [a@a.conj().T for a in mats]
    vals, vecs = np.linalg.eigh(sum(raw))
    inv = (vecs/np.sqrt(vals))@vecs.conj().T
    return [herm(inv@e@inv) for e in raw]


def random_case(d, noise):
    base = [np.diag(np.eye(d)[j]).astype(complex) for j in range(d)]
    effects = [(1-noise)*p+noise*g for p, g in zip(base, random_povm(d))]
    delta = math.sqrt(noise)
    bases, projectors = [], []
    for e in effects:
        vals, vecs = np.linalg.eigh(e)
        b = vecs[:, vals >= 1-delta]
        assert b.shape[1] == 1
        bases.append(b)
        projectors.append(b@b.conj().T)
    t = np.concatenate(bases, axis=1)
    left, sv, right = np.linalg.svd(t)
    u = left@right
    rounded = [np.outer(u[:, j], u[:, j].conj()) for j in range(d)]
    records = []
    for j in range(d):
        z = RNG.normal(size=d)+1j*RNG.normal(size=d)
        z /= np.linalg.norm(z)
        psi = u[:, j] + .3*math.sqrt(noise)*z
        psi /= np.linalg.norm(psi)
        records.append(np.outer(psi, psi.conj()))
    # A certified lower bound on kappa from the Q_j binary test.
    kappa = min(float(np.trace(q@s).real) - max(float(np.trace(q@v).real)
                for i, v in enumerate(records) if i != j)
                for j, (q, s) in enumerate(zip(rounded, records)))
    assert kappa > 0
    e = max(1-float(np.linalg.eigvalsh(v).max()) for v in effects)
    v = [apply(effects, records, s)-s for s in records]
    drec = max(trace_norm(a) for a in v)
    eta_sdp = diamond(choi(effects, v), d)
    eta = eta_sdp["primal"]
    assert (1-2*e)*drec <= eta+TOL and eta <= drec+TOL
    alpha = min(1., float(sv[-1]))
    packing = math.sqrt(max(0., 1-alpha**2))
    # Use the feasible numerical dual as eta upper estimate, plus residual slack.
    # The result remains floating point; it is not an interval-certified bound.
    eta_upper = eta_sdp["dual"]+TOL
    q_bound = eta_upper/(2*kappa*delta*(1-2*e))
    taus = []
    for p, q, s in zip(projectors, rounded, records):
        wp = float(np.trace(p@s).real)
        wq = float(np.trace(q@s).real)
        assert 1-wp <= q_bound+TOL
        assert math.sqrt(max(0., 1-wq)) <= math.sqrt(q_bound)+packing+TOL
        tau = herm(q@s@q/wq)
        assert trace_norm(s-tau) <= 2*(math.sqrt(q_bound)+packing)+TOL
        taus.append(tau)
    idempotence = max(trace_norm(apply(rounded, taus, tau)-tau) for tau in taus)
    assert idempotence < 1e-10
    distance_sdp = diamond(choi(effects, records)-choi(rounded, taus), d)
    coarse_b = 4*(packing+math.sqrt(delta))
    certificate = min(2., coarse_b+2*packing+math.sqrt(
        2*eta_upper/(kappa*delta*(1-2*delta))))
    assert distance_sdp["primal"] <= certificate+TOL
    certificate_two = min(2., 4*packing+2*math.sqrt(delta)+math.sqrt(
        2*eta_upper/(kappa*delta*(1-2*delta))))
    assert distance_sdp["primal"] <= certificate_two+TOL
    return {"d": d, "noise": noise, "delta": delta, "alpha": alpha,
            "kappa_lower": kappa, "accessibility_error": e, "D_rec": drec,
            "eta_sdp": eta_sdp, "distance_sdp": distance_sdp,
            "certificate": certificate, "certificate_constant_two": certificate_two,
            "idempotence_error": idempotence}


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    exact = []
    for epsilon in (1e-8, 1e-6, 1e-4, 1e-3, .01, .1, .49):
        transition = np.array([[1-epsilon, epsilon], [epsilon, 1-epsilon]])
        eta = float(np.linalg.norm(transition@transition-transition, 1))
        drec = float(np.linalg.norm(transition-np.eye(2), 1))
        assert abs(eta-(1-2*epsilon)*drec) < 1e-14
        row = {"epsilon": epsilon, "eta": eta, "D_rec": drec}
        if epsilon < .25:
            delta = math.sqrt(epsilon)
            b = 4*math.sqrt(delta)
            repaired = b+math.sqrt(2*eta/(delta*(1-2*delta)))
            prior = b+math.sqrt(2*(eta+3*b)/delta)
            repaired_two = 2*math.sqrt(delta)+math.sqrt(2*eta/(delta*(1-2*delta)))
            row.update(delta=delta, repaired=repaired, repaired_constant_two=repaired_two,
                       prior=prior,
                       exact_distance=2*epsilon)
            assert 2*epsilon <= repaired
            if epsilon <= 1e-4:
                assert repaired < 2 < prior
        exact.append(row)
    # Endpoint shows why accessibility must be strict.
    a = np.ones((2, 2))/2
    assert np.linalg.norm(a@a-a, 1) == 0 and np.linalg.norm(a-np.eye(2), 1) == 1
    # Quantum SDP normalization checks on zero and complete discrimination.
    for outputs, expected in (([np.zeros((2, 2))]*2, 0.),
                              ([np.diag([1., -1.])]*2, 2.)):
        j = choi([np.diag([1., 0.]), np.diag([0., 1.])], outputs)
        assert abs(diamond(j, 2)["primal"]-expected) < TOL
    rows = []
    for d in (2, 3):
        for noise in (1e-6, 1e-4, .01):
            for trial in range(2):
                row = random_case(d, noise)
                rows.append(row)
                print("PASS", d, noise, trial, "certificate", row["certificate"], flush=True)
    result = {"seed": 2026103119, "tolerance": TOL,
              "exact_binary_cases": exact, "random_quantum_cases": rows,
              "sdp_count": 2+2*len(rows),
              "nontrivial_random_certificates": sum(r["certificate"] < 2 for r in rows),
              "nontrivial_constant_two_certificates":
                  sum(r["certificate_constant_two"] < 2 for r in rows)}
    (OUT/"record_accessibility.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("PASS", len(exact), "exact cases;", len(rows), "random cases;",
          result["sdp_count"], "primal/dual SDPs", flush=True)


if __name__ == "__main__":
    main()
