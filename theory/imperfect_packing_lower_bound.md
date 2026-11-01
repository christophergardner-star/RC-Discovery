# Imperfect packing: a coupled simplex lower bound and two failed extensions

1 November 2026. Internally derived mathematics and exact finite checks;
external review and literature novelty remain open. The frozen theorem is
unchanged. None of the proposed stronger upper bounds below is asserted as
a theorem.

## 1. A family detecting both errors

For every even \(m\ge4\) and \(0<\alpha\le1\), there is a POVM on
\(\mathbb C^{m+1}\), with \(m\) full rank-one sectors and
\(\delta=1/m\), whose synthesis has least singular value exactly
\(\alpha\). Its prescribed completion obeys
\[
\nu\ge L_m(\alpha):=
\sqrt{\frac{(m-2)[m-(m-1)\alpha^2]}
{m(m-2)+m-(m-1)\alpha^2}}.
\tag{1}
\]
The lower bound uses a system-only input. It is not generally the full
diamond distance of this family, nor the optimum over all admissible POVMs.

Put \(a=\sqrt{1-\alpha^2}\). For fixed \(0<\alpha<1\),
\[
\lim_{m\to\infty,\ m\text{ even}} L_m(\alpha)=a,
\qquad \delta=1/m\longrightarrow0.
\tag{2}
\]
Thus no bound depending only on \(\delta\) and tending to zero can hold
uniformly over the frozen theorem's injective synthesis maps.
Furthermore, along any sequence \(a_m^2=O(1/m)\),
\[
\frac{L_m(\alpha_m)}{\sqrt{a_m^2+1/m}}\longrightarrow1.
\tag{3}
\]
Together with the known upper bounds, this identifies a necessary joint
small-error scale. It does **not** prove a sharp joint upper envelope.

## 2. Construction

Work first on \(\mathbb C^m\) with coordinate vectors \(e_j\). Set
\[
u=m^{-1/2}\sum_je_j,\quad
w_j=\frac{e_j-u/\sqrt m}{\sqrt{1-1/m}},\quad
c=\sqrt{\frac{m-\alpha^2}{m-1}},\quad K=\alpha+c(m-2).
\]
Take signs \(\sigma_j\) equal to \(+1\) on half the labels and \(-1\)
on the rest, and let \(w=m^{-1/2}\sum_j\sigma_je_j\). Define
\[
\begin{split}
v_j&=\frac{\alpha}{\sqrt m}u+\sqrt{1-\alpha^2/m}\,w_j,
&z_j&=\sqrt{1-\alpha^2/m}\,u-\frac{\alpha}{\sqrt m}w_j,\\
\lambda&=1-\frac1m,
&\mu&=\frac{m-(m-1)\alpha^2}{m(m-\alpha^2)},
\qquad \beta=\frac{\alpha^2}{m(m-\alpha^2)},\\
G_j&=\lambda v_jv_j^*+\mu z_jz_j^*
+\beta(I-uu^*-w_jw_j^*).
\end{split}
\tag{4}
\]
The \(v_j,z_j\) are orthonormal within their plane, and
\(\lambda,\mu,\beta>0\). Using
\(\sum_jw_j=0\) and
\(\sum_jw_jw_j^*=m(I-uu^*)/(m-1)\), direct substitution gives
\(\sum_jG_j=I\), \(\operatorname{Tr}G_j=1\), and
\(u^*G_ju=1/m\). This is a variation of the repository's existing lifted
simplex construction; no new frame construction is claimed.

The residual coupling directions are
\[
g_j=\sigma_ju-\frac{\alpha\sqrt m}{K}\sigma_je_j
+\frac{\alpha}{K}w.
\tag{5}
\]
They satisfy \(g_j\perp v_j\), \(\sum_jg_j=0\), and
\(u^*g_j=\sigma_jc(m-2)/K\). Their squared components along \(z_j\)
and its orthogonal complement inside \(v_j^\perp\) are respectively
\[
\frac{m(m-2)^2}{(m-1)K^2},\qquad
\frac{\alpha^2(m-2)}{(m-1)K^2}.
\]
Consequently the number
\[
C:=g_j^*(G_j|_{v_j^\perp})^{-1}g_j
=\frac{m(m-2)^2/\mu+\alpha^2(m-2)/\beta}{(m-1)K^2}
\tag{6}
\]
is positive and independent of \(j\).

Adjoin a residual unit vector \(e_r\), and define
\[
E_j=\begin{pmatrix}G_j&g_j/\sqrt{mC}\\
g_j^*/\sqrt{mC}&1/m\end{pmatrix}.
\tag{7}
\]
The Schur complement on \(v_j^\perp\oplus\mathbb Ce_r\) is zero,
so \(E_j\ge0\). The zero-sum couplings and \(\sum_jG_j=I\) prove
\(\sum_jE_j=I\).

