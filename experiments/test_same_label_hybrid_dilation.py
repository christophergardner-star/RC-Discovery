#!/usr/bin/env python3
"""Numerical audit for the exact same-label hybrid dilation.

Verifies for random finite POVMs near a repeatable base:

1. V = J U^* + W R is an isometry.
2. V implements F_j = Q_j + R E_j R exactly.
3. ||V-W|| = ||WU-J||.
4. The resulting Stinespring upper bound is stable as m grows.

This supports theory/same_label_dimension_free_theorem.md.
"""

from __future__ import annotations

import math
import numpy as np

SEED = 20261031
RNG = np.random.default_rng(SEED)
TOL = 1e-9


def sqrt_psd(a: np.ndarray) -> np.ndarray:
    vals, vecs = np.linalg.eigh((a + a.conj().T) / 2)
    vals = np.clip(vals, 0.0, None)
    return vecs @ np.diag(np.sqrt(vals)) @ vecs.conj().T


def invsqrt_psd(a: np.ndarray, tol: float = 1e-12) -> np.ndarray:
    vals, vecs = np.linalg.eigh((a + a.conj().T) / 2)
    inv = np.array([1.0 / math.sqrt(v) if v > tol else 0.0 for v in vals])
    return vecs @ np.diag(inv) @ vecs.conj().T


def random_povm(d: int, m: int) -> list[np.ndarray]:
    raw = []
    for _ in range(m):
        x = RNG.normal(size=(d, d)) + 1j * RNG.normal(size=(d, d))
        raw.append(x @ x.conj().T)
    s = sum(raw)
    sinv = invsqrt_psd(s)
    return [sinv @ a @ sinv for a in raw]


def repeatable_base(d: int, m: int) -> list[np.ndarray]:
    residual = np.zeros((d, d), dtype=complex)
    for k in range(m, d):
        residual[k, k] = 1.0

    out = []
    for j in range(m):
        p = np.zeros((d, d), dtype=complex)
        p[j, j] = 1.0
        out.append(p + residual / m)
    return out


def mixed_povm(d: int, m: int, t: float) -> list[np.ndarray]:
    base = repeatable_base(d, m)
    noise = random_povm(d, m)
    return [(1.0 - t) * base[j] + t * noise[j] for j in range(m)]


def spectral_basis(effect: np.ndarray, threshold: float) -> np.ndarray:
    vals, vecs = np.linalg.eigh((effect + effect.conj().T) / 2)
    return vecs[:, vals >= threshold - 1e-10]


def run_case(d: int, m: int, t: float, delta: float) -> dict[str, float]:
    effects = mixed_povm(d, m, t)
    roots = [sqrt_psd(e) for e in effects]
    bases = [spectral_basis(e, 1.0 - delta) for e in effects]

    if any(b.shape[1] == 0 for b in bases):
        raise AssertionError("missing near-unit sector")

    tmat = np.concatenate(bases, axis=1)
    gram = tmat.conj().T @ tmat
    vals = np.linalg.eigvalsh(gram)
    if vals.min() <= 1e-12:
        raise AssertionError("singular synthesis operator")

    h = sqrt_psd(gram)
    u = tmat @ invsqrt_psd(gram)

    sproj = u @ u.conj().T
    rproj = np.eye(d) - sproj

    w = np.vstack(roots)

    rtot = tmat.shape[1]
    jmap = np.zeros((m * d, rtot), dtype=complex)
    off = 0
    for label, basis in enumerate(bases):
        r = basis.shape[1]
        jmap[label * d : (label + 1) * d, off : off + r] = basis
        off += r

    v = jmap @ u.conj().T + w @ rproj

    epsilon = float(np.linalg.norm(w @ u - jmap, ord=2))
    movement = float(np.linalg.norm(v - w, ord=2))
    isometry_error = float(np.linalg.norm(v.conj().T @ v - np.eye(d), ord=2))

    # Exact implementation of F_j = Q_j + R E_j R.
    off = 0
    max_effect_error = 0.0
    max_gap_violation = 0.0

    for label, basis in enumerate(bases):
        r = basis.shape[1]
        uj = u[:, off : off + r]
        off += r
        qj = uj @ uj.conj().T

        lam = np.zeros((m * d, m * d), dtype=complex)
        lam[label * d : (label + 1) * d, label * d : (label + 1) * d] = np.eye(d)

        fj_from_v = v.conj().T @ lam @ v
        fj_direct = qj + rproj @ effects[label] @ rproj

        max_effect_error = max(
            max_effect_error,
            float(np.linalg.norm(fj_from_v - fj_direct, ord=2)),
        )

        residual_radius = float(
            np.linalg.norm(rproj @ effects[label] @ rproj, ord=2)
        )
        max_gap_violation = max(
            max_gap_violation,
            residual_radius - (1.0 - delta),
        )

    alpha = math.sqrt(float(vals.min()))
    sigma_max = math.sqrt(float(vals.max()))
    beta = float(np.linalg.norm(h - np.eye(rtot), ord=2))
    rdelta = 1.0 - math.sqrt(1.0 - delta)
    eps_bound = math.sqrt(max(0.0, 2.0 * beta + 2.0 * rdelta * sigma_max))

    assert abs(movement - epsilon) <= 1e-8
    assert isometry_error <= TOL
    assert max_effect_error <= 1e-8
    assert max_gap_violation <= 1e-8
    assert epsilon <= eps_bound + 1e-8

    return {
        "alpha": alpha,
        "epsilon": epsilon,
        "nu_upper": 2.0 * epsilon,
        "explicit_bound": 4.0 * (
            math.sqrt(max(0.0, 1.0 - alpha * alpha))
            + math.sqrt(delta)
        ),
    }


def main() -> None:
    print("Same-label hybrid dilation audit")
    print(f"seed: {SEED}")
    print("m   mean(alpha)   mean(2epsilon)   max(2epsilon)   mean(C=4 bound)")

    for m in (2, 4, 8, 16):
        d = m + 2
        rows = [run_case(d=d, m=m, t=0.005, delta=0.01) for _ in range(5)]

        mean_alpha = np.mean([r["alpha"] for r in rows])
        mean_nu = np.mean([r["nu_upper"] for r in rows])
        max_nu = np.max([r["nu_upper"] for r in rows])
        mean_bound = np.mean([r["explicit_bound"] for r in rows])

        print(
            f"{m:2d}   {mean_alpha:11.8f}   "
            f"{mean_nu:14.8f}   {max_nu:13.8f}   {mean_bound:15.8f}"
        )

        for row in rows:
            assert row["nu_upper"] <= row["explicit_bound"] + 1e-8

    print("\nPASS")


if __name__ == "__main__":
    main()
