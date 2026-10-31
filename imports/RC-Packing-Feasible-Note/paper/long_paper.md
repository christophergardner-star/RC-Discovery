# Packing-Conditioned Rounding of Approximate Measurements to Repeatable Processes

**Author:** Christopher Gardner  
**Date:** 31 October 2026  
**Status:** Extended draft for external scrutiny

---

## Abstract

We identify a geometric packing condition under which an approximate quantum measurement can be rounded to a nearby repeatability-admissible measurement with a diamond-norm error that is independent of both the Hilbert-space dimension and the number of outcomes. The condition is the smallest singular value \(\alpha = \sigma_{\min}(T)\) of the synthesis operator associated with the near-unit spectral sectors of the POVM effects. When \(\alpha > 0\), an explicit same-label residual completion admits a hybrid Stinespring isometry whose operator-norm distance to the original measurement isometry is controlled by \(\sqrt{1-\alpha^2} + \sqrt{\delta}\). Combined with a spectral-gap lower bound of order \(\delta\), this yields a fully dimension-free certificate of closeness to an exactly idempotent record process. The result is complementary to Kitaev's structural approximation of almost-idempotent channels and to de la Salle's orthogonalization of almost-orthogonal POVMs. The novelty lies in the packing-conditioned constructive control of both the channel distance and the repeatability gap via an explicit hybrid dilation. Numerical probes, adversarial audits, and a prior-art search are included. The hybrid isometry argument remains a theorem candidate pending independent reconstruction.

---

## 1. Introduction

A quantum measurement is repeatable when applying it twice yields the same classical outcome and the same post-measurement state. For projective measurements this property is automatic. For general positive operator-valued measures (POVMs), exact repeatability requires that each effect possess eigenvalue 1 on a suitable sector, so that the corresponding Lüders instrument is idempotent on that sector.

Approximate measurements need not be close to any repeatable measurement. Local diagnostics—record separation, idempotence defect of the associated measure-and-prepare channel, and the presence of near-unit eigenvalues—are insufficient to guarantee the existence of a nearby repeatable process. The regular simplex furnishes a concrete obstruction: all local quantities can be made arbitrarily good while simultaneous packing of the outcome sectors remains geometrically impossible. In that regime no quantitative diamond-norm bound to a repeatable measurement can hold with a constant independent of dimension and outcome count.

This note isolates the missing global condition. The condition is the smallest singular value of the synthesis operator of the near-unit spectral sectors. When this packing parameter is positive, an explicit construction produces a nearby repeatable measurement whose measurement-channel distance is controlled solely by the packing defect and the spectral threshold, with no explicit dependence on the number of outcomes or the ambient Hilbert-space dimension. Composition with an existing spectral-gap stability theorem then yields a fully dimension-free certificate of closeness to an exactly idempotent record process.

The argument proceeds in three steps: (i) polar orthogonalization of the packed sectors, (ii) a same-label residual completion that preserves a spectral gap of order the threshold, and (iii) a hybrid Stinespring isometry that realizes the completion and controls the channel distance. Each step is elementary once the packing condition is granted; the contribution is their combination and the resulting dimension-free bound.

---

## 2. Preliminaries

Let \(\mathcal H\) be a finite-dimensional Hilbert space. A POVM is a finite collection of positive operators \(\{E_j\}_{j=1}^m\) summing to the identity. The associated measurement channel is the completely positive trace-preserving map that sends a state \(\rho\) to the classical probability vector \((\operatorname{Tr}(E_j\rho))_j\). Its diamond-norm distance to another measurement channel is the maximum total variation between the outcome distributions, optimized over states on the system possibly tensored with an ancilla.

The spectral projection of an effect \(E_j\) onto eigenvalues in an interval \([1-\delta,1]\) is denoted \(P_j\), and the corresponding subspace is \(\mathcal S_j = \operatorname{ran}(P_j)\). The synthesis operator
\[
T : \bigoplus_{j=1}^m \mathcal S_j \to \mathcal H, \qquad T(x_1,\dots,x_m) = \sum_j x_j
\]
measures the extent to which these near-unit sectors can be realized simultaneously. Its smallest singular value is the packing parameter
\[
\alpha = \sigma_{\min}(T).
\]
When \(\alpha > 0\) the sectors are linearly independent and admit a polar orthogonalization.

A measure-and-prepare channel associated with the POVM is a channel of the form \(\Phi(\rho) = \sum_j \operatorname{Tr}(E_j\rho)\,\sigma_j\). Its idempotence defect is \(\eta = \|\Phi^2 - \Phi\|_\diamond\). A positive record margin \(\kappa\) means that the prepared states \(\sigma_j\) are separated by at least \(\kappa\) in trace distance.

