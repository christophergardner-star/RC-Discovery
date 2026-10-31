# A Packing Condition for Approximate Quantum Measurements

**Author:** Christopher Gardner  
**Affiliation:** Independent / RC-Discovery programme  
**Date:** 31 October 2026  
**Status:** research draft; not peer-reviewed; novelty unverified

## Abstract

We study a record-structured class of finite POVMs with near-unit spectral sectors. Let (P_j) be the full spectral projection of (E_j) onto eigenvalues at least (1-delta), and let

[
T:igoplus_joperatorname{ran}(P_j)	omathcal H,
qquad
T(x_j)=sum_jx_j
]

be the synthesis operator. Writing

[
alpha=sigma_{min}(T)>0,
]

the polar factor of (T) produces mutually orthogonal sectors (Q_j) with

[
|P_j-Q_j|_inftylesqrt{1-alpha^2}.
]

For every nonzero outcome effect we assume (P_j
eq0). Let

[
R=I-sum_jQ_j
]

and define the same-label completion

[
F_j=Q_j+R E_jR.
]

Then ({F_j}) is a POVM whose nonzero effects possess exact repeatable eigenvalue-1 sectors and whose repeatability spectral gap obeys

[
gamma_Fgedelta.
]

Using a hybrid Naimark/Stinespring isometry

[
V=JU^*+WR,
]

where (W) is the canonical measurement dilation and (J) is the labelled embedding of the packed sectors, one obtains the outcome-count- and dimension-independent measurement-channel estimate

[

u=
|mathcal M_E-mathcal M_F|_diamond
le
4left(
sqrt{1-alpha^2}+sqrtdelta
ight).
]

Combining this with the RC spectral-gap Record-Margin theorem yields an exactly idempotent measure-and-prepare channel (Pi) satisfying

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

where (eta=|Phi_E^2-Phi_E|_diamond) and (kappa) is the record margin. The bound has no explicit dependence on the number of outcomes, Hilbert-space dimension, or total packed rank. The hybrid-isometry proof has survived an independent internal reconstruction. The main remaining gates are prior-art novelty, sharper constants, and full formalisation.

## 1. Motivation

Local diagnostics do not suffice to guarantee proximity to repeatable measurement. In particular, regular-simplex families can simultaneously exhibit:

- small idempotence defect,
- good record separation,
- near-unit effects,
- near-reachable records,

while remaining far from same-label repeatability.

This motivates a global packing parameter.

## 2. Packing condition

Let ({E_j}_{j=1}^m) be a finite POVM on a finite-dimensional Hilbert space (mathcal H). Fix (0<delta<1/2).

For every nonzero (E_j), let (P_j
eq0) be the full spectral projection onto eigenvalues at least (1-delta). Define

[
mathcal K=igoplus_joperatorname{ran}(P_j)
]

and

[
T:mathcal K	omathcal H,
qquad
T(x_1,ldots,x_m)=sum_jx_j.
]

Assume

[
alpha=sigma_{min}(T)>0.
]

Then (T) is injective and the total packed rank is at most (dimmathcal H).

## 3. Polar packing theorem

Let

[
T=UH
]

be the polar decomposition, with (H=|T|). Let (R_j^{m coord}) be the coordinate projection on the (j)-th direct-sum sector and define

[
Q_j=U R_j^{m coord}U^*.
]

The (Q_j) are pairwise orthogonal and have the same ranks as the (P_j).

For every (j),

[
oxed{
|P_j-Q_j|_infty
le
sqrt{1-alpha^2}.
}
]

The proof follows from principal-angle geometry and the inequality

[
langle Te,Ueangle
=
langle He,eangle
gealpha
]

for unit coordinate vectors (e).

The polar step itself is classical linear algebra and is not a novelty claim.

## 4. Same-label repeatable completion

Define

[
S=sum_jQ_j=UU^*,
qquad
R=I-S.
]

Because (operatorname{ran}(U)=operatorname{ran}(T)), (R) is orthogonal to every original near-unit sector (P_j):

[
P_jR=RP_j=0.
]

Define

[
oxed{
F_j=Q_j+R E_jR.
}
]

Then:

1. (F_jge0);
2. (sum_jF_j=I);
3. (F_iQ_j=delta_{ij}Q_j).

Hence ({F_j}) is repeatability-admissible.

Because

[
E_jle P_j+(1-delta)(I-P_j),
]

compression by (R) gives

[
R E_jRle(1-delta)R.
]

Therefore

[
oxed{gamma_Fgedelta.}
]

## 5. Hybrid isometry

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

Let

[
J:mathcal K	omathcal Y
]

embed the (j)-th direct-sum coordinate into output label (j).

Since (P_j) commutes with (sqrt{E_j}) and (P_jR=0),

[
oxed{J^*WR=0.}
]

