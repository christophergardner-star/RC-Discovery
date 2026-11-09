import RCProof.JointWitnessCore

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

noncomputable def jointFactor (n : ℕ) (w a g : ℝ) : Matrix (JointDim n) (JointDim n) ℂ :=
  twoLevelFactor (jointOld n) (jointMean n w) a g

lemma jointFactor_positive (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1)
    (ha : 0 ≤ a) (hg : 0 ≤ g) : (jointFactor n w a g).PosSemidef :=
  twoLevelFactor_positive _ _ (jointOld_positive n) (jointMean_positive n w)
    (jointOld_square n) (jointMean_square n w hw) (jointOld_mean n w) a g ha hg

lemma jointFactor_inverse (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1)
    (ha : a ≠ 0) (hg : g ≠ 0) : jointFactor n w a g * jointFactor n w a⁻¹ g⁻¹ = 1 :=
  twoLevelFactor_inverse _ _ (jointOld_square n) (jointMean_square n w hw)
    (jointOld_mean n w) (jointMean_old n w) a g ha hg

lemma jointFactor_square (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1) :
    jointFactor n w a g * jointFactor n w a g = jointFactor n w (a*a) (g*g) :=
  twoLevelFactor_product _ _ (jointOld_square n) (jointMean_square n w hw)
    (jointOld_mean n w) (jointMean_old n w) a g a g

lemma jointFactor_square_diag (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1)
    (hunit : a^2+((n : ℝ)-1)*g^2=(n : ℝ)) (i : Fin n) :
    (jointFactor n w a g * jointFactor n w a g) (Sum.inl i) (Sum.inl i) = 1 := by
  have hs : g^2+(a^2-g^2)*w^2=1 := by
    have hh := congrArg (fun x : ℝ => x*w^2) hunit
    nlinarith [hw]
  rw [jointFactor_square n w a g hw]
  dsimp only [jointFactor, twoLevelFactor]
  simp only [Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply, jointMean_old_diag]
  norm_num [jointOld, realDiagonal, Complex.real_smul]
  have hs' : (g : ℂ)^2+((a : ℂ)^2-(g : ℂ)^2)*(w : ℂ)^2=1 := by exact_mod_cast hs
  push_cast
  linear_combination hs'

lemma jointFactor_clean_axis (n : ℕ) (w a g : ℝ) (i : Fin 4) :
    jointFactor n w a g * jointAxis (Sum.inr i) = jointAxis (Sum.inr i) := by
  simp only [jointFactor, twoLevelFactor, Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul,
    Matrix.one_mul, jointMean_clean_axis, jointOld_clean_axis, sub_self, smul_zero,
    zero_add, sub_zero]

lemma jointFactor_residual (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1) :
    jointFactor n w a g * jointResidual n = jointResidual n := by
  simp only [jointFactor, twoLevelFactor, Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul,
    Matrix.one_mul, jointMean_residual n w hw, jointOld_residual, sub_self, smul_zero,
    zero_add, sub_zero]

lemma jointFactor_selected_commutes (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1) :
    (∑ j : JointLabels n, jointAxis j) * jointFactor n w a g =
      jointFactor n w a g * (∑ j : JointLabels n, jointAxis j) := by
  have hD := twoLevelFactor_hermitian (jointOld n) (jointMean n w)
    (jointOld_positive n).1 (jointMean_positive n w).1 a g
  have hR := (coordinateAxis_positive (Sum.inr (4 : Fin 5) : JointDim n)).1
  have hDh : (jointFactor n w a g).IsHermitian := hD
  have hRh : (jointResidual n).IsHermitian := hR
  have hRD : jointResidual n * jointFactor n w a g = jointResidual n := by
    have hh := congrArg Matrix.conjTranspose (jointFactor_residual n w a g hw)
    simpa only [Matrix.conjTranspose_mul, hDh.eq, hRh.eq] using hh
  rw [jointAxis_sum, Matrix.sub_mul, Matrix.mul_sub, Matrix.one_mul, Matrix.mul_one,
    jointFactor_residual n w a g hw, hRD]

lemma jointOld_axes_sum (n : ℕ) : (∑ i : Fin n, jointAxis (Sum.inl i)) = jointOld n := by
  ext i j
  rcases i with i | i <;> rcases j with j | j <;>
    simp [jointAxis, jointLabelIndex, coordinateAxis, jointOld, realDiagonal,
      Matrix.sum_apply, Matrix.diagonal_apply, apply_ite]

lemma jointFactor_old_sandwich (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1) :
    jointFactor n w a g * jointOld n * jointFactor n w a g =
      a^2 • jointMean n w + g^2 • (jointOld n-jointMean n w) := by
  dsimp only [jointFactor, twoLevelFactor]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.sub_mul, Matrix.mul_sub,
    Matrix.smul_mul, Matrix.mul_smul, smul_smul, Matrix.one_mul, Matrix.mul_one,
    jointOld_square, jointMean_square n w hw, jointOld_mean, jointMean_old,
    sub_self, smul_zero, mul_zero, zero_mul, add_zero, zero_add, sub_zero, smul_sub]
  module

lemma jointTransport_projection (n : ℕ) (w a g : ℝ) (hw : (n : ℝ)*w^2=1)
    (hunit : a^2+((n : ℝ)-1)*g^2=(n : ℝ)) (i : Fin n) :
    let D := jointFactor n w a g
    (D * jointAxis (Sum.inl i) * D) * (D * jointAxis (Sum.inl i) * D) =
      D * jointAxis (Sum.inl i) * D := by
  dsimp only
  let D := jointFactor n w a g
  have hs : jointAxis (Sum.inl i) * (D*D) * jointAxis (Sum.inl i) = jointAxis (Sum.inl i) := by
    rw [jointAxis, coordinateAxis_sandwich]
    change (D*D) (Sum.inl i) (Sum.inl i) • coordinateAxis (Sum.inl i) = _
    rw [jointFactor_square_diag n w a g hw hunit, one_smul]
    rfl
  change (D * jointAxis (Sum.inl i) * D) * (D * jointAxis (Sum.inl i) * D) =
    D * jointAxis (Sum.inl i) * D
  calc
    _ = D * (jointAxis (Sum.inl i) * (D*D) * jointAxis (Sum.inl i)) * D := by simp only [Matrix.mul_assoc]
    _ = _ := by rw [hs]

end RCProof
