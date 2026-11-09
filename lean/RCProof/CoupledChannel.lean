import RCProof.UniformThreshold

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k o p q r : Type*} [Fintype d] [Fintype k] [Fintype o]
  [Fintype p] [Fintype q] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]
  [DecidableEq p] [DecidableEq q] [DecidableEq r]

lemma rectangular_kraus_gram (J : p → Matrix o k ℂ) (Z : Matrix k d ℂ) :
    (∑ i, (J i * Z)ᴴ * (J i * Z)) = Zᴴ * (∑ i, (J i)ᴴ * J i) * Z := by
  simp only [Matrix.conjTranspose_mul, Matrix.mul_sum, Matrix.sum_mul, Matrix.mul_assoc]

lemma rectangular_kraus_output (J : p → Matrix o k ℂ) (Z : Matrix k d ℂ) (X : Matrix d d ℂ) :
    rectKrausMap (fun i => J i * Z) X = rectKrausMap J (Z * X * Zᴴ) := by
  simp only [rectKrausMap, LinearMap.coe_mk, AddHom.coe_mk, Matrix.conjTranspose_mul, Matrix.mul_assoc]

lemma real_scaled_kraus_output (J : p → Matrix o d ℂ) (t : ℝ) (X : Matrix d d ℂ) :
    rectKrausMap (fun i => t • J i) X = (t ^ 2) • rectKrausMap J X := by
  simp only [rectKrausMap, LinearMap.coe_mk, AddHom.coe_mk, Matrix.conjTranspose_smul,
    star_trivial, Matrix.mul_smul, Matrix.smul_mul, smul_smul, ← pow_two, Finset.smul_sum]

lemma real_scaled_kraus_gram (J : p → Matrix o d ℂ) (t : ℝ) :
    (∑ i, (t • J i)ᴴ * (t • J i)) = (t ^ 2) • ∑ i, (J i)ᴴ * J i := by
  simp only [Matrix.conjTranspose_smul, star_trivial, Matrix.mul_smul,
    Matrix.smul_mul, smul_smul, ← pow_two, Finset.smul_sum]

