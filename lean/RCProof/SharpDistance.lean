import RCProof.TraceInequalities
import RCProof.Ancilla

/-! Sharp Stinespring comparison on all complex inputs. A shifted telescoping
identity avoids reducing the stabilized induced norm to pure states. -/
namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d y r : Type*} [Fintype d] [Fintype y] [Fintype r]
  [DecidableEq d] [DecidableEq y] [DecidableEq r]

theorem shifted_isometry_bounds (W V : Matrix y d ℂ)
    (hW : Wᴴ * W = 1) (hV : Vᴴ * V = 1)
    (η : ℝ) (hη : 0 ≤ η) (hη1 : η ≤ 1)
    (hf : (realPart (Wᴴ * V) - η • (1 : Matrix d d ℂ)).PosSemidef) :
    ‖W - η • V‖ ≤ Real.sqrt (1 - η ^ 2) ∧
      ‖η • W - V‖ ≤ Real.sqrt (1 - η ^ 2) := by
  have hs : (Real.sqrt (1 - η ^ 2)) ^ 2 = 1 - η ^ 2 := Real.sq_sqrt (by nlinarith)
  have hp := hf.smul (show 0 ≤ 2 * η by positivity)
  constructor
  · apply norm_le_of_gram _ _ (Real.sqrt_nonneg _)
    rw [hs]
    convert hp using 1
    simp only [realPart, Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
      star_trivial, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      Matrix.sub_mul, Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, hW, hV]
    module
  · apply norm_le_of_gram _ _ (Real.sqrt_nonneg _)
    rw [hs]
    convert hp using 1
    simp only [realPart, Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
      star_trivial, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      Matrix.sub_mul, Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, hW, hV]
    module

lemma shifted_telescoping (W V : Matrix y d ℂ) (X : Matrix d d ℂ) (η : ℝ) :
    W * X * Wᴴ - V * X * Vᴴ =
      (W - η • V) * X * Wᴴ + V * X * (η • W - V)ᴴ := by
  simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul, star_trivial,
    Matrix.sub_mul, Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul]
  module

/-- No positivity, Hermiticity, rank or trace-normalization hypothesis on X. -/
theorem sharp_isometry_trace_distance (W V : Matrix y d ℂ)
    (hW : Wᴴ * W = 1) (hV : Vᴴ * V = 1)
    (η : ℝ) (hη : 0 ≤ η) (hη1 : η ≤ 1)
    (hf : (realPart (Wᴴ * V) - η • (1 : Matrix d d ℂ)).PosSemidef)
    (X : Matrix d d ℂ) :
    traceNorm (W * X * Wᴴ - V * X * Vᴴ) ≤
      2 * Real.sqrt (1 - η ^ 2) * traceNorm X := by
  obtain ⟨hleft, hright⟩ := shifted_isometry_bounds W V hW hV η hη hη1 hf
  have hnW := isometry_norm_le_one W hW
  have hnV := isometry_norm_le_one V hV
  have hnX := traceNorm_nonneg X
  rw [shifted_telescoping W V X η]
  calc
    _ ≤ traceNorm ((W - η • V) * X * Wᴴ) + traceNorm (V * X * (η • W - V)ᴴ) := traceNorm_add _ _
    _ ≤ ‖W - η • V‖ * traceNorm X * ‖W‖ + ‖V‖ * traceNorm X * ‖η • W - V‖ :=
      add_le_add (traceNorm_mul_sandwich _ _ _) (traceNorm_mul_sandwich _ _ _)
    _ ≤ Real.sqrt (1 - η ^ 2) * traceNorm X * 1 + 1 * traceNorm X * Real.sqrt (1 - η ^ 2) := by
      gcongr
    _ = _ := by ring

theorem sharp_isometry_trace_distance_ancilla (W V : Matrix y d ℂ)
    (hW : Wᴴ * W = 1) (hV : Vᴴ * V = 1)
    (η : ℝ) (hη : 0 ≤ η) (hη1 : η ≤ 1)
    (hf : (realPart (Wᴴ * V) - η • (1 : Matrix d d ℂ)).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm ((W ⊗ₖ (1 : Matrix r r ℂ)) * X * (W ⊗ₖ (1 : Matrix r r ℂ))ᴴ -
      (V ⊗ₖ (1 : Matrix r r ℂ)) * X * (V ⊗ₖ (1 : Matrix r r ℂ))ᴴ) ≤
      2 * Real.sqrt (1 - η ^ 2) * traceNorm X :=
  sharp_isometry_trace_distance _ _ (tensor_isometry W hW) (tensor_isometry V hV)
    η hη hη1 (tensor_overlap_floor W V η hf) X

end RCProof
