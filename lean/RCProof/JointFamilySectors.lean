import RCProof.JointFamilyPOVM

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

lemma jointCore_clean_axis (n : ℕ) (w : ℝ) (i : Fin 4) :
    (jointCore n w)ᴴ * jointAxis (Sum.inr i : JointLabels n) = 0 := by
  ext j k
  simp only [jointAxis, jointLabelIndex, Sum.map_inr, coordinateAxis, realDiagonal, Matrix.mul_diagonal]
  by_cases hk : k = Sum.inr i.castSucc
  · subst k
    have hi : i.castSucc ≠ (4 : Fin 5) := by
      intro heq
      have hh : i.val = 4 := congrArg (fun x : Fin 5 => x.val) heq
      omega
    simp [jointCore, Matrix.conjTranspose_apply, hi]
  · simp [hk]

namespace JointFamilyData
variable (p : JointFamilyData)

lemma other_clean_positive (i : Fin 4) :
    (1 - jointResidual p.n - jointOld p.n - jointAxis (Sum.inr i : JointLabels p.n)).PosSemidef := by
  rw [← p.clean_axis_sum]
  have hh := Matrix.posSemidef_sum (Finset.univ.erase i)
    (fun j _ => coordinateAxis_positive (jointLabelIndex (Sum.inr j : JointLabels p.n)))
  convert hh using 1
  have hs := Finset.sum_erase_add Finset.univ (fun j : Fin 4 => jointAxis (Sum.inr j : JointLabels p.n))
    (Finset.mem_univ i)
  rw [← hs]
  abel

lemma plus_clean_zero (i : Fin 4) : p.plus * jointAxis (Sum.inr i) = 0 := by
  dsimp only [plus]
  rw [Matrix.mul_assoc, jointCore_clean_axis, Matrix.mul_zero]

lemma minus_clean_zero (i : Fin 4) : p.minus * jointAxis (Sum.inr i) = 0 := by
  dsimp only [minus]
  rw [Matrix.mul_assoc, jointCore_clean_axis, Matrix.mul_zero]

lemma perp_clean_zero (i : Fin 4) : p.perp * jointAxis (Sum.inr i) = 0 := by
  dsimp only [perp, mean]
  rw [Matrix.sub_mul, jointOld_clean_axis, jointMean_clean_axis, sub_self]

lemma low_clean_zero (i : Fin 4) : p.low i * jointAxis (Sum.inr i) = 0 := by
  dsimp only [low]
  split_ifs <;> simp only [Matrix.add_mul, Matrix.smul_mul, p.plus_clean_zero,
    p.minus_clean_zero, p.perp_clean_zero, smul_zero, add_zero]

lemma low_complement_bound (i : Fin 4) :
    ((1/2 : ℝ) • (1 - jointAxis (Sum.inr i : JointLabels p.n)) - p.low i).PosSemidef := by
  have hc : 0 ≤ p.c := by linarith [p.c_gt_half]
  have hdef : p.b^2=1-p.c*p.a^2 := by linarith [p.defect]
  have hplus : p.plus = p.b^2 • p.mean + jointResidual p.n - p.minus := by
    rw [← p.residual_sum]
    abel
  have hminus : p.minus = p.b^2 • p.mean + jointResidual p.n - p.plus := by
    rw [← p.residual_sum]
    abel
  by_cases hi : i.val < 2
  · have hp := (((p.other_clean_positive i).smul (show (0 : ℝ) ≤ 1/2 by norm_num)).add
      (p.minus_positive.smul (show (0 : ℝ) ≤ 1/2 by norm_num))).add
      (((jointMean_positive p.n p.w).smul (show 0 ≤ p.c*p.a^2/2 by positivity)).add
        (p.perp_positive.smul (show 0 ≤ (1+p.c*p.g^2)/4 by positivity)))
    convert hp using 1
    dsimp only [low]
    rw [if_pos hi, hplus, hdef]
    dsimp only [perp, mean]
    module
  · have hp := (((p.other_clean_positive i).smul (show (0 : ℝ) ≤ 1/2 by norm_num)).add
      (p.plus_positive.smul (show (0 : ℝ) ≤ 1/2 by norm_num))).add
      (((jointMean_positive p.n p.w).smul (show 0 ≤ p.c*p.a^2/2 by positivity)).add
        (p.perp_positive.smul (show 0 ≤ (1+p.c*p.g^2)/4 by positivity)))
    convert hp using 1
    dsimp only [low]
    rw [if_neg hi, hminus, hdef]
    dsimp only [perp, mean]
    module

lemma full_sectors (j : JointLabels p.n) :
    thresholdProjector (p.povm.effect j) (p.povm.positive j).1 p.c = p.factor * jointAxis j * p.factor := by
  rcases j with j | j
  · let P := p.factor * jointAxis (Sum.inl j) * p.factor
    have hP : P.PosSemidef := by
      have hh := (coordinateAxis_positive (jointLabelIndex (Sum.inl j : JointLabels p.n))).mul_mul_conjTranspose_same p.factor
      simpa only [p.factor_positive.1.eq, P, jointAxis] using hh
    have hPP : P*P=P := jointTransport_projection p.n p.w p.a p.g p.mean_unit p.column_unit j
    apply thresholdProjector_eq_of_isolated_projection _ P (p.povm.positive (Sum.inl j)).1 hP hPP
      p.c 0 p.c (by linarith [p.c_gt_half]) le_rfl
    · change (p.c • P)*P=p.c • P
      rw [Matrix.smul_mul, hPP]
    · change (p.c • P + (0 : ℝ) • (1-P) - p.c • P).PosSemidef
      simp only [zero_smul, add_zero, sub_self]
      exact Matrix.PosSemidef.zero
  · have hF := (coordinateAxis_positive (jointLabelIndex (Sum.inr j : JointLabels p.n)))
    have hDF : p.factor * jointAxis (Sum.inr j) = jointAxis (Sum.inr j) :=
      jointFactor_clean_axis p.n p.w p.a p.g j
    have hFD : jointAxis (Sum.inr j) * p.factor = jointAxis (Sum.inr j) := by
      have hh := congrArg Matrix.conjTranspose hDF
      have hFh : (jointAxis (Sum.inr j : JointLabels p.n)).IsHermitian := hF.1
      simpa only [Matrix.conjTranspose_mul, p.factor_positive.1.eq, hFh.eq] using hh
    rw [hDF, hFD]
    have hFF : jointAxis (Sum.inr j : JointLabels p.n)*jointAxis (Sum.inr j)=jointAxis (Sum.inr j) := by
      simp [jointAxis_orthogonal]
    apply thresholdProjector_eq_of_isolated_projection _ _ (p.povm.positive (Sum.inr j)).1 hF hFF
      1 (1/2) p.c p.c_gt_half p.c_lt_one.le
    · change (jointAxis (Sum.inr j)+p.low j)*jointAxis (Sum.inr j)=(1 : ℝ) • jointAxis (Sum.inr j)
      rw [Matrix.add_mul, hFF, p.low_clean_zero, add_zero, one_smul]
    · change ((1 : ℝ) • jointAxis (Sum.inr j)+(1/2 : ℝ) • (1-jointAxis (Sum.inr j))-
        (jointAxis (Sum.inr j)+p.low j)).PosSemidef
      convert p.low_complement_bound j using 1
      simp only [one_smul]
      abel

end JointFamilyData
end RCProof
