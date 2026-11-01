# Attribution scope: exact bound at perfect packing

1 November 2026. This is a scoped literature check, not a novelty certificate
or external review.

## Exact comparison target

The [new proof](../theory/perfect_packing_sharpness.md) concerns the prescribed
completion `F_j = P_j + R E_j R` when the full spectral sectors at threshold
`1-delta` are mutually orthogonal (`alpha=1`). For every `0<delta<1/2`, it
gives the exact worst-case diamond distance

\[
B(\delta)=\frac{2\sqrt\delta}{2-\sqrt\delta},
\]

over finite dimensions and outcome counts, together with a six-dimensional,
five-outcome family attaining it. The asymptotic coefficient is one; the
best coefficient uniform over the whole threshold interval is
`(8+2*sqrt(2))/7`. This narrower sharpness statement is the comparison target.
It does not claim optimality of the general `alpha<1` bound.

## Established tools used in the proof

| Step | Attribution and scope |
|---|---|
| Spectral commutation, positive residual effects, normalization by a positive sum on its support | Standard finite-dimensional positive-operator algebra. No new general lemma is claimed. |
| Reduction to pure inputs with a reference, trace-norm contractivity under channels | Standard quantum channel norm machinery; see [Watrous, *The Theory of Quantum Information*, Chapter 3, especially Theorem 3.51](https://cs.uwaterloo.ca/~watrous/TQI/TQI.pdf). |
| Trace norm of a difference of two rank-one positive operators | Elementary two-eigenvalue calculation, written explicitly in the proof. No novelty claim for that identity. |
| Primal/dual diamond-norm certificates | Established semidefinite programming machinery; see [Watrous, *Simpler semidefinite programs for completely bounded norms*, 2012](https://arxiv.org/abs/1207.5726). |
| Prescribed polar sector constructions in the surrounding theorem | Established least-squares measurement constructions, as recorded in the [earlier attribution audit](CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md). At perfect packing the two constructions coincide. |

The exact scalar optimization and the explicit matching family are supplied
in the new note. That establishes an internal derivation of the stated
envelope; it does not establish first publication. The proof does not
introduce a new general gentle-measurement or dilation-continuity theorem.

## Search and inspection on 1 November

Queries included combinations of `quantum gentle measurement lemma optimal
sharp bound trace norm disturbance`, `quantum measurement rounding orthogonal
spectral subspaces diamond distance sharp`, `POVM rounding optimal diamond
norm`, `POVM perfect packing`, `repeatable completion quantum measurement`,
`POVM residual sharp rounding`, `orthogonal near-unit measurement bound`,
and searches for the denominator `2-sqrt(delta)` in measurement bounds.
Formula searches were noisy and are particularly weak evidence of absence.

The primary sources inspected included Watrous's book and SDP paper, and
[de la Salle's orthogonalization paper](https://arxiv.org/pdf/2103.14126v2).
The latter belongs to the earlier comparison of state-dependent
orthogonalization with the present prescribed channel-distance problem;
the [completed general-bound reduction](PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
remains the fuller account of that comparison. It did not by itself settle
this newly derived exact envelope.

A recent search result was [James Tian, *Ordered POVMs and Residual Collapse*,
arXiv:2605.17592v1, 17 May 2026](https://arxiv.org/html/2605.17592).
Its abstract and introduction describe ordered sequential residual tests,
iteration to a collapsed image, and a terminal escape effect. Those stated
objects differ from the fixed spectral-threshold completion considered here.
This observation is limited to the inspected scope: it is not a complete
non-implication audit of all results in that paper.

### A closer gentle-measurement comparison

Following the references in [Winter, *Generalised Pinching Inequality*,
Section III, 2025](https://arxiv.org/html/2510.19111v1) led to
[Regula, Lami and Datta, *Tight relations and equivalences between smooth
relative entropies*, Appendix C, equations (170)-(175), version 5,
3 April 2026](https://arxiv.org/html/2501.12447v5).
The latter explicitly develops the rank-two trace-distance calculation
behind a tightened gentle-measurement estimate.

Our comparison is direct: in the new proof let `t=r+q>0`, normalize
`xx*` to trace one, and project with `R`. The loss is `epsilon=r/t`.
The pure-state projected trace-norm expression in that appendix, rescaled
by `t`, is

\[
t\sqrt{4\epsilon-3\epsilon^2}=\sqrt{r^2+4rq}.
\]

This recovers precisely the trace-norm ingredient in our proof. The case
`t=0` is zero directly. This is our explicit specialization of their
calculation, not an assertion that their paper states the combined POVM
theorem. The additional work here is the residual-effect factorization,
adding the defect term `r`, optimizing under `r<=delta*p`, and constructing
an admissible full-sector family attaining the resulting envelope. Thus
even the sharper trace-distance ingredient has explicit prior art.

No direct statement of this exact prescribed-completion envelope was
identified in the inspected material. Search coverage, terminology, and
possible derivations from other disturbance inequalities remain limitations.
There has been no exhaustive citation-chain audit for this new formula.

## Remaining review question

An external researcher should reconstruct the universal factorization and
optimization, check the full-sector hypothesis for the matching family,
and determine whether this precise statement or a direct equivalent has
already appeared. The repository's claim is **internally derived sharpness
for a specified subclass; publication novelty unverified**.
