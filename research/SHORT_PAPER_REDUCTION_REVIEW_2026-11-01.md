# Prescribed-bound reduction and short-paper revision

1 November 2026. Internal audit and document revision; no external review.

## Deliverables

- [Complete proof-level reduction](../literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
- [Revised ten-page paper](../paper/prescribed_repeatable_completion.pdf)
- [Editable manuscript](../paper/arxiv_ready.md), [readable version](../paper/prescribed_repeatable_completion.md), [standalone LaTeX](../paper/prescribed_repeatable_completion.tex)
- [Focused review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md)

The frozen theorem and certificate proof sources are unchanged. The manuscript
now explicitly identifies both sector polar constructions with Eldar–Forney,
supplies the dependency classification, and includes the certified comparison
as Proposition 6. There are 26 numbered equations and nine primary references.
The certificate supplement is pinned to Git commit
`d706872d89503f5c6f9e59d8f91b518bec9991b1` for reproducibility.

## Audit conclusion and limits

The unweighted bound reduces to established polar geometry, the classical
Jordan-product bound, and the pure-state trace-distance formula once the
prescribed labelled dilation is verified. The record correction adds
elementary accessibility, convex-hull separation, spectral compression, and
normalized gentle projection. No additional general lemma is required.
This is an explicit quantitative specialization. The age of its ingredients
alone does not decide publication novelty of the combined statement.

The audit checked domains, zero labels, a single active label, arbitrary sector
ranks, spectral degeneracy within sectors, the auxiliary width condition and
its removal in the informative regime, and reference-assisted inputs. No
substantive defect was identified in this internal reconstruction.

Several distinctions were made explicit:

- The generic estimate \(2\|W-V\|\) alone gives a weaker constant than the
  pure-state overlap argument actually used.
- Weighted least-squares column weights are \(\sqrt{\lambda_a}\); the
  corresponding state priors are proportional to \(\lambda_a\).
- A state-dependent rounding theorem cannot simply be renamed a diamond-norm
  theorem. The explicit overlap calculation supplies the uniform bound.
- A smaller upper envelope for the weighted construction does not imply a
  smaller actual distance. Proposition 6 supplies exact counterexamples to
  both proposed dominance directions.
- The localized equality point is an existence statement. Uniqueness,
  optimality of either completion, and novelty of the examples are unproved.

The analytic main theorem and record corollary remain self-contained in the
paper. Proposition 6 is computer-assisted and explicitly depends on the linked
certificate data and analytical error-bound supplement. No claim of a complete
Lean formalization or independent specialist review was added.

## Checks run for this revision

| Check | Result | Scope |
|---|---|---|
| Frozen theorem contract, without new SDPs | 10 valid cases and 16 expected rejections passed; maximum identity error 6.418476861114186e-15 | Finite floating-point diagnostics; no universal proof |
| Threshold obstruction family | Passed at delta = 1e-2, 1e-4, 1e-6, 1e-8 | Finite support for the analytic lower-bound construction |
| Exact crossover verifier | Passed both strict signs in (2.33690021, 2.33690023), and reran the uniform family certificate | Exact rational inequalities plus the written analytic bridge |
| Independent determinant/corruption audit | 139 determinant checks and 12 rejection controls passed | Both uniform-family and new endpoint certificate inequalities |
| Paper build and document checker | Ten pages rendered; 26 equation numbers and nine references checked; source/artifact hashes match | Document integrity, not mathematical proof |
| Repository claim discipline | 30 required files, eight source Git objects, and 62 local links passed | Repository consistency, not novelty verification |

The document checker also compares the new proposition's numerical assertions
against the retained exact results and verifies their source hashes. All ten
pages were rendered, the contact sheet was inspected, and the comparison and
reference pages were inspected at readable resolution. There were no TeX
overfull-box, missing-character, or undefined-reference findings. Fontconfig
configuration/cache messages remain an environment issue; compilation and
rendering succeed.

The revision does not change operator code, the Lean development, or the frozen
theorem. The earlier whole-repository suite and earlier numerical SDP search
were not rerun; they are not presented as fresh results.

Reproduction:

```powershell
.venv-audit/Scripts/python.exe experiments/test_theorem_v1_contract.py --skip-sdp
.venv-audit/Scripts/python.exe experiments/test_spectral_threshold_rate.py
python -I -S experiments/verify_completion_crossover.py
python -I -S experiments/check_completion_crossover.py
python scripts/build_short_paper.py
python scripts/check_short_paper.py
python experiments/test_repository_claim_discipline.py
```

Build provenance is in [the manifest](short_paper_build/manifest.json);
[document checks](short_paper_build/document_checks.json) identify the PDF by
hash. The manifest's source revision is the base commit used for the build;
its explicit source hashes include the subsequent manuscript edits.

## External question

The review packet now asks whether the supplied reduction is correct, whether
the resulting quantitative specialization and comparison are already documented,
and whether they solve a useful problem. This makes the result concrete enough
to challenge without asking a reviewer to discover the implication chain first.
No messages were sent and no external review outcome is claimed.
