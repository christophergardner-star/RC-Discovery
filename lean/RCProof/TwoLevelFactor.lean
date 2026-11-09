import RCProof.FrameRecognition

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d : Type*} [Fintype d] [DecidableEq d]

noncomputable def twoLevelFactor (O P : Matrix d d ℂ) (a g : ℝ) : Matrix d d ℂ :=
  a • P + g • (O - P) + (1 - O)

lemma hermitian_projection_positive (P : Matrix d d ℂ) (hP : P.IsHermitian) (hPP : P * P = P) :
    P.PosSemidef := by
  have hh := Matrix.posSemidef_conjTranspose_mul_self P
  simpa only [hP.eq, hPP] using hh

lemma projection_difference_positive (O P : Matrix d d ℂ)
    (hO : O.IsHermitian) (hP : P.IsHermitian)
    (hOO : O * O = O) (hPP : P * P = P) (hOP : O * P = P) : (O - P).PosSemidef := by
  have hPO : P * O = P := by
    have hh := congrArg Matrix.conjTranspose hOP
    simpa only [Matrix.conjTranspose_mul, hO.eq, hP.eq] using hh
  apply hermitian_projection_positive _ (hO.sub hP)
  noncomm_ring [hOO, hPP, hOP, hPO]

lemma twoLevelFactor_product (O P : Matrix d d ℂ)
    (hOO : O * O = O) (hPP : P * P = P) (hOP : O * P = P) (hPO : P * O = P)
    (a g a' g' : ℝ) :
    twoLevelFactor O P a g * twoLevelFactor O P a' g' = twoLevelFactor O P (a*a') (g*g') := by
  dsimp only [twoLevelFactor]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.sub_mul, Matrix.mul_sub,
    Matrix.smul_mul, Matrix.mul_smul, smul_smul, Matrix.one_mul, Matrix.mul_one,
    hOO, hPP, hOP, hPO, sub_self, smul_zero, mul_zero, zero_mul, add_zero,
    zero_add, sub_zero, smul_sub]
  module

lemma twoLevelFactor_hermitian (O P : Matrix d d ℂ) (hO : O.IsHermitian) (hP : P.IsHermitian)
    (a g : ℝ) : (twoLevelFactor O P a g).IsHermitian := by
  change _ᴴ = _
  simp [twoLevelFactor, hP.eq, hO.eq]

lemma twoLevelFactor_positive (O P : Matrix d d ℂ)
    (hO : O.PosSemidef) (hP : P.PosSemidef)
    (hOO : O * O = O) (hPP : P * P = P) (hOP : O * P = P)
    (a g : ℝ) (ha : 0 ≤ a) (hg : 0 ≤ g) : (twoLevelFactor O P a g).PosSemidef :=
  ((hP.smul ha).add ((projection_difference_positive O P hO.1 hP.1 hOO hPP hOP).smul hg)).add
    (projection_complement_positive O hO.1 hOO)

lemma twoLevelFactor_inverse (O P : Matrix d d ℂ)
    (hOO : O * O = O) (hPP : P * P = P) (hOP : O * P = P) (hPO : P * O = P)
    (a g : ℝ) (ha : a ≠ 0) (hg : g ≠ 0) :
    twoLevelFactor O P a g * twoLevelFactor O P a⁻¹ g⁻¹ = 1 := by
  rw [twoLevelFactor_product O P hOO hPP hOP hPO, mul_inv_cancel₀ ha, mul_inv_cancel₀ hg]
  dsimp only [twoLevelFactor]
  simp only [one_smul]
  abel

lemma twoLevelFactor_square_lower (O P : Matrix d d ℂ)
    (hO : O.PosSemidef) (hP : P.PosSemidef)
    (hOO : O * O = O) (hPP : P * P = P) (hOP : O * P = P) (hPO : P * O = P)
    (a g : ℝ) (ha : a ^ 2 ≤ 1) (hg : a ^ 2 ≤ g ^ 2) :
    (twoLevelFactor O P a g * twoLevelFactor O P a g - a ^ 2 • (1 : Matrix d d ℂ)).PosSemidef := by
  rw [twoLevelFactor_product O P hOO hPP hOP hPO]
  have hh := ((projection_difference_positive O P hO.1 hP.1 hOO hPP hOP).smul (sub_nonneg.mpr hg)).add
    ((projection_complement_positive O hO.1 hOO).smul (sub_nonneg.mpr ha))
  convert hh using 1
  dsimp only [twoLevelFactor]
  module

lemma twoLevelFactor_on_projection (O P : Matrix d d ℂ)
    (hPP : P * P = P) (hOP : O * P = P) (a g : ℝ) :
    twoLevelFactor O P a g * P = a • P := by
  simp only [twoLevelFactor, Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul,
    Matrix.one_mul, hPP, hOP, sub_self, smul_zero, add_zero]

end RCProof
