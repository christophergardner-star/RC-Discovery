# One changing coupling switches the preferred completion

1 November 2026.

The comparison now has a compact example: one real-matrix family on complex
dimension four, with three outcomes and one scalar parameter. Only one
off-diagonal pair changes, while every diagonal entry stays fixed. The
unweighted completion wins at one end and the weighted completion at the other.

The [proof note displays all three matrices](../theory/completion_switch_family.md).
Every entry is a small integer or the parameter t, divided by 40.
The parameter ranges over [2,4], and the spectral threshold is fixed at 3/4.

## Certified result

For every real parameter in the interval:

- The effects form a positive, normalized POVM.
- The full near-unit sectors have ranks (1,1,1).
- The synthesis packing parameter exceeds 0.900373705510, hence exceeds 0.9.
- The frozen theorem gives a uniform bound below 1.871779790, hence below two.

These are whole-interval conclusions, obtained from affine positivity,
fixed diagonal and trace bounds, and an exact uniform residual certificate.
They are not inferred from a sampled parameter grid.

Exact endpoint distance enclosures are:

| Parameter | Unweighted distance | Weighted distance | Closer completion |
| --- | --- | --- | --- |
| t = 2 | [0.397564913, 0.397565478] | [0.398080262, 0.398080826] | Unweighted |
| t = 4 | [0.471373922, 0.471374518] | [0.471278745, 0.471279340] | Weighted |

The strict separation exceeds 0.000514784608 at t = 2 and 0.000094582398
at t = 4. All intervals are rounded outward.

The proof establishes continuity of both completed channels and their
distances. Therefore at least one parameter strictly between 2 and 4 gives
equal distances, with opposite preferences near the two ends. Uniqueness
and the exact location of that point are not asserted.

The input measurements themselves satisfy the exact distance formula
diamond_distance(E(t), E(s)) = abs(t-s)/20. All their outcome probabilities
on coordinate-basis inputs are unchanged. Thus this example isolates an
off-diagonal change that can reverse which correction is closer.

## What was checked

The endpoint checks reuse the exact rational spectral, polar, and SDP
certificate framework. The new uniform certificate uses fixed approximate
eigenvectors only as rational witnesses: the exact residuals at the two ends
bound their residuals everywhere by convexity. A rank-one projection estimate
then bounds the entire synthesis family away from singularity.

All certificate acceptance decisions use Python integers and fractions.
Verification passed with scientific Python packages disabled. Ten deliberate
corruption or execution-mode checks were rejected, and all 73 positivity
checks also passed an independent integer-determinant audit.

This is a finite computer-assisted proof of the displayed family result,
with a written analytical argument for the continuous interval. Its logic
has not been fully formalized in Lean or reviewed by an external specialist.
No novelty, optimality, or practical-superiority claim follows from it.

## Artifacts and reproduction

- [Explicit family and full proof](../theory/completion_switch_family.md)
- [Exact certificate data](completion_switch_family_2026-11-01/certificates.json)
- [Exact verification results and source hashes](completion_switch_family_2026-11-01/verification.json)
- [Corruption controls and determinant audit](completion_switch_family_2026-11-01/audit.json)
- [Numerical illustration of the distance curves](completion_switch_family_2026-11-01/numerical_curve.json)

Run with standard Python:

    python -I -S experiments/verify_completion_switch_family.py
    python experiments/check_completion_switch_family.py

To regenerate proposed witnesses and the numerical illustration:

    .venv-audit/Scripts/python.exe experiments/build_completion_switch_family.py

Only the rational certificates establish the endpoint comparisons. The
numerical curve suggests an equality point between 2.25 and 2.5; that narrower
location is an illustration, not a certified assertion. The rigorous existence
interval remains (2,4).

The earlier six-dimensional certificates remain valid. This family provides
a simpler presentation and an explicit path joining opposite preferences.
The frozen theorem and its literature status are unchanged.
