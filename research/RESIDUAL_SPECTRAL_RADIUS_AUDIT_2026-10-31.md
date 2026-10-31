# Residual Spectral Radius Audit: no new invariant is needed

Date: 31 October 2026  
Status: **exact correction / strengthening**

The proposed residual spectral radius

[
ho_{m res}:=max_j|R E_j R|_infty
]

is useful notation, but for the residual projector

[
R=I-sum_jQ_j
]

coming from the polar synthesis construction it is **already controlled by the spectral threshold**.

It is not an independent invariant.

## 1. Key range identity

Let

[
T:igoplus_jmathcal S_j	omathcal H
]

be the synthesis operator, with (mathcal S_j=operatorname{ran}(P_j)), and let

[
T=U|T|
]

be its polar decomposition.

Because (alpha=sigma_{min}(T)>0), (T) is injective and (U) is an isometry onto (operatorname{ran}(T)).

The polar-rounded sectors are

[
Q_j=UR_j^{m coord}U^*.
]

Therefore

[
sum_jQ_j=UU^*,
]

the orthogonal projection onto

[
operatorname{ran}(T)
=
mathcal S_1+cdots+mathcal S_m.
]

Hence

[
R:=I-sum_jQ_j
]

is the orthogonal projection onto the complement of the **entire original near-unit span**.

Consequently, for every (j),

[
oxed{P_jR=RP_j=0.}
]

This is exact and does not depend on how far the individual (P_j) move to (Q_j).

## 2. Residual spectral radius bound

Because (P_j) is the full spectral projection of (E_j) for eigenvalues at least (1-delta),

[
E_j
le
P_j+(1-delta)(I-P_j).
]

Compressing by (R), and using (RP_j=0),

[
R E_j R
le
(1-delta)R.
]

Therefore

[
oxed{
ho_{m res}
=
max_j|R E_j R|_infty
le
1-delta.
}
]

So the residual radius is automatically bounded away from (1) whenever (delta>0).

## 3. Immediate consequence for the explicit residual completion

For the same-label completion

[
F_j=Q_j+R E_jR,
]

the Hilbert space decomposes orthogonally as

[
mathcal H
=
Q_jmathcal H
oplus
left(igoplus_{i
e j}Q_imathcal Hight)
oplus
Rmathcal H.
]

On these pieces, (F_j) acts as:

- identity on (Q_jmathcal H);
- zero on every (Q_imathcal H), (i
e j);
- (R E_jR) on (Rmathcal H).

Therefore the spectral radius below the exact eigenvalue-(1) sector is at most (1-delta), and

[
oxed{
gamma_Fgedelta.
}
]

This is stronger than the earlier bound involving the packing angle.

## 4. What remains open

For the explicit residual completion

[
F_j=Q_j+R E_jR,
]

the spectral-gap problem is therefore solved.

The remaining same-label bottleneck is again exactly the measurement-channel perturbation

[

u
=
|mathcal M_E-mathcal M_F|_diamond.
]

The current crude proof gives an (m)-dependent sum, while numerical experiments suggest the true bound is outcome-count independent.

Thus the sharp target is now:

[
oxed{
|mathcal M_E-mathcal M_F|_diamond
stackrel{?}{le}
Cleft(
sqrt{1-alpha^2}
+
sqrtdelta
ight)
}
]

for the **specific residual completion** (F_j=Q_j+R E_jR), with absolute (C).

If this is proved, then the full same-label chain closes with

[
gamma_Fgedelta
]

and the RC spectral-gap theorem.

## 5. Conceptual lesson

The polar factor changes the decomposition **inside the span of the near-unit sectors**, but it does not change that total span.

That is why the residual complement is automatically orthogonal to every original (P_j).

The missing information was therefore not residual spectral radius. It remains the collective channel cost of rotating/repacking the protected sector decomposition.
