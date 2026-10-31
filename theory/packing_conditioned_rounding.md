# Historical Note: Packing-Conditioned Moving-POVM Rounding

**Status:** superseded intermediate result; retained for development history

This note originally recorded the stage at which synthesis packing and the residual completion had been established, but the available channel estimate still carried an explicit outcome-count factor.

## Durable results from that stage

The following facts survived into the canonical theorem:

- the synthesis operator
  \[
  T:\bigoplus_j\operatorname{ran}(P_j)\to\mathcal H,
  \qquad T(x_j)=\sum_jx_j;
  \]
- the packing condition \(\alpha=\sigma_{\min}(T)>0\);
- polar construction of mutually orthogonal sectors;
- the all-rank movement estimate
  \[
  \|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2};
  \]
- the same-label residual completion
  \[
  F_j=Q_j+RE_jR;
  \]
- the spectral-gap estimate
  \[
  \gamma_F\ge\delta;
  \]
- the explicit counterexample showing that threshold-only movement may require order \(\sqrt\delta\), so a universal linear \(O(\delta)\) rate is false.

## What is no longer current

The old note bounded channel movement by summing per-effect errors and therefore introduced an \(m\)-factor. The typed hybrid Stinespring construction later removed that proof artifact for the canonical same-label completion.

The current internal estimate is

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
\]

## Canonical replacements

- [`THEOREM_V1_FREEZE.md`](THEOREM_V1_FREEZE.md);
- [`same_label_dimension_free_theorem.md`](same_label_dimension_free_theorem.md);
- [`BOUND_CANDIDATE_2026-10-31.md`](BOUND_CANDIDATE_2026-10-31.md);
- [`RESIDUAL_COUPLING_RATES_2026-10-31.md`](RESIDUAL_COUPLING_RATES_2026-10-31.md).

The detailed historical derivation remains in Git history and the synchronized source snapshot. It is not the current theorem statement.
