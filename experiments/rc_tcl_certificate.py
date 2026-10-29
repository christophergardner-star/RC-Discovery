"""RC-TCL pilot: idempotence-style diagnostics for Thermodynamic Continual Learning.

This is a deliberately narrow bridge. It isolates the quadratic ThermalMemory
penalty used by canonical TCL and asks whether the penalty-only dynamics, over a
chosen training horizon, are close to an exact coordinate projection.

It does NOT claim that the full nonlinear SGD/Adam training map is idempotent.
Task gradients, weight decay, BatchNorm state, optimizer state, and changing
importance maps are outside the exact theorem below.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Iterable, Sequence

import numpy as np


@dataclass(frozen=True)
class RoundingCertificate:
    factors: np.ndarray
    eta: float
    delta: float
    locked_fraction: float
    free_fraction: float
    ambiguous_fraction: float


def sgd_horizon_factor(
    importance: float,
    *,
    lr: float,
    lambda_tcl: float,
    steps: int,
) -> float:
    """Exact scalar contraction for isolated quadratic TCL penalty under plain SGD."""
    d = 1.0 - 2.0 * lr * lambda_tcl * importance
    return float(d ** steps)


def momentum_horizon_factor(
    importance: float,
    *,
    lr: float,
    lambda_tcl: float,
    steps: int,
    momentum: float,
) -> float:
    """Exact theta contraction with fresh zero momentum for isolated quadratic TCL."""
    c = 2.0 * lambda_tcl * importance
    mat = np.array(
        [
            [1.0 - lr * c, -lr * momentum],
            [c, momentum],
        ],
        dtype=np.float64,
    )
    power = np.linalg.matrix_power(mat, int(steps))
    return float(power[0, 0])


def nearest_idempotent_certificate(
    factors: Sequence[float],
    *,
    lock_threshold: float = 0.1,
    free_threshold: float = 0.9,
) -> RoundingCertificate:
    """Certificate for a diagonal affine horizon map with factors in [0,1]."""
    arr = np.asarray(factors, dtype=np.float64)
    if arr.size == 0:
        raise ValueError("factors must be non-empty")
    if np.any(arr < -1e-12) or np.any(arr > 1.0 + 1e-12):
        raise ValueError("certificate requires factors in [0,1]")
    arr = np.clip(arr, 0.0, 1.0)

    eta = float(np.max(arr * (1.0 - arr)))
    delta = float(np.max(np.minimum(arr, 1.0 - arr)))
    exact_delta = (1.0 - math.sqrt(max(0.0, 1.0 - 4.0 * eta))) / 2.0
    if not math.isclose(delta, exact_delta, rel_tol=1e-9, abs_tol=1e-9):
        raise AssertionError((delta, exact_delta, eta))

    locked = float(np.mean(arr <= lock_threshold))
    free = float(np.mean(arr >= free_threshold))
    ambiguous = 1.0 - locked - free
    return RoundingCertificate(arr, eta, delta, locked, free, ambiguous)


def weighted_anchor_conflict(
    anchors: np.ndarray,
    importances: np.ndarray,
    *,
    task_weights: Iterable[float] | None = None,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Return total importance A, anchor barycentre mu, and conflict variance."""
    anchors = np.asarray(anchors, dtype=np.float64)
    importances = np.asarray(importances, dtype=np.float64)
    if anchors.shape != importances.shape or anchors.ndim != 2:
        raise ValueError("anchors and importances must have identical [tasks, coordinates] shape")
    if np.any(importances < 0.0):
        raise ValueError("importances must be nonnegative")

    tasks = anchors.shape[0]
    if task_weights is None:
        weights = np.ones(tasks, dtype=np.float64)
    else:
        weights = np.asarray(list(task_weights), dtype=np.float64)
        if weights.shape != (tasks,) or np.any(weights < 0.0):
            raise ValueError("task_weights must be nonnegative with one entry per task")

    q = importances * weights[:, None]
    A = q.sum(axis=0)
    mu = np.zeros_like(A)
    nz = A > 0.0
    mu[nz] = (q[:, nz] * anchors[:, nz]).sum(axis=0) / A[nz]

    conflict = np.zeros_like(A)
    conflict[nz] = (
        q[:, nz] * (anchors[:, nz] - mu[nz]) ** 2
    ).sum(axis=0) / A[nz]
    return A, mu, conflict