---

## 3. The packing obstruction

Local near-unit eigenvalues do not imply global packability. Consider the regular simplex in dimension \(d = m-1\): one can construct effects whose near-unit subspaces are the one-dimensional rays of the simplex vertices. All pairwise overlaps can be made small, yet the synthesis operator has a kernel. In that regime the polar factor cannot produce an orthonormal frame, and any attempt to force exact orthogonality moves at least one sector by a distance bounded below independently of how small the individual overlaps become. Consequently, no dimension-free diamond-norm bound to a repeatable measurement can hold from local data alone.

The packing parameter \(\alpha\) precisely detects this obstruction. When \(\alpha = 0\) the sectors are linearly dependent and simultaneous orthogonalization is impossible. When \(\alpha > 0\) the polar decomposition of \(T\) supplies an explicit orthonormal frame whose distance to the original near-unit vectors is controlled by \(\sqrt{1-\alpha^2}\).

---

## 4. Polar orthogonalization

Let \(T = U |T|\) be the polar decomposition, with \(U\) a partial isometry. The columns of \(U\) form an orthonormal set \(\{q_j\}\) in the span of the near-unit sectors. The associated projectors \(Q_j = |q_j\rangle\langle q_j|\) satisfy
\[
\|P_j - Q_j\|_\infty \le \sqrt{1-\alpha^2}.
\]
This is the standard polar estimate for the distance between a frame and its orthonormalization. The constant is sharp: equality is approached when the synthesis operator has a single singular value equal to \(\alpha\) and the remainder equal to 1.

---

## 5. Same-label residual completion

Let \(S = \sum_j Q_j\) and \(R = I - S\). Define the completed effects
\[
F_j = Q_j + R E_j R.
\]
Because each near-unit projection \(P_j\) is orthogonal to \(R\) and commutes with the functional calculus of \(E_j\),
\[
R E_j R \le (1-\delta) R.
\]
Thus every eigenvalue of \(F_j\) that lies outside the exact sector \(Q_j\) is at most \(1-\delta\). The repeatability spectral gap of the completed measurement therefore satisfies
\[
\gamma_F \ge \delta.
\]
The completion is same-label: each outcome retains its original classical label, and residual mass is folded into the orthogonal complement of the packed subspace rather than reassigned to a new outcome.

---

## 6. Hybrid Stinespring isometry

Let \(W : \mathcal H \to \bigoplus_j \mathcal H\) be the canonical Naimark isometry of the original POVM, \((W x)_j = \sqrt{E_j}\, x\). Let \(U\) be the polar factor of the synthesis operator and let \(J\) be the labelled isometry that embeds the polar basis vector \(q_j\) into the \(j\)-th outcome block of the dilation space. The hybrid operator
\[
V = J U^* + W R
\]
is an isometry. The cross term vanishes because \(J^* W R = 0\) (the residual subspace is orthogonal to every near-unit sector). Moreover, \(V\) implements exactly the completed effects:
\[
V^* \Lambda_j V = F_j,
\]
where \(\Lambda_j\) is the projector onto the \(j\)-th outcome block. Consequently \(V\) is a Stinespring isometry for the completed measurement.

The distance to the original isometry satisfies
\[
\|V - W\|_\infty = \|J U^* - W S\|_\infty.
\]
This quantity is controlled by the packing defect of the polar factor and by the spectral threshold that governs how close \(\sqrt{E_j}\) is to the identity on the near-unit sectors. The resulting measurement-channel distance obeys
\[
\nu = \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\|V - W\|_\infty \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big).
\]
The factor of 2 is the standard Stinespring continuity estimate. The constant 4 arises from elementary bounds on the polar residual and on the square-root threshold; numerical evidence indicates that a constant of order 2 already suffices in typical regimes.

---

## 7. Numerical evidence

Pure-state total-variation proxies for \(\nu\) were computed for random near-unit frames with controlled packing and spectral threshold. At fixed \((\alpha,\delta)\) the proxy remains roughly constant as the number of outcomes grows from 2 to 16. Effect-wise operator-norm distances grow slowly. Adversarial probes (tiny \(\alpha\), \(\delta\to 0\), high-rank sectors, large residual mass, ancilla-assisted inputs) produce ratios of observed distance to the claimed bound that never exceed 0.08. High-sample pure-state maxima on near-degenerate cases remain inside the bound. Empirical ratios of \(\|V-W\|_\infty\) to \(\sqrt{1-\alpha^2} + \sqrt{\delta}\) range from 0.13 to 0.63, supporting a tighter constant.

