# Minimal RC Language for This Research Branch

This repository uses a deliberately small subset of the broader Resolvance Calculus vocabulary.

The goal is to make every statement translatable into ordinary mathematics.

## Distinction

A distinction is an experimentally recoverable alternative: different records, outcomes, histories, or sectors.

## Record

A record is a physical state carrying information about a distinction.

In the theorem branch a record is represented by a density operator \(\sigma_j\).

## Record margin

The RC record margin is

\[
\kappa
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1.
\]

It measures how strongly each record is separated from every mixture of its competitors. It is deliberately stronger than pairwise separation.

## Closure / repeatability

A process is exactly repeatable when

\[
\Phi^2=\Phi.
\]

It is approximately repeatable when

\[
\eta=\|\Phi^2-\Phi\|_\diamond
\]

is small.

## Objective record

In this branch, “objective” is used operationally rather than metaphysically: competing record states are distinguishable and the registered distinction can be read repeatedly without instability.

## Rounding

Rounding asks whether an approximately closed process lies near an exactly closed one.

The general quantum answer is no. The RC record-margin theorem gives a positive answer for a sharp, separated record-producing subclass.

## Research discipline

RC terminology is useful only when it creates a sharper mathematical question.

Every RC statement in this repository should reduce to one of:

1. translation into a known theorem,
2. derivation from known mathematics,
3. falsifiable conjecture,
4. proof or counterexample.
