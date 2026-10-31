# Packing-Feasible Moving-POVM Result — Audited Version

**Status:** geometric core proved; channel transfer partially proved; novelty unverified  
**Date:** 31 October 2026

## Main geometric invariant

For selected near-unit spectral sectors (mathcal S_j=operatorname{ran}(P_j)), define
[
T:igoplus_jmathcal S_j	omathcal H,qquad (x_j)mapstosum_jx_j,
]
and
[
alpha=sigma_{min}(T).
]

A positive (alpha) is the correct global packing conditioner: it detects linear dependence of the sector family, including the regular-simplex obstruction.

## All-rank theorem

Let (T=U|T|) be the polar decomposition and let (Q_j) be the projection onto the moved sector (Umathcal S_j). Then the (Q_j) are pairwise orthogonal, have the same ranks as (P_j), and
[
oxed{|P_j-Q_j|_inftylesqrt{1-alpha^2}.}
]

This follows from principal-angle geometry:
[
langle Te,Ueangle=langle |T|e,eanglegealpha
]
for every unit coordinate vector (e).

## Rank-1 case

For unit columns (V=[v_1cdots v_m]), the polar factor
[
Q=V(V^*V)^{-1/2}
]
has orthonormal columns (q_j), and
[
igl||v_janglelangle v_j|-|q_janglelangle q_j|igr|_infty
lesqrt{1-sigma_{min}(V)^2}.
]

## Repeatability-admissible completion

If the stronger whole-effect estimate
[
|E_j-P_j|_inftyledelta
]
holds, set
[
s=sqrt{1-alpha^2},qquad e=delta+s.
]
Then (|E_j-Q_j|_inftyle e).

Let
[
Q=sum_jQ_j,qquad R=I-Q,
]
and define
[
F_j=Q_j+R E_jR.
]

Then ({F_j}) is a POVM with exact mutually orthogonal unit sectors, so it is repeatability-admissible, and
[
|E_j-F_j|_inftyle2e.
]

This completion is necessary when (m<d): the orthogonal sector projectors alone do not generally sum to the identity.

## Spectral-threshold correction

If (P_j) merely collects eigenvalues (ge1-delta), the stronger estimate (|E_j-P_j|_inftyledelta) need not hold.

An explicit (d=4,m=3,alpha=1) family shows that a generic correction can require (Omega(sqrtdelta)) movement. Therefore the earlier linear (O(delta+1-alpha)) theorem is too strong under spectral-threshold-only assumptions.

## Channel statement

For
[
Phi_E(ho)=sum_joperatorname{Tr}(E_jho)sigma_j
]
and the moved-POVM channel (widetildePhi_F), define
[

u=|Phi_E-widetildePhi_F|_diamond.
]

If
[
eta=|Phi_E^2-Phi_E|_diamond
]
and the records have margin (kappa>0), then
[
|widetildePhi_F^2-widetildePhi_F|_diamondleeta+3
u.
]

If the moved POVM has repeatability spectral gap (gamma_F>0), the RC spectral-gap theorem yields an exactly idempotent channel (Pi) satisfying
[
oxed{
|Phi_E-Pi|_diamond
le

u+
sqrt{rac{2(eta+3
u)}{kappagamma_F}}.
}
]

The current universally safe estimate for (
u) can depend on the number of outcomes. A dimension/outcome-independent estimate is open.

## Lean scope

Machine checked in Lean 4 + Mathlib:
- `projector_const_one`,
- `polar_residual_le`,
- `near_orthonormal_overlap`,
- `rank1_core_package`.

Not machine checked:
- Hilbert-space polar decomposition,
- higher-rank synthesis operator,
- diamond-norm channel estimates.

## Prior-art boundary

The polar factor / nearest orthonormal frame is classical. Quantitative POVM orthogonalisation is established prior art (including de la Salle 2022).

The potentially distinct contribution is the synthesis-conditioning + repeatability-completion + record-margin/diamond-certification combination. Novelty remains unverified.
