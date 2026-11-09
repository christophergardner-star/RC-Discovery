import RCProof.JointFamilyCanonical

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

lemma coordinateAxis_compression (U : Matrix d k ℂ) (j : d) :
    Uᴴ * coordinateAxis j * U = vecMulVec (star (U j)) (U j) := by
  ext i l
  simp [coordinateAxis, realDiagonal, Matrix.mul_diagonal, Matrix.mul_apply,
    Matrix.conjTranspose_apply, vecMulVec, apply_ite]
    <;> simp [Matrix.diagonal_apply]

lemma isometry_compression (U : Matrix d k ℂ) (hU : Uᴴ*U=1) (A : Matrix k k ℂ) :
    Uᴴ * (U*A*Uᴴ) * U = A := by
  calc
    _ = (Uᴴ*U)*A*(Uᴴ*U) := by simp only [Matrix.mul_assoc]
    _ = _ := by rw [hU, Matrix.one_mul, Matrix.mul_one]

lemma trace_isometry_conjugation (U : Matrix d k ℂ) (hU : Uᴴ*U=1) (A : Matrix k k ℂ) :
    (U*A*Uᴴ).trace=A.trace := by
  rw [Matrix.trace_mul_comm, ← Matrix.mul_assoc, hU, Matrix.one_mul]

lemma trace_conjugated_input (U : Matrix d k ℂ) (A : Matrix d d ℂ) (X : Matrix k k ℂ) :
    (A*(U*X*Uᴴ)).trace=((Uᴴ*A*U)*X).trace := by
  rw [← Matrix.mul_assoc, Matrix.trace_mul_comm]
  simp only [Matrix.mul_assoc]

lemma intertwined_compression (U : Matrix d k ℂ) (A : Matrix d d ℂ) (B : Matrix k k ℂ)
    (hA : A.IsHermitian) (hB : B.IsHermitian) (hAU : A*U=U*B) (X : Matrix d d ℂ) :
    Uᴴ*(A*X*A)*U=B*(Uᴴ*X*U)*B := by
  have hUA : Uᴴ*A=B*Uᴴ := by
    have hh := congrArg Matrix.conjTranspose hAU
    simpa only [Matrix.conjTranspose_mul, hA.eq, hB.eq] using hh
  calc
    _ = (Uᴴ*A)*X*(A*U) := by simp only [Matrix.mul_assoc]
    _ = _ := by rw [hUA, hAU]; simp only [Matrix.mul_assoc]

namespace JointFamilyData
variable (p : JointFamilyData)

noncomputable def coreFactor : Matrix (Fin 2) (Fin 2) ℂ := realDiagonal ![p.a, 1]

lemma coreFactor_hermitian : p.coreFactor.IsHermitian := by
  apply (realDiagonal_positive _ _).1
  intro i
  fin_cases i <;> simp [p.a_pos.le]

lemma mean_core_action : p.mean * jointCore p.n p.w = jointCore p.n p.w * coordinateAxis (0 : Fin 2) := by
  dsimp only [mean, jointMean]
  rw [Matrix.mul_assoc, jointCore_isometry p.n p.w p.mean_unit, Matrix.mul_one]

lemma factor_core_action : p.factor * jointCore p.n p.w = jointCore p.n p.w * p.coreFactor := by
  have hc : p.coreFactor=p.a • coordinateAxis (0 : Fin 2)+(1-coordinateAxis (0 : Fin 2)) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [coreFactor, coordinateAxis, realDiagonal, Matrix.diagonal_apply, Matrix.one_apply, Complex.real_smul]
  rw [hc]
  dsimp only [factor, jointFactor, twoLevelFactor]
  change (p.a • p.mean+p.g • (jointOld p.n-p.mean)+(1-jointOld p.n))*jointCore p.n p.w=_
  simp only [Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul, Matrix.one_mul,
    p.mean_core_action, jointOld_core, sub_self, smul_zero, add_zero, Matrix.mul_add,
    Matrix.mul_sub, Matrix.mul_smul, Matrix.mul_one]

lemma residual_core_action : jointResidual p.n * jointCore p.n p.w =
    jointCore p.n p.w * coordinateAxis (1 : Fin 2) := by
  rw [← jointCore_residual p.n p.w, Matrix.mul_assoc,
    jointCore_isometry p.n p.w p.mean_unit, Matrix.mul_one]

lemma old_axis_core (i : Fin p.n) :
    (jointCore p.n p.w)ᴴ * jointAxis (Sum.inl i) * jointCore p.n p.w =
      p.w^2 • coordinateAxis (0 : Fin 2) := by
  rw [jointAxis, coordinateAxis_compression]
  ext j k
  fin_cases j <;> fin_cases k <;>
    simp [jointLabelIndex, jointCore, coordinateAxis, realDiagonal,
      vecMulVec, Matrix.diagonal_apply, Complex.real_smul, pow_two]

lemma clean_axis_core (i : Fin 4) :
    (jointCore p.n p.w)ᴴ * jointAxis (Sum.inr i : JointLabels p.n) * jointCore p.n p.w = 0 := by
  rw [jointCore_clean_axis, Matrix.zero_mul]

lemma perp_core : (jointCore p.n p.w)ᴴ*p.perp*jointCore p.n p.w=0 := by
  dsimp only [perp]
  rw [Matrix.mul_sub, Matrix.sub_mul]
  have hO : (jointCore p.n p.w)ᴴ*jointOld p.n*jointCore p.n p.w=coordinateAxis (0 : Fin 2) := by
    rw [Matrix.mul_assoc, jointOld_core, ← Matrix.mul_assoc, jointCore_isometry p.n p.w p.mean_unit,
      Matrix.one_mul]
  rw [hO]
  have hP : (jointCore p.n p.w)ᴴ*p.mean*jointCore p.n p.w=coordinateAxis (0 : Fin 2) :=
    isometry_compression _ (jointCore_isometry p.n p.w p.mean_unit) _
  rw [hP, sub_self]

lemma low_core (i : Fin 4) :
    (jointCore p.n p.w)ᴴ*p.low i*jointCore p.n p.w=
      (1/2 : ℝ) • (if i.val<2 then jointPlusCore p.b p.h else jointMinusCore p.b p.h) := by
  dsimp only [low]
  simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul, p.perp_core,
    smul_zero, add_zero]
  split_ifs <;> congr 1 <;> exact isometry_compression _ (jointCore_isometry p.n p.w p.mean_unit) _

end JointFamilyData
end RCProof
