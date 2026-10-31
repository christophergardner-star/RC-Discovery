# Novelty and Prior-Art Ledger

Updated: 31 October 2026.

## Confirmed neighbouring results

### Kitaev (2024)

*Almost-idempotent quantum channels and approximate C*-algebras*, arXiv:2405.02434.

### Chenxiao (2026)

*Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels*, Zenodo 22906336, 23 September 2026.

The paper constructs regular-simplex bistochastic entanglement-breaking maps whose idempotence defects vanish while their distance from all UCP idempotents remains bounded below.

This is the decisive veto against any general dimension-independent exact-rounding theorem.

### Repeatable POVMs

Busch, Grabowski and Lahti, *Repeatable measurements in quantum theory: Their role and feasibility*, Foundations of Physics 25 (1995), DOI 10.1007/BF02055331.

For finite discrete POVMs, repeatable implementation is possible exactly when every nonzero effect has eigenvalue 1.

### POVM orthogonalization / projectivization

Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), DOI 10.5802/crmath.326.

This work proves quantitative rounding of almost-orthogonal POVMs to PVMs in a state-dependent (L_2)-type metric and improves earlier finite-dimensional results.

This is mandatory prior art for any RC claim of “almost projective POVM implies nearby projective measurement.”

### Polar / Löwdin orthogonalization

The fact that the polar factor is a closest matrix with orthonormal columns in unitarily invariant norms is classical (Fan–Hoffman / Higham / Löwdin orthogonalization).

No novelty claim belongs to the polar step itself.

### QMSM metastability

Li, Lin and Ragone, *Quantum Markov State Models for Metastable Dynamics*, arXiv:2609.40214 (2026).

### Quantum Chernoff redundancy

Zwolak, Riedel and Zurek, *Amplification, Redundancy, and Quantum Chernoff Information*, PRL 112, 140406 (2014).

## Current RC theorem candidates

### 1. Sharp Record-Margin theorem

[
|Phi-Pi|_diamondlesqrt{2eta/kappa}.
]

Independent proof reconstruction on 31 October 2026: **survives**.

The proof should explicitly cite:

- the state-optimization characterization of the diamond norm for Hermiticity-preserving maps,
- the normalized post-selection / gentle-projection trace-distance inequality.

### 2. Repeatability-admissible POVM extension

[
|Phi-Pi|_diamond
le
sqrt{2eta/(kappagamma)}.
]

Independent proof reconstruction on 31 October 2026: **survives**.

Neither exact RC inequality has yet been located in prior work.

## Moving-POVM result status

The broad moving-POVM conjecture based only on local diagnostics is false.

The session has now produced:

- an elementary packing inequality,
- a direct same-label packing no-go,
- a binary positive transfer theorem,
- a synthesis-operator conditioner for many-outcome near-unit sectors,
- a constructive polar orthogonalization lemma valid at arbitrary rank,
- an explicit repeatability-admissible POVM completion,
- a non-optimal many-outcome channel theorem with an (m)-dependent perturbation term.

### Important correction

The 31 October proposed linear effect movement

[
O!left(delta+sqrt{1-alpha^2}ight)
]

is too strong when (delta) only specifies a near-unit spectral threshold.

An explicit (d=4,m=3) family has perfect packing (alpha=1) but requires order-(sqrtdelta) movement.

See:

- theory/packing_conditioned_rounding.md
- experiments/test_spectral_threshold_rate.py
- research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md

The correct generic rate must permit square-root spectral-threshold dependence unless stronger whole-effect control is assumed.

### Current novelty boundary

No novelty claim should be attached to:

- the polar decomposition,
- nearest orthonormal-frame properties,
- the general fact that almost-projective POVMs can be rounded,
- the regular-simplex obstruction itself.

The potentially distinct RC contribution is the combination of:

- near-unit sector synthesis conditioning,
- repeatability-admissible completion,
- record-margin and idempotence control,
- a downstream diamond-norm stability certificate.

That combination remains **novelty unverified**.

## Before publication

Required:

1. outcome-count-independent measurement-channel perturbation bound, or a proof that some count dependence is unavoidable,
2. comparison against de la Salle and the earlier finite-dimensional projectivization results it cites,
3. independent reconstruction of the packing-conditioned theorem,
4. proof-assistant or second-researcher verification of the core finite-dimensional lemmas,
5. norm-convention audit.

## Continual-learning bridge

### IDER (ICLR 2026)

Liu et al., *IDER: IDempotent Experience Replay for Reliable Continual Learning*, ICLR 2026 / arXiv:2603.00624.

IDER already uses idempotence directly in continual learning, including an idempotence loss and an idempotence-distillation objective. Therefore:

- “idempotence for continual learning” is **not** an RC novelty claim,
- projection-style stability is **not** an RC novelty claim,
- quadratic parameter anchoring is **not** an RC novelty claim.

### RC-TCL pilot

The 29 October 2026 pilot derives an exact affine task-horizon diagnostic for the frozen canonical TCL memory penalty and introduces an **anchor-conflict variance** for stored task checkpoints.

Current status:

- exact diagonal/horizon rounding identity: **derived elementary math; no novelty claim**,
- anchor-barycentre decomposition: **standard quadratic algebra; no novelty claim**,
- using horizon rounding + anchor conflict as a retained/joint-performance diagnostic: **potentially distinct application; novelty unverified**.

A literature veto is required across EWC/Laplace consolidation, parameter-conflict diagnostics, projection-based continual learning, and idempotent neural-network training before stronger wording is allowed.
