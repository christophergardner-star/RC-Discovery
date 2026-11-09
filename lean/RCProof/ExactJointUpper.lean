import RCProof.CoupledMeasurement
import RCProof.JointUpper
import RCProof.WorstCase

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o r : Type*} [Fintype d] [Fintype o] [Fintype r]
  [DecidableEq d] [DecidableEq o] [DecidableEq r]

/-- The exact-envelope upper bound for the actual canonical completion,
on arbitrary complex inputs and every finite ancillary space. -/
theorem canonical_exact_joint_all_inputs (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c < 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (measurementMap E - measurementMap (canonicalCompletion E c hT)) X) ≤
      perfectEnvelope (Real.sqrt (jointDefect E c)) * traceNorm X := by
  let U := polarIsometry (canonicalSynthesis E c)
  let C := Real.sqrt c • polarRoot (canonicalSynthesis E c)
  let R := 1 - U * Uᴴ
  let B := fun j => E.effect j - uniformSelectedEffect E c j
  let Q := sectorProjection E c U
  let m := packingAlpha (canonicalSynthesis E c) * Real.sqrt c
  let b := Real.sqrt (jointDefect E c)
  have hU := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  have hR := residual_projection_properties U hU
  have hC : C.IsHermitian := ((positiveRoot_positive _ _).smul (Real.sqrt_nonneg c)).1
  obtain ⟨G, hG, hGR, hGG, hsum, hAR⟩ := canonical_uniform_remainder_data E c hc hT
  obtain ⟨hε, hε1⟩ := jointDefect_range E c hc hc1 hT
  have hb : 0 < b := Real.sqrt_pos.mpr hε
  have hb1 : b ≤ 1 := (Real.sqrt_le_one).mpr hε1.le
  have hm : 0 ≤ m := mul_nonneg (packingAlpha_pos _ hT).le (Real.sqrt_nonneg c)
  have hcircle : b ^ 2 + m ^ 2 = 1 := by
    dsimp only [b, m]
    rw [Real.sq_sqrt hε.le, mul_pow, Real.sq_sqrt hc.le]
    unfold jointDefect
    ring
  have hA (j : o) : (sectorCoordinate E c j).PosSemidef := by
    rw [← canonicalBlock_gram]
    exact Matrix.posSemidef_conjTranspose_mul_self _
  have hh := coupled_measurement_all_inputs B (sectorCoordinate E c)
    (uniform_remainder_positive E c) hA (sectorCoordinate_sum E c) U C G R hC hG hR.2.2
    hR.2.1 hGR rfl hGG hsum b m hb hb1 hm hcircle
    (canonical_uniform_filter_bounds E c hc hT).1 (canonical_uniform_filter_bounds E c hc hT).2 X
  have heffect : (fun j => E.effect j - (canonicalCompletion E c hT).effect j) =
      fun j => (B j - R * B j * R) + (uniformSelectedEffect E c j - Q j) := by
    funext j
    rw [canonicalCompletion_effect]
    change E.effect j - (Q j + R * E.effect j * R) = _
    have hBR : R * B j * R = R * E.effect j * R := by
      dsimp only [B]
      rw [Matrix.mul_sub R (E.effect j) (uniformSelectedEffect E c j),
        Matrix.sub_mul (R * E.effect j) (R * uniformSelectedEffect E c j) R, hAR j, sub_zero]
    rw [hBR]
    dsimp only [B]
    abel
  have hmaps : measurementMap E - measurementMap (canonicalCompletion E c hT) =
      (effectMap B - effectMap (fun j => R * B j * R)) +
        (effectMap (fun j => U * C * sectorCoordinate E c j * C * Uᴴ) -
          effectMap (fun j => U * sectorCoordinate E c j * Uᴴ)) := by
    change effectMap E.effect - effectMap (canonicalCompletion E c hT).effect = _
    rw [← effectMap_sub, heffect, effectMap_add]
    simp only [effectMap_sub]
    congr 2
    · congr 1
      funext j
      exact uniform_selected_factor E c hc.le hT j
  rw [hmaps]
  exact hh

theorem canonical_exact_joint_diamond_upper (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 < c) (hc1 : c < 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E c hT)) ≤
      ENNReal.ofReal (perfectEnvelope (Real.sqrt (jointDefect E c))) := by
  apply diamondSize_le_of_all_inputs
  intro n X hX
  have hu := canonical_exact_joint_all_inputs E c hc hc1 hT X
  have hb : Real.sqrt (jointDefect E c) ≤ 1 :=
    (Real.sqrt_le_one).mpr (jointDefect_range E c hc hc1 hT).2.le
  have hnon : 0 ≤ perfectEnvelope (Real.sqrt (jointDefect E c)) :=
    div_nonneg (by positivity) (by linarith)
  exact hu.trans (by nlinarith)

theorem packingWorstCase_exact_joint_upper (a δ : ℝ) (hδ : 0 < δ) (hδ2 : δ < 1 / 2) :
    packingWorstCase a δ ≤ ENNReal.ofReal (perfectEnvelope (Real.sqrt (1 - a ^ 2 * (1 - δ)))) := by
  apply iSup_le
  intro E
  letI := E.sectors_nonempty
  have hu := canonical_exact_joint_diamond_upper E.povm (1 - δ) (by linarith) (by linarith) E.synthesis_injective
  simpa only [packedDistance, jointDefect, E.exact_alpha] using hu

end RCProof
