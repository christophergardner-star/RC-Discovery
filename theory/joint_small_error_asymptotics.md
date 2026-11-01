# Sharp joint small-error asymptotics for the prescribed completion

1 November 2026. Internally reconstructed analytic result. Not externally
reviewed or completely formalized; publication novelty unverified. The frozen
theorem remains valid. This note improves its small-error analysis.

## Result

Use the full hypotheses and prescribed **unweighted** completion of the
[frozen theorem](THEOREM_V1_FREEZE.md). Write

\[
 a^2=1-\alpha^2,\quad s=a^2+\delta,\quad
 d=\sqrt{1-\delta},\quad \varepsilon=1-\alpha^2(1-\delta),
 \qquad
 h=\max\{1-\alpha,d^{-1}-1\}+1-d.
\]

For every admissible POVM, in unhalved diamond norm,

\[
 \boxed{\nu\le\min\left\{2,
 \frac{2\sqrt\varepsilon}{\sqrt{4-\varepsilon}}+2h\right\}.} \tag{1}
\]

This bound does not require the earlier Jordan-product width condition.
It need not improve earlier bounds away from the small-error regime.

Let W(alpha,delta) be the supremum of nu over all finite-dimensional POVMs
satisfying the hypotheses with synthesis minimum **exactly** alpha and the
specified threshold parameter delta. Dimensions, ranks and label counts
are unrestricted. For `0<delta<1/4`, this class is nonempty for every
`0<alpha<=1`, and

\[
 \sqrt{s}\sqrt{\frac{1-2\delta}{1+2\delta}}
 \le W(\alpha,\delta)
 \le \frac{2\sqrt\varepsilon}{\sqrt{4-\varepsilon}}+2h.
 \tag{2}
\]

Consequently the sharp leading joint envelope is

\[
 \boxed{\frac{W(\alpha,\delta)}{\sqrt{1-\alpha^2+\delta}}
 \longrightarrow1\quad\text{as }(\alpha,\delta)\longrightarrow(1,0),
 \quad \delta>0.} \tag{3}
\]

The limit is joint: no fixed ratio of the two errors is required. In
particular, for every fixed `r>=0`, along `1-alpha^2=r delta`,

\[
 \frac{W(\sqrt{1-r\delta},\delta)}{\sqrt\delta}
 \longrightarrow\sqrt{1+r}. \tag{4}
\]

For the requested ratio `r=1`, the leading constant is therefore sqrt(2),
closing the previous factor-two gap. Equation (3) concerns a worst-case
supremum; it does not say every POVM attains this error. The lower construction
uses growing dimension and label count as delta tends to zero.

## 1. Split the selected effects from the positive remainder

Let `T=UH` be the synthesis polar decomposition on the sector direct sum K.
Let C_j be its coordinate projections and let D have blocks
`sqrt(E_j)|ran(P_j)`. The standard inequalities are

\[
 \alpha I\le H\le d^{-1}I,\qquad dI\le D\le I.
\]

Define on the original Hilbert space

\[
 A_j=P_jE_jP_j=UHDC_jDHU^*,\qquad B_j=E_j-A_j\ge0.
\]

The identity for A_j uses that D commutes with every C_j; it does not
assume that D commutes with H. Since each A_j is a spectral part of E_j,

\[
 \sum_jA_j=UHD^2HU^*\le I.
\]

On K put `Delta_K=I-HD^2H`. Congruence of `D^2>=d^2 I` gives

\[
 0\le\Delta_{\mathcal K}\le\varepsilon I.
\]

With S=UU*, R=I-S and Delta=U Delta_K U*, the positive remainder sums to

\[
 \sum_jB_j=R+\Delta=:L,\qquad
 \sqrt L=R+\sqrt\Delta.
\]

Normalize `N_j=L^{-1/2}B_jL^{-1/2}` on the support of L. Each B_j
annihilates the kernel of L because `0<=B_j<=L`. Extend the N_j to a POVM
by allocating the kernel projection to any label. Its measurement channel
N is CPTP. Since `A_j R=0`, `RB_jR=RE_jR`. Therefore the exact identity is

\[
 \mathcal M_E-\mathcal M_F
 =\mathcal N\bigl(\sqrt L\,\cdot\,\sqrt L-R\,\cdot\,R\bigr)
   +(\mathcal M_A-\mathcal M_Q). \tag{5}
\]

Here M_A and M_Q are completely positive maps, not generally channels on
the entire input space. No channel norm ceiling is applied to their difference.

## 2. Bound the two terms, with an arbitrary reference

Take a pure input psi on the system and any finite reference. Put
`p=<psi,(S tensor I)psi>`, `q=1-p` and
`t=<psi,(Delta tensor I)psi> <= epsilon p`. With
`x=(sqrt(L) tensor I)psi`, `y=(R tensor I)psi`, the norms and overlap are
`||x||^2=t+q`, `||y||^2=q`, `<x,y>=q`. Thus

\[
 \|xx^*-yy^*\|_1=\sqrt{t^2+4tq}
 \le\sqrt{\varepsilon^2p^2+4\varepsilon p(1-p)}. \tag{6}
\]

CPTP contractivity bounds the first term in (5) by (6), including the
reference. This is the same established rank-two gentle-measurement
calculation used in the perfect-packing proof.

