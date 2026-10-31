# RC Record-Margin Stability Theorem

**Status:** internally proved and independently reconstructed; novelty unverified  
**Scope:** finite-dimensional sharp measure-and-prepare channels

## Setting

Let \(\mathcal H\) be finite dimensional. Let \(\{P_j\}_{j=1}^m\) be nonzero pairwise orthogonal projectors satisfying

\[
\sum_jP_j=I.
\]

Let \(\sigma_j\) be density operators and define

\[
\Phi(\rho)=\sum_j\operatorname{Tr}(P_j\rho)\sigma_j.
\]

Define the record margin

\[
\kappa
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\neq j\}}
\|\sigma_j-\omega\|_1,
\]

and the idempotence defect

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

The bound has no explicit dependence on \(\dim\mathcal H\) or the number of sectors.

## Proof

Fix \(j\), and choose any input state \(\rho_j\) supported in \(P_j\). Then

\[
\Phi(\rho_j)=\sigma_j.
\]

Set

\[
a_j=\operatorname{Tr}(P_j\sigma_j).
\]

When \(a_j<1\), define

\[
\omega_j
=
\frac{1}{1-a_j}
\sum_{i\neq j}
\operatorname{Tr}(P_i\sigma_j)\sigma_i.
\]

Then \(\omega_j\) is a convex combination of competing records and

\[
\Phi(\sigma_j)=a_j\sigma_j+(1-a_j)\omega_j.
\]

Therefore

\[
\begin{aligned}
\eta
&\ge
\|\Phi^2(\rho_j)-\Phi(\rho_j)\|_1\\
&=
\|\Phi(\sigma_j)-\sigma_j\|_1\\
&=(1-a_j)\|\omega_j-\sigma_j\|_1\\
&\ge2\kappa(1-a_j).
\end{aligned}
\]

Hence

\[
1-a_j\le\frac{\eta}{2\kappa}.
\tag{1}
\]

If \(a_j>0\), define

\[
\tau_j=\frac{P_j\sigma_jP_j}{a_j}.
\]

Normalized postselection gives

\[
\|\sigma_j-\tau_j\|_1
\le2\sqrt{1-a_j}
\le
\sqrt{\frac{2\eta}{\kappa}}.
\tag{2}
\]

If \(a_j=0\), equation (1) implies \(\eta\ge2\kappa\), so the right-hand side of (2) is at least the maximal trace distance \(2\). Any state supported in \(P_j\) then satisfies (2).

Define

\[
\Pi(\rho)=\sum_j\operatorname{Tr}(P_j\rho)\tau_j.
\]

Because \(\tau_j\) is supported in \(P_j\),

\[
\operatorname{Tr}(P_i\tau_j)=\delta_{ij},
\]

and hence \(\Pi(\tau_j)=\tau_j\), so \(\Pi^2=\Pi\).

For a system-plus-ancilla state \(\rho_{AR}\),

\[
[(\Phi-\Pi)\otimes I_R](\rho_{AR})
=
\sum_j(\sigma_j-\tau_j)\otimes R_j,
\]

where \(R_j\ge0\) and \(\sum_j\operatorname{Tr}R_j=1\). Therefore

\[
\|[(\Phi-\Pi)\otimes I_R](\rho_{AR})\|_1
\le
\max_j\|\sigma_j-\tau_j\|_1.
\]

Taking the diamond-norm supremum and applying (2) proves the result.

## Sharpness and verification

The family in [`sharpness_example.md`](sharpness_example.md) attains equality, so the square-root dependence and universal prefactor are worst-case sharp within this theorem class.

Internal proof reconstruction and implemented numerical tests have passed. The theorem has not been externally peer reviewed, and no literature-search result should be interpreted as a verified novelty certificate.
