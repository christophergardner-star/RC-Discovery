# Moving-POVM Boundary: Packing Obstruction and Binary Positive Result

Status: **mixed — exact no-go lemmas, known regular-simplex obstruction, and an internally proved binary positive theorem**  
Date: 28 October 2026

The previous RC theorem assumed that the readout POVM already had exact eigenvalue-\(1\) repeatable sectors.

The natural next question was:

> If a measure-and-prepare channel is almost idempotent but its POVM has no exact unit eigenvalues, can the POVM itself be moved slightly so that exact rounding becomes possible?

The answer is **no in general**.

The missing variable is global record packing.

---

# 1. Why idempotence alone cannot move the POVM

Take the completely unsharp two-outcome POVM

\[
E_0=E_1=\frac{I}{2}
\]

and arbitrary distinct output records \(\sigma_0,\sigma_1\).

Then

\[
\Phi(\rho)
=
\frac{\sigma_0+\sigma_1}{2}
\]

for every input \(\rho\).

This channel is exactly idempotent:

\[
\Phi^2=\Phi.
\]

But neither POVM effect has norm \(1\), so the POVM admits no repeatable implementation.

Therefore

\[
\boxed{
\eta=\|\Phi^2-\Phi\|_\diamond
\text{ alone contains no information about distance of the POVM to repeatability.}
}
\]

Any moving-POVM theorem needs an accessibility / identifiability hypothesis.

---

# 2. Record-packing lemma

Let \(\{E_j\}_{j=1}^m\) be a POVM on a \(d\)-dimensional Hilbert space and let \(\sigma_j\) be density operators.

Define the self-read probabilities

\[
a_j=\operatorname{Tr}(E_j\sigma_j).
\]

## Lemma

\[
\boxed{
\sum_{j=1}^m a_j\le d.
}
\]

### Proof

Because \(0\le\sigma_j\le I\),

\[
\operatorname{Tr}(E_j\sigma_j)\le\operatorname{Tr}(E_j).
\]

Summing,

\[
\sum_j a_j
\le
\sum_j\operatorname{Tr}(E_j)
=
\operatorname{Tr}I
=
d.
\]

QED.

## Corollary

If every record is read correctly with probability at least \(1-\epsilon\),

\[
a_j\ge1-\epsilon
\]

for all \(j\), then

\[
\boxed{
m(1-\epsilon)\le d.
}
\]

Equivalently,

\[
\boxed{
\epsilon\ge1-\frac dm
}
\]

whenever \(m>d\).

This is the basic packing obstruction.

---

# 3. Exact repeatability has a hard label-capacity bound

A finite discrete POVM admits a repeatable instrument iff every nonzero effect has eigenvalue \(1\).

Suppose \(F_j\) and \(F_i\) have unit eigenvectors \(v_j,v_i\) for different outcomes.

Because

\[
\sum_kF_k=I,
\]

one has

\[
F_i v_j=0
\qquad (i\ne j).
\]

Thus

\[
\langle v_i,v_j\rangle
=
\langle F_i v_i,v_j\rangle
=
\langle v_i,F_i v_j\rangle
=
0.
\]

Therefore a \(d\)-dimensional system can support at most \(d\) nonzero exactly repeatable outcome labels:

\[
\boxed{
m_{\rm repeatable}\le d.
}
\]

If an \(m>d\) POVM has

\[
\min_j\|E_j\|_\infty\ge\lambda,
\]

then any label-preserving repeatability-admissible POVM \(\{F_j\}_{j=1}^m\) must set at least one label to zero. Hence

\[
\boxed{
\max_j
\|E_j-F_j\|_\infty
\ge
\lambda.
}
\]

So local near-norm-\(1\) effects do not imply global proximity to a repeatable POVM.

---

# 4. Regular-simplex witness

Let the Hilbert-space dimension be \(n\), and take \(n+1\) unit vectors

\[
|v_1\rangle,\ldots,|v_{n+1}\rangle
\]

forming a regular simplex:

\[
\langle v_i|v_j\rangle=-\frac1n
\qquad(i\ne j).
\]

Define

\[
\sigma_j=|v_j\rangle\langle v_j|
\]

and

