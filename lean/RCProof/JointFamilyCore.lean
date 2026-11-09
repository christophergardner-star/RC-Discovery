import RCProof.JointFamilyGeometry
import RCProof.TwoLevelFactor

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

lemma isometry_conjugation_product {d k : Type*} [Fintype d] [Fintype k]
    [DecidableEq k] (U : Matrix d k ℂ) (hU : Uᴴ * U = 1) (A B : Matrix k k ℂ) :
    (U * A * Uᴴ) * (U * B * Uᴴ) = U * (A * B) * Uᴴ := by
  calc
    _ = U * A * (Uᴴ * U) * B * Uᴴ := by simp only [Matrix.mul_assoc]
    _ = _ := by rw [hU, Matrix.mul_one]; simp only [Matrix.mul_assoc]

noncomputable def jointMean (n : ℕ) (w : ℝ) : Matrix (JointDim n) (JointDim n) ℂ :=
  jointCore n w * coordinateAxis (0 : Fin 2) * (jointCore n w)ᴴ

lemma jointMean_positive (n : ℕ) (w : ℝ) : (jointMean n w).PosSemidef :=
  (coordinateAxis_positive (0 : Fin 2)).mul_mul_conjTranspose_same _

lemma jointMean_square (n : ℕ) (w : ℝ) (hw : (n : ℝ) * w ^ 2 = 1) :
    jointMean n w * jointMean n w = jointMean n w := by
  rw [jointMean, isometry_conjugation_product _ (jointCore_isometry n w hw)]
  simp [coordinateAxis_mul]

lemma jointCore_residual (n : ℕ) (w : ℝ) :
    jointCore n w * coordinateAxis (1 : Fin 2) * (jointCore n w)ᴴ = jointResidual n := by
  ext i j
  rcases i with i | i <;> rcases j with j | j <;>
    simp [jointCore, coordinateAxis, jointResidual, realDiagonal, Matrix.mul_apply,
      Matrix.diagonal_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]
  fin_cases i <;> fin_cases j <;> norm_num

lemma jointOld_core (n : ℕ) (w : ℝ) :
    jointOld n * jointCore n w = jointCore n w * coordinateAxis (0 : Fin 2) := by
  ext i j
  rcases i with i | i <;> fin_cases j <;>
    simp [jointOld, jointCore, coordinateAxis, realDiagonal, Matrix.diagonal_mul, Matrix.mul_diagonal]

lemma jointOld_mean (n : ℕ) (w : ℝ) : jointOld n * jointMean n w = jointMean n w := by
  dsimp only [jointMean]
  calc
    _ = (jointOld n * jointCore n w) * coordinateAxis (0 : Fin 2) * (jointCore n w)ᴴ := by
      simp only [Matrix.mul_assoc]
    _ = jointCore n w * (coordinateAxis (0 : Fin 2) * coordinateAxis (0 : Fin 2)) * (jointCore n w)ᴴ := by
      rw [jointOld_core]
      simp only [Matrix.mul_assoc]
    _ = _ := by simp [coordinateAxis_mul]

lemma jointMean_old (n : ℕ) (w : ℝ) : jointMean n w * jointOld n = jointMean n w := by
  have hh := congrArg Matrix.conjTranspose (jointOld_mean n w)
  simpa only [Matrix.conjTranspose_mul, (jointMean_positive n w).1.eq,
    (jointOld_positive n).1.eq] using hh

lemma jointOld_residual (n : ℕ) : jointOld n * jointResidual n = 0 := by
  ext i j
  rcases i with i | i <;> rcases j with j | j <;>
    simp [jointOld, jointResidual, coordinateAxis, realDiagonal, Matrix.mul_diagonal,
      Matrix.diagonal_apply]

lemma jointMean_residual (n : ℕ) (w : ℝ) (hw : (n : ℝ) * w ^ 2 = 1) :
    jointMean n w * jointResidual n = 0 := by
  rw [← jointCore_residual n w]
  dsimp only [jointMean]
  rw [isometry_conjugation_product _ (jointCore_isometry n w hw)]
  simp [coordinateAxis_mul]

lemma jointMean_trace (n : ℕ) (w : ℝ) (hw : (n : ℝ) * w ^ 2 = 1) :
    (jointMean n w).trace = 1 := by
  dsimp only [jointMean]
  rw [Matrix.trace_mul_comm, ← Matrix.mul_assoc, jointCore_isometry n w hw, Matrix.one_mul]
  norm_num [coordinateAxis, realDiagonal, Matrix.trace, Fin.sum_univ_succ]

lemma jointMean_old_diag (n : ℕ) (w : ℝ) (i : Fin n) :
    jointMean n w (Sum.inl i) (Sum.inl i) = (w ^ 2 : ℝ) := by
  norm_num [jointMean, jointCore, coordinateAxis, realDiagonal, Matrix.mul_apply,
    Matrix.diagonal_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]
  push_cast
  ring

lemma jointMean_clean_axis (n : ℕ) (w : ℝ) (i : Fin 4) :
    jointMean n w * jointAxis (Sum.inr i) = 0 := by
  ext j k
  simp only [jointAxis, jointLabelIndex, Sum.map_inr, coordinateAxis, realDiagonal, Matrix.mul_diagonal]
  by_cases hk : k = Sum.inr i.castSucc
  · subst k
    rcases j with j | j <;>
      simp [jointMean, jointCore, coordinateAxis, realDiagonal, Matrix.mul_apply,
        Matrix.diagonal_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]
  · simp [hk]

lemma jointOld_clean_axis (n : ℕ) (i : Fin 4) :
    jointOld n * jointAxis (Sum.inr i) = 0 := by
  ext j k
  rcases j with j | j <;> rcases k with k | k <;>
    simp [jointOld, jointAxis, jointLabelIndex, coordinateAxis, realDiagonal,
      Matrix.mul_diagonal, Matrix.diagonal_apply]

end RCProof
