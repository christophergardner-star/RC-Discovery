# Attribution scope for reference advantage and imperfect packing

1 November 2026. This records the scope of the new statements, not a
comprehensive novelty determination or independent review.

## Reference advantage

Reference-assisted measurement discrimination, its comparison with
system-only discrimination, and channel-norm optimization are established
topics. [Puchala, Pawela, Krawiec and Kukulski, *Strategies for optimal
single-shot discrimination of quantum measurements*, Physical Review A 98,
042103 (2018)](https://arxiv.org/abs/1804.05856v2) explicitly studies both
approaches for von Neumann measurements. The primary abstract and publication
metadata were inspected for this attribution; no full theorem-level reduction
from that paper to the present constrained example is claimed.

The diamond-norm primal used in the certificate is standard machinery from
[Watrous, *Simpler semidefinite programs for completely bounded norms*,
2012](https://arxiv.org/abs/1207.5726v2). The sign-operator formula for the
system-only optimum follows directly by maximizing signed expectation sums.
Neither the norm characterization nor the existence of reference advantages
in general is claimed as new.

The internally certified statement is narrower: reference advantage occurs
between a POVM satisfying the frozen theorem with `alpha=1` and its own
prescribed residual completion. The retained rational example has system-only
distance at most 0.1161 and diamond distance at least 0.1208. Whether this
particular constrained occurrence adds publishable content is unverified.

## Imperfect packing

The lower-bound construction extends the repository's existing lifted
simplex family with a residual coordinate. Simplex symmetry, a positive
synthesis matrix, and Schur-complement positivity are standard tools. The
new work within the repository is the explicit zero-sum residual coupling,
its admissibility check, and the distinguishing input yielding `L_m(alpha)`.

For fixed `alpha<1`, the lower bound tends to `sqrt(1-alpha^2)` while
`delta=1/m` tends to zero. In the joint small-error regime, it approaches
`sqrt(1-alpha^2+delta)` to leading order. This is a lower-bound family, not
a proof of a matching upper theorem. Exact counterexamples also exclude
two proposed extensions of the perfect-packing bound.

The earlier [general-bound reduction](PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
and [perfect-packing attribution note](PERFECT_PACKING_SHARPNESS_ATTRIBUTION_2026-11-01.md)
remain applicable. In particular, the sharp subclass proof uses a rank-two
trace-distance calculation explicitly present in Regula--Lami--Datta's
gentle-measurement analysis. No new general operator inequality is asserted.

This turn did not complete an exhaustive literature search for the coupled
simplex formula or the constrained reference example. The requested external
assessment remains correctness, prior publication or implication, and
usefulness of these precise statements. Their exact internal certificates
do not answer the publication-priority question.
