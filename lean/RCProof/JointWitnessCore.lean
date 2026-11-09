import RCProof.JointFamilyCore

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

noncomputable def jointPlusCore (b h : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2-b)⁻¹ • vecMulVec ![(b : ℂ), (h : ℂ)] (star ![(b : ℂ), (h : ℂ)])

noncomputable def jointMinusCore (b h : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2-b)⁻¹ • vecMulVec ![((b*h : ℝ) : ℂ), (-1 : ℂ)] (star ![((b*h : ℝ) : ℂ), (-1 : ℂ)])

noncomputable def jointStateCore (b h : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2-b)⁻¹ • vecMulVec ![(1 : ℂ), (h : ℂ)] (star ![(1 : ℂ), (h : ℂ)])

lemma jointPlusCore_positive (b h : ℝ) (hb : b < 2) : (jointPlusCore b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))

lemma jointMinusCore_positive (b h : ℝ) (hb : b < 2) : (jointMinusCore b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))

lemma jointStateCore_positive (b h : ℝ) (hb : b < 2) : (jointStateCore b h).PosSemidef :=
  (Matrix.posSemidef_vecMulVec_self_star _).smul (inv_nonneg.mpr (by linarith))

lemma jointCore_effect_sum (b h : ℝ) (hb : b < 2) (hh : h ^ 2 = 1-b) :
    jointPlusCore b h + jointMinusCore b h = b ^ 2 • coordinateAxis (0 : Fin 2) + coordinateAxis 1 := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-b ≠ 0 by linarith)
  have hh' : (h : ℂ) ^ 2 = 1-b := by exact_mod_cast hh
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [jointPlusCore, jointMinusCore, coordinateAxis, realDiagonal,
      vecMulVec, Matrix.diagonal_apply, Complex.real_smul] <;>
    push_cast <;> field_simp <;> ring_nf <;> simp only [hh'] <;> ring

lemma jointCore_state_trace (b h : ℝ) (hb : b < 2) (hh : h ^ 2 = 1-b) :
    (jointStateCore b h).trace = 1 := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-b ≠ 0 by linarith)
  have hh' : (h : ℂ) ^ 2 = 1-b := by exact_mod_cast hh
  norm_num [jointStateCore, Matrix.trace, Fin.sum_univ_succ, vecMulVec, Complex.real_smul]
  push_cast
  field_simp
  linear_combination hh'

lemma jointCore_plus_difference (b h : ℝ) (hb : b < 2) (hh : h ^ 2 = 1-b) :
    ((jointPlusCore b h - coordinateAxis (1 : Fin 2) * jointPlusCore b h * coordinateAxis (1 : Fin 2)) *
      jointStateCore b h).trace = ((b / (2-b) : ℝ) : ℂ) := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-b ≠ 0 by linarith)
  have hh' : (h : ℂ) ^ 2 = 1-b := by exact_mod_cast hh
  norm_num [jointPlusCore, jointStateCore, coordinateAxis, realDiagonal,
    Matrix.mul_apply, Matrix.trace, Fin.sum_univ_succ, Matrix.diagonal_apply,
    vecMulVec, Complex.real_smul]
  push_cast
  field_simp
  ring_nf
  simp only [hh']
  ring

lemma jointCore_minus_difference (b h : ℝ) (hb : b < 2) (hh : h ^ 2 = 1-b) :
    ((jointMinusCore b h - coordinateAxis (1 : Fin 2) * jointMinusCore b h * coordinateAxis (1 : Fin 2)) *
      jointStateCore b h).trace = ((-b*h^2 / (2-b) : ℝ) : ℂ) := by
  have hz : (2 - b : ℂ) ≠ 0 := by exact_mod_cast (show (2 : ℝ)-b ≠ 0 by linarith)
  have hh' : (h : ℂ) ^ 2 = 1-b := by exact_mod_cast hh
  norm_num [jointMinusCore, jointStateCore, coordinateAxis, realDiagonal,
    Matrix.mul_apply, Matrix.trace, Fin.sum_univ_succ, Matrix.diagonal_apply,
    vecMulVec, Complex.real_smul]
  push_cast
  field_simp
  ring_nf

end RCProof
