# RC-Discovery

A private research repository for the **Resolvance Calculus (RC)** discovery programme developed on 28 October 2026.

The repository is deliberately conservative: every claim is labelled as known, derived, provisionally novel, open, or refuted.

## Current strongest internally proved result

### POVM Spectral-Gap Record-Margin Stability

For a finite discrete POVM whose nonzero effects possess eigenvalue-1 repeatable sectors, the current bound is

[
|Phi-Pi|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
]

Here \(\eta\) is the idempotence defect, \(\kappa\) is the record margin and \(\gamma\) is the spectral gap below the repeatable sector.

A non-projective qutrit family attains equality exactly.

## Moving-POVM boundary

The next question was whether a POVM with no exact unit eigenvalue could itself be moved slightly and then rounded.

That is **false in general**.

The missing variable is global packing.

For any \(m\)-outcome POVM on a \(d\)-dimensional Hilbert space with record states \(\sigma_j\),

[
a_j=\operatorname{Tr}(E_j\sigma_j)
]

obeys

[
\sum_j a_j\le d.
]

Thus if every record is self-read with probability at least \(1-\epsilon\),

[
m(1-\epsilon)\le d.
]

A regular-simplex family with \(m=d+1\) simultaneously has:

- idempotence defect tending to zero,
- record margin tending to one,
- effect norms tending to one,
- record reachability error tending to zero,

yet any same-label repeatable POVM stays order-one far away.

So local near-repeatability is not enough.

### Binary positive result

For two outcomes the packing obstruction disappears.

If the two records remain separated, their reachability errors are small, and the moved POVM retains a nonzero edge spectral gap, then an exact idempotent channel exists with

[
|Phi-\Pi|_\diamond
\le
2r+
\sqrt{
\frac{2(\eta+6r)}
{\kappa\widetilde\gamma}
}.
]

This is the first positive moving-POVM theorem in the repository.

## Other results

### Redundancy

For two independent pure records with overlap \(s\),

[
\kappa_R=\sqrt{1-s^{2R}}.
]

Correlated common-mode errors can completely remove the redundancy gain.

### Record-structured metastability

If a metastable channel \(\mathcal C\) lies within \(\delta\) of the record-producing class, an exact idempotent \(\mathcal Q\) exists with

[
|\mathcal C-\mathcal Q|_\diamond
\le
\delta+
\sqrt{
\frac{2(\eta+3\delta)}
{\kappa\gamma}
}.
]

No explicit phase-count term appears, but this applies only to the stronger classical-record subclass.

## Current main open problem

The moving-POVM problem has now narrowed to the packing-feasible many-outcome regime

[
\boxed{3\le m\le d}.
]

The target is to identify the global conditioning parameter that guarantees simultaneous rounding of near-unit outcome sectors to mutually orthogonal repeatable sectors.

Candidate structures include:

- Gram-matrix conditioning,
- principal-angle separation,
- total packing defect,
- subspace matching / Hall-type conditions.

## Repository map

- theory/record_margin_stability.md
- theory/povm_spectral_gap_stability.md
- theory/moving_povm_boundary.md
- theory/redundancy_stability.md
- theory/metastable_record_rounding.md
- experiments/test_record_margin.py
- experiments/test_three_extensions.py
- experiments/test_moving_povm.py
- literature/NOVELTY_LEDGER.md
- research/OPEN_PROBLEMS.md
- STATUS.md

## Reproduce

    pip install -r experiments/requirements.txt
    python experiments/test_record_margin.py
    python experiments/test_three_extensions.py
    python experiments/test_moving_povm.py

## Research discipline

Before a novelty claim:

1. proof audit,
2. adversarial counterexample search,
3. reproducibility,
4. literature veto,
5. independent reconstruction or formal verification.

Author: **Christopher Gardner**
