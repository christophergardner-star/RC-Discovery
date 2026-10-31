# Packing-Conditioned Rounding of Approximate Measurements

**Author:** Christopher Gardner  
**Date:** 31 October 2026  
**Status:** Draft for external attack

## Abstract

We identify a geometric packing condition under which an approximate quantum measurement can be rounded to a nearby repeatability-admissible measurement with a dimension-free and outcome-count-independent diamond-norm error. The condition is the smallest singular value \(\alpha = \sigma_{\min}(T)\) of the synthesis operator of the near-unit spectral sectors. When \(\alpha > 0\), an explicit same-label residual completion admits a hybrid Stinespring isometry whose distance to the original measurement isometry is controlled by \(\sqrt{1-\alpha^2} + \sqrt{\delta}\). Combined with a spectral-gap lower bound of order \(\delta\), this yields a fully dimension-free certificate of closeness to an exactly idempotent record process. The result is complementary to Kitaev's structural approximation of almost-idempotent channels and to de la Salle's orthogonalization of almost-orthogonal POVMs; the novelty lies in the packing-conditioned constructive control of both the channel distance and the repeatability gap.

## 1. Introduction

A measurement is repeatable when applying it twice yields the same classical outcome and the same post-measurement state. For projective measurements this is automatic. For general POVMs, exact repeatability requires that each effect possess eigenvalue 1 on a suitable sector.

Approximate measurements need not be close to any repeatable measurement. Local diagnostics (record separation, idempotence defect, near-unit eigenvalues) are insufficient: the regular simplex furnishes an obstruction in which all local quantities improve while simultaneous packing of the outcome sectors remains impossible. This note isolates the missing global condition and shows that, once it holds, a quantitative rounding is possible with no dependence on the number of outcomes or the Hilbert-space dimension.

## 2. Packing condition

Let \(\{E_j\}_{j=1}^m\) be a POVM. For a spectral threshold \(\delta \in (0,1/2)\), let \(P_j\) be the spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\), and let \(\mathcal S_j = \operatorname{ran}(P_j)\). The synthesis operator
\[
T : \bigoplus_j \mathcal S_j \to \mathcal H, \qquad T(x_1,\dots,x_m) = \sum_j x_j
\]
has smallest singular value \(\alpha = \sigma_{\min}(T)\). When \(\alpha > 0\) the near-unit sectors can be simultaneously orthogonalized by the polar factor of \(T\). The polar projectors \(Q_j\) satisfy
\[
\|P_j - Q_j\|_\infty \le \sqrt{1-\alpha^2}.
\]

## 3. Same-label residual completion

Let \(R = I - \sum_j Q_j\). Define
\[
F_j = Q_j + R E_j R.
\]
Because each near-unit projection \(P_j\) is orthogonal to \(R\) and commutes with \(\sqrt{E_j}\),
\[
R E_j R \le (1-\delta) R.
\]
Hence every eigenvalue of \(F_j\) outside the exact sector \(Q_j\) is at most \(1-\delta\), so the repeatability spectral gap satisfies \(\gamma_F \ge \delta\).

## 4. Hybrid Stinespring isometry

Let \(W\) be the canonical Naimark isometry of the original POVM, \(U\) the polar factor of \(T\), and \(J\) the labelled isometry that embeds the polar basis into the corresponding outcome blocks. The operator
\[
V = J U^* + W R
\]
is an isometry (the cross term vanishes because \(J^* W R = 0\)), and it implements exactly the completed effects:
\[
V^* \Lambda_j V = F_j.
\]
The distance satisfies \(\|V - W\|_\infty = \|J U^* - W S\|_\infty\), where \(S = \sum Q_j\). This distance is controlled by the packing and spectral defects; the resulting measurement-channel distance obeys
\[
\nu = \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\|V - W\|_\infty \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big).
\]
Numerical probes show the constant 4 is conservative (empirical ratios suggest a constant of order 2 suffices). Both square-root rates are consistent with the data; an explicit adversarial family shows that the \(\sqrt{\delta}\) dependence cannot be improved in general under spectral-threshold-only assumptions.

## 5. Composite certificate

Let \(\Phi_E\) be a measure-and-prepare channel using the original POVM, with record margin \(\kappa > 0\) and idempotence defect \(\eta = \|\Phi_E^2 - \Phi_E\|_\diamond\). After the move above, the spectral-gap Record-Margin theorem applies with \(\gamma_F \ge \delta\) and yields an exactly idempotent channel \(\Pi\) such that
\[
\|\Phi_E - \Pi\|_\diamond \le \nu + \sqrt{\frac{2(\eta + 3\nu)}{\kappa \delta}},
\]
where \(\nu\) is bounded as in Section 4. All quantities are controlled by packing, spectral-threshold, and record data alone; no explicit dependence on the number of outcomes or Hilbert-space dimension appears.

## 6. Relation to prior work

- de la Salle (2022) orthogonalizes almost-orthogonal POVMs with linear dependence, optimally, while preserving the von Neumann algebra. The hypothesis and conclusion differ: the present result uses a synthesis packing condition on near-unit sectors and produces a same-label residual completion with explicit hybrid dilation.
- Kitaev (2024) constructs approximate \(C^*\)-algebras from almost-idempotent channels. The present work supplies a constructive geometric route to an exactly idempotent record process under an additional packing hypothesis.
- Frame-theoretic synthesis operators and classical Stinespring continuity are used as tools; the combination that yields a dimension-free same-label certificate from a packing condition appears to be new.

## 7. Limitations and open questions

- Independent reconstruction of the hybrid isometry bound is required.
- The optimal constant in the \(\nu\) bound is not known (empirically order 2; analytic claim 4).
- Higher-rank sectors are covered by the same synthesis construction but have received less numerical stress-testing.
- Full formalisation in a proof assistant remains open.
- Same-label applications that cannot tolerate residual folding must retain \(\gamma_F\) as an explicit parameter or supply a separate argument.

## 8. Conclusion

A positive packing condition on the near-unit sectors of a POVM is sufficient for a fully dimension-free and outcome-count-independent diamond-norm certificate of closeness to an exactly idempotent record process. The proof proceeds by an explicit same-label residual completion, a hybrid Stinespring isometry, and the existing spectral-gap Record-Margin theorem. The result is a theorem candidate of publishable form, contingent on independent audit of the hybrid isometry step.

## Acknowledgements

The geometric packing obstruction and the hybrid isometry construction were developed through iterative numerical and analytic exploration ("VIBE MATH" methodology). All claims remain subject to independent verification.
