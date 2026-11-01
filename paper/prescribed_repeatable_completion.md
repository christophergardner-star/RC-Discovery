# Stability of a prescribed repeatable completion of a quantum measurement

**Author:** Christopher Gardner  
**Date:** 1 November 2026

<!-- Generated from arxiv_ready.md; edit that source and rebuild. -->

**External-review draft.** The argument below gives an explicit
quantitative specialization of established constructions and
inequalities. The supplied reduction, its usefulness, and publication
priority remain subjects for independent review.

## Abstract

Let $`E=(E_j)`$ be a finite positive-operator-valued measurement (POVM),
and let $`P_j`$ be its full spectral sectors at or above $`1-\delta`$,
where $`0<\delta<1/2`$. Assume that each nonzero effect has a nonzero
sector and that the sector synthesis operator is injective, with least
singular value $`\alpha`$. Its unweighted polar isometry determines
orthogonal sectors $`Q_j`$. We prove that the prescribed completion
$`F_j=Q_j+RE_jR`$, where $`R=I-\sum_jQ_j`$, admits a repeatable
instrument and satisfies
``` math
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le 2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.
```
The proof reduces to polar geometry, a classical Jordan-product
inequality, and pure-state trace distance after an explicit
labelled-dilation calculation. For orthogonal input sectors, we
determine the exact worst-case envelope $`2\sqrt\delta/(2-\sqrt\delta)`$
and exhibit an attaining family. For general packing, a residual
decomposition and a coupled simplex lower construction determine the
sharp joint leading envelope $`\sqrt{1-\alpha^2+\delta}`$ as
$`(\alpha,\delta)\to(1,0)`$, uniformly over dimension and outcome count.
Exact rational certificates show both a strict reference advantage and
the failure of a natural finite-error joint extension. A corollary
corrects separated output records to an exactly idempotent channel. Both
sector constructions are established least-squares measurements; no new
general operator lemma or literature priority is claimed. The exact
joint finite-error envelope remains open.

## 1. Question and scope

A finite POVM can admit a repeatable instrument without being a
projection-valued measurement (PVM). The relevant criterion is that
every nonzero effect have eigenvalue one (Busch et al. 1995). Such
measurements have orthogonal unit eigenspaces and may retain an
arbitrary POVM on their common orthogonal complement. We study a
particular way to select a nearby measurement in this class while
retaining the input space, labels, and compressed residual effects.

The construction uses the polar factor of a synthesis operator, a
standard orthogonalization device (Higham 1986). Its sector vectors are
exactly the unweighted least-squares measurement of Eldar–Forney; the
weighted counterpart below is their weighted version (Eldar and Forney
2001). The issue addressed here is quantitative control of a prescribed
residual extension in the full diamond norm. The hypothesis concerns
near-unit sectors and their simultaneous linear independence; it is not
a global almost-projectivity assumption.

The distinction from earlier work is limited. De la Salle’s
orthogonalization proof also contains a closely related weighted polar
construction (Salle 2022). Dilation continuity is standard (Kretschmann
et al. 2008), and the noncommuting matrix inequality used below is a
special case of the Strang–de Bruijn Jordan-product bounds (Bruijn
1980). No additional general operator lemma is needed: the
measurement-specific work is the labelled dilation and residual
compression, followed by parameter substitution. Section 5 makes the
reduction explicit. This is a quantitative specialization with a
complete argument.

## 2. Setting and main statement

Let $`\mathcal H\ne\{0\}`$ be a finite-dimensional complex Hilbert
space. Write $`\|\cdot\|`$ for operator norm and $`\|\cdot\|_1`$ for
trace norm. A POVM $`E=(E_j)_{j=1}^m`$, $`m\ge1`$, consists of positive
operators summing to $`I`$. Its measurement channel is
``` math
\mathcal M_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)|j\rangle\langle j|.
```
We use the unhalved diamond norm; all state distances below likewise use
the unhalved trace norm. For a difference of channels the diamond norm
equals the supremum of output trace-norm difference over density
operators with an arbitrary reference system; reference-assisted pure
inputs suffice (Watrous 2018, Theorem 3.51). Consequently its maximum is
two. Channels are completely positive and trace preserving (CPTP); their
adjoints are unital completely positive (UCP).

Fix $`0<\delta<1/2`$ and set
``` math
P_j=1_{[1-\delta,1]}(E_j),\qquad
\mathcal K_j=\operatorname{ran}P_j,\qquad
\mathcal K=\bigoplus_j\mathcal K_j.
\tag{1}
```
Assume $`P_j\ne0`$ whenever $`E_j\ne0`$. A zero effect has $`P_j=0`$ and
may retain its label. Define
``` math
T:\mathcal K\longrightarrow\mathcal H,\qquad
T(x_1,\ldots,x_m)=\sum_jx_j,
\qquad \alpha=\sigma_{\min}(T)>0.
\tag{2}
```
Thus $`T`$ is injective. Write $`T=UH`$, with $`H=|T|`$, and let $`C_j`$
be the coordinate projection of $`\mathcal K`$ onto $`\mathcal K_j`$.
Put
``` math
Q_j=UC_jU^*,\qquad S=UU^*,\qquad R=I-S,\qquad
F_j=Q_j+RE_jR.
\tag{3}
```

**Theorem 1 (prescribed completion).** Under (1)–(2), the $`Q_j`$ are
mutually orthogonal, have the ranks of $`P_j`$, and obey
``` math
\|P_j-Q_j\|\le a,\qquad a:=\sqrt{1-\alpha^2}.
\tag{4}
```
The family $`F`$ in (3) is a POVM with full unit eigenspaces $`Q_j`$,
and
``` math
\begin{gathered}
F_iQ_j=\delta_{ij}Q_j,\\
\gamma_F:=\min_j\left[1-\|(I-Q_j)F_j(I-Q_j)\|\right]\ge\delta.
\end{gathered}
\tag{5}
```
It admits a repeatable instrument and satisfies
``` math
\boxed{\|\mathcal M_E-\mathcal M_F\|_\diamond
\le 2\min\{1,a+\sqrt\delta\}.}
\tag{6}
```
More precisely, writing $`d_0=\sqrt{1-\delta}`$ and $`M=\|H\|`$, the
sufficient condition
``` math
(M-\alpha)(1-d_0)\le4\alpha d_0
\tag{7}
```
implies
``` math
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le 2\sqrt{1-\alpha^2(1-\delta)}.
\tag{8}
```

The constants contain no explicit dimension, outcome-count, or
sector-rank factor. The domain remains restrictive:
$`\sum_j\operatorname{rank}P_j\le\dim\mathcal H`$, so there are at most
$`\dim\mathcal H`$ nonzero outcomes. The estimate does not apply to
generic overcomplete POVMs.

## 3. Proof of Theorem 1

### 3.1. Geometry and the residual gap

