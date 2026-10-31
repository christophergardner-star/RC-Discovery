# Same-Label Dimension-Free Moving-POVM Theorem

Date: 31 October 2026  
Status: **internally proved theorem candidate; independent audit required**

## Result

The remaining same-label measurement-channel bottleneck can be removed directly.

Let ({E_j}_{j=1}^m) be a finite POVM. Fix (0<delta<1/2), and let (P_j) be the full spectral projection of (E_j) onto eigenvalues at least (1-delta). Assume every nonzero outcome effect (E_j) has a nonzero such sector (P_j); zero effects may be discarded.

Let

[
mathcal K=igoplus_joperatorname{ran}(P_j),
qquad
T:mathcal K	omathcal H,quad
T(x_j)=sum_jx_j,
]

and assume

[
alpha=sigma_{min}(T)>0.
]

Let

[
T=U H,qquad H=|T|,
]

be the polar decomposition. Define the mutually orthogonal rounded sectors

[
Q_j=U R_j^{m coord}U^*,
]

their total projector

[
S=sum_jQ_j=UU^*,
]

and residual projector

[
R=I-S.
]

Define the same-label residual completion

[
oxed{
F_j=Q_j+R E_jR.
}
]

Then ({F_j}) is a POVM with exact repeatable sectors (Q_j), and

[
oxed{gamma_Fgedelta.}
]

Moreover, the measurement channels obey an outcome-count- and dimension-independent bound.

---

## 1. Canonical dilation of the original POVM

Let

[
mathcal Y=igoplus_{j=1}^mmathcal H
]

and define

[
W:mathcal H	omathcal Y,
qquad
(Wx)_j=sqrt{E_j},x.
]

Because (sum_jE_j=I),

[
W^*W=I.
]

Let

[
J:mathcal K	omathcal Y
]

be the labelled direct-sum isometry

[
(J(x_1,ldots,x_m))_j=x_j.
]

For each (j), (P_j) commutes with (sqrt{E_j}). Define

[
D=igoplus_jleft.sqrt{E_j}ight|_{operatorname{ran}(P_j)}.
]

Then

[
sqrt{1-delta},Ile Dle I.
]

---

## 2. Packed-sector overlap

A direct calculation gives

[
oxed{
J^*WU=DH.
}
]

Indeed, the (j)-th coordinate of (T^*Ux) is (P_jUx), while

[
T^*U=H.
]

Therefore

[
(WU-J)^*(WU-J)
=
2I-HD-DH.
]

Define

[
arepsilon=|WU-J|_infty.
]

Then

[
oxed{
arepsilon^2
=
|2I-HD-DH|_infty.
}
]

Set

[
eta=|H-I|_infty,
qquad
r_delta=1-sqrt{1-delta},
qquad
M=|H|_infty.
]

Since

[
2I-HD-DH
=
2(I-H)+H(I-D)+(I-D)H,
]

we obtain

[
oxed{
arepsilon^2
le
2eta+2r_delta M.
}
]

The POVM condition gives

[
(1-delta)TT^*
le I,
]

so

[
Mle(1-delta)^{-1/2}.
]

Also

[
eta
le
maxleft{
1-alpha,,
(1-delta)^{-1/2}-1
ight}.
]

No outcome count or Hilbert-space dimension appears.

---

## 3. Exact same-label dilation

The crucial simplification is that the residual part of the original canonical dilation is already exactly orthogonal to the labelled packed isometry.

Because

[
Rperpoperatorname{ran}(P_j)
]

for every (j), and (P_j) commutes with (sqrt{E_j}),

[
P_jsqrt{E_j}R
=
sqrt{E_j}P_jR
=
0.
]

Hence

[
oxed{J^*WR=0.}
]

Now define

[
oxed{
V=JU^*+WR.
}
]

Since the two summands have orthogonal initial and final spaces,

[
V^*V
=
UU^*+R
=
I.
]

Thus (V) is an isometry.

Let (Lambda_j) be the projection in (mathcal Y) onto label (j). Then

[
V^*Lambda_jV
=
Q_j+R E_jR
=
F_j.
]

The cross terms vanish exactly because

[
J^*Lambda_jWR=0.
]

So (V) is a Stinespring/Naimark isometry for the **specific same-label completion** (F_j=Q_j+RE_jR).

---

## 4. Exact isometry movement

Since (W=WS+WR) and (UU^*=S),

[
V-W
=
JU^*-WS.
]

On (S), every vector is (Ux), so

