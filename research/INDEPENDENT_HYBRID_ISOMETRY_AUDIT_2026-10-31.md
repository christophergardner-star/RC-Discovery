# Independent Reconstruction of the Same-Label Hybrid Isometry

Date: 31 October 2026  
Status: **PASS with one explicit hypothesis and one typing clarification**

## Critical typing clarification after the refreshed Cruxy merge

The labelled map in this audit is

\[
J_{\mathcal K}:\mathcal K=\bigoplus_j\mathcal S_j
\longrightarrow
\mathcal Y=\bigoplus_j\mathcal H,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

It embeds each **original sector vector** into the corresponding output block.

In the rank-one case, if the coordinate vector represents the original sector vector \(v_j\), then its image in block \(j\) is \(v_j\), not the polar-rounded vector \(q_j\).

The refreshed Cruxy source contains a separate calculation for an alternative map \(J_q\) that embeds \(q_j\). Its matrix-element formula is correct for \(J_q\), but it does not refute the identities below for \(J_{\mathcal K}\).

See `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`.

## Setting

Let \(\{E_j\}_{j=1}^m\) be a POVM on a finite-dimensional Hilbert space \(\mathcal H\). Fix \(0<\delta<1/2\). For every nonzero outcome effect, let \(P_j\neq0\) be the full spectral projection of \(E_j\) onto eigenvalues at least \(1-\delta\).

Let

\[
\mathcal K=\bigoplus_j\operatorname{ran}(P_j),
\qquad
T:\mathcal K\to\mathcal H,
\qquad
T(x_j)=\sum_jx_j,
\]

and assume

\[
\alpha=\sigma_{\min}(T)>0.
\]

Let

\[
T=UH,
\qquad
H=|T|
\]

be the polar decomposition. Then \(U:\mathcal K\to\mathcal H\) is an isometry. Put

\[
Q_j=U R_j^{\mathcal K}U^*,
\qquad
S=UU^*=\sum_jQ_j,
\qquad
R=I-S.
\]

## 1. Total-span identity

The range of the synthesis operator is

\[
\operatorname{ran}(T)=\sum_j\operatorname{ran}(P_j).
\]

Since the polar isometry has the same range,

\[
\operatorname{ran}(U)=\operatorname{ran}(T).
\]

Therefore \(R\) is orthogonal to every original near-unit sector:

\[
\boxed{P_jR=RP_j=0.}
\]

## 2. Canonical dilation and labelled embedding

Let

\[
\mathcal Y=\bigoplus_{j=1}^m\mathcal H
\]

and define

\[
Wz=(\sqrt{E_1}z,\ldots,\sqrt{E_m}z).
\]

Because \(\sum_jE_j=I\),

\[
W^*W=I.
\]

The map \(J_{\mathcal K}\) is the direct-sum inclusion defined above, and

\[
J_{\mathcal K}^*J_{\mathcal K}=I_{\mathcal K}.
\]

Since \(P_j\) is a spectral projection of \(E_j\), it commutes with \(\sqrt{E_j}\).

## 3. Exact overlap identity

Define

\[
D=igoplus_j\left.\sqrt{E_j}\right|_{\operatorname{ran}(P_j)}.
\]

Then

\[
\sqrt{1-\delta}\,I\le D\le I.
\]

For \(x\in\mathcal K\), the \(j\)-th component of \(J_{\mathcal K}^*WU x\) is

\[
P_j\sqrt{E_j}Ux
=
\sqrt{E_j}P_jUx.
\]

The \(j\)-th component of \(T^*Ux\) is \(P_jUx\), while

\[
T^*U=H.
\]

Therefore

\[
\boxed{J_{\mathcal K}^*WU=DH.}
\]

Both \(WU\) and \(J_{\mathcal K}\) are isometries, so

\[
(WU-J_{\mathcal K})^*(WU-J_{\mathcal K})
=
2I-HD-DH.
\]

## 4. Dimension-free packed-sector error

Define

\[
\varepsilon=\|WU-J_{\mathcal K}\|_\infty,
\quad
\beta=\|H-I\|_\infty,
\quad
r_\delta=1-\sqrt{1-\delta},
\quad
M=\|H\|_\infty.
\]

Using

\[
2I-HD-DH
=
2(I-H)+H(I-D)+(I-D)H,
\]

we obtain

\[
\boxed{
\varepsilon^2
\le
2\beta+2r_\delta M.
}
\]

Since

\[
I=\sum_jE_j\ge(1-\delta)\sum_jP_j=(1-\delta)TT^*,
\]

we have

\[
M\le(1-\delta)^{-1/2}.
\]

The spectrum of \(H\) lies in \([\alpha,M]\), hence

\[
\beta
\le
\max\left\{
1-\alpha,
(1-\delta)^{-1/2}-1
\right\}.
\]

No \(m\)- or \(d\)-factor appears.

## 5. Exact hybrid-isometry orthogonality

Because \(P_jR=0\) and \(P_j\) commutes with \(\sqrt{E_j}\),

\[
P_j\sqrt{E_j}R=0.
\]

Thus

\[
\boxed{J_{\mathcal K}^*WR=0.}
\]

Define

\[
\boxed{V=J_{\mathcal K}U^*+WR.}
\]

The summands have orthogonal initial and final spaces, so

\[
V^*V=UU^*+R=I.
\]

## 6. Exact implementation of the same-label completion

Let \(\Lambda_j\) project onto output block \(j\). Then

\[
U J_{\mathcal K}^*\Lambda_jJ_{\mathcal K}U^*=Q_j,
\]

\[
R W^*\Lambda_jWR=R E_jR,
\]

and the cross terms vanish. Therefore

\[
\boxed{
V^*\Lambda_jV=Q_j+R E_jR.
}
\]

## 7. Exact isometry-distance identity

Since \(W=W(S+R)\),

\[
V-W=(J_{\mathcal K}-WU)U^*.
\]

Consequently,

\[
\boxed{
\|V-W\|_\infty
=
\|J_{\mathcal K}-WU\|_\infty
=
\varepsilon.
}
\]

## 8. Diamond-norm transfer

The measurement channels are obtained from \(\operatorname{Ad}_W\) and \(\operatorname{Ad}_V\) by the same CPTP label-reading map. Therefore

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
\|\operatorname{Ad}_W-\operatorname{Ad}_V\|_\diamond
\le
2\|W-V\|_\infty.
\]