The polar factor $`U`$ is an isometry with
$`\operatorname{ran}U=\operatorname{ran}T=\sum_j\operatorname{ran}P_j`$.
Thus $`P_jR=0`$, and the $`Q_j`$ are orthogonal and rank preserving. A
unit vector supported in one nonzero coordinate sector has $`\|Tx\|=1`$,
proving $`\alpha\le1`$. The spectral inequality $`E_j\ge(1-\delta)P_j`$
gives
``` math
(1-\delta)TT^*=(1-\delta)\sum_jP_j\le I,
\qquad M\le d_0^{-1}.
\tag{9}
```

For a nonzero sector let $`\iota_j:\mathcal K_j\to\mathcal K`$ be the
coordinate inclusion, $`T_j=T\iota_j`$, and $`U_j=U\iota_j`$. Both
$`T_j`$ and $`U_j`$ are isometries, and
``` math
T_j^*U_j=\iota_j^*H\iota_j\ge\alpha I_{\mathcal K_j}.
```
Hence their overlap has smallest singular value at least $`\alpha`$. It
follows that $`\|(I-P_j)Q_j\|`$ and $`\|(I-Q_j)P_j\|`$ are at most
$`a`$. For two orthogonal projections their difference norm is the
maximum of these two quantities, proving (4). One may verify this
identity by squaring the difference and taking its two diagonal blocks
relative to the first projection. Zero sectors are immediate.

Each $`F_j`$ is positive, and
``` math
\sum_jF_j=S+R\Bigl(\sum_jE_j\Bigr)R=I.
```
Equation (5)’s sector action follows from orthogonality. Fullness of the
spectral sector gives
``` math
E_j\le P_j+(1-\delta)(I-P_j),\qquad
RE_jR\le(1-\delta)R.
\tag{10}
```
On $`S`$, the effect $`F_j`$ is $`Q_j`$; on $`R`$, its norm is at most
$`1-\delta`$. Thus $`Q_j`$ is its full unit eigenspace and (5) holds,
including zero effects. Choosing a density operator $`\tau_j`$ supported
in each nonzero $`Q_j`$ gives the instrument
$`\mathcal I_j(\rho)=\operatorname{Tr}(F_j\rho)\tau_j`$. For a zero
effect set $`\mathcal I_j=0`$. Since
$`\operatorname{Tr}(F_i\tau_j)=\delta_{ij}`$, a repetition returns the
same outcome.

### 3.2. An explicit labelled dilation

On $`\mathcal Y=\bigoplus_j\mathcal H`$, let $`\Lambda_j`$ project onto
label $`j`$, and define
``` math
\begin{aligned}
W:\mathcal H\to\mathcal Y,&\quad Wz=(\sqrt{E_j}z)_j,\\
J:\mathcal K\to\mathcal Y,&\quad J(x_j)_j=(x_j)_j.
\end{aligned}
\tag{11}
```
In particular, $`J`$ embeds the original sector vectors. Both $`W`$ and
$`J`$ are isometries. Spectral commutation allows the block operator
``` math
D=\bigoplus_j\sqrt{E_j}\big|_{\mathcal K_j},
\qquad d_0I\le D\le I.
```
Directly from their domains,
``` math
W^*J=TD=UHD,\qquad
J^*\Lambda_jWR=0\quad\text{for every }j.
\tag{12}
```
Indeed, the only possible nonzero coordinate of the second expression is
$`P_j\sqrt{E_j}R=\sqrt{E_j}P_jR=0`$.

Set
``` math
V=JU^*+WR.
\tag{13}
```
The cross terms in $`V^*V`$ vanish, so $`V^*V=S+R=I`$. The labelwise
identities in (12), together with $`J^*\Lambda_jJ=C_j`$, give
``` math
V^*\Lambda_jV=UC_jU^*+RE_jR=F_j,\qquad
W^*V=UHD\,U^*+R.
\tag{14}
```
These identities concern the particular completion (3).

### 3.3. The overlap estimate

**Lemma 2 (classical Jordan-product specialization).** If
$`\alpha I\le H\le MI`$, $`d_0I\le D\le I`$, and (7) holds, then
$`\operatorname{Re}(HD)\ge\alpha d_0I`$.

*Proof.* Set $`X=H-\alpha I`$, $`Y=D-d_0I`$, $`h=M-\alpha`$, and
$`r=1-d_0`$. For $`s>0`$, positivity of $`(\sqrt{s}X+s^{-1/2}Y)^2`$
implies
``` math
XY+YX\ge-sX^2-s^{-1}Y^2\ge-shX-(r/s)Y.
```
Therefore
``` math
\operatorname{Re}(HD)-\alpha d_0I
\ge(d_0-sh/2)X+(\alpha-r/(2s))Y.
```
For $`h>0`$, take $`s=2d_0/h`$; both coefficients are nonnegative by
(7). For $`h=0`$, $`H=\alpha I`$ and the assertion is immediate.
$`\square`$

For attribution, put $`u=(M-\alpha)/(M+\alpha)`$ and
$`v=(1-d_0)/(1+d_0)`$. Condition (7) is exactly $`u+v\le1`$; the
corresponding branch of de Bruijn’s Theorem 3.2 and Sections 4–5 gives
the lower bound $`(M+\alpha)(1+d_0)(1-u)(1-v)/4=\alpha d_0`$ (Bruijn
1980). The proof above is included for completeness.

By (14) and $`\alpha d_0\le1`$, Lemma 2 yields
``` math
\operatorname{Re}(W^*V)\ge\alpha d_0S+R\ge\alpha d_0I.
```
For any normalized $`\psi\in\mathcal H\otimes\mathcal A`$, the dilated
vectors $`(W\otimes I_{\mathcal A})\psi`$ and
$`(V\otimes I_{\mathcal A})\psi`$ have overlap of modulus at least
$`\alpha d_0`$. The trace distance of their pure density operators is
consequently at most $`2\sqrt{1-\alpha^2d_0^2}`$. Apply to both the same
CPTP label readout
$`\mathcal L(X)=\sum_j\operatorname{Tr}(\Lambda_jX)|j\rangle\langle j|`$,
with the identity on $`\mathcal A`$. Trace-norm contractivity and the
reference-assisted characterization prove (8).

To obtain (6), write $`b=\sqrt\delta`$. If $`a+b\ge1`$, use the
universal bound two. Otherwise $`a<1-b`$, so $`\alpha^2>2b-b^2>b^2`$,
hence $`\alpha>b`$. By (9),
``` math
(M-\alpha)(1-d_0)\le M(1-d_0)
\le\frac{\delta}{d_0(1+d_0)}
\le\delta<4\alpha d_0.
```
Here $`d_0>1/\sqrt2`$, and $`b<4d_0`$. Thus (7) holds, and
``` math
2\sqrt{1-\alpha^2(1-\delta)}
=2\sqrt{a^2+\alpha^2\delta}
\le2(a+b).
```
This completes the proof of Theorem 1. $`\square`$

## 4. Correction of supplied records

Let $`\sigma_j`$ be density operators on the same $`\mathcal H`$, and
set
``` math
\Phi(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j,\qquad
\eta=\|\Phi^2-\Phi\|_\diamond.
```
For this section discard zero effects and their unused records. Assume
at least two remaining labels and define
``` math
\begin{gathered}
\kappa=\min_j\frac12\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\ne j\}}
\|\sigma_j-\omega\|_1>0,\\
e=\max_j(1-\lambda_{\max}(E_j)).
\end{gathered}
\tag{15}
```
The main hypotheses give $`0\le e\le\delta<1/2`$. With one remaining
label the channel is constant and already idempotent.

