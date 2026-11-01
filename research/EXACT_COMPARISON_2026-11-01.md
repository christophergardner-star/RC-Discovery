# Exact comparison certificates: neither completion always wins

1 November 2026.

Subsequent simplification: the [four-dimensional one-parameter family](COMPLETION_SWITCH_FAMILY_2026-11-01.md)
has small displayed matrix entries, opposite endpoint orderings, and a
uniform certificate covering every parameter in its interval.

The numerical comparison has been advanced to two exact rational examples.
For one measurement the prescribed unweighted completion is strictly closer
in full diamond distance. For the other the weighted completion is strictly
closer. Both satisfy the frozen theorem's hypotheses and lie in its
informative regime, where the certified theorem bound is below two.

This is a finite computer-assisted result with an analytic error-bound proof
and an exact arithmetic verifier. It is stronger than a floating-point solver
comparison. It is not a Lean formalization, external specialist verification,
or an established novelty claim.

## Result

Both examples act on complex dimension six, have three outcomes, and have
full threshold-sector ranks (2,2,1). The following intervals are rounded
outward; smaller distance is better.

| Exact example | Unweighted distance | Weighted distance | Strict ordering |
| --- | --- | --- | --- |
| A, inspired by search case 1676 | [0.749960051, 0.749961254] | [0.750939416, 0.750940620] | Unweighted closer |
| B, inspired by search case 2003 | [0.518692284, 0.518693420] | [0.518401816, 0.518402952] | Weighted closer |

The exact rational separation bounds exceed 0.000978162586 in A and
0.000289333328 in B. The threshold errors are exactly 373/1000 and 123/500.
Certified upper bounds from the frozen theorem are 1.903823406 and
1.775804462, respectively, both below two.

The examples are defined by rational matrices in
[the certificate](exact_comparison_2026-11-01/certificates.json). The first
two effects are encoded exactly, and the last is the identity minus their
sum. They are nearby rational measurements derived from the saved search
cases. The claim concerns these explicitly defined rational measurements,
not an unqualified promotion of the earlier floating-point inputs.

## What was certified

The [analytic proof](../theory/exact_completion_comparison.md) explains the
complete bridge from rational data to the two strict comparisons:

1. Exact positivity and normalization of the input measurements.
2. Full spectral-sector ranks, using rational approximate eigensystems with
   rigorous residual bounds and a verified threshold gap.
3. Synthesis injectivity and bounds on both actual polar factors.
4. Explicit operator-norm error bounds between the actual completions and
   the rational matrices used in the distance witnesses.
5. Exact feasible primal and dual witnesses, with the completion error
   included in the final channel-distance enclosures.
6. Strict separation of those enclosures in opposite directions, plus
   rational confirmation that the theorem bounds are informative.

All acceptance decisions in the verifier use Python integers and fractions.
The matrix norm bounds are conservative rational bounds. Positive-definiteness
is established by positive exact LDL pivots. Decimal output is rounded
outward with integer arithmetic. Neither solver status nor floating-point
eigenvalue or tolerance checks are used to accept the retained certificates.

The NumPy-based builder merely proposes rational witnesses. Incorrect
numerical proposals fail the exact checker. Verification can be run with
Python's site packages and environment paths disabled.

## Checks and artifacts

- [Exact verifier](../experiments/verify_exact_completion_comparison.py)
- [Verified rational bounds and hashes](exact_comparison_2026-11-01/verification.json)
- [Certificate builder](../experiments/build_exact_completion_comparison.py)
- [Negative-control and independent determinant audit](../experiments/check_exact_certificate_negative_controls.py)
- [Audit output](exact_comparison_2026-11-01/negative_controls.json)

Both exact certificates passed. All 66 positive matrices also passed a
separate exact Sylvester-criterion check using integer Bareiss determinants.
Eleven expected rejection checks passed, covering invalid measurements,
wrong sectors, invalid thresholds, false packing bounds, broken spectral or
polar witnesses, infeasible primal/dual data, missing labels, reversed
conclusions, and accidental use of optimized Python with assertions disabled.

Reproduce verification, requiring only Python's standard library:

    python -I -S experiments/verify_exact_completion_comparison.py
    python experiments/check_exact_certificate_negative_controls.py

To regenerate proposed certificates from the retained numerical artifacts:

    .venv-audit/Scripts/python.exe experiments/build_exact_completion_comparison.py

Regeneration uses numerical routines and can vary across environments.
Verification of the retained exact certificate does not depend on
regeneration or on those routines. The verification record hashes the
certificate, checker, and analytic proof using LF-normalized UTF-8 text.

## Meaning and remaining limits

The two constructions do not universally dominate one another in actual
movement distance. A stronger general upper bound for the weighted
construction cannot alone justify replacing the unweighted construction
on every instance. This establishes a precise distinction between the
prescribed maps; it does not show that either is globally optimal among
repeatable measurements or preferable in a practical application.

These examples have long rational coefficients; the subsequent family linked
above supplies a simpler explicit presentation. The analytic lemmas connecting certificate entries to the full
channel statement still need independent mathematical review; only the
finite arithmetic certificates have been mechanically checked here.
The frozen theorem, its constant, and the paper's novelty status are
unchanged. The new proof note is a separate reviewable addition.
