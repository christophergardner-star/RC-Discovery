# Redundancy to Record Margin to Stability

Status: **exact corollaries plus an explicit failure mode**  
Date: 28 October 2026

This file separates what redundancy really proves from the stronger claim that “more copies automatically make dynamics classical.”

The latter is false without qualifications.

## 1. Two independent record states

For two record states \(\rho_0,\rho_1\), the RC record margin is simply their trace distance:

\[
\kappa
=
\frac12\|\rho_0-\rho_1\|_1.
\]

For \(R\) independent record fragments,

\[
\rho_j^{(R)}
=
\rho_j^{\otimes R},
\]

so

\[
\boxed{
\kappa_R
=
\frac12
\left\|
\rho_0^{\otimes R}
-
\rho_1^{\otimes R}
\right\|_1.
}
\]

This is exactly the optimal equal-prior binary state-discrimination advantage.

## 2. Pure records: exact formula

Let

\[
\rho_0=|e_0\rangle\langle e_0|,
\qquad
\rho_1=|e_1\rangle\langle e_1|,
\]

and define

\[
s=|\langle e_0|e_1\rangle|,
\qquad
0\le s<1.
\]

Then

\[
|\langle e_0^{\otimes R}|e_1^{\otimes R}\rangle|
=
s^R,
\]

and the pure-state trace-distance identity gives

\[
\boxed{
\kappa_R
=
\sqrt{1-s^{2R}}.
}
\]

Thus \(\kappa_R\to1\) exponentially with the number of independent fragments.

If a sharp record-producing channel with these records has idempotence defect \(\eta_R\), the RC stability theorem gives

\[
\boxed{
\|\Phi_R-\Pi_R\|_\diamond
\le
\sqrt{2\eta_R}
\,(1-s^{2R})^{-1/4}.
}
\]

At fixed \(\eta_R\), the certificate improves monotonically with \(R\) and approaches the floor

\[
\sqrt{2\eta_R}.
\]

Important: redundancy alone does **not** force \(\eta_R\) to shrink. It improves the geometric conditioning of the certificate.

## 3. Number of independent fragments required for a target margin

To guarantee

\[
\kappa_R\ge\kappa_\star,
\qquad
0<\kappa_\star<1,
\]

it is enough and necessary in the pure binary case that

\[
\sqrt{1-s^{2R}}\ge\kappa_\star.
\]

Therefore

\[
\boxed{
R
\ge
\frac{\log(1-\kappa_\star^2)}
{2\log s}
}
\]

with the integer result rounded upward, for \(0<s<1\).

## 4. Mixed records: a fidelity lower bound

Let

\[
f(\rho_0,\rho_1)
=
\|\sqrt{\rho_0}\sqrt{\rho_1}\|_1
\]

denote root fidelity.

Tensor products obey

\[
f(\rho_0^{\otimes R},\rho_1^{\otimes R})
=
f(\rho_0,\rho_1)^R.
\]

Fuchs-van de Graaf gives

\[
\boxed{
\kappa_R
\ge
1-f(\rho_0,\rho_1)^R.
}
\]

Hence

\[
\boxed{
\|\Phi_R-\Pi_R\|_\diamond
\le
\sqrt{
\frac{2\eta_R}
{1-f(\rho_0,\rho_1)^R}
}
}
\]

whenever the denominator is nonzero.

The quantum Chernoff bound gives the asymptotically optimal exponential discrimination rate for tensor-product records; this is standard prior art, not an RC discovery.

Relevant reference:

Michael Zwolak, C. Jess Riedel, Wojciech H. Zurek,  
“Amplification, Redundancy, and Quantum Chernoff Information,”  
Phys. Rev. Lett. 112, 140406 (2014), DOI 10.1103/PhysRevLett.112.140406.

## 5. Multi-record operational lemma

Let \(\rho_1,\ldots,\rho_m\) be candidate records.

Suppose there exists a discriminator POVM \(\{D_j\}\) with worst-case classification error at most \(\epsilon\):

\[
\operatorname{Tr}(D_j\rho_j)\ge1-\epsilon
\]

for every \(j\).

Then for \(i\neq j\),

\[
\operatorname{Tr}(D_j\rho_i)\le\epsilon.
\]

For every convex mixture \(\omega\) of competing records,

\[
\operatorname{Tr}(D_j\omega)\le\epsilon.
\]

Therefore

\[
\frac12\|\rho_j-\omega\|_1
\ge
1-2\epsilon,
\]

and hence

\[
\boxed{
\kappa
\ge
1-2\epsilon.
}
\]

This gives a direct bridge from an experimentally meaningful worst-case record-discrimination error to the record-margin theorem.

## 6. Correlated redundancy can fail completely

“\(R\) fragments” is not sufficient. The fragments must supply genuinely additional information.

Let \(0<p<1/2\) and define classical, perfectly correlated \(R\)-fragment records

\[
\rho_0^{(R)}
=
(1-p)|0^R\rangle\langle0^R|
+
p|1^R\rangle\langle1^R|,
\]

\[
\rho_1^{(R)}
=
p|0^R\rangle\langle0^R|
+
(1-p)|1^R\rangle\langle1^R|.
\]

Every fragment carries a noisy record of the distinction, but all fragment errors are the same shared error.

For every \(R\),

\[
\boxed{
\kappa_R
=
1-2p.
}
\]

There is no redundancy gain at all.

This is the clean correction to the informal slogan “more copies make a fact more stable”:

\[
\boxed{
\text{independent / fresh record information can improve }\kappa;
\quad
\text{mere multiplicity need not.}
}
\]

## Novelty status

The state-discrimination and Chernoff ingredients are known.

The potentially novel content is their use as an input to the RC exact-rounding theorem, creating an explicit **redundancy-to-stability certificate**.

That combined statement inherits the provisional novelty status of the RC stability theorem; the discrimination formulas themselves are not claimed as new.
