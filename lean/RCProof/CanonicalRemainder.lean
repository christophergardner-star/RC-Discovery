import RCProof.CanonicalSplit
import RCProof.RemainderMap

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

/-- Construct the physical residual square root and all structural inputs of
the sharp residual-map estimate from the canonical POVM construction. -/
theorem canonical_remainder_data (E : FinitePOVM d o) (c : ℝ) (hc : 0 ≤ c)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    let U := polarIsometry (canonicalSynthesis E c)
    let R := 1 - U * Uᴴ
    ∃ G : Matrix d d ℂ, G.PosSemidef ∧ G * R = 0 ∧
      ((1 - packingAlpha (canonicalSynthesis E c) ^ 2 * c) • (1 - R) - G * G).PosSemidef ∧
      (∑ j, (E.effect j - selectedEffect E c j)) = (R + G) * (R + G) ∧
      ∀ j, R * selectedEffect E c j * R = 0 := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  let D := sectorRoot E c
  let R := 1 - U * Uᴴ
  let Z := (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) - H * D * D * H
  have hU : Uᴴ * U = 1 := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hUH : U * H = T := polar_factorization T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hH : Hᴴ = H := polarRoot_hermitian T
  have hD : Dᴴ = D := (sectorRoot_positive E c).1.eq
  have hZ : Z.PosSemidef := by
    have hp := gram_bound_of_norm (D * H) 1 zero_le_one (canonical_selected_contraction E c hT)
    simpa only [Matrix.conjTranspose_mul, hH, hD, one_pow, one_smul, Matrix.mul_assoc, Z] using hp
  let Δ := U * Z * Uᴴ
  have hΔ : Δ.PosSemidef := hZ.mul_mul_conjTranspose_same U
  let G := positiveRoot Δ hΔ
  have hG : G.PosSemidef := positiveRoot_positive Δ hΔ
  have hGG : G * G = Δ := positiveRoot_square Δ hΔ
  have hRU : R * U = 0 := residual_annihilates_isometry U hU
  have hRp := residual_projection_properties U hU
  have hRh : Rᴴ = R := hRp.1
  have hRR : R * R = R := hRp.2.1
  have hUR : Uᴴ * R = 0 := by
    have hh := congrArg Matrix.conjTranspose hRU
    simpa only [Matrix.conjTranspose_mul, hRh, Matrix.conjTranspose_zero] using hh
  have hΔR : Δ * R = 0 := by
    change (U * Z * Uᴴ) * R = 0
    rw [Matrix.mul_assoc, hUR, Matrix.mul_zero]
  have hGR : G * R = 0 := by
    apply (Matrix.conjTranspose_mul_self_mul_eq_zero G R).mp
    rw [hG.1.eq, hGG]
    exact hΔR
  have hRG : R * G = 0 := by
    have hh := congrArg Matrix.conjTranspose hGR
    simpa only [Matrix.conjTranspose_mul, hRh, hG.1.eq, Matrix.conjTranspose_zero] using hh
  refine ⟨G, hG, hGR, ?_, ?_, ?_⟩
  · have hp := (canonical_selected_defect_upper E c hc).mul_mul_conjTranspose_same U
    rw [hGG]
    convert hp using 1
    dsimp only [R, Δ, Z, H, D, T]
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul,
      Matrix.mul_one, smul_sub]
    module
  · rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_add, hRR, hGR, hRG, hGG]
    simp only [add_zero, zero_add]
    rw [Finset.sum_sub_distrib, E.normalized, selectedEffect_sum]
    change 1 - (T * D) * (T * D)ᴴ = R + Δ
    rw [← hUH, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, hD, hH]
    dsimp only [R, Δ, Z]
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, Matrix.mul_assoc]
    abel
  · intro j
    have hRTD : R * (T * D) = 0 := by
      rw [← hUH, ← Matrix.mul_assoc, ← Matrix.mul_assoc, hRU, Matrix.zero_mul, Matrix.zero_mul]
    rw [selectedEffect_factor]
    change R * ((T * D) * sectorCoordinate E c j * (T * D)ᴴ) * R = 0
    rw [← Matrix.mul_assoc R ((T * D) * sectorCoordinate E c j), ← Matrix.mul_assoc R (T * D), hRTD]
    simp

end RCProof
