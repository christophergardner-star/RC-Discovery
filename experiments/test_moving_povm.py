#!/usr/bin/env python3
"""
Tests for the moving-POVM boundary analysis.

Checks:
1. Regular-simplex local parameters and packing obstruction.
2. Binary moving-POVM defect-transfer inequality on random cases.

NumPy only.
"""

from __future__ import annotations

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


def regular_simplex_parameters(n: int):
    m = n + 1
    effect_norm = n / (n + 1)
    kappa = 1 - 1 / n**2
    reachability = (n - 1) / n**2
    eta_upper = 2 * (n - 1) / n**2
    return m, effect_norm, kappa, reachability, eta_upper


def binary_case(d: int):
    x = RNG.normal(size=(d, d)) + 1j * RNG.normal(size=(d, d))
    q, _ = np.linalg.qr(x)

    eig = np.sort(RNG.uniform(0.02, 0.98, size=d))
    eig[0] = RNG.uniform(0.001, 0.12)
    eig[-1] = RNG.uniform(0.88, 0.999)
    eig = np.sort(eig)

    e = q @ np.diag(eig) @ q.conj().T

    s0 = random_density(d)
    s1 = random_density(d)
    record_distance = trace_norm_hermitian(s0 - s1)
    kappa = record_distance / 2

    t0 = float(np.real(np.trace(e @ s0)))
    t1 = float(np.real(np.trace(e @ s1)))

    # Exact binary idempotence defect:
    # Phi^2-Phi = Tr(A .) (sigma0-sigma1)
    a = t1 * np.eye(d) + (t0 - t1 - 1) * e
    eta = np.linalg.norm(a, 2) * record_distance

    lam_min = eig[0]
    lam_max = eig[-1]

    r0 = kappa * (1 - lam_max)
    r1 = kappa * lam_min
    r = max(r0, r1)

    moved = eig.copy()
    moved[np.isclose(eig, lam_min, rtol=0, atol=1e-12)] = 0
    moved[np.isclose(eig, lam_max, rtol=0, atol=1e-12)] = 1

    e_tilde = q @ np.diag(moved) @ q.conj().T

    delta = np.linalg.norm(e - e_tilde, 2) * record_distance

    tt0 = float(np.real(np.trace(e_tilde @ s0)))
    tt1 = float(np.real(np.trace(e_tilde @ s1)))

    a_tilde = tt1 * np.eye(d) + (tt0 - tt1 - 1) * e_tilde
    eta_tilde = np.linalg.norm(a_tilde, 2) * record_distance

    return {
        "kappa": kappa,
        "r": r,
        "delta": delta,
        "eta": eta,
        "eta_tilde": eta_tilde,
        "transfer": eta + 3 * delta,
    }


def main():
    print("=== Regular simplex packing witness ===")
    for n in (2, 3, 5, 10, 50, 100, 1000):
        m, lam, kappa, reach, eta_upper = regular_simplex_parameters(n)
        print(
            f"n={n:4d} m={m:4d} "
            f"min||E_j||={lam:.9f} "
            f"kappa={kappa:.9f} "
            f"reach={reach:.9f} "
            f"eta_upper={eta_upper:.9f}"
        )
        assert m > n
        assert lam < 1
        # Any same-label repeatable POVM has at most n nonzero labels,
        # hence at least one label must move by >= lam in operator norm.

    print("\n=== Binary moving-POVM transfer stress test ===")
    violations = 0
    worst_delta_ratio = 0.0
    worst_transfer_ratio = 0.0

    cases = 20_000
    dims = (2, 3, 5, 10)

    for i in range(cases):
        out = binary_case(dims[i % len(dims)])

        predicted_delta = 2 * out["r"]
        if out["delta"] > predicted_delta + TOL:
            violations += 1

        if out["eta_tilde"] > out["transfer"] + TOL:
            violations += 1

        if predicted_delta > 0:
            worst_delta_ratio = max(
                worst_delta_ratio,
                out["delta"] / predicted_delta,
            )

        if out["transfer"] > 0:
            worst_transfer_ratio = max(
                worst_transfer_ratio,
                out["eta_tilde"] / out["transfer"],
            )

    print(f"seed: {SEED}")
    print(f"cases: {cases}")
    print(f"violations: {violations}")
    print(f"max delta/(2r): {worst_delta_ratio:.12f}")
    print(
        "max moved_defect/(eta+3delta): "
        f"{worst_transfer_ratio:.12f}"
    )

    assert violations == 0
    print("\nPASS")


if __name__ == "__main__":
    main()
