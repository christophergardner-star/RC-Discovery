"""Exact examples for the conditional explicit-matrix simulation reduction.

The external signing algorithm is not implemented here. These examples use
small groups whose norm bounds can be checked directly over the rationals.
"""
from __future__ import annotations

from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import time

import sympy as sp

ROOT = Path(__file__).resolve().parents[1]


def positive_rank_one_terms(matrix: sp.Matrix) -> list[sp.Matrix]:
    """Exact rational pivoted Schur elimination, also serving as a PSD check."""
    if matrix != matrix.conjugate().T:
        raise ValueError("Non-Hermitian input")
    residual = matrix.copy()
    terms = []
    for _ in range(matrix.rows):
        diagonal = [residual[i, i] for i in range(matrix.rows)]
        if any(value < 0 for value in diagonal):
            raise ValueError("Negative diagonal pivot")
        for i, value in enumerate(diagonal):
            if value == 0 and any(residual[i, j] != 0 for j in range(matrix.rows)):
                raise ValueError("Zero PSD diagonal with a nonzero row")
        pivot = next((i for i, value in enumerate(diagonal) if value > 0), None)
        if pivot is None:
            if residual != sp.zeros(matrix.rows):
                raise ValueError("Nonzero residual")
            return terms
        column = residual[:, pivot]
        term = column * column.conjugate().T / residual[pivot, pivot]
        terms.append(term)
        residual -= term
    if residual != sp.zeros(matrix.rows):
        raise ValueError("Unresolved Schur residual")
    return terms


def audit_example(name: str, effects: list[sp.Matrix]) -> dict:
    dimension = effects[0].rows
    identity = sp.eye(dimension)
    zero = sp.zeros(dimension)
    assert sum(effects, zero) == identity
    terms = [(label, term) for label, effect in enumerate(effects)
             for term in positive_rank_one_terms(effect)]
    epsilon = sp.Rational(1, 100 * len(terms))
    chunks = []
    remainders = []
    for label, term in terms:
        trace = sp.trace(term)
        count = int(sp.floor(trace / epsilon))
        chunk = term * epsilon / trace
        chunks.extend([(label, chunk)] * count)
        remainder = term - count * chunk
        if remainder != zero:
            positive_rank_one_terms(remainder)
            remainders.append((label, remainder))
    assert len(chunks) <= dimension / epsilon
    remainder_mass = sum(sp.trace(term) for _, term in remainders)
    assert remainder_mass < sp.Rational(1, 100)
    capacity = dimension - 1
    groups = [chunks[i:i + capacity] for i in range(0, len(chunks), capacity)]
    assert len(groups) < 4 / epsilon
    branches = [(group, 289 * epsilon) for group in groups]
    branches.extend(([(label, term)], sp.trace(term)) for label, term in remainders)
    normalization = sum(upper for _, upper in branches)
    assert 1 <= normalization < 1157
    probability = 1 / normalization
    recovered = [sp.zeros(dimension) for _ in effects]
    failure = sp.zeros(dimension)
    total_mixing = 0
    for group, upper in branches:
        assert len(group) <= capacity
        group_sum = sum((term for _, term in group), sp.zeros(dimension))
        positive_rank_one_terms(upper * identity - group_sum)
        mixing = upper / normalization
        total_mixing += mixing
        failure += mixing * (identity - group_sum / upper)
        for label, term in group:
            recovered[label] += mixing * term / upper
    assert total_mixing == 1
    assert failure == (1 - probability) * identity
    assert all(actual == probability * effect for actual, effect in zip(recovered, effects))
    group_sum = sum((term for _, term in branches[0][0]), sp.zeros(dimension))
    corrupted_upper = sp.trace(group_sum) / (2 * dimension)
    try:
        positive_rank_one_terms(corrupted_upper * identity - group_sum)
    except ValueError:
        pass
    else:
        raise AssertionError("Corrupted branch bound accepted")
    corrupted_recovery = [matrix.copy() for matrix in recovered]
    first_group, first_upper = branches[0]
    for label, term in first_group:
        corrupted_recovery[label] += sp.Rational(1, 100) * term / first_upper
    assert any(actual != probability * effect
               for actual, effect in zip(corrupted_recovery, effects))
    return {
        "name": name, "dimension": dimension, "original_outcomes": len(effects),
        "rank_one_terms": len(terms), "epsilon": str(epsilon),
        "full_chunks": len(chunks), "remainders": len(remainders),
        "remainder_trace_sum": str(remainder_mass), "branches": len(branches),
        "success_probability": str(probability), "positive_branch_checks": len(branches),
        "negative_controls_rejected": ["undersized_branch_upper", "wrong_mixing_normalization"],
        "external_signing_algorithm_invoked": False,
    }


def main() -> None:
    started = time.monotonic()
    projectors = []
    for vector in [sp.Matrix([1, 0]), sp.Matrix([0, 1]),
                   sp.Matrix([1, 1]), sp.Matrix([1, -1]),
                   sp.Matrix([1, sp.I]), sp.Matrix([1, -sp.I])]:
        projectors.append(vector * vector.conjugate().T / (vector.conjugate().T * vector)[0] / 3)
    tiny = sp.Rational(1, 10 ** 40)
    cases = [
        audit_example("three_bases_of_one_qubit", projectors),
        audit_example("tiny_high_rank_effect", [(1 - tiny) * sp.eye(3), tiny * sp.eye(3)]),
        audit_example("unequal_diagonal_effects", [
            sp.diag(sp.Rational(1, 7), sp.Rational(2, 5), sp.Rational(3, 11)),
            sp.diag(sp.Rational(6, 7), sp.Rational(3, 5), sp.Rational(8, 11))]),
    ]
    output = ROOT / "research/constructive_simulation_reduction_2026-11-10/verification.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    sources = [Path(__file__), ROOT / "theory/constructive_simulation_reduction.md"]
    result = {
        "result": "PASS", "utc": datetime.now(timezone.utc).isoformat(),
        "scope": "Exact rational examples for refinement and the branch protocol. The global partition theorem uses an external signing algorithm as an unimplemented hypothesis. No general algorithm, full Lean proof, or new open-problem solution is certified by this script.",
        "cases": cases, "elapsed_seconds": time.monotonic() - started,
        "source_sha256": {str(path.relative_to(ROOT)).replace('\\', '/'):
                          hashlib.sha256(path.read_bytes()).hexdigest() for path in sources},
    }
    output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {len(cases)} exact examples, "
          f"{sum(case['positive_branch_checks'] for case in cases)} branch positivity checks, "
          f"{2 * len(cases)} rejected corruptions. External signing algorithm unimplemented.")


if __name__ == "__main__":
    main()
