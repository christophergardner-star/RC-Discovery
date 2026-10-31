#!/usr/bin/env python3
"""Stress-test the synthesis-polar packing lemma."""

from __future__ import annotations

import math
import numpy as np

SEED = 20261031
RNG = np.random.default_rng(SEED)
TOL = 1e-10


def orthonormal_columns(d: int, r: int) -> np.ndarray:
    a = RNG.normal(size=(d, r)) + 1j * RNG.normal(size=(d, r))
    q, _ = np.linalg.qr(a)
    return q[:, :r]


def polar_isometry(t: np.ndarray):
    g = t.conj().T @ t
    vals, vecs = np.linalg.eigh(g)
    if vals.min() <= 1e-14:
        raise ValueError("singular")
    invroot = vecs @ np.diag(1.0 / np.sqrt(vals)) @ vecs.conj().T
    return t @ invroot, np.sqrt(vals)


def projector(basis: np.ndarray) -> np.ndarray:
    return basis @ basis.conj().T


def rank_one_cases(ncases: int = 20000):
    violations = 0
    max_ratio = 0.0

    for _ in range(ncases):
        d = int(RNG.integers(2, 21))
        m = int(RNG.integers(2, d + 1))
        v = RNG.normal(size=(d, m)) + 1j * RNG.normal(size=(d, m))
        v /= np.linalg.norm(v, axis=0, keepdims=True)
        if np.linalg.matrix_rank(v) < m:
            continue

        q, singular = polar_isometry(v)
        alpha = float(singular.min())
        bound = math.sqrt(max(0.0, 1.0 - alpha * alpha))

        movement = 0.0
        for j in range(m):
            p = np.outer(v[:, j], v[:, j].conj())
            f = np.outer(q[:, j], q[:, j].conj())
            movement = max(movement, float(np.linalg.norm(p - f, ord=2)))

        if movement > bound + TOL:
            violations += 1
        if bound > 1e-14:
            max_ratio = max(max_ratio, movement / bound)

    return violations, max_ratio


def higher_rank_cases(ncases: int = 10000):
    violations = 0
    max_ratio = 0.0

    for _ in range(ncases):
        d = int(RNG.integers(4, 21))
        remaining = d
        ranks = []

        while remaining > 0 and len(ranks) < 5:
            r = int(RNG.integers(1, min(3, remaining) + 1))
            ranks.append(r)
            remaining -= r
            if len(ranks) >= 2 and RNG.random() < 0.5:
                break

        if len(ranks) < 2:
            continue

        blocks = [orthonormal_columns(d, r) for r in ranks]
        t = np.concatenate(blocks, axis=1)
        if np.linalg.matrix_rank(t) < t.shape[1]:
            continue

        u, singular = polar_isometry(t)
        alpha = float(singular.min())
        bound = math.sqrt(max(0.0, 1.0 - alpha * alpha))

        movement = 0.0
        start = 0
        for basis, r in zip(blocks, ranks):
            moved = u[:, start:start + r]
            start += r
            movement = max(
                movement,
                float(np.linalg.norm(projector(basis) - projector(moved), ord=2)),
            )

        if movement > bound + TOL:
            violations += 1
        if bound > 1e-14:
            max_ratio = max(max_ratio, movement / bound)

    return violations, max_ratio


def equicorrelated_ratio(m: int, alpha: float) -> float:
    rho = 1.0 - alpha * alpha
    g = (1.0 - rho) * np.eye(m) + rho * np.ones((m, m))
    vals, vecs = np.linalg.eigh(g)
    v = np.diag(np.sqrt(vals)) @ vecs.conj().T
    q, singular = polar_isometry(v)

    measured_alpha = float(singular.min())
    bound = math.sqrt(max(0.0, 1.0 - measured_alpha**2))

    movement = 0.0
    for j in range(m):
        p = np.outer(v[:, j], v[:, j].conj())
        f = np.outer(q[:, j], q[:, j].conj())
        movement = max(movement, float(np.linalg.norm(p - f, ord=2)))

    return movement / bound


def main():
    v1, r1 = rank_one_cases()
    vh, rh = higher_rank_cases()

    print("Synthesis-polar packing stress test")
    print(f"seed: {SEED}")
    print(f"rank-1 violations: {v1}")
    print(f"rank-1 max movement/bound: {r1:.12f}")
    print(f"higher-rank violations: {vh}")
    print(f"higher-rank max movement/bound: {rh:.12f}")

    assert v1 == 0
    assert vh == 0

    print("\nEquicorrelated family, alpha=0.5")
    for m in (4, 10, 50, 200):
        print(f"m={m:3d} movement/bound={equicorrelated_ratio(m, 0.5):.12f}")

    print("\nPASS")


if __name__ == "__main__":
    main()