/-- A signed Kraus certificate for the full selected-plus-residual map.
Every norm conclusion is derived from operator data, not assumed. -/
theorem coupled_channel_certificate
    (N : q → Matrix o d ℂ) (J : p → Matrix o k ℂ)
    (U : Matrix d k ℂ) (C : Matrix k k ℂ) (G R : Matrix d d ℂ)
    (hC : C.IsHermitian) (hG : G.IsHermitian) (hR : R.IsHermitian)
    (hRR : R * R = R) (hGR : G * R = 0) (hRdef : R = 1 - U * Uᴴ)
    (hGG : G * G = U * (1 - C * C) * Uᴴ)
    (hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef)
    (hJ : (∑ i, (J i)ᴴ * J i) = 1)
    (b m : ℝ) (hb : 0 < b) (hb1 : b ≤ 1) (hm : 0 ≤ m)
    (hcircle : b ^ 2 + m ^ 2 = 1)
    (hl : (C - m • (1 : Matrix k k ℂ)).PosSemidef) (hu : (1 - C).PosSemidef) :
    ∃ A B : q ⊕ p → Matrix o d ℂ,
      ((2 : ℝ) • (1 : Matrix d d ℂ) -
        ((∑ i, (A i)ᴴ * A i) + ∑ i, (B i)ᴴ * B i)).PosSemidef ∧
      ∀ X, rectKrausMap A X - rectKrausMap B X =
        (2 * (b⁻¹ - 1 / 2)) •
          (rectKrausMap N ((R + G) * X * (R + G)ᴴ - R * X * Rᴴ) +
            rectKrausMap J (C * (Uᴴ * X * U) * Cᴴ - Uᴴ * X * U)) := by
  let z := b⁻¹ - 1 / 2
  have hz : 0 < z := by
    have hh : 1 ≤ b⁻¹ := (one_le_inv₀ hb).mpr hb1
    dsimp [z]; linarith
  obtain ⟨A, B, hbase, hpair⟩ := coupled_filter_signed_pair C hC b m hb hb1 hm hcircle hl hu
  let L := (1 / 2 + z) • G + R
  let M := (1 / 2 - z) • G + R
  let t := Real.sqrt (2 * z)
  have ht : t ^ 2 = 2 * z := Real.sq_sqrt (by positivity)
  have hRG : R * G = 0 := by
    have hh := congrArg Matrix.conjTranspose hGR
    simpa only [Matrix.conjTranspose_mul, hG.eq, hR.eq, Matrix.conjTranspose_zero] using hh
  have hLM : Lᴴ * L + Mᴴ * M =
      (2 * (z ^ 2 + 1 / 4)) • (G * G) + (2 : ℝ) • R := by
    dsimp [L, M]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      hG.eq, hR.eq, Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, hGR, hRG, hRR, smul_zero, add_zero, zero_add]
    module
  let Aall : q ⊕ p → Matrix o d ℂ := Sum.elim (fun i => N i * L) (fun i => t • (J i * (A * Uᴴ)))
  let Ball : q ⊕ p → Matrix o d ℂ := Sum.elim (fun i => N i * M) (fun i => t • (J i * (B * Uᴴ)))
  have hgram : ((2 : ℝ) • (1 : Matrix d d ℂ) -
      ((∑ i, (Aall i)ᴴ * Aall i) + ∑ i, (Ball i)ᴴ * Ball i)).PosSemidef := by
    have hp := ((hbase.mul_mul_conjTranspose_same U).add
      (hN.conjTranspose_mul_mul_same L)).add (hN.conjTranspose_mul_mul_same M)
    have hbasic : (2 : ℝ) • (1 : Matrix d d ℂ) -
        (Lᴴ * L + Mᴴ * M + (2 * z) • (U * (Aᴴ * A + Bᴴ * B) * Uᴴ)) =
        U * ((2 : ℝ) • 1 - ((2 * (z ^ 2 + 1 / 4)) • (1 - C * C) +
          (2 * z) • (Aᴴ * A + Bᴴ * B))) * Uᴴ := by
      rw [hLM, hGG, hRdef]
      simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_add, Matrix.add_mul,
        Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one, Matrix.one_mul, smul_sub]
      module
    dsimp only [Aall, Ball]
    simp only [Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
    simp only [real_scaled_kraus_gram, ht]
    simp only [rectangular_kraus_gram, hJ, Matrix.mul_one]
    simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]
    convert hp using 1
    rw [← hbasic]
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, Matrix.mul_add,
      Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_assoc, smul_add]
    abel
  refine ⟨Aall, Ball, hgram, ?_⟩
  intro X
  have hLMout : L * X * Lᴴ - M * X * Mᴴ =
      (2 * z) • ((R + G) * X * (R + G)ᴴ - R * X * Rᴴ) := by
    dsimp [L, M]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    module
  have hsel (Z : Matrix k k ℂ) :
      (A * Uᴴ) * X * (A * Uᴴ)ᴴ - (B * Uᴴ) * X * (B * Uᴴ)ᴴ =
        C * (Uᴴ * X * U) * Cᴴ - Uᴴ * X * U := by
    simpa only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      Matrix.mul_assoc] using hpair (Uᴴ * X * U)
  have hsum (V : q → Matrix o d ℂ) (W : p → Matrix o d ℂ) :
      rectKrausMap (Sum.elim V W) X = rectKrausMap V X + rectKrausMap W X := by
    simp [rectKrausMap, Fintype.sum_sum_type]
  dsimp only [Aall, Ball]
  rw [hsum, hsum, real_scaled_kraus_output, real_scaled_kraus_output, ht,
    rectangular_kraus_output, rectangular_kraus_output,
    rectangular_kraus_output, rectangular_kraus_output]
  calc
    _ = rectKrausMap N (L * X * Lᴴ - M * X * Mᴴ) +
        (2 * z) • rectKrausMap J ((A * Uᴴ) * X * (A * Uᴴ)ᴴ - (B * Uᴴ) * X * (B * Uᴴ)ᴴ) := by
      rw [map_sub, map_sub, smul_sub]; abel
    _ = _ := by
      rw [hLMout, hsel C]
      change (∑ i, N i * ((2 * z) • _) * (N i)ᴴ) + _ = _
      simp only [Matrix.mul_smul, Matrix.smul_mul, ← Finset.smul_sum, smul_add]
      rfl

end RCProof
