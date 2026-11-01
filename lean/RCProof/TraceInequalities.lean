import RCProof.TraceDuality

namespace RCProof
open Matrix Unitary
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

lemma matrix_entry_le_opNorm (K : Matrix d k ℂ) (i : d) (j : k) : ‖K i j‖ ≤ ‖K‖ := by
  have hp := gram_bound_of_norm K ‖K‖ (norm_nonneg _) le_rfl
  have hd := (Complex.nonneg_iff.mp (hp.diag_nonneg (i := j))).1
  have hdiag : (Kᴴ * K) j j = ((∑ x, ‖K x j‖ ^ 2 : ℝ) : ℂ) := by
    simp only [Matrix.mul_apply, Matrix.conjTranspose_apply, ← starRingEnd_apply, RCLike.conj_mul]
    norm_cast
  simp only [Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply_eq,
    Complex.real_smul, mul_one, Complex.sub_re, Complex.ofReal_re, hdiag] at hd
  have hs : ‖K i j‖ ^ 2 ≤ ∑ x, ‖K x j‖ ^ 2 :=
    Finset.single_le_sum (fun x _ => sq_nonneg ‖K x j‖) (Finset.mem_univ i)
  nlinarith [norm_nonneg K, norm_nonneg (K i j)]

lemma isometry_norm_le_one (A : Matrix d k ℂ) (hA : Aᴴ * A = 1) : ‖A‖ ≤ 1 := by
  apply norm_le_of_gram _ 1 zero_le_one
  simp only [one_pow, one_smul, hA, sub_self, Matrix.PosSemidef.zero]

lemma positive_trace_pairing (H K : Matrix d d ℂ) (hH : H.PosSemidef) :
    ‖(H * K).trace‖ ≤ H.trace.re * ‖K‖ := by
  let B := hH.1.eigenvectorUnitary
  let L := (B : Matrix d d ℂ)ᴴ * K * (B : Matrix d d ℂ)
  have hB : ‖(B : Matrix d d ℂ)‖ ≤ 1 := isometry_norm_le_one _ (Unitary.coe_star_mul_self B)
  have hL : ‖L‖ ≤ ‖K‖ := by
    calc
      _ ≤ (‖(B : Matrix d d ℂ)ᴴ‖ * ‖K‖) * ‖(B : Matrix d d ℂ)‖ :=
        (Matrix.l2_opNorm_mul _ _).trans (mul_le_mul_of_nonneg_right
          (Matrix.l2_opNorm_mul _ _) (norm_nonneg _))
      _ ≤ ‖K‖ := by
        rw [Matrix.l2_opNorm_conjTranspose]
        calc
          _ ≤ (1 * ‖K‖) * 1 := mul_le_mul (mul_le_mul_of_nonneg_right hB (norm_nonneg _))
            hB (norm_nonneg _) (by positivity)
          _ = _ := by ring
  have ht : (H * K).trace = ∑ i, (hH.1.eigenvalues i : ℂ) * L i i := by
    conv_lhs => rw [spectral_representation H hH.1]
    simp only [inEigenbasis, Unitary.conjStarAlgAut_apply, Matrix.star_eq_conjTranspose,
      Function.comp_def]
    rw [Matrix.mul_assoc, Matrix.mul_assoc,
      Matrix.trace_mul_comm (hH.1.eigenvectorUnitary : Matrix d d ℂ)]
    simp only [Matrix.trace, Matrix.diag, realDiagonal, Matrix.diagonal_mul, L, B,
      Matrix.mul_assoc]
  have htr : H.trace.re = ∑ i, hH.1.eigenvalues i := by
    conv_lhs => rw [spectral_representation H hH.1]
    exact trace_inEigenbasis _ _
  rw [ht, htr, Finset.sum_mul]
  apply (norm_sum_le _ _).trans
  apply Finset.sum_le_sum
  intro i _
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (hH.eigenvalues_nonneg i)]
  exact mul_le_mul_of_nonneg_left ((matrix_entry_le_opNorm L i i).trans hL) (hH.eigenvalues_nonneg i)

