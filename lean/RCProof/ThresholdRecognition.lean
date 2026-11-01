import RCProof.PerfectMeasurement

namespace RCProof
set_option autoImplicit false
open Matrix Unitary
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d : Type*} [Fintype d] [DecidableEq d]

lemma positive_column_zero_of_diag_zero (A : Matrix d d ℂ) (hA : A.PosSemidef)
    (j : d) (hj : A j j = 0) : ∀ i, A i j = 0 := by
  have hh : A *ᵥ Pi.single j 1 = 0 := hA.dotProduct_mulVec_zero_iff.mp (by
    simpa using hj)
  intro i
  simpa using congrFun hh i

lemma projection_complement_positive (P : Matrix d d ℂ) (hP : P.IsHermitian) (hPP : P * P = P) :
    (1 - P).PosSemidef := by
  have hh := Matrix.posSemidef_conjTranspose_mul_self (1 - P)
  have heq : (1 - P)ᴴ * (1 - P) = 1 - P := by
    rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hP.eq]
    noncomm_ring [hPP]
  rwa [heq] at hh

/-- Recognize the *full* closed-threshold sector from an isolated selected
eigenvalue and a strict upper bound on its orthogonal complement. -/
theorem thresholdProjector_eq_of_isolated_projection (E P : Matrix d d ℂ)
    (hE : E.IsHermitian) (hP : P.PosSemidef) (hPP : P * P = P)
    (ell t c : ℝ) (ht : t < c) (hc : c ≤ ell)
    (hEP : E * P = ell • P) (hu : (ell • P + t • (1 - P) - E).PosSemidef) :
    thresholdProjector E hE c = P := by
  let f := Unitary.conjStarAlgAut ℝ _ (star hE.eigenvectorUnitary)
  let Q := f P
  have hfE : f E = realDiagonal hE.eigenvalues := hE.conjStarAlgAut_star_eigenvectorUnitary
  have hQ : Q.PosSemidef := hP.mul_mul_conjTranspose_same
    (star hE.eigenvectorUnitary : Matrix d d ℂ)
  have hQc : (1 - Q).PosSemidef := by
    have hh := (projection_complement_positive P hP.1 hPP).mul_mul_conjTranspose_same
      (star hE.eigenvectorUnitary : Matrix d d ℂ)
    change (f (1 - P)).PosSemidef at hh
    simpa only [map_sub, map_one] using hh
  have hEQ : realDiagonal hE.eigenvalues * Q = ell • Q := by
    rw [← hfE]
    change f E * f P = ell • f P
    rw [← map_mul, hEP, map_smul]
  have huQ : (ell • Q + t • (1 - Q) - realDiagonal hE.eigenvalues).PosSemidef := by
    have hh := hu.mul_mul_conjTranspose_same (star hE.eigenvectorUnitary : Matrix d d ℂ)
    change (f (ell • P + t • (1 - P) - E)).PosSemidef at hh
    simpa only [map_sub, map_add, map_smul, map_one, hfE] using hh
  have hdiag (i : d) : Q i i = (if c ≤ hE.eigenvalues i then 1 else 0) := by
    have hq0 := (Complex.nonneg_iff.mp (hQ.diag_nonneg (i := i))).1
    have hqim := (Complex.nonneg_iff.mp (hQ.diag_nonneg (i := i))).2
    have hq1 := (Complex.nonneg_iff.mp (hQc.diag_nonneg (i := i))).1
    have hu' := (Complex.nonneg_iff.mp (huQ.diag_nonneg (i := i))).1
    have heq := congrArg (fun M : Matrix d d ℂ => (M i i).re) hEQ
    simp only [realDiagonal, Matrix.diagonal_mul, Matrix.smul_apply, Complex.real_smul,
      Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero] at heq
    simp only [Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply_eq,
      realDiagonal, Matrix.diagonal_apply_eq, Complex.real_smul, Complex.sub_re, Complex.add_re,
      Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero, Complex.one_re] at hq1 hu'
    by_cases hi : c ≤ hE.eigenvalues i
    · rw [if_pos hi]
      have hne : (Q i i).re ≠ 0 := by intro hz; rw [hz] at hu'; nlinarith
      have heig : hE.eigenvalues i = ell := by
        have hz : (hE.eigenvalues i - ell) * (Q i i).re = 0 := by nlinarith only [heq]
        exact sub_eq_zero.mp ((mul_eq_zero.mp hz).resolve_right hne)
      apply Complex.ext
      · simp only [Complex.one_re]
        rw [heig] at hu'
        nlinarith
      · simpa using hqim.symm
    · rw [if_neg hi]
      have hne : hE.eigenvalues i - ell ≠ 0 := by linarith
      have hz : (hE.eigenvalues i - ell) * (Q i i).re = 0 := by nlinarith only [heq]
      apply Complex.ext
      · simpa using (mul_eq_zero.mp hz).resolve_left hne
      · simpa using hqim.symm
  have hQeq : Q = realDiagonal (fun i => if c ≤ hE.eigenvalues i then 1 else 0) := by
    ext i j
    by_cases hj : c ≤ hE.eigenvalues j
    · have hz : (1 - Q) j j = 0 := by simp [Matrix.sub_apply, hdiag, hj]
      have hh := positive_column_zero_of_diag_zero (1 - Q) hQc j hz i
      simp only [Matrix.sub_apply] at hh
      have hh' := sub_eq_zero.mp hh
      rw [← hh']
      by_cases hij : i = j
      · subst i; simp [realDiagonal, hj]
      · simp [realDiagonal, Matrix.diagonal_apply, Matrix.one_apply, hij]
    · have hz : Q j j = 0 := by simp [hdiag, hj]
      rw [positive_column_zero_of_diag_zero Q hQ j hz i]
      by_cases hij : i = j
      · subst i; simp [realDiagonal, hj]
      · simp [realDiagonal, Matrix.diagonal_apply, hij]
  apply f.injective
  change f (inEigenbasis hE.eigenvectorUnitary (fun i => if c ≤ hE.eigenvalues i then 1 else 0)) = Q
  rw [hQeq]
  simp only [f, inEigenbasis, Unitary.conjStarAlgAut_apply, Matrix.star_eq_conjTranspose]
  simp only [Unitary.coe_star, Matrix.star_eq_conjTranspose, Matrix.conjTranspose_conjTranspose]
  have hU : (hE.eigenvectorUnitary : Matrix d d ℂ)ᴴ * hE.eigenvectorUnitary = 1 :=
    Unitary.coe_star_mul_self _
  simp only [← Matrix.mul_assoc, hU, Matrix.one_mul]
  simp only [Matrix.mul_assoc, hU, Matrix.mul_one]

end RCProof
