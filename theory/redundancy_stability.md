# Redundancy, Record Margin, and Stability

**Status:** exact corollaries of known state-discrimination facts and the internal Record-Margin theorem; novelty unverified

This note separates what independent record redundancy proves from the false slogan that mere multiplicity automatically makes dynamics classical.

## Binary records

For two records \(\rho_0,\rho_1\),

\[
\kappa=\frac12\|\rho_0-\rho_1\|_1.
\]

For \(R\) independent fragments,

\[
\rho_j^{(R)}=\rho_j^{\otimes R},
\]

and therefore

\[
\boxed{
\kappa_R
=
\frac12
\left\|
\rho_0^{\otimes R}-\rho_1^{\otimes R}
\right\|_1.
}
\]

This is the optimal equal-prior binary state-discrimination advantage.

## Pure records

If

\[
\rho_0=|e_0\rangle\langle e_0|,
\qquad
\rho_1=|e_1\rangle\langle e_1|,
\qquad
s=|\langle e_0|e_1\rangle|<1,
\]

then

\[
\boxed{
\kappa_R=\sqrt{1-s^{2R}}.
}
\]

Thus the margin approaches one exponentially. If the corresponding sharp record channel has idempotence defect \(\eta_R\), the Record-Margin theorem gives

\[
\boxed{
\|\Phi_R-\Pi_R\|_\diamond
\le
\sqrt{2\eta_R}\,(1-s^{2R})^{-1/4}.
}
\]

At fixed \(\eta_R\), redundancy improves the conditioning of the certificate. It does not force \(\eta_R\) itself to decrease.

For a target margin \(0<\kappa_\star<1\), the pure binary case requires

\[
\boxed{
R
\ge
\frac{\log(1-\kappa_\star^2)}{2\log s},
}
\]

rounded upward, for \(0<s<1\).

## Mixed records

Let

\[
f(\rho_0,\rho_1)=\|\sqrt{\rho_0}\sqrt{\rho_1}\|_1
\]

be root fidelity. Tensor products obey

\[
f(\rho_0^{\otimes R},\rho_1^{\otimes R})=f(\rho_0,\rho_1)^R.
\]

Fuchs–van de Graaf gives

\[
\boxed{
\kappa_R\ge1-f(\rho_0,ho_1)^R,
}
\]

and hence, whenever the denominator is nonzero,

\[
\boxed{
\|\Phi_R-\Pi_R\|_\diamond
\le
\sqrt{\frac{2\eta_R}{1-f(\rho_0,ho_1)^R}}.
}
\]

The discrimination and Chernoff ingredients here are standard prior art.

## Multi-record operational bridge

Suppose a POVM \(\{D_j\}\) identifies every record \(\rho_j\) with worst-case error at most \(\epsilon\):

\[
\operatorname{Tr}(D_j\rho_j)\ge1-\epsilon.
\]

Then for any convex combination \(\omega\) of competing records,

\[
\operatorname{Tr}(D_j\omega)\le\epsilon.
\]

The operational characterization of trace distance gives

\[
\frac12\|\rho_j-\omega\|_1\ge1-2\epsilon,
\]

so

\[
\boxed{\kappa\ge1-2\epsilon.}
\]

This converts a worst-case discrimination guarantee into the geometric parameter required by the Record-Margin theorem.

## Correlated redundancy can fail completely

Let \(0<p<1/2\) and define perfectly correlated \(R\)-fragment records

\[
\rho_0^{(R)}=(1-p)|0^R\rangle\langle0^R|+p|1^R\rangle\langle1^R|,
\]

\[
\rho_1^{(R)}=p|0^R\rangle\langle0^R|+(1-p)|1^R\rangle\langle1^R|.
\]

All fragments share the same error. For every \(R\),

\[
\boxed{\kappa_R=1-2p.}
\]

There is no redundancy gain.

The defensible conclusion is therefore

\[
\boxed{
\text{independent fresh record information can improve }\kappa;
\quad
\text{mere multiplicity need not.}
}
\]

## Claim boundary

The state-discrimination formulas, fidelity inequalities, and Chernoff asymptotics are known and are not claimed by RC-Discovery. Their substitution into the Record-Margin certificate is an application of the internal theorem candidate. External review and novelty assessment of any combined framing remain pending.
