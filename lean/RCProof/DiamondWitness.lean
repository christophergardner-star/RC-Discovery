import RCProof.PerfectGeometry

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b r : Type*} [Fintype d] [Fintype b] [Fintype r]
  [DecidableEq d] [DecidableEq b] [DecidableEq r]

lemma amplifyRect_tensor_one (Φ : RectMatrixMap d b) (X : Matrix d d ℂ) :
    amplifyRect Φ (X ⊗ₖ (1 : Matrix r r ℂ)) = Φ X ⊗ₖ (1 : Matrix r r ℂ) := by
  ext x y
  by_cases hxy : x.2 = y.2 <;>
    simp [amplifyRect, Matrix.kroneckerMap_apply, Matrix.one_apply, hxy]
  change Φ 0 x.1 y.1 = 0
  rw [map_zero]
  rfl

/-- A concrete density matrix and a contraction test certify a lower bound
on the implemented full diamond supremum. -/
theorem diamondSize_ge_state_test (Φ : RectMatrixMap d b) (ρ : Matrix d d ℂ)
    (hρ : ρ.PosSemidef) (htr : ρ.trace = 1) (K : Matrix b b ℂ) (hK : ‖K‖ ≤ 1) :
    ENNReal.ofReal ‖(Φ ρ * K).trace‖ ≤ diamondSize Φ := by
  let X := ρ ⊗ₖ (1 : Matrix (Fin 1) (Fin 1) ℂ)
  have hX : traceNorm X ≤ 1 := by
    rw [traceNorm_positive X (hρ.kronecker Matrix.PosSemidef.one)]
    simp [X, Matrix.trace_kronecker, htr]
  have hpair := traceNorm_pairing (amplifyRect Φ X) (K ⊗ₖ (1 : Matrix (Fin 1) (Fin 1) ℂ))
  have hn := tensor_norm_bound (r := Fin 1) K 1 zero_le_one hK
  have hbound : ‖(Φ ρ * K).trace‖ ≤ traceNorm (amplifyRect Φ X) := by
    have ht : ((amplifyRect Φ X) * (K ⊗ₖ (1 : Matrix (Fin 1) (Fin 1) ℂ))).trace = (Φ ρ * K).trace := by
      dsimp only [X]
      rw [amplifyRect_tensor_one, ← Matrix.mul_kronecker_mul, Matrix.one_mul, Matrix.trace_kronecker]
      simp
    rw [ht] at hpair
    exact hpair.trans (by nlinarith [traceNorm_nonneg (amplifyRect Φ X)])
  exact (ENNReal.ofReal_le_ofReal hbound).trans
    (le_iSup_of_le 1 (le_iSup_of_le X (le_iSup_of_le hX le_rfl)))

lemma realDiagonal_sign_contraction {o : Type*} [Fintype o] [DecidableEq o]
    (s : o → ℝ) (hs : ∀ i, s i ^ 2 = 1) : ‖realDiagonal s‖ ≤ 1 := by
  apply isometry_norm_le_one
  change (realDiagonal s)ᴴ * realDiagonal s = 1
  simp only [realDiagonal, Matrix.diagonal_conjTranspose, star_trivial,
    Matrix.diagonal_mul_diagonal]
  ext i j
  by_cases hij : i = j
  · subst j
    simpa [Matrix.diagonal_apply_eq, Matrix.one_apply_eq, Function.comp_def,
      ← Complex.ofReal_mul, ← pow_two] using congrArg Complex.ofReal (hs i)
  · simp [Matrix.diagonal_apply, Matrix.one_apply, hij]

end RCProof