\[
E_j=\frac{n}{n+1}\sigma_j.
\]

The tight-frame identity gives

\[
\sum_jE_j=I,
\]

so this is a POVM.

It has \(m=n+1>d=n\).

## Local readout quality

Every effect has

\[
\boxed{
\|E_j\|_\infty
=
\frac{n}{n+1}
\longrightarrow1.
}
\]

The self-read probability is also

\[
a_j
=
\operatorname{Tr}(E_j\sigma_j)
=
\frac{n}{n+1}.
\]

Thus the packing inequality is saturated:

\[
\sum_j a_j=n=d.
\]

## Record margin

The pairwise state overlap is

\[
\operatorname{Tr}(\sigma_i\sigma_j)=\frac1{n^2}
\qquad(i\ne j).
\]

For every mixture \(\omega\) of the competing records,

\[
\operatorname{Tr}(\sigma_j\omega)=\frac1{n^2}.
\]

The uniform mixture of all competitors attains the trace-distance lower bound, giving

\[
\boxed{
\kappa_n
=
1-\frac1{n^2}
\longrightarrow1.
}
\]

So the record geometry becomes extremely well separated.

## Reachability

Define the associated measure-and-prepare channel

\[
\Phi_n(\rho)
=
\sum_j
\operatorname{Tr}(E_j\rho)\sigma_j.
\]

Direct calculation gives

\[
\Phi_n(\sigma_j)
=
\frac{n-1}{n}\sigma_j+\frac{I}{n^2}.
\]

Hence

\[
\boxed{
\frac12
\|\Phi_n(\sigma_j)-\sigma_j\|_1
=
\frac{n-1}{n^2}
\longrightarrow0.
}
\]

The records are therefore themselves asymptotically reachable from the channel image.

## Almost idempotence

For a system-plus-ancilla input, after one application of the entanglement-breaking channel the state has the form

\[
\sum_j\sigma_j\otimes R_j,
\qquad
R_j\ge0,
\qquad
\sum_j\operatorname{Tr}R_j=1.
\]

Therefore

\[
\|(\Phi_n^2-\Phi_n)\otimes I\|_1
\le
\max_j
\|\Phi_n(\sigma_j)-\sigma_j\|_1,
\]

so

\[
\boxed{
\eta_n
=
\|\Phi_n^2-\Phi_n\|_\diamond
\le
\frac{2(n-1)}{n^2}
\longrightarrow0.
}
\]

Thus all of the following happen simultaneously:

\[
\eta_n\to0,
\]

\[
\kappa_n\to1,
\]

\[
\min_j\|E_j\|_\infty\to1,
\]

and the record reachability error tends to zero.

Yet any same-label repeatable POVM remains far away:

\[
\boxed{
\inf_{\{F_j\}\ {\rm repeatable}}
\max_j
\|E_j-F_j\|_\infty
\ge
\frac{n}{n+1}
\longrightarrow1.
}
\]

This is a direct moving-POVM no-go theorem.

## Relation to the September 2026 negative result

Chenxiao's preprint

> *Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels*  
> Zenodo 22906336, 23 September 2026

uses a regular simplex with \(n+1\) vertices to obtain a stronger channel-level obstruction: almost-idempotent bistochastic entanglement-breaking maps whose distance from every UCP idempotent remains bounded below and tends to one.

The regular-simplex packing mechanism is therefore not an accident of the present POVM argument; it is the known obstruction underlying the general negative exact-rounding result.

---

# 5. Consequence for the classification problem

The following hoped-for statement is false:

> small idempotence defect + large record margin + almost reachable records + almost norm-\(1\) POVM effects  
> \(\Rightarrow\) nearby exact repeatable measurement.

The simplex family has all four properties and still fails.

A global packing parameter is necessary.

The classification problem therefore splits into:

### Overcomplete regime

\[
m>d.
\]

Same-label exact repeatability is impossible.

### Packing-feasible regime

\[
m\le d.
\]

A positive theorem may exist, but further conditioning is still required.

---

# 6. Binary moving-POVM theorem

The two-outcome case has no packing obstruction once \(d\ge2\), and it can be solved under an explicit edge-conditioning assumption.

