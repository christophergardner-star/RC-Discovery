# End-to-end MQC demonstration (synthetic detector)

Date: 31 October 2026

## Setup
- Hilbert dimension $d=4$, $m=4$ outcomes
- Near-orthonormal frame with small Gaussian perturbation
- Spectral defect $\delta=0.01$

## Measured MQC inputs
| Quantity | Value |
|----------|-------|
| $\alpha$ (packing) | 0.976 |
| $\delta$ (spectral) | 0.010 |
| $\kappa$ (record margin) | 0.999 |
| $\eta$ (idempotence proxy) | $8.3\times 10^{-3}$ |

## Results
| Output | Value |
|--------|-------|
| MQC bound ($C=6$) | 0.757 |
| MQC bound ($C=2$) | 0.252 |
| Actual polar projector movement | 0.026 |
| Theory $\delta+(1-\alpha)$ | 0.034 |
| Surface-code-style gap (1% th., 0.5% op.) | 0.005 |
| Poor-packing control $\alpha$ | 0.038 → MQC ≈ 8.7 (reject) |

## Interpretation
Good packing is accepted by the geometric test and polar movement matches theory order. Poor packing is rejected. Absolute diamond-norm bounds remain larger than a 0.5% FT gap until constants and device quality are both pushed further — the certificate is informative, not automatically permissive.
