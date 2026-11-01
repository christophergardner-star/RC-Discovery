# Joint second-order envelope and a stronger lower construction

1 November 2026. Internally derived analytic result, with exact rational
certificates and finite numerical attacks. The universal results in this note are **not yet fully formalized in
Lean or externally reviewed**. No publication-priority claim is made.

This note strengthens the earlier [joint leading-order result](joint_small_error_asymptotics.md).
All distances are unhalved, all upper bounds include arbitrary finite ancillas,
and the target is the prescribed unweighted residual completion.

## Results

Write

\[
 a^2=1-\alpha^2,\quad s=a^2+\delta,\quad
 \varepsilon=1-\alpha^2(1-\delta)=s-a^2\delta,\quad
 B(x)=\frac{2\sqrt{x}}{2-\sqrt{x}}.
\]

Let \(W(\alpha,\delta)\) denote the worst-case distance at **exactly** the
specified packing parameter and threshold, over all admissible finite POVMs.
For every \(0<\alpha\le1\), \(0<\delta<1/2\), the construction below gives

\[
 W(\alpha,\delta)\ge B(\varepsilon). \tag{1}
\]

For \(s\le1/4\), the universal upper bound is

\[
 \boxed{B(\varepsilon)\le W(\alpha,\delta)
 \le B(\varepsilon)+4\delta s\le B(\varepsilon)+4s^2.} \tag{2}
\]

Consequently the **joint subleading coefficient is one half**:

\[
 \boxed{W(\alpha,\delta)=\sqrt{s}+\tfrac12s+O(s^{3/2})} \tag{3}
\]

uniformly as \((\alpha,\delta)\to(1,0)\), \(\delta>0\). An explicit remainder is

\[
 -\frac5{16}s^{3/2}\le W-\sqrt{s}-\tfrac12s
 \le\frac73s^{3/2}\qquad(0<s\le1/4). \tag{4}
\]

This determines the second-order term, **not the exact general finite-error
optimum**. The remaining finite-error gap in (2) has width at most \(4\delta s\).
If the canonical operators \(D,H\) commute, the same proof has zero correction:
the optimum within that commuting subclass is exactly \(B(\varepsilon)\)
whenever \(\varepsilon\le3/4\) and \(0<\delta<1/2\). The constructed lower
family belongs to this subclass.

## 1. A lower family at every exact pair of parameters

Set \(\lambda=1-\delta\). Choose an integer \(m\ge2\) with

\[
 \delta(m-1)\ge\lambda(1-\alpha^2).
\]

On \(\mathbb C^m\), let \(u=m^{-1/2}(1,\ldots,1)^T\), and put

\[
 g^2=\frac{m-\alpha^2}{m-1},\qquad
 T=gI+(\alpha-g)uu^*,\qquad v_j=Te_j.
\]

The matrix \(T\) is positive definite, its eigenvalues are \(\alpha\) on
\(u\) and \(g\ge1\) on \(u^\perp\), and each column has squared norm
\(g^2+(\alpha^2-g^2)/m=1\). Define the old effects
\(E_j=\lambda v_jv_j^*\), \(1\le j\le m\).

Adjoin four orthogonal clean-sector vectors \(f_1,\ldots,f_4\) and one
residual vector \(r\). The total dimension is \(m+5\). Extend all old
operators by zero. Let

\[
 t=1-\lambda g^2\ge0,\quad
 \Delta=\varepsilon uu^*+t(I_m-uu^*),\quad
 R=rr^*,\quad b=\sqrt\varepsilon,\quad h=\sqrt{1-b},\quad z=2-b.
\]

Here \(0<\varepsilon<1\), \(0\le t\le1\), and
\(\sum_{j=1}^mE_j=I_m-\Delta\). On \(\operatorname{span}\{u,r\}\), put

\[
 L_+=\frac{(bu+hr)(bu+hr)^*}{z},\qquad
 L_-=\frac{(bhu-r)(bhu-r)^*}{z}.
\]

Since \(h^2=1-b\),
\(L_++L_-=\varepsilon uu^*+R\). Set \(G=t(I_m-uu^*)\) and define

\[
 \begin{aligned}
 E_{m+i}&=f_if_i^*+L_+/2+G/4 &&(i=1,2),\\
 E_{m+i}&=f_if_i^*+L_-/2+G/4 &&(i=3,4).
 \end{aligned} \tag{5}
\]

All effects are positive and their sum is the identity. Each added low part
is at most \((L_++L_-+G)/2=(R+\Delta)/2\le I/2\). Thus its eigenvalues are
strictly below \(1-\delta\). The full closed-threshold sectors are precisely
\(v_jv_j^*\) for the old labels and \(f_if_i^*\) for the added labels.
The old selected eigenvalue is exactly the threshold \(1-\delta\), so endpoint
inclusion is essential and is respected.

