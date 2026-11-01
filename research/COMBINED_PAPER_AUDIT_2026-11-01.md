# Audit of the combined fourteen-page manuscript

1 November 2026. Scope: `paper/arxiv_ready.md`, equations (1)--(40), Theorems
1, 7 and 10, Lemma 2, Corollary 3 and Propositions 4--6 and 8--9, together
with their specified proof supplements. This is internal reconstruction in
the same AI-assisted workflow, not an independent referee report or Lean proof.

## Outcome

No fatal mathematical gap was identified in the combined argument. The
new joint-asymptotic proof is now in Section 8 of the paper, rather than
being represented only by a separate research note. The main distinction
throughout is between an exact finite-error result for alpha=1, a sharp
joint leading envelope, and the still-unknown exact general finite-error
envelope. These claims are compatible with the two existing counterexamples.

The integration required no change to the statements or mathematical proofs
of claims 1--9. Their earlier
[claim-by-claim reconstruction](FINAL_PROOF_AUDIT_2026-11-01.md) remains the
base audit. The abstract, limitations and review request now include the
joint result; the additional proof below was checked against that base.
The old reports remain historical evidence for their stated revisions.

## Combined proof dependencies

| Paper claim | Reviewed foundation and scope |
| --- | --- |
| Theorem 1 and Lemma 2 | Typed sector geometry and labelled dilation, spectral gap, Jordan-product sufficient condition, scalar case split and arbitrary-reference pure-input estimate. No claim of sharp general finite constants. |
| Corollary 3 | Active-label convention, positive convex-hull margin, individual record control from channel residual, full-sector gap and normalized projection including zero projected mass. Extra record assumptions are essential. |
| Proposition 4 | Invertible D preserves the synthesis range; weighted polar alignment gives its own completion bound. It is not substituted for the unweighted target. |
| Proposition 5 and Section 6.1 | Same-space/same-label square-root obstruction against any repeatable target; separate binary projective obstruction. These are not claims about an unrestricted dilation target. |
| Proposition 6 | Whole-interval positivity and full-sector isolation, uniform packing, spectral/polar error transfer, exact primal/dual signs and continuity. The bracket proves existence, not uniqueness. |
| Theorem 7 | Positive residual decomposition, support normalization, reference-assisted rank-two norm, scalar maximum and full-sector attaining family. Finite certificates supplement the analytic proof. |
| Proposition 8 | Exhaustive system-only sign bound and feasible rational assisted witness, including complex transpose/realification factors and full sectors. Only separated bounds on the two distances are claimed. |
| Proposition 9 | Positive coupled-simplex construction, full threshold sectors, exact synthesis minimum and explicit witness. Its finite-error vetoes remain valid. |
| Theorem 10 | New upper decomposition and dimension-free selected-map bound, plus Proposition 9 at a rounded even label count. No numerical SDP is used in the universal proof. |

## Reconstruction of Theorem 10

1. **Positive selected decomposition.** Spectral commutation makes each
   `A_j=P_jE_jP_j` a positive part of E_j. Therefore `sum A_j<=I` even though
   the original sectors are not mutually orthogonal. The synthesis formula
   is `A_j=UHDC_jDHU*`, using only `[D,C_j]=0`. It follows that
   `0<=I-HD^2H<=epsilon I` by congruence of `D^2>=d^2 I`.
2. **Residual normalization.** L equals `R+U(I-HD^2H)U*`. Since `0<=B_j<=L`,
   the B_j vanish on its kernel, so support-restricted inverse square roots
   suffice. The kernel extension makes N a true measurement channel. The
   identities `A_jR=0` and `R sqrt(L)=R` justify equation (38) exactly.
3. **Reference-assisted residual estimate.** For a pure joint input,
   `||x||^2=t+q`, `||y||^2=q`, and `<x,y>=q`; hence the two possible nonzero
   eigenvalues have product `-tq` and the trace norm is `sqrt(t^2+4tq)`.
   This expression increases in t for `t,q>=0`, justifying `t<=epsilon p`.
4. **Selected-map estimate.** The relevant contraction is DH because
   `(DH)*(DH)=HD^2H<=I`. Applying the same coordinate measurement to
   `ww*` and `zz*` gives the two CP maps. The bound `2||DH-I||p` holds
   before reference information is discarded. Expanding
   `DH-I=D(H-I)+(D-I)` proves the stated h bound without assuming `[D,H]=0`.
   A channel ceiling is never incorrectly applied to these non-trace-preserving
   maps separately.
5. **Scalar maximum and norms.** Completing the square in (39) gives
   `4 epsilon/(4-epsilon)`. Since `0<epsilon<1`, the denominator is positive.
   Taking the supremum over pure joint inputs bounds the difference of the
   actual measurement channels; their ceiling is two. No factor of one-half
   is introduced into the trace or diamond norm.
6. **Full-sector lower family at the requested parameters.** Choosing
   `m=2 ceil(1/(2 delta))` gives `1/m<=delta` and
   `1/m>=delta/(1+2 delta)`. For `delta<=1/4`, the low block has norm at most
   `2/m<=2 delta<1-delta`, while the selected eigenvalue is at least the
   closed threshold. Thus neither the selected subspace nor alpha changes.
   The equality boundary `delta=1/4` uses m=4 and remains strictly gapped.
7. **Supremum and uniform limit.** The construction proves nonemptiness for
   every alpha and sufficiently small delta. The inequalities in (40) follow
   from `a^2<1` and the two rounding bounds. The upper estimate has no hidden
   dimension or label factor. With `s=a^2+delta`, `epsilon/s->1` and `h=O(s)`
   uniformly near zero, so the sandwich proves a joint limit, not a sampled
   or merely subsequential statement.
8. **Explicit remainder.** For `s<=1/4`, `h<=2s`. Squaring verifies
   `(1-s/4)^(-1/2)<=1+s`; also
   `sqrt((1-2 delta)/(1+2 delta))>=1-2 delta`. These give (37).
   The coefficient five is conservative and is not a subleading optimality claim.

## Boundary and consistency checks

Zero labels and singular L are allowed. Allocating a kernel projection to a
zero label during normalization does not alter either filtered input, since
the relevant vectors have no component in that kernel. Arbitrary sector
ranks and spectral degeneracies enter only through projections and operator
inequalities. The case R=0 removes the residual coherence but does not
invalidate the estimates. Alpha=0 and delta=0 remain excluded endpoints.

At alpha=1, Theorem 7 supplies a sharper finite bound than Theorem 10 but
both have leading coefficient one. A binary example shows why the selected
correction cannot be omitted; the perfect-packing example shows why the
asymptotic equivalent cannot become an exact finite upper bound. Theorem 10
therefore does not contradict Proposition 9's vetoes. Matching lower examples
are system-only, while the upper proof includes arbitrary references.

## Evidence and limits

The final reproduction reruns all twelve exact certificate/audit commands,
the numerical joint-operator audit, the PDF build and the document checker.
The [release report](COMBINED_REVIEW_RELEASE_2026-11-01.md) records the actual
outcomes, versions and source revision. Document checks test artifact integrity;
SDP diagnostics and sampled operator checks do not prove a universal theorem.

This completes the internal review preparation for the current manuscript.
Independent correctness assessment, publication novelty, the exact general
finite-error optimum, the sharp subleading term and crossing uniqueness remain
open. Full Lean formalisation is not part of this release's completed scope.
