# Packing-Conditioned Moving-POVM Rounding

Status: **internally derived; quantitative constants non-optimal; novelty unverified**  
Date: 31 October 2026

This note sharpens the many-outcome moving-POVM programme.

The synthesis-operator conditioner is useful, but the strongest form proposed on 29–31 October needs correction:

- the polar step really does solve the **subspace packing** problem constructively;
- a linear-in-(delta) effect-movement bound is not available from a near-unit spectral threshold alone;
- a dimension-independent channel bound still needs sharper measurement-channel bookkeeping.

A fully rigorous non-optimal theorem is available with an explicit outcome-count factor.

## 1. Near-unit sectors and synthesis operator

Let ({E_j}_{j=1}^m) be a POVM on a finite-dimensional Hilbert space (mathcal H). Fix (0<delta<1).

Let (P_j) be the full spectral projection of (E_j) for eigenvalues in ([1-delta,1]), and put

[
mathcal S_j=operatorname{ran}(P_j).
]

Let

[
mathcal K=igoplus_{j=1}^m mathcal S_j
]

and define the synthesis operator

[
T:mathcal K	omathcal H,
qquad
T(x_1,dots,x_m)=sum_j x_j.
]

Assume

[
alpha:=sigma_{min}(T)>0.
]

Then (T) has full column rank, so in particular

[
sum_jdimmathcal S_jle dimmathcal H.
]

This is the correct higher-rank version of the packing-feasible condition.

## 2. POVM structure controls the top singular value

Because (P_j) is a spectral projection for eigenvalues at least (1-delta),

[
E_jge (1-delta)P_j.
]

Summing over outcomes,

[
I=sum_jE_j
ge
(1-delta)sum_jP_j.
]

But

[
TT^*=sum_jP_j.
]

Therefore

[
TT^*le rac{1}{1-delta}I
]

and hence

[
oxed{
sigma_{max}(T)
le
(1-delta)^{-1/2}.
}
]

This point is important: a lower bound on (sigma_{min}(T)) alone does not control the upper singular values for an arbitrary frame, but the POVM constraint does.

## 3. Polar orthogonalization lemma

Take the polar decomposition

[
T=Q|T|.
]

Since (T) has full column rank, (Q:mathcal K	omathcal H) is an isometry.

For each summand (mathcal S_jsubsetmathcal K), let (R_j) be the projection onto (Qmathcal S_j).

Then the (R_j) are pairwise orthogonal and have the same ranks as the (P_j).

Define

[
eta
=
|T-Q|_infty
=
max_k|sigma_k(T)-1|.
]

The polar factor is the nearest isometry to (T) in every unitarily invariant norm. In particular,

[
oxed{
eta
le
maxleft{
1-alpha,,
(1-delta)^{-1/2}-1
ight}.
}
]

For each sector,

[
oxed{
|P_j-R_j|_infty
le 2eta.
}
]

Thus the synthesis conditioner gives a constructive simultaneous orthogonalization for arbitrary ranks.

The regular-simplex obstruction is correctly detected because there (T) is singular and (alpha=0).

## 4. Repeatable POVM completion

Let

[
R=sum_jR_j,
qquad
C=I-R.
]

Define

[
oxed{
F_j
=
R_j
+
CE_jC.
}
]

Then:

1. (F_jge0).
2. (sum_jF_j=R+C=I).
3. (F_jR_j=R_j).
4. (F_iR_j=0) for (i
eq j).

Therefore every (F_j) has an exact eigenvalue-(1) sector and

[
{F_j}
]

is repeatability-admissible.

This also resolves the (m<d) issue: the orthogonal unit sectors need not span all of (mathcal H); the residual POVM is retained on the orthogonal complement (C).

## 5. Explicit effect-movement bound

Let

[
p=max_j|P_j-R_j|_infty
]

and

[
M=(1-delta)^{-1/2}.
]

The polar construction gives

[
ple 2eta.
]

For a fixed label (j), write

[
R_{-j}=R-R_j.
]

Also set

[
zeta=eta(M+1).
]

The non-(j) original sector operator obeys

[
left|
sum_{i
e j}P_i-R_{-j}
ight|_infty
le zeta.
]

Define

[
a
=
delta+(1-delta)p^2,
]

and

[
b
=
minleft{
1,,
delta+(1-delta)zeta
ight}.
]

Then on the new (j)-sector,

[
R_jE_jR_jge (1-a)R_j,
]

while on the other rounded sectors,

[
R_{-j}E_jR_{-j}le bR_{-j}.
]

Positivity of (E_j) and (I-E_j) bounds the corresponding off-diagonal blocks by square roots of these defects. A direct block decomposition of

[
E_j-F_j
]

therefore gives the conservative dimension-free estimate

[
oxed{
|E_j-F_j|_infty
le
a+b+2sqrt a+2sqrt b.
}
]

Hence with

[
arepsilon_{m mov}
=
minleft{
1,,
a+b+2sqrt a+2sqrt b
ight},
]

we have

[
oxed{
max_j|E_j-F_j|_infty
le
arepsilon_{m mov}.
}
]

For small packing defect this is of order

[
O!left(
sqrt{delta+eta}
ight).
]

The square-root rate is not merely proof slack; Section 8 gives an explicit family showing that a linear (O(delta)) rate is false under spectral-threshold assumptions, even when the packing is perfect.

## 6. Spectral gap of the rounded POVM

Because (P_j) contains all eigenvalues at least (1-delta),

[
E_j
le
P_j+(1-delta)(I-P_j).
]

For a unit vector (xin C), the angle estimate gives

[
|P_jx|le p.
]

