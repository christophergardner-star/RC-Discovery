# Exact certificates comparing the two prescribed completions

1 November 2026. This note supplies the analytic bridge for the exact rational
checker. It is a computer-assisted finite comparison, not an optimality or
literature-priority claim and not a complete Lean formalization.

## Statement and exact definition of the examples

There are two three-outcome POVMs on complex dimension six satisfying the
frozen theorem's full-sector and injectivity hypotheses, with informative
measurement bounds, for which the unweighted and weighted completions have
opposite strict distance orderings.

Write \(F^u_j=UC_jU^*+RE_jR\), where \(U=\operatorname{polar}(T)\), and
\(F^w_j=\widehat U C_j\widehat U^*+RE_jR\), where
\(\widehat U=\operatorname{polar}(TD)\).
Here \(T\) is the synthesis of the full sectors at or above \(1-\delta\),
\(D\) restricts the positive square roots of the effects to those sectors,
and \(R=I-UU^*\). All distances below are unhalved diamond distances.

The examples are defined by
[certificates.json](../research/exact_comparison_2026-11-01/certificates.json).
For each case, the first two effects are exactly the encoded matrices
\((A+iB)/q\), with integer arrays A and B and positive integer denominator q.
The third effect is exactly \(I-E_1-E_2\). These are newly defined rational
measurements inspired by the earlier numerical cases; they are not an
assertion that floating-point inputs were exact.

The exact checker proves these outward distance enclosures:

| Example | Threshold error | \(\|\mathcal M_E-\mathcal M_{F^u}\|_\diamond\) | \(\|\mathcal M_E-\mathcal M_{F^w}\|_\diamond\) |
| --- | --- | --- | --- |
| A, identifier 1676 | \(373/1000\) | \([0.749960051,\ 0.749961254]\) | \([0.750939416,\ 0.750940620]\) |
| B, identifier 2003 | \(123/500\) | \([0.518692284,\ 0.518693420]\) | \([0.518401816,\ 0.518402952]\) |

Both have sector ranks \((2,2,1)\). Thus the unweighted completion is strictly
closer in A and the weighted completion is strictly closer in B. Neither
construction universally minimizes movement relative to the other, even in
the informative region of the frozen theorem. This says nothing about
whether either is the nearest repeatable measurement among all possibilities.

The remainder explains every bound used to pass from rational data to these
claims. Approximate spectral and polar matrices are used as witnesses only;
their errors are bounded by exact arithmetic.

## 1. Exact arithmetic and matrix representation

The verifier uses Python integers and fractions, without NumPy, a numerical
eigensolver, or an SDP solver. It represents a complex matrix by
\[
 \mathfrak r(A)=
 \begin{pmatrix}\operatorname{Re}A&-\operatorname{Im}A\\
                 \operatorname{Im}A&\operatorname{Re}A\end{pmatrix}.
\]
This representation preserves products, adjoints, operator norms and
positivity. For Hermitian products,
\(\operatorname{Tr}(\mathfrak r(A)\mathfrak r(B))/2=\operatorname{Tr}(AB)\).
Accordingly the realified density matrices have trace two, and the verifier
divides objective traces by two. Realification is a representation of the
same complex example, not a change to a twelve-dimensional example.

For any rectangular rational matrix it uses the rational upper bound
\[
 N(A)=\max\{\|A\|_1,\|A\|_\infty\}\ \ge\ \|A\|_2.
\]
Every required strict positive-definiteness assertion is checked by symmetric
LDL-transpose elimination with exactly positive rational pivots.
Positivity of all three effects and their exact normalization imply
\(0<E_j<I\). Assertions remain enabled; optimized Python is explicitly rejected.

## 2. Certified full spectral sectors

For each effect \(E_j\), the certificate proposes a square matrix \(Z_j\)
and a diagonal matrix \(L_j\) with rational entries in \([0,1]\). Define
\[
 \eta_j=N(Z_j^*Z_j-I)<\tfrac12,\qquad
 r_j=N(E_jZ_j-Z_jL_j),\qquad \epsilon_j=r_j+2\eta_j.
\]
Let \(V_j=\operatorname{polar}(Z_j)\). It is unitary, and
\(\|Z_j-V_j\|\le\eta_j\), since every singular value of \(Z_j\) has square
within \(\eta_j\) of one. Consequently
\[
 \|E_j-V_jL_jV_j^*\|
 =\|E_jV_j-V_jL_j\|\le\epsilon_j.
\]
The checker verifies
\[
 g_j=\min_{\lambda\in\operatorname{spec}L_j}
          |\lambda-(1-\delta)|>\epsilon_j.
\]
Let \(P_j=1_{[1-\delta,1]}(E_j)\) and let \(Q_j^0\) select the columns of
\(V_j\) whose diagonal entries in \(L_j\) exceed \(1-\delta\).
Then, with \(n=2d=12\) as a conservative dimension factor,
\[
 \|P_j-Q_j^0\|\le p_j:=n\epsilon_j/g_j<\tfrac14. \tag{C1}
\]

