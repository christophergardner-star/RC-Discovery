import RCProof.JointFamilyWitness
import RCProof.MatrixRelabel

namespace RCProof
set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

namespace JointFamilyData
variable (p : JointFamilyData) {e q : Type*} [Fintype e] [Fintype q]
  [DecidableEq e] [DecidableEq q] (s : JointDim p.n ≃ e) (t : JointLabels p.n ≃ q)

lemma relabel_full_sectors (j : q) :
    thresholdProjector ((relabelPOVM s t p.povm).effect j)
      ((relabelPOVM s t p.povm).positive j).1 p.c =
      matrixRelabel s (p.factor*jointAxis (t.symm j)*p.factor) := by
  change thresholdProjector (matrixRelabel s (p.effect (t.symm j)))
    (matrixRelabel_hermitian s _ (p.povm.positive (t.symm j)).1) p.c = _
  rcases hi : t.symm j with i | i
  · let P := p.factor*jointAxis (Sum.inl i)*p.factor
    have hP : P.PosSemidef := by
      have hh := (coordinateAxis_positive (jointLabelIndex (Sum.inl i : JointLabels p.n))).mul_mul_conjTranspose_same p.factor
      simpa only [p.factor_positive.1.eq, P, jointAxis] using hh
    have hPP : P*P=P := jointTransport_projection p.n p.w p.a p.g p.mean_unit p.column_unit i
    apply relabel_isolated_sector s _ P (p.povm.positive (Sum.inl i)).1 hP hPP
      p.c 0 p.c (by linarith [p.c_gt_half]) le_rfl
    · change (p.c • P)*P=p.c • P
      rw [Matrix.smul_mul, hPP]
    · change (p.c • P + (0 : ℝ) • (1-P)-p.c • P).PosSemidef
      simp only [zero_smul, add_zero, sub_self]
      exact Matrix.PosSemidef.zero
  · have hF := coordinateAxis_positive (jointLabelIndex (Sum.inr i : JointLabels p.n))
    have hDF : p.factor*jointAxis (Sum.inr i)=jointAxis (Sum.inr i) :=
      jointFactor_clean_axis p.n p.w p.a p.g i
    have hFD : jointAxis (Sum.inr i)*p.factor=jointAxis (Sum.inr i) := by
      have hh := congrArg Matrix.conjTranspose hDF
      have hhF : (jointAxis (Sum.inr i : JointLabels p.n)).IsHermitian := hF.1
      simpa only [Matrix.conjTranspose_mul, p.factor_positive.1.eq, hhF.eq] using hh
    rw [hDF, hFD]
    have hFF : jointAxis (Sum.inr i : JointLabels p.n)*jointAxis (Sum.inr i)=jointAxis (Sum.inr i) := by
      simp [jointAxis_orthogonal]
    apply relabel_isolated_sector s _ _ (p.povm.positive (Sum.inr i)).1 hF hFF
      1 (1/2) p.c p.c_gt_half p.c_lt_one.le
    · change (jointAxis (Sum.inr i)+p.low i)*jointAxis (Sum.inr i)=(1 : ℝ) • jointAxis (Sum.inr i)
      rw [Matrix.add_mul, hFF, p.low_clean_zero, add_zero, one_smul]
    · change ((1 : ℝ) • jointAxis (Sum.inr i)+(1/2 : ℝ) • (1-jointAxis (Sum.inr i))-
        (jointAxis (Sum.inr i)+p.low i)).PosSemidef
      convert p.low_complement_bound i using 1
      simp only [one_smul]
      abel

theorem relabel_transport :
    Function.Injective (canonicalSynthesis (relabelPOVM s t p.povm) p.c).mulVec ∧
      polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c) =
        matrixRelabel s p.inverse*canonicalSynthesis (relabelPOVM s t p.povm) p.c ∧
      ∀ j, sectorProjection (relabelPOVM s t p.povm) p.c
        (polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c)) j =
        matrixRelabel s (jointAxis (t.symm j)) := by
  apply canonical_sectors_of_positive_transport _ _ (matrixRelabel s p.factor)
    (matrixRelabel s p.inverse) (fun j => matrixRelabel s (jointAxis (t.symm j)))
    (matrixRelabel_positive s _ p.factor_positive) (matrixRelabel_positive s _ p.inverse_positive)
    (by rw [← map_mul, p.factor_inverse, map_one])
  · intro j
    exact matrixRelabel_hermitian s _ (coordinateAxis_positive _).1
  · intro i j
    rw [← map_mul, jointAxis_orthogonal]
    by_cases hij : i=j
    · subst j; simp
    · have ht : t.symm i ≠ t.symm j := fun h => hij (t.symm.injective h)
      simp only [if_neg hij, if_neg ht, map_zero]
  · rw [matrixRelabel_sum, ← map_mul, ← map_mul]
    congr 1
    exact jointFactor_selected_commutes p.n p.w p.a p.g p.mean_unit
  · intro j
    rw [p.relabel_full_sectors, map_mul, map_mul]

