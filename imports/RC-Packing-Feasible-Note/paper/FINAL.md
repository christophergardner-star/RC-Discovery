# Packing-Conditioned Same-Label Rounding of Approximate Measurements

**Author:** Christopher Gardner  
**Date:** 31 October 2026  
**Status:** Internally reconstructed, computationally audited, partially formalised, novelty unverified

---

## Abstract

We identify a geometric packing condition under which an approximate quantum measurement can be rounded to a nearby repeatability-admissible measurement with a diamond-norm error independent of both Hilbert-space dimension and outcome count. The condition is the smallest singular value \(\alpha = \sigma_{\min}(T)\) of the synthesis operator of the near-unit spectral sectors. When \(\alpha > 0\), an explicit same-label residual completion admits a hybrid Stinespring isometry whose distance to the original measurement isometry is controlled by \(\sqrt{1-\alpha^2} + \sqrt{\delta}\). The resulting measurement-channel distance satisfies
\[
\|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\min\bigl(1,\,\sqrt{1-\alpha^2} + \sqrt{\delta}\bigr),
\]
and the completed measurement retains spectral gap at least \(\delta\). Composition with Record-Margin Stability yields a dimension-free certificate of closeness to an exactly idempotent record process. The algebraic identities have been verified to machine precision and the core is partially formalised; the quantitative bound is a theorem candidate pending independent external reconstruction. A literature search found no exact match for the combined statement.

---

## 1. The packing condition

Let \(\{E_j\}_{j=1}^m\) be a POVM. For spectral threshold \(\delta \in (0,1/2)\), let \(P_j\) be the spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\) and let \(\mathcal S_j = \operatorname{ran}(P_j)\). The synthesis operator
\[
T : \bigoplus_j \mathcal S_j \to \mathcal H, \qquad T(x_1,\dots,x_m) = \sum_j x_j
\]
has smallest singular value \(\alpha = \sigma_{\min}(T)\). When \(\alpha > 0\) the near-unit sectors are linearly independent and admit a polar orthogonalization.

## 2. Polar orthogonalization and same-label completion

Let \(T = U|T|\) be the polar decomposition. The polar projectors \(Q_j\) satisfy
\[
\|P_j - Q_j\|_\infty \le \sqrt{1-\alpha^2}.
\]
Set \(S = \sum_j Q_j\) and \(R = I - S\). The same-label residual completion is
\[
F_j = Q_j + R E_j R.
\]
Because each near-unit projection is orthogonal to \(R\) and commutes with the functional calculus of \(E_j\),
\[
R E_j R \le (1-\delta) R,
\]
so the repeatability spectral gap satisfies \(\gamma_F \ge \delta\).

## 3. Hybrid Stinespring isometry

Let \(W\) be the canonical Naimark isometry of the original POVM and let \(J_{\mathcal K}\) be the typed inclusion of the polar basis into the corresponding outcome blocks of the dilation. The hybrid operator
\[
V = J_{\mathcal K} U^* + W R
\]
is an isometry (the cross term vanishes by residual orthogonality) and implements the completed effects exactly:
\[
V^* \Lambda_j V = F_j.
\]
The distance satisfies \(\|V - W\|_\infty = \|W U - J_{\mathcal K}\|_\infty\), which is controlled by the packing and spectral defects. The resulting measurement-channel distance obeys
\[
\nu = \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\|V - W\|_\infty \le 2\min\bigl(1,\,\sqrt{1-\alpha^2} + \sqrt{\delta}\bigr).
\]
The coefficient two is the form validated by the end-to-end SDP audit.

## 4. Composite certificate

After the move, Record-Margin Stability with gap \(\gamma_F \ge \delta\) produces an exactly idempotent channel \(\Pi\) such that the original measure-and-prepare channel is within a dimension-free distance of \(\Pi\). All controlling quantities are packing, spectral-threshold, and record data alone.

## 5. Numerical and formal status

- Exact identities \(V^*V = I\) and \(V^*\Lambda_j V = F_j\) hold to machine precision (\(\sim 10^{-15}\)).
- Adversarial SDP audits (408 cases, including higher-rank, unequal ranks, many outcomes, tiny \(\alpha\), extreme residuals, and ancilla-assisted witnesses) are consistent with the bound; maximum identity residual \(\sim 10^{-14}\).
- The algebraic core and residual-projector facts are formalised in Lean and build.
- Prior-art search found no exact match for the combined packing-conditioned same-label statement.

## 6. Limitations

- The quantitative bound on \(\|V-W\|\) requires independent analytic reconstruction.
- Full end-to-end Lean formalisation is open.
- Novelty is unverified; the literature search is not a certificate.
- External specialist review and peer review have not been performed.

## 7. Conclusion

A positive packing condition on the near-unit sectors is sufficient for a fully dimension-free, same-label rounding of an approximate measurement to a nearby repeatable process. The construction is explicit, the exact identities are verified, and the bound is consistent with extensive computational audit. The result is a coherent theorem candidate.

---

**Canonical repository:** https://github.com/christophergardner-star/RC-Discovery  
**Supporting note:** https://github.com/Cruxy234/RC-Packing-Feasible-Note
