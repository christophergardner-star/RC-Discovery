import RCProof.PerfectAttainment
import RCProof.JointAsymptotic

namespace RCProof
set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

/-- An admissible finite-dimensional measurement at the exact requested
packing parameter and threshold. Every nonzero label has its full selected
sector. Dimensions and outcome counts are part of the data. -/
structure PackedMeasurement (a δ : ℝ) where
  dimension : ℕ
  outcomes : ℕ
  povm : FinitePOVM (Fin dimension) (Fin outcomes)
  sectors_nonempty : Nonempty (SectorIndex povm (1 - δ))
  synthesis_injective : Function.Injective (canonicalSynthesis povm (1 - δ)).mulVec
  exact_alpha : letI := sectors_nonempty; packingAlpha (canonicalSynthesis povm (1 - δ)) = a
  active_sector : ∀ j, povm.effect j ≠ 0 →
    thresholdProjector (povm.effect j) (povm.positive j).1 (1 - δ) ≠ 0

noncomputable def packedDistance {a δ : ℝ} (M : PackedMeasurement a δ) : ENNReal :=
  diamondSize (measurementMap M.povm -
    measurementMap (canonicalCompletion M.povm (1 - δ) M.synthesis_injective))

/-- Worst-case distance over finite complex matrix spaces with exact packing
parameter; neither a numerical proxy nor a postulated scalar envelope. -/
noncomputable def packingWorstCase (a δ : ℝ) : ENNReal := ⨆ M : PackedMeasurement a δ, packedDistance M

lemma packedDistance_le_worstCase {a δ : ℝ} (M : PackedMeasurement a δ) :
    packedDistance M ≤ packingWorstCase a δ := le_iSup (fun M => packedDistance M) M

theorem packingWorstCase_le_two (a δ : ℝ) : packingWorstCase a δ ≤ 2 := by
  apply iSup_le
  intro M
  exact (measurement_diamond_le_two M.povm _).trans (by norm_num)

theorem packingWorstCase_joint_upper (a δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1) :
    packingWorstCase a δ ≤ ENNReal.ofReal
      (2 * Real.sqrt (1 - a ^ 2 * (1 - δ)) / Real.sqrt (4 - (1 - a ^ 2 * (1 - δ))) +
        2 * (max (1 - a) ((Real.sqrt (1 - δ))⁻¹ - 1) + (1 - Real.sqrt (1 - δ)))) := by
  apply iSup_le
  intro M
  letI := M.sectors_nonempty
  have hh := canonical_joint_diamond_upper M.povm (1 - δ) (by linarith) (by linarith) M.synthesis_injective
  apply hh.trans
  apply ENNReal.ofReal_le_ofReal
  have heq := M.exact_alpha
  simp only [jointUpper, jointDefect, selectedCorrectionRadius, heq]
  exact min_le_right _ _

theorem packingWorstCase_uniform_upper (a δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    (hs : 1 - a ^ 2 + δ ≤ 1 / 4) :
    packingWorstCase a δ ≤ ENNReal.ofReal (Real.sqrt (1 - a ^ 2 + δ) + 5 * (1 - a ^ 2 + δ)) := by
  apply iSup_le
  intro M
  letI := M.sectors_nonempty
  have heq := M.exact_alpha
  have hh := canonical_joint_uniform_diamond_upper M.povm (1 - δ) (by linarith) (by linarith)
    M.synthesis_injective (by simpa only [heq, sub_sub_cancel] using hs)
  simpa only [packedDistance, heq, sub_sub_cancel] using hh

theorem packingWorstCase_perfect_upper (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1) :
    packingWorstCase 1 δ ≤ ENNReal.ofReal (perfectEnvelope (Real.sqrt δ)) := by
  apply iSup_le
  intro M
  letI := M.sectors_nonempty
  exact perfect_packing_diamond_upper M.povm δ hδ hδ1 M.synthesis_injective M.exact_alpha

noncomputable def perfectPackedExample (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) : PackedMeasurement 1 (b ^ 2) where
  dimension := 6
  outcomes := 5
  povm := perfectExample b h hb hb2 hh
  sectors_nonempty := perfectExample_nonempty b h hb hb2 hh
  synthesis_injective := perfectExample_injective b h hb hb2 hh
  exact_alpha := by
    letI := perfectExample_nonempty b h hb hb2 hh
    exact packingAlpha_isometry _ (perfectExample_synthesis_isometry b h hb hb2 hh)
  active_sector := by
    intro j _
    rw [perfectExample_full_sectors]
    exact exampleAxis_ne_zero _

theorem packingWorstCase_perfect_exact (δ : ℝ) (hδ : 0 < δ) (hδ2 : δ < 1 / 2) :
    packingWorstCase 1 δ = ENNReal.ofReal (perfectEnvelope (Real.sqrt δ)) := by
  apply le_antisymm (packingWorstCase_perfect_upper δ hδ (by linarith))
  let b := Real.sqrt δ
  let h := Real.sqrt (1 - b)
  have hb : 0 < b := Real.sqrt_pos.mpr hδ
  have hb2 : b ^ 2 = δ := Real.sq_sqrt hδ.le
  have hb1 : b < 1 := by nlinarith
  have hh : h ^ 2 = 1 - b := Real.sq_sqrt (by linarith)
  have hm := packedDistance_le_worstCase (perfectPackedExample b h hb (by nlinarith) hh)
  change diamondSize (measurementMap (perfectExample b h hb (by nlinarith) hh) -
    measurementMap (canonicalCompletion _ (1 - b ^ 2) (perfectExample_injective b h hb (by nlinarith) hh))) ≤
      packingWorstCase 1 (b ^ 2) at hm
  rw [perfectExample_attains, hb2] at hm
  exact hm

end RCProof