For the second term let `z=(U* tensor I)psi`, so `||z||^2=p`.
Before the common coordinate measurement its two outputs are the rank-one
operators of z and `w=(DH tensor I)z`. The operator DH is a contraction,
because `HD^2H<=I`. The elementary outer-product difference bound gives

\[
 \|ww^*-zz^*\|_1
 \le(\|w\|+\|z\|)\|w-z\|
 \le2\|DH-I\|p\le2hp. \tag{7}
\]

The last inequality follows from
`DH-I=D(H-I)+(D-I)` and `||D||<=1`, hence
`||DH-I||<=||H-I||+||D-I||<=h`.
This estimate has no label-count or rank factor. It is the useful change
from the earlier sector-angle bound: h is of order `a^2+delta`, not its
square root, when both errors are small.

Combining (5)--(7) bounds each reference-assisted input by

\[
 2hp+\sqrt{\varepsilon^2p^2+4\varepsilon p(1-p)}.
\]

For `0<epsilon<1`, completing the square yields

\[
 \varepsilon^2p^2+4\varepsilon p(1-p)
 =\frac{4\varepsilon}{4-\varepsilon}
 -\varepsilon(4-\varepsilon)
   \left(p-\frac{2}{4-\varepsilon}\right)^2.
\]

Use `p<=1` in the first summand and the displayed maximum in the second.
The pure-input characterization of channel diamond distance proves (1).
This proof covers zero labels, high-rank and degenerate sectors, `R=0`,
and a singular L. It never replaces the full distance by a system-only norm.

## 3. Match the bound at every sufficiently small threshold

For arbitrary `0<delta<1/4`, choose the even integer

\[
 m=2\left\lceil\frac1{2\delta}\right\rceil,
 \qquad \delta' =1/m\le\delta,\qquad
 \frac{\delta'}{\delta}\ge\frac1{1+2\delta}.
\]

Use the [coupled-simplex family](imperfect_packing_lower_bound.md) with this
m and the requested alpha. Its selected eigenvalues are `1-delta'`, hence
at least `1-delta`; every other eigenvalue is at most `2/m<=2 delta<1-delta`.
Thus increasing the declared threshold parameter from delta' to delta
preserves **exactly** the full selected sectors, alpha and completion.
The family is admissible for W(alpha,delta), not just for a nearby parameter.

Its proved system-only witness satisfies, with `a^2=1-alpha^2`,

\[
 \nu^2\ge L_m^2
 =\frac{m-2}{m-1+a^2}\left(a^2+\frac1{m-1}\right)
 \ge(1-2\delta)\left(a^2+\frac{\delta}{1+2\delta}\right)
 \ge\frac{1-2\delta}{1+2\delta}\,(a^2+\delta). \tag{8}
\]

Here `0<=a^2<1` implies `(m-2)/(m-1+a^2)>=(m-2)/m>=1-2delta`.
This proves the lower bound in (2), including alpha=1.

For the upper asymptotics, `epsilon=s-a^2 delta`, so `epsilon/s -> 1`.
Also

\[
 1-\alpha=\frac{a^2}{1+\alpha},\quad
 d^{-1}-1=\frac{\delta}{d(1+d)},\quad
 1-d=\frac{\delta}{1+d}.
\]

It follows uniformly as s tends to zero that `h=O(s)`, so the upper bound
in (2), divided by sqrt(s), tends to one. The lower bound does likewise.
This proves (3)--(4), not merely subsequential numerical convergence.

An explicit uniform estimate is also available. If `s<=1/4`, the displayed
denominators give `h<=2s`. Furthermore
`(1-s/4)^(-1/2)<=1+s`, as follows by squaring, and
`sqrt((1-2delta)/(1+2delta))>=1-2delta`. Hence

\[
 (1-2\delta)\sqrt{s}\le W(\alpha,\delta)
 \le\sqrt{s}+5s\qquad (s\le1/4). \tag{9}
\]

The coefficient five is only a convenient remainder bound, not a sharp
subleading coefficient. Equation (9) makes the uniformity of (3) explicit.

## Scope and attribution

The finite-error expression sqrt(s) alone is **not** asserted as an upper
bound. Even the perfect-packing extremizers exceed sqrt(delta) at every
positive delta. The remainder in (1) matters, and the earlier finite-error
vetoes remain valid. The exact general finite-error envelope and subleading
joint term remain open. No claim about a fixed dimension's sharp coefficient
or the best freely chosen repeatable target is implied by (3).

The proof combines spectral splitting, polar norm bounds, CP factorization,
trace-norm contractivity and the familiar gentle-measurement rank-two
identity; see [Regula--Lami--Datta, Appendix C](https://arxiv.org/html/2501.12447v5)
and the [existing attribution audit](../literature/FINAL_FOCUSED_VETO_2026-11-01.md).
The lower construction was already proved in this repository. The additional
step here is the dimension-free order-s control of the selected-effect map,
which matches that lower construction at leading order. Whether this
completion-specific consequence is already in the literature remains open.

The [verification script](../experiments/test_joint_small_error.py) exercises
the operator decomposition and both trace-norm estimates on finite inputs,
then checks selected full diamond SDPs. Its
[retained report](../research/joint_small_error_2026-11-01/verification.json)
is numerical support, not a formal proof of the universal claim.