**Corollary 3 (record correction).** Under Theorem 1 and (15), there are
explicit states $`\tau_j`$ supported in $`Q_j`$ such that
$`\Pi(\rho)=\sum_j\operatorname{Tr}(F_j\rho)\tau_j`$ is exactly
idempotent. For any valid measurement movement bound $`B_{\rm move}`$,
``` math
\boxed{\|\Phi-\Pi\|_\diamond\le
\min\left\{2,\ B_{\rm move}+2a+
\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}\right\}.}
\tag{16}
```
In particular,
``` math
\|\Phi-\Pi\|_\diamond\le
\min\left\{2,\ 4a+2\sqrt\delta+
\sqrt{\frac{2\eta}{\kappa\delta(1-2\delta)}}\right\}.
\tag{17}
```

*Proof.* Put $`v_j=\Phi(\sigma_j)-\sigma_j`$ and
$`D_{\rm rec}=\max_j\|v_j\|_1`$. The action of $`\Phi^2-\Phi`$ on a
reference-assisted state is $`\sum_jv_j\otimes B_j`$, where the
conditional operators $`B_j`$ are positive and
$`\sum_j\operatorname{Tr}B_j=1`$. Thus $`\eta\le D_{\rm rec}`$. Choose a
maximizing label and an input whose probability of that label is at
least $`1-e`$. The reverse triangle inequality gives
``` math
(1-2e)D_{\rm rec}\le\eta\le D_{\rm rec}.
\tag{18}
```
Writing $`a_j=\operatorname{Tr}(E_j\sigma_j)`$, when $`a_j<1`$ the other
outcomes yield a state $`\omega_j`$ in the competing convex hull with
$`v_j=(1-a_j)(\omega_j-\sigma_j)`$. The case $`a_j=1`$ is immediate.
Hence
``` math
2\kappa(1-a_j)\le\|v_j\|_1,\qquad
1-\operatorname{Tr}(P_j\sigma_j)\le
q:=\frac{\eta}{2\kappa\delta(1-2e)},
\tag{19}
```
where the second inequality uses (10).

For a purification of $`\sigma_j`$, the triangle inequality and (4)
imply
``` math
\sqrt{1-\operatorname{Tr}(Q_j\sigma_j)}
\le\sqrt{1-\operatorname{Tr}(P_j\sigma_j)}+\|P_j-Q_j\|
\le\sqrt q+a.
```
If $`z_j=\operatorname{Tr}(Q_j\sigma_j)>0`$, set
$`\tau_j=Q_j\sigma_jQ_j/z_j`$. Projecting the purification gives a
normalized vector with overlap $`\sqrt{z_j}`$ with the original; the
pure-state trace distance formula and partial trace therefore give
``` math
\|\sigma_j-\tau_j\|_1\le2\sqrt{1-z_j}\le2\sqrt q+2a.
\tag{20}
```
This is the standard normalized gentle-projection estimate (Watrous
2018, Corollary 3.15 and Theorem 3.33). If $`z_j=0`$, the preceding
inequality forces $`\sqrt q+a\ge1`$; choose
$`\tau_j=Q_j/\operatorname{rank}Q_j`$, which satisfies (20).

Now $`\operatorname{Tr}(F_i\tau_j)=\delta_{ij}`$, so $`\Pi^2=\Pi`$.
Keeping the records $`\sigma_j`$ while changing $`E`$ to $`F`$ costs at
most $`B_{\rm move}`$, by common CPTP post-processing. Keeping $`F`$
while changing its records costs at most
$`\max_j\|\sigma_j-\tau_j\|_1`$, also for inputs with a reference.
Combining these facts proves (16). Theorem 1 and $`e\le\delta`$ give
(17). $`\square`$

For a concrete nontrivial regime, take $`0<\varepsilon<1/16`$ and
$`E_0=\operatorname{diag}(1-\varepsilon,\varepsilon)`$, $`E_1=I-E_0`$,
and the two computational-basis records. Then $`\alpha=\kappa=1`$,
$`e=\varepsilon`$, $`\eta=2\varepsilon(1-2\varepsilon)`$, and the
constructed channel is complete dephasing, at distance $`2\varepsilon`$.
Choosing $`\delta=\sqrt\varepsilon`$ in (16) with
$`B_{\rm move}=2\sqrt\delta`$ gives $`4\varepsilon^{1/4}`$, which is
below two for $`\varepsilon<1/16`$. The certificate is useful but can be
very conservative.

## 5. Relationship to existing constructions

Choose an eigenbasis within every full sector and write the concatenated
unit vectors as the columns of $`T`$. In these coordinates
$`D=\operatorname{diag}(\sqrt{\lambda_a})`$, with $`\lambda_a`$ the
selected effect eigenvalues. Eldar–Forney’s unweighted and weighted
least-squares formulas are exactly
``` math
U=T(T^*T)^{-1/2},\qquad
\widehat U=TD(DT^*TD)^{-1/2}
```
(Eldar and Forney 2001, Theorem 2 and Section V). The weighted formula
is also the square-root measurement for priors proportional to
$`\lambda_a`$. Grouping columns by sector recovers $`Q_j`$ and
$`\widehat Q_j`$, including higher-rank sectors. These formulas optimize
vector least-squares objectives; they do not assert optimal distance
from the original measurement channel. The extension $`RE_jR`$ and its
channel comparison must still be checked.

**Proposition 4 (weighted comparison).** Keep the hypotheses and
notation of Theorem 1, but let $`TD=\widehat U|TD|`$. Then, without
condition (7),
``` math
\begin{gathered}
\widehat F_j=\widehat UC_j\widehat U^*+RE_jR,\\
\|\mathcal M_E-\mathcal M_{\widehat F}\|_\diamond
\le2\sqrt{1-\alpha^2(1-\delta)}.
\end{gathered}
\tag{21}
```
*Proof.* The invertibility of $`D`$ gives
$`\operatorname{ran}(TD)=\operatorname{ran}T`$ and
$`|TD|\ge\alpha d_0I`$. Thus $`\widehat U`$ has the same range
projection $`S`$. Equations (12)–(14), with
$`\widehat V=J\widehat U^*+WR`$, give the isometry and effect
identities, while
``` math
W^*\widehat V=\widehat U|TD|\widehat U^*+R\ge\alpha d_0I.
```
The same reference-assisted overlap argument proves (21). $`\square`$

This is a reconstructed application of established polar alignment, not
a claim that a cited paper states (21) verbatim. Its connection to de la
Salle’s proof is explicit. On $`S\mathcal H`$, put $`A_j=SE_jS`$. The
$`P_j`$ commute with their $`A_j`$, have total rank
$`\dim S\mathcal H`$, and satisfy
``` math
\sum_jP_jA_j\ge(1-\delta)\alpha^2I_{S\mathcal H}.
```
They can therefore replace the state-selected projections in the finite
proof’s polar step. That column becomes $`x=(P_j\sqrt{A_j})_j=DT^*`$;
its adjoint is $`TD`$ (Salle 2022, Lemma 3.1 and Section 3). The
residual extension and overlap calculation above make the application
uniform. Broad existence of a nearby same-label repeatable measurement
consequently has a short derivation from this machinery. The weighted
construction generally differs from (3); (21) does not prove Theorem 1’s
estimates for that prescribed map.

