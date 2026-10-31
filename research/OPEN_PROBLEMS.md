# Open Problems

Updated after the independent moving-POVM audit on 31 October 2026.

## Resolved or substantially narrowed

### No-go side

A theorem based only on

- small idempotence defect,
- large record margin,
- almost reachable records,
- almost norm-1 POVM effects

is impossible.

The regular-simplex family defeats all of those local diagnostics simultaneously.

### Binary side

For two outcomes, moving the POVM is possible under explicit reachability and edge-gap control.

See:

- theory/moving_povm_boundary.md

### Many-outcome geometric side

The synthesis operator

[
T:igoplus_joperatorname{ran}(P_j)	omathcal H,
qquad
(x_j)mapstosum_jx_j
]

is now a concrete global conditioner.

If

[
sigma_{min}(T)>0,
]

the polar factor gives a constructive simultaneous orthogonalization of all near-unit sectors, at arbitrary rank.

The POVM condition also gives an automatic upper singular-value bound.

See:

- theory/packing_conditioned_rounding.md

## A. Outcome-count factor: internally resolved at the existence level

A common Naimark-dilation construction now gives a repeatability-admissible POVM whose measurement channel is within an absolute, outcome-count-independent distance of the original measurement channel.

See:

- theory/dimension_free_nu_via_naimark.md
- experiments/test_dimension_free_naimark.py

The current theorem candidate gives

[
nu
=
|mathcal M_E-mathcal M_F|_diamond
=
Oleft(
sqrt{1-alpha^2}+sqrtdelta
right),
]

with no dependence on (m) or (d).

This corrects the earlier conjectured linear dependence on (delta); the explicit lower-bound family already shows that (sqrtdelta) is generically necessary under spectral-threshold-only assumptions.

### New highest-value target

The remaining bottleneck is no longer the (m)-factor.

It is now:

> Can the repeatability spectral gap of the Naimark-completed POVM be bounded directly from the packing/spectral data, or can the RC record-rounding step be reformulated without a separate gap parameter?

A secondary question is whether the same outcome-independent bound can be proved for the explicit residual formula

[
F_j=Q_j+RE_jR.
]

## B. Sharp spectral-threshold rate

A linear (O(delta)) movement bound is false under spectral-threshold assumptions.

The current constructive upper bound is of square-root type.

Open:

- optimize constants,
- determine the exact exponent in the mixed packing/spectral regime,
- prove a matching converse beyond the explicit adversarial family.

## C. Necessity of the synthesis conditioner

Prove a quantitative converse:

> if (sigma_{min}(T)) is small, how large must any label-preserving repeatable rounding move be?

The regular simplex gives the singular endpoint (alpha=0). A useful theorem should interpolate quantitatively away from that endpoint.

## D. Prior-art comparison

The moving-POVM theory must be compared directly with:

- de la Salle (2022), *Orthogonalization of Positive Operator Valued Measures*,
- the finite-dimensional projectivization results cited there,
- classical polar / Löwdin orthogonalization,
- frame and fusion-frame perturbation theory.

The main question is whether the RC combination of synthesis conditioning + repeatability + record-margin/idempotence + diamond-norm control is genuinely new.

## E. Multi-record redundancy geometry

Obtain sharp (kappa_R) rates for many mixed records and correlated fragments.

## F. Microscopic metastability

Apply the record-structured transfer theorem to an explicit open-system model and derive (eta,delta,kappa,gamma) from microscopic parameters.

## G. Experimental certification

Find protocols that estimate enough of (eta,kappa,gamma), and the packing conditioner, without full process tomography.

## H. Independent audit

Current priority order:

1. packing-conditioned many-outcome theorem,
2. binary moving-POVM theorem,
3. metastability transfer theorem,
4. redundancy extension,
5. formalization of the elementary core after theorem statements stabilize.

The sharp Record-Margin and POVM spectral-gap proofs have now survived independent reconstruction.
