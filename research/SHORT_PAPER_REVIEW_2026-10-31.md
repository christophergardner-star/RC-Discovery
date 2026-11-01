# Short-paper preparation and internal review

Date: 31 October 2026.

Historical record of the original eight-page revision. The linked manuscript
has since been updated; see the
[1 November reduction and revision record](SHORT_PAPER_REDUCTION_REVIEW_2026-11-01.md)
for the current ten-page paper and its checks.

The deliverable is the eight-page paper
[Stability of a prescribed repeatable completion of a quantum measurement](../paper/prescribed_repeatable_completion.pdf),
with [readable Markdown](../paper/prescribed_repeatable_completion.md),
[editable source](../paper/arxiv_ready.md),
[standalone LaTeX](../paper/prescribed_repeatable_completion.tex),
and [bibliography](../paper/prescribed_repeatable_completion.bib).
The [review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md) specifies the
correctness and prior-art questions for an external researcher.

## Mathematical content and scope

The paper preserves the hypotheses and coefficient-two conclusion of the
[frozen theorem](../theory/THEOREM_V1_FREEZE.md). It supplies the full analytic
argument: sector geometry, residual spectral gap, correctly typed labelled
dilation, vanishing cross terms, isometry and compression identities,
Jordan-product overlap estimate, and reference-assisted channel bound.
The record corollary includes accessibility, convex-hull separation,
projection of the supplied states, exact idempotence, and a quantitative
distance estimate.

The weighted comparison is presented as an adaptation of established polar
machinery. The positive-matrix lemma is explicitly attributed to the
Strang--de Bruijn Jordan-product bounds. General orthogonalization,
Stinespring continuity, and exact encoding/decoding structure are not
claimed as new. The remaining question concerns the prescribed unweighted
completion and the supplied-record correction, including whether these are
direct or elementary consequences of existing work. See the detailed
[theorem-level comparison](../literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md).

Proposition 5 gives a complete lower-bound argument for the existing
four-dimensional threshold family. Its quantifier covers every repeatable
POVM on that space with the same three labels. The lower bound is
sqrt(delta)/(4 sqrt(3)), with alpha equal to one. This establishes the
square-root threshold obstruction for that target class; it does not prove
the optimal coefficient, optimal packing dependence, or literature priority.
Other examples separate repeatable from projective approximation, expose
the accessibility endpoint, and show discontinuity of the threshold selection.

## Internal mathematical review

Three separate AI-assisted review tasks examined the main operator proof,
the record corollary and examples, and the theorem-level attribution.
No substantive defect was found in those reviews. Their clarifications were
incorporated: the threshold is closed, all norms are unhalved, zero effects
have zero instrument maps, the one-active-label record case is separate,
and a state is explicitly supplied when projected record weight is zero.
The square-root lower-bound argument was checked in two of the review tasks.

These are internal checks using related AI systems, not independent human
refereeing. Agreement among them is not evidence of originality and does
not establish the universal theorem by computation. No external researcher
has been contacted as part of preparing this package.

## Checks performed during preparation

| Check | Result and limit |
| --- | --- |
| Frozen-theorem contract, with SDP checks skipped | Passed 10 valid cases and 16 expected rejections; maximum identity error 6.418476861114186e-15. Finite numerical evidence only. |
| Spectral-threshold family | Passed at delta = 1e-2, 1e-4, 1e-6, 1e-8; alpha = 1 and coupling = sqrt(delta)/4. The universal lower bound is proved analytically in the paper. |
| Repository claim discipline | Passed 30 required files and eight source Git-object comparisons; linked documents were checked. |
| Bibliography | Eight primary references resolved; attribution and cited theorem scopes reviewed internally. |
| Document build | Pandoc 3.13 and Tectonic 0.17.0 produced an eight-page PDF and standalone LaTeX. |
| Document integrity | Equation numbers 1 through 23 appear in sequence; source math delimiters balance; source and artifact hashes match the build manifest. |
| PDF inspection | All eight pages rendered successfully; title and author metadata and extracted text checked; typeset equations and reference layout inspected. |

The numerical contract was run with:

    .venv-audit/Scripts/python.exe experiments/test_theorem_v1_contract.py --skip-sdp
    .venv-audit/Scripts/python.exe experiments/test_spectral_threshold_rate.py

The claim-discipline check and document build are reproducible with:

    python experiments/test_repository_claim_discipline.py
    python scripts/build_short_paper.py

The earlier 104 weighted-construction checks and six primal/dual SDPs cited
in the paper belong to the recorded prior-art comparison. They are not
represented as newly run during document preparation. The existing 13
constituent Lean declarations were not expanded into a formal proof of the
operator/channel theorem, and the entire repository suite was not rerun for
this manuscript change.

The [build manifest](short_paper_build/manifest.json) records tool versions,
LF-normalized source hashes, and the PDF hash. Its source revision identifies
the repository base used for the build; the explicit hashes identify the
manuscript and build sources including then-uncommitted changes.
[Document checks](short_paper_build/document_checks.json) are tied to the
same PDF hash. The LaTeX log has no overfull-box, missing-character, or
undefined-reference findings. The compiler console does report local
Fontconfig configuration/cache messages; PDF generation and rendering
nevertheless completed successfully.

## Status after preparation

The deliverable is a complete short external-review draft, not a submission
or an external validation result. VIBE MATH is disclosed as methodology.
The decisive next milestone is a researcher independently reconstructing
the proof and identifying an exact prior statement, a direct corollary,
an elementary adaptation, or a genuinely additional argument. Correctness,
novelty, optimality, and practical usefulness remain separate assessments.