KSW’s continuity theorem supplies the generic dilation-to-channel
comparison (Kretschmann et al. 2008, Proposition 3). In tracking the
sharper constant in (8), our proof uses pure-state trace distance
directly: overlap at least $`c`$ gives $`2\sqrt{1-c^2}`$; applying only
$`2\|W-V\|`$ would give $`2\sqrt{2(1-c)}`$. Both are established
estimates. Kotowski–Oszmaniec’s dimension-deficient Naimark construction
proves projective simulability for a different complement-noise
completion, without requiring unit eigenspaces or asserting the present
diamond estimate (Kotowski and Oszmaniec 2025, Theorem 6).

The exact record endpoint also has established structure. On the algebra
of active labels define $`\Delta(f)=\sum_jf_jF_j`$ and
$`\Upsilon(X)=(\operatorname{Tr}(\tau_jX))_j`$. They are UCP maps with
$`\Upsilon\Delta=I`$ and $`\Pi^*=\Delta\Upsilon`$, a commutative
instance of exact encoding/decoding structure (Kitaev 2025, Theorem
1.2). Kitaev’s Theorem 12.3 gives general approximate factors; it does
not directly supply this particular exact correction of the original
effects and records. The additional specification here is quantitative
and applies to a substantially narrower class.

The reduction of the unweighted estimate is complete: (12)–(14) identify
its dilation, the classical matrix bound supplies the overlap, and the
pure-state formula and scalar case split prove (6). The sector estimate
is principal-angle geometry. The record proof adds the reverse triangle
inequality, convex-hull separation, and normalized gentle projection.
Thus the bounds require no additional general lemma. The remaining
questions are whether this explicit specialization is already documented
and whether its quantitative control and limitations are useful. The
certified comparison below distinguishes the two targets, but does not
establish originality.

## 6. Counterexamples and limitations

### 6.1. Repeatable approximation differs from projective approximation

On $`\mathbb C^3`$, let
``` math
E_0(t)=\operatorname{diag}(1-t,t,1/2),\quad E_1(t)=I-E_0(t),
\qquad0<t<1/2.
```
For $`\delta=t`$, the sectors are the first two coordinate lines and
$`\alpha=1`$. The prescribed completion is
$`F_0=\operatorname{diag}(1,0,1/2)`$, $`F_1=I-F_0`$, with distance
$`2t`$. However, its input measurement has distance exactly one to the
nearest binary PVM. For any projection $`L`$, ordered-eigenvalue
perturbation gives $`\|E_0(t)-L\|\ge1/2`$, because the middle eigenvalue
of $`E_0(t)`$ is $`1/2`$ whereas that of $`L`$ is zero or one. Binary
measurement-channel distance is $`2\|E_0(t)-L\|`$; the upper bound one
is attained by $`L=\operatorname{diag}(1,0,0)`$. The binary norm
identity follows from the norm of the Hermitian functional
$`\rho\mapsto\operatorname{Tr}((E_0-L)\rho)`$; an extremal eigenvector
attains it, and reference systems do not increase it. Also
$`\|I-\sum_jE_j(t)^2\|=1/2`$.

Thus small $`\delta`$ and perfect packing do not imply global
near-projectivity. The example does not preclude the packed-subspace
reduction in Section 5.

### 6.2. A square-root threshold obstruction

**Proposition 5.** For every $`0<\delta<1/10`$, there is a three-outcome
POVM on $`\mathbb C^4`$ satisfying Theorem 1 with $`\alpha=1`$, such
that every repeatable POVM $`G`$ on the same space and with the same
three labels obeys
``` math
\|\mathcal M_E-\mathcal M_G\|_\diamond\ge
\frac{\sqrt\delta}{4\sqrt3}.
\tag{22}
```

*Proof.* In the basis $`e_1,\ldots,e_4`$, put $`t=\sqrt\delta/4`$ and
``` math
\begin{gathered}
E_1=
\begin{pmatrix}
1-\delta/2&0&0&0\\
0&\delta/2&0&t\\
0&0&0&0\\
0&t&0&1/4
\end{pmatrix},\\
E_2=\operatorname{diag}(\delta/2,1-\delta,\delta/2,1/2),
\quad E_3=I-E_1-E_2.
\end{gathered}
\tag{23}
```
The nontrivial low $`2\times2`$ blocks of $`E_1,E_3`$ have determinant
$`\delta/16>0`$ and trace $`1/4+\delta/2<3/10`$. The remaining entries
are nonnegative. Thus these are POVM effects, and their full near-unit
sectors are respectively $`\mathbb Ce_1,\mathbb Ce_2,\mathbb Ce_3`$;
hence $`\alpha=1`$.

Set $`\rho_0=\max_j\|E_j-G_j\|`$. If $`\rho_0\le1/4`$, then $`G_2\ne0`$,
since $`\|E_2\|=1-\delta>9/10`$. Repeatability supplies a unit vector
$`v`$ with $`G_2v=v`$, and positivity of the other effects gives
$`G_1v=0`$. Write $`v=a_2e_2+b_2`$, $`b_2\perp e_2`$. Since
$`I-E_2\ge I/2`$ on $`e_2^\perp`$,
``` math
\|(I-E_2)v\|\le\rho_0
\quad\Longrightarrow\quad
\|b_2\|\le2\rho_0,\quad |a_2|\ge\sqrt3/2.
```
Moreover, $`\|E_1v\|\le\rho_0`$, $`\|E_1\|\le1`$, and
$`\|E_1e_2\|\ge t`$. Therefore
``` math
|a_2|t\le\|a_2E_1e_2\|
\le\rho_0+\|b_2\|\le3\rho_0,
```
so $`\rho_0\ge t/(2\sqrt3)`$. For any two POVMs, a state maximizing one
effect difference gives
$`\|\mathcal M_E-\mathcal M_G\|_\diamond\ge2\rho_0`$: the other
probability differences sum to its negative. This proves (22). If
$`\rho_0>1/4`$, the same conclusion follows from distance greater than
$`1/2`$. $`\square`$

The proposition establishes the necessity of square-root threshold order
for this same-space, same-label target class. It does not establish
optimality of the constant two, the dependence on $`\alpha`$, or the
joint bound.

### 6.3. Neither completion uniformly dominates the other

