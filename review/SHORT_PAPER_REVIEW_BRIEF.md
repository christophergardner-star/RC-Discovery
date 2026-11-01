# Review brief: prescribed repeatable measurement completion

Prepared 31 October; revised 1 November 2026 for independent mathematical review. This is a local
review packet, not a record of external review or a message sent to a reviewer.

## Material to review

Start with the short paper:

- [PDF](../paper/prescribed_repeatable_completion.pdf)
- [LaTeX source](../paper/prescribed_repeatable_completion.tex)
- [Readable Markdown](../paper/prescribed_repeatable_completion.md)

Use the [statement-and-proof comparison](../literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
and [completed reduction audit](../literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
for the prior-art analysis. The latter supplies the explicit implication chain
for the unweighted bound and record corollary. The older long research document and historical
imports are not needed to assess this paper.

## Subsequent sharpness supplement

The [perfect-packing proof](../theory/perfect_packing_sharpness.md) is an
additional review target, separate from the current PDF. It claims the exact
worst-case prescribed-completion envelope `2*sqrt(delta)/(2-sqrt(delta))`
under `alpha=1`. Please reconstruct the positive-residual factorization,
the arbitrary-reference trace-norm estimate, its scalar maximization, and
the full-threshold-sector check for the attaining family. The
[exact certificate report](../research/PERFECT_PACKING_SHARPNESS_2026-11-01.md)
and [attribution scope note](../literature/PERFECT_PACKING_SHARPNESS_ATTRIBUTION_2026-11-01.md)
provide further checks and identify the unresolved priority question.
This result does not settle optimality for general `alpha<1`.

## Precise proposed contribution

For a finite POVM, choose the full spectral sectors at or above `1-delta` and
assume their synthesis map `T` is injective. The paper controls the particular
unweighted polar completion

\[
T=U|T|,\qquad Q_j=UC_jU^*,\qquad
F_j=Q_j+RE_jR,\qquad R=I-UU^*.
\]

Its intended contribution is an explicit quantitative specialization for
this prescribed correction and, with extra record assumptions, correction
to an exactly idempotent measure-and-prepare channel. It is not presented as
a new general orthogonalization, dilation, Jordan-product, or idempotent
structure theorem. The weighted polar alternative from existing machinery
must be considered when judging whether the prescribed construction adds
useful content.

The local reduction uses no new general lemma. The measurement-specific work
is the residual-preserving labelled dilation and its identities; classical
inequalities and elementary conditioning complete the bounds. An implication
proof is supplied for review, rather than left as a task for the referee.

## Questions for a correctness referee

A subsequent [exact comparison note](../theory/exact_completion_comparison.md)
and [rational certificates](../research/EXACT_COMPARISON_2026-11-01.md) give
opposite distance orderings for the two completions. Its spectral-to-polar
error bounds and exact SDP certificates are additional review targets.
This addition does not alter the frozen statement or settle its priority.
The [four-dimensional one-parameter family](../theory/completion_switch_family.md)
is the simpler presentation: its displayed matrices, uniform packing bound,
and continuity argument are further concrete targets for reconstruction.
The [additional crossover certificate](../research/COMPLETION_CROSSOVER_2026-11-01.md)
localizes at least one equality point to (2.33690021, 2.33690023), without
asserting uniqueness. The [latest attribution audit](../literature/CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md)
identifies both sector polar formulas with Eldar–Forney's established
least-squares measurements. Assess the quantitative application and comparison,
not originality of the orthogonalization constructions.

1. **Hypotheses and domains.** Are zero effects removed consistently, full
   spectral sectors used at the stated closed threshold, and injectivity
   distinguished from a rectangular singular-value convention? Are
   `T`, `U`, the original-sector labelled inclusion `J`, and `W` correctly
   typed throughout?
2. **Construction and gap.** Do the sector-angle estimate, labelwise
   cross-zero identities, hybrid isometry, exact compression, and residual
   spectral bound follow from the stated hypotheses alone?
3. **Operational estimate.** Is the Jordan-product condition used only in
   the justified parameter region, and does the case split prove the
   unconditional coefficient-two bound? Does the proof cover arbitrary
   reference systems with the full diamond norm, whose ceiling is two?
4. **Record corollary.** Is the margin the distance to the entire competing
   convex hull, rather than pairwise distance? Does accessibility control
   individual record residuals? Are zero projection weight, one nonzero
   label, and zero effects handled? Does the constructed channel satisfy
   exact idempotence without an additional assumption?
5. **Examples and limitations.** Are bounds against the prescribed
   construction clearly distinguished from bounds against every repeatable
   target? Does the square-root lower-bound proof establish exactly its
   claimed scope? Is threshold discontinuity described as a limitation of
   this selection rule, rather than a failure of the pointwise theorem?

## Questions for a prior-art referee

The central question is: **Is this explicit quantitative specialization,
including its limitations and certified comparison, already documented,
and does it add useful content?** Please check the supplied reduction,
not merely whether the final formula appears verbatim elsewhere. In particular:

- Does the supplied reduction of the **unweighted** completion bound,
  including the principal-angle estimate and the conditional Jordan-product
  substitution, omit a hypothesis or import a conclusion incorrectly? Is an
  earlier combined statement or a shorter derivation available?
- The weighted construction is an elementary adaptation of published polar
  machinery and already provides a strong existential measurement bound.
  Does retaining the prescribed unweighted construction have a useful
  mathematical or operational reason, or should this paper be framed simply
  as an expository corollary?
- Does an existing record-stability theorem already give the explicit
  correction of the supplied effects and states with these parameters?
  The endpoint's exact classical encoding/decoding structure, accessibility
  estimate's elementary norm argument, convex-hull conditioning, and gentle
  projection are explicitly credited as established or elementary tools.
- Are the closest hypotheses, norms, quantifiers, and conclusions compared
  accurately? Identify any overlooked source or stronger available result.

Relevant primary sources are
[Eldar–Forney, Theorem 2 and Section V](https://www.weizmann.ac.il/math/yonina/sites/math.yonina/files/quantumDetection_0.pdf),
[de la Salle, v2, Theorems 1.1--1.2 and Section 3](https://arxiv.org/pdf/2103.14126v2),
[Kretschmann--Schlingemann--Werner](https://arxiv.org/html/0710.2495),
[de Bruijn, Theorem 3.2](https://pure.tue.nl/ws/portalfiles/portal/2165089/597564.pdf),
[Kotowski--Oszmaniec, Theorem 6](https://arxiv.org/pdf/2501.09339v1), and
[Kitaev, v2, Theorems 1.2 and 12.3](https://arxiv.org/html/2405.02434v2).
The comparison report records the exact reductions and additional sources.

## Requested review outcome

For each concern, identify the exact proposition or proof step, give a
counterexample or missing argument where possible, and classify the concern
as fatal, repairable, or expository. For overlap, distinguish an exact prior
statement, a direct corollary, an elementary adaptation, and a genuinely
additional argument. An assessment that the result is correct but only an
elementary specialization is a useful outcome.

Numerical tests and partial Lean checks are supporting evidence. They do not
replace review of the complete analytic proof; the full channel theorem is
not yet formalized. No literature-priority or optimal-constant claim is
assumed in requesting this review.
Proposition 6 is explicitly computer-assisted and requires its rational
certificate supplement; the analytic main theorem does not depend on those
computations. No external reviewer has been contacted.
