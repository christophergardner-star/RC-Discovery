# RC-Discovery

A private research repository for the **Resolvance Calculus (RC)** discovery programme developed on 28 October 2026.

The repository is deliberately conservative: every claim is labelled as known, derived, provisionally novel, open, or refuted.

## Current strongest internally proved result

### POVM Spectral-Gap Record-Margin Stability

For a finite discrete POVM \(\{E_j\}\) whose nonzero effects have eigenvalue \(1\), let \(P_j\) be the eigenvalue-\(1\) spectral projection and define

\[
\gamma
=
\min_j
\left[
1-
\|(I-P_j)E_j(I-P_j)\|_\infty
\right].
\]

For the measure-and-prepare channel

\[
\Phi(\rho)
=
\sum_j
\operatorname{Tr}(E_j\rho)\sigma_j,
\]

define the record margin

\[
\kappa
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1
\]

and idempotence defect

\[
\eta
=
\|\Phi^2-\Phi\|_\diamond.
\]

If \(\kappa>0\), there exists an exactly idempotent channel \(\Pi\), using the same POVM, such that

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{
\frac{2\eta}{\kappa\gamma}
}.
}
\]

The bound is independent of Hilbert-space dimension and outcome count.

A two-outcome qutrit family attains equality exactly, so the spectral-gap factor is not merely proof slack.

For projective measurements, \(\gamma=1\), recovering the original Record-Margin Stability Theorem.

**Status:** internally proved and stress-tested. No exact prior statement has yet been located. Novelty is not claimed pending independent proof and specialist prior-art review.

## Three-track results from 28 October 2026

### 1. POVM extension

The sharp-projective theorem extends to every finite POVM with exact repeatable sectors. The extra conditioning parameter is the spectral gap \(\gamma\) below eigenvalue \(1\).

See:

- theory/povm_spectral_gap_stability.md

### 2. Redundancy to stability

For two independent pure records with single-fragment overlap \(s\),

\[
\boxed{
\kappa_R
=
\sqrt{1-s^{2R}}.
}
\]

This produces an explicit redundancy-to-stability certificate when inserted into the RC rounding theorem.

A correlated common-noise construction shows that simply increasing the number of fragments need not improve \(\kappa\) at all.

See:

- theory/redundancy_stability.md

### 3. Record-structured metastability

If a metastable channel \(\mathcal C\) is \(\delta\)-close to a record channel in the POVM theorem class, with

\[
\eta
=
\|\mathcal C^2-\mathcal C\|_\diamond,
\]

then an exact idempotent \(\mathcal Q\) exists with

\[
\boxed{
\|\mathcal C-\mathcal Q\|_\diamond
\le
\delta
+
\sqrt{
\frac{2(\eta+3\delta)}
{\kappa\gamma}
}.
}
\]

This has no explicit dependence on the number of classical phases.

It does **not** replace the 2026 QMSM theorem in general; it gives an alternative sufficient condition for a stronger classical-record subclass.

See:

- theory/metastable_record_rounding.md

## Why this matters

General dimension-independent exact rounding of almost-idempotent quantum channels is false, even for explicit entanglement-breaking channels.

The RC branch is therefore asking a classification question:

> Which physical record structures restore stable exact rounding?

The current results identify a positive family controlled by two geometric quantities:

- record separation \(\kappa\),
- repeatable-readout gap \(\gamma\).

## Repository map

- theory/record_margin_stability.md — original sharp theorem and proof.
- theory/povm_spectral_gap_stability.md — non-projective POVM extension and sharp qutrit family.
- theory/redundancy_stability.md — independent-record formulas and correlated failure mode.
- theory/metastable_record_rounding.md — metastability transfer theorem.
- theory/sharpness_example.md — original qubit saturation example.
- theory/rc_language.md — minimal RC vocabulary.
- experiments/test_record_margin.py — original 10,000-case stress test.
- experiments/test_three_extensions.py — 20,000-case POVM stress test plus redundancy/metastability checks.
- literature/NOVELTY_LEDGER.md — prior-art veto ledger.
- research/OPEN_PROBLEMS.md — remaining falsifiable targets.
- research/SESSION_2026-10-28.md — compact session log.
- STATUS.md — claim-status ledger.

## Reproduce

Install NumPy:

    pip install -r experiments/requirements.txt

Run:

    python experiments/test_record_margin.py
    python experiments/test_three_extensions.py

## Research discipline

No result is called a discovery merely because it is interesting, numerically successful, or absent from a quick search.

Before a novelty claim:

1. full proof audit,
2. adversarial counterexample search,
3. reproducibility,
4. literature veto in neighbouring mathematical languages,
5. independent reconstruction or formal verification.

Author: **Christopher Gardner**
