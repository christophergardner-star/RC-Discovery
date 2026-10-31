# POVM Spectral-Gap Record-Margin Stability

**Status:** internally proved and independently reconstructed; novelty unverified  
**Scope:** finite-dimensional repeatability-admissible POVMs

## Setting

Let \(\{E_j\}_{j=1}^m\) be a finite POVM with \(m\ge2\), and suppose every nonzero effect has eigenvalue \(1\). Let \(P_j\) be the full spectral projection of \(E_j\) onto its eigenvalue-\(1\) eigenspace.

Positivity and \(\sum_jE_j=I\) imply

\[
E_iP_j=\delta_{ij}P_j.
\]

Define

\[
\gamma_j
=
1-\|(I-P_j)E_j(I-P_j)\|_\infty,
\qquad
\gamma=\min_j\gamma_j.
\]

In finite dimension, \(\gamma_j>0\) for the full eigenvalue-\(1\) projector.

Let \(\sigma_j\) be density operators and define

\[
\Phi(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j.
\]

Let

\[
\kappa
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1
\]

and

\[
\eta=\|\Phi^2-\Phi\|_\diamond.
\]

## Theorem

If \(\kappa>0\), then there exists an exactly idempotent measure-and-prepare channel

\[
\Pi(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\tau_j
\]

using the same POVM such that

\[
\boxed{
\Pi^2=\Pi,
\qquad
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
}
\]

The bound has no explicit dependence on dimension or outcome count. For a PVM, \(\gamma=1\), recovering the sharp Record-Margin theorem.

## Proof

Fix \(j\). Choose a state \(\rho_j\) supported in \(P_j\). Then \(\Phi(\rho_j)=\sigma_j\).

Set

\[
a_j=\operatorname{Tr}(E_j\sigma_j).
\]

When \(a_j<1\), write

\[
\Phi(\sigma_j)=a_j\sigma_j+(1-a_j)\omega_j,
\]

where \(\omega_j\) is a convex combination of the competing records. Hence

\[
\eta
\ge
\|\Phi(\sigma_j)-\sigma_j\|_1
\ge
2\kappa(1-a_j),
\]

and therefore

\[
1-a_j\le\frac{\eta}{2\kappa}.
\tag{1}
\]

Let

\[
w_j=\operatorname{Tr}(P_j\sigma_j).
\]

By definition of the gap,

\[
E_j\le P_j+(1-\gamma_j)(I-P_j),
\]

so

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

If \(w_j>0\), define

\[
\tau_j=\frac{P_j\sigma_jP_j}{w_j}.
\]

Normalized postselection and (2) give

\[
\|\sigma_j-\tau_j\|_1
\le2\sqrt{1-w_j}
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
\tag{3}
\]

If \(w_j=0\), the right side of (3) is at least \(2\), so any state supported in \(P_j\) works.

Because \(\operatorname{Tr}(E_i\tau_j)=\delta_{ij}\), the channel \(\Pi\) fixes every \(\tau_j\), hence \(\Pi^2=\Pi\). The standard positive conditional-ancilla decomposition gives

\[
\|\Phi-\Pi\|_\diamond
\le
\max_j\|\sigma_j-\tau_j\|_1,
\]

which proves the theorem.

## Sharpness family

For

\[
E_0=\operatorname{diag}(1,c,0),
\qquad
E_1=\operatorname{diag}(0,1-c,1),
\qquad
\frac12\le c<1,
\]

one has \(\gamma=1-c\). With \(\sigma_1=|2\rangle\langle2|\) and

\[
\sigma_0=|\psi_\theta\rangle\langle\psi_\theta|,
\qquad
|\psi_\theta\rangle=\cos\theta|0\rangle+\sin\theta|1\rangle,
\]

the records are orthogonal, \(\kappa=1\), and direct calculation gives

\[
\eta=2(1-c)\sin^2\theta,
\qquad
\|\Phi-\Pi\|_\diamond=2\sin\theta.
\]

Thus

\[
\|\Phi-\Pi\|_\diamond
=
\sqrt{\frac{2\eta}{\kappa\gamma}}.
\]

The spectral-gap dependence is therefore sharp within this class.

## Boundary and status

The eigenvalue-1 criterion for repeatable finite POVMs is established measurement theory and is not claimed here. This theorem addresses stability once those sectors exist; it does not classify arbitrary POVMs whose readout must itself move.

Internal proof reconstruction and implemented tests have passed. External specialist review and definitive novelty assessment remain pending.
