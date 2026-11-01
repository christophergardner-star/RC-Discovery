# Combined review release

1 November 2026. The fourteen-page manuscript now includes the sharp joint
small-error result as Theorem 10, with the upper proof and joint-limit
argument in Section 8. It has forty numbered equations and twelve references.
The [combined internal audit](COMBINED_PAPER_AUDIT_2026-11-01.md) covers the
new proof and its dependencies on claims 1--9 and their supplements.

The reviewer packet, detailed review questions and unsent invitation now
refer to the combined manuscript. The scientific status remains internally
reconstructed, computationally audited, partially formalised, novelty unverified.

Fresh reproduction is being run from a separate full checkout with a new
Python environment and initially empty TeX cache. The pinned numerical and
PDF packages were installed from checksum-verified PyPI wheels after the
initial index-based dependency resolution stalled. The installation exited
successfully; its [log](combined_review_release_2026-11-01/installation.log)
and [wheel manifest](combined_review_release_2026-11-01/wheel_manifest.json)
record the actual packages. This report will be completed with the command
manifest and artifact comparison when the fresh run finishes.

The scope is the current paper and its computational dependencies. Historical
experiments, optional neural experiments and full Lean formalisation are not
represented as completed by this release. No external researcher has been
contacted. Correctness review, publication priority and further mathematical
questions remain distinct from local package completion.
