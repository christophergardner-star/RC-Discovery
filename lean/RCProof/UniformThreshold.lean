import RCProof.CoupledFilter
import RCProof.CanonicalRemainder

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

/-- The common-threshold split, which retains selected support in the remainder. -/
noncomputable def uniformSelectedEffect (E : FinitePOVM d o) (c : ℝ) (j : o) : Matrix d d ℂ :=
  c • thresholdProjector (E.effect j) (E.positive j).1 c

lemma uniform_remainder_positive (E : FinitePOVM d o) (c : ℝ) (j : o) :
    (E.effect j - uniformSelectedEffect E c j).PosSemidef :=
  threshold_spectral_lower (E.effect j) (E.positive j) c

lemma uniform_selected_sum (E : FinitePOVM d o) (c : ℝ) :
    ∑ j, uniformSelectedEffect E c j = c • (canonicalSynthesis E c * (canonicalSynthesis E c)ᴴ) := by
  simp only [uniformSelectedEffect, ← Finset.smul_sum, ← canonical_range_gram]

lemma uniform_remainder_sum (E : FinitePOVM d o) (c : ℝ) :
    ∑ j, (E.effect j - uniformSelectedEffect E c j) =
      1 - c • (canonicalSynthesis E c * (canonicalSynthesis E c)ᴴ) := by
  rw [Finset.sum_sub_distrib, E.normalized, uniform_selected_sum]

theorem canonical_uniform_filter_bounds (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    let C := Real.sqrt c • polarRoot (canonicalSynthesis E c)
    (C - (packingAlpha (canonicalSynthesis E c) * Real.sqrt c) • 1).PosSemidef ∧
      (1 - C).PosSemidef := by
  dsimp only
  constructor
  · have hh := (packing_polar_lower (canonicalSynthesis E c)).smul (Real.sqrt_nonneg c)
    simpa only [smul_sub, smul_smul, mul_comm (Real.sqrt c)] using hh
  · have hh := (canonical_polar_upper E c hc hT).smul (Real.sqrt_nonneg c)
    simpa only [smul_sub, smul_smul, mul_inv_cancel₀ (Real.sqrt_pos.mpr hc).ne', one_smul] using hh

lemma uniform_selected_factor (E : FinitePOVM d o) (c : ℝ) (hc : 0 ≤ c)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) (j : o) :
    let U := polarIsometry (canonicalSynthesis E c)
    let C := Real.sqrt c • polarRoot (canonicalSynthesis E c)
    uniformSelectedEffect E c j = U * C * sectorCoordinate E c j * C * Uᴴ := by
  dsimp only
  rw [uniformSelectedEffect, canonical_projector_factor]
  have hfac := polar_factorization (canonicalSynthesis E c)
    (Matrix.PosDef.conjTranspose_mul_self _ hT)
  conv_lhs => rhs; lhs; lhs; rw [← hfac]
  conv_lhs => rhs; rhs; rw [← hfac]
  simp only [Matrix.conjTranspose_mul, polarRoot_hermitian, Matrix.mul_smul, Matrix.smul_mul,
    smul_smul, ← pow_two, Real.sq_sqrt hc, Matrix.mul_assoc]

end RCProof
