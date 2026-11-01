import RCProof.MeasurementCertificate

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d : Type*} [Fintype d] [DecidableEq d]

lemma positive_filter_scalar (m x : ℝ) (hm : 1 / 2 ≤ m) (hm1 : m < 1)
    (hx : m ≤ x) (hx1 : x ≤ 1) :
    (1 - m) / (2 * (1 + m)) * (x + 1) ^ 2 +
      (1 + m) / (2 * (1 - m)) * (x - 1) ^ 2 ≤ 1 - m ^ 2 := by
  have hid : 1 - m ^ 2 - ((1 - m) / (2 * (1 + m)) * (x + 1) ^ 2 +
      (1 + m) / (2 * (1 - m)) * (x - 1) ^ 2) =
      (1 + m ^ 2) / (1 - m ^ 2) * (x - m) * (1 - x) +
        ((1 + m) ^ 2 - 2) / (1 + m) * (x - m) := by
    field_simp [show 1 - m ^ 2 ≠ 0 by nlinarith,
      show (1 : ℝ) + m ≠ 0 by linarith, show (1 : ℝ) - m ≠ 0 by linarith]
    <;> ring
  have hp1 : 0 ≤ (1 + m ^ 2) / (1 - m ^ 2) * (x - m) * (1 - x) := by
    apply mul_nonneg
    · exact mul_nonneg (div_nonneg (by positivity) (by nlinarith)) (by linarith)
    · linarith
  have hp2 : 0 ≤ ((1 + m) ^ 2 - 2) / (1 + m) * (x - m) := by
    exact mul_nonneg (div_nonneg (by nlinarith) (by linarith)) (by linarith)
  linarith

/-- A signed Kraus representation of a positive filter minus the identity,
with the sharp loss Gram bound used by the joint second-order argument. -/
theorem positive_filter_signed_pair (C : Matrix d d ℂ) (hC : C.IsHermitian)
    (m : ℝ) (hm : 1 / 2 ≤ m) (hm1 : m < 1)
    (hl : (C - m • (1 : Matrix d d ℂ)).PosSemidef) (hu : (1 - C).PosSemidef) :
    ∃ A B : Matrix d d ℂ,
      ((1 - m ^ 2) • (1 : Matrix d d ℂ) - (Aᴴ * A + Bᴴ * B)).PosSemidef ∧
      ∀ X, A * X * Aᴴ - B * X * Bᴴ = C * X * Cᴴ - X := by
  let t := Real.sqrt ((1 - m) / (4 * (1 + m)))
  let u := 1 / (4 * t)
  have ht : 0 < t := Real.sqrt_pos.mpr (div_pos (by linarith) (by linarith))
  have ht2 : t ^ 2 = (1 - m) / (4 * (1 + m)) := Real.sq_sqrt (by positivity)
  have hu2 : u ^ 2 = (1 + m) / (4 * (1 - m)) := by
    dsimp only [u]
    rw [div_pow, mul_pow, ht2]
    field_simp
    <;> ring
  have htu : 4 * t * u = 1 := by dsimp only [u]; field_simp
  let A := t • (C + 1) + u • (C - 1)
  let B := t • (C + 1) - u • (C - 1)
  have hA : Aᴴ = A := by
    dsimp [A]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
      Matrix.conjTranspose_one, star_trivial, hC.eq]
  have hB : Bᴴ = B := by
    dsimp [B]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
      Matrix.conjTranspose_one, star_trivial, hC.eq]
  have heigL (i : d) : m ≤ hC.eigenvalues i := by
    have heq : C - m • (1 : Matrix d d ℂ) =
        inEigenbasis hC.eigenvectorUnitary (fun i => hC.eigenvalues i - m) := by
      rw [inEigenbasis_sub, inEigenbasis_const, ← spectral_representation C hC]
    rw [heq, inEigenbasis_positive_iff] at hl
    linarith [hl i]
  have heigU := eigenvalues_le_of_upper C hC 1 (by simpa using hu)
  have hAr : A = inEigenbasis hC.eigenvectorUnitary
      (fun i => t * (hC.eigenvalues i + 1) + u * (hC.eigenvalues i - 1)) := by
    rw [inEigenbasis_add, inEigenbasis_smul, inEigenbasis_smul, inEigenbasis_add, inEigenbasis_sub,
      inEigenbasis_one, ← spectral_representation C hC]
  have hBr : B = inEigenbasis hC.eigenvectorUnitary
      (fun i => t * (hC.eigenvalues i + 1) - u * (hC.eigenvalues i - 1)) := by
    rw [inEigenbasis_sub, inEigenbasis_smul, inEigenbasis_smul, inEigenbasis_add, inEigenbasis_sub,
      inEigenbasis_one, ← spectral_representation C hC]
  refine ⟨A, B, ?_, ?_⟩
  · rw [hA, hB, hAr, hBr, inEigenbasis_mul, inEigenbasis_mul, ← inEigenbasis_add,
      ← inEigenbasis_const hC.eigenvectorUnitary, ← inEigenbasis_sub]
    apply inEigenbasis_positive
    intro i
    have hs := positive_filter_scalar m (hC.eigenvalues i) hm hm1 (heigL i) (heigU i)
    have ht' : 2 * t ^ 2 = (1 - m) / (2 * (1 + m)) := by rw [ht2]; field_simp; ring
    have hu' : 2 * u ^ 2 = (1 + m) / (2 * (1 - m)) := by rw [hu2]; field_simp; ring
    nlinarith only [hs, congrArg (fun y : ℝ => y * (hC.eigenvalues i + 1) ^ 2) ht',
      congrArg (fun y : ℝ => y * (hC.eigenvalues i - 1) ^ 2) hu']
  · intro X
    rw [hA, hB, hC.eq]
    calc
      _ = (4 * t * u) • (C * X * C - X) := by
        dsimp only [A, B]
        simp only [Matrix.add_mul, Matrix.sub_mul, Matrix.mul_add, Matrix.mul_sub,
          Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, Matrix.mul_one, smul_smul]
        module
      _ = _ := by rw [htu, one_smul]

end RCProof
