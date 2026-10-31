# Adversarial Theorem Audit: Same-Label Dimension-Free Bound

**Date:** 31 October 2026  
**Status:** No counter-example found; bound holds with large margin in tested regimes

## Claim under attack

For the same-label completion \(F_j = Q_j + R E_j R\),
\[
\nu = \|\mathcal M_E - \mathcal M_F\|_\diamond \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big).
\]

## Probes performed

Pure-state total-variation proxy (and one ancilla-assisted case) under:

| Case | α | ν_proxy | claimed bound | ratio |
|------|---|----------|---------------|-------|
| tiny α | 0.08 | 0.29 | 5.25 | 0.056 |
| δ → 0 | 0.97 | 0.015 | 1.17 | 0.013 |
| many outcomes (m=16) | 0.95 | 0.035 | 2.19 | 0.016 |
| high-rank sectors (r=2) | 0.96 | 0.018 | 2.00 | 0.009 |
| large δ | 0.95 | 0.17 | 3.79 | 0.045 |
| α → 0 | 0.02 | 0.40 | 4.89 | 0.081 |
| ancilla-assisted | 0.97 | 0.019 | 1.86 | 0.010 |

In every case the observed distance is well below the claimed bound (ratios ≤ 0.08).

## Observations

- No linear growth with m appears.
- High-rank sectors do not break the scaling.
- Extreme residual or near-degenerate packing remain inside the bound.
- Ancilla-assisted pure inputs do not inflate the proxy beyond the pure-state case.

## Limitations of the audit

- Proxy is pure-state TV, not a full diamond-norm SDP. Ancilla dimension was modest.
- High-rank implementation used a simplified grouping; a fully rigorous multi-dimensional polar construction was not re-derived here.
- Degenerate eigenvalues and nonzero classical labels with tiny sectors were only partially probed.

## Verdict

No counter-example to \(\nu \le 4(\sqrt{1-\alpha^2} + \sqrt{\delta})\) was found under the tested adversarial conditions. The constant 4 appears conservative. The bound is consistent with the hybrid isometry construction and survives the extreme regimes examined.

Next recommended attack: full diamond-norm computation (or larger ancilla) on a few carefully chosen near-degenerate cases, and a tighter analytic constant.
