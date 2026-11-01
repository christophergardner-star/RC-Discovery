import RCProof.Spectral

/-! Construct the polar isometry for a rectangular matrix with positive
definite Gram matrix. No isometry or polar-factor identity is assumed. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

noncomputable def polarRoot (T : Matrix d k ℂ) : Matrix k k ℂ :=
  positiveRoot (Tᴴ * T) (Matrix.posSemidef_conjTranspose_mul_self T)

lemma polarRoot_square (T : Matrix d k ℂ) : polarRoot T * polarRoot T = Tᴴ * T :=
  positiveRoot_square _ _

lemma polarRoot_hermitian (T : Matrix d k ℂ) : (polarRoot T)ᴴ = polarRoot T :=
  (positiveRoot_positive _ _).1.eq

lemma polarRoot_det_unit (T : Matrix d k ℂ) (hT : (Tᴴ * T).PosDef) :
    IsUnit (polarRoot T).det := by
  have hu := (Matrix.isUnit_iff_isUnit_det _).mp hT.isUnit
  rw [← polarRoot_square T, Matrix.det_mul] at hu
  exact isUnit_iff_ne_zero.mpr (mul_ne_zero_iff.mp hu.ne_zero).1

noncomputable def polarIsometry (T : Matrix d k ℂ) : Matrix d k ℂ := T * (polarRoot T)⁻¹

theorem polarIsometry_isometry (T : Matrix d k ℂ) (hT : (Tᴴ * T).PosDef) :
    (polarIsometry T)ᴴ * polarIsometry T = 1 := by
  have hu := polarRoot_det_unit T hT
  unfold polarIsometry
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_nonsing_inv, polarRoot_hermitian]
  calc
    _ = (polarRoot T)⁻¹ * (Tᴴ * T) * (polarRoot T)⁻¹ := by simp only [Matrix.mul_assoc]
    _ = (polarRoot T)⁻¹ * (polarRoot T * polarRoot T) * (polarRoot T)⁻¹ := by
      rw [polarRoot_square]
    _ = 1 := by
      rw [← Matrix.mul_assoc, Matrix.nonsing_inv_mul _ hu, Matrix.one_mul,
        Matrix.mul_nonsing_inv _ hu]

theorem polar_factorization (T : Matrix d k ℂ) (hT : (Tᴴ * T).PosDef) :
    polarIsometry T * polarRoot T = T := by
  exact Matrix.nonsing_inv_mul_cancel_right _ _ (polarRoot_det_unit T hT)

end RCProof
