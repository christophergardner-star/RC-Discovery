# RC Record-Margin Stability Theorem

## Setting

Let \(\mathcal H\) be finite dimensional. Let \(\{P_j\}_{j=1}^m\) be non-zero pairwise orthogonal projectors with

\[
\sum_jP_j=I.
\]

Let \(\sigma_j\) be density operators on \(\mathcal H\). Define

\[
\Phi(\rho)=\sum_j\operatorname{Tr}(P_j\rho)\sigma_j.
\]

Define the **record margin**

\[
\kappa
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1,
\]

and the **idempotence defect**

\[
\eta=\|\Phi^2-\Phi\|_\diamond.
\]

## Theorem

If \(\kappa>0\), there exists a sharp measure-and-prepare channel

\[
\Pi(\rho)=\sum_j\operatorname{Tr}(P_j\rho)\tau_j
\]

such that

\[
\Pi^2=\Pi
\]

and

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
}
\]

The constant is independent of \(\dim\mathcal H\) and the number of record sectors.

## Proof

Fix \(j\). For any input state \(\rho_j\) supported entirely in \(P_j\),

\[
\Phi(\rho_j)=\sigma_j.
\]

Define

\[
a_j=\operatorname{Tr}(P_j\sigma_j).
\]

If \(a_j<1\), define

\[
\omega_j
=
\frac{1}{1-a_j}
\sum_{i\neq j}
\operatorname{Tr}(P_i\sigma_j)\sigma_i.
\]

This is a convex combination of competing records, and

\[
\Phi(\sigma_j)=a_j\sigma_j+(1-a_j)\omega_j.
\]

Therefore

\[
\|\Phi(\sigma_j)-\sigma_j\|_1
=
(1-a_j)\|\omega_j-\sigma_j\|_1
\ge
2\kappa(1-a_j).
\]

The diamond norm dominates output trace distance on every ordinary input state, so

\[
\eta
\ge
\|\Phi^2(\rho_j)-\Phi(\rho_j)\|_1
=
\|\Phi(\sigma_j)-\sigma_j\|_1.
\]

Hence

\[
1-a_j\le\frac{\eta}{2\kappa}.
\tag{1}
\]

Assume first \(a_j>0\). Define

\[
\tau_j
=
\frac{P_j\sigma_jP_j}{a_j}.
\]

It is supported entirely in the \(j\)-th sector. The standard fidelity/trace-distance estimate for normalized post-selection gives

\[
\|\sigma_j-\tau_j\|_1
\le
2\sqrt{1-a_j}.
\]

Using (1),

\[
\|\sigma_j-\tau_j\|_1
\le
\sqrt{\frac{2\eta}{\kappa}}.
\tag{2}
\]

If \(a_j=0\), the earlier inequality gives \(\eta\ge2\kappa\), so the right-hand side of (2) is at least \(2\), the maximum trace distance between states. Choose any density operator \(\tau_j\) supported in \(P_j\); (2) still holds.

Now define

\[
\Pi(\rho)
=
\sum_j\operatorname{Tr}(P_j\rho)\tau_j.
\]

Because each \(\tau_j\) is supported in \(P_j\),

\[
\operatorname{Tr}(P_i\tau_j)=\delta_{ij},
\]

so \(\Pi(\tau_j)=\tau_j\) and therefore

\[
\Pi^2=\Pi.
\]

For a system-plus-ancilla state \(\rho_{AR}\),

\[
[(\Phi-\Pi)\otimes I_R](\rho_{AR})
=
\sum_j(\sigma_j-\tau_j)\otimes R_j,
\]

where \(R_j\ge0\) and \(\sum_j\operatorname{Tr}R_j=1\). Hence

\[
\|[(\Phi-\Pi)\otimes I_R](\rho_{AR})\|_1
\le
\sum_j
\|\sigma_j-\tau_j\|_1
\operatorname{Tr}R_j
\le
\max_j\|\sigma_j-\tau_j\|_1.
\]

Taking the diamond-norm supremum and applying (2),

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
}
\]

QED.

## Interpretation

Within this channel class:

> If records are geometrically distinguishable and applying the process twice is almost the same as applying it once, an exactly repeatable record process lies nearby with a dimension-independent error certificate.

The role of \(\kappa\) is essential. As record geometry collapses, the guarantee is allowed to become weak.

## Current status

- Internal proof audit: passed.
- Analytic sharpness family: available.
- Numerical stress tests: passed for implemented families.
- Exact prior theorem located: not yet.
- Independent external audit: pending.

This is therefore a **provisionally novel theorem candidate**, not a publication claim.
