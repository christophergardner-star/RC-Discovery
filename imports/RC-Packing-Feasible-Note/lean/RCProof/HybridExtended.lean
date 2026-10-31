import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Extended hybrid isometry formalisation

Additional geometric facts stated algebraically.
Builds successfully.
-/

open scoped Matrix Complex

/-- Residual projector is complementary: S R = 0 and R S = 0. -/
theorem residual_orthogonal
    {n : ℕ}
    (S : Matrix (Fin n) (Fin n) ℂ)
    (hS : S * S = S) :
    S * (1 - S) = 0 ∧ (1 - S) * S = 0 := by
  constructor
  · simp [Matrix.mul_sub, hS]
  · simp [Matrix.sub_mul, hS]

/-- Residual is idempotent. -/
theorem residual_idempotent
    {n : ℕ}
    (S : Matrix (Fin n) (Fin n) ℂ)
    (hS : S * S = S) :
    (1 - S) * (1 - S) = 1 - S := by
  simp [Matrix.sub_mul, Matrix.mul_sub, hS, Matrix.mul_one, Matrix.one_mul]

#check residual_orthogonal
#check residual_idempotent
