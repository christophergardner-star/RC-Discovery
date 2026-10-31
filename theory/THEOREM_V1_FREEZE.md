# Theorem v1 Freeze: Same-Label Packing-Conditioned Record Stability

**Freeze date:** 31 October 2026  
**Status:** Internally reconstructed theorem candidate; external verification pending  
**Purpose:** This file states the canonical theorem without historical conjectures or superseded bounds.

## Hypotheses

Let \(\mathcal H\) be finite dimensional and let \(\{E_j\}_{j=1}^m\) be a POVM.

Choose \(0<\delta<1/2\). For every nonzero \(E_j\), let \(P_j\neq0\) be the full spectral projection onto eigenvalues at least \(1-\delta\).

Set

\[
\mathcal K=\bigoplus_j\operatorname{ran}(P_j),
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j,
\]

and assume

\[
\alpha=\sigma_{\min}(T)>0.
\]

Let \(T=U|T|\). Define

\[
Q_j=UR_j^{\rm coord}U^*,
\qquad
S=\sum_jQ_j=UU^*,
\qquad
R=I-S,
\]

and

\[
F_j=Q_j+R E_jR.
\]

## Geometric and measurement conclusions

1. \(\{Q_j\}\) are mutually orthogonal and \(\operatorname{rank}Q_j=\operatorname{rank}P_j\).

2. For every \(j\),

\[
\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}.
\]

3. \(\{F_j\}\) is a POVM and

\[
F_iQ_j=\delta_{ij}Q_j.
\]

4. The repeatability spectral gap obeys

\[
\gamma_F\ge\delta.
\]

5. Let \(\mathcal M_E,\mathcal M_F\) be the classical-output measurement channels. Then

\[
\boxed{
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\!\left\{
1,\sqrt{1-\alpha^2}+\sqrt\delta
\right\}.
}
\]

The coefficient \(2\) is not claimed optimal.

## Typed hybrid isometry

Let

\[
\mathcal Y=\bigoplus_j\mathcal H,
\qquad
(Wz)_j=\sqrt{E_j}z,
\]

and define

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

Then

\[
J_{\mathcal K}^*WR=0
\]

and

\[
V=J_{\mathcal K}U^*+WR
\]

is an isometry satisfying

\[
V^*\Lambda_jV=F_j.
\]

The direct-sum definition of \(J_{\mathcal K}\) is part of the theorem statement.

## Record-process corollary

Let

\[
\Phi(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

have record margin \(\kappa>0\) and idempotence defect

\[
\eta=\|\Phi^2-\Phi\|_\diamond.
\]

Define the label inaccessibility by
\(e=\max_{j:E_j\ne0}(1-\lambda_{\max}(E_j))\).
The near-unit-sector hypothesis gives \(0\le e\le\delta<1/2\).
For any valid measurement movement bound \(B_{\rm move}\), there is an explicit exactly idempotent channel \(\Pi\) such that

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
B_{\rm move}
+
2\sqrt{1-\alpha^2}
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2e)}
}
\right\}.
}
\]

Since \(e\le\delta\), substitution of the coefficient-two movement estimate yields

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
4\sqrt{1-\alpha^2}
+
2\sqrt\delta
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2\delta)}
}
\right\}.
}
\]

## Claim boundary

This theorem is:

- internally reconstructed;
- numerically audited;
- partially Lean formalised;
- not externally peer reviewed;
- not novelty certified.

No individual use of polar decomposition, synthesis operators, Naimark/Stinespring dilation, POVM orthogonalisation, repeatability criteria, or diamond-norm continuity is claimed as new.
