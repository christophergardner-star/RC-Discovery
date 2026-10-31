# Lean 4 formalisation

## Status

**Build: succeeded** (Lean 4.35.0 + Mathlib, zero `sorry`).

## File

`RCProof/Core.lean` — fully machine-checked proofs of:

1. **`projector_const_one`** — `√(1−c²) ≤ √(2−2c)` for `c ∈ [0,1]`  
   (sharp geometric constant `C_proj = 1`)

2. **`polar_residual_le`** — if `α ≤ σ ≤ 1` then `|σ−1| ≤ 1−α`  
   (polar factor residual)

3. **`near_orthonormal_overlap`** — `√(2−2c) ≤ ε ⇒ 1−c ≤ ε²/2`  
   (necessity / continuity of overlap)

4. **`rank1_core_package`** — packages the three facts together

## What is *not* formalised

- Full Hilbert-space / matrix SVD polar decomposition (uses Mathlib matrix theory beyond this file)
- Diamond-norm channel estimates
- Higher-rank synthesis operator as a Lean object

The real-arithmetic content that underpins the sharp constant and polar residual is fully verified.

## Reproduce

```bash
lake build RCProof.Core
```

Requires Lean 4.35.0 and Mathlib.