**Proposition 6 (computer-assisted comparison).** On $`\mathbb C^4`$,
set
``` math
\begin{gathered}
E_1(t)=\frac1{40}\begin{pmatrix}
32&0&3&1\\0&2&2&2\\3&2&4&4\\1&2&4&8
\end{pmatrix},\qquad
E_2(t)=\frac1{40}\begin{pmatrix}
4&2&-2&t\\2&34&-3&-1\\-2&-3&2&-2\\t&-1&-2&12
\end{pmatrix},\\
E_3(t)=I-E_1(t)-E_2(t),\qquad 2\le t\le4,\qquad\delta=1/4.
\end{gathered}
\tag{24}
```
This family satisfies Theorem 1 throughout the interval, with sector
ranks $`(1,1,1)`$ and $`\alpha(t)>9/10`$. Let $`\nu_u(t)`$ and
$`\nu_w(t)`$ be the full diamond distances from the original measurement
to the unweighted and weighted completions, and put
$`g(t)=\nu_w(t)-\nu_u(t)`$. Exact certificates give
``` math
g(2)>5\times10^{-4},\qquad g(4)<-9\times10^{-5}.
\tag{25}
```
The distances are continuous, and at least one equality point satisfies
``` math
2.33690021<t_*<2.33690023,\qquad g(t_*)=0.
\tag{26}
```
Uniqueness and absence of other equality points are not asserted.

*Certificate argument.* The accompanying rational data verify positivity
at $`t=2,4`$, hence throughout the affine family. Designated diagonal
entries give lower bounds $`4/5,17/20,17/20`$ for the top eigenvalues;
the sums of the remaining eigenvalues are at most $`7/20,9/20,7/10`$,
respectively. These bounds isolate exactly one eigenvalue above $`3/4`$
in each effect. The uniform spectral-residual and polar certificate
proves $`\alpha(t)>9/10`$ on the entire interval, not merely on a finite
grid.

