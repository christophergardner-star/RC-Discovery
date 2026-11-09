# Exact joint envelope for the prescribed repeatable completion

9 November 2026. Internally derived proof. The central coupled operator
inequality is checked in Lean; the complete canonical assembly and general
attaining family are not yet fully formalized. External reconstruction and
publication priority remain unresolved. This note supersedes the finite-error
gap in [joint_second_order.md](joint_second_order.md).

## Statement

Let the effects of a finite POVM be `E_j`, let `c=1-delta`, and take the full
closed-threshold sectors `P_j=1_[c,1](E_j)`. Assume `0<delta<1/2`, injective
sector synthesis `T`, and a nonzero sector for every nonzero label. Write
`T=UH`, `alpha=sigma_min(T)`, `Q_j=U C_j U*`, `R=I-UU*`, and use the prescribed
unweighted completion `F_j=Q_j+R E_j R`.

For every such measurement, with unhalved diamond distance,

\[
 \boxed{\|\mathcal M_E-\mathcal M_F\|_\diamond
 \le \frac{2\sqrt{1-\alpha^2(1-\delta)}}
 {2-\sqrt{1-\alpha^2(1-\delta)}}.} \tag{1}
\]

For every exact pair `0<alpha<=1`, `0<delta<1/2`, the lower family in Section 1
of [the second-order note](joint_second_order.md) attains (1). Consequently,
over the same admissible class used by `packingWorstCase` in Lean,

\[
 \boxed{W(\alpha,\delta)=B(\varepsilon),\qquad
 \varepsilon=1-\alpha^2(1-\delta),\qquad
 B(x)=\frac{2\sqrt{x}}{2-\sqrt{x}}.} \tag{2}
\]

This concerns the prescribed completion. It does not identify a nearest
repeatable target among all possible choices. It establishes no new general
claim about entanglement-assisted discrimination, and makes no novelty claim.

## 1. Split at the common threshold

The important change from the previous proof is to use

\[
 A_j=cP_j,\qquad B_j=E_j-cP_j\ge0, \tag{3}
\]

instead of the split `P_j E_j P_j` and its remainder. Positivity in (3) follows
directly from the full spectral projector, including eigenvalues equal to `c`.
The new remainder may have support in a selected sector. No step below assumes
that it vanishes there.

Since `P_j=T C_j T*` and `sum C_j=I`,

\[
 \sum_j A_j=cTT^*\le I.
\]

On the sector coordinate space define the **positive** filter

\[
 C=\sqrt c\,H,\qquad m=\alpha\sqrt c,\qquad
 b=\sqrt{1-m^2},\qquad k=b^{-1}-\tfrac12.
\]

Then `0<m<1`, `0<b<1`, `k>0`, and `mI<=C<=I`. The upper inequality follows
from `cT*T<=I`; it requires neither commutation of the original selected
eigenvalues with `H` nor the earlier width condition.

Set `S=UU*` and

\[
 G=U\sqrt{I-C^2}\,U^*.
\]

Thus `G>=0`, `GR=RG=0`, and, crucially,

\[
 G^2=U(I-C^2)U^*,\qquad
 \sum_j B_j=I-cTT^*=R+G^2=(R+G)^2. \tag{4}
\]

The selected and residual errors now share exactly the same squared deficit.
Also `R B_j R=R E_j R`, since `R P_j=0`.

## 2. Factor the residual measurement, including singular sums

Write `L=R+G` and let `L^+` be its inverse on its support, zero on its kernel.
Because `0<=B_j<=L^2`, every `B_j` is supported in the support of `L`. Define

\[
 M_j=L^+ B_j L^+\ge0,\qquad \sum_j M_j=P_{\operatorname{ran}L}\le I.
\]

Let `N` be the trace-nonincreasing measurement map with effects `M_j`. Then

\[
 \mathcal M_B(X)=N(LXL),\qquad
 \mathcal M_{RBR}(X)=N(RXR). \tag{5}
\]

These identities hold for all complex matrices. The second uses `LR=RL=R`.
Equivalently, use the already formalized positive-family factorization to
construct Kraus operators `N_l` with `sum N_l* N_l<=I`.

Let `J` be the trace-preserving coordinate measurement with effects `C_j`.
The complete channel difference is

\[
 N(LXL-RXR)+J(CU^*XUC-U^*XU). \tag{6}
\]

All output labels in (6) are the original labels. The split does not modify
the prescribed completed measurement.

## 3. Combine the errors before taking norms

The two residual filters

\[
 A_r=(\tfrac12+k)G+R,\qquad B_r=(\tfrac12-k)G+R
\]

satisfy, for every complex `X`,

\[
 A_r X A_r^*-B_r X B_r^*=2k(LXL-RXR),
\]

and have combined Gram operator

\[
 A_r^*A_r+B_r^*B_r=2(k^2+\tfrac14)G^2+2R. \tag{7}
\]

On the coordinate space put

