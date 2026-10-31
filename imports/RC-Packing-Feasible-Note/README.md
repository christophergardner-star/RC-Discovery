# Packing-Conditioned Same-Label Rounding

**Share this link:** https://github.com/Cruxy234/RC-Packing-Feasible-Note

**Final version:** [`paper/FINAL.md`](paper/FINAL.md)

**Canonical repository:** [christophergardner-star/RC-Discovery](https://github.com/christophergardner-star/RC-Discovery)

**Current status:** [`STATUS.md`](STATUS.md)

## Papers

- **[`paper/FINAL.md`](paper/FINAL.md)** — Clean final version (coefficient-two bound).
- **[`paper/long_paper.md`](paper/long_paper.md)** — Extended development.
- **[`paper/short_paper.md`](paper/short_paper.md)** — Concise version.
- **[`theory/full_proof.md`](theory/full_proof.md)** — Full proof write-up.

## Detailed notes

| File | Content |
|------|---------|
| `STATUS.md` | Current precise status |
| `theory/HARDER_PUSH_2.md` | Careful sharpness search (ratios 0.18–0.47) |
| `theory/HARDER_PUSH.md` | Explicit probes and robustness constants |
| `theory/CLOSING_PROOFS.md` | Analytic arguments for tractable problems |
| `lean/RCProof/Hybrid.lean` | Formalised algebraic core (builds) |
| `lean/RCProof/HybridExtended.lean` | Residual orthogonality (builds) |
| `REVIEW_PACKAGE.md` | Package for external specialists |
| `NOVELTY_STATEMENT.md` | Novelty claim and search scope |

## Headline

Under packing condition \(\alpha = \sigma_{\min}(T) > 0\), the same-label completion admits a hybrid Stinespring isometry such that
\[
\nu \le 2\min\bigl(1,\,\sqrt{1-\alpha^2} + \sqrt{\delta}\bigr),
\qquad
\gamma_F \ge \delta.
\]
The result is internally reconstructed, computationally audited, and partially formalised. Coefficient 2 is a safe majorant with observed slack. Novelty is unverified. Independent external reconstruction of the hybrid distance bound remains the credibility gate.