Define

[
oxed{
V=JU^*+WR.
}
]

The two terms have orthogonal initial and final spaces, so

[
V^*V=I.
]

If (Lambda_j) is the projector onto output label (j), then the cross terms vanish and

[
oxed{
V^*Lambda_jV
=
Q_j+R E_jR
=
F_j.
}
]

Thus (V) is an exact Naimark/Stinespring dilation of the same-label completed POVM.

## 6. Dimension-free measurement-channel bound

Let

[
D=
igoplus_j
left.sqrt{E_j}ight|_{operatorname{ran}(P_j)}.
]

Then

[
sqrt{1-delta},Ile Dle I
]

and

[
J^*WU=DH.
]

Therefore

[
(WU-J)^*(WU-J)
=
2I-HD-DH.
]

Define

[
arepsilon=|WU-J|_infty,
]

[
eta=|H-I|_infty,
qquad
r_delta=1-sqrt{1-delta},
qquad
M=|H|_infty.
]

Then

[
oxed{
arepsilon^2
le
2eta+2r_delta M.
}
]

The POVM condition gives

[
Mle(1-delta)^{-1/2}
]

and

[
etale
maxleft{
1-alpha,,
(1-delta)^{-1/2}-1
ight}.
]

Also,

[
|V-W|_infty
=
|J-WU|_infty
=
arepsilon.
]

Since both measurement channels are obtained from the two isometric channels by the same label-reading CPTP post-processing,

[
|mathcal M_E-mathcal M_F|_diamond
le
2|V-W|_infty.
]

Hence

[
oxed{

u
le
2arepsilon.
}
]

For (0<delta<1/2), a simple explicit bound is

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

The constant (4) is conservative and not claimed optimal.

## 7. Exact-idempotent record certificate

Let

[
Phi_E(ho)
=
sum_joperatorname{Tr}(E_jho)sigma_j
]

with record margin (kappa>0) and idempotence defect

[
eta=|Phi_E^2-Phi_E|_diamond.
]

Let (widetildePhi_F) use the moved POVM (F_j) with the same records.

Because the record-preparation map is a common CPTP post-processing,

[
|Phi_E-widetildePhi_F|_diamondle
u.
]

Also,

[
|widetildePhi_F^2-widetildePhi_F|_diamond
le
eta+3
u.
]

Applying the RC spectral-gap Record-Margin theorem with (gamma_Fgedelta) gives an exactly idempotent channel (Pi) satisfying

[
oxed{
|Phi_E-Pi|_diamond
le

u+
sqrt{
rac{2(eta+3
u)}
{kappadelta}
}.
}
]

This is the current dimension-free same-label certificate.

## 8. Negative results and sharpness information

Several stronger statements were falsified during the derivation.

### Local diagnostics alone are insufficient

The regular-simplex obstruction shows that local near-repeatability does not imply global repeatability.

### Linear spectral-threshold movement is false

An explicit (d=4,m=3), (alpha=1) family requires order-(sqrtdelta) movement, so generic (O(delta)) dependence is impossible under spectral-threshold-only assumptions.

### Extra-outcome shortcut fails

Routing all residual mass to a new projective outcome can produce measurement-channel diamond distance (2), even with perfect packing.

Thus the same-label hybrid construction is not replaceable by that shortcut.

## 9. Verification status

### Independently reconstructed internally

- sharp Record-Margin theorem;
- POVM spectral-gap theorem;
- same-label hybrid-isometry construction;
- exact implementation (V^*Lambda_jV=F_j);
- dimension-free measurement-channel estimate;
- (gamma_Fgedelta).

### Numerically stress-tested

- rank-1 and higher-rank polar sector movement;
- same-label hybrid isometry;
- exact POVM implementation;
- scaling with outcome count.

### Lean 4 + Mathlib

Machine checked with zero `sorry`:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`.

The full Hilbert-space/channel theorem is not yet machine formalised.

## 10. Prior-art boundary

The following ingredients are known and are not claimed as novel:

- polar / Löwdin / Fan-Hoffman nearest-isometry results;
- quantitative POVM orthogonalisation, including de la Salle;
- continuity of Stinespring dilations and channel distance, including Kretschmann-Schlingemann-Werner;
- Kitaev's approximate-algebra treatment of almost-idempotent channels.

The potentially distinct contribution is the particular synthesis-conditioned same-label construction and its combination with Record-Margin stability to produce the explicit dimension-free exact-idempotent certificate above.

Novelty remains unverified.

## 11. Conclusion

At the internal-proof level, the same-label chain is closed:

[
oxed{
	ext{synthesis packing}
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

The remaining work is external validation and positioning:

1. deep prior-art search;
2. external review;
3. sharpen constants;
4. formalise the full theorem;
5. determine the optimal joint dependence on (alpha) and (delta).

