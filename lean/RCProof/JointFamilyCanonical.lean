import RCProof.JointFamilySectors

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

namespace JointFamilyData
variable (p : JointFamilyData)

theorem canonical_transport :
    Function.Injective (canonicalSynthesis p.povm p.c).mulVec ∧
      polarIsometry (canonicalSynthesis p.povm p.c) = p.inverse * canonicalSynthesis p.povm p.c ∧
      ∀ j, sectorProjection p.povm p.c (polarIsometry (canonicalSynthesis p.povm p.c)) j = jointAxis j :=
  canonical_sectors_of_positive_transport p.povm p.c p.factor p.inverse jointAxis
    p.factor_positive p.inverse_positive p.factor_inverse
    (fun j => (coordinateAxis_positive (jointLabelIndex j)).1) (jointAxis_orthogonal p.n)
    (jointFactor_selected_commutes p.n p.w p.a p.g p.mean_unit) p.full_sectors

lemma sectors_nonzero (j : JointLabels p.n) :
    thresholdProjector (p.povm.effect j) (p.povm.positive j).1 p.c ≠ 0 := by
  have hKD : p.inverse*p.factor=1 := by
    have hh := congrArg Matrix.conjTranspose p.factor_inverse
    simpa only [Matrix.conjTranspose_mul, p.factor_positive.1.eq, p.inverse_positive.1.eq,
      Matrix.conjTranspose_one] using hh
  intro hz
  rw [p.full_sectors] at hz
  have hh := congrArg (fun A => p.inverse*A*p.inverse) hz
  have heq : p.inverse*(p.factor*jointAxis j*p.factor)*p.inverse=jointAxis j := by
    calc
      _ = (p.inverse*p.factor)*jointAxis j*(p.factor*p.inverse) := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hKD, p.factor_inverse, Matrix.one_mul, Matrix.mul_one]
  rw [heq, Matrix.mul_zero, Matrix.zero_mul] at hh
  have ht := congrArg (fun A => A (jointLabelIndex j) (jointLabelIndex j)) hh
  simpa [jointAxis, coordinateAxis, realDiagonal] using ht

lemma sectors_nonempty : Nonempty (SectorIndex p.povm p.c) :=
  sectorIndex_nonempty p.povm p.c (fun j _ => p.sectors_nonzero j)

lemma polar_range :
    polarIsometry (canonicalSynthesis p.povm p.c) *
      (polarIsometry (canonicalSynthesis p.povm p.c))ᴴ = 1-jointResidual p.n := by
  rw [← canonical_sectorProjection_sum]
  simp only [p.canonical_transport.2.2]
  exact jointAxis_sum p.n

theorem packing_exact : letI := p.sectors_nonempty
    packingAlpha (canonicalSynthesis p.povm p.c) = p.a := by
  letI := p.sectors_nonempty
  let T := canonicalSynthesis p.povm p.c
  let V := polarIsometry T
  have hV : Vᴴ*V=1 := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T p.canonical_transport.1)
  have hf : p.factor*V=T := by
    dsimp only [V, T]
    rw [p.canonical_transport.2.1, ← Matrix.mul_assoc, p.factor_inverse, Matrix.one_mul]
  have hRP : jointResidual p.n*p.mean=0 := by
    have hh := congrArg Matrix.conjTranspose (jointMean_residual p.n p.w p.mean_unit)
    have hR : (jointResidual p.n).IsHermitian := (coordinateAxis_positive _).1
    simpa only [mean, Matrix.conjTranspose_mul, (jointMean_positive p.n p.w).1.eq,
      hR.eq,
      Matrix.conjTranspose_zero] using hh
  have hVP : V*Vᴴ*p.mean=p.mean := by
    dsimp only [V, T]
    rw [p.polar_range, Matrix.sub_mul, Matrix.one_mul, hRP, sub_zero]
  apply packing_eq_of_physical_factor T V p.factor p.mean hV p.factor_positive.1 hf
    (jointMean_positive p.n p.w).1 (jointMean_square p.n p.w p.mean_unit)
    (jointMean_trace p.n p.w p.mean_unit) hVP p.a p.a_pos.le
  · exact twoLevelFactor_on_projection _ _ (jointMean_square p.n p.w p.mean_unit)
      (jointOld_mean p.n p.w) p.a p.g
  · exact twoLevelFactor_square_lower _ _ (jointOld_positive p.n) (jointMean_positive p.n p.w)
      (jointOld_square p.n) (jointMean_square p.n p.w p.mean_unit) (jointOld_mean p.n p.w)
      (jointMean_old p.n p.w) p.a p.g (by nlinarith [p.a_pos, p.a_le_one])
      (by nlinarith [p.a_pos, p.a_le_one, p.g_ge_one])

theorem completion_effect (j : JointLabels p.n) :
    (canonicalCompletion p.povm p.c p.canonical_transport.1).effect j =
      jointAxis j + jointResidual p.n*p.effect j*jointResidual p.n := by
  rw [canonicalCompletion_effect]
  change sectorProjection p.povm p.c (polarIsometry (canonicalSynthesis p.povm p.c)) j +
    (1 - polarIsometry (canonicalSynthesis p.povm p.c) *
      (polarIsometry (canonicalSynthesis p.povm p.c))ᴴ) * p.effect j *
    (1 - polarIsometry (canonicalSynthesis p.povm p.c) *
      (polarIsometry (canonicalSynthesis p.povm p.c))ᴴ) = _
  rw [p.canonical_transport.2.2, p.polar_range, sub_sub_cancel]

end JointFamilyData
end RCProof
