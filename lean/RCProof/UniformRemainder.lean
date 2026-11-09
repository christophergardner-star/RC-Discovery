import RCProof.UniformThreshold

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

/-- The uniform threshold split gives the exact shared defect needed by the
coupled certificate, including residual effects with selected support. -/
theorem canonical_uniform_remainder_data (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    let U := polarIsometry (canonicalSynthesis E c)
    let C := Real.sqrt c • polarRoot (canonicalSynthesis E c)
    let R := 1 - U * Uᴴ
    ∃ G : Matrix d d ℂ, G.PosSemidef ∧ G * R = 0 ∧
      G * G = U * (1 - C * C) * Uᴴ ∧
      (∑ j, (E.effect j - uniformSelectedEffect E c j)) = (R + G) * (R + G) ∧
      ∀ j, R * uniformSelectedEffect E c j * R = 0 := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  let C := Real.sqrt c • H
  let R := 1 - U * Uᴴ
  have hU : Uᴴ * U = 1 := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hUH : U * H = T := polar_factorization T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hH : Hᴴ = H := polarRoot_hermitian T
  have hCp : C.PosSemidef := (positiveRoot_positive _ _).smul (Real.sqrt_nonneg c)
  have hCu : (1 - C).PosSemidef := (canonical_uniform_filter_bounds E c hc hT).2
  have hZ : (1 - C * C).PosSemidef := by
    have hh := hCu.add (positive_square_upper C hCp 1 (by simpa using hCu))
    simpa only [one_smul, sub_add_sub_cancel] using hh
  let Δ := U * (1 - C * C) * Uᴴ
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
  have hGR : G * R = 0 := by
    apply (Matrix.conjTranspose_mul_self_mul_eq_zero G R).mp
    rw [hG.1.eq, hGG]
    change (U * (1 - C * C) * Uᴴ) * R = 0
    rw [Matrix.mul_assoc, hUR, Matrix.mul_zero]
  have hRG : R * G = 0 := by
    have hh := congrArg Matrix.conjTranspose hGR
    simpa only [Matrix.conjTranspose_mul, hRh, hG.1.eq, Matrix.conjTranspose_zero] using hh
  refine ⟨G, hG, hGR, hGG, ?_, ?_⟩
  · rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_add, hRR, hGR, hRG, hGG]
    simp only [add_zero, zero_add]
    rw [uniform_remainder_sum]
    change 1 - c • (T * Tᴴ) = R + Δ
    rw [← hUH, Matrix.conjTranspose_mul, hH]
    dsimp only [R, Δ, C]
    have hsqrt : Real.sqrt c * Real.sqrt c = c := Real.mul_self_sqrt hc.le
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, Matrix.mul_smul,
      Matrix.smul_mul, smul_smul, hsqrt, Matrix.mul_assoc]
    abel
  · intro j
    rw [uniform_selected_factor E c hc.le hT]
    change R * (U * C * sectorCoordinate E c j * C * Uᴴ) * R = 0
    simp only [← Matrix.mul_assoc, hRU, Matrix.zero_mul]

end RCProof
