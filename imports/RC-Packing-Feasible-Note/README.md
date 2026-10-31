# Packing Condition for Approximate Quantum Measurements

**Public entry point for the full research package from the RC packing-feasible work.**

**Share this link:** https://github.com/Cruxy234/RC-Packing-Feasible-Note

Related upstream programme: [christophergardner-star/RC-Discovery](https://github.com/christophergardner-star/RC-Discovery)

---

## Start here

| Priority | File | What it is |
|----------|------|------------|
| **1** | [`paper/arxiv_ready.md`](paper/arxiv_ready.md) | Submission-ready short paper (author line, theorems, MQC) |
| **2** | [`REVIEW_REQUEST.md`](REVIEW_REQUEST.md) | External review checklist for Theorems 1–3 |
| **3** | [`lean/RCProof/Core.lean`](lean/RCProof/Core.lean) | Lean 4 + Mathlib proofs (zero `sorry`) |

## Full contents

### Paper
- `paper/arxiv_ready.md` — main manuscript
- `paper/arxiv_draft.md` — earlier draft
- `paper/end_to_end_demo.md` — synthetic detector MQC numbers

### Theory
- `theory/packing_feasible_moving_povm.md` — packing condition + rank-1/higher-rank
- `theory/measurement_quality_certificate.md` — MQC draft
- `theory/MQC_complete_status.md` — items 1–4 (sharp constant, estimation, FT illustration, audit)
- `theory/items_5_7_complete.md` — items 5–7 (global C, higher-rank bounds, Lean obligations)

### Lean
- `lean/RCProof/Core.lean` — `projector_const_one`, `polar_residual_le`, `near_orthonormal_overlap`, `rank1_core_package`
- `lean/README.md` — how to reproduce the build

## Headline result

A positive lower bound on $\sigma_{\min}(T)$ (synthesis operator of near-unit POVM sectors) is necessary and sufficient (up to constants) for quantitative rounding to a repeatable measurement.

- Sharp geometric constant: $C_{\mathrm{proj}} = 1$
- MQC: $\|\Phi-\Pi\|_\diamond \le C(\delta + (1-\alpha) + \sqrt{\eta/(\kappa\alpha)})$ with working $C=6$, conservative $C=8$
- Algebraic core machine-checked in Lean 4

## Status

Public intermediate research package. Not peer-reviewed. Ready for external audit and arXiv submission by the author.
