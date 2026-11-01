# Sharp prescribed-completion bound at perfect packing

1 November 2026. Internally derived with exact finite SDP certificates and
numerical checks. The exact operator upper bound, attaining POVM, actual
worst-case supremum and perfect-packing second-order limit are now
[Lean checked](../research/LEAN_PERFECT_SHARPNESS_2026-11-01.md).
External review and publication novelty remain unresolved.

## Statement

Assume the [frozen theorem](THEOREM_V1_FREEZE.md), with \(0<\delta<1/2\),
and additionally \(\alpha=1\). All norms below are unhalved. For the prescribed
completion \(F_j=Q_j+RE_jR\),

\[
\boxed{\|\mathcal M_E-\mathcal M_F\|_\diamond
\le B(\delta):=\frac{2\sqrt\delta}{2-\sqrt\delta}.} \tag{1}
\]

For every allowed \(\delta\), equality is attained by a five-outcome POVM
on \(\mathbb C^6\) with full sector ranks \((1,1,1,1,1)\). The attaining
input needs no reference system. Consequently (1) is the exact worst-case
envelope over all finite dimensions and outcome counts in this subclass.

In particular,

\[
B(\delta)=\sqrt\delta+\tfrac12\delta+O(\delta^{3/2}),\qquad
\lim_{\delta\downarrow0}\sup_E
\frac{\|\mathcal M_E-\mathcal M_F\|_\diamond}{\sqrt\delta}=1. \tag{2}
\]

The best single coefficient valid throughout \(0<\delta<1/2\) is
\[
C_* =\sup_{0<\delta<1/2}\frac{B(\delta)}{\sqrt\delta}
=\frac{2}{2-1/\sqrt2}=\frac{8+2\sqrt2}{7}. \tag{3}
\]
This supremum is approached as \(\delta\uparrow1/2\); it is not an
attainment assertion at the excluded endpoint. The result improves the
frozen bound in the subclass \(\alpha=1\). It does not determine the sharp
bound for \(\alpha<1\), or the distance to the best freely chosen repeatable
measurement.

## 1. Perfect packing and decomposition of the measurement

Let \(k=\dim\mathcal K\). Every diagonal sector block of \(T^*T\) is the
identity, so \(\operatorname{Tr}T^*T=k\). Since its least eigenvalue is one,
all eigenvalues are one. Thus \(T^*T=I\), the original \(P_j\) are mutually
orthogonal, \(U=T\), and \(Q_j=P_j\). Conversely, orthogonal sectors give
\(\alpha=1\). Let \(D\) be the block-diagonal operator on \(\mathcal K\)
whose block on \(\operatorname{ran}P_j\) is
\((P_jE_jP_j|_{\operatorname{ran}P_j})^{1/2}\). Since \(D>0\) and \(T\)
is an isometry, \(TD\) has polar factor \(T\). The weighted completion
therefore also equals the prescribed one.

Set \(S=\sum_jP_j\), \(R=I-S\), and define
\[
A_j=P_jE_jP_j,\qquad \Delta_j=P_j-A_j,\qquad
\Delta=\sum_j\Delta_j,\qquad B_j=E_j-A_j. \tag{4}
\]
Spectral commutation makes \(B_j\ge0\). The near-unit threshold gives
\(0\le\Delta_j\le\delta P_j\), hence
\[
0\le\Delta\le\delta S,\qquad
\sum_j B_j=R+\Delta=:L,\qquad
E_j-F_j=B_j-RB_jR-\Delta_j. \tag{5}
\]
This uses orthogonality exactly; no estimate for approximately orthogonal
sectors is being substituted.

On the support of \(L\), put \(N_j=L^{-1/2}B_jL^{-1/2}\), with inverses
restricted to that support. Because \(0\le B_j\le L\), every \(B_j\)
annihilates \(\ker L\). Thus \(B_j=\sqrt L N_j\sqrt L\), and the \(N_j\)
sum to the support projection. Allocate the kernel projection to any label
to extend them to a POVM on \(\mathcal H\). This defines a CPTP measurement
map \(\mathcal N\). Since \(\sqrt L=R+\sqrt\Delta\), equation (5) gives
the exact map identity
\[
\mathcal M_E-\mathcal M_F
=\mathcal N\bigl(\sqrt L\,\cdot\,\sqrt L-R\,\cdot\,R\bigr)
-\mathcal M_\Delta. \tag{6}
\]
Here \(\mathcal M_\Delta(X)=\sum_j\operatorname{Tr}(\Delta_jX)|j\rangle\langle j|\)
is completely positive but need not be trace preserving.