lemma relabel_polar_range :
    polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c)*
      (polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c))ᴴ =
      matrixRelabel s (1-jointResidual p.n) := by
  rw [← canonical_sectorProjection_sum]
  simp only [(p.relabel_transport s t).2.2]
  rw [matrixRelabel_sum, jointAxis_sum]

lemma relabel_sector_nonzero (j : q) :
    thresholdProjector ((relabelPOVM s t p.povm).effect j)
      ((relabelPOVM s t p.povm).positive j).1 p.c ≠ 0 := by
  rw [p.relabel_full_sectors, ← p.full_sectors]
  intro hz
  exact p.sectors_nonzero _ ((matrixRelabel s).injective (hz.trans (map_zero _).symm))

lemma relabel_sectors_nonempty : Nonempty (SectorIndex (relabelPOVM s t p.povm) p.c) := by
  letI : Nonempty e := ⟨s (Sum.inr 0)⟩
  letI : Nonempty q := ⟨t (Sum.inr 0)⟩
  exact sectorIndex_nonempty _ _ (fun j _ => p.relabel_sector_nonzero s t j)

theorem relabel_packing_exact : letI := p.relabel_sectors_nonempty s t
    packingAlpha (canonicalSynthesis (relabelPOVM s t p.povm) p.c)=p.a := by
  letI := p.relabel_sectors_nonempty s t
  let E := relabelPOVM s t p.povm
  let T := canonicalSynthesis E p.c
  let V := polarIsometry T
  let f := matrixRelabel s
  have hV : Vᴴ*V=1 := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T (p.relabel_transport s t).1)
  have hf : f p.factor*V=T := by
    dsimp only [V, T, E, f]
    rw [(p.relabel_transport s t).2.1, ← Matrix.mul_assoc, ← map_mul, p.factor_inverse, map_one, Matrix.one_mul]
  have hRP : jointResidual p.n*p.mean=0 := by
    have hh := congrArg Matrix.conjTranspose (jointMean_residual p.n p.w p.mean_unit)
    have hR : (jointResidual p.n).IsHermitian := (coordinateAxis_positive _).1
    simpa only [mean, Matrix.conjTranspose_mul, (jointMean_positive p.n p.w).1.eq, hR.eq,
      Matrix.conjTranspose_zero] using hh
  have hVP : V*Vᴴ*f p.mean=f p.mean := by
    dsimp only [V, T, E, f]
    rw [p.relabel_polar_range, ← map_mul, Matrix.sub_mul, Matrix.one_mul, hRP, sub_zero]
  apply packing_eq_of_physical_factor T V (f p.factor) (f p.mean) hV
    (matrixRelabel_hermitian s _ p.factor_positive.1) hf
    (matrixRelabel_hermitian s _ (jointMean_positive p.n p.w).1)
    (by rw [← map_mul]; exact congrArg f (jointMean_square p.n p.w p.mean_unit))
    (by rw [matrixRelabel_trace]; exact jointMean_trace p.n p.w p.mean_unit) hVP p.a p.a_pos.le
  · rw [← map_mul, show p.factor*p.mean=p.a • p.mean from
      twoLevelFactor_on_projection _ _ (jointMean_square p.n p.w p.mean_unit) (jointOld_mean p.n p.w) p.a p.g,
      map_smul]
  · have hh := twoLevelFactor_square_lower _ _ (jointOld_positive p.n) (jointMean_positive p.n p.w)
      (jointOld_square p.n) (jointMean_square p.n p.w p.mean_unit) (jointOld_mean p.n p.w)
      (jointMean_old p.n p.w) p.a p.g (by nlinarith [p.a_pos, p.a_le_one])
      (by nlinarith [p.a_pos, p.a_le_one, p.g_ge_one])
    have hp := matrixRelabel_positive s _ hh
    simpa only [f, factor, jointFactor, map_sub, map_mul, map_smul, map_one] using hp

theorem relabel_completion (j : q) :
    (canonicalCompletion (relabelPOVM s t p.povm) p.c (p.relabel_transport s t).1).effect j =
      matrixRelabel s ((canonicalCompletion p.povm p.c p.canonical_transport.1).effect (t.symm j)) := by
  rw [canonicalCompletion_effect]
  change sectorProjection (relabelPOVM s t p.povm) p.c
      (polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c)) j +
    (1-polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c)*
      (polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c))ᴴ)*
    matrixRelabel s (p.effect (t.symm j))*
    (1-polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c)*
      (polarIsometry (canonicalSynthesis (relabelPOVM s t p.povm) p.c))ᴴ) = _
  rw [(p.relabel_transport s t).2.2, p.relabel_polar_range, map_sub, map_one, sub_sub_cancel,
    p.completion_effect, map_add, map_mul, map_mul]

end JointFamilyData
end RCProof
