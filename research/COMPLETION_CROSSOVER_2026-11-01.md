# Certified localization of an equality point

Date: 1 November 2026. All channel distances use the full diamond norm.

For the explicit real four-dimensional, three-outcome family in
[the family proof](../theory/completion_switch_family.md), let

\[
g(t)=\|\mathcal M_{E(t)}-\mathcal M_{F^w(t)}\|_\diamond
     -\|\mathcal M_{E(t)}-\mathcal M_{F^u(t)}\|_\diamond.
\]

There exists at least one \(t_*\) with \(g(t_*)=0\) and

\[
\boxed{\frac{233690021}{100000000}<t_*<
       \frac{233690023}{100000000}}.
\]

The endpoints are exactly **2.33690021** and **2.33690023**, and the width
is exactly \(1/50000000=2\times10^{-8}\). Equivalently, at least one equality
point is within \(10^{-8}\) of 2.33690022. This is an exact rational enclosure,
not an exact formula for the root. It neither proves uniqueness inside the
bracket nor excludes further equality points elsewhere in [2,4].

## Exact endpoint evidence

The following bounds have been rounded outward from exact rational results:

| Parameter | Lower bound on g(t) | Upper bound on g(t) | Strictly closer completion |
|---|---:|---:|---|
| 2.33690021 | 0.000000000006606 | 0.000000000018991 | Unweighted |
| 2.33690023 | -0.000000000019938 | -0.000000000007658 | Weighted |

The verifier checks the actual rational family inputs, full spectral-sector
ranks, spectral and polar approximation errors, and primal/dual SDP witnesses
for the full measurement-channel distance, including reference systems.
It also reruns the existing whole-interval certificate. Thus these are
strict orderings for the exact constructed completions, not just the rounded
matrices supplied to a numerical solver.

The existing uniform certificate proves positivity, fixed full sector ranks,
and \(\alpha(t)>0.9\) throughout [2,4]. The continuous spectral and polar
constructions imply continuity of both distances. The intermediate value
theorem applied to the strict signs above proves the displayed existence
statement. The analytic error bounds and continuity argument remain written
mathematics; the entire proof has not been encoded in Lean.

## Verification and reproduction

- [Rational certificate data](completion_crossover_2026-11-01/certificates.json)
- [Exact results and source hashes](completion_crossover_2026-11-01/verification.json)
- [Independent determinant and corruption audit](completion_crossover_2026-11-01/audit.json)
- [Numerical proposal diagnostics](completion_crossover_2026-11-01/proposal_diagnostics.json)

No third-party packages or network access are needed to check the retained data:

```powershell
python -I -S experiments/verify_completion_crossover.py
python -I -S experiments/check_completion_crossover.py
```

Both commands passed. The audit rejected 11 deliberately corrupted certificates
and optimized Python, and independently confirmed all 139 positivity decisions
across the uniform family and new endpoints using integer Bareiss determinants.
These checks audit finite certificate inequalities, not the literature priority
or every step of the analytic proof.

Optional witness regeneration uses mpmath 1.3.0 at 60 decimal digits for spectral
and polar proposals, rounded to denominator \(10^{40}\), and SCS through CVXPY
for SDP proposals. Exact rational checking decides acceptance. Solver versions
and settings are retained in the diagnostics; numerical proposals need not be
identical on other systems.

```powershell
.venv-audit/Scripts/python.exe experiments/build_completion_crossover.py
python -I -S experiments/verify_completion_crossover.py
python -I -S experiments/check_completion_crossover.py
```

Initial double-precision witnesses could only certify a wider bracket. Some
attempts with smaller SDP padding failed exact positivity and were rejected.
The retained higher-precision witnesses passed; no acceptance tolerance was
relaxed. The shared certificate verifier and earlier family proof are unchanged.

## Remaining questions

The numerical curve is not globally monotone, so bisection does not establish
uniqueness. A uniqueness claim would need an additional analytic argument or
certified control of the optimal SDP values throughout an interval. No such
claim is made here. The [updated attribution assessment](../literature/CROSSOVER_AND_CONSTRUCTION_ATTRIBUTION_2026-11-01.md)
also distinguishes established constructions from unverified priority of the
specific bounds and comparison. External review remains outstanding.