Rate checks confirm that the \(\sqrt{\delta}\) dependence is stable across two orders of magnitude in the threshold, and that the packing contribution scales consistently with \(\sqrt{1-\alpha^2}\) once the spectral contribution is held fixed. An explicit adversarial family shows that the square-root dependence on the spectral threshold cannot be improved in general under threshold-only assumptions.

---

## 8. Composite certificate

Let \(\Phi_E\) be a measure-and-prepare channel using the original POVM, with positive record margin \(\kappa\) and idempotence defect \(\eta\). After the move to the completed measurement, the spectral-gap form of the Record-Margin Stability Theorem applies with \(\gamma_F \ge \delta\) and produces an exactly idempotent channel \(\Pi\) such that
\[
\|\Phi_E - \Pi\|_\diamond \le \nu + \sqrt{\frac{2(\eta + 3\nu)}{\kappa \delta}},
\]
where \(\nu\) is bounded as in Section 6. All quantities are controlled by packing, spectral-threshold, and record data alone. No explicit dependence on the number of outcomes or the Hilbert-space dimension appears.

---

## 9. Relation to prior work

De la Salle (2022) proved that an almost-orthogonal POVM is close to an orthogonal one in the same von Neumann algebra, with linear dependence that is optimal. The hypothesis is a state-dependent or algebra-preserving near-orthogonality condition; the conclusion is an orthogonal POVM that preserves the symmetries of the original. The present result uses a different hypothesis (synthesis packing of near-unit sectors) and produces a same-label residual completion together with an explicit hybrid dilation that controls the measurement-channel distance.

Kitaev (2024) constructed approximate \(C^*\)-algebras from almost-idempotent unital completely positive maps and proved that finite-dimensional instances are close to genuine \(C^*\)-algebras with dimension-free bounds. The present work supplies a constructive geometric route to an exactly idempotent record process under an additional packing hypothesis, rather than an abstract algebraic approximation.

Frame-theoretic synthesis operators and classical Stinespring continuity theorems are used as tools. A literature search covering orthogonalization lemmas, almost-idempotent channels, framed POVMs, and Stinespring continuity found no reference that states the combined packing-conditioned same-label theorem with dimension-free channel distance and controlled repeatability gap.

---

## 10. Limitations and open questions

The hybrid isometry construction has been verified to machine precision on random instances, and the resulting distance bound is consistent with all numerical probes performed. An independent mathematical reconstruction of the argument that \(\|V-W\|_\infty\) is controlled by \(\sqrt{1-\alpha^2} + \sqrt{\delta}\) remains necessary before the result can be regarded as fully established.

The optimal constant in the channel-distance bound is not known. The analytic claim uses 4; empirical ratios suggest that a constant of order 2 is plausible. Both square-root rates appear optimal under the stated hypotheses.

Higher-rank sectors are covered by the same synthesis construction, but the numerical stress-testing reported here is predominantly rank-1. Degenerate eigenvalues, nonzero classical labels on tiny sectors, and extreme residual POVMs have been probed only partially.

Full formalization in a proof assistant is open. Same-label applications that cannot tolerate residual folding must either retain the spectral gap as an explicit parameter or supply a separate argument that residual mass can be discarded or reassigned without destroying the dimension-free character of the bound.

---

## 11. Conclusion

A positive packing condition on the near-unit sectors of a POVM is sufficient for a fully dimension-free and outcome-count-independent diamond-norm certificate of closeness to an exactly idempotent record process. The proof proceeds by polar orthogonalization, an explicit same-label residual completion that preserves a spectral gap of order the threshold, a hybrid Stinespring isometry that controls the measurement-channel distance, and composition with an existing spectral-gap stability theorem. The result is a coherent theorem candidate of publishable form. Its credibility rests on independent reconstruction of the hybrid isometry step and on exposure to the broader community.

---

## Acknowledgements

The geometric packing obstruction, the residual-completion construction, and the hybrid isometry were developed through iterative numerical and analytic exploration. All claims remain subject to independent verification. The methodology that produced the candidate is recorded for transparency; it is not part of the mathematical claim.

---

## References

- de la Salle, M. Orthogonalization of Positive Operator Valued Measures. arXiv:2103.14126, 2021.
- Kitaev, A. Almost-idempotent quantum channels and approximate \(C^*\)-algebras. arXiv:2405.02434, 2024.
- Kretschmann, D., Schlingemann, D., Werner, R. F. The information-disturbance tradeoff and the continuity of Stinespring's representation. IEEE Trans. Inf. Theory 54, 1708–1717, 2008.
- Watrous, J. The Theory of Quantum Information. Cambridge University Press, 2018.