For completeness, take an eigenvector of \(E_j\) in its high sector. On the
low sector of \(V_jL_jV_j^*\), its eigenvalue is separated by at least \(g_j\);
applying the inverse restricted eigenvalue equation bounds its low component
by \(\epsilon_j/g_j\). Summing squared bounds over an orthonormal eigenbasis
gives at most \(\sqrt d\,\epsilon_j/g_j\) for
\(\|(I-Q_j^0)P_j\|\). Reversing the roles and using a high eigenvector of
\(V_jL_jV_j^*\) gives the same estimate for
\(\|(I-P_j)Q_j^0\|\). The projection-difference identity gives (C1), with
the larger integer factor \(n\). A projection distance below one forces
equal ranks. Thus these are the full sectors of the exact rational effects,
and their ranks are exactly those read from the rational diagonal models.

Let \(V_j^h\) be the selected columns and
\(B_j=\operatorname{polar}(P_jV_j^h)\). Its columns form an orthonormal
basis of \(\operatorname{ran}P_j\). The singular values of \(P_jV_j^h\)
lie in \([\sqrt{1-p_j^2},1]\), so
\[
 \|B_j-V_j^h\|\le p_j+p_j^2\le2p_j.
\]
Writing \(T=(B_1,\ldots,B_m)\) and \(T_0=(Z_1^h,\ldots,Z_m^h)\) therefore gives
\[
 \|T-T_0\|\le e_T:=\sum_j(2p_j+\eta_j). \tag{C2}
\]
Changing these bases by separate within-sector unitaries leaves both
completed POVMs unchanged.

## 3. Certified weighted synthesis

In the bases just selected, \(TD=(\sqrt{E_1}B_1,\ldots,\sqrt{E_m}B_m)\).
For each selected diagonal entry \(\lambda\), the certificate supplies a
rational \(s\in[1/2,1]\), and checks the bound
\[
 |\sqrt\lambda-s|\le2|\lambda-s^2|.
\]
Let \(S_j\) be the diagonal matrix of these s values and let
\(s_j^{\rm err}=\max 2|\lambda-s^2|\) on that block.

Put \(X=\sqrt{E_j}V_j^h-V_j^h\sqrt{L_j^h}\).
Then
\[
 \sqrt{E_j}X+X\sqrt{L_j^h}=E_jV_j^h-V_j^hL_j^h.
\]
The right-hand side has norm at most \(\epsilon_j\).
The integral solution of this Sylvester equation is bounded by
\(2\epsilon_j\): \(\sqrt{E_j}\ge0\), while
\(\sqrt{L_j^h}\ge\tfrac12I\), so the integrand norm decays at least as
\(e^{-t/2}\). The integral solution is verified by differentiating the
two matrix exponentials.
Using \(\|\sqrt{E_j}\|\le1\) and (C2)'s block estimates yields
\[
 \|TD-A_0\|\le e_A:=
 \sum_j(2p_j+2\epsilon_j+\eta_j+s_j^{\rm err}),\qquad
 A_0=(Z_1^hS_1,\ldots,Z_m^hS_m). \tag{C3}
\]
No square-root perturbation estimate near a zero eigenvalue is assumed.

## 4. A deliberately loose polar-factor error bound

Apply the following argument separately to \(T\) and \(TD\).
Suppose \(\|A-A_0\|\le e\), and rational witness matrices \(U_0,H_0\) satisfy
\[
 \eta=N(U_0^*U_0-I)<\tfrac12,\quad H_0\ge hI,\quad
 h\ge\tfrac34,\quad N(H_0)\le2.
\]
The checker verifies the stronger strict positivity \(H_0-hI>0\).
Define
\[
 z=e+N(A_0-U_0H_0)+\eta N(H_0)<\tfrac14.
\]
Set \(V_0=\operatorname{polar}(U_0)\) and \(B=V_0H_0\).
Then \(\|A-B\|\le z\), \(\|B\|\le2\),
\(\sigma_{\min}(A)\ge h-z>1/2\), and
\(\operatorname{polar}(B)=V_0\).

If \(G,H\ge\frac14I\), the positive-matrix integral formula
\[
 G^{-1/2}=\frac1\pi\int_0^\infty t^{-1/2}(G+tI)^{-1}\,dt
\]
and the resolvent identity give
\(\|G^{-1/2}-H^{-1/2}\|\le4\|G-H\|\).
The constant is the scalar integral
\((1/\pi)\int_0^\infty t^{-1/2}(t+1/4)^{-2}\,dt=4\).
Since \(\|A^*A-B^*B\|\le5z\), expanding the two normalized matrices gives
\[
 \|\operatorname{polar}(A)-V_0\|\le2z+2(4)(5z)=42z.
\]
Therefore
\[
 \|\operatorname{polar}(A)-U_0\|\le42z+\eta. \tag{C4}
\]
The first application also certifies the actual synthesis injectivity and
the lower bound \(\alpha\ge h-z\).

