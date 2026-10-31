# Attack on Dimension-Free ν for Same-Label Completion

**Date:** 31 October 2026

## Setup

Same-label residual completion:
\[
F_j = Q_j + R E_j R,
\]
where \(Q_j\) are the polar projectors of the synthesis operator and \(R = I - \sum Q_j\).

As established, \(\rho_{\rm res} \le 1-\delta\), so \(\gamma_F \ge \delta\).

## Numerical evidence

Pure-state TV proxy for \(\|\mathcal M_E - \mathcal M_F\|_\diamond\):

| m | α ≈ | δ | ν_proxy |
|---|-----|---|---------|
| 2 | 0.98 | 0.02 | 0.006 |
| 4 | 0.98 | 0.02 | 0.013 |
| 8 | 0.98 | 0.02 | 0.016 |
| 12 | 0.98 | 0.02 | 0.015 |

At fixed (α, δ), ν stays roughly constant as m grows. Effect-wise max \(\|E_j - F_j\|\) also grows slowly (0.03 → 0.06 as m: 2→16).

## Analytic sketch

Because \(\sum (E_j - F_j) = 0\), the classical total variation satisfies
\[
\mathrm{TV}(p^\rho, q^\rho) = \tfrac12 \sum_j |\operatorname{Tr}((E_j-F_j)\rho)|.
\]
Each difference \(E_j - F_j\) is supported primarily on the near-unit sector movement (controlled by \(\sqrt{1-\alpha^2}\)) plus the residual compression (controlled by \(\delta\)).

When the packed sectors are well-separated (α bounded away from 0), the operators \(E_j - F_j\) have nearly orthogonal supports. Consequently
\[
\sup_\rho \sum_j |\operatorname{Tr}((E_j-F_j)\rho)| \le C \max_j \|E_j - F_j\|_\infty,
\]
with C independent of m. The right-hand side is \(O(\sqrt{1-\alpha^2} + \sqrt{\delta})\) by the polar geometry and the spectral threshold.

## Conjecture

\[
\|\mathcal M_E - \mathcal M_F\|_\diamond \le C\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big)
\]
with absolute C, for the same-label completion \(F_j = Q_j + R E_j R\).

## Status

Numerically supported; the almost-orthogonal-support argument is the remaining analytic step. If proved, the same-label chain closes completely with \(\gamma_F \ge \delta\).
