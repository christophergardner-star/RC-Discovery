# Independent Reconstruction of the Same-Label Hybrid Isometry

Date: 31 October 2026  
Status: **PASS with one explicit hypothesis added**

This audit reconstructs the proof of the same-label dimension-free measurement-channel theorem from definitions rather than from the original derivation.

## Setting

Let ({E_j}_{j=1}^m) be a POVM on a finite-dimensional Hilbert space (mathcal H). Fix (0<delta<1/2). For every nonzero outcome effect, let (P_j
eq0) be the full spectral projection of (E_j) onto eigenvalues at least (1-delta).

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
T=UH,qquad H=|T|
]

be the polar decomposition. Then (U:mathcal K	omathcal H) is an isometry. Put

[
Q_j=U R_j^{m coord}U^*,
qquad
S=UU^*=sum_jQ_j,
qquad
R=I-S.
]

## 1. Total-span identity

The range of the synthesis operator is

[
operatorname{ran}(T)=sum_joperatorname{ran}(P_j).
]

Since the polar isometry has the same range,

[
operatorname{ran}(U)=operatorname{ran}(T).
]

Therefore (R) is orthogonal to every original near-unit sector:

[
oxed{P_jR=RP_j=0.}
]

This is the key exact identity behind both the hybrid isometry and the spectral-gap estimate.

## 2. Canonical dilation and labelled embedding

Let

[
mathcal Y=igoplus_{j=1}^mmathcal H
]

and define the canonical measurement isometry

[
W:mathcal H	omathcal Y,
qquad
(Wx)_j=sqrt{E_j},x.
]

Because (sum_jE_j=I),

[
W^*W=I.
]

Define

[
J:mathcal K	omathcal Y
]

by placing the (j)-th direct-sum coordinate into output label (j). Then (J^*J=I_{mathcal K}).

Since (P_j) is a spectral projection of (E_j), it commutes with (sqrt{E_j}).

## 3. Exact overlap identity

Define

[
D=igoplus_jleft.sqrt{E_j}ight|_{operatorname{ran}(P_j)}.
]

Then

[
sqrt{1-delta},Ile Dle I.
]

For (xinmathcal K), the (j)-th component of (J^*WU x) is

[
P_jsqrt{E_j},Ux
=
sqrt{E_j}P_jUx.
]

But the (j)-th component of (T^*Ux) is (P_jUx), while

[
T^*U=H.
]

Therefore

[
oxed{J^*WU=DH.}
]

Hence

[
(WU-J)^*(WU-J)
=
2I-HD-DH.
]

This part of the derivation is correct.

## 4. Dimension-free packed-sector error

Define

[
arepsilon=|WU-J|_infty,
quad
eta=|H-I|_infty,
quad
r_delta=1-sqrt{1-delta},
quad
M=|H|_infty.
]

Since

[
2I-HD-DH
=
2(I-H)+H(I-D)+(I-D)H,
]

the triangle inequality gives

[
oxed{
arepsilon^2
le
2eta+2r_delta M.
}
]

The spectral-threshold condition implies

[
E_jge(1-delta)P_j.
]

Summing,

[
Ige(1-delta)sum_jP_j
=
(1-delta)TT^*,
]

so

[
Mle(1-delta)^{-1/2}.
]

Since the spectrum of (H) lies in ([alpha,M]),

[
eta
le
maxleft{
1-alpha,,
(1-delta)^{-1/2}-1
ight}.
]

No (m) or (d) factor occurs.

## 5. Exact hybrid-isometry orthogonality

Because (P_jR=0) and (P_j) commutes with (sqrt{E_j}),

[
P_jsqrt{E_j}R=0.
]

This implies

[
oxed{J^*WR=0.}
]

Define

[
oxed{V=JU^*+WR.}
]

The two summands have orthogonal initial spaces (Smathcal H) and (Rmathcal H), and orthogonal final ranges because (J^*WR=0). Thus

