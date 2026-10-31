# Updated Prior-Art Assessment: Hybrid Same-Label Packing Theorem

**Date:** 31 October 2026  
**Status:** Deeper search completed; no exact match found for the combined statement or the hybrid isometry construction

## Target statement

Given a POVM with near-unit spectral sectors whose synthesis operator satisfies \(\alpha = \sigma_{\min}(T) > 0\), the same-label residual completion
\[
F_j = Q_j + R E_j R
\]
admits an explicit hybrid Stinespring isometry
\[
V = J U^* + W R
\]
such that
\[
\nu = \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\|V - W\|_\infty \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big),
\]
and the completed measurement satisfies \(\gamma_F \ge \delta\). Composition with Record-Margin Stability then yields a fully dimension-free certificate.

## Additional searches performed

- Hybrid Stinespring isometries and residual completions of POVMs.
- Synthesis-operator polar orthogonalization applied to near-unit POVM sectors for diamond-norm rounding.
- Packing conditions on near-unit sectors controlling repeatability or idempotence of measurements.
- Residual orthogonal-complement constructions in Naimark dilations used for completion rather than joint measurability or ordered residual processes.
- Specific form \(V = JU^* + WR\) or equivalent hybrid labelled embeddings that implement a same-label residual completion.

## Closest related work

- de la Salle (arXiv:2103.14126): almost-orthogonal POVMs close to orthogonal ones (linear, optimal, algebra-preserving). Different hypothesis and conclusion.
- Kitaev (arXiv:2405.02434): almost-idempotent channels to approximate \(C^*\)-algebras. Structural, not constructive packing-conditioned rounding.
- Ordered residual processes and residual collapse (e.g. recent notes on ordered POVMs): use residual tails in Naimark dilations for collapse maps, not for same-label repeatability rounding with packing control.
- Naimark dilation literature for joint measurability (Pellonpää et al.): block-diagonal representations in minimal dilations for compatibility, not for channel-distance control of a residual completion.
- Frame-theoretic synthesis operators: analysis/synthesis for reconstruction, not quantitative diamond-norm rounding to a repeatable POVM.
- Stinespring continuity theorems: apply once channels are already close; do not construct the packing-conditioned move.

## Verdict

No reference was found that states the combined packing-conditioned same-label theorem, nor the specific hybrid isometry construction \(V = JU^* + WR\) that realises the residual completion while controlling the measurement-channel distance in a dimension-free manner.

The ingredients (polar decomposition, Naimark/Stinespring, residual subspaces, almost-orthogonal rounding) are classical or established. The combination that produces a dimension-free same-label certificate from a synthesis packing condition appears to be new.

## Caveats

This remains a literature search, not a formal novelty certificate. A specialist may know of an unpublished, differently phrased, or non-English result. The hybrid isometry argument itself still requires independent mathematical audit.

## Recommendation

The prior-art risk for the combined statement continues to appear low. Proceed with independent reconstruction of the hybrid isometry bound, then expose the short/long paper to external review.
