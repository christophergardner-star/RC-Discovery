import RCProof.ThresholdRecognition

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

noncomputable def exampleAxis (j : Fin 6) : Matrix (Fin 6) (Fin 6) ℂ :=
  realDiagonal (fun i => if i = j then 1 else 0)

lemma exampleAxis_positive (j : Fin 6) : (exampleAxis j).PosSemidef := by
  apply realDiagonal_positive
  intro i
  split_ifs <;> norm_num

lemma exampleAxis_mul (i j : Fin 6) : exampleAxis i * exampleAxis j =
    if i = j then exampleAxis i else 0 := by
  unfold exampleAxis
  rw [realDiagonal_mul]
  ext a b
  simp only [realDiagonal, Matrix.diagonal_apply]
  split_ifs <;> simp_all

noncomputable def examplePlusVector (b h : ℝ) : Fin 6 → ℂ := ![b, 0, 0, 0, 0, h]
noncomputable def exampleMinusVector (b h : ℝ) : Fin 6 → ℂ := ![b * h, 0, 0, 0, 0, -1]

noncomputable def examplePlus (b h : ℝ) : Matrix (Fin 6) (Fin 6) ℂ :=
  (2 - b)⁻¹ • vecMulVec (examplePlusVector b h) (star (examplePlusVector b h))
noncomputable def exampleMinus (b h : ℝ) : Matrix (Fin 6) (Fin 6) ℂ :=
  (2 - b)⁻¹ • vecMulVec (exampleMinusVector b h) (star (exampleMinusVector b h))

lemma examplePlus_positive (b h : ℝ) (hb : b < 2) : (examplePlus b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))
lemma exampleMinus_positive (b h : ℝ) (hb : b < 2) : (exampleMinus b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))

lemma example_aux_sum (b h : ℝ) (hb : b ≠ 2) (hh : h ^ 2 = 1 - b) :
    examplePlus b h + exampleMinus b h = b ^ 2 • exampleAxis 0 + exampleAxis 5 := by
  have hz : (2 - b : ℂ) ≠ 0 := by
    exact_mod_cast (show (2 : ℝ) - b ≠ 0 by intro hz; apply hb; linarith)
  have hh' : (h : ℂ) ^ 2 = 1 - b := by exact_mod_cast hh
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [examplePlus, exampleMinus, examplePlusVector, exampleMinusVector, exampleAxis,
      realDiagonal, vecMulVec, Matrix.diagonal_apply, Complex.real_smul] <;>
    push_cast <;> field_simp <;> ring_nf <;> simp only [hh'] <;> ring

noncomputable def perfectExampleEffect (b h : ℝ) : Fin 5 → Matrix (Fin 6) (Fin 6) ℂ :=
  ![(1 - b ^ 2) • exampleAxis 0,
    exampleAxis 1 + (1 / 2 : ℝ) • examplePlus b h,
    exampleAxis 2 + (1 / 2 : ℝ) • examplePlus b h,
    exampleAxis 3 + (1 / 2 : ℝ) • exampleMinus b h,
    exampleAxis 4 + (1 / 2 : ℝ) • exampleMinus b h]

theorem perfectExample_positive (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2) :
    ∀ j, (perfectExampleEffect b h j).PosSemidef := by
  have hb1 : b < 2 := by nlinarith
  intro j
  fin_cases j
  · exact (exampleAxis_positive 0).smul (by nlinarith)
  · exact (exampleAxis_positive 1).add ((examplePlus_positive b h hb1).smul (by norm_num))
  · exact (exampleAxis_positive 2).add ((examplePlus_positive b h hb1).smul (by norm_num))
  · exact (exampleAxis_positive 3).add ((exampleMinus_positive b h hb1).smul (by norm_num))
  · exact (exampleAxis_positive 4).add ((exampleMinus_positive b h hb1).smul (by norm_num))

theorem perfectExample_normalized (b h : ℝ) (hb : b ≠ 2) (hh : h ^ 2 = 1 - b) :
    ∑ j, perfectExampleEffect b h j = 1 := by
  have haux := example_aux_sum b h hb hh
  have hex : (∑ j, perfectExampleEffect b h j) =
      exampleAxis 0 + exampleAxis 1 + exampleAxis 2 + exampleAxis 3 + exampleAxis 4 +
      (examplePlus b h + exampleMinus b h) - b ^ 2 • exampleAxis 0 := by
    simp only [Fin.sum_univ_succ, perfectExampleEffect, Matrix.cons_val_zero, Matrix.cons_val_succ,
      Fin.sum_univ_zero, add_zero]
    module
  rw [hex, haux]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [exampleAxis, realDiagonal, Matrix.diagonal_apply, Matrix.one_apply, Complex.real_smul] <;> ring

noncomputable def perfectExample (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) : FinitePOVM (Fin 6) (Fin 5) where
  effect := perfectExampleEffect b h
  positive := perfectExample_positive b h hb hb2
  normalized := perfectExample_normalized b h (by nlinarith) hh

end RCProof
