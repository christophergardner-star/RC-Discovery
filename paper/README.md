# Short paper for external review

**Stability of a prescribed repeatable completion of a quantum measurement**  
Christopher Gardner, 31 October 2026.

- [Typeset PDF](prescribed_repeatable_completion.pdf)
- [Readable Markdown with resolved references](prescribed_repeatable_completion.md)
- [Standalone LaTeX](prescribed_repeatable_completion.tex)
- [Bibliography](prescribed_repeatable_completion.bib)
- [Focused external-review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md)

The paper contains the frozen coefficient-two theorem, a complete analytic
proof, the record-correction corollary, the weighted prior-art comparison,
and explicit counterexamples and limitations. VIBE MATH appears in the
methodology disclosure, not as a mathematical claim.

The current status is an external-review draft: internally checked, not peer
reviewed, novelty unverified, and not represented as submission-ready.
The next assessment is independent reconstruction and an exact implication
comparison with existing results. No external reviewer has been contacted
by preparing this package.

## Source and build

[arxiv_ready.md](arxiv_ready.md) is the editable manuscript. Its historical
filename does not imply readiness for submission. The other Markdown file,
LaTeX file, and PDF are generated from that source and the BibTeX file.
The LaTeX includes the formatted references, so it can also be compiled on
its own without BibTeX.

With Python 3.10 or later, Pandoc, and Tectonic available, run from the
repository root:

    python scripts/build_short_paper.py

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
distinguishes document checks, numerical checks, and mathematical review.

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
