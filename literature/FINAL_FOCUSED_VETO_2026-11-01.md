# Focused prior-art veto of the final three additions

1 November 2026. Scope: Theorem 7 and Propositions 8--9 of the twelve-page
paper. This updates, rather than replaces, the existing construction and
general-bound reduction audits. No exact combined match was identified in
the sources inspected. This is a bounded search result, not proof of novelty
or a claim that the results cannot follow easily from existing work.

## The sharp perfect-packing formula

[Regula, Lami and Datta, arXiv:2501.12447v5](https://arxiv.org/html/2501.12447v5),
Appendix C, equations (170)--(175), explicitly supplies the sharp
subnormalized gentle-measurement calculation. For the present proof set
`t=r+q`, normalize `xx*/t`, project with `R`, and put `epsilon=r/t`.
The unhalved projected-pure-state expression rescales to
`sqrt(r^2+4rq)`. Adding the lost mass gives the expression used here.
Thus the rank-two identity is prior art. Our upper bound is a specialization
after the residual POVM factorization and constraint `r<=delta p`.
The remaining claimed content is the exact maximum
`2 sqrt(delta)/(2-sqrt(delta))` for this specified completion class and
a POVM attaining it for every allowed delta while retaining the full sectors.
Appendix C does not state that completion-class theorem. This difference in
statement does not establish non-implication or publication priority.

## Reference advantage in the constrained class

[Puchala, Pawela, Krawiec and Kukulski, arXiv:1804.05856v2](https://arxiv.org/pdf/1804.05856v2),
Theorem 1 / equation (19), identifies the diamond distance of two rank-one
projective measurements with a minimum over diagonal phase choices of a
unitary-channel distance. Proposition 4 relates a discriminator's rank to
the necessary reference dimension. These are explicit prior results about
reference-assisted measurement discrimination.
Our effects and their residual-preserving completions are generally
nonprojective, so Theorem 1 is not directly a formula for this pair.
The retained contribution is one rational example with both full-threshold
constraints and separated exact system-only/assisted bounds. The general
phenomenon and SDP methods are not new. No claim is made that this is the
first example in the constrained class without external assessment.

## Coupled simplex lower bound

[Kutyniok, Pezeshki, Calderbank and Liu, arXiv:0709.2340](https://arxiv.org/pdf/0709.2340),
Theorem 4.3, relates tightness and the simplex bound for equidistant,
equidimensional fusion frames. Its distance is chordal subspace distance,
and its robustness objective concerns linear estimation under erasures.
The regular-simplex geometry is established material. Our additional
calculation couples the low spectral block to a residual coordinate,
checks a zero Schur complement and full threshold sectors, and evaluates
a measurement-channel witness. The resulting lower expression and its
two upper-bound counterexamples are not stated by that theorem. That
observation leaves open reductions through other frame results.

## Search record and calibrated conclusion

Queries used in this pass included:

- `"POVM" "2-sqrt" sharp`
- `"repeatable" "completion" "diamond" measurement`
- `"POVM" "simplex" perturbation lower bound`
- `"quantum measurement" "repeatable" "perturbation" sharp bound`
- `"POVM" "residual" "gentle" completion`
- `"fusion frame" "simplex" perturbation polar`
- `"measurement" "2√δ" "2−" repeatable`
- `"POVM" "prescribed" "completion" stability`
- `"Naimark" "same-label" perturbation`
- `"repeatable" POVM "diamond norm" approximation`

Literal formula searches were noisy and cannot exclude equivalent notation.
The comparisons above use the primary papers' actual theorem/proof text,
not search snippets. The closest earlier reductions remain documented in
[the general-bound audit](PRESCRIBED_BOUND_REDUCTION_2026-11-01.md),
[polar-construction attribution](CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md)
and [sharpness attribution](PERFECT_PACKING_SHARPNESS_ATTRIBUTION_2026-11-01.md).

The strongest defensible presentation remains a quantitative specialization
with an exact sharp regime and explicit constrained examples. The novelty
question is narrower now: whether this completion-specific sharp theorem,
reference example or coupled lower family has already been published, or
is an immediate consequence a specialist would regard as routine. Search
alone cannot close that question. Status: potentially distinct; novelty unverified.
