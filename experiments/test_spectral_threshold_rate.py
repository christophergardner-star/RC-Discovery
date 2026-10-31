#!/usr/bin/env python3
"""
Adversarial test for linear-in-delta moving-POVM rounding.

Constructs a 3-outcome POVM on C^4 whose near-unit spectral sectors are
already exactly orthogonal (alpha = 1), while an off-sector coupling has
size Theta(sqrt(delta)).

This demonstrates that a general effect-movement estimate of the form
    C * delta
cannot follow from the near-unit spectral threshold alone.

The script verifies:
- positivity and POVM normalization,
- the near-unit spectral sectors,
- alpha = 1 for the synthesis map,
- the sqrt(delta) off-sector coupling,
- divergence of coupling / delta as delta -> 0.

The analytic lower bound for arbitrary nearby repeatable POVMs is recorded
in theory/packing_conditioned_rounding.md.
"""

from __future__ import annotations

import math
import numpy as np


def family(delta: float):
    if not (0.0 < delta < 0.1):
        raise ValueError("use 0 < delta < 0.1")

    t = math.sqrt(delta) / 4.0

    e1 = np.zeros((4, 4), dtype=float)
    e1[0, 0] = 1.0 - delta / 2.0
    e1[1, 1] = delta / 2.0
    e1[3, 3] = 1.0 / 4.0
    e1[1, 3] = e1[3, 1] = t

    e2 = np.diag(
        [
            delta / 2.0,
            1.0 - delta,
            delta / 2.0,
            1.0 / 2.0,
        ]
    )

    e3 = np.eye(4) - e1 - e2
    return (e1, e2, e3), t


def near_unit_projector(effect: np.ndarray, delta: float) -> np.ndarray:
    vals, vecs = np.linalg.eigh(effect)
    mask = vals >= 1.0 - delta - 1e-12
    basis = vecs[:, mask]
    return basis @ basis.T


def synthesis_alpha(projectors: list[np.ndarray]) -> float:
    cols = []
    for p in projectors:
        vals, vecs = np.linalg.eigh(p)
        basis = vecs[:, vals > 0.5]
        cols.append(basis)
    v = np.concatenate(cols, axis=1)
    return float(np.linalg.svd(v, compute_uv=False)[-1])


def main() -> None:
    print("Spectral-threshold adversarial family")
    print("delta        alpha       coupling       coupling/delta")

    for delta in (1e-2, 1e-4, 1e-6, 1e-8):
        effects, coupling = family(delta)

        # POVM checks.
        assert np.linalg.norm(sum(effects) - np.eye(4), ord=2) < 1e-12
        for effect in effects:
            assert np.linalg.eigvalsh(effect).min() > -1e-10

        projectors = [
            near_unit_projector(effect, delta)
            for effect in effects
        ]

        # For this family the threshold sectors are e1, e2, e3.
        expected = [
            np.diag([1.0, 0.0, 0.0, 0.0]),
            np.diag([0.0, 1.0, 0.0, 0.0]),
            np.diag([0.0, 0.0, 1.0, 0.0]),
        ]
        for got, want in zip(projectors, expected):
            assert np.linalg.norm(got - want, ord=2) < 1e-8

        alpha = synthesis_alpha(projectors)
        assert abs(alpha - 1.0) < 1e-10

        # E1 maps e2 partly into e4 with amplitude sqrt(delta)/4.
        e2_vec = np.array([0.0, 1.0, 0.0, 0.0])
        leaked = effects[0] @ e2_vec
        observed = abs(leaked[3])
        assert abs(observed - coupling) < 1e-12

        print(
            f"{delta:1.0e}   "
            f"{alpha:10.8f}   "
            f"{coupling:12.8g}   "
            f"{coupling / delta:14.6g}"
        )

    print("\nPASS")
    print(
        "The packing is perfect (alpha=1), but the off-sector term scales "
        "as sqrt(delta), so a universal O(delta) effect-movement rate is "
        "too strong under spectral-threshold assumptions."
    )


if __name__ == "__main__":
    main()
