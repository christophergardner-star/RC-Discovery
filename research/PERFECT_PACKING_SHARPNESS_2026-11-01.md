# Exact prescribed-completion envelope at perfect packing

1 November 2026. Internally derived and computationally checked; not
externally reviewed, fully formalized in Lean, or established as new in the
literature.

## Result

For the frozen theorem's prescribed completion, under the additional
hypothesis `alpha=1`, the exact worst-case diamond distance is

\[
\boxed{B(\delta)=\frac{2\sqrt\delta}{2-\sqrt\delta}},
\qquad 0<\delta<1/2.
\]

The upper bound holds for every admissible finite-dimensional POVM in this
subclass, including arbitrary reference-assisted inputs. For every allowed
threshold a six-dimensional, five-outcome POVM attains it with a system-only
input. The [complete proof and family](../theory/perfect_packing_sharpness.md)
therefore determine the exact envelope, rather than just its scaling.

This completes the three mathematical targets for perfect packing:

1. **Find extremizing families as the defect tends to zero.** The displayed
   family has distance `B(delta)` and ratio to `sqrt(delta)` tending to one.
   A four-dimensional, three-outcome version works for `delta<1/4`.
2. **Check the full reference-assisted distance.** Explicit primal and dual
   SDP witnesses agree exactly. Seven rational instances pass exact
   verification, independent principal-minor audits, and corruption controls.
3. **Match the lower bound by a universal upper bound.** A positive-residual
   factorization reduces the reference-assisted estimate to a one-variable
   maximization, whose maximum is exactly `B(delta)`.

The asymptotic expansion and the best single uniform coefficient are

\[
B(\delta)=\sqrt\delta+\frac12\delta+O(\delta^{3/2}),
\qquad
C_* =\sup_{0<\delta<1/2}\frac{B(\delta)}{\sqrt\delta}
=\frac{8+2\sqrt2}{7}\simeq1.546918.
\]

Thus the earlier coefficient two was conservative in this subclass. The
sharp small-defect coefficient is one, while a coefficient one is not valid
uniformly at positive defects. The uniform supremum is approached at the
excluded endpoint `delta=1/2`.

## Why the upper bound works

Perfect packing makes the full spectral sectors orthogonal. Write
`S=sum(P_j)`, `R=I-S`, `A_j=P_j E_j P_j`, and
`Delta_j=P_j-A_j`. The positive residual effects `B_j=E_j-A_j` sum to
`L=R+Delta`, with `0<=Delta<=delta*S`. Normalizing by `L` on its support
gives a POVM `N` and an exact channel-difference factorization.

For any pure input including a reference, let `p` be its weight in `S`,
and `r` its expectation of `Delta`. Trace-norm contractivity and a rank-two
calculation give the upper bound

\[
r+\sqrt{r^2+4r(1-p)}
\le \delta p+\sqrt{\delta^2p^2+4\delta p(1-p)}.
\]

The last expression is maximized at `p=1/(2-sqrt(delta))`, with value
`B(delta)`. The proof explicitly handles a kernel of `L` and the endpoint
input weights. If `R=0`, the same argument instead gives `2*delta`.
The extremizers use coherence between a sector and the residual space.

## Exact computational evidence

The [retained certificates](perfect_packing_sharpness_2026-11-01/certificates.json)
use rational parameters `h` with `sqrt(delta)=1-h*h`; all effect matrices,
completion matrices, densities, and SDP witnesses are rational. They are
generated analytically, without numerical optimization.

Representative exact instances are:

| h | delta | Exact full diamond distance | Distance / sqrt(delta) |
|---|---|---|---|
| 11/20 | 77841/160000 | 558/521 | 800/521 |
| 4/5 | 81/625 | 18/41 | 50/41 |
| 99/100 | 39601/100000000 | 398/19801 | 20000/19801 |
| 9999/10000 | 399960001/10000000000000000 | 39998/199980001 | 200000000/199980001 |

The [exact verifier](../experiments/verify_perfect_packing_sharpness.py)
checks effect positivity and normalization, the full closed-threshold sectors
with strict exclusion of every other eigenvalue, the prescribed completion,
primal and dual feasibility, and equality of the two objectives and the
system-only witness. It uses only Python's standard library and exact
integer/Fraction arithmetic. See the [verification output](perfect_packing_sharpness_2026-11-01/verification.json).

