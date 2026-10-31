"""Numerical checks of the analytic constant-two refinement (not a proof)."""
from __future__ import annotations
import json
import math
from pathlib import Path
import numpy as np
from test_adversarial_same_label import mixed, lifted_simplex, root
from test_spectral_threshold_rate import family

OUT = Path(__file__).resolve().parents[1] / "research/local_validation"
RNG = np.random.default_rng(2026103111)


def unitary(n):
    z = RNG.normal(size=(n, n)) + 1j*RNG.normal(size=(n, n))
    return np.linalg.qr(z)[0]


def anticommutator_floor(h, d):
    return float(np.linalg.eigvalsh((h@d+d@h)/2).min())


def physical_check(effects, delta):
    bases = []
    for e in effects:
        vals, vecs = np.linalg.eigh(e)
        bases.append(vecs[:, vals >= 1-delta])
    t = np.concatenate(bases, axis=1)
    left, sv, vh = np.linalg.svd(t, full_matrices=False)
    assert len(sv) == t.shape[1] and sv[-1] > 1e-9
    h = (vh.conj().T*sv)@vh
    d = np.zeros_like(h)
    offset = 0
    for e, basis in zip(effects, bases):
        k = basis.shape[1]
        d[offset:offset+k, offset:offset+k] = basis.conj().T@root(e)@basis
        offset += k
    alpha, maximum = float(sv[-1]), float(sv[0])
    floor = anticommutator_floor(h, d)
    lower = alpha*math.sqrt(1-delta)
    condition = ((maximum-alpha)*(1-math.sqrt(1-delta)) <=
                 4*alpha*math.sqrt(1-delta))
    if condition:
        assert floor >= lower-1e-11, (alpha, delta, floor, lower)
    return {"alpha": alpha, "delta": delta, "dimension": len(effects[0]),
            "outcomes": len(effects), "condition": condition,
            "actual_overlap_floor": floor, "claimed_floor": lower}


def main():
    abstract = []
    for n in (2, 3, 5, 10):
        for _ in range(1500):
            alpha = 10**RNG.uniform(-6, 0)
            delta = RNG.uniform(1e-7, .499999)
            d = math.sqrt(1-delta)
            maximum = RNG.uniform(alpha, 1/d)
            vals = RNG.uniform(alpha, maximum, n)
            vals[0], vals[-1] = alpha, maximum
            q = unitary(n)
            hmat = (q*vals)@q.conj().T
            vals = RNG.uniform(d, 1, n)
            vals[0], vals[-1] = d, 1
            q = unitary(n)
            dmat = (q*vals)@q.conj().T
            condition = (maximum-alpha)*(1-d) <= 4*alpha*d
            residual = anticommutator_floor(hmat, dmat)-alpha*d
            if condition:
                assert residual >= -1e-12
                abstract.append(residual)
    # Without the width condition a product of positive matrices can have
    # a Hermitian part below the claimed floor. Keep this negative control.
    alpha, delta = 1e-4, .49
    d = math.sqrt(1-delta)
    hmat = np.diag([1/d, alpha])
    v = np.ones(2)/math.sqrt(2)
    dmat = d*np.eye(2)+(1-d)*np.outer(v, v)
    negative = anticommutator_floor(hmat, dmat)-alpha*d
    assert negative < -.001

    physical = []
    for ranks in ([1, 1, 1], [2, 2, 2], [1, 5, 2]):
        for residual in (0, 3):
            for noise in (1e-6, .001, .02, .15, .4):
                for _ in range(4):
                    physical.append(physical_check(mixed(ranks, residual, noise),
                                                   min(.49, 1.1*noise)))
    for m in (8, 16, 32):
        for alpha in (1e-4, .01, .2, .8):
            effects, delta = lifted_simplex(m, alpha)
            physical.append(physical_check(effects, delta))
    for delta in (1e-2, 1e-4, 1e-6, 1e-8):
        effects, _ = family(delta)
        physical.append(physical_check(effects, delta*(1+1e-6)))

    previous = json.loads((OUT / "adversarial.json").read_text(encoding="utf-8"))
    ratios = []
    for row in previous["cases"]:
        a = math.sqrt(max(0., 1-row["alpha"]**2))
        b = math.sqrt(row["delta"])
        bound = 2*min(1., a+b)
        assert row["ancilla_witness"] <= bound+1e-7
    for solution in previous["sdp"]:
        row = previous["cases"][solution["case"]]
        a = math.sqrt(max(0., 1-row["alpha"]**2))
        b = math.sqrt(row["delta"])
        bound = 2*min(1., a+b)
        assert solution["primal"] <= bound+2e-6
        ratios.append(float(solution["primal"]/bound))

    result = {"seed": 2026103111, "imported_povm_seed": 2026103107,
              "abstract_generated": 6000,
              "abstract_condition_satisfied": len(abstract),
              "minimum_valid_floor_slack": min(abstract),
              "negative_control_slack": negative, "physical_cases": physical,
              "previous_ancilla_cases_checked": len(previous["cases"]),
              "previous_sdp_cases_checked": len(ratios),
              "maximum_sdp_to_bound_ratio": max(ratios)}
    (OUT / "constant_two.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("PASS", len(abstract), "conditional abstract matrix cases;",
          len(physical), "POVM cases;", len(previous["cases"]), "saved ancilla cases;",
          len(ratios), "saved SDP cases; max SDP/bound", max(ratios))


if __name__ == "__main__":
    main()
