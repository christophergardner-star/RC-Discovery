# Novelty and Prior-Art Ledger

Updated: 29 October 2026.

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

### QMSM metastability

Li, Lin and Ragone, *Quantum Markov State Models for Metastable Dynamics*, arXiv:2609.40214 (2026).

### Quantum Chernoff redundancy

Zwolak, Riedel and Zurek, *Amplification, Redundancy, and Quantum Chernoff Information*, PRL 112, 140406 (2014).

## Current RC theorem candidates

### 1. Sharp Record-Margin theorem

[
|\Phi-\Pi|_\diamond\le\sqrt{2\eta/\kappa}.
]

### 2. Repeatability-admissible POVM extension

[
|\Phi-\Pi|_\diamond
\le
\sqrt{2\eta/(\kappa\gamma)}.
]

Neither exact inequality has yet been located in prior work.

## Moving-POVM result status

The broad moving-POVM conjecture is **not novel because it is false**.

The session instead produced:

- an elementary packing inequality,
- a direct same-label packing no-go,
- a binary positive transfer theorem,
- a clear reduction of the open problem to the many-outcome packing-feasible regime.

The regular-simplex obstruction must be viewed in light of Chenxiao's 2026 negative result, which already uses the same geometric mechanism at the full channel level.

No novelty claim should be attached to the existence of the simplex obstruction itself.

The potentially useful contribution is the RC parameter-level diagnosis: why local record margin, local reachability and near-unit effect norms all fail to detect the obstruction.

## Before publication

Required:

1. independent proof reconstruction,
2. expert search in POVM perturbation and frame theory,
3. comparison with stability results for nearly orthogonal frames/subspaces,
4. proof-assistant or second-researcher verification,
5. norm-convention audit.

## Continual-learning bridge

### IDER (ICLR 2026)

Liu et al., *IDER: IDempotent Experience Replay for Reliable Continual Learning*, ICLR 2026 / arXiv:2603.00624.

IDER already uses idempotence directly in continual learning, including an idempotence loss and an idempotence-distillation objective. Therefore:

- "idempotence for continual learning" is **not** an RC novelty claim,
- projection-style stability is **not** an RC novelty claim,
- quadratic parameter anchoring is **not** an RC novelty claim.

### RC-TCL pilot

The 29 October 2026 pilot derives an exact affine task-horizon diagnostic for the frozen canonical TCL memory penalty and introduces an **anchor-conflict variance** for stored task checkpoints.

Current status:

- exact diagonal/horizon rounding identity: **derived elementary math; no novelty claim**,
- anchor-barycentre decomposition: **standard quadratic algebra; no novelty claim**,
- using horizon rounding + locked-anchor conflict as a predictor of TCL forgetting: **potentially distinct application/diagnostic; novelty unverified**.

A literature veto is required across EWC/Laplace consolidation, parameter-conflict diagnostics, projection-based continual learning, and idempotent neural-network training before stronger wording is allowed.
