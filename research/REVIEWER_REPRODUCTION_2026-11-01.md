# Finished-paper reproduction and review package

1 November 2026. All three requested tasks are completed within their stated
local scope: internal proof reconstruction, a focused prior-art veto, and
isolated reproduction with a reviewer packet. Novelty and external review
remain unresolved; this report does not convert internal checks into either.

## Results and corrections

The [proof audit](FINAL_PROOF_AUDIT_2026-11-01.md) reconstructs every numbered
claim and the supporting counterexamples, including reference-assisted bounds
and the certificate error transfers. It found no fatal mathematical gap in
the arguments reviewed. A malformed TeX command in the coupled-simplex
supplement was corrected. No theorem statement or numerical bound changed.

The [focused literature comparison](../literature/FINAL_FOCUSED_VETO_2026-11-01.md)
checks the sharp gentle-measurement ingredient, projective-measurement
discrimination theorem and fusion-frame simplex theorem directly. It identifies
what is established and what the constrained completion statements additionally
specify. No exact combined match was found in the inspected sources. This
bounded result cannot certify originality or exclude an easy further reduction.

## Fresh reproduction

The successful source revision was
`dbbdd7406d69bad51fd7f17c0637baf294aa284b`.
A separate full local clone was created with `git clone --no-local --no-hardlinks`.
It used a new virtual environment without system site packages and an initially
empty Tectonic cache. Existing Pandoc and Tectonic executable binaries were
reused by explicit absolute path; their versions and SHA256 hashes are retained
in the [run manifest](reviewer_reproduction/manifest.json). This is isolation
on the same Windows laptop, not a different machine or an external reproducer.

The environment used Python 3.12.10, Pandoc 3.13, Tectonic 0.17.0, pypdf
6.21.4, pypdfium2 5.14.0 and Pillow 13.0.0. Initial package installation
reported success but did not terminate promptly afterward; that installer
process was stopped. A subsequent isolated, no-index installation check with
pip's version check disabled exited successfully with all pinned requirements
satisfied. The successful runner imported and used those packages.

The first isolated attempt found that two older audit scripts could not import
their sibling verifier modules under `-I -S`. Their imports were corrected,
committed and pulled into the separate checkout. The complete run then passed:

| Verification group | Outcome |
| --- | --- |
| Original exact comparison | Exact verifier passes; 11 expected rejections and 66 integer determinant positivity checks |
| Uniform comparison family | Exact verifier passes; 10 expected rejections and 73 integer determinant positivity checks |
| Crossing bracket | Exact verifier passes; 12 expected rejections and 139 integer determinant positivity checks |
| Perfect-packing sharpness witnesses | Exact verifier passes; 16 rejection controls, 259 PSD decisions and 15,197 integer principal minors |
| Reference advantage | Exact verifier passes; 13 rejection controls, 289 positive matrices and 5,764 integer leading minors |
| Imperfect-packing vetoes | Exact verifier passes; 10 rejection controls, 6 positive matrices and 42 integer leading minors |
| Paper build and document checks | Both pass: 12 pages, 33 numbered equations, 12 references; all pages render |

These are twelve certificate/audit commands plus two document commands.
The groups overlap in data and checks, so their counts should not be added
and described as independent experiments. Every exact command used `-I -S`;
no NumPy, CVXPY or numerical solver participated in acceptance.
The [numbered logs](reviewer_reproduction/manifest.json) retain commands,
exit codes and durations. The fresh-cache build log records the TeX downloads.
Nonfatal Fontconfig messages remain documented; no overflow, missing glyph
or unresolved citation finding was reported by the document checker.

The resulting PDF SHA256 is
`dea5758a8299f6855c9a73f91a1000f1b51516ad8fa0f6d8f047001d6f3a9394`.
The PDF's supplement URL now pins the corrected proof. Extracted text is
identical on all twelve pages to the previous PDF; see the
[page comparison](reviewer_reproduction/comparison.json). The raw PDF is not
byte-identical, and byte identity is not claimed. The rendered contact sheet
was visually inspected for clipping and layout problems; none were apparent.

## Deliverables and limits

- [Concise reviewer packet](../review/REVIEWER_PACKET.md).
- [Reproduction instructions](../review/REPRODUCE.md), pinned PDF dependencies
  and a runner that stops on the first failure.
- [Unsent invitation draft](../review/REVIEW_INVITATION_DRAFT.txt). No recipient
  was chosen and no external message was sent.

This pass did not rerun historical numerical searches or the existing partial
Lean development. Exact witness verification is intentionally separate from
search. No full Lean proof, unique crossover, sharp joint upper envelope for
general packing, external validation or confirmed novelty is claimed.