Hence

\[
\boxed{
\nu_{\rm meas}\le2\varepsilon.
}
\]

This generic Stinespring-continuity step is prior art and should be cited to Kretschmann–Schlingemann–Werner.

## 9. Explicit constant

For \(0<\delta<1/2\),

\[
(1-\delta)^{-1/2}-1\le\delta,
\qquad
r_\delta M\le\delta.
\]

Thus

\[
\varepsilon^2\le2(1-\alpha)+4\delta.
\]

Using \(1-\alpha\le1-\alpha^2\),

\[
\boxed{
\nu
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right).
}
\]

The constant is conservative and not claimed sharp.

## 10. Spectral-gap check

Since

\[
R E_jR\le(1-\delta)R
\]

and

\[
F_j=Q_j+R E_jR,
\]

we obtain

\[
\boxed{
\gamma_F\ge\delta.
}
\]

The hypothesis that every nonzero original effect has a nonzero near-unit sector is essential for repeatability-admissibility of every nonzero completed effect.

## 11. Composite certificate

With record margin \(\kappa>0\) and original idempotence defect \(\eta\),

\[
\|\widetilde\Phi_F^2-\widetilde\Phi_F\|_\diamond
\le
\eta+3\nu.
\]

The RC spectral-gap theorem gives

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{
\frac{2(\eta+3\nu)}
{\kappa\delta}
}.
}
\]

## Verdict

**PASS at the internal-reconstruction level**, with:

- the nonzero-near-unit-sector hypothesis explicit;
- the direct-sum type of \(J_{\mathcal K}\) explicit;
- generic Stinespring continuity attributed to prior work.

This is not external peer review and does not establish novelty.