## 3. Full sectors, prescribed target, and witness

The eigenvector \(v_j\) has eigenvalue \(\lambda=1-\delta\), because
the coupling is orthogonal to it. The positive complementary block has
trace \(2/m\). Since \(2/m<1-1/m\) for \(m\ge4\), every other
eigenvalue is strictly below the threshold. Thus the full closed-threshold
sector is precisely \(P_j=v_jv_j^*\).

The synthesis matrix on \(\mathbb C^m\) is
\[
T=cI+(\alpha-c)uu^*.
\]
Its eigenvalues are \(\alpha\) on \(u\) and \(c\ge1\) on \(u^\perp\).
It is positive definite, with polar factor the inclusion into
\(\mathbb C^{m+1}\). Therefore
\[
Q_j=e_je_j^*,\quad R=e_re_r^*,\quad
F_j=e_je_j^*+\frac1m e_re_r^*.
\tag{8}
\]
All hypotheses of the frozen theorem hold, including injectivity for every
fixed positive \(\alpha\). The weighted construction coincides here,
because all selected eigenvalues equal \(\lambda\).

For \(\psi=(u+e_r)/\sqrt2\), the two diagonal contributions to
\(\langle\psi,(E_j-F_j)\psi\rangle\) cancel. The remaining difference is
\(\sigma_jc(m-2)/(K\sqrt{mC})\). Its absolute sum is
\[
\frac{\sqrt m\,c(m-2)}{K\sqrt C}.
\]
Squaring and substituting (4)--(6) gives exactly (1). Equation (2) follows
by dividing numerator and denominator of (1) by \(m^2\). To check (3),
write
\[
L_m^2=\frac{(m-2)[1+(m-1)a_m^2]}{(m-1)(m-1+a_m^2)}
\]
and divide by \(a_m^2+1/m\). The ratio tends to one when
\(a_m^2=O(1/m)\), including \(a_m=0\).

## 4. Two tempting upper bounds are false

Let \(B(\delta)=2\sqrt\delta/(2-\sqrt\delta)\), the sharp perfect-packing
envelope. A linear replacement for the packing contribution would be
\[
\nu\stackrel{?}{\le}2(1-\alpha)+B(\delta).
\tag{9}
\]
For (7), take \(m=64\), \(\alpha=9/10\), and \(\delta=1/64\).
The right side of (9) is exactly \(1/3\), while
\[
\nu^2\ge L_{64}(9/10)^2=\frac{80414}{398097}>\frac19.
\]
This is an analytic counterexample inside the theorem's hypotheses.

The Euclidean combination is also false:
\[
\nu\stackrel{?}{\le}\sqrt{1-\alpha^2+B(\delta)^2}.
\tag{10}
\]
A rational seven-dimensional, six-outcome variant has
\(\alpha=13/27\), \(c=29/27\), and \(\delta=1/6\).
Its couplings are decreased slightly from the Schur-complement boundary
to make all matrices rational. The retained
[certificate](../research/imperfect_packing_2026-11-01/veto_certificate.json)
and [exact verifier](../experiments/verify_imperfect_packing.py) prove
\[
\nu\ge\nu_{\rm sys}\ge\frac{2081}{2000}=1.0405,
\qquad
\sqrt{1-\alpha^2+B(\delta)^2}\le\frac{2539}{2500}=1.0156.
\tag{11}
\]
Here the verifier constructs the exact effects from rational parameters,
checks positivity, normalization, the selected eigenvectors and full-sector
trace gap, and the positive synthesis formula. The system witness is a
rational vector normalized by its exact squared norm, together with six
signs. Its signed expectation is a lower bound on the output trace norm.
An upper rational enclosure of \(\sqrt\delta\), followed by squaring,
certifies the right side of (11). No SDP or approximate eigenvalue is used
in accepting this counterexample.

Neither counterexample contradicts the frozen bound. The actual sharp
joint upper envelope remains open; in particular, numerical survival of
any other proposed formula would not prove it.

## 5. Verification and scope

The [numerical search](../research/imperfect_packing_2026-11-01/search.json)
checks 56 structured cases, 711 accepted random/adaptive cases, and seven
full SDPs. It found the Euclidean violation before the rational certificate
was built. The exact lower-bound proof is independent of those finite tests.
Both counterexamples can be checked using only the standard library:

```powershell
python -I -S experiments/verify_imperfect_packing.py
python -I -S experiments/check_imperfect_packing.py
```

The coupled construction uses standard simplex symmetry, a Schur complement,
and an explicit distinguishing input. Its publication priority has not been
determined. These results establish lower bounds and vetoes, not a new
universal upper theorem or a complete Lean formalization.
