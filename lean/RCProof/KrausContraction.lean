import RCProof.TraceInequalities

/-! Trace-norm contraction for normalized rectangular Kraus families on all
complex inputs. No Hermitian-input restriction is used. -/
namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b q : Type*} [Fintype d] [Fintype b] [Fintype q]
  [DecidableEq d] [DecidableEq b] [DecidableEq q]

lemma one_tensor_contraction (K : Matrix b b ℂ) (hK : ‖K‖ ≤ 1) :
    ‖(1 : Matrix q q ℂ) ⊗ₖ K‖ ≤ 1 := by
  apply norm_le_of_gram _ 1 zero_le_one
  have hp := (Matrix.PosSemidef.one : (1 : Matrix q q ℂ).PosSemidef).kronecker
    (gram_bound_of_norm K 1 zero_le_one hK)
  simp only [one_pow, one_smul] at hp ⊢
  convert hp using 1
  simp only [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
    ← Matrix.mul_kronecker_mul, Matrix.one_mul]
  simp [sub_eq_add_neg, Matrix.kronecker_add, ← neg_smul, Matrix.kronecker_smul]
  ext x y
  simp [Matrix.kroneckerMap_apply]

lemma tensor_mul_stack (K : Matrix b b ℂ) (A : q → Matrix b d ℂ) :
    ((1 : Matrix q q ℂ) ⊗ₖ K) * stack A = stack (fun i => K * A i) := by
  ext x j
  simp [Matrix.mul_apply, stack, Matrix.kronecker, Matrix.kroneckerMap_apply,
    Matrix.one_apply, Fintype.sum_prod_type, ite_mul]

lemma kraus_dual_contraction (A : q → Matrix b d ℂ) (hA : ∑ i, (A i)ᴴ * A i = 1)
    (K : Matrix b b ℂ) (hK : ‖K‖ ≤ 1) : ‖∑ i, (A i)ᴴ * K * A i‖ ≤ 1 := by
  have hS : (stack A)ᴴ * stack A = 1 := by rw [stack_gram, hA]
  have hnS := isometry_norm_le_one (stack A) hS
  have hnK := one_tensor_contraction (q := q) K hK
  have heq : (stack A)ᴴ * ((1 : Matrix q q ℂ) ⊗ₖ K) * stack A =
      ∑ i, (A i)ᴴ * K * A i := by
    rw [Matrix.mul_assoc, tensor_mul_stack, stack_cross]
    simp only [Matrix.mul_assoc]
  rw [← heq]
  calc
    _ ≤ (‖(stack A)ᴴ‖ * ‖(1 : Matrix q q ℂ) ⊗ₖ K‖) * ‖stack A‖ :=
      (Matrix.l2_opNorm_mul _ _).trans (mul_le_mul_of_nonneg_right
        (Matrix.l2_opNorm_mul _ _) (norm_nonneg _))
    _ ≤ 1 := by
      rw [Matrix.l2_opNorm_conjTranspose]
      calc
        ‖stack A‖ * ‖(1 : Matrix q q ℂ) ⊗ₖ K‖ * ‖stack A‖ ≤ (1 * 1) * 1 := by gcongr
        _ = 1 := by norm_num

theorem traceNorm_kraus_contraction (A : q → Matrix b d ℂ)
    (hA : ∑ i, (A i)ᴴ * A i = 1) (X : Matrix d d ℂ) :
    traceNorm (∑ i, A i * X * (A i)ᴴ) ≤ traceNorm X := by
  obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction (∑ i, A i * X * (A i)ᴴ)
  have ht : ((∑ i, A i * X * (A i)ᴴ) * K).trace =
      (X * (∑ i, (A i)ᴴ * K * A i)).trace := by
    rw [Matrix.sum_mul, Matrix.trace_sum, Matrix.mul_sum, Matrix.trace_sum]
    apply Finset.sum_congr rfl
    intro i _
    rw [Matrix.mul_assoc (A i * X), Matrix.mul_assoc (A i) X, Matrix.trace_mul_comm (A i)]
    simp only [Matrix.mul_assoc]
  rw [← hk, ht]
  exact (traceNorm_pairing X _).trans (by
    have hh := kraus_dual_contraction A hA K hK
    nlinarith [traceNorm_nonneg X])

end RCProof
