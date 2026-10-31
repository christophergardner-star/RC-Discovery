# Harder Push 2: Careful Sharpness Search

**Date:** 31 October 2026  
**Status:** Numerical; no ratio approaching 2 found with valid POVMs

## Extreme residual search (initial)

An initial search with rough residual concentration produced one ratio above 5. This was traced to an invalid POVM (failure to preserve positivity and normalisation after concentration).

## Careful POVM construction

With proper positive, normalised effects (threshold plus uniform residual, then exact completion to a POVM):

| Regime | Observed ratio \(\|V-W\| / (\sqrt{1-\alpha^2}+\sqrt{\delta})\) |
|--------|----------------------------------------------------------------|
| High \(\alpha\approx 0.995\), small \(\delta=0.02\) | 0.415–0.472 |
| Single-defect families (previous) | 0.18–0.40 |

No valid POVM in the tested regimes produced a ratio above 0.5.

## Interpretation

- The coefficient 2 remains a safe majorant with substantial slack.
- The earlier high ratio was an artifact of an invalid effect.
- A matching lower bound of order 1 is consistent with the data; a lower bound approaching 2 has not been exhibited.
- Refining the analytic estimate of \(\|JU^* - WS\|\) (replacing the factor 2 by a smaller absolute constant) appears more promising than searching for a saturating family.

## Next concrete step

Derive a tighter majorant for \(\|JU^* - WS\|\) by tracking the polar residual and the square-root threshold separately, rather than using a uniform factor of 2. This is a finite-dimensional calculation with the existing hybrid isometry.
