# Short paper for external review

**Stability of a prescribed repeatable completion of a quantum measurement**  
Christopher Gardner, revised 1 November 2026. Fourteen pages including references.

- [Typeset PDF](prescribed_repeatable_completion.pdf)
- [Readable Markdown with resolved references](prescribed_repeatable_completion.md)
- [Standalone LaTeX](prescribed_repeatable_completion.tex)
- [Bibliography](prescribed_repeatable_completion.bib)
- [Focused external-review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md)
- [Concise reviewer packet](../review/REVIEWER_PACKET.md)
- [Isolated certificate and PDF reproduction](../review/REPRODUCE.md)
- [Combined-paper audit](../research/COMBINED_PAPER_AUDIT_2026-11-01.md)
- [Combined reproduction report](../research/COMBINED_REVIEW_RELEASE_2026-11-01.md)

The paper contains the frozen coefficient-two theorem, a complete analytic
proof, the record-correction corollary, the weighted prior-art comparison,
and explicit counterexamples and limitations. Proposition 6 adds the certified
four-dimensional comparison and localized equality point; its computer-assisted
proof includes the linked certificate supplement. Section 7 adds the sharp
perfect-packing theorem, an exact reference-advantage certificate, and a
coupled simplex lower bound with two vetoed upper extensions. Section 8 integrates
Theorem 10, the sharp joint leading envelope, with its upper proof and uniform
limit argument. VIBE MATH appears in the
methodology disclosure, not as a mathematical claim.

The current status is an external-review draft: internally checked, not peer
reviewed, novelty unverified, and not represented as submission-ready.
The [completed reduction audit](../literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
classifies the main bound and record corollary as explicit quantitative
specializations of established tools. External assessment should check that
reduction and evaluate earlier publication and usefulness. No external reviewer has been contacted
by preparing this package.

## Sharpness and reference results

The [perfect-packing note](../theory/perfect_packing_sharpness.md) proves an
exact bound for the prescribed completion when `alpha=1`, together with a
family attaining it. Its [verification report](../research/PERFECT_PACKING_SHARPNESS_2026-11-01.md)
includes exact primal/dual certificates. Its analytic theorem is now included
in the PDF as Theorem 7. The [reference-advantage note](../theory/reference_advantage.md)
and [imperfect-packing construction](../theory/imperfect_packing_lower_bound.md)
are linked proof supplements for Propositions 8--9 and the two upper-bound
vetoes. Theorem 10 determines the joint leading envelope
`sqrt(1-alpha^2+delta)` as `(alpha,delta)->(1,0)`. The exact finite-error
envelope, subleading term and publication novelty remain open.

## Source and build

[arxiv_ready.md](arxiv_ready.md) is the editable manuscript. Its historical
filename does not imply readiness for submission. The other Markdown file,
LaTeX file, and PDF are generated from that source and the BibTeX file.
The LaTeX includes the formatted references, so it can also be compiled on
its own without BibTeX.

With Python 3.10 or later, Pandoc, and Tectonic available, run from the
repository root:

    python scripts/build_short_paper.py

To check the build hashes, equation numbering, citations, certified comparison
values, and PDF rendering, run:

    python scripts/check_short_paper.py

The document checker uses pypdf, pypdfium2, and Pillow; it also finds the
existing ignored laptop copies. Its checks concern document integrity and
consistency, not proof of the theorem.

Explicit executable paths are accepted:

    python scripts/build_short_paper.py --pandoc PATH_TO_PANDOC --tectonic PATH_TO_TECTONIC

The build was tested with Pandoc 3.13 and Tectonic 0.17.0. Obtain these tools
from their official projects:
[Pandoc](https://pandoc.org/installing.html) and
[Tectonic](https://tectonic-typesetting.github.io/en-US/install.html).
On this laptop, the script also finds their portable copies under the ignored
local audit directory. Tectonic caches its TeX support files there on first
use; that cache and the downloaded tools are not repository artifacts.

Build logs and source/artifact hashes are retained in
[the build evidence](../research/short_paper_build/manifest.json).
The [internal review record](../research/SHORT_PAPER_REVIEW_2026-10-31.md)
records the original eight-page revision. The
[1 November revision record](../research/SHORT_PAPER_REDUCTION_REVIEW_2026-11-01.md)
records the earlier ten-page paper and distinguishes document checks,
numerical checks, exact certificate checks, and mathematical review.
The [latest revision report](../research/REFERENCE_AND_PACKING_PROGRESS_2026-11-01.md)
records the earlier twelve-page paper, 33 equations, and twelve references.
The [combined release report](../research/COMBINED_REVIEW_RELEASE_2026-11-01.md)
records the current fourteen-page paper, 40 equations, twelve references and
the fresh reproduction including Theorem 10's numerical operator checks.

## Relationship to the longer material

For a compact comparison example, the
[four-dimensional family note](../theory/completion_switch_family.md)
displays a single varying coupling with certified opposite endpoint
preferences and a proof that the hypotheses hold throughout the interval.
The [subsequent crossover certificate](../research/COMPLETION_CROSSOVER_2026-11-01.md)
localizes at least one equality point to an interval of width 2e-8. The
[updated attribution note](../literature/CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md)
also gives the direct Eldar–Forney identification of both sector constructions.

The subsequent [exact comparison note](../theory/exact_completion_comparison.md)
certifies examples favoring each completion in full diamond distance.
It is a separate computer-assisted addition for review; it does not change
the frozen theorem or constitute an external novelty assessment.

The [frozen theorem](../theory/THEOREM_V1_FREEZE.md) remains the statement
reference. The [theorem-level comparison](../literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
retains the detailed prior-art deductions. The longer research document and
historical imports are supporting records; they are not required to
reconstruct the short paper.
