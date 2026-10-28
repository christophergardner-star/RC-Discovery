# RC-QND Pilot: Applying Record-Stability to a 2026 IBM Midcircuit-Measurement Model

Date: 28 October 2026  
Status: **application result / derived exact adapter; not a novelty claim by itself**

## Target paper

Chia-Tung Chu, Su-un Lee, Han Zheng, Senrui Chen, Bibek Pokharel, Alireza Seif, Liang Jiang,

**Learning Midcircuit Measurement Backaction from Three Repeated Measurements**

Phys. Rev. Lett. 137, 180601 (2026).  
DOI: 10.1103/y6x3-348l  
arXiv:2606.00433v3

The paper learns a single-qubit Z-twirled midcircuit-measurement instrument as two nonnegative \(2\times2\) matrices

\[
M^{(0)},M^{(1)},
\]

with entries

\[
M^{(o)}_{s',s}=\Pr(o,s'|s).
\]

The unconditional post-measurement population-transfer matrix is

\[
B=M^{(0)}+M^{(1)}
=
\begin{pmatrix}
1-u & d\\
u & 1-d
\end{pmatrix},
\]

where

\[
u=\eta_\uparrow
\]

is the measurement-induced excitation probability and

\[
d=\eta_\downarrow
\]

is the measurement-induced decay probability.

This is exactly the kind of binary sharp measure-and-prepare population channel covered by the original RC Record-Margin Stability theorem.

---

# 1. Exact RC adapter for the Z-twirled population channel

Define

\[
\sigma_0=
\begin{pmatrix}
1-u&0\\
0&u
\end{pmatrix},
\qquad
\sigma_1=
\begin{pmatrix}
d&0\\
0&1-d
\end{pmatrix}.
\]

The channel is

\[
\Phi_B(\rho)
=
\operatorname{Tr}(|0\rangle\langle0|\rho)\sigma_0
+
\operatorname{Tr}(|1\rangle\langle1|\rho)\sigma_1.
\]

## Record margin

For two diagonal records,

\[
\boxed{
\kappa_B
=
\frac12\|\sigma_0-\sigma_1\|_1
=
|1-u-d|.
}
\]

In the experimentally relevant regime \(u+d<1\),

\[
\kappa_B=1-u-d.
\]

## Idempotence defect

A direct calculation gives

\[
\Phi_B(\sigma_0)-\sigma_0
=
u(\sigma_1-\sigma_0),
\]

\[
\Phi_B(\sigma_1)-\sigma_1
=
d(\sigma_0-\sigma_1).
\]

Because this is a classical-output measure-and-prepare map, ancillas do not improve the optimum, so

\[
\boxed{
\eta_{\rm RC}
:=
\|\Phi_B^2-\Phi_B\|_\diamond
=
2\max(u,d)|1-u-d|.
}
\]

## Exact distance to ideal QND population preservation

Let

\[
\Pi(\rho)
=
\operatorname{Tr}(|0\rangle\langle0|\rho)|0\rangle\langle0|
+
\operatorname{Tr}(|1\rangle\langle1|\rho)|1\rangle\langle1|.
\]

Then

\[
\boxed{
\|\Phi_B-\Pi\|_\diamond
=
2\max(u,d).
}
\]

So in this special binary-classical case the exact distance is available, rather than merely an upper bound.

## Generic RC theorem bound

The Record-Margin theorem gives

\[
\|\Phi_B-\Pi\|_\diamond
\le
\sqrt{
\frac{2\eta_{\rm RC}}{\kappa_B}
}.
\]

Substituting the exact formulas yields

\[
\boxed{
\|\Phi_B-\Pi\|_\diamond
\le
2\sqrt{\max(u,d)}.
}
\]

This is valid but generally conservative compared with the exact binary-classical value \(2\max(u,d)\).

---

# 2. Readout-label separation

The paper separately defines the classical readout confusion matrix

\[
A=
\begin{pmatrix}
1-\epsilon_{1|0}&\epsilon_{0|1}\\
\epsilon_{1|0}&1-\epsilon_{0|1}
\end{pmatrix}.
\]

The total-variation separation between the two readout-label distributions is

\[
\boxed{
\kappa_{\rm label}
=
|1-\epsilon_{1|0}-\epsilon_{0|1}|.
}
\]

This is not the same quantity as dynamical stability of the post-measurement state.

The learned instrument therefore naturally separates two questions:

1. **Can the record label distinguish the input?** — controlled by \(\kappa_{\rm label}\).
2. **Does the MCM preserve the computational-basis population?** — controlled by \(u,d\) and the RC-QND state certificate.

