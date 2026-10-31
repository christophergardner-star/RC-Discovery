# Controlling γ_F: residual-to-extra-outcome closure

**Date:** 31 October 2026  
**Depends on:** Naimark dimension-free ν theorem candidate in RC-Discovery `theory/dimension_free_nu_via_naimark.md`

## The bottleneck

After the Naimark construction of a nearby repeatability-admissible POVM F, the composite RC bound still contains γ_F (repeatability spectral gap of F). Question: can γ_F be controlled from (α, δ) alone?

## Clean solution

Route residual mass to an **extra outcome** rather than folding it into the original m labels.

Construction:
1. Synthesis packing α = σ_min(T) > 0 → polar isometry U → orthogonal projectors Q_j on the packed sectors.
2. Set F_j = Q_j for j = 1,...,m.
3. Set F_{m+1} = I - Σ_{j=1}^m Q_j (residual / reject outcome).

Then each F_j (j ≤ m) is an **exact orthogonal projector**. Spectrum ∈ {0,1}, so

$$
\gamma_F = 1
$$

exactly — independent of α, δ, m, d.

## Compatibility with Naimark ν bound

The Naimark theorem candidate constructs F via an isometry V near W and sets F_j = V* Λ_j V. That can be arranged so labels 1..m receive the packed sectors and label m+1 receives residual (extend the outcome space by one). The same Stinespring distance bound applies, still **m,d-independent**:

$$
\nu = O\big(\sqrt{1-\alpha^2}+\sqrt{\delta}\big).
$$

(The square-root δ matches the known adversarial lower bound.)

## Composite certificate (conjectural until Naimark proof is audited)

$$
\|\Phi_E - \Pi\|_\diamond
\le
\nu + \sqrt{\frac{2(\eta+3\nu)}{\kappa \cdot 1}}
=
O\Big(\sqrt{1-\alpha^2}+\sqrt{\delta}\Big)
+
O\Big(\sqrt{\eta/\kappa}\Big).
$$

All parameters are controlled without outcome-count or dimension factors, once the Naimark ν proof is accepted.

## Status

| Piece | Status |
|-------|--------|
| Packing α → orthogonal Q_j | Internally solid |
| Dimension-free ν via Naimark | Theorem candidate in RC-Discovery; needs independent audit |
| γ_F = 1 via extra residual outcome | Immediate from construction |
| Composite dimension-free certificate | Follows if Naimark audit passes |

## Caveat

Adding an extra outcome changes the classical alphabet (m → m+1). For applications that require the same outcome labels, residual must be folded back and γ_F may again be a free parameter — or bounded by a separate argument. For existence of a nearby record process with dimension-free error, the extra-outcome route is enough.
