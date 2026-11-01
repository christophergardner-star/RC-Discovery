import RCProof.MeasurementDistance
import RCProof.CanonicalAngles
import RCProof.DiamondScalar

/-! The frozen same-label construction and its full, unhalved diamond-norm
estimate. The width hypothesis is removed by the nontrivial-radius split. -/
namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

noncomputable def canonicalCompletion (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) : FinitePOVM d o :=
  completedPOVM (polarIsometry (canonicalSynthesis E c))
    (polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT))
    (canonicalFrame E c).coordinates E

lemma canonicalCompletion_effect (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) (j : o) :
    (canonicalCompletion E c hT).effect j =
      completedEffect (polarIsometry (canonicalSynthesis E c)) (sectorCoordinate E c j) (E.effect j) := by
  change completedEffect _ ((canonicalFrame E c).coordinates.effect j) _ = _
  rw [canonicalFrame_coordinates]

theorem canonical_measurement_diamond_sharp (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 < c) (hc1 : c ≤ 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hwidth : ((Real.sqrt c)⁻¹ - packingAlpha (canonicalSynthesis E c)) * (1 - Real.sqrt c) ≤
      4 * packingAlpha (canonicalSynthesis E c) * Real.sqrt c) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E c hT)) ≤
      ENNReal.ofReal (2 * Real.sqrt (1 - (packingAlpha (canonicalSynthesis E c) * Real.sqrt c) ^ 2)) := by
  let U := polarIsometry (canonicalSynthesis E c)
  let V := stack (canonicalBlock E c) * Uᴴ + naimark E * (1 - U * Uᴴ)
  obtain ⟨hV, hcV⟩ := canonical_hybrid_dilation_of_injective E c hT
  apply measurement_diamond_of_overlap E (canonicalCompletion E c hT) (naimark E) V
    (naimark_isometry E) hV (naimark_compression E)
  · intro j
    rw [canonicalCompletion_effect]
    exact hcV j
  · exact mul_nonneg (Real.sqrt_nonneg _) (Real.sqrt_nonneg _)
  · exact mul_le_one₀ (canonical_packing_le_one E c) (Real.sqrt_nonneg _)
      (by simpa using Real.sqrt_le_sqrt hc1)
  · exact canonical_hybrid_overlap_floor E c hc hc1 hT hwidth

/-- No width assumption remains. All complex inputs and all finite reference
systems occur in the diamondSize definition used here. -/
theorem canonical_measurement_diamond_bound (E : FinitePOVM d o) (c : ℝ)
    (hc : 1 / 2 ≤ c) (hc1 : c ≤ 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E c hT)) ≤
      ENNReal.ofReal (2 * min 1 (Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2) + Real.sqrt (1 - c))) := by
  have ha : 0 ≤ packingAlpha (canonicalSynthesis E c) := Real.sqrt_nonneg _
  have ha1 := canonical_packing_le_one E c
  by_cases hs : Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2) + Real.sqrt (1 - c) < 1
  · rw [min_eq_right hs.le]
    have hw := width_of_nontrivial_radius _ c ha ha1 hc hc1 hs
    apply (canonical_measurement_diamond_sharp E c (by linarith) hc1 hT hw).trans
    apply ENNReal.ofReal_le_ofReal
    have hrad := sharp_radius_le_sum _ c ha ha1 (by linarith) hc1
    linarith
  · rw [min_eq_left (le_of_not_gt hs), mul_one]
    exact measurement_diamond_le_two E _

/-- The delta-parameterized estimate in the frozen theorem. -/
theorem frozen_measurement_diamond_bound (E : FinitePOVM d o) (δ : ℝ)
    (hδ : 0 < δ) (hδhalf : δ < 1 / 2) [Nonempty (SectorIndex E (1 - δ))]
    (hT : Function.Injective (canonicalSynthesis E (1 - δ)).mulVec) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E (1 - δ) hT)) ≤
      ENNReal.ofReal (2 * min 1 (Real.sqrt (1 - packingAlpha (canonicalSynthesis E (1 - δ)) ^ 2) + Real.sqrt δ)) := by
  have h := canonical_measurement_diamond_bound E (1 - δ) (by linarith) (by linarith) hT
  simpa only [sub_sub_cancel] using h

end RCProof
