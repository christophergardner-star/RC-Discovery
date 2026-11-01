import RCProof.Instrument

/-! Construct prepared states on the completed sectors, including zero labels,
and prove the resulting instrument is completely positive and repeatable. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

noncomputable def normalizedPositive (Q : Matrix d d ℂ) : Matrix d d ℂ :=
  Q.trace.re⁻¹ • Q

lemma normalizedPositive_positive (Q : Matrix d d ℂ) (hQ : Q.PosSemidef) :
    (normalizedPositive Q).PosSemidef :=
  hQ.smul (inv_nonneg.mpr (Complex.nonneg_iff.mp hQ.trace_nonneg).1)

lemma normalizedPositive_trace (Q : Matrix d d ℂ) (hQ : Q.PosSemidef) (hne : Q ≠ 0) :
    (normalizedPositive Q).trace = 1 := by
  have him := (Complex.nonneg_iff.mp hQ.trace_nonneg).2
  have hreal : Q.trace = (Q.trace.re : ℂ) := by
    apply Complex.ext <;> simp [him]
  have ht : Q.trace ≠ 0 := fun h => hne (hQ.trace_eq_zero_iff.mp h)
  have hr : Q.trace.re ≠ 0 := by intro h; apply ht; rw [hreal, h]; rfl
  rw [normalizedPositive, Matrix.trace_smul]
  change ((Q.trace.re⁻¹ : ℝ) : ℂ) * Q.trace = 1
  conv_lhs => rhs; rw [hreal]
  rw [← Complex.ofReal_mul, inv_mul_cancel₀ hr, Complex.ofReal_one]

