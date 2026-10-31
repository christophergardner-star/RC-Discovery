import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.Tactic

/-! Finite-dimensional operator algebra for the hybrid dilation.
The spectral calculus and quantitative norm estimates are not assumed proved here.
All hypotheses below are explicit; no additional axioms or sorry are used. -/
namespace RCProof
open Matrix
variable {d k y : Type*} [Fintype d] [Fintype k] [Fintype y]
  [DecidableEq d] [DecidableEq k] [DecidableEq y]

theorem spectral_cross_zero (P A R : Matrix d d ℂ)
    (hcomm : P * A = A * P) (hzero : P * R = 0) :
    P * A * R = 0 := by
  rw [hcomm, Matrix.mul_assoc, hzero, Matrix.mul_zero]

theorem hybrid_isometry
    (U : Matrix d k ℂ) (J : Matrix y k ℂ) (W : Matrix y d ℂ)
    (R : Matrix d d ℂ)
    (hJ : Jᴴ * J = 1) (hW : Wᴴ * W = 1)
    (hR : Rᴴ = R) (hRR : R * R = R)
    (hcomp : U * Uᴴ + R = 1)
    (hcross : Jᴴ * W * R = 0) :
    (J * Uᴴ + W * R)ᴴ * (J * Uᴴ + W * R) = 1 := by
  have hc : R * Wᴴ * J = 0 := by
    have hh := congrArg Matrix.conjTranspose hcross
    simpa [Matrix.conjTranspose_mul, hR, Matrix.mul_assoc] using hh
  simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, hR, Matrix.add_mul, Matrix.mul_add]
  have a : U * Jᴴ * (J * Uᴴ) = U * Uᴴ := by
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc Jᴴ, hJ, Matrix.one_mul]
  have b : U * Jᴴ * (W * R) = 0 := by
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc Jᴴ, hcross, Matrix.mul_zero]
  have c : R * Wᴴ * (J * Uᴴ) = 0 := by
    rw [← Matrix.mul_assoc, hc, Matrix.zero_mul]
  have e : R * Wᴴ * (W * R) = R := by
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc Wᴴ, hW, Matrix.one_mul, hRR]
  rw [a, b, c, e, add_zero, zero_add]
  exact hcomp

theorem hybrid_cross_zero
    (U : Matrix d k ℂ) (J : Matrix y k ℂ) (W : Matrix y d ℂ)
    (A : Matrix k k ℂ)
    (hU : Uᴴ * U = 1) (hfactor : Jᴴ * W = A * Uᴴ) :
    Jᴴ * W * (1 - U * Uᴴ) = 0 := by
  have hz : Uᴴ * (1 - U * Uᴴ) = 0 := by
    rw [Matrix.mul_sub, Matrix.mul_one, ← Matrix.mul_assoc,
      hU, Matrix.one_mul, sub_self]
  rw [hfactor, Matrix.mul_assoc, hz, Matrix.mul_zero]

theorem hybrid_compression
    (U : Matrix d k ℂ) (J : Matrix y k ℂ) (W : Matrix y d ℂ)
    (R : Matrix d d ℂ) (L : Matrix y y ℂ)
    (C : Matrix k k ℂ) (E : Matrix d d ℂ)
    (hR : Rᴴ = R) (hL : Lᴴ = L)
    (hC : Jᴴ * L * J = C) (hE : Wᴴ * L * W = E)
    (hcross : Jᴴ * L * W * R = 0) :
    (J * Uᴴ + W * R)ᴴ * L * (J * Uᴴ + W * R) =
      U * C * Uᴴ + R * E * R := by
  have hc : R * Wᴴ * L * J = 0 := by
    have hh := congrArg Matrix.conjTranspose hcross
    simpa [Matrix.conjTranspose_mul, hR, hL, Matrix.mul_assoc] using hh
  simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, hR, Matrix.add_mul, Matrix.mul_add]
  have a : U * Jᴴ * L * (J * Uᴴ) = U * C * Uᴴ := by
    simpa only [Matrix.mul_assoc] using
      congrArg (fun X => U * X * Uᴴ) hC
  have b : U * Jᴴ * L * (W * R) = 0 := by
    simpa only [Matrix.mul_assoc, Matrix.mul_zero] using congrArg (U * ·) hcross
  have c : R * Wᴴ * L * (J * Uᴴ) = 0 := by
    rw [← Matrix.mul_assoc, hc, Matrix.zero_mul]
  have e : R * Wᴴ * L * (W * R) = R * E * R := by
    simpa only [Matrix.mul_assoc] using
      congrArg (fun X => R * X * R) hE
  rw [a, b, c, e, add_zero, zero_add]
end RCProof
