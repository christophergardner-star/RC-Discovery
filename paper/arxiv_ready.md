# A Packing Condition for Approximate Quantum Measurements

**Authors:** Christopher Gardner  
**Affiliation:** Independent / RC-Discovery programme  
**Date:** 31 October 2026  
**Status:** public research draft; not peer-reviewed

## Abstract

We study when near-unit spectral sectors of a finite POVM can be moved to mutually orthogonal repeatable sectors. Let (P_j) be selected near-unit spectral projections and let
[
T:igoplus_j operatorname{ran}(P_j)	omathcal H,qquad (x_j)mapstosum_jx_j
]
be their synthesis operator. A positive lower singular-value bound
[
alpha=sigma_{min}(T)>0
]
is a natural global packing condition: it detects the regular-simplex obstruction and, via the polar factor of (T), gives a constructive simultaneous orthogonalisation at arbitrary rank. The resulting per-sector movement satisfies
[
|P_j-Q_j|_inftyle sqrt{1-alpha^2}.
]
Under the stronger whole-effect assumption (|E_j-P_j|_inftyledelta), this yields an explicit nearby repeatability-admissible POVM. Under the weaker assumption that (P_j) merely collects eigenvalues above (1-delta), a generic linear (O(delta)) movement bound is false; an explicit family requires (Omega(sqrtdelta)) correction even when (alpha=1).

For the associated measure-and-prepare channel, the exact remaining quantity is the measurement-channel perturbation
[

u=|Phi_E-widetildePhi_F|_diamond.
]
Combining the moved POVM with the RC spectral-gap Record-Margin theorem gives
[
|Phi_E-Pi|_diamond
le

u+
sqrt{rac{2(eta+3
u)}{kappagamma_F}}.
]
A dimension/outcome-independent bound on (
u) remains open. The real-arithmetic core of the rank-1 geometry is machine-checked in Lean 4 + Mathlib with zero `sorry`.

## 1. Motivation

Local diagnostics such as near-unit eigenvalues, good record separation, and small idempotence defect do not by themselves guarantee proximity to a same-label repeatable measurement. The regular-simplex family gives a global packing obstruction.

The aim of this note is therefore to isolate a global geometric invariant that detects this obstruction and gives a constructive rounding when packing is feasible.

## 2. Packing condition

Let ({E_j}_{j=1}^m) be a finite POVM on a (d)-dimensional Hilbert space. Let (P_j) be chosen near-unit spectral projections and define
[
mathcal S_j=operatorname{ran}(P_j),qquad
mathcal K=igoplus_jmathcal S_j.
]
The synthesis operator is
[
T:mathcal K	omathcal H,qquad
T(x_1,dots,x_m)=sum_jx_j.
]

Define
[
alpha=sigma_{min}(T).
]

If (alpha>0), then (T) is injective, so automatically
[
sum_jdimmathcal S_jle d.
]

## 3. All-rank polar orthogonalisation theorem

Let
[
T=U|T|
]
be the polar decomposition. Since (T) is injective, (U) is an isometry on (mathcal K).

Let (R_j) be the coordinate projection onto the (j)-th direct-sum sector and define
[
Q_j=UR_jU^*.
]

Then the (Q_j) are pairwise orthogonal projections with
[
operatorname{rank}Q_j=operatorname{rank}P_j.
]

### Theorem 1

If (alpha=sigma_{min}(T)>0), then for every (j),
[
oxed{
|P_j-Q_j|_inftyle sqrt{1-alpha^2}.
}
]

### Proof sketch

Take a unit vector (xinmathcal S_j), and identify it with the corresponding unit vector (einmathcal K). Then (Te=x) and (Uein Umathcal S_j). Since (|T|gealpha I),
[
langle x,Ueangle
=
langle Te,Ueangle
=
langle |T|e,eangle
gealpha.
]
Therefore the largest principal angle between (mathcal S_j) and (Umathcal S_j) has cosine at least (alpha). Equal-dimensional projection geometry gives the result.

The regular simplex is correctly detected by (alpha=0).

## 4. Rank-1 specialisation and Lean status

For unit columns (V=[v_1cdots v_m]), the polar factor
[
Q=V(V^*V)^{-1/2}
]
has orthonormal columns (q_j), and
[
igl||v_janglelangle v_j|-|q_janglelangle q_j|igr|_infty
le
sqrt{1-sigma_{min}(V)^2}.
]

