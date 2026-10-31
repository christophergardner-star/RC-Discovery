import Mathlib.Tactic

/-! Formalised real-arithmetic core of C_proj = 1. Zero sorry. -/

namespace RCProof

theorem projector_const_one (c : ℝ) (_hc0 : 0 ≤ c) (_hc1 : c ≤ 1) :
    Real.sqrt (1 - c^2) ≤ Real.sqrt (2 - 2 * c) := by
  apply Real.sqrt_le_sqrt
  nlinarith [sq_nonneg c, sq_nonneg (1 - c)]

theorem polar_residual_le (α σ : ℝ) (_ : 0 ≤ α) (h1 : α ≤ σ) (h2 : σ ≤ 1) :
    |σ - 1| ≤ 1 - α := by
  have : σ - 1 ≤ 0 := by linarith
  rw [abs_of_nonpos this]
  linarith

theorem near_orthonormal_overlap (c ε : ℝ) (hc0 : 0 ≤ c) (_hc1 : c ≤ 1)
    (hε : 0 ≤ ε) (hdist : Real.sqrt (2 - 2 * c) ≤ ε) :
    1 - c ≤ ε^2 / 2 := by
  have h2 : 0 ≤ 2 - 2 * c := by nlinarith
  have hsq : (Real.sqrt (2 - 2 * c))^2 ≤ ε^2 := by
    have habs : |Real.sqrt (2 - 2 * c)| ≤ |ε| := by
      rw [abs_of_nonneg (Real.sqrt_nonneg _), abs_of_nonneg hε]
      exact hdist
    exact (sq_le_sq).mpr habs
  have : 2 - 2 * c ≤ ε^2 := by rwa [Real.sq_sqrt h2] at hsq
  linarith

theorem rank1_core_package (c α σ ε : ℝ)
    (hc0 : 0 ≤ c) (hc1 : c ≤ 1)
    (hα : 0 ≤ α) (hσlo : α ≤ σ) (hσhi : σ ≤ 1)
    (hε : 0 ≤ ε) (hdist : Real.sqrt (2 - 2 * c) ≤ ε) :
    Real.sqrt (1 - c^2) ≤ Real.sqrt (2 - 2 * c) ∧
    |σ - 1| ≤ 1 - α ∧
    1 - c ≤ ε^2 / 2 :=
  ⟨projector_const_one c hc0 hc1,
   polar_residual_le α σ hα hσlo hσhi,
   near_orthonormal_overlap c ε hc0 hc1 hε hdist⟩

end RCProof
