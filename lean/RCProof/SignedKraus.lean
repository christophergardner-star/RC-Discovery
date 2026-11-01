import RCProof.KrausContraction

/-! Signed Kraus sums controlled by their combined Gram operator, on arbitrary
complex inputs. This preserves the cancellations needed for sharp bounds. -/
namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b q : Type*} [Fintype d] [Fintype b] [Fintype q]
  [DecidableEq d] [DecidableEq b] [DecidableEq q]

lemma traceNorm_real_smul (a : ℝ) (X : Matrix d d ℂ) :
    traceNorm (a • X) = |a| * traceNorm X := by
  have ht (K : Matrix d d ℂ) : ‖((a • X) * K).trace‖ = |a| * ‖(X * K).trace‖ := by
    rw [Matrix.smul_mul, Matrix.trace_smul, norm_smul, Real.norm_eq_abs]
  apply le_antisymm
  · obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction (a • X)
    rw [← hk, ht]
    apply mul_le_mul_of_nonneg_left _ (abs_nonneg a)
    exact (traceNorm_pairing X K).trans (by nlinarith [traceNorm_nonneg X])
  · obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction X
    rw [← hk, ← ht]
    exact (traceNorm_pairing (a • X) K).trans (by nlinarith [traceNorm_nonneg (a • X)])

lemma signed_tensor_contraction (s : q → ℝ) (hs : ∀ i, s i ^ 2 = 1)
    (K : Matrix b b ℂ) (hK : ‖K‖ ≤ 1) : ‖realDiagonal s ⊗ₖ K‖ ≤ 1 := by
  have hD : (realDiagonal s)ᴴ * realDiagonal s = 1 := by
    simp only [realDiagonal, Matrix.diagonal_conjTranspose, star_trivial,
      Matrix.diagonal_mul_diagonal]
    ext i j
    by_cases hij : i = j
    · subst j
      simpa [Matrix.diagonal_apply_eq, Matrix.one_apply_eq, Function.comp_def,
        ← Complex.ofReal_mul, ← pow_two] using congrArg Complex.ofReal (hs i)
    · simp [Matrix.diagonal_apply, Matrix.one_apply, hij]
  apply norm_le_of_gram _ 1 zero_le_one
  have hp := (Matrix.PosSemidef.one : (1 : Matrix q q ℂ).PosSemidef).kronecker
    (gram_bound_of_norm K 1 zero_le_one hK)
  simp only [one_pow, one_smul] at hp ⊢
  convert hp using 1
  simp only [Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul, hD]
  ext x y
  simp [Matrix.kroneckerMap_apply, Matrix.one_apply, Matrix.sub_apply, mul_sub,
    Prod.ext_iff, ite_mul]
  split_ifs <;> simp_all

lemma signed_tensor_mul_stack (s : q → ℝ) (K : Matrix b b ℂ) (A : q → Matrix b d ℂ) :
    (realDiagonal s ⊗ₖ K) * stack A = stack (fun i => s i • (K * A i)) := by
  ext x j
  simp [Matrix.mul_apply, stack, realDiagonal, Matrix.kroneckerMap_apply,
    Matrix.diagonal_apply, Fintype.sum_prod_type, ite_mul, Matrix.smul_apply,
    Complex.real_smul, mul_assoc, Finset.mul_sum]

theorem signed_kraus_dual_bound (A : q → Matrix b d ℂ) (s : q → ℝ)
    (hs : ∀ i, s i ^ 2 = 1) (B : ℝ) (hB : 0 ≤ B)
    (hA : (B • (1 : Matrix d d ℂ) - ∑ i, (A i)ᴴ * A i).PosSemidef)
    (K : Matrix b b ℂ) (hK : ‖K‖ ≤ 1) :
    ‖∑ i, s i • ((A i)ᴴ * K * A i)‖ ≤ B := by
  have hn : ‖stack A‖ * ‖stack A‖ ≤ B := by
    rw [← Matrix.l2_opNorm_conjTranspose_mul_self]
    apply positive_norm_le _ (Matrix.posSemidef_conjTranspose_mul_self _) B hB
    rwa [stack_gram]
  have hnK := signed_tensor_contraction s hs K hK
  have heq : (stack A)ᴴ * (realDiagonal s ⊗ₖ K) * stack A =
      ∑ i, s i • ((A i)ᴴ * K * A i) := by
    rw [Matrix.mul_assoc, signed_tensor_mul_stack, stack_cross]
    simp only [Matrix.mul_smul, Matrix.mul_assoc]
  rw [← heq]
  calc
    _ ≤ (‖(stack A)ᴴ‖ * ‖realDiagonal s ⊗ₖ K‖) * ‖stack A‖ :=
      (Matrix.l2_opNorm_mul _ _).trans (mul_le_mul_of_nonneg_right
        (Matrix.l2_opNorm_mul _ _) (norm_nonneg _))
    _ ≤ ‖stack A‖ * ‖stack A‖ := by
      rw [Matrix.l2_opNorm_conjTranspose]
      nlinarith [mul_le_mul_of_nonneg_left hnK (mul_self_nonneg ‖stack A‖)]
    _ ≤ B := hn

theorem traceNorm_signed_kraus_bound (A : q → Matrix b d ℂ) (s : q → ℝ)
    (hs : ∀ i, s i ^ 2 = 1) (B : ℝ) (hB : 0 ≤ B)
    (hA : (B • (1 : Matrix d d ℂ) - ∑ i, (A i)ᴴ * A i).PosSemidef)
    (X : Matrix d d ℂ) :
    traceNorm (∑ i, s i • (A i * X * (A i)ᴴ)) ≤ B * traceNorm X := by
  obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction (∑ i, s i • (A i * X * (A i)ᴴ))
  have ht : ((∑ i, s i • (A i * X * (A i)ᴴ)) * K).trace =
      (X * (∑ i, s i • ((A i)ᴴ * K * A i))).trace := by
    simp only [Matrix.sum_mul, Matrix.mul_sum, Matrix.trace_sum, Matrix.smul_mul,
      Matrix.mul_smul, Matrix.trace_smul]
    apply Finset.sum_congr rfl
    intro i _
    congr 1
    rw [Matrix.mul_assoc (A i * X), Matrix.mul_assoc (A i) X, Matrix.trace_mul_comm (A i)]
    simp only [Matrix.mul_assoc]
  rw [← hk, ht]
  exact (traceNorm_pairing X _).trans (by
    have hh := signed_kraus_dual_bound A s hs B hB hA K hK
    nlinarith [traceNorm_nonneg X])

theorem traceNorm_kraus_pair_bound (A C : Matrix b d ℂ) (B : ℝ) (hB : 0 ≤ B)
    (hAC : (B • (1 : Matrix d d ℂ) - (Aᴴ * A + Cᴴ * C)).PosSemidef)
    (X : Matrix d d ℂ) : traceNorm (A * X * Aᴴ - C * X * Cᴴ) ≤ B * traceNorm X := by
  have h := traceNorm_signed_kraus_bound (fun i : Bool => if i then C else A)
    (fun i : Bool => if i then -1 else 1) (by intro i; cases i <;> norm_num)
    B hB (by simpa [Fintype.sum_bool, add_comm] using hAC) X
  simpa [Fintype.sum_bool, sub_eq_add_neg, add_comm] using h

end RCProof
