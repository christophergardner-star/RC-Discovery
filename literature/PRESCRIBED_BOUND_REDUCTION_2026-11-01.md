# Proof-level reduction of the prescribed completion bound

1 November 2026. This is an internal mathematical audit, not external review.
It concerns the [frozen theorem](../theory/THEOREM_V1_FREEZE.md), including its
record corollary. The theorem and its hypotheses are unchanged.

## Conclusion

The main bound has a complete reduction to established polar geometry,
the classical Jordan-product inequality, and the pure-state trace-distance
formula. The measurement-specific work is the choice of the residual-preserving
target and verification of its labelled dilation, followed by parameter
substitution. No additional general operator inequality is required.

The appropriate classification is **an explicit quantitative specialization**,
or a corollary once that dilation has been exhibited. This resolves the internal
question of whether a new general lemma is needed. It does not establish that
the complete statement was previously published, that the specialization has
no value, or that the certified examples have no original content.
A theorem can be new while following from standard facts. This audit settles
the proof dependencies; it does not infer lack of publication novelty merely
from the age of the ingredients.

## Primary results and the exact use made of them

| Source | Use | What is not being imported |
|---|---|---|
| [Eldar–Forney, Theorem 2 and Section V](https://www.weizmann.ac.il/math/yonina/sites/math.yonina/files/quantumDetection_0.pdf), IEEE TIT 47 (2001), 858–872 | Unweighted and weighted least-squares polar formulas on the packed span. | A diamond-distance guarantee or our residual extension. |
| [Higham, Section 2](https://eprints.maths.manchester.ac.uk/694/1/high86p.pdf) | Polar decomposition and orthogonalization geometry. | A new measurement-rounding theorem. |
| [de Bruijn, Theorem 3.2 and Sections 4–5](https://pure.tue.nl/ws/portalfiles/portal/2165089/597564.pdf) | The Jordan-product lower bound after the explicit substitution below. | A positive-product inequality valid for arbitrary spectral widths. |
| [Watrous, Theorem 3.51](https://cs.uwaterloo.ca/~watrous/TQI/TQI.pdf) | Pure reference-assisted inputs suffice for the full diamond norm. | Conversion of a system-only test or normalized-trace error into a uniform bound. |
| [Watrous, Corollary 3.15 and Theorem 3.33](https://cs.uwaterloo.ca/~watrous/TQI/TQI.pdf) | Normalized gentle projection in the record step. | A general stability theorem for all almost-idempotent channels. |

The relevant statements and formulas were inspected in the primary texts.
For the first row, diagonalize each restricted effect in its sector. The
concatenated unit columns are independent by hypothesis. The two polar
formulas are exactly the least-squares constructions, with column weights
equal to one or to the square roots of the selected eigenvalues. Grouping
columns recovers the original sector labels. See the
[explicit identification](CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md).

## Reduction of the complete measurement statement

Use the paper's domains and notation: \(T:\mathcal K\to\mathcal H\),
\(T=UH\), \(C_j\) the coordinate projections, \(S=UU^*\), \(R=I-S\),
\(d=\sqrt{1-\delta}\), and \(a=\sqrt{1-\alpha^2}\).

**1. Spectral and geometric bookkeeping.** A vector in one nonzero coordinate
sector has \(\|Tx\|=\|x\|\), so \(0<\alpha\le1\). From
\(E_j\ge d^2P_j\),

\[
d^2TT^*\le I,\qquad \alpha I\le H\le MI,\quad M\le1/d.
\]

The sector isometries satisfy
\(T_j^*U_j=\iota_j^*H\iota_j\ge\alpha I\). Consequently
\(\|(I-P_j)U_j\|^2=\|I-U_j^*P_jU_j\|\le1-\alpha^2\), with the
same estimate in the reverse direction. The two off-diagonal projection
norms determine \(\|P_j-Q_j\|\), yielding \(\|P_j-Q_j\|\le a\).
This is elementary principal-angle geometry, not a separate new lemma.

**2. The prescribed residual extension.** The polar range equals the sum of
the original sectors, so \(P_jR=0\). Positivity and normalization give
\(F_j=UC_jU^*+RE_jR\ge0\) and \(\sum_jF_j=I\).
Fullness of the threshold sector gives
\(RE_jR\le(1-\delta)R\). Thus the full unit eigenspace is \(Q_j\), the
residual gap is at least \(\delta\), and preparing any state supported in
\(Q_j\) after outcome \(j\) defines a repeatable instrument.

**3. The additional identities to check.** On \(\mathcal Y=\bigoplus_j\mathcal H\),
let \(Wz=(\sqrt{E_j}z)_j\), \(J(x_j)_j=(x_j)_j\), and let \(\Lambda_j\)
select the label. Set \(D=\bigoplus_j\sqrt{E_j}|_{\mathcal K_j}\), so
\(dI\le D\le I\). Spectral commutation gives

\[
W^*J=TD,\qquad J^*\Lambda_jWR=0.
\]

In particular the second identity is *labelwise*, not only a cancellation
after summation. With \(V=JU^*+WR\), direct multiplication yields

\[
V^*V=I,\qquad V^*\Lambda_jV=F_j,\qquad
W^*V=UHD\,U^*+R.
\]

These are the measurement-specific bridge. No optimization over an unspecified
nearby measurement or change of the prescribed polar factor is made.

**4. Classical matrix bound.** Put

\[
u=\frac{M-\alpha}{M+\alpha},\quad v=\frac{1-d}{1+d},\quad
c=\frac{(M+\alpha)(1+d)}4.
\]

The \(u+v\le1\) branch of the cited Jordan-product result gives
\(\operatorname{Re}(HD)\ge c(1-u)(1-v)I=\alpha dI\).
Its condition is precisely \((M-\alpha)(1-d)\le4\alpha d\).
The short sum-of-squares proof in the paper verifies the same specialization
directly, including \(M=\alpha\), without relying on an OCR reading of a formula.

**5. Standard channel estimate, with the constant tracked.** For isometries
\(A,B\) and a common CPTP output map \(\mathcal L\), if
\(\operatorname{Re}(A^*B)\ge cI\), \(0\le c\le1\), then

\[
\|\mathcal L(A\,\cdot\,A^*)-\mathcal L(B\,\cdot\,B^*)\|_\diamond
\le2\sqrt{1-c^2}.
\]

Indeed, for a unit vector with any reference system the two dilated vectors
have overlap of modulus at least \(c\). The trace norm of the difference
of their pure states is \(2\sqrt{1-|\langle x,y\rangle|^2}\); common readout
contracts it. This proves the assertion for the diamond norm. Taking
\(A=W,B=V,c=\alpha d\) proves the conditional joint bound exactly.

KSW's general estimate \(2\|A-B\|\) would only give
\(2\sqrt{2(1-c)}\) from this overlap premise. Thus the stronger displayed
constant uses the pure-state formula explicitly. This is a standard fact,
not an additional continuity theorem or an application of KSW's converse.

**6. Removing the auxiliary width condition.** If \(a+\sqrt\delta\ge1\),
the frozen additive bound is the universal channel ceiling two. Otherwise,
put \(b=\sqrt\delta\); then
\(\alpha^2>2b-b^2>b^2\), so \(\alpha>b\). Since \(d>1/\sqrt2\),

\[
(M-\alpha)(1-d)\le\frac{\delta}{d(1+d)}\le\delta<4\alpha d.
\]

The joint bound therefore applies, and
\(\sqrt{1-\alpha^2d^2}=\sqrt{a^2+\alpha^2\delta}\le a+\sqrt\delta\).
This proves the frozen coefficient-two conclusion in every allowed case.
No commutativity of \(H,D\) was assumed.

Zero effects contribute zero coordinate sectors and zero instrument maps.
At least one sector is nonzero because the POVM is normalized on a nonzero
space. The one-label case has \(T=U=I\) and poses no exception. High ranks,
degeneracy within a sector, and arbitrary reference systems are covered by
the same operator argument. Threshold crossings remain a limitation of
continuity of the selected map, not of this pointwise theorem.

## Reduction of the record corollary

Discard zero effects; with one active label the channel is constant and
idempotent. For at least two labels, let
\(v_j=\Phi(\sigma_j)-\sigma_j\), \(D_{\rm rec}=\max_j\|v_j\|_1\),
and retain the paper's \(e<1/2\), \(\kappa>0\), and defect \(\eta\).

Reference-assisted outputs are sums \(\sum_jv_j\otimes B_j\) with
\(B_j\ge0\), \(\sum_j\operatorname{Tr}B_j=1\), so \(\eta\le D_{\rm rec}\).
An input accessing a maximizing label with probability at least \(1-e\)
and the reverse triangle inequality give \((1-2e)D_{\rm rec}\le\eta\).
Convex-hull separation and spectral compression then give, in order,

\[
2\kappa(1-\operatorname{Tr}E_j\sigma_j)\le\|v_j\|_1,
\qquad
1-\operatorname{Tr}P_j\sigma_j\le
q:=\frac{\eta}{2\kappa\delta(1-2e)}.
\]

On a purification, the projector triangle inequality gives
\(\sqrt{1-\operatorname{Tr}Q_j\sigma_j}\le\sqrt q+a\).
Normalized projection into \(Q_j\), followed by the standard gentle bound,
costs at most \(2\sqrt q+2a\). If projected weight is zero, the latter bound
is at least two and any state in the nonzero \(Q_j\) works. These projected
records give exact idempotence because \(\operatorname{Tr}(F_i\tau_j)=\delta_{ij}\).
Common post-processing and the triangle inequality add the measurement cost,
proving the record bound. Thus no new general conditioning or idempotent-channel
structure lemma is needed either.

## What remains worth evaluating

The paper's mathematical deliverable is the specified correction, its explicit
parameter bounds, the threshold-order obstruction, and certified comparison
examples. The [four-dimensional family](../theory/completion_switch_family.md)
proves that neither established completion always has smaller full diamond
distance. Its [localized equality point](../research/COMPLETION_CROSSOVER_2026-11-01.md)
does not establish uniqueness or optimality among all repeatable targets.

A weighted upper envelope is not the actual weighted distance, so its stronger
form does not imply weighted dominance. Conversely, opposite preferences do
not establish that the unweighted bound is sharp or that either construction
solves a global best-approximation problem.

The precise external question is now: **Is this explicit specialization,
together with its limitations and certified comparison, already documented,
and does it add useful quantitative content?** The reduction itself is supplied
for correction and verification. Global publication priority and usefulness
remain unverified. No external researcher was contacted.
