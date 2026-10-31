import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Tactic
import RCProof.Hybrid

/-! Matrix positivity and compression steps used by the spectral-gap argument.
The input spectral inequality is explicit; constructing it from spectral
functional calculus is outside the scope of these lemmas. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d k : Type*} [Fintype d] [Fintype k]
  [DecidableEq d] [DecidableEq k]

theorem range_projection_idempotent (U : Matrix d k ℂ)
    (hU : Uᴴ * U = 1) :
    (U * Uᴴ) * (U * Uᴴ) = U * Uᴴ := by
  rw [Matrix.mul_assoc, ← Matrix.mul_assoc Uᴴ, hU, Matrix.one_mul]

theorem residual_projection_properties (U : Matrix d k ℂ)
    (hU : Uᴴ * U = 1) :
    (1 - U * Uᴴ)ᴴ = 1 - U * Uᴴ ∧
    (1 - U * Uᴴ) * (1 - U * Uᴴ) = 1 - U * Uᴴ ∧
    (1 - U * Uᴴ).PosSemidef := by
  have hs : (U * Uᴴ) * (U * Uᴴ) = U * Uᴴ :=
    range_projection_idempotent U hU
  have hr : (1 - U * Uᴴ)ᴴ = 1 - U * Uᴴ := by
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_one,
      Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]
  have hi : (1 - U * Uᴴ) * (1 - U * Uᴴ) = 1 - U * Uᴴ := by
    simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.one_mul, Matrix.mul_one, hs]
    abel
  refine ⟨hr, hi, ?_⟩
  have hp := Matrix.posSemidef_conjTranspose_mul_self (1 - U * Uᴴ)
  simpa only [hr, hi] using hp

/-- Compression of an upper spectral envelope to an orthogonal residual.
`PosSemidef (B - A)` expresses the Loewner inequality `A ≤ B`.
Taking `c = 1 - delta` gives the residual spectral-gap inequality. -/
theorem residual_spectral_gap_compression (P E R : Matrix d d ℂ) (c : ℝ)
    (hR : Rᴴ = R) (hRR : R * R = R) (hPR : P * R = 0)
    (hgap : (P + c • (1 - P) - E).PosSemidef) :
    (c • R - R * E * R).PosSemidef := by
  have hp := hgap.conjTranspose_mul_mul_same R
  have hzero : R * P * R = 0 := by
    rw [Matrix.mul_assoc, hPR, Matrix.mul_zero]
  simpa only [hR, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_add,
    Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one,
    hzero, hRR, sub_zero, zero_add] using hp

theorem residual_effect_positive (E R : Matrix d d ℂ)
    (hR : Rᴴ = R) (hE : E.PosSemidef) :
    (R * E * R).PosSemidef := by
  simpa only [hR] using hE.conjTranspose_mul_mul_same R

/-- Assemble the hybrid isometry without separately assuming properties of R.
The overlap factorization is still an explicit hypothesis. -/
theorem hybrid_isometry_from_factorization
    {y : Type*} [Fintype y] [DecidableEq y]
    (U : Matrix d k ℂ) (J : Matrix y k ℂ) (W : Matrix y d ℂ)
    (A : Matrix k k ℂ)
    (hU : Uᴴ * U = 1) (hJ : Jᴴ * J = 1) (hW : Wᴴ * W = 1)
    (hfactor : Jᴴ * W = A * Uᴴ) :
    (J * Uᴴ + W * (1 - U * Uᴴ))ᴴ *
      (J * Uᴴ + W * (1 - U * Uᴴ)) = 1 := by
  obtain ⟨hR, hRR, _⟩ := residual_projection_properties U hU
  have hcomp : U * Uᴴ + (1 - U * Uᴴ) = 1 := by abel
  exact hybrid_isometry U J W (1 - U * Uᴴ) hJ hW hR hRR hcomp
    (hybrid_cross_zero U J W A hU hfactor)

end RCProof
