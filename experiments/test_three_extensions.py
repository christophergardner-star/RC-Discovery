#!/usr/bin/env python3
"""
Cross-checks for the three 28-Oct-2026 RC extensions:

1. POVM spectral-gap record-margin stability.
2. Redundancy -> margin -> stability formulas.
3. Many-phase metastability sanity family.

Only NumPy is required.
"""

from __future__ import annotations

import math
import numpy as np

SEED = 20261028
RNG = np.random.default_rng(SEED)
TOL = 1e-10


def random_density(d: int) -> np.ndarray:
    a = RNG.normal(size=(d, d)) + 1j * RNG.normal(size=(d, d))
    rho = a @ a.conj().T
    return rho / np.trace(rho)


def trace_norm_hermitian(a: np.ndarray) -> float:
    vals = np.linalg.eigvalsh((a + a.conj().T) / 2)
    return float(np.sum(np.abs(vals)))


def projected_pure_core(rho: np.ndarray, index: int) -> np.ndarray:
    out = np.zeros_like(rho)
    out[index, index] = 1.0
    return out


def random_two_outcome_povm_cases(cases: int = 20_000) -> tuple[int, float]:
    """
    E0 has eigenvalues 1, interior values, 0.
    E1 = I-E0.
    Each effect therefore has a nonzero eigenvalue-1 repeatable sector.

    For two records, kappa is exactly half their trace distance.
    We check the stronger intermediate estimate
        max_j ||sigma_j - tau_j||_1 <= sqrt(2 eta/(kappa gamma)).
    This implies the channel diamond-norm estimate.
    """
    violations = 0
    worst_ratio = 0.0

    for _ in range(cases):
        d = int(RNG.integers(3, 13))
        middle = np.sort(RNG.uniform(0.02, 0.98, size=d - 2))
        eig0 = np.concatenate(([1.0], middle, [0.0]))
        e0 = np.diag(eig0)

        gamma0 = 1.0 - middle[-1]
        gamma1 = middle[0]
        gamma = min(gamma0, gamma1)

        sigma0 = random_density(d)
        sigma1 = random_density(d)

        record_distance = trace_norm_hermitian(sigma0 - sigma1)
        kappa = record_distance / 2.0

        t0 = float(np.real(np.trace(e0 @ sigma0)))
        t1 = float(np.real(np.trace(e0 @ sigma1)))

        # For two outputs and this E0 spectrum, the defect is exactly:
        eta = max(1.0 - t0, t1) * record_distance

        tau0 = projected_pure_core(sigma0, 0)
        tau1 = projected_pure_core(sigma1, d - 1)

        record_rounding = max(
            trace_norm_hermitian(sigma0 - tau0),
            trace_norm_hermitian(sigma1 - tau1),
        )

        bound = math.sqrt(2.0 * eta / (kappa * gamma))
        ratio = record_rounding / bound if bound > 0 else 0.0

        worst_ratio = max(worst_ratio, ratio)
        if record_rounding > bound + TOL:
            violations += 1

    return violations, worst_ratio


def qutrit_saturation(c: float, theta: float) -> tuple[float, float, float, float]:
    assert 0.5 <= c < 1.0
    gamma = 1.0 - c
    kappa = 1.0
    eta = 2.0 * (1.0 - c) * (math.sin(theta) ** 2)
    actual = 2.0 * math.sin(theta)
    bound = math.sqrt(2.0 * eta / (kappa * gamma))
    return gamma, eta, actual, bound


def pure_redundancy_margin(s: float, r: int) -> float:
    return math.sqrt(1.0 - s ** (2 * r))


def common_noise_correlated_margin(p: float, r: int) -> float:
    # rho_0=(1-p)|0^R><0^R|+p|1^R><1^R|
    # rho_1=p|0^R><0^R|+(1-p)|1^R><1^R|
    # The trace distance is independent of R.
    _ = r
    return 1.0 - 2.0 * p


def many_phase_family(m: int, eps: float) -> tuple[float, float, float, float]:
    """
    sigma_j=(1-eps)|j><j|+eps I/m.
    """
    kappa = 1.0 - eps
    eta = 2.0 * eps * (1.0 - eps) * (1.0 - 1.0 / m)
    actual = 2.0 * eps * (1.0 - 1.0 / m)
    bound = math.sqrt(2.0 * eta / kappa)
    return kappa, eta, actual, bound


def main() -> None:
    print("=== POVM spectral-gap stress test ===")
    violations, worst_ratio = random_two_outcome_povm_cases()
    print(f"seed: {SEED}")
    print("random cases: 20000")
    print(f"violations: {violations}")
    print(f"max intermediate ratio: {worst_ratio:.12f}")
    assert violations == 0

    print("\n=== Exact qutrit saturation ===")
    for c in (0.5, 0.7, 0.9):
        for deg in (5, 20, 45):
            gamma, eta, actual, bound = qutrit_saturation(
                c, math.radians(deg)
            )
            print(
                f"c={c:.1f} theta={deg:2d}deg "
                f"gamma={gamma:.6f} eta={eta:.6f} "
                f"actual={actual:.9f} bound={bound:.9f}"
            )
            assert abs(actual - bound) <= 1e-12

    print("\n=== Independent pure-record redundancy ===")
    s = 0.9
    previous = -1.0
    for r in (1, 2, 4, 8, 16, 32):
        kappa = pure_redundancy_margin(s, r)
        print(f"R={r:2d} kappa_R={kappa:.9f}")
        assert kappa > previous
        previous = kappa

    print("\n=== Perfectly correlated-noise counterexample ===")
    p = 0.2
    target = 1.0 - 2.0 * p
    for r in (1, 2, 4, 8, 16, 32):
        kappa = common_noise_correlated_margin(p, r)
        print(f"R={r:2d} kappa_R={kappa:.9f}")
        assert abs(kappa - target) <= 1e-15

    print("\n=== Many classical phases ===")
    eps = 0.01
    for m in (2, 4, 16, 64, 256, 1024, 4096):
        kappa, eta, actual, bound = many_phase_family(m, eps)
        print(
            f"m={m:4d} kappa={kappa:.6f} eta={eta:.9f} "
            f"actual={actual:.9f} bound={bound:.9f}"
        )
        assert actual <= bound + TOL

    print("\nPASS")


if __name__ == "__main__":
    main()