That separation is one reason the full learned instrument is more informative than a confusion matrix alone.

---

# 3. Gauge-aware RC certificate

The paper reports a residual gauge parameter \(t\). The four learned readout/backaction rates become functions

\[
\epsilon_{1|0}(t),\;
\epsilon_{0|1}(t),\;
u(t),\;
d(t)
\]

over the physically allowed gauge set.

Therefore RC quantities should also be reported as gauge bands:

\[
\kappa_B(t)=|1-u(t)-d(t)|,
\]

\[
\eta_{\rm RC}(t)
=
2\max(u(t),d(t))\kappa_B(t),
\]

\[
D_{\rm exact}(t)
=
2\max(u(t),d(t)),
\]

\[
D_{\rm RC}(t)
=
2\sqrt{\max(u(t),d(t))}.
\]

A robust certificate is obtained by maximizing the distance quantity over the allowed physical gauge branch.

The paper reports that its four MCM error-rate gauge bands are typically narrower than 10% relative width, so this optimization should remain numerically well conditioned on their measured devices.

---

# 4. Published IBM example: qubit 40 on ibm_kingston

Figure 2(a) of the paper gives a representative qubit-40 example.

Reading the plotted gauge-midpoint markers approximately gives

\[
u=\eta_\uparrow
\approx
(1.3\text{--}1.6)\times10^{-3},
\]

\[
d=\eta_\downarrow
\approx
(7\text{--}8)\times10^{-3}.
\]

These are **plot-read estimates**, not machine-readable values supplied by the authors.

Using those ranges gives approximately

\[
\boxed{
\kappa_B
\approx
0.9904\text{--}0.9917
}
\]

and

\[
\boxed{
\eta_{\rm RC}
\approx
0.0139\text{--}0.0158.
}
\]

The exact population-channel distance to ideal QND preservation is

\[
\boxed{
D_{\rm exact}
=
2\max(u,d)
\approx
0.014\text{--}0.016
}
\]

or about **1.4%–1.6%** in trace/diamond distance.

The generic RC theorem gives

\[
\boxed{
D_{\rm RC}
=
2\sqrt{\max(u,d)}
\approx
0.167\text{--}0.179.
}
\]

So the generic theorem gives a valid nontrivial certificate but is about an order of magnitude looser than the exact binary-classical formula in this example.

This is an important application lesson:

> The general Record-Margin theorem is a fallback certificate. When the learned record dynamics is explicitly classical and binary, use the exact adapter instead.

---

# 5. What the pilot establishes

The pilot does **not** claim a new result about IBM hardware beyond the cited paper.

It establishes that the RC framework can ingest a published learned midcircuit-measurement model and output a rigorous stability quantity with a clear operational interpretation.

For the Z-twirled population dynamics, no full quantum process tomography is needed once \(u\) and \(d\) are known.

The paper obtains those rates from only three repeated MCMs on a maximally mixed input, up to a narrow gauge band.

Thus the combined workflow is:

\[
\boxed{
\text{three-repeat MCM learning}
\rightarrow
u,d
\rightarrow
\text{RC-QND stability certificate}.
}
\]

---

# 6. Practical next step

The paper does not publish the 60 exact gauge-band endpoint pairs as a machine-readable table in the accessible manuscript.

To run the full 60-qubit RC-QND benchmark exactly, obtain either:

1. the reconstructed \(M^{(0)},M^{(1)}\) matrices for every qubit, or
2. the gauge-band endpoints for \(u=\eta_\uparrow\) and \(d=\eta_\downarrow\).

Then compute, for every allowed gauge representative,

\[
\kappa_B,\quad
\eta_{\rm RC},\quad
D_{\rm exact},\quad
D_{\rm RC},
\]

and compare those with the paper's observed long-depth prediction error.

A particularly useful empirical test would be:

> Does \(D_{\rm exact}\) or the gauge-robust RC certificate predict which qubits accumulate the largest MCM-induced error in the independent depth-10 validation circuits?

If yes, RC becomes a useful diagnostic rather than only a structural theorem.

---

# Status

- Mathematical adapter: **exactly derived**.
- Application to published model class: **successful**.
- Qubit-40 numerical values: **approximate plot-read pilot only**.
- Full 60-qubit hardware benchmark: **requires exact reconstructed data / gauge bands**.
- Novelty claim: **none for the binary classical formulas; application methodology is a new RC use case to investigate**.
