# Historical Note: Dimension-Free Naimark Completion Route

**Status:** superseded development note; not a canonical theorem statement

This file originally recorded an intermediate Naimark-completion construction developed before the exact same-label hybrid dilation was identified. The original text also contained damaged mathematical markup from an earlier conversion and should not be cited.

## What the route established internally

The intermediate construction indicated that a common Naimark/Stinespring dilation could remove the naive outcome-count factor in measurement-channel movement. It produced an existence-level repeatability-admissible completion with square-root dependence on packing and threshold defects.

## Why it is superseded

The later typed hybrid construction gives the specific same-label completion

\[
F_j=Q_j+RE_jR
\]

exactly, using

\[
V=J_{\mathcal K}U^*+WR.
\]

That construction simultaneously supplies:

- the original outcome alphabet;
- exact implementation of the residual completion;
- the repeatability gap \(\gamma_F\ge\delta\);
- the current dimension-free movement estimate
  \[
  \|\mathcal M_E-\mathcal M_F\|_\diamond
  \le
  2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.
  \]

## Canonical replacements

Read instead:

- [`THEOREM_V1_FREEZE.md`](THEOREM_V1_FREEZE.md);
- [`same_label_dimension_free_theorem.md`](same_label_dimension_free_theorem.md);
- [`BOUND_CANDIDATE_2026-10-31.md`](BOUND_CANDIDATE_2026-10-31.md);
- [`../research/CERTIFICATE_PROGRESS_2026-10-31.md`](../research/CERTIFICATE_PROGRESS_2026-10-31.md).

The full historical development remains recoverable from Git history and the exact Cruxy snapshot under `imports/`. This short file exists only to prevent an obsolete and malformed intermediate note from being mistaken for the current result.
