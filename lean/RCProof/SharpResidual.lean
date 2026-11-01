import RCProof.SignedKraus
import RCProof.Ancilla

/-! Sharp residual-map comparison without a pure-state reduction. -/
namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d r : Type*} [Fintype d] [Fintype r] [DecidableEq d] [DecidableEq r]

theorem residual_trace_bound_balanced (D R : Matrix d d ℂ)
    (hD : D.IsHermitian) (hR : R.IsHermitian) (hRR : R * R = R) (hDR : D * R = 0)
    (ε k : ℝ) (hk : 0 < k) (hbalance : (1 / 4 + k ^ 2) * ε = 1)
    (hgap : (ε • (1 - R) - D * D).PosSemidef) (X : Matrix d d ℂ) :
    traceNorm ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) ≤ k⁻¹ * traceNorm X := by
  have hRD : R * D = 0 := by
    have hh := congrArg Matrix.conjTranspose hDR
    simpa only [Matrix.conjTranspose_mul, hD.eq, hR.eq, Matrix.conjTranspose_zero] using hh
  let A := (1 / 2 + k) • D + R
  let C := (1 / 2 - k) • D + R
  have hgram : Aᴴ * A + Cᴴ * C = (2 * (1 / 4 + k ^ 2)) • (D * D) + (2 : ℝ) • R := by
    dsimp [A, C]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      hD.eq, hR.eq, Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, hDR, hRD, hRR, smul_zero, add_zero, zero_add]
    module
  have hbound : ((2 : ℝ) • (1 : Matrix d d ℂ) - (Aᴴ * A + Cᴴ * C)).PosSemidef := by
    have hp := hgap.smul (show 0 ≤ 2 * (1 / 4 + k ^ 2) by positivity)
    rw [smul_sub, smul_smul, show 2 * (1 / 4 + k ^ 2) * ε = 2 by nlinarith [hbalance], smul_sub] at hp
    rw [hgram]
    convert hp using 1 <;> module
  have hid : (2 * k) • ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) =
      A * X * Aᴴ - C * X * Cᴴ := by
    dsimp [A, C]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    module
  have hn := traceNorm_kraus_pair_bound A C 2 (by norm_num) hbound X
  rw [← hid, traceNorm_real_smul, abs_of_pos (show 0 < 2 * k by positivity)] at hn
  calc
    _ ≤ traceNorm X / k := (le_div_iff₀ hk).mpr (by nlinarith)
    _ = _ := by ring

noncomputable def residualBalance (ε : ℝ) : ℝ := Real.sqrt (4 - ε) / (2 * Real.sqrt ε)

lemma residualBalance_pos (ε : ℝ) (hε : 0 < ε) (hε4 : ε < 4) : 0 < residualBalance ε := by
  unfold residualBalance
  exact div_pos (Real.sqrt_pos.mpr (by linarith)) (by positivity)

lemma residualBalance_identity (ε : ℝ) (hε : 0 < ε) (hε4 : ε < 4) :
    (1 / 4 + residualBalance ε ^ 2) * ε = 1 := by
  have hs := Real.sq_sqrt hε.le
  have ht := Real.sq_sqrt (show 0 ≤ 4 - ε by linarith)
  unfold residualBalance
  rw [div_pow, mul_pow, hs, ht]
  field_simp
  ring

lemma residualBalance_inverse (ε : ℝ) : (residualBalance ε)⁻¹ =
    2 * Real.sqrt ε / Real.sqrt (4 - ε) := by simp [residualBalance, inv_div]

/-- The sharp gentle/residual constant appearing in the joint upper bound,
proved directly on all complex inputs. -/
theorem sharp_residual_trace_bound (D R : Matrix d d ℂ)
    (hD : D.IsHermitian) (hR : R.IsHermitian) (hRR : R * R = R) (hDR : D * R = 0)
    (ε : ℝ) (hε : 0 < ε) (hε1 : ε < 1)
    (hgap : (ε • (1 - R) - D * D).PosSemidef) (X : Matrix d d ℂ) :
    traceNorm ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) ≤
      (2 * Real.sqrt ε / Real.sqrt (4 - ε)) * traceNorm X := by
  have hh := residual_trace_bound_balanced D R hD hR hRR hDR ε (residualBalance ε)
    (residualBalance_pos ε hε (by linarith)) (residualBalance_identity ε hε (by linarith)) hgap X
  simpa only [residualBalance_inverse] using hh

theorem sharp_residual_trace_bound_ancilla (D R : Matrix d d ℂ)
    (hD : D.IsHermitian) (hR : R.IsHermitian) (hRR : R * R = R) (hDR : D * R = 0)
    (ε : ℝ) (hε : 0 < ε) (hε1 : ε < 1)
    (hgap : (ε • (1 - R) - D * D).PosSemidef) (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * X * ((R + D) ⊗ₖ (1 : Matrix r r ℂ))ᴴ -
      (R ⊗ₖ (1 : Matrix r r ℂ)) * X * (R ⊗ₖ (1 : Matrix r r ℂ))ᴴ) ≤
      (2 * Real.sqrt ε / Real.sqrt (4 - ε)) * traceNorm X := by
  rw [Matrix.add_kronecker]
  apply sharp_residual_trace_bound
  · change (D ⊗ₖ (1 : Matrix r r ℂ))ᴴ = D ⊗ₖ (1 : Matrix r r ℂ)
    rw [Matrix.conjTranspose_kronecker, hD.eq, Matrix.conjTranspose_one]
  · change (R ⊗ₖ (1 : Matrix r r ℂ))ᴴ = R ⊗ₖ (1 : Matrix r r ℂ)
    rw [Matrix.conjTranspose_kronecker, hR.eq, Matrix.conjTranspose_one]
  · rw [← Matrix.mul_kronecker_mul, hRR, Matrix.one_mul]
  · rw [← Matrix.mul_kronecker_mul, hDR, Matrix.zero_kronecker]
  · exact hε
  · exact hε1
  · have hp := hgap.kronecker (Matrix.PosSemidef.one : (1 : Matrix r r ℂ).PosSemidef)
    convert hp using 1
    rw [← Matrix.mul_kronecker_mul, Matrix.one_mul]
    ext x y
    simp [Matrix.kroneckerMap_apply, Matrix.sub_apply, Matrix.smul_apply,
      Matrix.one_apply, Complex.real_smul, sub_mul, mul_sub, mul_assoc, Prod.ext_iff, ite_mul, mul_ite]
    split_ifs <;> simp_all

end RCProof