Let

\[
\Phi_E(\rho)
=
\operatorname{Tr}(E\rho)\sigma_0
+
\operatorname{Tr}((I-E)\rho)\sigma_1,
\]

where

\[
0\le E\le I
\]

and

\[
\kappa
=
\frac12\|\sigma_0-\sigma_1\|_1
>0.
\]

Let

\[
\lambda_{\max}=\lambda_{\max}(E),
\qquad
\lambda_{\min}=\lambda_{\min}(E).
\]

Define the record reachability errors

\[
r_0
=
\inf_\rho
\frac12\|\Phi_E(\rho)-\sigma_0\|_1,
\]

\[
r_1
=
\inf_\rho
\frac12\|\Phi_E(\rho)-\sigma_1\|_1.
\]

Because every output is a binary mixture of the two records,

\[
\boxed{
r_0
=
\kappa(1-\lambda_{\max}),
\qquad
r_1
=
\kappa\lambda_{\min}.
}
\]

Set

\[
r=\max\{r_0,r_1\}.
\]

Assume

\[
r<\frac{\kappa}{2},
\]

so the top and bottom spectral edges are distinct.

Let \(P_+\) be the full top-eigenvalue spectral projection of \(E\), and \(P_-\) the full bottom-eigenvalue spectral projection.

Define the moved effect

\[
\widetilde E
=
E
+
(1-\lambda_{\max})P_+
-
\lambda_{\min}P_-.
\]

Then

\[
0\le\widetilde E\le I,
\]

\[
\|\widetilde E-E\|_\infty
=
\frac r\kappa,
\]

and both \(\widetilde E\) and \(I-\widetilde E\) have eigenvalue \(1\).

Thus

\[
\{\widetilde E,I-\widetilde E\}
\]

is repeatability-admissible.

Let \(\widetilde\Phi\) be the same measure-and-prepare channel with \(E\) replaced by \(\widetilde E\).

The binary rank-one form of the channel difference gives

\[
\boxed{
\delta
:=
\|\Phi_E-\widetilde\Phi\|_\diamond
=
2r.
}
\]

Let

\[
\eta
=
\|\Phi_E^2-\Phi_E\|_\diamond.
\]

Then

\[
\|\widetilde\Phi^2-\widetilde\Phi\|_\diamond
\le
\eta+3\delta
=
\eta+6r.
\]

Define the repeatability spectral gap of the moved POVM by

\[
\widetilde\gamma
=
\min
\left\{
1-\|(I-P_+)\widetilde E(I-P_+)\|_\infty,\,
1-\|(I-P_-)(I-\widetilde E)(I-P_-)\|_\infty
\right\}.
\]

In finite dimension

\[
\widetilde\gamma>0.
\]

Applying the POVM Spectral-Gap Record-Margin theorem gives an exactly idempotent channel \(\Pi\) such that

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
2r
+
\sqrt{
\frac{2(\eta+6r)}
{\kappa\widetilde\gamma}
}.
}
\]

This is a genuine moving-POVM stability theorem for two outcomes.

## Interpretation

For binary records,

\[
\boxed{
\eta\to0,\quad
r\to0,\quad
\kappa\ge\kappa_0>0,\quad
\widetilde\gamma\ge\gamma_0>0
}
\]

forces

\[
\operatorname{dist}(\Phi_E,\mathrm{Idempotents})
\to0.
\]

So the moving-POVM problem is not hopeless; it fails because of global packing, not because moving the POVM is intrinsically impossible.

---

# 7. New target

The unresolved regime is now sharply defined:

\[
\boxed{
3\le m\le d.
}
\]

The next classification question is:

> What global conditioning parameter replaces the trivial binary geometry and guarantees that the near-unit outcome sectors can be simultaneously rounded to mutually orthogonal repeatable sectors?

Candidate quantities include:

- the smallest singular value of the Gram matrix of near-unit outcome vectors,
- a total packing defect rather than worst-case local defect,
- subspace principal-angle conditioning,
- a quantum analogue of Hall-type matching between labels and repeatable subspaces.

The regular simplex shows that any successful parameter must detect the rank/packing obstruction even when every local diagnostic looks excellent.
