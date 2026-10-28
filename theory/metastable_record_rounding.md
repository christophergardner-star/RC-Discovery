# Record-Structured Metastability Transfer Theorem

Status: **internally proved corollary; complementary to current QMSM results**  
Date: 28 October 2026

## Current comparison point

Li, Lin and Ragone, *Quantum Markov State Models for Metastable Dynamics* (arXiv:2609.40214, September 2026), construct exact idempotent quantum channels approximating almost-idempotent metastable channels under a bounded slow-rank assumption.

Their global diamond-norm approximation scales as \(O_r(\eta^{1/3})\), with constants depending on slow rank \(r\), and they obtain \(O_r(\sqrt{\eta})\) in a metastable-state seminorm.

They explicitly note that without bounded slow rank, no general dimension-independent approximation modulus exists.

The result below does **not** contradict that obstruction. It replaces generality with strong classical-record structure.

## Theorem

Let \(\mathcal C\) be any finite-dimensional quantum channel and define its idempotence defect

\[
\eta
=
\|\mathcal C^2-\mathcal C\|_\diamond.
\]

Suppose there exists a record-producing channel

\[
\Phi(\rho)
=
\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

satisfying the POVM Spectral-Gap Record-Margin theorem, with record margin \(\kappa>0\) and repeatability spectral gap \(\gamma>0\).

Let

\[
\delta
=
\|\mathcal C-\Phi\|_\diamond.
\]

Then there exists an exactly idempotent quantum channel \(\mathcal Q\) with a classical record simplex as its range such that

\[
\boxed{
\|\mathcal C-\mathcal Q\|_\diamond
\le
\Delta_{\rm RC}
:=
\delta
+
\sqrt{
\frac{2(\eta+3\delta)}
{\kappa\gamma}
}.
}
\]

The bound contains no explicit dependence on:

- ambient Hilbert-space dimension,
- number of record sectors,
- rank of the slow spectral subspace.

## Proof

First transfer almost-idempotence from \(\mathcal C\) to \(\Phi\):

\[
\Phi^2-\Phi
=
(\Phi^2-\mathcal C^2)
+
(\mathcal C^2-\mathcal C)
+
(\mathcal C-\Phi).
\]

Since quantum channels have diamond norm \(1\),

\[
\|\Phi^2-\mathcal C^2\|_\diamond
=
\|\Phi(\Phi-\mathcal C)+(\Phi-\mathcal C)\mathcal C\|_\diamond
\le
2\delta.
\]

Therefore

\[
\|\Phi^2-\Phi\|_\diamond
\le
\eta+3\delta.
\]

Apply the POVM Spectral-Gap Record-Margin theorem to \(\Phi\). It yields an exact idempotent \(\mathcal Q\) satisfying

\[
\|\Phi-\mathcal Q\|_\diamond
\le
\sqrt{
\frac{2(\eta+3\delta)}
{\kappa\gamma}
}.
\]

Finally,

\[
\|\mathcal C-\mathcal Q\|_\diamond
\le
\|\mathcal C-\Phi\|_\diamond
+
\|\Phi-\mathcal Q\|_\diamond,
\]

giving the result.

QED.

## Reduced dynamics

Let

\[
\mathscr D_\star
=
\mathcal Q(\mathscr D)
\]

be the reduced state space, let \(\mathcal R\) be inclusion into the full state space, and define

\[
\mathcal M
=
\mathcal Q\mathcal C\mathcal R.
\]

Because \(\mathcal Q^2=\mathcal Q\), this is a physical reduced Markov model on the record simplex.

Set

\[
\Delta
=
\|\mathcal C-\mathcal Q\|_\diamond.
\]

Then

\[
\|\mathcal Q\mathcal C\mathcal Q-\mathcal C\|_\diamond
\le
2\Delta.
\]

A telescoping power bound gives, for every integer \(k\ge1\),

\[
\boxed{
\|
\mathcal R\mathcal M^k\mathcal Q
-
\mathcal C^k
\|_\diamond
\le
2k\Delta.
}
\]

Thus

\[
\boxed{
\|
\mathcal R\mathcal M^k\mathcal Q
-
\mathcal C^k
\|_\diamond
\le
2k\Delta_{\rm RC}.
}
\]

This parallels the standard QMSM iteration estimate, but the sufficient condition is record geometry rather than bounded slow rank.

## What has actually been gained

The 2026 QMSM theorem is much more general: it can retain noncommutative quantum memory blocks.

This RC corollary only covers channels close to a **classical record-producing structure**.

Within that subclass, however, the number of classical phases may grow without entering the constant, provided \(\kappa\), \(\gamma\), \(\eta\), and \(\delta\) remain controlled.

So the defensible statement is:

> Bounded slow rank is not necessary for dimension-independent exact rounding in a record-structured classical metastable subclass.

It is **not**:

> The bounded-slow-rank assumption has been removed for arbitrary quantum metastability.

## Explicit many-phase sanity family

Let the Hilbert space be \(\mathbb C^m\), with projectors

\[
P_j=|j\rangle\langle j|.
\]

Let

\[
u=\frac{I}{m}
\]

and define records

\[
\sigma_j
=
(1-\epsilon)|j\rangle\langle j|
+
\epsilon u,
\qquad
0<\epsilon<1.
\]

Then

\[
\kappa=1-\epsilon.
\]

The associated channel is

\[
\Phi_m(\rho)
=
\sum_j
\langle j|\rho|j\rangle
\sigma_j.
\]

Its idempotence defect is

\[
\eta_m
=
2\epsilon(1-\epsilon)
\left(1-\frac1m\right).
\]

The exact idempotent dephasing channel

\[
\Pi_m(\rho)
=
\sum_j
\langle j|\rho|j\rangle
|j\rangle\langle j|
\]

satisfies

\[
\|\Phi_m-\Pi_m\|_\diamond
=
2\epsilon
\left(1-\frac1m\right),
\]

while the theorem gives

\[
\|\Phi_m-\Pi_m\|_\diamond
\le
2
\sqrt{
\epsilon
\left(1-\frac1m\right)
}.
\]

As \(m\to\infty\), none of these constants diverges.

The range dimension of \(\Pi_m\) is \(m\), so this is an explicit sequence with an unbounded number of classical phases and a dimension-independent rounding guarantee.

This family is classical and is not itself a novelty claim; it is a sanity check demonstrating exactly what “no bounded phase-count assumption” means.

## Relevant prior work

- H.-E. Li, L. Lin, M. Ragone, *Quantum Markov State Models for Metastable Dynamics*, arXiv:2609.40214 (2026).
- K. Macieszczak, D. C. Rose, I. Lesanovsky, J. P. Garrahan, *Theory of classical metastability in open quantum systems*, Phys. Rev. Research 3, 033047 (2021), DOI 10.1103/PhysRevResearch.3.033047.
- General exact rounding without structural restrictions is impossible by the 2026 almost-idempotent-channel counterexamples recorded in the novelty ledger.

## Next real test

Apply the transfer theorem to an explicit many-body classical-metastability model and derive \(\delta\), \(\kappa\), and \(\gamma\) from its microscopic dynamics rather than assuming them.

That is the point where this becomes a physical result rather than a structural corollary.
