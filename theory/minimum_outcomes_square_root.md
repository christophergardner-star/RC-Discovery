# Three outcomes are necessary and sufficient for square-root error

1 November 2026. An elementary corollary of the existing binary norm identity
and perfect-packing construction. Internally reconstructed; external review
and publication priority unverified. This is not presented as a previously
recognized open problem in the literature.

All distances are unhalved diamond distances. Use the full closed-threshold
sectors and prescribed completion of the frozen theorem, with `0<delta<1/2`.

## Exact binary envelope

For two outcomes write `E_0=E`, `E_1=I-E`. The two selected sectors are
the spectral subspaces of E for `[1-delta,1]` and `[0,delta]`, respectively.
They are orthogonal, so their injective synthesis has `alpha=1`. Their
complement R is the spectral subspace for `(delta,1-delta)`. Consequently
the completion's first effect is the spectral function

\[
 F_0=f(E),\qquad
 f(t)=\begin{cases}
 0,&0\le t\le\delta,\\
 t,&\delta<t<1-\delta,\\
 1,&1-\delta\le t\le1.
 \end{cases}
\]

Thus `||E-F_0|| <= delta`, including the threshold endpoints and arbitrary
spectral degeneracy. If a label is zero, its selected sector is also zero
and the same conclusion holds.

For completeness, put `A=E-F_0`. The binary channel difference is
`X -> diag(Tr(AX),-Tr(AX))`. Its diamond norm is `2||A||`.
Indeed the completely bounded trace norm of the Hermitian functional
`X -> Tr(AX)` is `||A||`: on any positive input with a reference, duality
against a reference Hermitian contraction K bounds the expectation of
`A tensor K` by `||A||`. A unit eigenvector at an extremal eigenvalue of A
attains the bound without a reference. The pure-state characterization of
the diamond distance of channels completes the argument.

It follows that every admissible binary measurement satisfies

\[
 \boxed{\|\mathcal M_E-\mathcal M_F\|_\diamond\le2\delta.}
\]

Equality is attained for every allowed delta on a qubit:

\[
 E_0=\operatorname{diag}(1-\delta,\delta),\qquad E_1=I-E_0,
 \qquad F_0=\operatorname{diag}(1,0),\quad F_1=I-F_0.
\]

Both nonzero effects have nonzero full sectors. This proves the exact binary
worst-case envelope, not just an example or an upper estimate. It also shows
that references cannot improve discrimination for any binary pair.

## Minimum outcome count for square-root behavior

With one outcome the only POVM is `{I}`, and the completion error is zero.
With two outcomes the exact envelope is `2 delta`, so the ratio to
`sqrt(delta)` tends uniformly to zero as delta tends to zero.

Section 3 of the [perfect-packing proof](perfect_packing_sharpness.md)
constructs, for every `0<delta<1/4`, a three-outcome POVM on `C^4` with
`alpha=1` and exact prescribed-completion distance

\[
 B(\delta)=\frac{2\sqrt\delta}{2-\sqrt\delta}.
\]

Its unsplit low eigenvalue stays strictly below the threshold because,
with `b=sqrt(delta)<1/2`, the threshold margin is
`(1-2b)(1+b-b^2)/(2-b)>0`. It therefore satisfies the full-sector requirement.
The system-only attaining input and universal arbitrary-reference upper
bound are already proved in that note.

Hence three outcomes are both necessary and sufficient for worst-case
square-root asymptotics in this prescribed-completion problem. More strongly,
the exact three-outcome, perfect-packing envelope is B(delta) for
`0<delta<1/4`. No reference is needed by the attaining example.

This also gives an outcome-count threshold for the obstruction against
freely chosen repeatable targets: binary inputs have the prescribed repeatable
target within `2 delta`, whereas Proposition 5 of the
[short paper](../paper/arxiv_ready.md) supplies a three-outcome family whose
distance to every same-space, same-label repeatable target is at least
`sqrt(delta)/(4 sqrt(3))` for `0<delta<1/10`. This establishes the minimum
outcome count for that obstruction, but not its exact minimax constant.

## Limits and the next substantive question

This corollary uses standard binary spectral calculus and the existing
construction. It does not settle the exact three-outcome envelope for
`1/4<=delta<1/2`, the general packing bound, crossover uniqueness, or novelty.
In particular, failure of the displayed unsplit construction at the threshold
does not prove that a different three-outcome extremizer cannot exist.

A more substantial target is the sharp joint small-error behavior. Along
`delta_m=1/m` with even m and `1-alpha_m^2=r/m` for a fixed `r>=0`, define
W_m(r) as the supremum of the prescribed distance over all finite POVMs
satisfying the frozen hypotheses with these exact parameters (for sufficiently
large m). The [coupled-simplex family](imperfect_packing_lower_bound.md)
makes that class nonempty. Its lower bound and the conditional overlap upper
bound of Theorem 1 give

\[
 \sqrt{1+r}\le\liminf_{m\to\infty,\ m\text{ even}}
 \frac{W_m(r)}{\sqrt{\delta_m}}
 \le\limsup_{m\to\infty,\ m\text{ even}}
 \frac{W_m(r)}{\sqrt{\delta_m}}\le2\sqrt{1+r}.
\]

For the upper bound, the Jordan width condition holds eventually because
`alpha_m` tends to one and `delta_m` tends to zero; then use
`2 sqrt(1-alpha_m^2(1-delta_m))`.
For r=0, the sharp perfect-packing theorem improves both limits to one.
This was the remaining project-open problem when this note was written.
The subsequent [joint small-error proof](joint_small_error_asymptotics.md)
closes the gap for every fixed r: the limit exists and equals sqrt(1+r).
It also proves the unrestricted joint limit as alpha tends to one and delta
tends to zero. The exact finite-error envelope remains open.
