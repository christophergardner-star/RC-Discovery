# Constant Tightening and Rate Sharpness

**Date:** 31 October 2026  
**Status:** Empirical; constant 4 is conservative

## Empirical ratios for \(\varepsilon = \|V - W\|_\infty\)

Across rank-1 trials with varying \(m\), \(\alpha\), \(\delta\):

- Observed \(\varepsilon / (\sqrt{1-\alpha^2} + \sqrt{\delta})\) ranges from ~0.13 to ~0.63.
- Maximum ratio in the tested set: 0.63.
- Safe empirical constant for \(\varepsilon\): ~0.8.
- Safe empirical constant for \(\nu \le 2\varepsilon\): ~1.6.

The analytic claim \(\nu \le 4(\sqrt{1-\alpha^2} + \sqrt{\delta})\) therefore has roughly a factor-of-two slack in the regimes examined.

## Rate checks

**\(\sqrt{\delta}\) rate** (fixed high \(\alpha\), vary \(\delta\)):

| \(\delta\) | \(\varepsilon\) | \(\varepsilon/\sqrt{\delta}\) |
|----------|---------------|--------------------------|
| 0.001 | 0.023 | 0.73 |
| 0.005 | 0.056 | 0.79 |
| 0.02 | 0.102 | 0.72 |
| 0.08 | 0.202 | 0.71 |
| 0.20 | 0.321 | 0.72 |

The ratio is stable, supporting that \(\sqrt{\delta}\) is the correct leading order for the spectral-threshold contribution.

**\(\sqrt{1-\alpha^2}\) rate** (fixed \(\delta=0.05\), vary \(\alpha\)):

| \(\alpha\) | \(\varepsilon\) | \(\varepsilon/\sqrt{1-\alpha^2}\) |
|----------|---------------|--------------------------------|
| 0.998 | 0.159 | 2.32 |
| 0.974 | 0.161 | 0.71 |
| 0.898 | 0.185 | 0.42 |
| 0.766 | 0.262 | 0.41 |
| 0.646 | 0.342 | 0.45 |

The ratio is order-one for moderate packing defects. At extremely high \(\alpha\) the ratio rises, consistent with the \(\sqrt{\delta}\) term dominating when the packing contribution is negligible.

## Conclusion

- Constant 4 is safe but not sharp. A constant of order 2 for \(\nu\) appears plausible.
- Both \(\sqrt{1-\alpha^2}\) and \(\sqrt{\delta}\) are consistent with the observed scaling; the known adversarial family already shows that \(\sqrt{\delta}\) cannot be improved in general under spectral-threshold-only assumptions.
- Further analytic tightening of the constant is possible but not required for the existence of a dimension-free theorem.

## Recommended statement

\[
\nu \le C\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big)
\]
with an absolute constant \(C\) (currently 4; empirically ~2). The precise optimal constant remains open but does not affect the qualitative result.
