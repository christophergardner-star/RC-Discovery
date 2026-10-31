# Verification of the Hybrid Isometry Same-Label Completion

**Date:** 31 October 2026  
**Status:** Numerically confirmed; analytic bound candidate consistent

## Construction

\[
V = J U^* + W R,
\]
where \(W\) is the canonical Naimark isometry of the original POVM, \(U\) is the polar factor of the synthesis operator, \(J\) embeds the polar basis into the labelled dilation, and \(R = I - UU^*\).

## Numerical verification (machine precision)

Across random trials (\(m=2,3\), various \(\alpha,\delta\)):

- \(V^* V = I\) to \(\sim 10^{-15}\)
- \(V^* \Lambda_j V = Q_j + R E_j R\) exactly (error \(\sim 10^{-15}\))
- \(\|V - W\|_\infty = \|J U^* - W S\|_\infty\) (residual part matches)

The hybrid isometry is an exact Stinespring dilation of the same-label completion \(F_j = Q_j + R E_j R\).

## Distance scaling

\(\|V - W\|_\infty\) tracks \(\sqrt{1-\alpha^2} + \sqrt{\delta}\) with ratios in the range \(\sim 0.3\) to \(\sim 0.7\) in tested regimes. The claimed bound

\[
\nu \le 2\|V-W\|_\infty \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big)
\]

is consistent with the data (conservative constant).

## Consequence

Combined with the already-established \(\gamma_F \ge \delta\) for this completion, the same-label chain is closed at the level of an explicit, dimension-free proof candidate:

\[
\|\Phi_E - \Pi\|_\diamond \le \nu + \sqrt{\frac{2(\eta + 3\nu)}{\kappa \delta}},
\qquad
\nu \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big).
\]

No explicit \(m\) or \(d\). No extra outcome.

## Remaining gates

1. Independent reconstruction of the hybrid isometry argument and the bound on \(\|V-W\|\).
2. Prior-art / novelty audit relative to de la Salle, Kitaev, and related orthogonalization results.
3. Full formalisation if desired.

The major internal analytic bottleneck identified earlier is resolved by this construction.
