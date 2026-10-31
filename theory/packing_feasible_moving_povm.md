# Historical Note: Packing-Feasible Moving-POVM Boundary

**Status:** superseded intermediate audit; not the canonical channel theorem

This file originally summarized the programme after the packing geometry was understood but before the same-label dimension-free channel estimate had been reconstructed.

## Results that remain valid

- A positive synthesis lower bound \(\alpha=\sigma_{\min}(T)>0\) detects the global packing obstruction.
- The polar factor constructs mutually orthogonal sectors of the same ranks.
- For all ranks,
  \[
  \|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}.
  \]
- The completion
  \[
  F_j=Q_j+RE_jR
  \]
  retains the labels and gives exact unit sectors.
- A threshold-only theorem must allow square-root dependence on \(\delta\).
- Polar orthogonalisation and general POVM projectivisation are prior art; only the fully combined record-stability chain is under novelty review.

## Superseded statement

The former note said an outcome-count-independent estimate for the channel movement remained open. That is no longer the canonical internal status. The typed hybrid dilation now gives the theorem candidate

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
\]

The result remains externally unverified and novelty-unverified.

## Canonical replacements

- [`THEOREM_V1_FREEZE.md`](THEOREM_V1_FREEZE.md);
- [`same_label_dimension_free_theorem.md`](same_label_dimension_free_theorem.md);
- [`BOUND_CANDIDATE_2026-10-31.md`](BOUND_CANDIDATE_2026-10-31.md);
- [`../research/FULL_WORK_AUDIT_2026-10-31.md`](../research/FULL_WORK_AUDIT_2026-10-31.md).

The original detail is preserved by Git history and by the imported Cruxy research snapshot.