For each certified parameter and completion, the data specify rational
effects $`G_j`$, a rigorous bound $`\epsilon\ge\sum_j\|F_j-G_j\|`$, and
exact primal/dual feasible SDP witnesses with values $`L,U`$ for
$`\mathcal M_E-\mathcal M_G`$. Thus $`L-\epsilon\le\nu\le U+\epsilon`$,
including reference systems. These enclosures prove (25) and strict
opposite signs at the two endpoints in (26). Uniform spectral isolation
and synthesis injectivity imply continuity, so the intermediate value
theorem proves (26). The [certificate
supplement](https://github.com/christophergardner-star/RC-Discovery/blob/d706872d89503f5c6f9e59d8f91b518bec9991b1/research/COMPLETION_CROSSOVER_2026-11-01.md)
links the data, the analytic error bounds and uniform argument, and the
exact standard-library verifier. It is part of the computer-assisted
proof of this proposition. $`\square`$

The additive theorem bound stays below $`1+\sqrt{19}/5<2`$ along this
path. A stronger weighted upper envelope therefore does not imply a
smaller actual weighted distance. These comparisons do not prove either
completion optimal among all repeatable targets, sharpness of the upper
bounds, or literature priority of the examples.

### 6.4. Other limits

The strict accessibility condition in (18) is essential. For
$`E_0=E_1=I/2`$ and orthogonal pure records, $`e=1/2`$, $`\Phi`$ is
constant, $`\eta=0`$, but $`D_{\rm rec}=1`$. This example violates the
main theorem’s near-unit hypothesis; it concerns the accessibility
lemma’s endpoint.

The prescribed spectral selection is not globally continuous. Fix
$`\delta=1/5`$ and
``` math
E_0(\varepsilon)=\operatorname{diag}(1,4/5-\varepsilon,0,1/2),
\qquad E_1(\varepsilon)=I-E_0(\varepsilon).
```
At $`\varepsilon=0`$, $`F_0=\operatorname{diag}(1,1,0,1/2)`$. For
$`0<\varepsilon<1/10`$, $`F_0(\varepsilon)=E_0(\varepsilon)`$. All
examples satisfy the hypotheses with $`\alpha=1`$. Input measurement
distance $`2\varepsilon`$ tends to zero, while the completed measurement
distance tends to $`2/5`$. A perturbation-continuity claim therefore
requires additional threshold isolation.

Finally, (6) is informative only when $`a+\sqrt\delta<1`$. The record
certificate can become trivial for small $`\kappa`$ or unfavorable
$`\eta/\delta`$. No experimental estimation procedure for all these
parameters, nor practical advantage of the unweighted over the weighted
completion, is established here.

## 7. Sharpness and reference systems

### 7.1. Exact envelope for orthogonal sectors

**Theorem 7 (perfect packing).** Under Theorem 1 with $`\alpha=1`$,
``` math
\nu:=\|\mathcal M_E-\mathcal M_F\|_\diamond
\le B(\delta):=\frac{2\sqrt\delta}{2-\sqrt\delta}.
\tag{27}
```
For every $`0<\delta<1/2`$, equality is attained by a five-outcome POVM
on $`\mathbb C^6`$, using a system-only input. Thus (27) is the exact
worst-case envelope in this subclass, over arbitrary finite dimensions
and outcome counts.

*Proof.* The diagonal blocks of $`T^*T`$ are identities, so its trace is
$`\dim\mathcal K`$. Its least eigenvalue is one; hence $`T^*T=I`$. The
$`P_j`$ are orthogonal and $`Q_j=P_j`$. Write $`S=\sum_jP_j`$,
$`R=I-S`$, $`A_j=P_jE_jP_j`$, $`\Delta_j=P_j-A_j`$, and
$`\Delta=\sum_j\Delta_j`$. Spectral commutation gives
$`B_j:=E_j-A_j\ge0`$, with $`\sum_jB_j=L:=R+\Delta`$ and
$`0\le\Delta\le\delta S`$. Normalize the $`B_j`$ on the support of
$`L`$: $`N_j=L^{-1/2}B_jL^{-1/2}`$. Allocate the kernel projection to
any label to obtain a POVM $`N`$. Since $`B_j\le L`$, the factorization
$`B_j=\sqrt L N_j\sqrt L`$ is exact, including on the kernel. Therefore
``` math
\mathcal M_E-\mathcal M_F
=\mathcal M_N\bigl(\sqrt L\,\cdot\,\sqrt L-R\,\cdot\,R\bigr)
-\mathcal M_\Delta.
\tag{28}
```
Here $`\mathcal M_\Delta`$ is completely positive, though generally not
trace preserving.

For any unit vector $`\psi`$, including a reference system, put
$`p=\|(S\otimes I)\psi\|^2`$, $`q=1-p`$, and
$`r=\langle\psi,(\Delta\otimes I)\psi\rangle\le\delta p`$. The vectors
$`x=(\sqrt L\otimes I)\psi`$ and $`y=(R\otimes I)\psi`$ have squared
norms $`q+r,q`$ and overlap $`q`$. Their rank-two difference has trace
norm $`\sqrt{r^2+4rq}`$, by its trace $`r`$ and eigenvalue product
$`-rq`$. This standard projected-state calculation also appears
explicitly in (Regula et al. 2026, Appendix C). Contractivity and the
trace $`r`$ of the positive defect output give
``` math
\|[(\mathcal M_E-\mathcal M_F)\otimes\mathrm{id}](\psi\psi^*)\|_1
\le r+\sqrt{r^2+4rq}
\le\delta p+\sqrt{\delta^2p^2+4\delta p(1-p)}.
\tag{29}
```
Set $`b=\sqrt\delta`$, $`z=2-b`$, $`B=2b/z`$. Since $`B-b^2p>0`$, the
identity
``` math
(B-b^2p)^2-\bigl(b^4p^2+4b^2p(1-p)\bigr)
=4b^2(p-1/z)^2
```
proves (27), with equality in the scalar optimization at $`p=1/z`$.
Reference-assisted pure inputs suffice for the diamond norm.

For attainment, put $`h=\sqrt{1-b}`$, so $`z=1+h^2`$, and use basis
$`e_0,e_1,e_2,e_3,e_4,e_r`$. Let $`P_j=e_je_j^*`$. On
$`\operatorname{span}\{e_0,e_r\}`$, define
``` math
\begin{gathered}
L_+=\frac1z\begin{pmatrix}b^2&bh\\bh&h^2\end{pmatrix},\qquad
L_-=\frac1z\begin{pmatrix}b^2h^2&-bh\\-bh&1\end{pmatrix},\\
E_0=(1-b^2)P_0,\qquad
E_1=P_1+L_+/2,\quad E_2=P_2+L_+/2,\\
E_3=P_3+L_-/2,\quad E_4=P_4+L_-/2.
\end{gathered}
\tag{30}
```
The positive rank-one operators $`L_\pm`$ sum to $`b^2P_0+R\le I`$. Thus
the effects sum to $`I`$, and every low part has norm at most
$`1/2<1-\delta`$. Their full threshold sectors are exactly the $`P_j`$,
including the closed-threshold eigenvalue of $`E_0`$. For
$`\psi=(e_0+he_r)/\sqrt z`$, the five probability differences are
$`-b^2/z,b/(2z),b/(2z),-bh^2/(2z),-bh^2/(2z)`$. Their absolute sum is
$`2b/z`$, proving attainment. $`\square`$

Consequently $`B(\delta)=\sqrt\delta+\delta/2+O(\delta^{3/2})`$. The
optimal asymptotic coefficient is one; the best uniform coefficient of
$`\sqrt\delta`$ for $`0<\delta<1/2`$ is $`(8+2\sqrt2)/7`$, approached as
$`\delta\uparrow1/2`$. This is sharpness for the prescribed completion,
not for the best freely chosen repeatable target. If $`R=0`$, (29)
instead gives $`\nu\le2\delta`$. The [extended proof and exact attaining
certificates](https://github.com/christophergardner-star/RC-Discovery/blob/327986e318cbfeb8632f61dbd9bad2f0dc18b3c3/theory/perfect_packing_sharpness.md)
provide additional checks independent of numerical solver tolerances.

### 7.2. A reference can still improve discrimination

Define
$`\nu_{\rm sys}=\sup_\rho\sum_j|\operatorname{Tr}((E_j-F_j)\rho)|`$.
Theorem 7’s attaining family does not imply $`\nu=\nu_{\rm sys}`$ for
every measurement with $`\alpha=1`$. Reference-assisted measurement
discrimination is an established subject (Puchała et al. 2018); the
point here is its occurrence within this particular completion class.

**Proposition 8 (computer-assisted reference advantage).** There is a
rational eight-outcome POVM on $`\mathbb C^{10}`$, satisfying Theorem 1
with $`\alpha=1`$ and $`\delta=17/100`$, for which
``` math
\nu_{\rm sys}\le0.1161<0.1208\le\nu.
\tag{31}
```

*Certificate proof.* The [specified effects and certificate
supplement](https://github.com/christophergardner-star/RC-Discovery/blob/56f50f49db301a0f69eaed8ab5a650591a6a9aae/theory/reference_advantage.md)
form part of the statement and proof. With $`D_j=E_j-F_j`$,
$`\nu_{\rm sys}=\max_{s\in\{-1,1\}^8}\lambda_{\max}(\sum_js_jD_j)`$.
Exact positivity of all 256 matrices $`0.1161I-\sum_js_jD_j^T`$ gives
the upper bound. Rational Hermitian SDP witnesses satisfy
$`\operatorname{Tr}\rho=1`$, $`\rho\ge0`$, $`-\rho\le X_j\le\rho`$, and
$`\sum_j\operatorname{Tr}(D_j^TX_j)\ge0.1208`$, proving the lower bound
by standard diamond-norm duality (Watrous 2012). The verifier also
checks every full spectral sector and the exact prescribed target. The
advantage is at least $`0.0047`$; neither distance is asserted to be
exactly equal to the displayed endpoint. $`\square`$

### 7.3. Imperfect packing and failed extensions

**Proposition 9 (coupled simplex lower bound).** For every even
$`m\ge4`$ and $`0<\alpha\le1`$, an $`m`$-outcome POVM on
$`\mathbb C^{m+1}`$ satisfies Theorem 1 with the stated $`\alpha`$,
$`\delta=1/m`$, and
``` math
\nu\ge L_m(\alpha):=
\sqrt{\frac{(m-2)[m-(m-1)\alpha^2]}{m(m-2)+m-(m-1)\alpha^2}}.
\tag{32}
```
For fixed $`\alpha<1`$, this lower bound tends to $`\sqrt{1-\alpha^2}`$
as $`m\to\infty`$. If $`a_m^2=1-\alpha_m^2=O(1/m)`$, then
$`L_m(\alpha_m)/\sqrt{a_m^2+1/m}\to1`$.

*Construction argument.* The [analytic
supplement](https://github.com/christophergardner-star/RC-Discovery/blob/4bb04ff6e2a5f9250a81a0093cfbb1016cbbe82d/theory/imperfect_packing_lower_bound.md)
specifies the matrices and forms part of this proof. The synthesis is
$`cI+(\alpha-c)uu^*`$, with $`u=m^{-1/2}(1,\ldots,1)`$ and
$`c=\sqrt{(m-\alpha^2)/(m-1)}`$. Residual coupling vectors sum to zero
and are orthogonal to their respective selected eigenvectors. Their size
is fixed by a Schur complement, proving positivity. Each selected
eigenvalue is $`1-1/m`$; its positive complementary block has trace
$`2/m<1-1/m`$, so the full sectors are isolated. The positive synthesis
makes the polar sectors coordinate projections. Input $`(u+e_r)/\sqrt2`$
has output distance exactly $`L_m(\alpha)`$. The limits follow from
(32). $`\square`$

The exact joint finite-error envelope remains open. Two tempting
extensions of (27) are already false:
``` math
\nu\not\le 2(1-\alpha)+B(\delta)\quad\hbox{in general},\qquad
\nu\not\le\sqrt{1-\alpha^2+B(\delta)^2}\quad\hbox{in general}.
\tag{33}
```
For the first, (32) with $`m=64`$, $`\alpha=9/10`$ has squared lower
bound $`80414/398097>1/9`$, while the proposed upper bound is $`1/3`$.
For the second, a rational seven-dimensional variant has
$`\alpha=13/27`$, $`\delta=1/6`$, system-only distance at least
$`1.0405`$, and proposed bound at most $`1.0156`$. The same supplement
links its exact effects, rational input and sign witness, and verifier.
These are counterexamples to proposed extensions, not to Theorem 1.

## 8. Sharp joint small-error asymptotics

The residual argument of Theorem 7 extends to nonorthogonal sectors if
the selected-effect correction is estimated separately. This closes the
leading joint gap without asserting either of the false finite-error
extensions (33).

**Theorem 10 (joint leading envelope).** Under the hypotheses of Theorem
1, write
``` math
\begin{gathered}
a^2=1-\alpha^2,\quad s=a^2+\delta,\quad d=\sqrt{1-\delta},\\
\varepsilon=1-\alpha^2(1-\delta),\qquad
h=\max\{1-\alpha,d^{-1}-1\}+1-d.
\end{gathered}
\tag{34}
```
Then the prescribed unweighted completion satisfies, without condition
(7),
``` math
\nu\le\min\left\{2,\frac{2\sqrt\varepsilon}{\sqrt{4-\varepsilon}}+2h\right\}.
\tag{35}
```
Let $`\mathcal W(\alpha,\delta)`$ be the supremum of $`\nu`$ over all
finite POVMs satisfying Theorem 1 with synthesis minimum exactly
$`\alpha`$ and the specified threshold $`\delta`$. Dimension and outcome
count may vary. For $`0<\delta\le1/4`$ this class is nonempty for every
$`0<\alpha\le1`$, and
``` math
\boxed{\frac{\mathcal W(\alpha,\delta)}{\sqrt{1-\alpha^2+\delta}}
\longrightarrow1\quad\text{as }(\alpha,\delta)\longrightarrow(1,0),\quad\delta>0.}
\tag{36}
```
The limit is joint, with no fixed error ratio required. An explicit
consequence is
``` math
(1-2\delta)\sqrt{s}\le\mathcal W(\alpha,\delta)
\le\sqrt{s}+5s\qquad(s\le1/4).
\tag{37}
```
In particular, when $`1-\alpha^2=r\delta`$ for fixed $`r\ge0`$,
$`\mathcal W/\sqrt\delta\to\sqrt{1+r}`$. The coefficient five in (37) is
not asserted to be optimal.

*Proof.* Keep the sector operators $`T=UH,D,C_j`$ from Section 3.
Spectral commutation and $`[D,C_j]=0`$ give
``` math
A_j=P_jE_jP_j=UHDC_jDHU^*,\qquad B_j=E_j-A_j\ge0.
```
As $`A_j\le E_j`$, their sum is $`UHD^2HU^*\le I`$. Congruence of
$`D^2\ge d^2I`$, together with $`H\ge\alpha I`$, therefore yields
``` math
0\le\Delta_{\mathcal K}:=I-HD^2H\le\varepsilon I.
```
No commutation of $`H`$ and $`D`$ is assumed. Put
$`\Delta=U\Delta_{\mathcal K}U^*`$, so $`\sum_jB_j=L:=R+\Delta`$ and
$`\sqrt L=R+\sqrt\Delta`$. Normalize $`N_j=L^{-1/2}B_jL^{-1/2}`$ on the
support of $`L`$. Each $`B_j`$ kills its kernel, since
$`0\le B_j\le L`$; allocating that kernel projection to any label
extends the $`N_j`$ to a POVM. Let $`\mathcal N`$ be its CPTP
measurement map. Because $`A_jR=0`$, $`RB_jR=RE_jR`$, and the exact
decomposition is
``` math
\mathcal M_E-\mathcal M_F
=\mathcal N\bigl(\sqrt L\,\cdot\,\sqrt L-R\,\cdot\,R\bigr)
 +(\mathcal M_A-\mathcal M_Q).
\tag{38}
```
The maps $`\mathcal M_A,\mathcal M_Q`$ are CP but need not preserve
trace.

Take a unit input $`\psi`$ with an arbitrary reference, and set
$`p=\langle\psi,(S\otimes I)\psi\rangle`$, $`q=1-p`$, and
$`t=\langle\psi,(\Delta\otimes I)\psi\rangle\le\varepsilon p`$. For
$`x=(\sqrt L\otimes I)\psi`$, $`y=(R\otimes I)\psi`$, the squared norms
are $`t+q,q`$ and the overlap is $`q`$. Thus
$`\|xx^*-yy^*\|_1=\sqrt{t^2+4tq}`$, as in Theorem 7’s established
rank-two calculation (Regula et al. 2026, Appendix C). Contractivity of
$`\mathcal N\otimes\mathrm{id}`$ bounds the first term of (38).

For the second term put $`z=(U^*\otimes I)\psi`$ and
$`w=(DH\otimes I)z`$, so $`\|z\|^2=p`$. The map $`DH`$ is a contraction
because $`HD^2H\le I`$. The two selected outputs are obtained by the
same coordinate measurement of $`ww^*`$ and $`zz^*`$. Moreover,
``` math
\|DH-I\|\le\|D(H-I)\|+\|D-I\|
\le\max\{1-\alpha,d^{-1}-1\}+1-d=h.
```
The outer-product bound gives
$`\|ww^*-zz^*\|_1\le(\|w\|+\|z\|)\|w-z\|\le2hp`$. Consequently every
reference-assisted input obeys
``` math
\|[(\mathcal M_E-\mathcal M_F)\otimes\mathrm{id}](\psi\psi^*)\|_1
\le2hp+\sqrt{\varepsilon^2p^2+4\varepsilon p(1-p)}.
\tag{39}
```
For $`0<\varepsilon<1`$, the squared radical equals
``` math
\frac{4\varepsilon}{4-\varepsilon}
-\varepsilon(4-\varepsilon)\left(p-\frac2{4-\varepsilon}\right)^2.
```
Together with $`p\le1`$, this proves (35) by the pure-input
characterization of diamond distance. The selected correction is of
order $`s`$, not $`\sqrt s`$, and its estimate does not sum errors over
labels.

For the matching lower bound at an arbitrary $`0<\delta\le1/4`$, choose
$`m=2\lceil1/(2\delta)\rceil`$. In Proposition 9’s family take the
requested $`\alpha`$ and $`\delta'=1/m\le\delta`$. Its selected
eigenvalue $`1-\delta'`$ is at least $`1-\delta`$; every complementary
eigenvalue is at most $`2/m\le2\delta<1-\delta`$. Thus the full sectors,
synthesis minimum and completion are unchanged at the requested
threshold. The class defining $`\mathcal W`$ is nonempty, and (32) gives
``` math
\begin{aligned}
\mathcal W^2&\ge L_m^2
=\frac{m-2}{m-1+a^2}\left(a^2+\frac1{m-1}\right)\\
&\ge\frac{1-2\delta}{1+2\delta}\,(a^2+\delta).
\end{aligned}
\tag{40}
```
Indeed $`(m-2)/(m-1+a^2)\ge1-2\delta`$ and $`1/m\ge\delta/(1+2\delta)`$.
Meanwhile $`\varepsilon=s-a^2\delta`$, $`\varepsilon/s\to1`$, and
``` math
1-\alpha=\frac{a^2}{1+\alpha},\quad
d^{-1}-1=\frac{\delta}{d(1+d)},\quad
1-d=\frac{\delta}{1+d}
```
show uniformly that $`h=O(s)`$. Taking square roots in (40) and dividing
both bounds by $`\sqrt s`$ proves (36). For (37), when $`s\le1/4`$, use
$`h\le2s`$, $`(1-s/4)^{-1/2}\le1+s`$, and
$`\sqrt{(1-2\delta)/(1+2\delta)}\ge1-2\delta`$. $`\square`$

Theorem 10 determines a leading worst-case envelope, not a finite-error
formula for each POVM. Its lower examples use growing dimension and
label count. The exact general envelope, sharp subleading term, and
fixed-dimension optima remain open. Even at $`\alpha=1`$, (27) exceeds
$`\sqrt\delta`$ for every positive $`\delta`$; the remainder in (35)
cannot simply be omitted. The argument uses established tools and the
specified lower construction. Its completion-specific implication and
publication priority require external assessment. The [extended
derivation and operator
checks](https://github.com/christophergardner-star/RC-Discovery/blob/ccb4b5b22892a21de32c2a045102b85d640ea664/theory/joint_small_error_asymptotics.md)
provide supplementary detail; the upper proof and limit argument are
given here.

## 9. Reproducibility, methodology, and review status

The [RC-Discovery
repository](https://github.com/christophergardner-star/RC-Discovery)
contains the frozen statement, analytic source notes, numerical identity
checks, reference-assisted primal/dual SDPs, negative controls, and
recorded seeds and source hashes. Its theorem-level comparison was
checked on 104 weighted constructions and six primal/dual SDPs,
alongside exact rational examples. The analytic proofs of Theorem 1,
Corollary 3, and Propositions 4–5 do not rely on solver output.
Proposition 6 is computer-assisted: rational certificates and the stated
analytic error bounds establish the inequalities. Its combined audit
passes 139 independent integer-determinant positivity checks and 12
rejection controls. These checks do not prove uniqueness. Theorem 7 is
analytic and has seven additional exact attaining certificates.
Proposition 8’s audit checks 289 positive-definite matrices with 5,764
integer leading minors and 13 rejection controls. The rational veto
following Proposition 9 passes 42 integer leading-minor checks and ten
rejection controls. Its universal lower-bound family is established by
the linked analytic construction, not extrapolation from numerical
tests. A separate imperfect-packing search checked 56 structured cases,
711 accepted adaptive cases, and seven SDPs; these are numerical
evidence only. Theorem 10’s proof is analytic. Its separate numerical
audit checks 96 operator cases, 1,440 pure inputs with reference
dimensions 1, 2 and the system dimension, twenty structured witnesses,
and five full diamond SDPs. These checks probe the decomposition and
estimates; they do not prove the universal limit or replace its
arbitrary-reference argument. The Lean development checks 13 constituent
declarations, not the full spectral and channel theorem.

This work was developed using **VIBE MATH**, an AI-assisted workflow of
conjecture generation, derivation, adversarial checking, literature
comparison, and computational support directed by Christopher Gardner.
AI systems are research tools, not authors or endorsers. Agreement among
internal AI-assisted checks is not external verification.

The requested external assessment is concrete: check the supplied
reduction of Theorem 1 and Corollary 3 to established tools, reconstruct
the sharp subclass theorem, joint asymptotics, lower-bound family and
exact comparisons, and identify any earlier statement or application
that subsumes this quantitative specialization. The reduction requires
no new general lemma; publication priority and usefulness remain
unverified. Correctness, priority, optimality, and usefulness are
separate questions. This draft has not undergone independent specialist
review and is not represented as submission-ready.

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-debruijn1980" class="csl-entry">

Bruijn, N. G. de. 1980. “Remarks on Hermitian Matrices.” *Linear Algebra
and Its Applications* 32: 201–8.
<https://doi.org/10.1016/0024-3795(80)90017-8>.

</div>

<div id="ref-busch1995" class="csl-entry">

Busch, Paul, Marian Grabowski, and Pekka J. Lahti. 1995. “Repeatable
Measurements in Quantum Theory: Their Role and Feasibility.”
*Foundations of Physics* 25 (9): 1239–66.
<https://doi.org/10.1007/BF02055331>.

</div>

<div id="ref-eldar2001" class="csl-entry">

Eldar, Yonina C., and G. David Forney Jr. 2001. “On Quantum Detection
and the Square-Root Measurement.” *IEEE Transactions on Information
Theory* 47 (3): 858–72. <https://doi.org/10.1109/18.915636>.

</div>

<div id="ref-higham1986" class="csl-entry">

Higham, Nicholas J. 1986. “Computing the Polar Decomposition—with
Applications.” *SIAM Journal on Scientific and Statistical Computing* 7
(4): 1160–74. <https://doi.org/10.1137/0907079>.

</div>

<div id="ref-kitaev2025" class="csl-entry">

Kitaev, Alexei. 2025. *Almost-Idempotent Quantum Channels and
Approximate $`C^*`$-Algebras*. arXiv:2405.02434v2.
<https://doi.org/10.48550/arXiv.2405.02434>.

</div>

<div id="ref-kotowski2025" class="csl-entry">

Kotowski, Michał, and Michał Oszmaniec. 2025. *Pretty-Good Simulation of
All Quantum Measurements by Projective Measurements*.
arXiv:2501.09339v1. <https://doi.org/10.48550/arXiv.2501.09339>.

</div>

<div id="ref-ksw2008" class="csl-entry">

Kretschmann, Dennis, Dirk Schlingemann, and Reinhard F. Werner. 2008. “A
Continuity Theorem for Stinespring’s Dilation.” *Journal of Functional
Analysis* 255 (8): 1889–904.
<https://doi.org/10.1016/j.jfa.2008.07.023>.

</div>

<div id="ref-puchala2018" class="csl-entry">

Puchała, Zbigniew, Łukasz Pawela, Aleksandra Krawiec, and Ryszard
Kukulski. 2018. “Strategies for Optimal Single-Shot Discrimination of
Quantum Measurements.” *Physical Review A* 98: 042103.
<https://doi.org/10.1103/PhysRevA.98.042103>.

</div>

<div id="ref-regula2026" class="csl-entry">

Regula, Bartosz, Ludovico Lami, and Nilanjana Datta. 2026. *Tight
Relations and Equivalences between Smooth Relative Entropies*.
arXiv:2501.12447v5. <https://arxiv.org/abs/2501.12447v5>.

</div>

<div id="ref-delasalle2022" class="csl-entry">

Salle, Mikael de la. 2022. “Orthogonalization of Positive Operator
Valued Measures.” *Comptes Rendus. Mathématique* 360: 549–60.
<https://doi.org/10.5802/crmath.326>.

</div>

<div id="ref-watrous2012" class="csl-entry">

Watrous, John. 2012. *Simpler Semidefinite Programs for Completely
Bounded Norms*. arXiv:1207.5726v2. <https://arxiv.org/abs/1207.5726v2>.

</div>

<div id="ref-watrous2018" class="csl-entry">

Watrous, John. 2018. *The Theory of Quantum Information*. Cambridge
University Press. <https://doi.org/10.1017/9781316848142>.

</div>

</div>