def threshold_importance(
    target_factor: float,
    *,
    lr: float,
    lambda_tcl: float,
    steps: int,
    momentum: float | None,
    hi: float = 4.0,
) -> float:
    """Solve for importance A where the isolated horizon factor hits target."""
    if not (0.0 < target_factor < 1.0):
        raise ValueError("target_factor must lie in (0,1)")

    if momentum is None:
        def fn(x: float) -> float:
            return sgd_horizon_factor(x, lr=lr, lambda_tcl=lambda_tcl, steps=steps)
    else:
        def fn(x: float) -> float:
            return momentum_horizon_factor(
                x,
                lr=lr,
                lambda_tcl=lambda_tcl,
                steps=steps,
                momentum=momentum,
            )

    lo = 0.0
    while fn(hi) > target_factor and hi < 1e6:
        hi *= 2.0
    if fn(hi) > target_factor:
        return math.inf

    for _ in range(100):
        mid = 0.5 * (lo + hi)
        if fn(mid) > target_factor:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


def run_canonical_split_cifar10_pilot() -> None:
    lr = 0.01
    lambda_tcl = 0.01
    momentum = 0.9
    batch_size = 64
    epochs = 40
    examples_per_task = 10_000
    steps = math.ceil(examples_per_task / batch_size) * epochs

    print("RC-TCL canonical Split-CIFAR-10 pilot")
    print(f"steps/task={steps} lr={lr} lambda_tcl={lambda_tcl} momentum={momentum}")
    print()
    print("Importance A | plain-SGD factor | momentum-SGD factor")
    for importance in (0.0, 0.01, 0.05, 0.1, 0.2, 0.5, 1.0):
        p = sgd_horizon_factor(
            importance,
            lr=lr,
            lambda_tcl=lambda_tcl,
            steps=steps,
        )
        m = momentum_horizon_factor(
            importance,
            lr=lr,
            lambda_tcl=lambda_tcl,
            steps=steps,
            momentum=momentum,
        )
        print(f"{importance:12.3f} | {p:16.6f} | {m:19.6f}")

    print()
    for target in (0.9, 0.5, 0.1, 0.01):
        plain = threshold_importance(
            target,
            lr=lr,
            lambda_tcl=lambda_tcl,
            steps=steps,
            momentum=None,
        )
        mom = threshold_importance(
            target,
            lr=lr,
            lambda_tcl=lambda_tcl,
            steps=steps,
            momentum=momentum,
        )
        print(
            f"factor <= {target:>4.2f}: "
            f"A >= {plain:.6f} (plain SGD), "
            f"A >= {mom:.6f} (momentum SGD)"
        )

    anchors = np.array([[-1.0], [1.0]])
    importances = np.array([[1.0], [1.0]])
    A, mu, conflict = weighted_anchor_conflict(anchors, importances)
    factor = momentum_horizon_factor(
        float(A[0]),
        lr=lr,
        lambda_tcl=lambda_tcl,
        steps=steps,
        momentum=momentum,
    )

    print()
    print("Two-task conflict demo")
    print(
        f"anchors=(-1,+1), A={A[0]:.3f}, barycentre={mu[0]:.3f}, "
        f"anchor_variance={conflict[0]:.3f}, horizon_factor={factor:.6g}"
    )
    print(
        "Interpretation: the coordinate is extremely stable, but it is stable around "
        "a compromise anchor that neither task requested."
    )


if __name__ == "__main__":
    run_canonical_split_cifar10_pilot()
