# Reviewer packet

**Christopher Gardner — Stability of a prescribed repeatable completion of a
quantum measurement.** Twelve-page internal review draft, 1 November 2026.

Read the [paper](../paper/prescribed_repeatable_completion.pdf), then the
[proof audit](../research/FINAL_PROOF_AUDIT_2026-11-01.md) and
[focused prior-art comparison](../literature/FINAL_FOCUSED_VETO_2026-11-01.md).
The work is internally reconstructed, computationally audited, partially
formalised, novelty unverified. No external review is represented as completed.

For a finite POVM with nonzero full near-unit sectors and injective synthesis
map `T=U|T|`, the object is the specified same-label completion
`F_j=UC_jU*+RE_jR`, where `R=I-UU*`. Norms are unhalved diamond norms.
The general bound is a quantitative application of established tools.
The strongest additional candidate is the exact worst-case formula
`2 sqrt(delta)/(2-sqrt(delta))` when `alpha=1`, with attainment throughout
`0<delta<1/2`. The further claims are a certified reference advantage and
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
   error transfer?
2. Does a known theorem already imply the completion-specific sharp result
   or the constrained examples? A precise theorem and hypothesis mapping
   would be especially useful.
3. If correct, is this specialization useful enough for a short research note?
   Which claim should be removed or weakened?

[Reproduction instructions](REPRODUCE.md) run twelve exact verification/audit
commands and build/check the PDF without a numerical SDP solver. These checks
are evidence for the computational claims, not a substitute for proof review.
The [completed local reproduction report](../research/REVIEWER_REPRODUCTION_2026-11-01.md)
records the isolated environment, fixes, results and retained logs.
The general sharp joint envelope, crossing uniqueness and publication novelty
remain open. The methodology disclosure identifies the AI-assisted workflow
as VIBE MATH; it is not a mathematical claim or an endorsement.