\[
 A_s=(C-mI)/b,\qquad B_s=(I-mC)/b.
\]

Using `b^2+m^2=1`, direct expansion gives

\[
 A_s X A_s^*-B_s X B_s^*=CXC-X,\qquad
 f(C):=A_s^*A_s+B_s^*B_s
   =\frac{(C-mI)^2+(I-mC)^2}{b^2}. \tag{8}
\]

Unlike the old separate estimate, we do **not** require `f(C)<=b^2 I`.
Combine (7) with `2k` times (8). The scalar polynomial to bound is

\[
 g(x)=2(k^2+\tfrac14)(1-x^2)
       +\frac{2k}{b^2}\big((x-m)^2+(1-mx)^2\big).
\]

The decisive exact identity is

\[
 \boxed{2-g(x)=\frac4{b^3}(x-m)\,[m-(1-b)x].} \tag{9}
\]

For `m<=x<=1`, both factors are nonnegative: `m+b>=1` follows from
`m,b>=0` and `m^2+b^2=1`, so `m-(1-b)x>=m+b-1>=0`.
Functional calculus proves `g(C)<=2I` for **every** `0<b<1`. There is no
small-error restriction or assumption `m>=1/2`.

Compose the residual pair with the Kraus operators of `N`. Compose the
selected pair with those of `J`, embed by `U*`, and scale the selected Kraus
operators by `sqrt(2k)`. The resulting signed Kraus sum is `2k` times (6).
Its combined Gram operator is at most

\[
 2(k^2+\tfrac14)G^2+2R+2kU f(C)U^*
   = U g(C)U^*+2R\le2S+2R=2I. \tag{10}
\]

The signed Kraus trace-norm inequality therefore bounds `2k` times (6) by
`2||X||_1`. Tensoring every Kraus operator with the identity preserves the
Gram inequality, so this holds on every complex input and every finite
ancillary space. Dividing by `2k` yields

\[
 \|\mathcal M_E-\mathcal M_F\|_\diamond
 \le k^{-1}=\frac{2b}{2-b},
\]

which proves (1). No pure-input characterization is required.

## 4. Attainment and the actual supremum

For completeness, the previously constructed family chooses an integer
`n>=2` with `delta(n-1)>=(1-delta)(1-alpha^2)`, unit vector
`u=(1,...,1)/sqrt(n)`, and positive synthesis

\[
 T_0=gI+(\alpha-g)uu^*,\qquad g^2=(n-\alpha^2)/(n-1).
\]

Its columns have norm one. The old effects are
`(1-delta) T_0 |j><j| T_0`. Four additional orthogonal clean sectors receive
the positive remainder in two equal copies of each of the two rank-one
effects described in the [full construction](joint_second_order.md).
Their low parts are at most `I/2<1-delta`; hence these are the full sectors.
The packing parameter is exactly `alpha`, and the polar sectors and residual
projection are explicitly identified there.

On the normalized input `(u+sqrt(1-b) r)/sqrt(2-b)`, with
`b=sqrt(1-alpha^2(1-delta))`, the absolute outcome differences sum exactly to
`2b/(2-b)`. This gives an actual admissible member at every exact parameter
pair, not just a limiting sequence or an uninstantiated scalar lower bound.
Together with (1), it proves (2).

## 5. Consequences and boundaries

The previously retained correction `4 delta s` was an upper-proof loss.
Noncommuting selected data do not increase the worst-case envelope above (2).
Individual examples can still benefit from an ancillary reference; (2) is a
supremum over examples, attained by a system-only witness in the displayed family.

The exact formula determines all asymptotic terms through

\[
 B(\varepsilon)=\sqrt\varepsilon+\varepsilon/2+
 \varepsilon^{3/2}/4+\varepsilon^2/8+\cdots.
\]

The earlier second-order theorem follows, but the exact formula is stronger.
No statement is made here about `delta>=1/2`, noninjective synthesis, alternative
completions, a classification of all extremizers, or a fixed-dimension optimum.

The proof uses the established spectral theorem, positive-family factorization,
signed Kraus bound and the previously supplied attaining family. The new work
is the common-threshold split and the coupled identity (9). Whether this
specialization has appeared elsewhere requires a dedicated literature audit.

## Verification boundary

`CoupledFilter.lean` checks (9), its full-interval inequality and the signed
operator pair with the combined Gram bound. `UniformThreshold.lean` checks
the canonical common-threshold split, positive remainder, sum identity,
filter bounds and selected-effect factorization. The prior development already
checks the signed Kraus norm transfer, positive-family factorization and full
perfect-packing theorem. The complete new canonical upper theorem and the
general attaining-family/supremum assembly are **not yet fully Lean checked**.

The accompanying numerical attack, operator checks and primal/dual SDP checks
are retained separately from older evidence. They test the formulas and
constructions; the universal claim rests on the proof above.

See the [dated verification record](../research/EXACT_JOINT_ENVELOPE_2026-11-09.md)
for commands, retained outputs and the exact formalization boundary.
