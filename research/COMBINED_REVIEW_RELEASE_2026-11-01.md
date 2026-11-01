# Combined review release

1 November 2026. The fourteen-page manuscript now includes the sharp joint
small-error result as Theorem 10, with the upper proof and joint-limit
argument in Section 8. It has forty numbered equations and twelve references.
The [combined internal audit](COMBINED_PAPER_AUDIT_2026-11-01.md) covers the
new proof and its dependencies on claims 1--9 and their supplements.

The reviewer packet, detailed review questions and unsent invitation now
refer to the combined manuscript. The scientific status remains internally
reconstructed, computationally audited, partially formalised, novelty unverified.

## Completed fresh reproduction

All fifteen commands passed at source revision
`2747104488cbe9292bedf5aa8ab9b0b0fb0b7ddb`:

- Twelve exact certificate/verifier audit commands, run with `-I -S` and no
  scientific packages. They cover the comparison examples, uniform family,
  crossing bracket, perfect-packing witnesses, reference advantage and
  imperfect-packing vetoes, including the existing corruption controls.
- The joint-theorem numerical audit, run with `-I`: 96 operator cases,
  1,440 input checks, twenty structured witnesses and five full diamond
  primal/dual SDP comparisons. These remain numerical support for the
  analytic theorem, not exact certificates or a universal proof.
- The PDF build and document checker: fourteen pages, forty numbered
  equations, twelve resolved references, matching source/artifact hashes,
  and successful rendering of every page.

The [command manifest](combined_review_release_2026-11-01/manifest.json)
records every exit code, duration, package version, tool hash and numbered
log. The full local clone used `--no-local --no-hardlinks`, a new Python
environment with system site packages disabled, and an initially empty TeX
cache. Existing Pandoc 3.13 and Tectonic 0.17.0 binaries were reused explicitly.
This is isolation on the same Windows laptop, not independent external
reproduction or proof review.

The pinned numerical and PDF packages were installed from checksum-verified
PyPI wheels after the initial index-based dependency resolution stalled.
The installation exited successfully and `pip check` reported no broken
requirements. Its [log](combined_review_release_2026-11-01/installation.log)
and [wheel manifest](combined_review_release_2026-11-01/wheel_manifest.json)
record the actual packages, including transitive dependencies. The
[reproduction instructions](../review/REPRODUCE.md) describe both the normal
installation and this fallback.

The existing OSQP import warning also occurred in the fresh environment;
the five numerical SDPs used CLARABEL and passed. Tectonic emitted its
nonfatal Fontconfig messages. No overflow, missing-character or unresolved
reference finding was reported by the document checker.

## Artifact comparison and review package

The [comparison record](combined_review_release_2026-11-01/comparison.json)
confirms identical normalized generated TeX and Markdown and identical
extracted text on all fourteen pages between the cached and fresh builds.
Raw PDF bytes differ; byte-identical PDF reproduction is not claimed.
The released fresh PDF has SHA256
`431def7eb85a3ef9016dc8c162bb8c15ed58d935fe47e6e04a5f8dc72b768785`.
The rendered contact sheet and the new theorem's pages were visually
inspected; no clipping or layout defect was apparent.

The [reviewer packet](../review/REVIEWER_PACKET.md),
[detailed review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md),
[unsent invitation](../review/REVIEW_INVITATION_DRAFT.txt) and canonical status
pages now refer consistently to the combined paper and its limits. The
substantive proof/code sources tested at the revision above are unchanged
by the final commit retaining this report and the fresh build evidence.

## Completion boundary

The agreed local preparation is complete: integration, combined internal
proof audit, fresh reproduction, PDF rebuild and reviewer-package update.
The package is ready to request independent specialist review; it is not
represented as peer reviewed, novelty confirmed or submission-ready.

The scope is the current paper and its computational dependencies. Historical
experiments, optional neural experiments and full Lean formalisation are not
represented as completed by this release. No external researcher has been
contacted. Correctness review, publication priority and further mathematical
questions remain distinct from local package completion. The exact general
finite-error envelope, sharp subleading term and crossing uniqueness remain
open; pursuing them or full Lean formalisation would be further work.
