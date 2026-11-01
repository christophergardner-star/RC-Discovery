# Reference advantage, imperfect packing, and the revised short paper

1 November 2026. Internally derived and checked; external review, full Lean
formalization, and literature novelty remain open.

## 1. Reference advantage is now exact

A rational complex measurement on dimension ten, with eight outcomes,
`alpha=1`, and `delta=17/100`, satisfies

\[
\nu_{\rm sys}\le0.1161<0.1208\le\nu_\diamond.
\]

The advantage is at least **0.0047**. These are rigorous bounds, not asserted
exact values for the two norms. The example is a rationalized, regularized
version of the earlier numerical candidate.

The [proof](../theory/reference_advantage.md) and
[certificate](reference_advantage_2026-11-01/certificate.json) check every
frozen hypothesis. All 256 signed effect sums give the system-only upper
bound. A feasible rational diamond-norm primal gives the reference-assisted
lower bound. Exact normalization and strict spectral isolation avoid any
spectral-to-polar approximation.

The [verification](reference_advantage_2026-11-01/verification.json) passes.
An [independent audit](reference_advantage_2026-11-01/audit.json) checks
**289 positive-definite matrices, 5,764 integer leading minors, and 13
rejection controls**. No solver tolerance enters this acceptance decision.

## 2. Imperfect packing: lower bound and two exact vetoes

The [coupled simplex proof](../theory/imperfect_packing_lower_bound.md)
constructs an admissible family for each even `m>=4` and `0<alpha<=1`, with
`delta=1/m` and

\[
\nu\ge L_m(\alpha)=
\sqrt{\frac{(m-2)[m-(m-1)\alpha^2]}
{m(m-2)+m-(m-1)\alpha^2}}.
\]

For fixed `alpha<1`, this tends to `sqrt(1-alpha^2)` as the defect tends to
zero. If `1-alpha^2=O(1/m)`, it has leading scale
`sqrt(1-alpha^2+delta)`, with coefficient one. This establishes a necessary
joint scale; it does not determine the sharp joint upper bound.

With `B(delta)=2*sqrt(delta)/(2-sqrt(delta))`, two natural proposed upper
extensions fail:

| Proposed upper bound | Certified counterexample |
|---|---|
| `2*(1-alpha)+B(delta)` | `m=64`, `alpha=9/10`, `delta=1/64`: proposed upper `1/3`, but squared witness distance `80414/398097>1/9`. |
| `sqrt(1-alpha^2+B(delta)^2)` | Rational dimension-seven example, `alpha=13/27`, `delta=1/6`: distance at least **1.0405**, proposed bound at most **1.0156**. |

The first follows from the analytic family. The second has a
[small rational certificate](imperfect_packing_2026-11-01/veto_certificate.json)
with exact effects determined by its parameters, a rational system-only input,
and a signed expectation witness. Its
[verification](imperfect_packing_2026-11-01/veto_verification.json) and
[audit](imperfect_packing_2026-11-01/veto_audit.json) pass **42 independent
integer leading minors and ten rejection controls**. The frozen theorem is
not contradicted.

The [numerical search](imperfect_packing_2026-11-01/search.json) checked
**56 structured cases, 711 accepted random/adaptive cases, and seven SDPs**;
nine random proposals failed the theorem hypotheses and were rejected.
All seven retained SDPs report `optimal` primal and dual statuses. The largest
gap is below `3.69e-8`, and the largest measured feasibility violation is below
`2.47e-8`. The floating-point search suggested the second veto; only the
subsequent rational certificate establishes it rigorously. No numerical
violation of the frozen bound was found.

## 3. Revised review paper

The [PDF](../paper/prescribed_repeatable_completion.pdf), generated Markdown,
LaTeX, and bibliography now include:

- **Theorem 7:** the full analytic perfect-packing proof and attaining family.
- **Proposition 8:** exact reference advantage, with a pinned certificate supplement.
- **Proposition 9:** the coupled simplex lower bound, with a pinned analytic
  supplement; the two failed extensions follow it.

The paper remains **twelve pages including references**, with **33 numbered
equations and twelve references**. The frozen general theorem is unchanged.
The source explicitly attributes standard discrimination and trace-distance
machinery, and keeps general joint optimality and novelty open.

Document verification checked source/artifact hashes, sequential equations,
resolved citations, PDF metadata and text, and exact agreement of the new
reported bounds with their certificate outputs. All twelve pages were
rendered; the contact sheet and the two new mathematical pages were visually
inspected. There were no overflow, missing-glyph, or unresolved-reference
findings. The known Fontconfig environment warnings did not prevent building
or rendering. See the [build manifest](short_paper_build/manifest.json) and
[document checks](short_paper_build/document_checks.json).

## Reproduction and limits

Exact checks need only ordinary Python:

```powershell
python -I -S experiments/verify_reference_advantage.py
python -I -S experiments/check_reference_advantage.py
python -I -S experiments/verify_imperfect_packing.py
python -I -S experiments/check_imperfect_packing.py
```

The numerical search uses the existing NumPy/CVXPY audit environment:

```powershell
.venv-audit/Scripts/python.exe experiments/search_imperfect_packing.py
```

The manuscript is built and checked with:

```powershell
python scripts/build_short_paper.py
python scripts/check_short_paper.py
```

The [attribution note](../literature/REFERENCE_AND_PACKING_ATTRIBUTION_2026-11-01.md)
states the limited literature assessment. The exact reference advantage and
upper-bound vetoes are closed internally. General sharp upper control for
`alpha<1`, external reconstruction, and publication priority are not closed.
