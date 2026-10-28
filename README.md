# RC-Discovery

A private research repository for the **Resolvance Calculus (RC)** discovery programme developed on 28 October 2026.

The purpose of this repository is not to promote a finished theory. It is to preserve a falsifiable research trail: definitions, theorem candidates, proofs, counterexample searches, numerical tests, literature vetoes, and open problems.

## Current strongest result

### RC Record-Margin Stability Theorem — internally proved; novelty not yet independently established

For a finite-dimensional sharp measure-and-prepare channel

\[
\Phi(\rho)=\sum_j \operatorname{Tr}(P_j\rho)\,\sigma_j,
\]

where the non-zero orthogonal projectors \(P_j\) sum to the identity, define

\[
\kappa=
\min_j\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1
\]

and

\[
\eta=\|\Phi^2-\Phi\|_\diamond.
\]

If \(\kappa>0\), there exists an exactly idempotent sharp measure-and-prepare channel \(\Pi\) such that

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}
}
\]

The bound is dimension-independent. A two-record qubit family attains equality, so the square-root scaling and prefactor are sharp for this class.

**Status:** proof checked internally and numerically stress-tested. No exact prior statement has yet been located, but novelty is **not claimed** until an independent proof audit and deeper specialist prior-art search are completed.

## Why this matters

The general exact-rounding problem for almost-idempotent quantum channels is known to fail, including for explicit entanglement-breaking maps. This theorem candidate identifies a physically motivated positive subclass: projectively readable records that remain geometrically separated.

In RC language:

\[
\text{record distinguishability}
+
\text{approximate repeatability}
\Rightarrow
\text{nearby exact repeatable dynamics}.
\]

## Repository map

- theory/record_margin_stability.md — theorem statement and proof.
- theory/sharpness_example.md — saturating two-record qubit family.
- theory/rc_language.md — minimal RC vocabulary used in this branch.
- experiments/test_record_margin.py — reproducible numerical stress tests.
- experiments/requirements.txt — Python dependency.
- literature/NOVELTY_LEDGER.md — verified related work and novelty status.
- research/OPEN_PROBLEMS.md — next falsifiable targets.
- research/SESSION_2026-10-28.md — compact research log.
- STATUS.md — known / derived / provisionally novel / open ledger.

## Reproduce

Install NumPy from experiments/requirements.txt and run:

    python experiments/test_record_margin.py

The script uses fixed seed 20261028 and checks 10,000 full-rank two-record models in dimensions 2, 3, 5, 10 and 20, plus the analytic sharpness family.

## Research discipline

Nothing is promoted to “discovery” merely because it is interesting or numerically successful. A candidate should survive:

1. complete proof audit,
2. explicit counterexample search,
3. numerical reproduction where applicable,
4. literature veto in multiple mathematical languages,
5. independent reconstruction by another researcher or proof assistant.

Author: **Christopher Gardner**