Let \(e_u,e_w\) denote the two errors from (C4), and let \(U_0,W_0\) be
the corresponding rational isometries up to their certified Gram errors.
Put \(R_0=I-U_0U_0^*\).
Then \(\|R-R_0\|\le3e_u\) and \(\|R_0\|\le1\) by its spectrum;
using the weaker bound two is sufficient below.
Each sector projector differs from its rational column product by at most
three times the appropriate polar error. Thus
\[
 \begin{aligned}
 \|F^u_j-(U_0C_jU_0^*+R_0E_jR_0)\|&\le12e_u,\\
 \|F^w_j-(W_0C_jW_0^*+R_0E_jR_0)\|&\le3e_w+9e_u.
 \end{aligned} \tag{C5}
\]
The residual projection is shared: \(D\) is invertible on all selected
sectors, so \(\operatorname{ran}(TD)=\operatorname{ran}(T)\).

For each rational approximation \(G_j\) supplied to the distance certificate,
the verifier adds the exact rational bound N on its difference from the
corresponding model in (C5). Call the resulting bound \(c_j\). Consequently
\(\|F_j-G_j\|\le c_j\) for the actual, exactly defined completion.

## 5. Rational distance witnesses

For a chosen completion let \(D_j=(E_j-G_j)^{\mathsf T}\).
The certificate supplies exact Hermitian rational matrices \(\rho,X_j,Y_j\).
After rational identity shifts and normalization, the checker verifies
\[
 \rho>0,\quad \operatorname{Tr}\rho=1,\quad
 \rho\pm X_j>0,\quad Y_j\pm D_j>0,\quad
 tI-\sum_jY_j>0. \tag{C6}
\]
It calculates the rational primal objective \(L=\sum_j\operatorname{Tr}(D_jX_j)\).
The value t is also rational. The identity shifts do not replace a positivity
test: every displayed inequality is checked by exact positive LDL pivots.

These are direct lower and upper witnesses for the measurement-map norm.
Indeed, write \(X_j=\sqrt\rho H_j\sqrt\rho\), with
\(-I\le H_j\le I\). A purification with coefficient matrix
\((\sqrt\rho)^{\mathsf T}\) gives conditional output differences
\(\sqrt\rho D_j\sqrt\rho\). Their summed trace norms are at least L.
For the upper bound, for any feasible \(\rho,X_j\),
positivity of \(Y_j\pm D_j\) and \(\rho\mp X_j\) gives
\(\operatorname{Tr}(D_jX_j)\le\operatorname{Tr}(Y_j\rho)\);
summing bounds the value by t. Conversely each reference-assisted input
and each optimal trace-norm sign choice gives such feasible matrices.
This covers arbitrary reference systems by purification and Schmidt rank.

The actual differences replace \(D_j\) by matrices within \(c_j\) in operator
norm. For a feasible \(X_j\), \(\|X_j\|_1\le\operatorname{Tr}\rho=1\), so the
primal objective changes by at most \(\sum_jc_j\). Adding \(c_jI\) to
each dual matrix gives a feasible upper witness for the actual differences.
Hence the exact channel distance obeys
\[
 L-\sum_jc_j\ \le\
 \|\mathcal M_E-\mathcal M_F\|_\diamond\
 \le t+\sum_jc_j. \tag{C7}
\]
The approximations \(G_j\) themselves need not be POVMs; only the actual
effects and constructed completions are asserted to be POVMs.

## 6. Strict comparisons and informative bounds

The checker verifies strict separation of the two intervals in (C7).
It obtains a separation greater than \(0.000978162586\) in A and greater
than \(0.000289333328\) in B. Every comparison is between exact fractions.
The displayed decimal intervals are rounded outward using integer division.

For the informative-regime assertion, (C4) gives rational lower bounds
on alpha exceeding 0.939999999884 in A and 0.919999999860 in B.
Integer square-root calculations give rational upper bounds on
\(\sqrt{1-\alpha^2}\) and \(\sqrt\delta\). The resulting frozen-theorem
upper bounds are respectively 1.903823406 and 1.775804462, both strictly
below two.

## Reproduction and trust boundary

The retained certificate is checked without scientific Python packages:

    python -I -S experiments/verify_exact_completion_comparison.py

The [verifier](../experiments/verify_exact_completion_comparison.py) and
[exact outputs](../research/exact_comparison_2026-11-01/verification.json)
are the primary computational evidence. The separate
[builder](../experiments/build_exact_completion_comparison.py) uses NumPy to
propose rational data; its numerical correctness is not assumed by the
checker. Deliberately corrupted inputs are covered by the
[negative controls](../experiments/check_exact_certificate_negative_controls.py).
Those checks also verify all 66 positive matrices independently using
integer Bareiss determinants of every leading principal submatrix, rather
than relying solely on the rational LDL implementation.

The result is a finite computer-assisted proof using the analytic bounds
above and exact rational certificates. The complete logical argument is not
encoded in Lean, and the result has not received independent specialist
review. The certificate proves the two orderings, not their novelty, the
optimality of either construction, or an experimentally useful advantage.
