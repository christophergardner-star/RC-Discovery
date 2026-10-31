# Diamond-Norm Computation for Same-Label Completion

**Date:** 31 October 2026  
**Status:** Proxy computations consistent with the bound; no violation found

## Method

For measurement channels (classical output) the diamond distance equals the maximum total variation over states on the system (ancilla often unnecessary). We computed high-sample pure-state max TV as a tight proxy, and attempted an SDP formulation (solver returned unreliable values on complex Hermitian variables; pure-state sampling used instead).

## Results on adversarial cases

| Case | α | ν_proxy | claimed bound | ratio |
|------|---|----------|---------------|-------|
| near-degenerate α | 0.22 | 0.38 | 4.79 | 0.079 |
| δ near 0 | 0.98 | 0.0007 | 0.86 | 0.001 |
| m=3 moderate | 0.89 | 0.069 | 3.08 | 0.022 |
| high packing | 0.99 | 0.009 | 1.11 | 0.008 |
| extreme residual | 0.81 | 0.16 | 4.53 | 0.035 |

All ratios ≤ 0.08. No violation of \(\nu \le 4(\sqrt{1-\alpha^2} + \sqrt{\delta})\) appears.

## Interpretation

The hybrid isometry construction predicts \(\nu \le 2\|V-W\|_\infty\), and the observed proxies are consistent with a constant substantially smaller than 4. The pure-state maximum is expected to be close to the true diamond distance for these measurement channels.

## Limitations

- Not a full Watrous SDP with ancilla (solver issues on complex variables).
- Sampling, not exhaustive optimization over the pure-state manifold.
- Small dimensions only.

## Verdict

Diamond-norm proxies on near-degenerate and extreme cases remain comfortably inside the claimed bound. Combined with the hybrid isometry verification and the adversarial audit, the same-label dimension-free theorem candidate continues to hold under numerical scrutiny.