The synthesis is the inclusion of \(T\oplus I_4\), with minimum singular
value **exactly** \(\alpha\). Its polar isometry is the inclusion, so the
rounded sectors are \(e_je_j^*\) and \(f_if_i^*\), and the residual projection
is \(R\). Changing phases of sector bases does not change these projectors.
Furthermore \(D=\sqrt\lambda I_m\oplus I_4\) commutes with
\(H=T\oplus I_4\).

For the normalized system-only input
\(\psi=(u+hr)/\sqrt z\), the old outcome differences are each
\(-\varepsilon/(mz)\). The four new differences are

\[
 \frac{b}{2z},\quad\frac{b}{2z},\quad
 -\frac{bh^2}{2z},\quad-\frac{bh^2}{2z}.
\]

Their absolute sum is
\(\varepsilon/z+b(1+h^2)/z=2b/z=B(\varepsilon)\), proving (1).
This construction also proves nonemptiness of the exact-parameter class.
It does not rely on rounding the threshold to a nearby reciprocal integer.

Along \(1-\alpha^2=q\delta\) for fixed \(q\ge0\), any fixed integer
\(m\ge\max\{2,1+\lceil q\rceil\}\) works. In particular \(q=1\) uses
**seven dimensions and six outcomes**, independently of how small \(\delta\)
becomes. Dimension need only grow when the packing-to-threshold ratio grows.

## 2. A positive-filter estimate on all complex inputs

Let \(C\) be a positive contraction with \(mI\le C\le I\), where
\(1/2\le m<1\), and put \(\eta=1-m^2\). Define

\[
 t_0^2=\frac{1-m}{4(1+m)},\qquad u_0=\frac1{4t_0},\qquad
 A=t_0(C+I)+u_0(C-I),\quad A'=t_0(C+I)-u_0(C-I).
\]

Then for every complex matrix \(X\),

\[
 AXA^*-A'XA'^*=CXC-X.
\]

The combined Kraus Gram operator is the scalar polynomial

\[
 f(C)=2t_0^2(C+I)^2+2u_0^2(C-I)^2.
\]

The polynomial is convex on \([m,1]\), with
\(f(m)=1-m^2\) and \(f(1)=2(1-m)/(1+m)\le1-m^2\), since
\((1+m)^2\ge2\). Functional calculus therefore gives
\(A^*A+A'^*A'\le\eta I\).
The signed Kraus estimate proves
\(\|CXC-X\|_1\le\eta\|X\|_1\), with the same Gram bound after any
finite ancillary amplification. Composing with a trace-preserving coordinate
measurement preserves the combined Gram bound. The case \(m=1\) is the
zero map and needs no division.

This argument supplies a signed Kraus representation, not just a norm
inequality. That representation is needed to combine errors below without
losing the sharp leading and subleading terms.

## 3. Isolate the small non-Hermitian part of the selected filter

Use the established canonical split with \(K=DH\), \(S=UU^*\), \(R=I-S\)
and positive \(G\) satisfying

\[
 GR=0,\quad G^2\le\varepsilon S,\quad
 K^*K\ge(1-\varepsilon)I,\quad\|K\|\le1.
\]

The original-to-completed channel difference is the remainder map
\(\mathcal N((R+G)\,\cdot\,(R+G)-R\,\cdot\,R)\), plus the coordinate
readout of \(K\,\cdot\,K^*-\mathrm{id}\) on the selected sector.
Here \(\mathcal N\) is the constructed trace-nonincreasing Kraus map; singular
remainder sums are allowed.

Put
\(C=(K+K^*)/2\) and \(\tau=\|K-C\|=\|[D,H]\|/2\). In the regime
\(s\le1/4\), the earlier scalar bounds give

\[
 \|D-I\|\le\delta,\qquad\|H-I\|\le s,\qquad
 \|K-I\|\le2s,
\]

hence

\[
 \tau\le\|D-I\|\|H-I\|\le\delta s\le s^2. \tag{6}
\]

The Hermitian operator \(C\) satisfies \(I/2\le C\le I\): the lower bound
follows from \(\|K-I\|\le2s\), and the upper bound from \(\|K\|\le1\).
The singular-value inequality
\(\|Cx\|\ge\|Kx\|-\tau\|x\|\) sharpens this to

\[
 mI\le C\le I,\qquad m=\sqrt{1-\varepsilon}-\tau>1/2.
\]

Positivity of \(C\) is used in this last implication. Indeed
\(\varepsilon\le s\le1/4\) and \(\tau\le1/16\), so the displayed \(m\)
is greater than one half. Its loss parameter obeys