[
V^*V
=
UU^*+R
=
I.
]

So (V) is exactly an isometry.

## 6. Exact implementation of the same-label completion

Let (Lambda_j) be the projection in (mathcal Y) onto label (j).

Then

[
U J^*Lambda_jJ U^*=Q_j,
]

and

[
R W^*Lambda_j W R=R E_jR.
]

The cross terms vanish because

[
J^*Lambda_jWR
]

has only (j)-th coordinate

[
P_jsqrt{E_j}R=0.
]

Therefore

[
oxed{
V^*Lambda_jV
=
Q_j+R E_jR.
}
]

Thus the proposed (V) is an exact Naimark/Stinespring dilation of the specific same-label completion

[
F_j=Q_j+R E_jR.
]

## 7. Exact isometry-distance identity

Since (W=W(S+R)),

[
V-W
=
JU^*-WS.
]

Both sides vanish on (Rmathcal H). On (Smathcal H), every vector has the form (Ux), and

[
(V-W)Ux
=
Jx-WUx.
]

Because (U) is isometric,

[
oxed{
|V-W|_infty
=
|J-WU|_infty
=
arepsilon.
}
]

## 8. Diamond-norm transfer

The measurement channels are obtained from the isometric channels (operatorname{Ad}_W) and (operatorname{Ad}_V) by the same CPTP label-reading post-processing.

Therefore

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

Hence

[
oxed{

u_{m meas}
le
2arepsilon.
}
]

The same-record measure-and-prepare channels are another common CPTP post-processing, so the same bound holds for (
u).

This is standard Stinespring/channel continuity in the easy direction; it should be cited against Kretschmann–Schlingemann–Werner.

## 9. Explicit absolute constant

For (0<delta<1/2),

[
(1-delta)^{-1/2}-1ledelta
]

and

[
r_delta M
ledelta.
]

Therefore

[
arepsilon^2
le
2(1-alpha)+4delta.
]

Consequently

[

u
le
2sqrt{2(1-alpha)+4delta}.
]

Using (1-alphale1-alpha^2),

[
oxed{

u
le
4left(
sqrt{1-alpha^2}+sqrtdelta
ight).
}
]

The constant (4) is conservative, not claimed sharp.

## 10. Spectral-gap check

Because

[
R E_jRle(1-delta)R
]

and

[
F_j=Q_j+R E_jR,
]

the full eigenvalue-(1) sector of every nonzero (F_j) contains (Q_j), and the rest of the spectrum is at most (1-delta). Under the explicit hypothesis that every nonzero original outcome has a nonzero near-unit sector, each nonzero (F_j) is repeatability-admissible and

[
oxed{gamma_Fgedelta.}
]

### Important hypothesis made explicit

If some nonzero (E_j) has (P_j=0), then (Q_j=0) and

[
F_j=R E_jR
]

need not have eigenvalue (1). The repeatability theorem therefore requires either:

- every nonzero outcome effect has a nonzero near-unit sector, or
- such labels are treated separately.

This hypothesis has now been added to the theorem statement.

## 11. Composite certificate

With record margin (kappa>0) and original idempotence defect (eta),

[
|widetildePhi_F^2-widetildePhi_F|_diamond
le
eta+3
u.
]

The RC spectral-gap Record-Margin theorem therefore gives

[
oxed{
|Phi_E-Pi|_diamond
le

u+
sqrt{
rac{2(eta+3
u)}
{kappadelta}
},
}
]

where

[
oxed{

u
le
4left(
sqrt{1-alpha^2}+sqrtdelta
ight).
}
]

No explicit outcome-count, Hilbert-space dimension, or total-rank factor appears.

## Verdict

**PASS**, after adding the nonzero-near-unit-sector hypothesis.

The hybrid-isometry argument itself reconstructs cleanly from first principles. The next gates are now prior-art novelty, sharper constants, and formalisation—not an unresolved internal algebraic gap.
