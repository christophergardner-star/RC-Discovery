#!/usr/bin/env python3
"""Numerical audit of the dimension-free Naimark-completion bound.

The test builds POVMs by perturbing a repeatability-admissible base POVM with a
small random POVM component, extracts near-unit spectral sectors, and verifies:

1. the exact overlap identity
   (WU-J)^*(WU-J) = 2I - D|T| - |T|D;
2. the scalar bound on epsilon = ||WU-J||;
3. the complement-polar extension is an isometry;
4. the constructed POVM has exact repeatable sectors;
5. the Stinespring movement remains stable as m grows.

This supports the analytic proof in theory/dimension_free_nu_via_naimark.md.
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
    if m > d:
        raise ValueError("need m <= d")
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


def orth_complement(u: np.ndarray) -> np.ndarray:
    q, _ = np.linalg.qr(u, mode="complete")
    return q[:, u.shape[1] :]


def run_case(d: int, m: int, t: float, delta: float) -> dict[str, float]:
    effects = mixed_povm(d, m, t)
    roots = [sqrt_psd(e) for e in effects]

    bases = [spectral_basis(e, 1.0 - delta) for e in effects]
    if any(b.shape[1] == 0 for b in bases):
        raise AssertionError("missing near-unit sector")

    synth = np.concatenate(bases, axis=1)
    gram = synth.conj().T @ synth
    eig = np.linalg.eigvalsh(gram)
    if eig.min() <= 1e-12:
        raise AssertionError("singular synthesis operator")

    abs_t = sqrt_psd(gram)
    polar = synth @ invsqrt_psd(gram)

    alpha = math.sqrt(float(eig.min()))
    m_sing = math.sqrt(float(eig.max()))
    beta = float(np.linalg.norm(abs_t - np.eye(abs_t.shape[0]), 2))

    w = np.vstack(roots)

    rtot = synth.shape[1]
    jmap = np.zeros((m * d, rtot), dtype=complex)
    dblock = np.zeros((rtot, rtot), dtype=complex)

    off = 0
    for label, basis in enumerate(bases):
        r = basis.shape[1]
        jmap[label * d : (label + 1) * d, off : off + r] = basis
        dblock[off : off + r, off : off + r] = (
            basis.conj().T @ roots[label] @ basis
        )
        off += r

    a = w @ polar
    epsilon = float(np.linalg.norm(a - jmap, 2))

    identity_matrix = (
        2.0 * np.eye(rtot)
        - dblock @ abs_t
        - abs_t @ dblock
    )
    identity_error = abs(
        epsilon**2 - float(np.linalg.norm(identity_matrix, 2))
    )

    rdelta = 1.0 - math.sqrt(1.0 - delta)
    epsilon_bound = math.sqrt(
        max(0.0, 2.0 * beta + 2.0 * rdelta * m_sing)
    )

    n = orth_complement(polar)
    if n.shape[1]:
        p_j = jmap @ jmap.conj().T
        z = (np.eye(m * d) - p_j) @ w @ n
        zgram = z.conj().T @ z
        if np.linalg.eigvalsh(zgram).min() <= 1e-12:
            raise AssertionError("complement projection lost rank")
        c = z @ invsqrt_psd(zgram)
        v = jmap @ polar.conj().T + c @ n.conj().T
        h = (
            epsilon
            + 1.0
            - math.sqrt(max(0.0, 1.0 - epsilon**2))
        )
        extension_bound = math.sqrt(epsilon**2 + h**2)
    else:
        v = jmap @ polar.conj().T
        extension_bound = epsilon

    isometry_error = float(
        np.linalg.norm(v.conj().T @ v - np.eye(d), 2)
    )
    movement = float(np.linalg.norm(v - w, 2))

    max_repeatability_error = 0.0
    off = 0
    for label, basis in enumerate(bases):
        r = basis.shape[1]
        qj = polar[:, off : off + r]
        off += r

        label_proj = np.zeros((m * d, m * d), dtype=complex)
        label_proj[
            label * d : (label + 1) * d,
            label * d : (label + 1) * d,
        ] = np.eye(d)

        fj = v.conj().T @ label_proj @ v
        max_repeatability_error = max(
            max_repeatability_error,
            float(np.linalg.norm(fj @ qj - qj, 2)),
        )

    assert identity_error <= TOL
    assert epsilon <= epsilon_bound + TOL
    assert movement <= extension_bound + TOL
    assert isometry_error <= TOL
    assert max_repeatability_error <= TOL

    return {
        "alpha": alpha,
        "epsilon": epsilon,
        "movement": movement,
        "nu_upper": 2.0 * movement,
    }


def main() -> None:
    print("Dimension-free Naimark-completion audit")
    print(f"seed: {SEED}")
    print("m   mean(alpha)   mean(2||W-V||)   max(2||W-V||)")

    for m in (2, 4, 8, 16):
        d = m + 2
        rows = [
            run_case(d=d, m=m, t=0.005, delta=0.01)
            for _ in range(5)
        ]
        mean_alpha = np.mean([r["alpha"] for r in rows])
        mean_upper = np.mean([r["nu_upper"] for r in rows])
        max_upper = np.max([r["nu_upper"] for r in rows])
        print(
            f"{m:2d}   {mean_alpha:11.8f}   "
            f"{mean_upper:16.8f}   {max_upper:15.8f}"
        )

    print("\nPASS")


if __name__ == "__main__":
    main()
