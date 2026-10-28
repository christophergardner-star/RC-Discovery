# POVM Spectral-Gap Record-Margin Stability

Status: **internally proved; provisional novelty status**  
Date: 28 October 2026

This extends the sharp-projective Record-Margin Stability Theorem to a genuinely non-projective class of discrete POVMs.

## Background

A standard result in quantum measurement theory is that a discrete POVM admits a repeatable instrument only if every nonzero effect has eigenvalue \(1\); conversely, this condition is sufficient for a repeatable implementation. See Busch, Grabowski and Lahti, *Repeatable measurements in quantum theory: Their role and feasibility*, Foundations of Physics 25 (1995), DOI 10.1007/BF02055331.

The theorem below asks a stability question rather than an existence question:

> If such a repeatability-admissible POVM is only approximately repeatable as a measure-and-prepare channel, how close must it be to an exactly idempotent one?

## Setting

Let \(\{E_j\}_{j=1}^m\) be a finite POVM on a finite-dimensional Hilbert space, with \(m\ge2\), and suppose every nonzero \(E_j\) has eigenvalue \(1\).

Let \(P_j\) be the spectral projection of \(E_j\) onto its eigenvalue-\(1\) eigenspace.

Because \(\sum_jE_j=I\) and all \(E_j\ge0\), these repeatable sectors are mutually orthogonal and

\[
E_iP_j=\delta_{ij}P_j.
\]

Define the **repeatability spectral gap**

\[
\gamma_j
=
1-
\left\|
(I-P_j)E_j(I-P_j)
\right\|_\infty,
\]

and

\[
\gamma=\min_j\gamma_j.
\]

In finite dimension, \(\gamma_j>0\) when \(P_j\) is the full eigenvalue-\(1\) spectral projection.

Let \(\sigma_j\) be density operators and define

\[
\Phi(\rho)
=
\sum_j\operatorname{Tr}(E_j\rho)\sigma_j.
\]

Define the record margin

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

## Theorem

If \(\kappa>0\), then there exists an exactly idempotent measure-and-prepare channel

\[
\Pi(\rho)
=
\sum_j\operatorname{Tr}(E_j\rho)\tau_j
\]

using the **same POVM**, such that

\[
\boxed{
\Pi^2=\Pi,
\qquad
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
}
\]

The bound is independent of Hilbert-space dimension and the number of outcomes.

For a PVM, \(\gamma=1\), recovering the original RC Record-Margin Stability Theorem.

## Proof

Fix \(j\). Choose any state \(\rho_j\) supported in \(P_j\). Then

\[
\operatorname{Tr}(E_j\rho_j)=1
\]

and all other outcomes have probability zero, so

\[
\Phi(\rho_j)=\sigma_j.
\]

Set

\[
a_j=\operatorname{Tr}(E_j\sigma_j).
\]

If \(a_j<1\), then

\[
\Phi(\sigma_j)
=
a_j\sigma_j
+
(1-a_j)\omega_j,
\]

where

\[
\omega_j
=
\frac{
\sum_{i\neq j}
\operatorname{Tr}(E_i\sigma_j)\sigma_i
}{
1-a_j
}
\]

lies in the convex hull of the competing records.

Hence

\[
\eta
\ge
\|\Phi^2(\rho_j)-\Phi(\rho_j)\|_1
=
\|\Phi(\sigma_j)-\sigma_j\|_1
\ge
2\kappa(1-a_j),
\]

so

\[
1-a_j
\le
\frac{\eta}{2\kappa}.
\tag{1}
\]

Now let

\[
w_j=\operatorname{Tr}(P_j\sigma_j).
\]

By the definition of \(\gamma_j\),

\[
E_j
\le
P_j+(1-\gamma_j)(I-P_j).
\]

Therefore

\[
a_j
\le
w_j+(1-\gamma_j)(1-w_j)
=
1-\gamma_j(1-w_j).
\]

Combining with (1),

\[
1-w_j
\le
\frac{\eta}{2\kappa\gamma_j}
\le
\frac{\eta}{2\kappa\gamma}.
\tag{2}
\]

If \(w_j>0\), define the normalized projection

\[
\tau_j
=
\frac{P_j\sigma_jP_j}{w_j}.
\]

The standard post-selection fidelity/trace-distance inequality gives

\[
\|\sigma_j-\tau_j\|_1
\le
2\sqrt{1-w_j}
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
\tag{3}
\]

If \(w_j=0\), (2) implies the right side of (3) is at least \(2\), so any state supported in \(P_j\) may be chosen and (3) still holds.

Because \(\tau_j\) is supported in \(P_j\),

\[
\operatorname{Tr}(E_i\tau_j)=\delta_{ij}.
\]

Thus

\[
\Pi(\tau_j)=\tau_j
\]

and therefore

\[
\Pi^2=\Pi.
\]

For a system-plus-ancilla input, positivity of the POVM-conditioned ancilla operators and the triangle inequality give

\[
\|\Phi-\Pi\|_\diamond
\le
\max_j\|\sigma_j-\tau_j\|_1.
\]

Equation (3) proves the claim.

QED.

## Sharp qutrit family

The factor \(\gamma^{-1/2}\) can be saturated.

Take

\[
E_0=\operatorname{diag}(1,c,0),
\qquad
E_1=\operatorname{diag}(0,1-c,1),
\]

with

\[
\frac12\le c<1.
\]

Then

\[
P_0=|0\rangle\langle0|,
\qquad
P_1=|2\rangle\langle2|,
\qquad
\gamma=1-c.
\]

Choose

\[
\sigma_1=|2\rangle\langle2|
\]

and

\[
\sigma_0
=
|\psi_\theta\rangle\langle\psi_\theta|,
\qquad
|\psi_\theta\rangle
=
\cos\theta|0\rangle+\sin\theta|1\rangle.
\]

The records are orthogonal, so

\[
\kappa=1.
\]

A direct calculation gives

\[
\eta
=
2(1-c)\sin^2\theta.
\]

The exact rounded record is \(\tau_0=|0\rangle\langle0|\), while \(\tau_1=\sigma_1\), and

\[
\|\Phi-\Pi\|_\diamond
=
2\sin\theta.
\]

But

\[
\sqrt{
\frac{2\eta}{\kappa\gamma}
}
=
2\sin\theta.
\]

Thus equality holds:

\[
\boxed{
\|\Phi-\Pi\|_\diamond
=
\sqrt{\frac{2\eta}{\kappa\gamma}}.
}
\]

So the spectral-gap dependence is not merely proof slack in this class.

## What this does and does not classify

This result covers every finite POVM whose nonzero effects possess exact repeatable sectors, with the stability constant controlled by the gap below eigenvalue \(1\).

It does **not** classify arbitrary POVMs. If an effect has no eigenvalue \(1\), an exactly repeatable instrument for that POVM is already excluded by standard measurement theory. A broader rounding theorem would have to permit the readout POVM itself to move.

That moving-POVM classification remains open.
