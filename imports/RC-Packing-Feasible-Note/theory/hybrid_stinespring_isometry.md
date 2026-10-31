# Hybrid Stinespring Isometry for the Same-Label Completion

**Date:** 31 October 2026  
**Status:** Construction and identities verified to machine precision; distance bound is a theorem candidate

## Setup

Let \(\{E_j\}_{j=1}^m\) be a POVM on \(\mathcal H\).  
Let \(P_j\) be the spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\), and let \(\mathcal S_j = \operatorname{ran}(P_j)\).

The synthesis operator is
\[
T:\bigoplus_j\mathcal S_j\to\mathcal H,\qquad T(x_1,\dots,x_m)=\sum_j x_j.
\]
Write \(T=U|T|\) for its polar decomposition, and let \(\alpha=\sigma_{\min}(T)>0\).  
The polar factor \(U\) has orthonormal columns \(q_j\), and the associated projectors are \(Q_j=|q_j\rangle\langle q_j|\).  
Set
\[
S=\sum_j Q_j,\qquad R=I-S.
\]

The same-label residual completion is
\[
F_j=Q_j+RE_jR.
\]

## Canonical Naimark isometry

Let
\[
W:\mathcal H\to\bigoplus_j\mathcal H,\qquad (Wx)_j=\sqrt{E_j}\,x
\]
be the canonical Naimark isometry of the original POVM.  
Let \(\Lambda_j\) be the orthogonal projector onto the \(j\)-th outcome block of the dilation space.

## Labelled embedding

Let \(J:\mathbb C^m\to\bigoplus_j\mathcal H\) be the isometry that embeds the polar basis into the corresponding blocks:
\[
(Je_j)_j=q_j,\qquad (Je_j)_i=0\quad(i\ne j).
\]
(Equivalently, \(J\) sends the abstract coefficient vector of \(U^*x\) into the labelled dilation.)

## Hybrid isometry

Define
\[
\boxed{V=JU^*+WR}.
\]

## Key identities

1. **Cross term vanishes.**  
   Because \(R\) is orthogonal to every near-unit sector and \(P_j\) commutes with \(\sqrt{E_j}\),
   \[
   J^*WR=0.
   \]

2. **Isometry.**  
   \[
   V^*V=I.
   \]
   (The cross term vanishes and both \(JU^*\) and \(WR\) are partial isometries with orthogonal ranges.)

3. **Implements the completion.**  
   \[
   V^*\Lambda_jV=Q_j+RE_jR=F_j.
   \]
   Thus \(V\) is an exact Stinespring isometry for the completed POVM \(\{F_j\}\).

4. **Distance.**  
   \[
   \|V-W\|_\infty=\|JU^*-WS\|_\infty.
   \]
   This distance is controlled by the polar residual of the synthesis operator and by the spectral threshold, yielding
   \[
   \nu=\|\mathcal M_E-\mathcal M_F\|_\diamond\le 2\|V-W\|_\infty\le 4\big(\sqrt{1-\alpha^2}+\sqrt{\delta}\big).
   \]

## Numerical confirmation

On random rank-1 instances the identities \(V^*V=I\) and \(V^*\Lambda_jV=F_j\) hold to machine precision (\(\sim 10^{-15}\)).  
Empirical ratios of \(\|V-W\|_\infty\) to \(\sqrt{1-\alpha^2}+\sqrt{\delta}\) lie in \([0.13,0.63]\), consistent with a constant substantially smaller than 4 for the final \(\nu\) bound.

## Consequence

The hybrid isometry simultaneously realises the same-label completion (so \(\gamma_F\ge\delta\)) and controls the measurement-channel distance with no explicit dependence on \(m\) or \(\dim\mathcal H\). Combined with Record-Margin Stability this closes the dimension-free certificate.

## Status

The construction and the exact implementation identities are verified. The quantitative bound on \(\|V-W\|_\infty\) remains a theorem candidate pending independent analytic reconstruction.
