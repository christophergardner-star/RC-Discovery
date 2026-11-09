import RCProof.JointFamilyCompression

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

namespace JointFamilyData
variable (p : JointFamilyData)

noncomputable def state : Matrix (JointDim p.n) (JointDim p.n) ℂ :=
  jointCore p.n p.w * jointStateCore p.b p.h * (jointCore p.n p.w)ᴴ

lemma state_positive : p.state.PosSemidef :=
  (jointStateCore_positive p.b p.h (by linarith [p.b_lt_one])).mul_mul_conjTranspose_same _

lemma state_trace : p.state.trace=1 := by
  rw [state, trace_isometry_conjugation _ (jointCore_isometry p.n p.w p.mean_unit)]
  exact jointCore_state_trace p.b p.h (by linarith [p.b_lt_one]) p.root

lemma effect_core_old (i : Fin p.n) :
    (jointCore p.n p.w)ᴴ*p.effect (Sum.inl i)*jointCore p.n p.w=
      (p.c*p.a^2*p.w^2) • coordinateAxis (0 : Fin 2) := by
  dsimp only [effect, Sum.elim_inl]
  rw [Matrix.mul_smul, Matrix.smul_mul,
    intertwined_compression _ _ _ p.factor_positive.1 p.coreFactor_hermitian p.factor_core_action,
    p.old_axis_core]
  ext j k
  fin_cases j <;> fin_cases k <;>
    norm_num [coreFactor, coordinateAxis, realDiagonal, Matrix.mul_apply,
      Matrix.diagonal_apply, Fin.sum_univ_succ, Complex.real_smul, pow_two] <;> ring

lemma completion_core_old (i : Fin p.n) :
    (jointCore p.n p.w)ᴴ*(canonicalCompletion p.povm p.c p.canonical_transport.1).effect (Sum.inl i)*
      jointCore p.n p.w=p.w^2 • coordinateAxis (0 : Fin 2) := by
  rw [p.completion_effect, Matrix.mul_add, Matrix.add_mul, p.old_axis_core]
  have hR : (jointResidual p.n).IsHermitian := (coordinateAxis_positive (Sum.inr (4 : Fin 5) : JointDim p.n)).1
  rw [intertwined_compression _ _ _ hR (coordinateAxis_positive (1 : Fin 2)).1 p.residual_core_action,
    p.effect_core_old]
  simp [Matrix.mul_smul, Matrix.smul_mul, coordinateAxis_mul, Matrix.mul_assoc]

lemma effect_core_clean (i : Fin 4) :
    (jointCore p.n p.w)ᴴ*p.effect (Sum.inr i)*jointCore p.n p.w=
      (1/2 : ℝ) • (if i.val<2 then jointPlusCore p.b p.h else jointMinusCore p.b p.h) := by
  dsimp only [effect, Sum.elim_inr]
  rw [Matrix.mul_add, Matrix.add_mul, p.clean_axis_core, zero_add, p.low_core]

lemma completion_core_clean (i : Fin 4) :
    (jointCore p.n p.w)ᴴ*(canonicalCompletion p.povm p.c p.canonical_transport.1).effect (Sum.inr i)*
      jointCore p.n p.w=(1/2 : ℝ) • (coordinateAxis (1 : Fin 2)*
        (if i.val<2 then jointPlusCore p.b p.h else jointMinusCore p.b p.h)*coordinateAxis (1 : Fin 2)) := by
  rw [p.completion_effect, Matrix.mul_add, Matrix.add_mul, p.clean_axis_core, zero_add]
  have hR : (jointResidual p.n).IsHermitian := (coordinateAxis_positive (Sum.inr (4 : Fin 5) : JointDim p.n)).1
  rw [intertwined_compression _ _ _ hR (coordinateAxis_positive (1 : Fin 2)).1 p.residual_core_action,
    p.effect_core_clean, Matrix.mul_smul, Matrix.smul_mul]

lemma old_difference_trace (i : Fin p.n) :
    ((p.effect (Sum.inl i)-(canonicalCompletion p.povm p.c p.canonical_transport.1).effect (Sum.inl i))*p.state).trace=
      ((-p.b^2*p.w^2/(2-p.b) : ℝ) : ℂ) := by
  rw [state, trace_conjugated_input, Matrix.mul_sub, Matrix.sub_mul, p.effect_core_old, p.completion_core_old]
  have hz : (2-p.b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-p.b≠0 by linarith [p.b_lt_one])
  have hd : (p.b : ℂ)^2+(p.c : ℂ)*(p.a : ℂ)^2=1 := by exact_mod_cast p.defect
  norm_num [jointStateCore, coordinateAxis, realDiagonal, Matrix.mul_apply,
    Matrix.trace, Fin.sum_univ_succ, Matrix.diagonal_apply, vecMulVec, Complex.real_smul]
  push_cast
  field_simp
  linear_combination (p.w : ℂ)^2 * hd

