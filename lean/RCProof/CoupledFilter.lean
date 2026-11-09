import RCProof.PositiveFilter

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d : Type*} [Fintype d] [DecidableEq d]

/-- Exact factorization of the combined selected/residual Gram deficit.
Unlike the separate positive-filter estimate this holds on the whole circle. -/
lemma coupled_filter_scalar_identity (b m x : ℝ) (hb : b ≠ 0)
    (hcircle : b ^ 2 + m ^ 2 = 1) :
    2 - (2 * ((b⁻¹ - 1 / 2) ^ 2 + 1 / 4) * (1 - x ^ 2) +
      2 * (b⁻¹ - 1 / 2) * ((x - m) ^ 2 + (1 - m * x) ^ 2) / b ^ 2) =
      4 / b ^ 3 * (x - m) * (m - (1 - b) * x) := by
  have hm2 : m ^ 2 = 1 - b ^ 2 := by linarith
  field_simp
  <;> ring_nf
  <;> simp only [hm2]
  <;> ring

lemma coupled_filter_scalar (b m x : ℝ) (hb : 0 < b) (hb1 : b ≤ 1)
    (hm : 0 ≤ m) (hcircle : b ^ 2 + m ^ 2 = 1) (hx : m ≤ x) (hx1 : x ≤ 1) :
    2 * ((b⁻¹ - 1 / 2) ^ 2 + 1 / 4) * (1 - x ^ 2) +
      2 * (b⁻¹ - 1 / 2) * ((x - m) ^ 2 + (1 - m * x) ^ 2) / b ^ 2 ≤ 2 := by
  have hbm : 1 ≤ b + m := by nlinarith [mul_nonneg hb.le hm]
  have hlast : 0 ≤ m - (1 - b) * x := by
    have hh := mul_le_mul_of_nonneg_left hx1 (show 0 ≤ 1 - b by linarith)
    nlinarith
  have hp : 0 ≤ 4 / b ^ 3 * (x - m) * (m - (1 - b) * x) :=
    mul_nonneg (mul_nonneg (div_nonneg (by norm_num) (by positivity))
      (sub_nonneg.mpr hx)) hlast
  have hid := coupled_filter_scalar_identity b m x hb.ne' hcircle
  linarith

/-- Signed Kraus pair with a coupled Gram bound valid for every 0 < b < 1.
The residual square is exactly I-C^2; no commutator estimate is used. -/
theorem coupled_filter_signed_pair (C : Matrix d d ℂ) (hC : C.IsHermitian)
    (b m : ℝ) (hb : 0 < b) (hb1 : b ≤ 1) (hm : 0 ≤ m)
    (hcircle : b ^ 2 + m ^ 2 = 1)
    (hl : (C - m • (1 : Matrix d d ℂ)).PosSemidef) (hu : (1 - C).PosSemidef) :
    ∃ A B : Matrix d d ℂ,
      ((2 : ℝ) • (1 : Matrix d d ℂ) -
        ((2 * ((b⁻¹ - 1 / 2) ^ 2 + 1 / 4)) • (1 - C * C) +
          (2 * (b⁻¹ - 1 / 2)) • (Aᴴ * A + Bᴴ * B))).PosSemidef ∧
      ∀ X, A * X * Aᴴ - B * X * Bᴴ = C * X * Cᴴ - X := by
  let A := b⁻¹ • (C - m • (1 : Matrix d d ℂ))
  let B := b⁻¹ • ((1 : Matrix d d ℂ) - m • C)
  have hA : Aᴴ = A := by simp [A, Matrix.conjTranspose_sub, hC.eq]
  have hB : Bᴴ = B := by simp [B, Matrix.conjTranspose_sub, hC.eq]
  have heigL (i : d) : m ≤ hC.eigenvalues i := by
    have heq : C - m • (1 : Matrix d d ℂ) =
        inEigenbasis hC.eigenvectorUnitary (fun i => hC.eigenvalues i - m) := by
      rw [inEigenbasis_sub, inEigenbasis_const, ← spectral_representation C hC]
    rw [heq, inEigenbasis_positive_iff] at hl
    linarith [hl i]
  have heigU := eigenvalues_le_of_upper C hC 1 (by simpa using hu)
  have hAr : A = inEigenbasis hC.eigenvectorUnitary (fun i => b⁻¹ * (hC.eigenvalues i - m)) := by
    rw [inEigenbasis_smul, inEigenbasis_sub, inEigenbasis_const, ← spectral_representation C hC]
  have hBr : B = inEigenbasis hC.eigenvectorUnitary (fun i => b⁻¹ * (1 - m * hC.eigenvalues i)) := by
    rw [inEigenbasis_smul, inEigenbasis_sub, inEigenbasis_one, inEigenbasis_smul,
      ← spectral_representation C hC]
  have hres : 1 - C * C = inEigenbasis hC.eigenvectorUnitary (fun i => 1 - hC.eigenvalues i * hC.eigenvalues i) := by
    rw [inEigenbasis_sub, inEigenbasis_one, ← inEigenbasis_mul, ← spectral_representation C hC]
  refine ⟨A, B, ?_, ?_⟩
  · rw [hA, hB, hAr, hBr, hres]
    rw [inEigenbasis_mul, inEigenbasis_mul,
      ← inEigenbasis_add, ← inEigenbasis_smul, ← inEigenbasis_smul,
      ← inEigenbasis_add, ← inEigenbasis_const hC.eigenvectorUnitary,
      ← inEigenbasis_sub]
    apply inEigenbasis_positive
    intro i
    have hh := coupled_filter_scalar b m (hC.eigenvalues i) hb hb1 hm hcircle (heigL i) (heigU i)
    convert sub_nonneg.mpr hh using 1 <;> field_simp <;> ring
  · intro X
    rw [hA, hB, hC.eq]
    have hid : b⁻¹ * b⁻¹ * (1 - m ^ 2) = 1 := by
      rw [show 1 - m ^ 2 = b ^ 2 by linarith]
      field_simp
    calc
      _ = (b⁻¹ * b⁻¹ * (1 - m ^ 2)) • (C * X * C - X) := by
        dsimp only [A, B]
        simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul,
          Matrix.one_mul, Matrix.mul_one, smul_smul]
        module
      _ = _ := by rw [hid, one_smul]

end RCProof