noncomputable def sectorProjection (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (j : o) : Matrix d d ℂ :=
  U * sectorCoordinate E c j * Uᴴ

noncomputable def sectorRecord (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (j : o) : Matrix d d ℂ :=
  normalizedPositive (sectorProjection E c U j)

noncomputable def completionInstrument (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (j : o) : MatrixMap d :=
  prepareMap (completedEffect U (sectorCoordinate E c j) (E.effect j)) (sectorRecord E c U j)

lemma sectorProjection_positive (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (j : o) : (sectorProjection E c U j).PosSemidef := by
  have hp := ((canonicalFrame E c).coordinates.positive j).mul_mul_conjTranspose_same U
  simpa only [canonicalFrame_coordinates, sectorProjection] using hp

lemma sectorCoordinate_mul (E : FinitePOVM d o) (c : ℝ) (i j : o) :
    sectorCoordinate E c i * sectorCoordinate E c j =
      if i = j then sectorCoordinate E c j else 0 := by
  by_cases hij : i = j
  · subst i
    simpa only [if_pos rfl, ite_true, canonicalFrame_coordinates] using
      (canonicalFrame E c).coordinate_idempotent j
  · rw [if_neg hij]
    ext x y
    simp only [sectorCoordinate, Matrix.diagonal_mul_diagonal, Matrix.diagonal_apply,
      Matrix.zero_apply]
    split_ifs <;> simp_all

lemma completedEffect_projection (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1) (i j : o) :
    completedEffect U (sectorCoordinate E c i) (E.effect i) * sectorProjection E c U j =
      if i = j then sectorProjection E c U j else 0 := by
  unfold sectorProjection
  rw [completedEffect_on_sector U hU, sectorCoordinate_mul]
  split_ifs <;> simp

lemma completedEffect_record (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1) (i j : o) :
    completedEffect U (sectorCoordinate E c i) (E.effect i) * sectorRecord E c U j =
      if i = j then sectorRecord E c U j else 0 := by
  unfold sectorRecord normalizedPositive
  rw [Matrix.mul_smul, completedEffect_projection E c U hU]
  split_ifs <;> simp

lemma completion_active_sector (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (j : o) (hF : completedEffect U (sectorCoordinate E c j) (E.effect j) ≠ 0) :
    sectorProjection E c U j ≠ 0 := by
  intro hQ
  have hC : sectorCoordinate E c j = 0 := by
    have hh := congrArg (fun A => Uᴴ * A * U) hQ
    have hid : Uᴴ * sectorProjection E c U j * U = sectorCoordinate E c j := by
      unfold sectorProjection
      calc
        _ = (Uᴴ * U) * sectorCoordinate E c j * (Uᴴ * U) := by simp only [Matrix.mul_assoc]
        _ = _ := by rw [hU, Matrix.one_mul, Matrix.mul_one]
    simpa only [hid, Matrix.mul_zero, Matrix.zero_mul] using hh
  have hB : canonicalBlock E c j = 0 := Matrix.conjTranspose_mul_self_eq_zero.mp
    ((canonicalBlock_gram E c j).trans hC)
  have hP : thresholdProjector (E.effect j) (E.positive j).1 c = 0 := by
    rw [← canonicalBlock_full, hB, Matrix.zero_mul]
  have hE : E.effect j = 0 := by
    by_contra hne
    exact hsector j hne hP
  apply hF
  simp [completedEffect, hC, hE]

theorem completionInstrument_cp (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1) (j : o) :
    CompletelyPositive (completionInstrument E c U j) := by
  apply prepareMap_completelyPositive
  · apply completedEffect_positive U hU _ _ _ (E.positive j)
    rw [← canonicalFrame_coordinates]
    exact (canonicalFrame E c).coordinates.positive j
  · exact normalizedPositive_positive _ (sectorProjection_positive E c U j)

theorem completionInstrument_probability (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (j : o) (X : Matrix d d ℂ) :
    (completionInstrument E c U j X).trace =
      (completedEffect U (sectorCoordinate E c j) (E.effect j) * X).trace := by
  by_cases hF : completedEffect U (sectorCoordinate E c j) (E.effect j) = 0
  · simp [completionInstrument, prepareMap, hF]
  · have ht := normalizedPositive_trace _ (sectorProjection_positive E c U j)
      (completion_active_sector E c U hU hsector j hF)
    simpa [completionInstrument, prepareMap, Matrix.trace_smul, sectorRecord, ht]

theorem completionInstrument_repeatable (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (i j : o) (X : Matrix d d ℂ) :
    completionInstrument E c U i (completionInstrument E c U j X) =
      if i = j then completionInstrument E c U j X else 0 := by
  unfold completionInstrument
  rw [prepareMap_comp, completedEffect_record E c U hU]
  by_cases hij : i = j
  · subst i
    rw [if_pos rfl, if_pos rfl]
    by_cases hF : completedEffect U (sectorCoordinate E c j) (E.effect j) = 0
    · simp [prepareMap, hF]
    · have ht := normalizedPositive_trace _ (sectorProjection_positive E c U j)
        (completion_active_sector E c U hU hsector j hF)
      change (normalizedPositive (sectorProjection E c U j)).trace • _ = _
      rw [ht, one_smul]
  · simp [hij]

theorem completionInstrument_trace_preserving (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (X : Matrix d d ℂ) : (∑ j, completionInstrument E c U j X).trace = X.trace := by
  rw [Matrix.trace_sum]
  simp only [completionInstrument_probability E c U hU hsector]
  rw [← Matrix.trace_sum, ← Matrix.sum_mul,
    completedEffect_sum U hU _ _ (sectorCoordinate_sum E c) E.normalized, Matrix.one_mul]

noncomputable def completionChannel (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) : MatrixMap d := ∑ j, completionInstrument E c U j

lemma amplify_sum_maps {r : Type*} (Φ : o → MatrixMap d)
    (X : Matrix (d × r) (d × r) ℂ) :
    amplify (∑ j, Φ j) X = ∑ j, amplify (Φ j) X := by
  ext x y
  simpa only [amplify, Matrix.sum_apply] using
    congrArg (fun M : Matrix d d ℂ => M x.1 y.1)
      (LinearMap.sum_apply Finset.univ Φ (fun a b => X (a, x.2) (b, y.2)))

theorem completionChannel_cp (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1) :
    CompletelyPositive (completionChannel E c U) := by
  intro n X hX
  rw [completionChannel, amplify_sum_maps]
  exact Matrix.posSemidef_sum _ (fun j _ => completionInstrument_cp E c U hU j n X hX)

theorem completionChannel_idempotent (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (X : Matrix d d ℂ) :
    completionChannel E c U (completionChannel E c U X) = completionChannel E c U X := by
  simp [completionChannel, LinearMap.sum_apply, map_sum,
    completionInstrument_repeatable E c U hU hsector]

/-- With the polar isometry constructed, the instrument properties use exactly
injective synthesis and the nonzero-sector condition, with no supplied states. -/
theorem canonical_repeatable_instrument (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0) :
    let U := polarIsometry (canonicalSynthesis E c)
    (∀ j, CompletelyPositive (completionInstrument E c U j)) ∧
    (∀ X, (completionChannel E c U X).trace = X.trace) ∧
    (∀ i j X, completionInstrument E c U i (completionInstrument E c U j X) =
      if i = j then completionInstrument E c U j X else 0) := by
  have hU := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  refine ⟨completionInstrument_cp E c _ hU, ?_, completionInstrument_repeatable E c _ hU hsector⟩
  intro X
  simpa only [completionChannel, LinearMap.sum_apply] using
    completionInstrument_trace_preserving E c _ hU hsector X

end RCProof