\[
 \eta=1-m^2=\varepsilon+2\tau\sqrt{1-\varepsilon}-\tau^2
 \le\varepsilon+2\tau. \tag{7}
\]

Replacing \(K\) by \(C\) changes the selected map by at most \(2\tau\) in
full diamond norm, by the already proved contraction sandwich inequality.
The coordinate readout and embedding by \(U^*\) are contractions.

## 4. Combine the signed Kraus representations before bounding the norm

Choose \(k=\varepsilon^{-1/2}-1/2>0\), so
\(\varepsilon(k+1/2)^2=1\). The residual pair

\[
 A_r=(1/2+k)G+R,\qquad C_r=(1/2-k)G+R
\]

represents \(2k\) times the residual map as a signed Kraus sum, after
composition with \(\mathcal N\). Its combined Gram operator is at most

\[
 2(1/4+k^2)G^2+2R
 \le2(1/4+k^2)\varepsilon S+2R.
\]

The selected positive-filter difference from Section 2 has a signed Kraus
representation with combined Gram at most \(\eta S\) after embedding into
the physical space. Scale those Kraus operators by \(\sqrt{2k}\) and append
them to the residual family. For \(2k\) times the combined map, the total
Gram is at most

\[
 [2(1/4+k^2)\varepsilon+2k\eta]S+2R
 \le2I+4k\tau S\le(2+4k\tau)I.
\]

The signed Kraus bound, also after ancillary amplification, therefore gives
the combined distance at most \(k^{-1}+2\tau=B(\varepsilon)+2\tau\).
Restoring \(K\) costs at most another \(2\tau\). Thus every admissible
measurement satisfies

\[
 \nu\le B(\varepsilon)+4\tau\le B(\varepsilon)+4\delta s.
\]

This proves (2). The proof uses arbitrary complex inputs throughout, so it
does not assume a pure-input characterization of diamond distance.
When \([D,H]=0\), take \(C=K\), \(\tau=0\) directly. The filter argument
only needs \(\sqrt{1-\varepsilon}\ge1/2\), giving the stated exact commuting
subclass result through \(\varepsilon\le3/4\).

## 5. Explicit second-order remainder

Put \(p=a^2\delta\le s^2/4\), so \(\varepsilon=s-p\). The exact scalar
expansion is

\[
 B(\varepsilon)=\sqrt\varepsilon+\frac\varepsilon2+
 \frac{\varepsilon^{3/2}}{2(2-\sqrt\varepsilon)}.
\]

For \(s\le1/4\), its last term is between zero and \(s^{3/2}/3\), while
\(0\le\sqrt{s}-\sqrt\varepsilon=p/(\sqrt{s}+\sqrt\varepsilon)
\le s^{3/2}/4\) and \(p/2\le s^2/8\le s^{3/2}/16\).
Together with \(4s^2\le2s^{3/2}\), these prove (4) and hence

\[
 \frac{W(\alpha,\delta)-\sqrt{1-\alpha^2+\delta}}
 {1-\alpha^2+\delta}\longrightarrow\frac12
\]

jointly. This limit now concerns the actual worst-case class, via the explicit
lower family and the universal upper argument.

## Verification boundary

The signed Kraus inequality, canonical split, contraction sandwich inequality,
exact perfect-packing upper theorem, perfect-packing attaining family and
[positive-filter signed Kraus lemma](../lean/RCProof/PositiveFilter.lean) are
Lean checked. The new variable-size lower family and the assembled noncommuting
upper theorem of this note are not yet fully Lean checked.

[`test_joint_second_order.py`](../experiments/test_joint_second_order.py)
checks 29 instances of the new lower family, including exact-parameter sector
identities to floating-point tolerance, and 36 upper-bound instances with 432
arbitrary complex-input/ancilla checks. It also checks the positive-filter Gram
bound and the commutator estimate. The
[retained output](../research/joint_second_order_2026-11-01/verification.json)
records these finite tests. They are additional attacks on the formulas, not
a replacement for the universal proof above.

The isolated standard-library checker
[`verify_joint_lower_exact.py`](../experiments/verify_joint_lower_exact.py)
also verifies three rational nine-dimensional, eight-outcome members: exact
normalization, positivity, full threshold sectors, packing parameter, canonical
completion and witness value. It passes 126 exact positive-semidefiniteness
checks and rejects five deliberately corrupted certificates. The
[exact verification record](../research/joint_second_order_2026-11-01/exact_verification.json)
is finite evidence for the lower construction, not a universal Lean proof.

The exact general finite-error optimum, a sharper term beyond (3), novelty
and external specialist review remain open.
