# The joint leading-order gap is closed internally

1 November 2026. This is the continuation of the specified sharp joint
small-error problem, starting with `1-alpha^2=delta`. It is a new internal
analytic result, not independent external review, a complete formal proof,
or a confirmed publication-priority claim.

## What was resolved

Let W(alpha,delta) be the worst prescribed unweighted-completion diamond
distance over all finite POVMs with the exact synthesis minimum alpha and
the given threshold delta. The [proof](../theory/joint_small_error_asymptotics.md)
establishes

\[
 W(\alpha,\delta)\sim\sqrt{1-\alpha^2+\delta}
 \quad\text{jointly as }(\alpha,\delta)\to(1,0).
\]

In particular, at the requested ratio `1-alpha^2=delta`,
`W/sqrt(delta) -> sqrt(2)`. More generally the coefficient is sqrt(1+r)
when `1-alpha^2=r delta` for any fixed nonnegative r. The derivation closes
the gap for every approach to the joint limit, not only the reciprocal-even
threshold sequence used by the original lower family.

For `s=1-alpha^2+delta<=1/4`, a convenient explicit consequence is

\[
 (1-2\delta)\sqrt{s}\le W(\alpha,\delta)\le\sqrt{s}+5s.
\]

The proof gives a better explicit finite upper expression; five is not a
claimed optimal remainder coefficient. The exact finite-error envelope and
sharp subleading term remain open. The limit allows dimension and outcome
count to grow. It does not settle a separate fixed-dimension optimum.

## Why the argument improves the old estimate

The old overlap argument perturbed an entire dilation and lost a factor at
leading order. The new decomposition treats two terms separately. The
positive unselected effects sum to `R+Delta`, where
`0<=Delta<=epsilon S` and `epsilon=1-alpha^2(1-delta)`. Their residual coupling
is controlled by the established rank-two trace-norm formula. The selected
effects differ from the orthogonal sector measurement by a map of norm at
most `2h`, where

`h=max(1-alpha,1/sqrt(1-delta)-1)+1-sqrt(1-delta)=O(s)`.

The key estimate is `||DH-I||<=h`, together with `||DH||<=1`. It controls
the entire selected measurement at once, rather than adding individual
effect bounds. The operator H and the block operator D need not commute.
Both terms are estimated on an arbitrary pure input with a reference.
The existing coupled-simplex construction supplies the matching lower bound.

## Adversarial reconstruction

- **Noncommuting H and D:** only congruence of `D^2>=d^2 I` is used for
  `HD^2H>=alpha^2 d^2 I`. The error expansion is `DH-I=D(H-I)+(D-I)`;
  no eigenvalue argument for a non-Hermitian product is substituted.
- **Nonorthogonal sectors:** positivity is applied to each spectral piece
  `A_j=P_jE_jP_j<=E_j`. Their sum is `UHD^2HU*`, not an incorrectly assumed
  sum of orthogonal effects. This is what makes the remainder positive.
- **Maps that are not channels:** M_A and M_Q are compared through two
  contraction outputs and a common coordinate measurement. Channel
  contractivity is used only for the normalized residual measurement.
- **Singular normalization:** inverse square roots are restricted to the
  support of L; every B_j kills its kernel. The kernel extension has no
  influence on either filtered input.
- **References:** the scalar p is sector mass in the joint input. The
  outer-product estimate and rank-two calculation hold before reference
  information is discarded. The pure-input theorem is applied to the
  difference of the actual channels.
- **Arbitrary thresholds:** choose even `m=2 ceil(1/(2 delta))`. The lower
  family's selected eigenvalues stay above the new closed threshold and
  its complementary trace stays strictly below it. Alpha is unchanged.
- **Uniformity:** the lower sandwich is uniform in alpha, and `h=O(s)` has
  bounded denominators near `(1,0)`. No exchange of an uncontrolled
  dimension-dependent limit and supremum is needed.
- **False stronger claims:** the exact binary example rejects omitting
  the selected correction, and perfect-packing extremizers reject using
  sqrt(s) alone as a finite-error upper bound. Existing finite-error vetoes
  therefore remain fully consistent with this limit theorem.

## Verification and reproducibility

Run with the existing numerical environment:

```powershell
.venv-audit/Scripts/python.exe experiments/test_joint_small_error.py
```

The [retained report](joint_small_error_2026-11-01/verification.json) includes
the seed, package versions, source hashes, all cases and solver diagnostics.
The check covers 96 operator cases and 1,440 pure inputs with reference
dimensions 1, 2 and the system dimension. It includes high-rank sectors,
48 cases with detected noncommuting H and D, zero residual dimension,
a zero label, and singular normalization. Twenty structured witnesses are
also evaluated directly. The largest recorded factorization defect is below
`3e-14`. Twenty rational scalar checks exercise the lower sandwich at
thresholds on and off the original reciprocal-even sequence.

Five full primal/dual diamond SDPs used CLARABEL and returned optimal status.
The largest primal/dual gap was below `4.6e-8`, and the largest reported
feasibility violation below `1.1e-8`. These are floating-point diagnostics,
not exact SDP certificates. The existing OSQP import warning was emitted;
OSQP was not used. The written proof establishes the universal result;
finite tests only probe implementation and proof-step consistency.

For the ratio-one path, the proved family lower expression and the new
universal upper expression give the following illustrative enclosures of
`W/sqrt(delta)` at `delta=1/m` (displayed decimals are approximate):

| m | Family lower expression | Universal upper expression |
| --- | ---: | ---: |
| 100 | 1.41053039 | 1.61520336 |
| 10,000 | 1.41417819 | 1.43421456 |
| 1,000,000 | 1.41421321 | 1.41621356 |

Convergence to sqrt(2) follows analytically; this table is not its proof.

## Attribution and publication status

The ingredients remain standard: spectral splitting, polar perturbation,
CP normalization, and the rank-two gentle-measurement identity. The latter
is explicitly documented in
[Regula--Lami--Datta, Appendix C](https://arxiv.org/html/2501.12447v5).
The new application is the order-s bound for the selected map and its
combination with the already retained lower family. The prior
[comparison audit](../literature/FINAL_FOCUSED_VETO_2026-11-01.md) supplies the
broader attribution context.

Additional searches for `POVM rounding diamond norm sharp asymptotic
orthogonalization spectral sectors`, `POVM completion asymptotic diamond`
and `POVM asymptotically sharp stability` did not identify this precise
combined statement. Those limited searches cannot establish novelty.
The result resolves a stated project-open problem; no claim is made to
have resolved a previously recognized field-wide open problem.

The twelve-page PDF and its earlier audit are unchanged and predate this
addition. The new proof is a separate linked review target. No external
researcher has reviewed it and no message has been sent.