## 2. Universal upper bound, including arbitrary reference systems

Take a unit vector \(\psi\in\mathcal H\otimes\mathcal A\), with arbitrary
reference space \(\mathcal A\). Write
\[
p=\|(S\otimes I)\psi\|^2,\quad q=1-p,
\quad r=\langle\psi,(\Delta\otimes I)\psi\rangle\le\delta p.
\]
The positive output of \(\mathcal M_\Delta\otimes\mathrm{id}\) has trace
and trace norm \(r\). Put
\(x=(\sqrt L\otimes I)\psi\), \(y=(R\otimes I)\psi\).
Their squared norms are \(r+q,q\), and \(\langle x,y\rangle=q\).
The two possible nonzero eigenvalues of \(xx^*-yy^*\) have sum \(r\)
and product \(-rq\); therefore
\[
\|xx^*-yy^*\|_1=\sqrt{r^2+4rq}. \tag{7}
\]
This also holds when \(r=0\) or \(q=0\).

CPTP trace-norm contractivity for Hermitian inputs, the triangle inequality,
and (6) imply
\[
\|[(\mathcal M_E-\mathcal M_F)\otimes\mathrm{id}](\psi\psi^*)\|_1
\le r+\sqrt{r^2+4r(1-p)}
\le\delta p+\sqrt{\delta^2p^2+4\delta p(1-p)}. \tag{8}
\]
The last expression is maximized exactly. Set \(b=\sqrt\delta\),
\(z=2-b\), \(B=2b/z\). For \(0\le p\le1\), \(B-b^2p>0\), and
\[
(B-b^2p)^2-\bigl(b^4p^2+4b^2p(1-p)\bigr)
=4b^2\left(p-\frac1z\right)^2\ge0. \tag{9}
\]
Thus (8) is at most \(B\), with equality in this scalar optimization at
\(p=1/z\), where the square root in (8) is \(b\). The reference-assisted
pure-input characterization of the diamond norm proves (1). No assumption
that ancillas are unnecessary for arbitrary POVMs was used.

If \(R=0\), then \(q=0\) and the same proof gives the stronger linear
bound \(\nu\le2\delta\). The square-root extremizers below use coherence
between a sector and the residual space.

## 3. A family attaining the envelope for every allowed threshold

Fix \(0<b<1/\sqrt2\), set \(\delta=b^2\), \(h=\sqrt{1-b}\), and
\(z=2-b=1+h^2\). Use the orthonormal basis
\(e_0,e_1,e_2,e_3,e_4,e_r\) of \(\mathbb C^6\), and write
\(P_j=|e_j\rangle\langle e_j|\), \(R=|e_r\rangle\langle e_r|\).
On \(\operatorname{span}\{e_0,e_r\}\), define
\[
L_+=\frac1z\begin{pmatrix}b^2&bh\\bh&h^2\end{pmatrix},\qquad
L_-=\frac1z\begin{pmatrix}b^2h^2&-bh\\-bh&1\end{pmatrix}. \tag{10}
\]
Extend these operators by zero on the other four coordinates, and put
\[
\begin{aligned}
E_0&=(1-b^2)P_0,\\
E_1&=P_1+L_+/2,& E_2&=P_2+L_+/2,\\
E_3&=P_3+L_-/2,& E_4&=P_4+L_-/2.
\end{aligned} \tag{11}
\]
Both \(L_\pm\) are positive rank-one operators and
\(L_++L_-=b^2P_0+R\). Consequently (11) is a POVM.
Moreover \(L_\pm\le b^2P_0+R\le I\), so the low parts of
\(E_1,\ldots,E_4\) have norm at most \(1/2<1-\delta\).
The *full* closed-threshold sectors are exactly the five \(P_j\), including
\(P_0\) at eigenvalue \(1-\delta\). Thus \(\alpha=1\) and all frozen
hypotheses hold for every allowed \(\delta\).

The completion is \(F_j=P_j+RE_jR\). For the system-only pure input
\[
\psi=\frac{e_0+h e_r}{\sqrt z}, \tag{12}
\]
the five outcome probability differences \(E-F\) are exactly
\[
-\frac{b^2}{z},\quad \frac{b}{2z},\quad \frac{b}{2z},\quad
-\frac{bh^2}{2z},\quad-\frac{bh^2}{2z}. \tag{13}
\]
Their absolute values sum to
\(b^2/z+b(1+h^2)/z=b+b^2/z=2b/z\). This matches (1), proving
the exact optimal envelope, not just its order or a lower bound on it.

