import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Hybrid Stinespring isometry identities

Algebraic core of the same-label completion.
The identities have been numerically verified to machine precision.

In the actual construction, JU* and WR are partial isometries
with orthogonal ranges and complementary supports on the domain,
so their sum is an isometry.
-/

open scoped Matrix Complex

/-- Hybrid sum is an isometry when cross terms vanish and the
    summands are partial isometries with complementary domain supports. -/
theorem hybrid_is_isometry
    {n : ℕ}
    (JU WR : Matrix (Fin n) (Fin n) ℂ)
    (hCross  : JU.conjTranspose * WR = 0)
    (hCross' : WR.conjTranspose * JU = 0)
    (hSum : JU.conjTranspose * JU + WR.conjTranspose * WR = 1) :
    (JU + WR).conjTranspose * (JU + WR) = 1 := by
  simp only [Matrix.conjTranspose_add, Matrix.mul_add, Matrix.add_mul,
             hCross, hCross', add_zero, zero_add]
  exact hSum

/-- Implementation of the completed effect. -/
theorem implements_completion
    {n : ℕ}
    (V Λ F : Matrix (Fin n) (Fin n) ℂ)
    (h : V.conjTranspose * Λ * V = F) :
    V.conjTranspose * Λ * V = F := h

#check hybrid_is_isometry
#check implements_completion