[
oxed{
|V-W|_infty
=
|J-WU|_infty
=
arepsilon.
}
]

Let (mathcal M_E,mathcal M_F) be the corresponding classical-output measurement channels. Reading the label is the same CPTP post-processing of the two isometric channels, so

[
|mathcal M_E-mathcal M_F|_diamond
le
|operatorname{Ad}_W-operatorname{Ad}_V|_diamond.
]

For isometries,

[
|operatorname{Ad}_W-operatorname{Ad}_V|_diamond
le
2|W-V|_infty.
]

Therefore

[
oxed{

u_{m meas}
:=
|mathcal M_E-mathcal M_F|_diamond
le
2arepsilon.
}
]

Combining with the previous section,

[
oxed{

u_{m meas}
le
2sqrt{
2eta+2r_delta M
}.
}
]

This is independent of (m) and (d).

If the same record states are prepared after each label, the measure-and-prepare channel difference is a CPTP post-processing of the measurement-channel difference. Hence

[
oxed{

u
=
|Phi_E-widetildePhi_F|_diamond
le
2arepsilon.
}
]

---

## 5. Simple asymptotic bound

For (0<delta<1/2),

[
(1-delta)^{-1/2}-1ledelta.
]

Also (0<alphale1), because restricting (T) to any single direct-sum sector is an isometry.

Hence

[
arepsilon^2
le
2(1-alpha)+4delta.
]

Therefore

[

u
le
2sqrt{2(1-alpha)+4delta}.
]

Using

[
1-alphale1-alpha^2,
]

and (sqrt{x+y}lesqrt x+sqrt y),

[
oxed{

u
le
4left(
sqrt{1-alpha^2}
+
sqrtdelta
ight).
}
]

So the conjectured outcome-independent structure is true with an explicit absolute constant (C=4).

The constant is not claimed optimal.

---

## 6. Spectral gap

Because the polar-rounded sectors span the same total space as the original near-unit sectors,

[
R P_j=0.
]

The full spectral-threshold property gives

[
E_j
le
P_j+(1-delta)(I-P_j).
]

Thus

[
R E_jR
le
(1-delta)R.
]

Since

[
F_j=Q_j+R E_jR,
]

the spectrum outside the exact unit sector (Q_j) is bounded above by (1-delta). Therefore

[
oxed{gamma_Fgedelta.}
]

---

## 7. Dimension-free exact-idempotent certificate

**Audit qualification (31 October 2026):** the certificate below can be useful with actual or sufficiently sharp instance-dependent movement. Substituting either scalar movement envelope displayed here always gives an upper bound greater than 2, the trivial maximum channel distance. Thus these substitutions do not establish a nontrivial a priori exact-idempotent stability guarantee. The measurement-rounding bound is unaffected. See [the prior-art and certificate audit, Section 4](../literature/SAME_LABEL_PRIOR_ART_VETO_2026-10-31.md).

Let the original measure-and-prepare channel have record margin

[
kappa>0
]

and idempotence defect

[
eta=|Phi_E^2-Phi_E|_diamond.
]

The moved channel has the same records and therefore the same record margin. Its idempotence defect satisfies

[
|widetildePhi_F^2-widetildePhi_F|_diamond
le
eta+3
u.
]

Applying the RC spectral-gap Record-Margin theorem with

[
gamma_Fgedelta
]

gives an exactly idempotent channel (Pi) satisfying

[
oxed{
|Phi_E-Pi|_diamond
le

u
+
sqrt{
rac{2(eta+3
u)}
{kappadelta}
},
}
]

with

[
oxed{

u
le
2sqrt{
2eta+2r_delta M
}
le
4left(
sqrt{1-alpha^2}
+
sqrtdelta
ight).
}
]

There is no explicit dependence on (m), (d), or the total sector rank.

---

## 8. Current assessment

At the internal-proof level, this closes the same-label chain:

[
oxed{
	ext{packing}
	o
	ext{orthogonal repeatable sectors}
	o
	ext{same-label dimension-free channel move}
	o
	ext{spectral gap}
	o
	ext{exact idempotent record process}.
}
]

The result still requires:

1. independent reconstruction of the dilation identities;
2. literature veto against existing POVM/Naimark perturbation theorems;
3. checking of all norm conventions and threshold endpoint choices;
4. eventual formalisation of the Hilbert-space/channel argument.

The polar decomposition itself is classical and is not a novelty claim. The potentially new statement is the combined dimension-free same-label certificate for the record-structured class.
