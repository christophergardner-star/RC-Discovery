# The Missing Piece: Residual Spectral Radius

**Date:** 31 October 2026  
**Status:** Precise identification of the remaining invariant

## Counterexample confirmation

The extra-outcome construction fails, as shown by the exact example

\[
E_1 = \operatorname{diag}(1,0,1/2),\qquad
E_2 = \operatorname{diag}(0,1,1/2)
\]

with \(\alpha = 1\). Dumping residual into a new projective outcome produces measurement-channel distance \(2\). The Naimark-close construction preserves small \(\nu\) precisely because it does **not** do this.

## Residual spectral radius

Let \(R = I - \sum_j Q_j\) be the projector onto the orthogonal complement of the packed space produced by the polar factor of the synthesis operator.

Define the **residual spectral radius** of the original POVM by

\[
\rho_{\rm res}
:=
\max_j \| R E_j R \|_\infty.
\]

This quantity measures the largest eigenvalue that any original effect can have outside the packed near-unit sectors. It is independent of the packing parameter \(\alpha\).

## Relation to the Naimark-close completion

In the Naimark construction of `dimension_free_nu_via_naimark.md`, the completed effects satisfy

\[
F_j = Q_j + R_{\rm residual\, contribution},
\]

where the residual contribution is a small perturbation (controlled by \(\varepsilon = O(\sqrt{1-\alpha^2} + \sqrt{\delta})\)) of the original residual operators \(R E_j R\).

Consequently, for small \(\varepsilon\),

\[
\|(I - Q_j) F_j (I - Q_j)\|_\infty
\le
\rho_{\rm res} + O(\varepsilon).
\]

Therefore the repeatability spectral gap of the completed POVM obeys

\[
\gamma_F
\ge
1 - \rho_{\rm res} - O\!\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big),
\]

provided the right-hand side is positive.

## What this means

- Packing \(\alpha\) and spectral threshold \(\delta\) control the protected sectors and the measurement-channel distance \(\nu\).
- They do **not** control the residual measurement statistics on the orthogonal complement.
- The missing information is exactly \(\rho_{\rm res}\).

If \(\rho_{\rm res}\) is bounded away from 1, the Naimark-close completion has both small dimension-free \(\nu\) and a quantitative spectral gap \(\gamma_F\). The Record-Margin theorem then applies with no extra outcome and with the original record margin \(\kappa\).

If \(\rho_{\rm res}\) can be arbitrarily close to 1 while \(\alpha\) stays bounded away from 0, then no bound on \(\gamma_F\) depending only on \((\alpha,\delta)\) exists, and an additional residual invariant is required.

## Revised bottleneck

\[
\boxed{
\text{Bound }\rho_{\rm res}\text{ (or prove it is not controlled by }\alpha,\delta\text{ alone).}
}
\]

This is the precise missing piece.