For \(\delta<1/4\) a smaller version uses \(\mathbb C^4\), three labels,
and unsplit effects \((1-b^2)P_0,P_1+L_+,P_2+L_-\). The larger low
eigenvalue is \((1+b^2-b^3)/z\). Its distance below the threshold is
\((1-2b)(1+b-b^2)/z>0\). The same input attains the bound. Splitting into
four half-effects in (11) ensures the full-sector condition for the entire
interval \(0<\delta<1/2\).

## 4. Explicit primal and dual diamond-norm witnesses

There is also a direct SDP certificate, independent of applying the universal
bound to the example. Let \(D_j=E_j-F_j\), \(\rho=\psi\psi^*\),
\(Q=P_0+R-\rho\), and \(p=1/z,q=h^2/z\). Define
\[
X_0=-\rho,\quad X_1=X_2=\rho,\quad X_3=X_4=-\rho,
\]
\[
Y_0=-D_0,\quad Y_1=D_1+bqQ,\quad Y_2=D_2+bqQ,
\quad Y_3=-D_3+bpQ,\quad Y_4=-D_4+bpQ. \tag{14}
\]
These real symmetric matrices are feasible in the complex Hermitian SDP:
\(\rho\ge0\), \(\operatorname{Tr}\rho=1\), \(-\rho\le X_j\le\rho\),
\(Y_j\ge\pm D_j\), and \(\sum_jY_j\le BI\).

For an explicit check on the active two-dimensional block, use the basis
\((\psi,(-h e_0+e_r)/\sqrt z)\). In that basis
\[
2D_1=2D_2=\begin{pmatrix}bp&0\\0&-bq\end{pmatrix},\qquad
2D_3=2D_4=\begin{pmatrix}-bq&-b^2\sqrt{pq}\\-b^2\sqrt{pq}&b(1+b)q\end{pmatrix}.
\]
For the plus labels, \(Y_j-D_j=bqQ\) and \(Y_j+D_j=bp\rho\).
For the minus labels, \(Y_j+D_j=bpQ\), while \(Y_j-D_j\) has diagonal
entries \(bq,b^3p\) and off-diagonal entries \(b^2\sqrt{pq}\): it is
positive with determinant zero. The label-zero inequalities are immediate.
Finally \(\sum_jY_j=B(P_0+R)\le BI\) and
\(\sum_j\operatorname{Tr}(D_jX_j)=B\). Weak duality pins the diamond norm
to the same exact value. All other coordinates contribute zero effect
differences; the dual slack there is \(BI\).

Choosing rational \(h\) makes \(b=1-h^2\), \(\delta\), every effect,
\(\rho,X_j,Y_j\), and \(B\) rational. The retained seven instances include
\(h=11/20\) through \(h=9999/10000\). They can be checked with exact
integer and Fraction arithmetic, without a solver or tolerance:

```powershell
python -I -S experiments/verify_perfect_packing_sharpness.py
python -I -S experiments/check_perfect_packing_sharpness.py
```

The universal argument in Sections 1–3 is written mathematics, not a finite
test or a complete Lean proof. The numerical search and rational checks are
additional support and independent ways to check the extremizing examples.

## Attribution and scope

The spectral decomposition, congruence normalization of positive effects,
trace-norm contractivity, rank-two trace-distance calculation, and SDP duality
are standard tools. The reference-assisted characterization is in
[Watrous, Theorem 3.51](https://cs.uwaterloo.ca/~watrous/TQI/TQI.pdf); SDP
formulations are also developed in
[Watrous, *Simpler semidefinite programs for completely bounded norms*](https://arxiv.org/abs/1207.5726).
This proof does not introduce a new general gentle-measurement lemma.
The same rank-two projected-state calculation is explicit in
[Regula, Lami and Datta, Appendix C](https://arxiv.org/html/2501.12447v5).
The scope note below gives the substitution recovering (7).

The contribution established internally is the exact envelope for the
specified residual completion at \(\alpha=1\), with a family attaining it.
The [prior-art scope note](../literature/PERFECT_PACKING_SHARPNESS_ATTRIBUTION_2026-11-01.md)
records the literature checks and their limits. No priority finding or
external specialist endorsement follows from this derivation.
