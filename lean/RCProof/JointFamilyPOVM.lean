import RCProof.JointFamilyFactor

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

structure JointFamilyData where
  n : ℕ
  a : ℝ
  g : ℝ
  w : ℝ
  b : ℝ
  h : ℝ
  c : ℝ
  n_ge_two : 2 ≤ n
  a_pos : 0 < a
  a_le_one : a ≤ 1
  g_ge_one : 1 ≤ g
  w_pos : 0 < w
  c_gt_half : 1 / 2 < c
  c_lt_one : c < 1
  b_pos : 0 < b
  b_lt_one : b < 1
  h_nonneg : 0 ≤ h
  column_unit : a ^ 2 + ((n : ℝ)-1)*g^2 = (n : ℝ)
  mean_unit : (n : ℝ)*w^2 = 1
  defect : b^2+c*a^2=1
  root : h^2=1-b
  residual_nonneg : 0 ≤ 1-c*g^2

namespace JointFamilyData
variable (p : JointFamilyData)

noncomputable def factor := jointFactor p.n p.w p.a p.g
noncomputable def inverse := jointFactor p.n p.w p.a⁻¹ p.g⁻¹
noncomputable def mean := jointMean p.n p.w
noncomputable def perp := jointOld p.n - p.mean
noncomputable def plus := jointCore p.n p.w * jointPlusCore p.b p.h * (jointCore p.n p.w)ᴴ
noncomputable def minus := jointCore p.n p.w * jointMinusCore p.b p.h * (jointCore p.n p.w)ᴴ

noncomputable def low (i : Fin 4) : Matrix (JointDim p.n) (JointDim p.n) ℂ :=
  (1/2 : ℝ) • (if i.val < 2 then p.plus else p.minus) + ((1-p.c*p.g^2)/4) • p.perp

noncomputable def effect : JointLabels p.n → Matrix (JointDim p.n) (JointDim p.n) ℂ :=
  Sum.elim (fun j => p.c • (p.factor * jointAxis (Sum.inl j) * p.factor))
    (fun i => jointAxis (Sum.inr i) + p.low i)

lemma factor_positive : p.factor.PosSemidef :=
  jointFactor_positive p.n p.w p.a p.g p.mean_unit p.a_pos.le (by linarith [p.g_ge_one])

lemma inverse_positive : p.inverse.PosSemidef :=
  jointFactor_positive p.n p.w p.a⁻¹ p.g⁻¹ p.mean_unit (inv_nonneg.mpr p.a_pos.le)
    (inv_nonneg.mpr (by linarith [p.g_ge_one]))

lemma factor_inverse : p.factor * p.inverse = 1 :=
  jointFactor_inverse p.n p.w p.a p.g p.mean_unit p.a_pos.ne' (by linarith [p.g_ge_one])

lemma perp_positive : p.perp.PosSemidef :=
  projection_difference_positive _ _ (jointOld_positive p.n).1 (jointMean_positive p.n p.w).1
    (jointOld_square p.n) (jointMean_square p.n p.w p.mean_unit) (jointOld_mean p.n p.w)

lemma plus_positive : p.plus.PosSemidef :=
  (jointPlusCore_positive p.b p.h (by linarith [p.b_lt_one])).mul_mul_conjTranspose_same _

lemma minus_positive : p.minus.PosSemidef :=
  (jointMinusCore_positive p.b p.h (by linarith [p.b_lt_one])).mul_mul_conjTranspose_same _

lemma low_positive (i : Fin 4) : (p.low i).PosSemidef := by
  apply Matrix.PosSemidef.add
  · apply Matrix.PosSemidef.smul _ (show (0 : ℝ) ≤ 1/2 by norm_num)
    split_ifs
    · exact p.plus_positive
    · exact p.minus_positive
  · exact p.perp_positive.smul (div_nonneg p.residual_nonneg (by norm_num))

lemma effect_positive (j : JointLabels p.n) : (p.effect j).PosSemidef := by
  rcases j with j | j
  · have hh := (coordinateAxis_positive (jointLabelIndex (Sum.inl j : JointLabels p.n))).mul_mul_conjTranspose_same p.factor
    rw [p.factor_positive.1.eq] at hh
    exact hh.smul (by linarith [p.c_gt_half])
  · exact (coordinateAxis_positive _).add (p.low_positive j)

lemma residual_sum : p.plus + p.minus = p.b^2 • p.mean + jointResidual p.n := by
  dsimp only [plus, minus]
  rw [← Matrix.add_mul, ← Matrix.mul_add, jointCore_effect_sum p.b p.h (by linarith [p.b_lt_one]) p.root]
  simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
    jointCore_residual]
  rfl

lemma low_sum : (∑ i : Fin 4, p.low i) = p.plus + p.minus + (1-p.c*p.g^2) • p.perp := by
  norm_num [low, Fin.sum_univ_succ]
  simp only [two_mul]
  module

lemma clean_axis_sum : (∑ i : Fin 4, jointAxis (Sum.inr i : JointLabels p.n)) =
    1 - jointResidual p.n - jointOld p.n := by
  have hh := jointAxis_sum p.n
  rw [Fintype.sum_sum_type, jointOld_axes_sum] at hh
  rw [← hh]
  abel

lemma effect_sum : ∑ j, p.effect j = 1 := by
  have hold : (∑ j : Fin p.n, p.c • (p.factor * jointAxis (Sum.inl j) * p.factor)) =
      p.c • (p.a^2 • p.mean + p.g^2 • p.perp) := by
    rw [← Finset.smul_sum, ← Matrix.sum_mul, ← Matrix.mul_sum, jointOld_axes_sum]
    exact congrArg (p.c • ·) (jointFactor_old_sandwich p.n p.w p.a p.g p.mean_unit)
  simp only [effect, Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
  rw [hold, Finset.sum_add_distrib, p.clean_axis_sum, p.low_sum, p.residual_sum]
  have hdef : p.b^2 = 1-p.c*p.a^2 := by linarith [p.defect]
  rw [hdef]
  dsimp only [perp]
  module

noncomputable def povm : FinitePOVM (JointDim p.n) (JointLabels p.n) where
  effect := p.effect
  positive := p.effect_positive
  normalized := p.effect_sum

end JointFamilyData
end RCProof