The [independent audit](../experiments/check_perfect_packing_sharpness.py)
checks every principal minor by integer Bareiss determinants, separately
from the verifier's Schur elimination: **259 positivity decisions and
15,197 principal minors pass**. **Sixteen rejection controls** reject
corrupt certificates, invalid PSD inputs, and optimized Python that would
disable assertions. See the [audit output](perfect_packing_sharpness_2026-11-01/audit.json).
These finite checks certify the retained instances. The universal statement
uses the written proof, not extrapolation from them.

## Numerical attacks

The [structured search](../experiments/search_perfect_packing_sharpness.py)
varies the residual measurement direction and forms complex convex mixtures
with high-rank sectors, additional outcomes, and a two-dimensional residual
space. It tests thresholds `0.0001`, `0.01`, `0.16`, and `0.49`, using a fixed
seed. System-only optimizations and maximally entangled witnesses are
inexpensive attack scores; selected cases receive full primal/dual SDP checks.
Floating-point feasibility diagnostics are separate from the exact
certificates above.

The completed run checks **312 valid cases and seven full primal/dual
SDPs**. No candidate violation was found. The largest measured construction
identity error is `2.68e-15`; the largest inexpensive-score/bound ratio is
`1.0000000000000002`, consistent with equality to floating-point precision.
The four extremizing cases agree with the analytic formula as follows:

| delta | Exact-formula value, rounded | Numerical SDP primal, rounded |
|---|---|---|
| 0.0001 | 0.0100502512563 | 0.0100502512417 |
| 0.01 | 0.105263157895 | 0.105263157819 |
| 0.16 | 0.5 | 0.4999999999998 |
| 0.49 | 1.076923076923 | 1.076923076919 |

These decimal-threshold examples are numerical checks; the rational
certificates above are the separate exact checks. Across the seven SDPs,
the largest primal/dual gap is `2.64e-8` and the largest measured feasibility
violation is `9.87e-9`. The largest sharp-family primal error is `7.63e-11`.
All retained diagnostics and package versions are in the
[numerical output](perfect_packing_sharpness_2026-11-01/numerical_search.json).

The initial tight-tolerance run was rejected on the final eight-outcome,
ten-dimensional problem because both solvers returned inaccurate statuses.
The completed run uses Clarabel's `1e-7` tolerances for that problem, with
independent feasibility, gap, and scalar-identity repair checks. Its primal
status is `optimal` and its dual status remains `optimal_inaccurate`.
The small measured gap and residual justify retaining it as numerical
evidence, not an exact feasibility certificate. The script now checkpoints
completed results and records failures instead of losing prior results.

That last example also gives numerical evidence of a reference advantage:
its full distance is approximately `0.12137409`, compared with a system-only
optimum of `0.11660626`. Both are below `B(0.16)=0.5`. Thus the fact that
the sharp family needs no ancilla must not be extended to arbitrary
measurements in the subclass. No exact certificate for this additional
reference advantage is claimed.

## Reproduction

From the repository root, with ordinary Python:

```powershell
python experiments/build_perfect_packing_certificates.py
python -I -S experiments/verify_perfect_packing_sharpness.py
python -I -S experiments/check_perfect_packing_sharpness.py
```

For the floating-point search, use the existing audit environment with
NumPy, CVXPY, Clarabel and SCS:

```powershell
.venv-audit/Scripts/python.exe experiments/search_perfect_packing_sharpness.py
```

The exact outputs retain normalized UTF-8 source-text SHA-256 hashes. The
numerical search records its source hashes, seed, solver options, feasibility
residuals, and primal/dual gaps. The exact stage needs none of these solvers.

## Limits and attribution

This settles the sharp envelope internally **only for `alpha=1` and this
prescribed target**. The weighted and unweighted constructions coincide
there. It neither settles general `alpha<1`, nor says this completion is
the closest among all repeatable measurements. Ancillas are unnecessary
for the attaining family; no such assertion is made for arbitrary POVMs.

The [attribution scope note](../literature/PERFECT_PACKING_SHARPNESS_ATTRIBUTION_2026-11-01.md)
identifies standard ingredients and records the limited fresh search for
this exact statement. Novelty and external specialist review remain open.
No new complete Lean theorem was produced in this work. The current
ten-page paper is unchanged; this note and the full proof form a separate
supplement for reconstruction and review.
