import RCProof.PerfectExample
import RCProof.PerfectGeometry

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

lemma example_aux_axis_zero (b h : ℝ) (j : Fin 6) (hj0 : j ≠ 0) (hj5 : j ≠ 5) :
    examplePlus b h * exampleAxis j = 0 ∧ exampleMinus b h * exampleAxis j = 0 := by
  have hp : examplePlusVector b h j = 0 := by fin_cases j <;> simp_all [examplePlusVector]
  have hm : exampleMinusVector b h j = 0 := by fin_cases j <;> simp_all [exampleMinusVector]
  constructor <;> ext a v <;>
    simp only [examplePlus, exampleMinus, exampleAxis, realDiagonal, Matrix.smul_mul, Matrix.mul_diagonal,
      Matrix.smul_apply, vecMulVec, Pi.star_apply]
  all_goals
    by_cases hv : v = j
    · subst v
      simp [hp, hm]
    · simp [hv]

lemma example_aux_complement_positive (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) (j : Fin 6) (hj0 : j ≠ 0) (hj5 : j ≠ 5) :
    (1 - exampleAxis j - examplePlus b h).PosSemidef ∧
      (1 - exampleAxis j - exampleMinus b h).PosSemidef := by
  have hb1 : b < 2 := by nlinarith
  have hd : (1 - exampleAxis j - (b ^ 2 • exampleAxis 0 + exampleAxis 5)).PosSemidef := by
    have heq : 1 - exampleAxis j - (b ^ 2 • exampleAxis 0 + exampleAxis 5) =
        realDiagonal (fun i => 1 - (if i = j then 1 else 0) -
          (b ^ 2 * (if i = 0 then 1 else 0) + (if i = 5 then 1 else 0))) := by
      ext i k
      simp only [exampleAxis, realDiagonal, Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply,
        Matrix.diagonal_apply, Matrix.one_apply, Complex.real_smul]
      split_ifs <;> simp_all <;> push_cast <;> ring
    rw [heq]
    apply realDiagonal_positive
    intro i
    fin_cases j <;> fin_cases i <;> norm_num at * <;> simp only [abs_of_pos hb] <;> nlinarith
  have hs := example_aux_sum b h (by linarith) hh
  constructor
  · convert hd.add (exampleMinus_positive b h hb1) using 1
    rw [← hs]
    abel
  · convert hd.add (examplePlus_positive b h hb1) using 1
    rw [← hs]
    abel

theorem perfectExample_full_sectors (b h : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2)
    (hh : h ^ 2 = 1 - b) (j : Fin 5) :
    thresholdProjector ((perfectExample b h hb hb2 hh).effect j)
      ((perfectExample b h hb hb2 hh).positive j).1 (1 - b ^ 2) = exampleAxis j.castSucc := by
  let E := perfectExample b h hb hb2 hh
  have hPP (i : Fin 6) : exampleAxis i * exampleAxis i = exampleAxis i := by simp [exampleAxis_mul]
  by_cases hj : j = 0
  · subst j
    apply thresholdProjector_eq_of_isolated_projection _ _ (E.positive 0).1 (exampleAxis_positive 0)
      (hPP 0) (1 - b ^ 2) 0 (1 - b ^ 2) (by nlinarith) le_rfl
    · change ((1 - b ^ 2) • exampleAxis 0) * exampleAxis 0 = _
      rw [Matrix.smul_mul, hPP]
    · change ((1 - b ^ 2) • exampleAxis 0 + (0 : ℝ) • (1 - exampleAxis 0) - (1 - b ^ 2) • exampleAxis 0).PosSemidef
      simpa only [zero_smul, add_zero, sub_self] using
        (Matrix.PosSemidef.zero : (0 : Matrix (Fin 6) (Fin 6) ℂ).PosSemidef)
  · have hj0 : j.castSucc ≠ (0 : Fin 6) := by
      intro hz
      apply hj
      apply Fin.ext
      exact congrArg (fun x : Fin 6 => x.val) hz
    have hj5 : j.castSucc ≠ (5 : Fin 6) := by
      intro hz
      have hz' : j.val = 5 := congrArg (fun x : Fin 6 => x.val) hz
      omega
    have hz := example_aux_axis_zero b h j.castSucc hj0 hj5
    have hlow := example_aux_complement_positive b h hb hb2 hh j.castSucc hj0 hj5
    have hchoice : E.effect j = exampleAxis j.castSucc + (1 / 2 : ℝ) • examplePlus b h ∨
        E.effect j = exampleAxis j.castSucc + (1 / 2 : ℝ) • exampleMinus b h := by
      fin_cases j <;> simp_all [E, perfectExample, perfectExampleEffect]
    apply thresholdProjector_eq_of_isolated_projection _ _ (E.positive j).1 (exampleAxis_positive _)
      (hPP _) 1 (1 / 2) (1 - b ^ 2) (by linarith) (by nlinarith)
    · rcases hchoice with hp | hm
      · rw [hp, Matrix.add_mul, Matrix.smul_mul, hPP, hz.1, smul_zero, add_zero, one_smul]
      · rw [hm, Matrix.add_mul, Matrix.smul_mul, hPP, hz.2, smul_zero, add_zero, one_smul]
    · rcases hchoice with hp | hm
      · rw [hp]
        convert hlow.1.smul (show (0 : ℝ) ≤ 1 / 2 by norm_num) using 1 <;> module
      · rw [hm]
        convert hlow.2.smul (show (0 : ℝ) ≤ 1 / 2 by norm_num) using 1 <;> module

end RCProof