lemma clean_difference_trace (i : Fin 4) :
    ((p.effect (Sum.inr i)-(canonicalCompletion p.povm p.c p.canonical_transport.1).effect (Sum.inr i))*p.state).trace=
      if i.val<2 then ((p.b/(2*(2-p.b)) : ℝ) : ℂ) else ((-p.b*p.h^2/(2*(2-p.b)) : ℝ) : ℂ) := by
  rw [state, trace_conjugated_input, Matrix.mul_sub, Matrix.sub_mul,
    p.effect_core_clean, p.completion_core_clean]
  rw [← smul_sub, Matrix.smul_mul, Matrix.trace_smul]
  have hz : (2-p.b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-p.b≠0 by linarith [p.b_lt_one])
  split_ifs
  · rw [jointCore_plus_difference p.b p.h (by linarith [p.b_lt_one]) p.root]
    simp only [Complex.real_smul]
    push_cast
    field_simp
  · rw [jointCore_minus_difference p.b p.h (by linarith [p.b_lt_one]) p.root]
    simp only [Complex.real_smul]
    push_cast
    field_simp

def testSigns : JointLabels p.n → ℝ := Sum.elim (fun _ => -1) (fun i => if i.val<2 then 1 else -1)
noncomputable def test := realDiagonal p.testSigns

lemma test_contraction : ‖p.test‖ ≤ 1 := by
  apply realDiagonal_sign_contraction
  intro i
  rcases i with i | i
  · norm_num [testSigns]
  · dsimp only [testSigns, Sum.elim_inr]
    split_ifs <;> norm_num

theorem attaining_test :
    (((measurementMap p.povm-measurementMap (canonicalCompletion p.povm p.c p.canonical_transport.1)) p.state)*p.test).trace=
      (perfectEnvelope p.b : ℂ) := by
  have hs : (((measurementMap p.povm-measurementMap (canonicalCompletion p.povm p.c p.canonical_transport.1)) p.state)*p.test).trace=
      ∑ j : JointLabels p.n, ((p.effect j-(canonicalCompletion p.povm p.c p.canonical_transport.1).effect j)*p.state).trace * (p.testSigns j : ℂ) := by
    simp [measurementMap, test, realDiagonal, Matrix.trace, Matrix.mul_diagonal,
      Matrix.diagonal_apply, Matrix.sub_mul, Matrix.sub_apply, Finset.sum_sub_distrib, povm]
  rw [hs, Fintype.sum_sum_type]
  simp only [p.old_difference_trace, p.clean_difference_trace, testSigns, Sum.elim_inl, Sum.elim_inr]
  norm_num [Fin.sum_univ_succ]
  have hw : (p.n : ℂ)*(p.w : ℂ)^2=1 := by exact_mod_cast p.mean_unit
  have hh : (p.h : ℂ)^2=1-p.b := by exact_mod_cast p.root
  have hz : (2-p.b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-p.b≠0 by linarith [p.b_lt_one])
  dsimp only [perfectEnvelope]
  push_cast
  field_simp
  linear_combination 2 * (p.b : ℂ) ^ 2 * hw + 2 * (p.b : ℂ) * hh

theorem diamond_attains :
    diamondSize (measurementMap p.povm-measurementMap (canonicalCompletion p.povm p.c p.canonical_transport.1))=
      ENNReal.ofReal (perfectEnvelope p.b) := by
  letI := p.sectors_nonempty
  have hdef : jointDefect p.povm p.c=p.b^2 := by
    unfold jointDefect
    rw [p.packing_exact]
    nlinarith [p.defect]
  apply le_antisymm
  · have hh := canonical_exact_joint_diamond_upper p.povm p.c (by linarith [p.c_gt_half]) p.c_lt_one p.canonical_transport.1
    simpa only [hdef, Real.sqrt_sq p.b_pos.le] using hh
  · have hh := diamondSize_ge_state_test
      (measurementMap p.povm-measurementMap (canonicalCompletion p.povm p.c p.canonical_transport.1))
      p.state p.state_positive p.state_trace p.test p.test_contraction
    rw [p.attaining_test, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (show 0<perfectEnvelope p.b from div_pos (by linarith [p.b_pos]) (by linarith [p.b_lt_one]))] at hh
    exact hh

end JointFamilyData
end RCProof
