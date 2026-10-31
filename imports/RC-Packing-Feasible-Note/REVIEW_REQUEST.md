# External review request — Theorems 1–3

**Date:** 31 October 2026  
**Package:** https://github.com/Cruxy234/RC-Packing-Feasible-Note  
**Manuscript:** `paper/arxiv_ready.md`

## Request

We request independent checking of:

1. **Theorem 1 (Rank-1 rounding)** — polar factor + sharp bound $\delta+(1-\alpha)$.
2. **Theorem 2 (Higher rank)** — same bound via synthesis polar factor.
3. **Theorem 3 (MQC)** — composition with Record-Margin Stability and the stated $C$.

## Minimal reading path

1. `paper/arxiv_ready.md` (full short note)
2. `lean/RCProof/Core.lean` (machine-checked $\sqrt{1-c^2}\le\sqrt{2-2c}$ and polar residual)
3. `theory/packing_feasible_moving_povm.md` (extended discussion)

## Specific questions for reviewers

- Is the phase-aligned polar argument complete for operator-norm control of rank-1 projectors?
- Does the higher-rank lift introduce a hidden dimension factor in the leading constant?
- Is the diamond-norm prefactor $C=6$ (working) / $C=8$ (conservative) stated carefully enough relative to the Record-Margin black box?
- Is the distinction from de la Salle / Kitaev accurately drawn?

## How to respond

- Open an issue or PR on https://github.com/Cruxy234/RC-Packing-Feasible-Note
- Or comment on the corresponding issue/PR in https://github.com/christophergardner-star/RC-Discovery (if present)

Thank you for any time spent on verification.
