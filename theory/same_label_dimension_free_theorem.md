# Same-Label Dimension-Free Moving-POVM Theorem

Date: 31 October 2026  
Status: **internally reconstructed theorem candidate; typed-space audit passed; external review and novelty audit still required**

## 1. Setting

Let \(\{E_j\}_{j=1}^m\) be a finite POVM on a finite-dimensional Hilbert space \(\mathcal H\):

\[
E_j\ge 0,
\qquad
\sum_{j=1}^m E_j=I.
\]

Fix \(0<\delta<1/2\). For every nonzero effect \(E_j\), assume that its full spectral projection onto eigenvalues at least \(1-\delta\) is nonzero; denote it by \(P_j\). Zero effects may be discarded.

Put

\[
\mathcal S_j=\operatorname{ran}(P_j),
\qquad
\mathcal K=\bigoplus_{j=1}^m\mathcal S_j.
\]

Define the synthesis operator

\[
T:\mathcal K\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_j x_j,
\]

and assume

\[
\alpha:=\sigma_{\min}(T)>0.
\]

Write the polar decomposition as

\[
T=UH,
\qquad
H=|T|=(T^*T)^{1/2}.
\]

Since \(T\) is injective, \(U:\mathcal K\to\mathcal H\) is an isometry onto \(\operatorname{ran}(T)\).

Let \(R_j^{\mathcal K}\) be the coordinate projector onto \(\mathcal S_j\subset\mathcal K\), and define

\[
Q_j=U R_j^{\mathcal K}U^*,
\qquad
S=UU^*=\sum_jQ_j,
\qquad
R=I-S.
\]

Define the same-label residual completion

\[
\boxed{
F_j=Q_j+R E_jR.
}
\]

## 2. Packing geometry

The projectors \(Q_j\) are pairwise orthogonal and have the same ranks as \(P_j\). The total rounded span equals the original total sector span:

\[
\operatorname{ran}(U)
=
\operatorname{ran}(T)
=
\mathcal S_1+\cdots+\mathcal S_m.
\]

Consequently,

\[
P_jR=RP_j=0
\]

for every \(j\).

The per-sector principal-angle estimate is

\[
\boxed{
\|P_j-Q_j\|_\infty
\le
\sqrt{1-\alpha^2}.
}
\]

This polar/fusion-frame geometry is classical machinery and is not itself a novelty claim.

## 3. Repeatability-admissible completion and spectral gap

The operators \(F_j\) form a POVM:

\[
\sum_jF_j
=
\sum_jQ_j+R\Bigl(\sum_jE_j\Bigr)R
=S+R=I.
\]

Moreover,

\[
F_iQ_j=\delta_{ij}Q_j.
\]

Thus every nonzero effect has an exact eigenvalue-1 sector and the POVM is repeatability-admissible.

Because \(P_j\) is the full spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\),

\[
E_j
\le
P_j+(1-\delta)(I-P_j).
\]

Compressing with \(R\) and using \(RP_j=0\),

\[
R E_jR\le(1-\delta)R.
\]

Therefore the spectrum below the exact unit sector is at most \(1-\delta\), and

\[
\boxed{
\gamma_F\ge\delta.
}
\]

## 4. Typed labelled embedding

The definition of the labelled isometry is critical.

Let

\[
\mathcal Y=\bigoplus_{j=1}^m\mathcal H
\]

and define the canonical measurement isometry

\[
W:\mathcal H\to\mathcal Y,
\qquad
(Wz)_j=\sqrt{E_j}\,z.
\]

Since \(\sum_jE_j=I\),

\[
W^*W=I.
\]

Define the labelled direct-sum inclusion

