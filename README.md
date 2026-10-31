# RC-Discovery

A private research repository for the **Resolvance Calculus (RC)** discovery programme developed on 28 October 2026.

The repository is deliberately conservative: every claim is labelled as known, derived, provisionally novel, open, or refuted.

## Current strongest internally proved results

### Sharp Record-Margin Stability

For sharp record sectors,

[
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappa}}.
]

The 31 October 2026 independent reconstruction passes, subject only to citing two standard background lemmas explicitly: the density-operator optimization of the diamond norm for Hermiticity-preserving maps, and the normalized post-selection trace-distance bound.

### POVM Spectral-Gap Record-Margin Stability

For a finite discrete POVM whose nonzero effects possess eigenvalue-1 repeatable sectors,

[
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappagamma}}.
]

This proof also survives independent reconstruction.

## Moving-POVM programme

The unrestricted moving-POVM conjecture is false.

A regular-simplex family with (m=d+1) simultaneously has small idempotence defect, large record margin, near-unit effects and near-reachable records, while same-label exact repeatability remains far away.

The missing ingredient is global packing.

### Synthesis-operator conditioner

For near-unit spectral sectors (P_j), define

[
T:igoplus_joperatorname{ran}(P_j)	omathcal H,
qquad
(x_j)mapstosum_jx_j.
]

The quantity

[
alpha=sigma_{min}(T)
]

is now the working global conditioner.

If (alpha>0), the polar factor of (T) gives a constructive simultaneous orthogonalization of the near-unit sectors, including higher-rank sectors.

The POVM constraint also bounds the top singular value:

[
sigma_{max}(T)le(1-delta)^{-1/2}.
]

### Repeatable completion

If (R_j) are the polar-rounded orthogonal sectors and

[
C=I-sum_jR_j,
]

then

[
F_j=R_j+CE_jC
]

is a genuine POVM with exact eigenvalue-1 sectors (R_j).

This handles (m<d) without pretending that rank-one projectors alone can sum to the identity.

### Important correction

A linear spectral-threshold movement bound is false in general.

There is an explicit (d=4,m=3) family with perfect packing (alpha=1) that still requires order-(sqrtdelta) effect movement.

So the generic rate must allow square-root dependence on the near-unit spectral defect unless stronger whole-effect closeness is assumed.

### Current many-outcome theorem

A constructive positive theorem now exists in the well-conditioned packing-feasible regime.

The current proof has:

- polar orthogonalization,
- explicit repeatable POVM completion,
- a square-root effect-movement bound,
- transfer of idempotence defect to the moved channel,
- application of the RC spectral-gap theorem.

The remaining weakness is a crude measurement-channel estimate

[
|Phi-widetildePhi|_diamond
le
sum_j|E_j-F_j|_infty,
]

which introduces an outcome-count factor (m).

Removing that factor is now the main mathematical target.

See:

- theory/packing_conditioned_rounding.md
- research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md
- experiments/test_spectral_threshold_rate.py

## Prior-art boundary

The polar orthogonalization step is standard matrix analysis (Fan–Hoffman / Higham / Löwdin).

POVM projectivization is also established prior art. In particular, Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures* (2022), proves quantitative POVM-to-PVM rounding in a state-dependent (L_2)-type metric.

No novelty claim is made for those ingredients.

The potentially distinct RC contribution is the combination of:

- synthesis-operator packing conditioning,
- repeatability-admissible completion,
- record-margin / idempotence control,
- diamond-norm stability for the associated measure-and-prepare channel.

Novelty remains unverified.

## Other results

### Redundancy

For two independent pure records with overlap (s),

[
kappa_R=sqrt{1-s^{2R}}.
]

Correlated common-mode errors can remove the redundancy gain.

### Record-structured metastability

If a metastable channel (mathcal C) lies within (delta) of the record-producing class, an exact idempotent (mathcal Q) exists with

[
|mathcal C-mathcal Q|_diamond
le
delta+
sqrt{
rac{2(eta+3delta)}
{kappagamma}
}.
]

### RC-TCL continual-learning bridge

The classical TCL memory penalty admits an exact task-horizon affine analysis when stored anchors and importance maps are frozen.

The initial “locked conflict predicts more forgetting” hypothesis failed its smoke test, but anchor conflict did track poorer retained/joint performance and disappeared under an anchor-shuffle control.

See:

- research/RC_TCL_BRIDGE.md
- research/RC_TCL_SMOKE_RESULTS.md
- experiments/rc_tcl_certificate.py

## Repository map

- theory/record_margin_stability.md
- theory/povm_spectral_gap_stability.md
- theory/moving_povm_boundary.md
- theory/packing_conditioned_rounding.md
- theory/redundancy_stability.md
- theory/metastable_record_rounding.md
- experiments/test_record_margin.py
- experiments/test_three_extensions.py
- experiments/test_moving_povm.py
- experiments/test_spectral_threshold_rate.py
- experiments/rc_tcl_certificate.py
- literature/NOVELTY_LEDGER.md
- research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md
- research/OPEN_PROBLEMS.md
- STATUS.md

## Research discipline

Before a novelty claim:

1. proof audit,
2. adversarial counterexample search,
3. reproducibility,
4. literature veto,
5. independent reconstruction or formal verification.

Author: **Christopher Gardner**
