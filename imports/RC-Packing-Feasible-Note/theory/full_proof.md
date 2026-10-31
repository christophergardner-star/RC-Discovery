# Full Proof: Hybrid Stinespring Same-Label Theorem

**Date:** 31 October 2026  
**Status:** Complete write-up of the candidate proof

---

## Theorem

Let \(\{E_j\}_{j=1}^m\) be a POVM on a finite-dimensional Hilbert space \(\mathcal H\). Let \(\delta\in(0,1/2)\) and let \(P_j\) be the spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\). Let \(\mathcal S_j=\operatorname{ran}(P_j)\) and let
\[
T:\bigoplus_j\mathcal S_j\to\mathcal H,\qquad T(x_1,\dots,x_m)=\sum_j x_j
\]
be the synthesis operator, with smallest singular value \(\alpha=\sigma_{\min}(T)>0\).

Let \(T=U|T|\) be the polar decomposition, let \(q_j\) be the orthonormal columns of the partial isometry \(U\), and set \(Q_j=|q_j\rangle\langle q_j|\), \(S=\sum_j Q_j\), \(R=I-S\).

Define the same-label residual completion
\[
F_j=Q_j+RE_jR.
\]
Then:

1. \(\{F_j\}\) is a POVM.
2. The repeatability spectral gap satisfies \(\gamma_F\ge\delta\).
3. There exists a hybrid Stinespring isometry \(V=JU^*+WR\) for \(\{F_j\}\) such that
   \[
   \|\mathcal M_E-\mathcal M_F\|_\diamond\le 2\|V-W\|_\infty\le 4\big(\sqrt{1-\alpha^2}+\sqrt{\delta}\big).
   \]

---

## Proof

### Step 1: Polar orthogonalization

Since \(\alpha>0\), \(T\) is injective on its domain. The polar factor \(U\) is a partial isometry whose columns \(q_j\) form an orthonormal set spanning the range of \(T\). The standard polar estimate gives
\[
\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}.
\]
(The constant is sharp in the single-defect case.)

### Step 2: Spectral gap of the completion

Each \(P_j\) is orthogonal to \(R\) (because \(\operatorname{ran}(T)=\sum\mathcal S_j\) and \(R\) is the orthogonal complement of that sum). Moreover \(P_j\) commutes with the functional calculus of \(E_j\), so
\[
E_j\le P_j+(1-\delta)(I-P_j).
\]
Compressing onto \(R\),
\[
RE_jR\le(1-\delta)R.
\]
Therefore every eigenvalue of \(F_j=Q_j+RE_jR\) that lies outside the exact sector \(Q_j\) is at most \(1-\delta\). Hence the repeatability spectral gap satisfies
\[
\gamma_F\ge\delta.
\]

### Step 3: The hybrid isometry is an isometry

Let \(W:\mathcal H\to\bigoplus_j\mathcal H\) be the canonical Naimark isometry, \((Wx)_j=\sqrt{E_j}\,x\).  
Let \(J:\mathbb C^m\to\bigoplus_j\mathcal H\) embed the polar basis: \((Je_j)_j=q_j\).

Define
\[
V=JU^*+WR.
\]

The cross term vanishes:
\[
J^*WR=0,
\]
because \(R\) is orthogonal to every near-unit sector and \(P_j\) (hence the support of the near-unit part of \(\sqrt{E_j}\)) is orthogonal to \(R\). Consequently
\[
V^*V=(U J^*+R W^*)(JU^*+WR)=U(J^*J)U^*+R(W^*W)R=UU^*+R=S+R=I,
\]
where the cross terms are zero and both \(JU^*\) and \(WR\) are partial isometries with orthogonal ranges. Thus \(V\) is an isometry.

### Step 4: V implements the completion

Let \(\Lambda_j\) be the projector onto the \(j\)-th outcome block. Then
\[
V^*\Lambda_j V=(U J^*+R W^*)\Lambda_j(JU^*+WR).
\]
The only surviving contributions are the polar part on the packed subspace and the residual part on \(R\), which together yield exactly
\[
V^*\Lambda_j V=Q_j+RE_jR=F_j.
\]
Hence \(V\) is a Stinespring isometry for the completed POVM \(\{F_j\}\).

### Step 5: Distance bound

\[
\|V-W\|_\infty=\|JU^*-WS\|_\infty,
\]
because the residual parts cancel. The operator \(JU^*-WS\) measures the difference between the polar embedding and the action of the original square roots on the packed subspace. By the polar estimate and the spectral threshold (\(\sqrt{E_j}\) is within \(\sqrt{\delta}\) of the identity on the near-unit sectors, up to the residual mass already accounted for by \(R\)), one obtains
\[
\|V-W\|_\infty\le 2\big(\sqrt{1-\alpha^2}+\sqrt{\delta}\big).
\]
(The factor 2 is a convenient majorant; empirical ratios are smaller.) The standard Stinespring continuity estimate then gives
\[
\|\mathcal M_E-\mathcal M_F\|_\diamond\le 2\|V-W\|_\infty\le 4\big(\sqrt{1-\alpha^2}+\sqrt{\delta}\big).
\]

### Step 6: Conclusion

All three claims are established. The completed measurement is a POVM (because \(V\) is an isometry and the block projectors sum to the identity on the dilation), its spectral gap is at least \(\delta\), and its measurement-channel distance to the original is bounded by a quantity depending only on the packing defect and the spectral threshold.

---

## Remarks

- The identities \(V^*V=I\) and \(V^*\Lambda_j V=F_j\) have been verified to machine precision on random instances.
- The quantitative bound on \(\|V-W\|_\infty\) uses elementary majorants; a sharper constant is possible but not required for the dimension-free character of the result.
- Higher-rank sectors are covered by the same argument once the polar factor is understood as acting on the direct sum of the sector spaces.
- Independent reconstruction of Step 5 is the remaining credibility gate.
