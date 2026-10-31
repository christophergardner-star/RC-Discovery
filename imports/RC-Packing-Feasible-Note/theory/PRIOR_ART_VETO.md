# Prior-Art Veto: Combined Same-Label Packing Theorem

**Date:** 31 October 2026  
**Status:** Deep search completed; no exact match found for the combined statement

## Target statement

Given a POVM with near-unit spectral sectors whose synthesis operator satisfies \(\alpha = \sigma_{\min}(T) > 0\), the same-label residual completion
\[
F_j = Q_j + R E_j R
\]
(where \(Q_j\) are the polar projectors and \(R = I - \sum Q_j\)) satisfies:

1. \(\gamma_F \ge \delta\) (spectral gap controlled by the threshold),
2. An explicit hybrid Stinespring isometry \(V = J U^* + W R\) such that
   \[
   \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\|V - W\|_\infty \le 4\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big),
   \]
   with no explicit dependence on the number of outcomes or Hilbert-space dimension.

Combined with Record-Margin Stability this yields a fully dimension-free certificate of closeness to an exactly idempotent record process.

## Literature searched

- de la Salle, Orthogonalization of POVMs (arXiv:2103.14126): almost-orthogonal POVMs close to orthogonal ones in the same von Neumann algebra; linear dependence, optimal. State-dependent or algebra-preserving; does not treat synthesis packing of near-unit sectors nor hybrid residual completion.
- Kempe–Vidick; Ji–Natarajan–Vidick–Wright–Yuen: finite-dimensional orthogonalization lemmas used in quantum games / MIP*. Different hypothesis (self-consistency on a state) and different conclusion.
- Kitaev, Almost-idempotent quantum channels and approximate \(C^*\)-algebras (arXiv:2405.02434): structural approximation for almost-idempotent UCP maps; complementary but does not construct a nearby repeatable measurement via packing geometry.
- Frame / fusion-frame literature (e.g. Casazza et al.): analysis and synthesis operators for frames and framed POVMs; Naimark representation used for reconstruction, not for quantitative rounding to a repeatable POVM with diamond-norm control.
- Stinespring continuity (Kretschmann–Schlingemann–Werner; Shirokov): continuity of dilations for channels that are already close in cb-norm. Does not address the constructive packing-conditioned move from an approximate POVM to a nearby repeatable one.
- Spectral-gap-for-POVMs papers (Kaminker–Polterovich–Shmoish et al.): different notion of spectral gap (Markov / noise operator); not the repeatability gap of a completed measurement.
- Instrument diamond-distance bounds and measurement discrimination literature: general tools, not the specific packing + residual-completion theorem.

## Verdict

No reference was found that states the combined result: synthesis-conditioned packing parameter controlling a same-label residual completion whose measurement-channel distance is dimension-free via an explicit hybrid Stinespring isometry, with spectral gap controlled by the threshold alone.

The ingredients (polar decomposition, Naimark/Stinespring, almost-orthogonal POVM rounding, Stinespring continuity) are classical or established. The combination that produces a dimension-free same-label certificate from a packing condition appears to be new.

## Caveats

- This is a literature search, not a formal novelty proof. A specialist in operator algebras or quantum information may know of an unpublished or differently-phrased result.
- The hybrid isometry argument itself still requires independent mathematical audit.
- Prior art on state-dependent orthogonalization (de la Salle et al.) remains the closest comparison and must be discussed carefully in any paper.

## Recommendation

Proceed to independent reconstruction of the hybrid isometry proof, then draft the short paper. The prior-art risk appears low for the combined statement.
