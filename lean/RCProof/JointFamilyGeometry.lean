import RCProof.FrameRecognition

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

noncomputable def coordinateAxis {d : Type*} [DecidableEq d] (j : d) : Matrix d d ℂ :=
  realDiagonal (fun i => if i = j then 1 else 0)

lemma coordinateAxis_positive {d : Type*} [Fintype d] [DecidableEq d] (j : d) :
    (coordinateAxis j).PosSemidef := by
  apply realDiagonal_positive
  intro i
  split_ifs <;> norm_num

lemma coordinateAxis_mul {d : Type*} [Fintype d] [DecidableEq d] (i j : d) :
    coordinateAxis i * coordinateAxis j = if i = j then coordinateAxis i else 0 := by
  unfold coordinateAxis
  rw [realDiagonal_mul]
  ext a b
  simp only [realDiagonal, Matrix.diagonal_apply]
  split_ifs <;> simp_all

lemma coordinateAxis_sandwich {d : Type*} [Fintype d] [DecidableEq d]
    (A : Matrix d d ℂ) (j : d) : coordinateAxis j * A * coordinateAxis j = A j j • coordinateAxis j := by
  ext i k
  simp only [coordinateAxis, realDiagonal, Matrix.diagonal_mul, Matrix.mul_diagonal,
    Matrix.smul_apply, Matrix.diagonal_apply]
  split_ifs <;> simp_all

lemma coordinateAxis_sum {d : Type*} [Fintype d] [DecidableEq d] :
    ∑ j : d, coordinateAxis j = 1 := by
  ext i j
  simp [coordinateAxis, realDiagonal, Matrix.diagonal_apply, Matrix.one_apply, Matrix.sum_apply, apply_ite]

abbrev JointDim (n : ℕ) := Fin n ⊕ Fin 5
abbrev JointLabels (n : ℕ) := Fin n ⊕ Fin 4

def jointLabelIndex {n : ℕ} : JointLabels n → JointDim n := Sum.map id Fin.castSucc

noncomputable def jointAxis {n : ℕ} (j : JointLabels n) : Matrix (JointDim n) (JointDim n) ℂ :=
  coordinateAxis (jointLabelIndex j)

noncomputable def jointOld (n : ℕ) : Matrix (JointDim n) (JointDim n) ℂ :=
  realDiagonal (Sum.elim (fun _ => 1) (fun _ => 0))

noncomputable def jointResidual (n : ℕ) : Matrix (JointDim n) (JointDim n) ℂ :=
  coordinateAxis (Sum.inr 4)

noncomputable def jointCore (n : ℕ) (w : ℝ) : Matrix (JointDim n) (Fin 2) ℂ :=
  fun i j => match i with
  | Sum.inl _ => if j = 0 then (w : ℂ) else 0
  | Sum.inr k => if k = 4 ∧ j = 1 then 1 else 0

lemma jointCore_isometry (n : ℕ) (w : ℝ) (hw : (n : ℝ) * w ^ 2 = 1) :
    (jointCore n w)ᴴ * jointCore n w = 1 := by
  have hw' : (n : ℂ) * (w : ℂ) ^ 2 = 1 := by exact_mod_cast hw
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [jointCore, Matrix.mul_apply, Matrix.conjTranspose_apply,
      Fintype.sum_sum_type, Fin.sum_univ_succ, Matrix.one_apply] <;>
    simpa only [pow_two, mul_assoc] using hw'

lemma jointAxis_orthogonal (n : ℕ) (i j : JointLabels n) :
    jointAxis i * jointAxis j = if i = j then jointAxis i else 0 := by
  have hi : Function.Injective (@jointLabelIndex n) :=
    Sum.map_injective.mpr ⟨Function.injective_id, Fin.castSucc_injective 4⟩
  simp only [jointAxis, coordinateAxis_mul, hi.eq_iff]

lemma jointAxis_sum (n : ℕ) : (∑ j : JointLabels n, jointAxis j) = 1 - jointResidual n := by
  ext i j
  rcases i with i | i <;> rcases j with j | j
  · simp [jointAxis, jointLabelIndex, coordinateAxis, jointResidual, realDiagonal,
      Matrix.sum_apply, Fintype.sum_sum_type, Matrix.diagonal_apply, Matrix.one_apply, apply_ite]
  · simp [jointAxis, jointLabelIndex, coordinateAxis, jointResidual, realDiagonal,
      Matrix.sum_apply, Fintype.sum_sum_type, Matrix.diagonal_apply, Matrix.one_apply]
  · simp [jointAxis, jointLabelIndex, coordinateAxis, jointResidual, realDiagonal,
      Matrix.sum_apply, Fintype.sum_sum_type, Matrix.diagonal_apply, Matrix.one_apply]
  · fin_cases i <;> fin_cases j <;>
      norm_num [jointAxis, jointLabelIndex, coordinateAxis, jointResidual, realDiagonal,
        Matrix.sum_apply, Fintype.sum_sum_type, Fin.sum_univ_succ,
        Matrix.diagonal_apply, Matrix.one_apply]

lemma jointOld_positive (n : ℕ) : (jointOld n).PosSemidef := by
  apply realDiagonal_positive
  intro i
  rcases i with i | i <;> norm_num

lemma jointOld_square (n : ℕ) : jointOld n * jointOld n = jointOld n := by
  unfold jointOld
  rw [realDiagonal_mul]
  congr 1
  funext i
  rcases i with i | i <;> norm_num

end RCProof
