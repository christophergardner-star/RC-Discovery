import RCProof.PerfectExampleSectors
import RCProof.DiamondWitness

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

lemma exampleAxis_ne_zero (j : Fin 6) : exampleAxis j ≠ 0 := by
  intro hz
  have hh := congrArg (fun A : Matrix (Fin 6) (Fin 6) ℂ => A j j) hz
  simpa [exampleAxis, realDiagonal] using hh

lemma example_axes_sum : (∑ j : Fin 5, exampleAxis j.castSucc) = 1 - exampleAxis 5 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [exampleAxis, realDiagonal, Fin.sum_univ_succ, Matrix.one_apply, Matrix.diagonal_apply]

lemma perfectExample_nonempty (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) : Nonempty (SectorIndex (perfectExample b h hb hb2 hh) (1 - b ^ 2)) := by
  apply sectorIndex_nonempty
  intro j _
  rw [perfectExample_full_sectors]
  exact exampleAxis_ne_zero _

lemma perfectExample_synthesis_isometry (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) :
    (canonicalSynthesis (perfectExample b h hb hb2 hh) (1 - b ^ 2))ᴴ *
      canonicalSynthesis (perfectExample b h hb hb2 hh) (1 - b ^ 2) = 1 := by
  apply orthogonal_sectors_synthesis_isometry
  intro i j hij
  rw [perfectExample_full_sectors, perfectExample_full_sectors, exampleAxis_mul]
  exact if_neg (fun heq => hij (Fin.castSucc_injective 5 heq))

lemma perfectExample_injective (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) :
    Function.Injective (canonicalSynthesis (perfectExample b h hb hb2 hh) (1 - b ^ 2)).mulVec :=
  isometry_mulVec_injective _ (perfectExample_synthesis_isometry b h hb hb2 hh)

theorem perfectExample_completion (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) (j : Fin 5) :
    (canonicalCompletion (perfectExample b h hb hb2 hh) (1 - b ^ 2)
      (perfectExample_injective b h hb hb2 hh)).effect j =
      exampleAxis j.castSucc + exampleAxis 5 * perfectExampleEffect b h j * exampleAxis 5 := by
  let E := perfectExample b h hb hb2 hh
  let c := 1 - b ^ 2
  let U := polarIsometry (canonicalSynthesis E c)
  letI := perfectExample_nonempty b h hb hb2 hh
  have hα : packingAlpha (canonicalSynthesis E c) = 1 :=
    packingAlpha_isometry _ (perfectExample_synthesis_isometry b h hb hb2 hh)
  have hQ (i : Fin 5) : sectorProjection E c U i = exampleAxis i.castSucc :=
    (perfect_packing_sectors E c (perfectExample_injective b h hb hb2 hh) hα i).symm.trans
      (perfectExample_full_sectors b h hb hb2 hh i)
  have hsum : U * Uᴴ = 1 - exampleAxis 5 := by
    rw [← canonical_sectorProjection_sum E c U]
    simp only [hQ]
    exact example_axes_sum
  rw [canonicalCompletion_effect]
  change sectorProjection E c U j + (1 - U * Uᴴ) * E.effect j * (1 - U * Uᴴ) = _
  rw [hQ, hsum, sub_sub_cancel]
  rfl

noncomputable def perfectExampleState (b h : ℝ) : Matrix (Fin 6) (Fin 6) ℂ :=
  (2 - b)⁻¹ • vecMulVec (![1, 0, 0, 0, 0, (h : ℂ)]) (star (![1, 0, 0, 0, 0, (h : ℂ)]))

lemma perfectExampleState_positive (b h : ℝ) (hb : b < 2) : (perfectExampleState b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))

lemma perfectExampleState_trace (b h : ℝ) (hb : b < 2) (hh : h ^ 2 = 1 - b) :
    (perfectExampleState b h).trace = 1 := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ) - b ≠ 0 by linarith)
  have hh' : (h : ℂ) ^ 2 = 1 - b := by exact_mod_cast hh
  norm_num [perfectExampleState, Matrix.trace, Fin.sum_univ_succ, vecMulVec, Complex.real_smul]
  push_cast
  field_simp
  linear_combination hh'

noncomputable def perfectExampleTest : Matrix (Fin 5) (Fin 5) ℂ :=
  realDiagonal ![-1, 1, 1, -1, -1]

lemma perfectExampleTest_contraction : ‖perfectExampleTest‖ ≤ 1 := by
  apply realDiagonal_sign_contraction
  intro i
  fin_cases i <;> norm_num

set_option maxHeartbeats 1200000 in
theorem perfectExample_test_value (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) :
    (((measurementMap (perfectExample b h hb hb2 hh) -
      measurementMap (canonicalCompletion (perfectExample b h hb hb2 hh) (1 - b ^ 2)
        (perfectExample_injective b h hb hb2 hh))) (perfectExampleState b h)) * perfectExampleTest).trace =
      (perfectEnvelope b : ℂ) := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ) - b ≠ 0 by nlinarith)
  have hh' : (h : ℂ) ^ 2 = 1 - b := by exact_mod_cast hh
  change ((Matrix.diagonal (fun j => (((perfectExample b h hb hb2 hh).effect j) * perfectExampleState b h).trace) -
    Matrix.diagonal (fun j => ((canonicalCompletion (perfectExample b h hb hb2 hh) (1 - b ^ 2)
      (perfectExample_injective b h hb hb2 hh)).effect j * perfectExampleState b h).trace)) * perfectExampleTest).trace = _
  simp only [perfectExample_completion]
  norm_num [perfectExample, perfectExampleEffect, perfectExampleState, perfectExampleTest,
    exampleAxis, realDiagonal, examplePlus, exampleMinus, examplePlusVector, exampleMinusVector,
    Matrix.mul_apply, Matrix.trace, Fin.sum_univ_succ, Matrix.diagonal_apply, vecMulVec,
    Complex.real_smul, perfectEnvelope]
  push_cast
  field_simp
  ring_nf
  simp only [hh']
  ring

/-- The concrete six-dimensional family attains the exact bound for every
0<b^2<1/2. Its density witness is system-only; the upper bound is fully stabilized. -/
theorem perfectExample_attains (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) :
    diamondSize (measurementMap (perfectExample b h hb hb2 hh) -
      measurementMap (canonicalCompletion (perfectExample b h hb hb2 hh) (1 - b ^ 2)
        (perfectExample_injective b h hb hb2 hh))) = ENNReal.ofReal (perfectEnvelope b) := by
  letI := perfectExample_nonempty b h hb hb2 hh
  have hα := packingAlpha_isometry _ (perfectExample_synthesis_isometry b h hb hb2 hh)
  apply le_antisymm
  · have hu := perfect_packing_diamond_upper (perfectExample b h hb hb2 hh) (b ^ 2)
      (sq_pos_of_pos hb) (by linarith) (perfectExample_injective b h hb hb2 hh) hα
    simpa only [Real.sqrt_sq hb.le] using hu
  · have hl := diamondSize_ge_state_test
      (measurementMap (perfectExample b h hb hb2 hh) -
        measurementMap (canonicalCompletion (perfectExample b h hb hb2 hh) (1 - b ^ 2)
          (perfectExample_injective b h hb hb2 hh))) (perfectExampleState b h)
      (perfectExampleState_positive b h (by nlinarith))
      (perfectExampleState_trace b h (by nlinarith) hh) perfectExampleTest perfectExampleTest_contraction
    rw [perfectExample_test_value b h hb hb2 hh, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (show 0 < perfectEnvelope b from div_pos (by linarith) (by nlinarith))] at hl
    exact hl

end RCProof
