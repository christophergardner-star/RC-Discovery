# Reviewer packet

**9 November update:** start with the [exact joint reconstruction packet](EXACT_JOINT_RECONSTRUCTION.md)
for the later exact-envelope result. Its full canonical upper bound, general
attaining family, exact supremum equality and joint asymptotic limits are now
Lean checked.
The paper release described below remains a historical snapshot.

**Christopher Gardner — Stability of a prescribed repeatable completion of a
quantum measurement.** Fourteen-page internal review draft, 1 November 2026.

Read the [paper](../paper/prescribed_repeatable_completion.pdf), then the
[combined-paper audit](../research/COMBINED_PAPER_AUDIT_2026-11-01.md) and
[focused prior-art comparison](../literature/FINAL_FOCUSED_VETO_2026-11-01.md).
The work is internally reconstructed, computationally audited, partially
formalised, novelty unverified. No external review is represented as completed.

After this paper was frozen, the [Lean operator development](../lean/README.md)
expanded from 13 to 481 written lemmas/theorems. The assembled
[`frozen_theorem`](../lean/RCProof/FrozenTheorem.lean) now includes the canonical
frame and completion, principal-angle and equal-rank results, repeatable
instrument, and the unconditional coefficient-two diamond bound for all complex
inputs and all finite ancillas. Its sharp trace-distance proof uses a shifted
telescoping identity, bypassing pure-state reduction. The
[latest formalization report](../research/LEAN_PERFECT_SHARPNESS_2026-11-01.md)
also records the checked exact perfect-packing operator bound, attaining POVM,
actual worst-case supremum, its second-order limit and direct accessibility
estimate. The [full joint report](../research/LEAN_EXACT_JOINT_FULL_2026-11-09.md)
adds the general attaining family, actual exact joint supremum and both joint
asymptotic coefficients. Final record correction and saved comparison
instantiations remain separate unfinished formalizations. The paper's count
remains a historical snapshot.

**New review target, 9 November:** the [exact joint envelope](../theory/exact_joint_envelope.md)
gives equality `W=B(1-alpha^2(1-delta))` throughout the admissible parameter
range. It uses a common-threshold split and a coupled Gram certificate, avoiding
the prior commutator loss. The complete extremal equality is Lean checked.
Please reconstruct this supplement
alongside the frozen paper; its novelty and external correctness assessment
remain unresolved. [Verification record](../research/EXACT_JOINT_ENVELOPE_2026-11-09.md).

The new [joint second-order supplement](../theory/joint_second_order.md)
derives `W = sqrt(s) + s/2 + O(s^(3/2))` internally and narrows the small-error
finite-error enclosure to width `4 delta s`. It has exact rational checks and
partial Lean support in its historical release. The later exact equality and
`joint_worstCase_second_order_limit` now prove the subleading coefficient for
the actual supremum. External reconstruction remains open.

**Theorem 10 is now integrated into Section 8:** it establishes the sharp
leading envelope `sqrt(1-alpha^2+delta)` with a uniform remainder and includes
the upper proof and joint-limit argument. The
[extended note](../theory/joint_small_error_asymptotics.md) supplies supplementary
detail. The 9 November supplement now determines the exact finite-error optimum
internally for the prescribed completion.

For a finite POVM with nonzero full near-unit sectors and injective synthesis
map `T=U|T|`, the object is the specified same-label completion
`F_j=UC_jU*+RE_jR`, where `R=I-UU*`. Norms are unhalved diamond norms.
The general bound is a quantitative application of established tools.
The additional sharpness claims are the exact worst-case formula
`2 sqrt(delta)/(2-sqrt(delta))` when `alpha=1`, with attainment throughout
`0<delta<1/2`, and the joint leading envelope as `(alpha,delta)->(1,0)`.
The further claims are a certified reference advantage and
a coupled-simplex lower bound with two false proposed extensions.

Proof supplements are part of the review target:

- [Comparison and error transfer](../theory/exact_completion_comparison.md),
  [uniform parameter family](../theory/completion_switch_family.md), and
  [crossing certificate](../research/COMPLETION_CROSSOVER_2026-11-01.md).
- [Sharp perfect-packing proof](../theory/perfect_packing_sharpness.md),
  [reference certificate interpretation](../theory/reference_advantage.md),
  and [coupled-simplex proof and vetoes](../theory/imperfect_packing_lower_bound.md).

Please assess three questions:

1. Does the argument establish the exact stated hypotheses, full spectral
   sectors and arbitrary-reference bounds, including the certificate-to-norm
   error transfer, the order-s selected-map estimate, and the uniform passage
   from the coupled family to arbitrary small thresholds?
2. Does a known theorem already imply the completion-specific sharp result
   or the constrained examples? A precise theorem and hypothesis mapping
   would be especially useful.
3. If correct, is this specialization useful enough for a short research note?
   Which claim should be removed or weakened?

[Reproduction instructions](REPRODUCE.md) run twelve exact verification/audit
commands and build/check the PDF without a numerical SDP solver. The optional
full release mode also reruns the joint theorem's numerical operator and SDP
checks in a pinned environment. These are supporting checks, not proof review.
The [combined release report](../research/COMBINED_REVIEW_RELEASE_2026-11-01.md)
records the fresh checkout, environment, results and retained logs.
Crossing uniqueness and publication novelty remain open. The exact joint formula
now has an internal proof awaiting external reconstruction. The methodology disclosure identifies the AI-assisted workflow
as VIBE MATH; it is not a mathematical claim or an endorsement.
