"""End-to-end theorem-v1 contract audit.

This executable is intentionally redundant with several narrower scripts. Its
purpose is to validate the complete chain in one place, using the canonical
typed direct-sum embedding J_K and explicit negative controls.

It checks:
- all theorem hypotheses and expected rejection cases;
- polar packing at arbitrary finite rank;
- same-label POVM completion and repeatability gap;
- exact typed overlap and hybrid-isometry identities;
- exact implementation of F_j = Q_j + R E_j R;
- the conservative Stinespring movement envelope;
- the coefficient-two diamond bound on low-dimensional cases via a primal/dual
  SDP when CVXPY is available;
- the fact that the alternative polar-vector embedding J_q is not interchangeable
  with the theorem's direct-sum inclusion J_K.

Floating-point tests support but do not replace the analytic proof.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
import math
from pathlib import Path
from typing import Sequence

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research" / "local_validation"
SEED = 2026103123
RNG = np.random.default_rng(SEED)
TOL = 2e-8


class HypothesisError(ValueError):
    """Raised when an input violates a stated theorem hypothesis."""


@dataclass
class RoundingData:
    effects: list[np.ndarray]
    delta: float
    bases: list[np.ndarray]
    projectors: list[np.ndarray]
    roots: list[np.ndarray]
    synthesis: np.ndarray
    polar: np.ndarray
    absolute: np.ndarray
    singular_values: np.ndarray
    alpha: float
    sector_projectors: list[np.ndarray]
    total_projector: np.ndarray
    residual_projector: np.ndarray
    completed_effects: list[np.ndarray]
    measurement_isometry: np.ndarray
    labelled_inclusion: np.ndarray
    sector_square_root: np.ndarray
    hybrid_isometry: np.ndarray


def hermitian(a: np.ndarray) -> np.ndarray:
    return (a + a.conj().T) / 2


def operator_norm(a: np.ndarray) -> float:
    return float(np.linalg.norm(a, ord=2))


def psd_sqrt(a: np.ndarray, tol: float = TOL) -> np.ndarray:
    values, vectors = np.linalg.eigh(hermitian(a))
    if values.min(initial=0.0) < -tol:
        raise AssertionError(f"matrix is not positive semidefinite: {values.min()}")
    return (vectors * np.sqrt(np.clip(values, 0.0, None))) @ vectors.conj().T


def inverse_psd_sqrt(a: np.ndarray, tol: float = 1e-13) -> np.ndarray:
    values, vectors = np.linalg.eigh(hermitian(a))
    if values.min(initial=math.inf) <= tol:
        raise HypothesisError("positive normalizer is singular")
    return (vectors * (1.0 / np.sqrt(values))) @ vectors.conj().T


def random_unitary(d: int, rng: np.random.Generator) -> np.ndarray:
    z = rng.normal(size=(d, d)) + 1j * rng.normal(size=(d, d))
    q, r = np.linalg.qr(z)
    phases = np.diag(r)
    phases = np.where(np.abs(phases) > 0, phases / np.abs(phases), 1.0)
    return q @ np.diag(phases.conj())


def random_povm(d: int, m: int, rng: np.random.Generator) -> list[np.ndarray]:
    raw: list[np.ndarray] = []
    for _ in range(m):
        x = rng.normal(size=(d, d)) + 1j * rng.normal(size=(d, d))
        raw.append(x @ x.conj().T)
    inv = inverse_psd_sqrt(sum(raw))
    return [hermitian(inv @ effect @ inv) for effect in raw]


def exact_repeatable_base(
    ranks: Sequence[int],
    residual_dimension: int,
    rng: np.random.Generator,
) -> list[np.ndarray]:
    m = len(ranks)
    d = sum(ranks) + residual_dimension
    effects = [np.zeros((d, d), dtype=complex) for _ in range(m)]

    offset = 0
    for label, rank in enumerate(ranks):
        effects[label][offset : offset + rank, offset : offset + rank] = np.eye(rank)
        offset += rank

    if residual_dimension:
        # Uniform residual mass keeps every residual eigenvalue below the
        # theorem threshold and makes the exact-base cases transparent.
        residual = np.eye(residual_dimension, dtype=complex) / m
        for label in range(m):
            effects[label][-residual_dimension:, -residual_dimension:] = residual

    return effects


def mixed_povm(
    ranks: Sequence[int],
    residual_dimension: int,
    noise: float,
    rng: np.random.Generator,
) -> list[np.ndarray]:
    base = exact_repeatable_base(ranks, residual_dimension, rng)
    d, m = base[0].shape[0], len(base)
    perturbation = random_povm(d, m, rng)
    effects = [
        hermitian((1.0 - noise) * exact + noise * random)
        for exact, random in zip(base, perturbation)
    ]
    unitary = random_unitary(d, rng)
    return [hermitian(unitary @ effect @ unitary.conj().T) for effect in effects]


def validate_povm(effects: Sequence[np.ndarray], tol: float = TOL) -> int:
    """Validate raw inputs before any projection onto Hermitian matrices.

    This is a floating-point contract: Hermiticity and normalization use
    operator-norm tolerance ``tol``; eigenvalues may lie in [-tol, 1+tol].
    The subsequent square root clips only these tolerated negative roundoffs.
    """
    if not effects:
        raise HypothesisError("at least one outcome is required")
    if any(effect.ndim != 2 or effect.shape[0] != effect.shape[1]
           or effect.shape[0] == 0 for effect in effects):
        raise HypothesisError("effects must be nonempty square matrices")
    d = effects[0].shape[0]
    if any(effect.shape != (d, d) for effect in effects):
        raise HypothesisError("all effects must be square matrices of one dimension")
    if any(not np.isfinite(effect).all() for effect in effects):
        raise HypothesisError("all effect entries must be finite")
    if any(operator_norm(effect - effect.conj().T) > tol for effect in effects):
        raise HypothesisError("an effect is not Hermitian within tolerance")
    if operator_norm(sum(effects) - np.eye(d)) > tol:
        raise HypothesisError("effects do not sum to the identity")
    for effect in effects:
        values = np.linalg.eigvalsh(hermitian(effect))
        if values.min(initial=0.0) < -tol:
            raise HypothesisError("an effect is not positive semidefinite")
        if values.max(initial=0.0) > 1.0 + tol:
            raise HypothesisError("an effect exceeds the identity")
    return d


def build_rounding(effects: Sequence[np.ndarray], delta: float) -> RoundingData:
    if not (0.0 < delta < 0.5):
        raise HypothesisError("delta must lie strictly in (0, 1/2)")

    raw = [np.asarray(effect, dtype=complex) for effect in effects]
    d = validate_povm(raw)
    # Remove only tolerated floating-point skew, after validating raw inputs.
    copied = [hermitian(effect) for effect in raw]
    threshold = 1.0 - delta

    bases: list[np.ndarray] = []
    projectors: list[np.ndarray] = []
    roots: list[np.ndarray] = []

    for label, effect in enumerate(copied):
        values, vectors = np.linalg.eigh(effect)
        basis = vectors[:, values >= threshold]
        # Exact zero effects retain their labels through empty sector blocks.
        # A tiny nonzero label must still have a near-unit sector: do not use
        # the numerical tolerance to silently discard it.
        if basis.shape[1] == 0 and np.count_nonzero(raw[label]) != 0:
            raise HypothesisError(
                f"nonzero label {label} has no eigenvalue at least 1-delta"
            )
        bases.append(basis)
        projectors.append(basis @ basis.conj().T)
        roots.append(psd_sqrt(effect))

    synthesis = np.concatenate(bases, axis=1)
    total_rank = synthesis.shape[1]
    if total_rank > d:
        raise HypothesisError("total near-unit sector rank exceeds dimension")

    left, singular_values, right_h = np.linalg.svd(synthesis, full_matrices=False)
    if singular_values.size != total_rank or singular_values[-1] <= 1e-11:
        raise HypothesisError("synthesis operator is singular")

    polar = left @ right_h
    absolute = (right_h.conj().T * singular_values) @ right_h
    alpha = float(singular_values[-1])

    total_projector = hermitian(polar @ polar.conj().T)
    residual_projector = hermitian(np.eye(d) - total_projector)

    sector_projectors: list[np.ndarray] = []
    completed_effects: list[np.ndarray] = []
    labelled_inclusion = np.zeros((len(copied) * d, total_rank), dtype=complex)
    sector_square_root = np.zeros((total_rank, total_rank), dtype=complex)

    offset = 0
    for label, (basis, root, effect) in enumerate(zip(bases, roots, copied)):
        rank = basis.shape[1]
        moved_basis = polar[:, offset : offset + rank]
        q = hermitian(moved_basis @ moved_basis.conj().T)
        sector_projectors.append(q)
        completed_effects.append(
            hermitian(q + residual_projector @ effect @ residual_projector)
        )
        labelled_inclusion[
            label * d : (label + 1) * d, offset : offset + rank
        ] = basis
        sector_square_root[
            offset : offset + rank, offset : offset + rank
        ] = basis.conj().T @ root @ basis
        offset += rank

    measurement_isometry = np.vstack(roots)
    hybrid_isometry = (
        labelled_inclusion @ polar.conj().T
        + measurement_isometry @ residual_projector
    )

    return RoundingData(
        effects=copied,
        delta=delta,
        bases=bases,
        projectors=projectors,
        roots=roots,
        synthesis=synthesis,
        polar=polar,
        absolute=absolute,
        singular_values=singular_values,
        alpha=alpha,
        sector_projectors=sector_projectors,
        total_projector=total_projector,
        residual_projector=residual_projector,
        completed_effects=completed_effects,
        measurement_isometry=measurement_isometry,
        labelled_inclusion=labelled_inclusion,
        sector_square_root=sector_square_root,
        hybrid_isometry=hybrid_isometry,
    )


def assert_contract(data: RoundingData, tol: float = TOL) -> dict[str, float]:
    d = data.effects[0].shape[0]
    m = len(data.effects)
    k = data.synthesis.shape[1]
    identity_d = np.eye(d)
    identity_k = np.eye(k)

    errors: dict[str, float] = {}
    errors["povm_normalization"] = operator_norm(sum(data.effects) - identity_d)
    errors["polar_isometry"] = operator_norm(
        data.polar.conj().T @ data.polar - identity_k
    )
    errors["total_projector"] = operator_norm(
        sum(data.sector_projectors) - data.total_projector
    )
    errors["residual_projector"] = operator_norm(
        data.residual_projector @ data.residual_projector
        - data.residual_projector
    )

    packing_bound = math.sqrt(max(0.0, 1.0 - min(1.0, data.alpha) ** 2))
    maximum_sector_movement = 0.0
    maximum_original_residual_overlap = 0.0
    maximum_sector_orthogonality = 0.0

    for i, (p, q) in enumerate(zip(data.projectors, data.sector_projectors)):
        maximum_sector_movement = max(maximum_sector_movement, operator_norm(p - q))
        maximum_original_residual_overlap = max(
            maximum_original_residual_overlap,
            operator_norm(p @ data.residual_projector),
        )
        for j, other in enumerate(data.sector_projectors):
            if i != j:
                maximum_sector_orthogonality = max(
                    maximum_sector_orthogonality,
                    operator_norm(q @ other),
                )

    assert maximum_sector_movement <= packing_bound + 20 * tol
    errors["original_residual_overlap"] = maximum_original_residual_overlap
    errors["sector_orthogonality"] = maximum_sector_orthogonality

    errors["completed_normalization"] = operator_norm(
        sum(data.completed_effects) - identity_d
    )
    maximum_repeatability_error = 0.0
    maximum_residual_radius = 0.0

    for i, completed in enumerate(data.completed_effects):
        values = np.linalg.eigvalsh(completed)
        assert values.min(initial=0.0) >= -20 * tol
        assert values.max(initial=0.0) <= 1.0 + 20 * tol
        residual = hermitian(
            data.residual_projector
            @ data.effects[i]
            @ data.residual_projector
        )
        maximum_residual_radius = max(maximum_residual_radius, operator_norm(residual))
        for j, sector in enumerate(data.sector_projectors):
            target = sector if i == j else np.zeros_like(sector)
            maximum_repeatability_error = max(
                maximum_repeatability_error,
                operator_norm(completed @ sector - target),
            )

    assert maximum_residual_radius <= 1.0 - data.delta + 50 * tol
    errors["repeatability_action"] = maximum_repeatability_error

    w = data.measurement_isometry
    jmap = data.labelled_inclusion
    u = data.polar
    h = data.absolute
    dblock = data.sector_square_root
    r = data.residual_projector
    v = data.hybrid_isometry

    errors["W_isometry"] = operator_norm(w.conj().T @ w - identity_d)
    errors["J_isometry"] = operator_norm(jmap.conj().T @ jmap - identity_k)
    errors["typed_overlap"] = operator_norm(
        jmap.conj().T @ w @ u - dblock @ h
    )
    errors["typed_cross_term"] = operator_norm(jmap.conj().T @ w @ r)
    errors["hybrid_isometry"] = operator_norm(v.conj().T @ v - identity_d)

    maximum_implementation_error = 0.0
    for label, completed in enumerate(data.completed_effects):
        block = v[label * d : (label + 1) * d]
        maximum_implementation_error = max(
            maximum_implementation_error,
            operator_norm(block.conj().T @ block - completed),
        )
    errors["hybrid_implementation"] = maximum_implementation_error

    epsilon = operator_norm(w @ u - jmap)
    errors["movement_identity"] = abs(operator_norm(v - w) - epsilon)
    errors["epsilon_square_identity"] = abs(
        epsilon**2
        - operator_norm(2 * identity_k - h @ dblock - dblock @ h)
    )

    conservative_bound = 4.0 * (
        math.sqrt(max(0.0, 1.0 - data.alpha**2)) + math.sqrt(data.delta)
    )
    assert 2.0 * epsilon <= conservative_bound + 100 * tol

    max_error = max(errors.values(), default=0.0)
    assert max_error <= 100 * tol, errors

    return {
        "dimension": float(d),
        "outcomes": float(m),
        "total_rank": float(k),
        "alpha": data.alpha,
        "delta": data.delta,
        "packing_bound": packing_bound,
        "maximum_sector_movement": maximum_sector_movement,
        "residual_gap_lower_bound": 1.0 - maximum_residual_radius,
        "epsilon": epsilon,
        "conservative_channel_bound": conservative_bound,
        "maximum_identity_error": max_error,
    }


def measurement_diamond_sdp(
    original: Sequence[np.ndarray],
    rounded: Sequence[np.ndarray],
) -> dict[str, float | str]:
    try:
        import cvxpy as cp
    except (ImportError, OSError) as exc:
        raise RuntimeError(
            "CVXPY is required for SDP checks; install requirements_validation.txt"
        ) from exc

    differences = [
        hermitian((effect - completed).T)
        for effect, completed in zip(original, rounded)
    ]
    d = differences[0].shape[0]

    rho = cp.Variable((d, d), hermitian=True)
    xs = [cp.Variable((d, d), hermitian=True) for _ in differences]
    primal_constraints = [rho >> 0, cp.trace(rho) == 1]
    for x in xs:
        primal_constraints.extend([rho - x >> 0, rho + x >> 0])
    primal = cp.Problem(
        cp.Maximize(
            sum(cp.real(cp.trace(difference @ x))
                for difference, x in zip(differences, xs))
        ),
        primal_constraints,
    )

    ys = [cp.Variable((d, d), hermitian=True) for _ in differences]
    tau = cp.Variable()
    dual_constraints = [tau * np.eye(d) - sum(ys) >> 0]
    for y, difference in zip(ys, differences):
        dual_constraints.extend([y - difference >> 0, y + difference >> 0])
    dual = cp.Problem(cp.Minimize(tau), dual_constraints)

    options = dict(
        solver="CLARABEL",
        canon_backend=cp.SCIPY_CANON_BACKEND,
        tol_gap_abs=1e-9,
        tol_gap_rel=1e-9,
        tol_feas=1e-9,
        max_iter=400,
    )
    primal_value = primal.solve(**options)
    dual_value = dual.solve(**options)
    if primal.status != cp.OPTIMAL or dual.status != cp.OPTIMAL:
        options = dict(
            solver="SCS",
            canon_backend=cp.SCIPY_CANON_BACKEND,
            eps=1e-8,
            max_iters=150000,
        )
        primal_value = primal.solve(**options)
        dual_value = dual.solve(**options)

    assert primal.status == cp.OPTIMAL
    assert dual.status == cp.OPTIMAL

    feasibility = max(
        0.0,
        -float(np.linalg.eigvalsh(hermitian(rho.value)).min()),
        abs(float(np.trace(rho.value).real) - 1.0),
    )
    for x in xs:
        feasibility = max(
            feasibility,
            -float(np.linalg.eigvalsh(hermitian(rho.value - x.value)).min()),
            -float(np.linalg.eigvalsh(hermitian(rho.value + x.value)).min()),
        )
    for y, difference in zip(ys, differences):
        feasibility = max(
            feasibility,
            -float(np.linalg.eigvalsh(hermitian(y.value - difference)).min()),
            -float(np.linalg.eigvalsh(hermitian(y.value + difference)).min()),
        )
    feasibility = max(
        feasibility,
        -float(
            np.linalg.eigvalsh(
                hermitian(dual_value * np.eye(d) - sum(y.value for y in ys))
            ).min()
        ),
    )

    gap = abs(float(primal_value) - float(dual_value))
    assert gap <= 3e-6
    assert feasibility <= 3e-6

    return {
        "solver": options["solver"],
        "primal": float(primal_value),
        "dual": float(dual_value),
        "gap": gap,
        "feasibility_violation": feasibility,
    }


def coefficient_two_bound(data: RoundingData) -> float:
    return 2.0 * min(
        1.0,
        math.sqrt(max(0.0, 1.0 - data.alpha**2)) + math.sqrt(data.delta),
    )


def wrong_embedding_negative_control() -> dict[str, float]:
    for attempt in range(50):
        effects = mixed_povm([1, 1, 1], 2, 0.12, RNG)
        data = build_rounding(effects, 0.14)
        d = effects[0].shape[0]
        wrong = np.zeros_like(data.labelled_inclusion)
        offset = 0
        for label, basis in enumerate(data.bases):
            rank = basis.shape[1]
            wrong[
                label * d : (label + 1) * d,
                offset : offset + rank,
            ] = data.polar[:, offset : offset + rank]
            offset += rank
        wrong_overlap = operator_norm(
            wrong.conj().T
            @ data.measurement_isometry
            @ data.polar
            - data.sector_square_root @ data.absolute
        )
        wrong_cross = operator_norm(
            wrong.conj().T
            @ data.measurement_isometry
            @ data.residual_projector
        )
        if max(wrong_overlap, wrong_cross) > 1e-5:
            return {
                "attempt": float(attempt),
                "wrong_overlap_error": wrong_overlap,
                "wrong_cross_error": wrong_cross,
            }
    raise AssertionError("failed to produce a discriminating J_q negative control")


def trine_effects(dimension: int) -> list[np.ndarray]:
    if dimension not in (2, 3):
        raise ValueError("dimension must be 2 or 3")
    vectors = [
        np.array([math.cos(angle), math.sin(angle)], dtype=complex)
        for angle in (0.0, 2.0 * math.pi / 3.0, 4.0 * math.pi / 3.0)
    ]
    effects_2d = [(2.0 / 3.0) * np.outer(v, v.conj()) for v in vectors]
    if dimension == 2:
        return effects_2d
    output: list[np.ndarray] = []
    for effect in effects_2d:
        lifted = np.zeros((3, 3), dtype=complex)
        lifted[:2, :2] = effect
        lifted[2, 2] = 1.0 / 3.0
        output.append(lifted)
    return output


def assert_rejected(
    name: str,
    effects: Sequence[np.ndarray],
    delta: float,
    expected_fragment: str,
) -> dict[str, str]:
    try:
        build_rounding(effects, delta)
    except HypothesisError as exc:
        message = str(exc)
        assert expected_fragment in message, (name, message, expected_fragment)
        return {"name": name, "reason": message}
    raise AssertionError(f"invalid theorem input was accepted: {name}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--skip-sdp",
        action="store_true",
        help="Run all algebraic and negative-control checks without CVXPY SDPs.",
    )
    parser.add_argument(
        "--sdp-cases",
        type=int,
        default=4,
        help="Number of low-dimensional theorem cases to verify by primal/dual SDP.",
    )
    parser.add_argument(
        "--output",
        default=str(OUT / "theorem_v1_contract.json"),
        help="JSON output path.",
    )
    args = parser.parse_args()
    if args.sdp_cases < 0:
        parser.error("--sdp-cases must be nonnegative")

    cases: list[dict[str, float | str]] = []
    sdp_inputs: list[RoundingData] = []

    exact_cases = [
        ("exact_pvm", [1, 1, 1], 0, 0.0, 0.1),
        ("exact_residual", [1, 1], 2, 0.0, 0.1),
        ("exact_single_outcome", [2], 0, 0.0, 0.1),
    ]
    for name, ranks, residual, noise, delta in exact_cases:
        data = build_rounding(
            exact_repeatable_base(ranks, residual, RNG), delta
        )
        row = assert_contract(data)
        row["name"] = name
        assert row["epsilon"] <= 100 * TOL
        cases.append(row)

    zero_label_effects = [
        np.diag([1.0, 0.0]), np.zeros((2, 2)), np.diag([0.0, 1.0]),
    ]
    zero_label = build_rounding(zero_label_effects, 0.1)
    zero_row = assert_contract(zero_label)
    zero_row["name"] = "exact_zero_label_preserved"
    assert len(zero_label.completed_effects) == len(zero_label_effects)
    assert zero_label.bases[1].shape[1] == 0
    assert operator_norm(zero_label.completed_effects[1]) == 0.0
    cases.append(zero_row)

    random_specs = [
        ("rank1_small", [1, 1], 1, 1e-6),
        ("rank1_three", [1, 1, 1], 2, 1e-3),
        ("higher_rank", [2, 2, 2], 2, 0.02),
        ("unequal_rank", [1, 3, 2], 3, 0.08),
        ("moderate_noise", [1, 1, 1], 2, 0.18),
    ]
    for name, ranks, residual, noise in random_specs:
        delta = min(0.49, 1.15 * noise if noise > 0 else 0.1)
        data = build_rounding(mixed_povm(ranks, residual, noise, RNG), delta)
        row = assert_contract(data)
        row["name"] = name
        cases.append(row)
        if data.effects[0].shape[0] <= 6:
            sdp_inputs.append(data)

    endpoint_delta = 0.1
    endpoint_effects = [
        np.diag([1.0 - endpoint_delta, 0.0, 0.5]),
        np.diag([endpoint_delta, 1.0, 0.5]),
    ]
    endpoint = build_rounding(endpoint_effects, endpoint_delta)
    endpoint_row = assert_contract(endpoint)
    endpoint_row["name"] = "threshold_endpoint_included"
    cases.append(endpoint_row)
    sdp_inputs.append(endpoint)
    if not args.skip_sdp and args.sdp_cases > len(sdp_inputs):
        parser.error(f"requested {args.sdp_cases} theorem SDP cases, but only "
                     f"{len(sdp_inputs)} are available")

    nonhermitian = np.diag([0.95, 0.05]) + np.array([[0.0, 1.0], [-1.0, 0.0]])
    tiny = 1e-12
    rejections = [
        assert_rejected(
            "nonhermitian_effects",
            [nonhermitian, np.eye(2) - nonhermitian], 0.1, "not Hermitian",
        ),
        assert_rejected(
            "nonfinite_nan", [np.diag([np.nan, 1.0])], 0.1, "finite",
        ),
        assert_rejected(
            "nonfinite_infinity", [np.diag([np.inf, 1.0])], 0.1, "finite",
        ),
        assert_rejected("empty_effect_list", [], 0.1, "at least one"),
        assert_rejected(
            "nonsquare_effect", [np.zeros((2, 3))], 0.1, "square",
        ),
        assert_rejected(
            "zero_dimension_effect", [np.zeros((0, 0))], 0.1, "nonempty square",
        ),
        assert_rejected(
            "mixed_dimensions", [np.eye(2), np.eye(3)], 0.1, "one dimension",
        ),
        assert_rejected(
            "nonpositive_effect",
            [np.diag([1.01, -0.01]), np.diag([-0.01, 1.01])],
            0.1, "not positive semidefinite",
        ),
        assert_rejected(
            "not_normalized", [np.eye(2), np.eye(2)], 0.1, "sum to the identity",
        ),
        assert_rejected(
            "tiny_nonzero_label_without_sector",
            [np.diag([1.0-tiny, 0.0]), np.diag([0.0, 1.0-tiny]), tiny*np.eye(2)],
            0.1, "no eigenvalue",
        ),
        assert_rejected(
            "missing_near_unit_sector",
            [np.eye(2) / 2.0, np.eye(2) / 2.0],
            0.1,
            "no eigenvalue",
        ),
        assert_rejected(
            "total_rank_exceeds_dimension",
            trine_effects(2),
            0.4,
            "total near-unit sector rank exceeds dimension",
        ),
        assert_rejected(
            "singular_synthesis",
            trine_effects(3),
            0.4,
            "synthesis operator is singular",
        ),
        assert_rejected(
            "threshold_just_below",
            [
                np.diag([np.nextafter(0.9, 0.0), 0.0, 0.5]),
                np.diag([1.0 - np.nextafter(0.9, 0.0), 1.0, 0.5]),
            ],
            0.1,
            "no eigenvalue",
        ),
        assert_rejected(
            "invalid_delta_zero",
            [np.diag([1.0, 0.0]), np.diag([0.0, 1.0])],
            0.0,
            "strictly",
        ),
        assert_rejected(
            "invalid_delta_half",
            [np.diag([1.0, 0.0]), np.diag([0.0, 1.0])],
            0.5,
            "strictly",
        ),
    ]

    wrong_embedding = wrong_embedding_negative_control()

    sdp_results: list[dict[str, float | str]] = []
    if not args.skip_sdp:
        zero = [np.zeros((2, 2)), np.zeros((2, 2))]
        perfect = [np.eye(2), -np.eye(2)]
        for name, differences, expected in (
            ("zero_anchor", zero, 0.0),
            ("distance_two_anchor", perfect, 2.0),
        ):
            result = measurement_diamond_sdp(
                differences,
                [np.zeros_like(x) for x in differences],
            )
            assert abs(float(result["primal"]) - expected) <= 3e-6
            result["name"] = name
            sdp_results.append(result)

        for index, data in enumerate(sdp_inputs[: args.sdp_cases]):
            result = measurement_diamond_sdp(
                data.effects, data.completed_effects
            )
            bound = coefficient_two_bound(data)
            assert float(result["primal"]) <= bound + 3e-6
            result["name"] = f"theorem_case_{index}"
            result["alpha"] = data.alpha
            result["delta"] = data.delta
            result["coefficient_two_bound"] = bound
            sdp_results.append(result)

    output = {
        "seed": SEED,
        "tolerance": TOL,
        "case_count": len(cases),
        "cases": cases,
        "expected_rejections": rejections,
        "wrong_embedding_negative_control": wrong_embedding,
        "sdp_skipped": args.skip_sdp,
        "theorem_sdp_cases_requested": args.sdp_cases,
        "theorem_sdp_cases_run": 0 if args.skip_sdp else args.sdp_cases,
        "sdp_results": sdp_results,
        "maximum_identity_error": max(
            float(row["maximum_identity_error"]) for row in cases
        ),
        "minimum_alpha": min(float(row["alpha"]) for row in cases),
        "maximum_dimension": max(int(row["dimension"]) for row in cases),
    }

    output_path = Path(args.output)
    if not output_path.is_absolute():
        output_path = ROOT / output_path
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(output, indent=2), encoding="utf-8")

    print(
        "PASS",
        len(cases),
        "valid theorem cases;",
        len(rejections),
        "expected rejections;",
        len(sdp_results),
        "SDP checks;",
        "max identity error",
        output["maximum_identity_error"],
    )


if __name__ == "__main__":
    main()
