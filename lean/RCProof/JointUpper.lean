import RCProof.SelectedMeasurement

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o r : Type*} [Fintype d] [Fintype o] [Fintype r]
  [DecidableEq d] [DecidableEq o] [DecidableEq r]

noncomputable def jointDefect (E : FinitePOVM d o) (c : ℝ) [Nonempty (SectorIndex E c)] : ℝ :=
  1 - packingAlpha (canonicalSynthesis E c) ^ 2 * c

noncomputable def jointUpper (E : FinitePOVM d o) (c : ℝ) [Nonempty (SectorIndex E c)] : ℝ :=
  2 * Real.sqrt (jointDefect E c) / Real.sqrt (4 - jointDefect E c) + 2 * selectedCorrectionRadius E c

lemma jointDefect_range (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c < 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    0 < jointDefect E c ∧ jointDefect E c < 1 := by
  have ha := packingAlpha_pos (canonicalSynthesis E c) hT
  have ha1 := canonical_packing_le_one E c
  have ha2 : packingAlpha (canonicalSynthesis E c) ^ 2 ≤ 1 := by nlinarith
  have hpos := mul_pos (sq_pos_of_pos ha) hc
  have hup := mul_le_mul_of_nonneg_right ha2 hc.le
  unfold jointDefect
  constructor <;> nlinarith

theorem canonical_joint_all_inputs (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c < 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (measurementMap E - measurementMap (canonicalCompletion E c hT)) X) ≤
      jointUpper E c * traceNorm X := by
  let U := polarIsometry (canonicalSynthesis E c)
  let R := 1 - U * Uᴴ
  let B := fun j => E.effect j - selectedEffect E c j
  let Q := sectorProjection E c U
  have hU := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  have hR := residual_projection_properties U hU
  obtain ⟨G, hG, hGR, hgap, hsum, hAR⟩ := canonical_remainder_data E c hc.le hT
  obtain ⟨hε, hε1⟩ := jointDefect_range E c hc hc1 hT
  have hres := remainder_measurement_bound B (remainderEffect_positive E c) G R hG hR.2.2
    hR.2.1 hGR hsum (jointDefect E c) hε hε1 hgap X
  have hsel := canonical_selected_measurement_bound E c hc hc1.le hT X
  have heffect : (fun j => E.effect j - (canonicalCompletion E c hT).effect j) =
      fun j => (B j - R * B j * R) + (selectedEffect E c j - Q j) := by
    funext j
    rw [canonicalCompletion_effect]
    change E.effect j - (Q j + R * E.effect j * R) = _
    have hBR : R * B j * R = R * E.effect j * R := by
      dsimp only [B]
      rw [Matrix.mul_sub R (E.effect j) (selectedEffect E c j),
        Matrix.sub_mul (R * E.effect j) (R * selectedEffect E c j) R, hAR j, sub_zero]
    rw [hBR]
    dsimp only [B]
    abel
  have hmaps : measurementMap E - measurementMap (canonicalCompletion E c hT) =
      (effectMap B - effectMap (fun j => R * B j * R)) + (effectMap (selectedEffect E c) - effectMap Q) := by
    change effectMap E.effect - effectMap (canonicalCompletion E c hT).effect = _
    rw [← effectMap_sub, heffect, effectMap_add]
    simp only [effectMap_sub]
  rw [hmaps]
  change traceNorm (amplifyRect (effectMap B - effectMap (fun j => R * B j * R)) X +
    amplifyRect (effectMap (selectedEffect E c) - effectMap Q) X) ≤ _
  apply (traceNorm_add _ _).trans
  have hh := add_le_add hres hsel
  convert hh using 1 <;> unfold jointUpper <;> ring

/-- The later joint finite-error upper bound, without the old width condition.
This is an upper theorem, not an optimal-envelope or lower-construction claim. -/
theorem canonical_joint_diamond_upper (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c < 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E c hT)) ≤
      ENNReal.ofReal (min 2 (jointUpper E c)) := by
  by_cases hh : jointUpper E c ≤ 2
  · rw [min_eq_right hh]
    apply diamondSize_le_of_all_inputs
    intro n X hX
    have hu := canonical_joint_all_inputs E c hc hc1 hT X
    have hcor : 0 ≤ selectedCorrectionRadius E c := (norm_nonneg _).trans
      (canonical_selected_operator_close E c hc hc1.le hT)
    have hnon : 0 ≤ jointUpper E c := by unfold jointUpper; positivity
    exact hu.trans (by nlinarith)
  · rw [min_eq_left (le_of_not_ge hh)]
    exact measurement_diamond_le_two E _

end RCProof
