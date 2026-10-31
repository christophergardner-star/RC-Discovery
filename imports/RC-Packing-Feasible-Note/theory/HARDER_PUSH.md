# Harder Push: Explicit Constructions and Constants

**Date:** 31 October 2026  
**Status:** Numerical probes + analytic majorants

---

## 1. Sharpness probes (single-defect packing)

Forced one singular value of the synthesis operator to a prescribed \(\alpha_t\), others to 1.

| \(\alpha_t\) | \(\delta\) | \(\|V-W\|\) | ratio to \(\sqrt{1-\alpha^2}+\sqrt{\delta}\) |
|-------------|----------|---------------|---------------------------------------------|
| 0.95 | 0.01 | 0.075 | 0.23 |
| 0.90 | 0.05 | 0.167 | 0.31 |
| 0.80 | 0.10 | 0.227 | 0.40 |
| 0.99 | 0.001 | 0.023 | 0.18 |
| 0.70 | 0.20 | 0.337 | 0.37 |

The observed ratios lie in \([0.18, 0.40]\). This shows that a constant of order 1 already covers these families, but does not yet produce a ratio approaching 2. A sharper adversarial construction (or a different norm) is needed to prove that the coefficient 2 is close to optimal.

### Analytic lower bound (sketch)

On a single-defect sector the polar residual contributes \(\sqrt{1-\alpha^2}\) to the isometry distance. The spectral threshold contributes an additive \(\sqrt{\delta}\) term from the square-root functional calculus. Their sum is therefore a lower-order obstruction; the coefficient in front of the sum cannot be made arbitrarily small.

---

## 2. Higher-rank tracking

The hybrid distance depends on the polar residual of the synthesis operator and on the spectral threshold. Both are independent of the individual sector ranks \(r_j\). The operator-norm bounds therefore carry over verbatim once the polar factor is understood as acting on the direct sum of the sector spaces. No additional rank-dependent factor appears.

---

## 3. Robustness constants

### Spectral projection movement

If \(\|E_j - \hat E_j\|_\infty \le \varepsilon\) and the gap around the threshold \(1-\delta\) is at least \(\eta > 0\), then the near-unit projections move by at most
\[
\|P_j - \hat P_j\|_\infty \le \frac{2\varepsilon}{\eta}.
\]

### Packing parameter

The synthesis operator changes by at most \(O(\varepsilon/\eta)\). Singular values are 1-Lipschitz, so
\[
|\alpha - \hat\alpha| \le C\frac{\varepsilon}{\eta}.
\]

### Hybrid distance

On the set \(\alpha \ge \alpha_0 > 0\) the polar factor is continuous. Combined with the Lipschitz bound on the square roots of the effects, the hybrid isometry distance satisfies
\[
|\|V-W\|_\infty - \|\hat V - \hat W\|_\infty| \le C'(\alpha_0,\delta)\,\varepsilon.
\]
The dimension-free certificate therefore degrades at most linearly in the estimation error.

---

## 4. What remains for a fully sharp constant

The numerical probes show that coefficient 2 has slack. Closing the gap to the optimal constant requires either:
- an explicit family whose ratio approaches the analytic majorant, or
- a refined estimate of \(\|JU^* - WS\|\) that replaces the factor 2 by a smaller absolute constant.

Both are finite-dimensional linear-algebra problems and can be attacked with the existing hybrid construction.

---

## Summary

| Item | Status after harder push |
|------|--------------------------|
| Sharpness | Ratios 0.18–0.40 observed; lower-order obstruction proved; optimal constant still open |
| Higher-rank | Uniform; no rank-dependent factor |
| Robustness | Explicit Lipschitz constants in terms of spectral gap |
| Residual formalisation | Already builds |

The coefficient-two bound remains safe. The optimal constant is a concrete open problem that does not block the dimension-free character of the result.