\[
J_{\mathcal K}:\mathcal K\to\mathcal Y,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

This map embeds the **original sector vector** \(x_j\in\mathcal S_j\) into outcome block \(j\). In a rank-one sector with original unit vector \(v_j\), the corresponding coordinate basis vector is sent to \(v_j\) in block \(j\), not to the polar-rounded vector \(q_j\).

This typed definition resolves the apparent contradiction recorded in the imported Cruxy notes `correct_WU_J_relation.md` and `naimark_identity_audit.md`, which analyse a different map that embeds \(q_j\) instead.

Let

\[
D=\bigoplus_j
\left.\sqrt{E_j}\right|_{\mathcal S_j}.
\]

Then

\[
\sqrt{1-\delta}\,I_{\mathcal K}
\le D\le I_{\mathcal K}.
\]

## 5. Exact packed-sector overlap identity

For \(x\in\mathcal K\), the \(j\)-th component of \(J_{\mathcal K}^*WU x\) is

\[
P_j\sqrt{E_j}\,Ux
=
\sqrt{E_j}P_jUx.
\]

The \(j\)-th component of \(T^*Ux\) is \(P_jUx\), and the polar decomposition gives

\[
T^*U=H.
\]

Therefore

\[
\boxed{
J_{\mathcal K}^*WU=DH.
}
\]

Both \(WU\) and \(J_{\mathcal K}\) are isometries. Hence

\[
(WU-J_{\mathcal K})^*(WU-J_{\mathcal K})
=
2I-HD-DH.
\]

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

The POVM condition implies

\[
I
=
\sum_jE_j
\ge
(1-\delta)\sum_jP_j
=
(1-\delta)TT^*,
\]

so

\[
M\le(1-\delta)^{-1/2}.
\]

Since the singular spectrum of \(T\) lies in \([\alpha,M]\),

\[
\beta
\le
\max\left\{
1-\alpha,
(1-\delta)^{-1/2}-1
\right\}.
\]

No factor depending on \(m\), \(\dim\mathcal H\), or total packed rank appears.

## 6. Exact same-label hybrid dilation

Because \(R\) is orthogonal to every \(\mathcal S_j\), and \(P_j\) commutes with \(\sqrt{E_j}\),

\[
P_j\sqrt{E_j}R=0.
\]

Therefore

\[
\boxed{
J_{\mathcal K}^*WR=0.
}
\]

Define

\[
\boxed{
V=J_{\mathcal K}U^*+WR.
}
\]

The two terms have orthogonal initial and final spaces, giving

\[
V^*V=UU^*+R=I.
\]

Let \(\Lambda_j\) be the projector in \(\mathcal Y\) onto output block \(j\). Then

\[
J_{\mathcal K}^*\Lambda_jJ_{\mathcal K}=R_j^{\mathcal K},
\]

and the cross terms vanish, so

\[
\boxed{
V^*\Lambda_jV
=Q_j+R E_jR
=F_j.
}
\]

Thus \(V\) is an exact Naimark/Stinespring isometry for the specific same-label completion.

## 7. Dimension-free channel movement

Since \(W=W(S+R)\),

\[
V-W
=(J_{\mathcal K}-WU)U^*.
\]

Therefore

\[
\boxed{
\|V-W\|_\infty
=
\|J_{\mathcal K}-WU\|_\infty
=
\varepsilon.
}
\]

Let \(\mathcal M_E\) and \(\mathcal M_F\) be the classical-output measurement channels of \(E\) and \(F\). They are obtained from \(\operatorname{Ad}_W\) and \(\operatorname{Ad}_V\) by the same CPTP label-reading channel. Hence

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
\|\operatorname{Ad}_W-\operatorname{Ad}_V\|_\diamond
\le
2\|W-V\|_\infty.
\]

Thus

\[
\boxed{
\nu_{\rm meas}
\le
2\varepsilon
\le
2\sqrt{2\beta+2r_\delta M}.
}
\]

For \(0<\delta<1/2\),

\[
(1-\delta)^{-1/2}-1\le\delta,
\qquad
r_\delta M\le\delta,
\]

so

\[
\varepsilon^2\le2(1-\alpha)+4\delta.
\]

Using \(1-\alpha\le1-\alpha^2\), one obtains the conservative explicit estimate

\[
\boxed{
\nu_{\rm meas}
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right).
}
\]

If the same record states are prepared after the classical outcome, this preparation is a common CPTP post-processing. Therefore the associated measure-and-prepare channels obey the same bound:

\[
\boxed{
\nu
=
\|\Phi_E-\widetilde\Phi_F\|_\diamond
\le
\nu_{\rm meas}.
}
\]

The generic Stinespring-continuity step is established prior art and is not claimed as new.

## 8. Exact-idempotent record certificate

**Audit qualification (31 October 2026):** the certificate below can be useful with actual or sufficiently sharp instance-dependent movement. Substituting either scalar movement envelope displayed here always gives an upper bound greater than 2, the trivial maximum channel distance. Thus these substitutions do not establish a nontrivial a priori exact-idempotent stability guarantee. The measurement-rounding bound is unaffected. See [the prior-art and certificate audit, Section 4](../literature/SAME_LABEL_PRIOR_ART_VETO_2026-10-31.md).

Assume that the original measure-and-prepare channel has record margin \(\kappa>0\) and idempotence defect

\[
\eta=\|\Phi_E^2-\Phi_E\|_\diamond.
\]

The moved channel has the same record states, and

\[
\|\widetilde\Phi_F^2-\widetilde\Phi_F\|_\diamond
\le
\eta+3\nu.
\]

Applying the RC spectral-gap Record-Margin theorem with \(\gamma_F\ge\delta\) gives an exactly idempotent channel \(\Pi\) satisfying

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

Together with

\[
\nu
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right),
\]

this is dimension- and outcome-count independent.

## 9. Status and claim boundary

### Internally established

- the typed direct-sum identity \(J_{\mathcal K}^*WU=DH\);
- the exact hybrid isometry;
- exact implementation of \(F_j=Q_j+R E_jR\);
- \(\gamma_F\ge\delta\);
- the dimension-free operational bound, conditional on the stated hypotheses;
- the composite certificate, conditional on the RC spectral-gap theorem.

### Not yet externally established

- independent specialist verification;
- full proof-assistant formalisation;
- optimal constants and rates;
- novelty relative to all prior literature.

### Prior-art boundary

Polar/Löwdin orthogonalisation, fusion-frame synthesis operators, Naimark and Stinespring dilation, Stinespring continuity, repeatable-POVM criteria, and general POVM orthogonalisation/simulation are established prior art. The only potentially distinct object is the complete, correctly typed synthesis-conditioned same-label chain. Its novelty remains unverified.

See:

- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`