The public Lean development machine-checks the real-arithmetic core:
- `projector_const_one`,
- `polar_residual_le`,
- `near_orthonormal_overlap`,
- `rank1_core_package`.

It does not yet formalise the Hilbert-space polar decomposition, higher-rank synthesis operator, or diamond norm.

## 5. Constructive repeatability-admissible completion under whole-effect closeness

Assume the stronger hypothesis
[
|E_j-P_j|_inftyledelta
]
for every (j).

Let
[
s=sqrt{1-alpha^2},qquad e=delta+s.
]
Then
[
|E_j-Q_j|_inftyle e.
]

Set
[
Q=sum_jQ_j,qquad R=I-Q,
]
and define
[
oxed{
F_j=Q_j+R E_jR.
}
]

Then:
- (F_jge0),
- (sum_jF_j=I),
- (F_iQ_j=delta_{ij}Q_j).

Thus ({F_j}) is repeatability-admissible, including the case (m<d).

Moreover,
[
oxed{
|E_j-F_j|_inftyle 2e.
}
]

If (e<1), then the repeatability spectral gap satisfies
[
gamma_Fge1-e.
]

## 6. Spectral-threshold-only assumptions require square-root movement in general

If (P_j) is only defined as the spectral projection onto eigenvalues (ge1-delta), one does not generally have
[
|E_j-P_j|_inftyledelta.
]

An explicit (d=4,m=3) POVM family in RC-Discovery has perfect packing (alpha=1) but requires (Omega(sqrtdelta)) movement. Hence a universal linear (O(delta)) effect-movement claim is false under the weaker spectral-threshold assumption.

## 7. Channel transfer

Let
[
Phi_E(ho)=sum_joperatorname{Tr}(E_jho)sigma_j
]
and let
[
widetildePhi_F(ho)=sum_joperatorname{Tr}(F_jho)sigma_j.
]

Define
[

u=|Phi_E-widetildePhi_F|_diamond,
qquad
eta=|Phi_E^2-Phi_E|_diamond.
]

Then
[
|widetildePhi_F^2-widetildePhi_F|_diamond
le
eta+3
u.
]

Applying the RC POVM spectral-gap Record-Margin theorem gives an exactly idempotent channel (Pi) with
[
oxed{
|Phi_E-Pi|_diamond
le

u+
sqrt{rac{2(eta+3
u)}{kappagamma_F}}.
}
]

This is the rigorous transfer statement presently supported by the proof audit.

A general safe estimate is
[

ule sum_j|E_j-F_j|_infty,
]
which can carry an outcome-count factor. Removing or proving the necessity of that dependence is the main open step.

## 8. What is proved and what remains open

### Proved / independently audited
- synthesis conditioning detects the global packing obstruction;
- polar orthogonalisation works at arbitrary rank;
- per-sector movement obeys (sqrt{1-alpha^2});
- a repeatability-admissible completion exists under whole-effect closeness;
- the RC Record-Margin and spectral-gap channel bounds survive independent reconstruction;
- the rank-1 real-arithmetic core is Lean checked.

### Open
- a dimension/outcome-independent bound on the measurement-channel perturbation (
u);
- the sharp generic rate under spectral-threshold-only assumptions;
- a quantitative converse with optimal constants;
- full Lean formalisation of the operator/channel steps;
- novelty after comparison with prior POVM orthogonalisation results.

## 9. Prior work

The polar / Löwdin nearest-isometry construction is classical linear algebra and is not a novelty claim.

Quantitative POVM orthogonalisation is also established prior art; in particular, de la Salle (2022) is a mandatory comparison.

The potentially distinct RC contribution is the combination of:
- near-unit synthesis packing,
- repeatability-admissible completion,
- record-margin/idempotence control,
- downstream diamond-norm certification.

Novelty of that combination remains unverified.

## 10. Conclusion

The geometric packing bottleneck is substantially resolved: (sigma_{min}(T)>0) gives a constructive all-rank orthogonalisation with explicit per-sector control.

The full absolute-constant moving-channel theorem is not yet established. Its remaining bottleneck is the structured measurement-channel perturbation (
u).

This is the current submission-safe statement.