theorem traceNorm_pairing (X K : Matrix d d ℂ) :
    ‖(X * K).trace‖ ≤ traceNorm X * ‖K‖ := by
  obtain ⟨W, hW, hX, _⟩ := exists_contraction_polar X
  let H := positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X)
  have hH : H.PosSemidef := positiveRoot_positive _ _
  have ht : H.trace.re = traceNorm X := by dsimp only [H]; rw [positiveRoot_eq_cfc]; rfl
  calc
    _ = ‖(H * (K * W)).trace‖ := by
      conv_lhs => rw [hX, Matrix.mul_assoc, Matrix.trace_mul_comm W]
      simp only [Matrix.mul_assoc]
      rfl
    _ ≤ H.trace.re * ‖K * W‖ := positive_trace_pairing _ _ hH
    _ ≤ H.trace.re * ‖K‖ := by
      apply mul_le_mul_of_nonneg_left _ (Complex.nonneg_iff.mp hH.trace_nonneg).1
      exact (Matrix.l2_opNorm_mul K W).trans (by nlinarith [norm_nonneg K])
    _ = _ := by rw [ht]

theorem traceNorm_attaining_contraction (X : Matrix d d ℂ) :
    ∃ K : Matrix d d ℂ, ‖K‖ ≤ 1 ∧ ‖(X * K).trace‖ = traceNorm X := by
  obtain ⟨W, hW, hX, hWH⟩ := exists_contraction_polar X
  refine ⟨Wᴴ, by rwa [Matrix.l2_opNorm_conjTranspose], ?_⟩
  let H := positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X)
  have hH : H.PosSemidef := positiveRoot_positive _ _
  have ht : (X * Wᴴ).trace = H.trace := by
    conv_lhs => rw [hX, Matrix.trace_mul_cycle, hWH]
  rw [ht]
  have hr := congrArg Complex.re (Complex.eq_coe_norm_of_nonneg hH.trace_nonneg)
  have hh : ‖H.trace‖ = H.trace.re := by simpa using hr.symm
  rw [hh]
  dsimp only [H]
  rw [positiveRoot_eq_cfc]
  rfl

theorem traceNorm_add (X Y : Matrix d d ℂ) : traceNorm (X + Y) ≤ traceNorm X + traceNorm Y := by
  obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction (X + Y)
  rw [← hk, Matrix.add_mul, Matrix.trace_add]
  calc
    _ ≤ ‖(X * K).trace‖ + ‖(Y * K).trace‖ := norm_add_le _ _
    _ ≤ traceNorm X * ‖K‖ + traceNorm Y * ‖K‖ := add_le_add (traceNorm_pairing X K) (traceNorm_pairing Y K)
    _ ≤ _ := by nlinarith [traceNorm_nonneg X, traceNorm_nonneg Y]

theorem traceNorm_mul_sandwich (A B : Matrix d k ℂ) (X : Matrix k k ℂ) :
    traceNorm (A * X * Bᴴ) ≤ ‖A‖ * traceNorm X * ‖B‖ := by
  obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction (A * X * Bᴴ)
  have ht : (A * X * Bᴴ * K).trace = (X * (Bᴴ * K * A)).trace := by
    rw [Matrix.mul_assoc (A * X), Matrix.mul_assoc A X, Matrix.trace_mul_comm A]
    simp only [Matrix.mul_assoc]
  rw [← hk, ht]
  calc
    _ ≤ traceNorm X * ‖Bᴴ * K * A‖ := traceNorm_pairing X _
    _ ≤ traceNorm X * ((‖B‖ * ‖K‖) * ‖A‖) := by
      apply mul_le_mul_of_nonneg_left _ (traceNorm_nonneg X)
      have h := (Matrix.l2_opNorm_mul (Bᴴ * K) A).trans (mul_le_mul_of_nonneg_right
        (Matrix.l2_opNorm_mul Bᴴ K) (norm_nonneg A))
      simpa only [Matrix.l2_opNorm_conjTranspose] using h
    _ ≤ _ := by
      have hp : 0 ≤ traceNorm X * ‖B‖ * ‖A‖ :=
        mul_nonneg (mul_nonneg (traceNorm_nonneg X) (norm_nonneg B)) (norm_nonneg A)
      nlinarith [mul_le_mul_of_nonneg_left hK hp]

end RCProof
