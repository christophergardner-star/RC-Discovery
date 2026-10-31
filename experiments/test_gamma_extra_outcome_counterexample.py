#!/usr/bin/env python3
"""Counterexamples for the proposed gamma_F=1 residual-to-extra-outcome closure."""

from __future__ import annotations

import numpy as np


def trace_l1(p: np.ndarray, q: np.ndarray) -> float:
    return float(np.sum(np.abs(p - q)))


def measurement_probs(effects, rho):
    return np.array([np.real(np.trace(e @ rho)) for e in effects], dtype=float)


def main() -> None:
    e0 = np.array([1.0, 0.0, 0.0])
    e1 = np.array([0.0, 1.0, 0.0])
    e2 = np.array([0.0, 0.0, 1.0])

    p0 = np.outer(e0, e0)
    p1 = np.outer(e1, e1)
    r = np.outer(e2, e2)

    # Balanced residual example.
    E = [p0 + 0.5 * r, p1 + 0.5 * r]
    Fextra = [p0, p1, r]
    rho_r = r.copy()

    p = np.concatenate([measurement_probs(E, rho_r), [0.0]])
    q = measurement_probs(Fextra, rho_r)

    print("balanced residual example")
    print("original padded distribution:", p)
    print("extra-outcome distribution: ", q)
    print("l1 distance:", trace_l1(p, q))

    assert abs(trace_l1(p, q) - 2.0) < 1e-12

    # Arbitrarily small repeatability gap at perfect packing and exact idempotence.
    print("\ngap-collapse family")
    print("eps        gamma")
    for eps in (1e-1, 1e-2, 1e-4, 1e-6):
        E1 = p0 + (1.0 - eps) * r
        E2 = p1 + eps * r

        # Exact unit sectors are p0, p1 and alpha = 1.
        # Complement spectral radii:
        gamma1 = 1.0 - np.linalg.norm((np.eye(3) - p0) @ E1 @ (np.eye(3) - p0), 2)
        gamma2 = 1.0 - np.linalg.norm((np.eye(3) - p1) @ E2 @ (np.eye(3) - p1), 2)
        gamma = min(gamma1, gamma2)
        print(f"{eps:1.0e}   {gamma:.12g}")
        assert abs(gamma - eps) < 1e-10

    print("\nPASS")


if __name__ == "__main__":
    main()