Therefore

[
langle x,E_jxangle
le
1-delta+delta p^2.
]

So when (p<1),

[
oxed{
gamma_F
ge
delta(1-p^2)
>0,
}
]

where (gamma_F) is the repeatability spectral gap of the rounded POVM ({F_j}).

A sufficient checkable condition is

[
2eta<1.
]

## 7. Non-optimal channel theorem

Let

[
Phi(ho)
=
sum_joperatorname{Tr}(E_jho)sigma_j
]

have record margin (kappa>0) and idempotence defect

[
eta=|Phi^2-Phi|_diamond.
]

Let

[
widetildePhi(ho)
=
sum_joperatorname{Tr}(F_jho)sigma_j.
]

For a Hermitian functional (Xmapstooperatorname{Tr}(DX)), the completely bounded trace norm is (|D|_infty). Therefore, by the triangle inequality,

[
Delta
:=
|Phi-widetildePhi|_diamond
le
sum_j|E_j-F_j|_infty
le
marepsilon_{m mov}.
]

This is deliberately crude and is the current source of outcome-count dependence.

Since both maps are channels,

[
|widetildePhi^2-widetildePhi|_diamond
le
eta+3Delta.
]

The records are unchanged, so their margin is still (kappa).

Applying the RC POVM spectral-gap theorem to (widetildePhi) gives an exactly idempotent measure-and-prepare channel (Pi), using the repeatability-admissible POVM ({F_j}), with

[
oxed{
|Phi-Pi|_diamond
le
Delta
+
sqrt{
rac{2(eta+3Delta)}
{kappagamma_F}
}.
}
]

Using the explicit estimates above,

[
oxed{
Deltale marepsilon_{m mov},
qquad
gamma_Fgedelta(1-p^2).
}
]

This is a positive many-outcome moving-POVM theorem in the packing-feasible, well-conditioned regime.

It is not yet the desired final theorem because the (m)-factor is likely non-optimal.

## 8. A square-root lower-bound family

The proposed linear effect bound

[
O!left(delta+sqrt{1-alpha^2}ight)
]

is false when (delta) means only the near-unit spectral threshold.

Take (d=4), (m=3), basis (e_1,e_2,e_3,e_4), and (0<deltall1). Put

[
t=rac{sqrtdelta}{4}.
]

Define

[
E_1=
egin{pmatrix}
1-delta/2&0&0&0\\
0&delta/2&0&t\\
0&0&0&0\\
0&t&0&1/4
end{pmatrix},
]

[
E_2=
operatorname{diag}
left(
delta/2,,
1-delta,,
delta/2,,
1/2
ight),
]

and

[
E_3=I-E_1-E_2.
]

For sufficiently small (delta), all three effects are positive.

Their near-unit spectral projections at threshold (1-delta) are exactly

[
P_1=|e_1anglelangle e_1|,
quad
P_2=|e_2anglelangle e_2|,
quad
P_3=|e_3anglelangle e_3|.
]

Thus

[
alpha=1.
]

Nevertheless, any label-preserving repeatable POVM that is uniformly close to this family must move by order (sqrtdelta).

Indeed, if

[
r=max_j|E_j-F_j|_infty
]

and (q_2) is a unit eigenvector of (F_2), then

[
F_2q_2=q_2.
]

Since the next eigenvalue of (E_2) is at most (1/2), the relation

[
|(I-E_2)q_2|le r
]

forces (q_2) to lie within (O(r)) of (e_2).

Repeatability implies

[
F_1q_2=0.
]

But

[
E_1e_2
=
rac{delta}{2}e_2
+
t e_4,
]

whose norm is at least (t).

Therefore

[
rge c,t
]

for an absolute constant (c>0). A conservative estimate gives

[
oxed{
rgtrsim rac{sqrtdelta}{16}.
}
]

Consequently no absolute constant (C) can make

[
rle Cdelta
]

hold uniformly as (delta	o0), even with perfect packing (alpha=1).

The correct general rate must allow at least a square-root dependence on the spectral-threshold defect.

## 9. What is actually resolved

The conceptual geometry is now much clearer:

- (sigma_{min}(T)) is a correct global packing conditioner.
- The polar factor gives the orthogonal sectors constructively.
- The same construction works for higher-rank sectors.
- A repeatability-admissible POVM can be completed explicitly.
- Near-unit spectral threshold alone naturally produces square-root effect movement.
- A full channel theorem follows with a currently crude (m)-dependent perturbation term.

What remains is no longer the existence of a global packing invariant. The main technical targets are:

1. remove or improve the (m)-factor in the measurement-channel diamond bound;
2. sharpen the (sqrt{delta+eta}) constants;
3. obtain a quantitative converse showing that small (sigma_{min}(T)) forces large rounding cost;
4. compare this theorem carefully with prior POVM projectivization / orthogonalization results.

## 10. Prior-art warning

The polar-factor best-approximation step is standard matrix analysis (Fan–Hoffman / Higham / Löwdin orthogonalization).

POVM projectivization is also an established subject. In particular, Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), proves quantitative closeness of almost-orthogonal POVMs to PVMs in a state-dependent (L_2)-type metric, improving earlier finite-dimensional results.

Therefore no novelty claim should be attached to “polar orthogonalization” or “almost-projective POVMs can be rounded” by themselves.

The potentially distinct RC contribution is the combination of:

- synthesis-operator packing conditioning for near-unit sectors,
- explicit repeatability-admissible completion,
- record-margin / idempotence control of the associated measure-and-prepare channel,
- a diamond-norm stability statement.

That combination still requires a deeper literature veto before publication.
