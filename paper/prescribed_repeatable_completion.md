# Stability of a prescribed repeatable completion of a quantum measurement

**Author:** Christopher Gardner  
**Date:** 31 October 2026

<!-- Generated from arxiv_ready.md; edit that source and rebuild. -->

**External-review draft.** The argument below is intended to be
reconstructed independently. Its ingredients are established; the extent
to which the prescribed-map estimate and record corollary follow from
earlier results remains a question for review.

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
The proof gives an explicit labelled dilation and a residual spectral
gap. A corollary corrects separated output records to an exactly
idempotent channel. We identify the classical Jordan-product inequality
used in the proof and derive a weighted alternative from established
polar machinery. Explicit examples distinguish the target from
projective approximation, establish a square-root threshold obstruction,
and limit continuity of the prescribed selection. We make no claim of
optimal constants or literature priority.

## 1. Question and scope

A finite POVM can admit a repeatable instrument without being a
projection-valued measurement (PVM). The relevant criterion is that
every nonzero effect have eigenvalue one (Busch et al. 1995). Such
measurements have orthogonal unit eigenspaces and may retain an
arbitrary POVM on their common orthogonal complement. We study a
particular way to select a nearby measurement in this class while
retaining the input space, labels, and compressed residual effects.

The construction uses the polar factor of a synthesis operator, a
standard orthogonalization device (Higham 1986). The issue addressed
here is quantitative control of the resulting prescribed measurement in
the full diamond norm. The hypothesis concerns near-unit sectors and
their simultaneous linear independence; it is not a global
almost-projectivity assumption.

The distinction from earlier work is limited. De la Salle’s
orthogonalization proof already contains a closely related weighted
polar construction (Salle 2022). Dilation continuity is standard
(Kretschmann et al. 2008), and the noncommuting matrix inequality used
below is a special case of the Strang–de Bruijn Jordan-product bounds
(Bruijn 1980). Section 5 makes these relationships explicit. The paper
presents a specialization with a complete argument, not a claim of a new
general rounding principle.

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
comparison (Kretschmann et al. 2008, Proposition 3).
Kotowski–Oszmaniec’s dimension-deficient Naimark construction proves
projective simulability for a different complement-noise completion,
without requiring unit eigenspaces or asserting the present diamond
estimate (Kotowski and Oszmaniec 2025, Theorem 6).

The exact record endpoint also has established structure. On the algebra
of active labels define $`\Delta(f)=\sum_jf_jF_j`$ and
$`\Upsilon(X)=(\operatorname{Tr}(\tau_jX))_j`$. They are UCP maps with
$`\Upsilon\Delta=I`$ and $`\Pi^*=\Delta\Upsilon`$, a commutative
instance of exact encoding/decoding structure (Kitaev 2025, Theorem
1.2). Kitaev’s Theorem 12.3 gives general approximate factors; it does
not directly supply this particular exact correction of the original
effects and records. The additional specification here is quantitative
and applies to a substantially narrower class.

These comparisons leave the prescribed-map estimate and record
correction as the appropriate subjects for an external implication and
priority review. They do not establish that either specialization is
new.

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

### 6.3. Other limits

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

## 7. Reproducibility, methodology, and review status

The [RC-Discovery
repository](https://github.com/christophergardner-star/RC-Discovery)
contains the frozen statement, analytic source notes, numerical identity
checks, reference-assisted primal/dual SDPs, negative controls, and
recorded seeds and source hashes. Its theorem-level comparison was
checked on 104 weighted constructions and six primal/dual SDPs,
alongside exact rational examples. These computations support finite
instances; the proofs above do not rely on solver output. The Lean
development checks 13 constituent declarations, not the full spectral
and channel theorem.

This work was developed using **VIBE MATH**, an AI-assisted workflow of
conjecture generation, derivation, adversarial checking, literature
comparison, and computational support directed by Christopher Gardner.
AI systems are research tools, not authors or endorsers. Agreement among
internal AI-assisted checks is not external verification.

The requested external assessment is concrete: reconstruct Theorem 1 and
Corollary 3 from their stated hypotheses, check the scope of the
counterexamples, and determine whether the prescribed-map estimate and
record correction are already stated or follow as short corollaries of
existing results. Correctness, priority, optimality, and usefulness are
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

<div id="ref-delasalle2022" class="csl-entry">

Salle, Mikael de la. 2022. “Orthogonalization of Positive Operator
Valued Measures.” *Comptes Rendus. Mathématique* 360: 549–60.
<https://doi.org/10.5802/crmath.326>.

</div>

<div id="ref-watrous2018" class="csl-entry">

Watrous, John. 2018. *The Theory of Quantum Information*. Cambridge
University Press. <https://doi.org/10.1017/9781316848142>.

</div>

</div>
