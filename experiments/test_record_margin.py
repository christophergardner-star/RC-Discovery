#!/usr/bin/env python3
"""
Reproducible stress tests for the RC Record-Margin Stability Theorem.

The random test covers the two-record case, where
    kappa = 1/2 ||sigma_0 - sigma_1||_1
is exact and no convex optimisation dependency is required.

The script also checks the analytic qubit family that saturates the theorem.
These tests support the proof but do not replace it.
"""

from __future__ import annotations

import math
import numpy as np

SEED = 20261028
RNG = np.random.default_rng(SEED)
DIMS = (2, 3, 5, 10, 20)
CASES = 10_000
TOL = 1e-10


def random_density(d: int) -> np.ndarray:
    """Full-rank random density matrix."""
    a = RNG.normal(size=(d, d)) + 1j * RNG.normal(size=(d, d))
    rho = a @ a.conj().T
    return rho / np.trace(rho)


def trace_norm_hermitian(a: np.ndarray) -> float:
    vals = np.linalg.eigvalsh((a + a.conj().T) / 2)
    return float(np.sum(np.abs(vals)))


def projected_state(rho: np.ndarray, indices: np.ndarray) -> tuple[float, np.ndarray]:
    weight = float(np.real(np.trace(rho[np.ix_(indices, indices)])))
    tau = np.zeros_like(rho)
    if weight > 1e-15:
        tau[np.ix_(indices, indices)] = rho[np.ix_(indices, indices)] / weight
    else:
        tau[indices[0], indices[0]] = 1.0
    return weight, tau


def random_two_record_case(d: int) -> tuple[float, float]:
    split = int(RNG.integers(1, d))
    sectors = (np.arange(split), np.arange(split, d))

    sigma = (random_density(d), random_density(d))
    record_distance = trace_norm_hermitian(sigma[0] - sigma[1])
    kappa = record_distance / 2.0

    weights = []
    tau = []
    for j in range(2):
        weight, rounded = projected_state(sigma[j], sectors[j])
        weights.append(weight)
        tau.append(rounded)

    # For two records:
    # Phi(sigma_j)-sigma_j = (1-a_j)(sigma_{1-j}-sigma_j).
    eta = max((1.0 - weights[j]) * record_distance for j in range(2))

    actual = max(
        trace_norm_hermitian(sigma[j] - tau[j])
        for j in range(2)
    )

    bound = math.sqrt(2.0 * eta / kappa)
    return actual, bound


def sharp_qubit(theta: float) -> tuple[float, float, float, float]:
    kappa = math.cos(theta)
    eta = 2.0 * (math.sin(theta) ** 2) * math.cos(theta)
    actual = 2.0 * math.sin(theta)
    bound = math.sqrt(2.0 * eta / kappa)
    return kappa, eta, actual, bound


def main() -> None:
    violations = 0
    ratios = []

    for i in range(CASES):
        d = DIMS[i % len(DIMS)]
        actual, bound = random_two_record_case(d)
        if actual > bound + TOL:
            violations += 1
        ratios.append(actual / bound if bound > 0 else 0.0)

    print("RC Record-Margin Stability stress test")
    print(f"seed: {SEED}")
    print(f"random full-rank two-record cases: {CASES}")
    print(f"dimensions: {DIMS}")
    print(f"violations: {violations}")
    print(f"max(actual / bound): {max(ratios):.12f}")

    assert violations == 0

    print("\\nAnalytic sharpness family")
    for deg in (5, 10, 30, 45):
        theta = math.radians(deg)
        kappa, eta, actual, bound = sharp_qubit(theta)
        print(
            f"{deg:2d} deg  "
            f"kappa={kappa:.8f}  eta={eta:.8f}  "
            f"actual={actual:.8f}  bound={bound:.8f}"
        )
        assert abs(actual - bound) <= 1e-12

    print("\\nPASS")


if __name__ == "__main__":
    main()
