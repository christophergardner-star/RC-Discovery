import RCProof.RemainderMap
import RCProof.EnvelopeAnalysis

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b q p r : Type*} [Fintype d] [Fintype b] [Fintype q] [Fintype p] [Fintype r]
  [DecidableEq d] [DecidableEq b] [DecidableEq q] [DecidableEq p] [DecidableEq r]

lemma kraus_composition_gram (N : q → Matrix b d ℂ) (A : Matrix d d ℂ) :
    (∑ i, (N i * A)ᴴ * (N i * A)) = Aᴴ * (∑ i, (N i)ᴴ * N i) * A := by
  simp only [Matrix.conjTranspose_mul, Matrix.mul_sum, Matrix.sum_mul, Matrix.mul_assoc]

lemma kraus_composition_output (N : q → Matrix b d ℂ) (A X : Matrix d d ℂ) :
    (∑ i, (N i * A) * X * (N i * A)ᴴ) = rectKrausMap N (A * X * Aᴴ) := by
  change _ = ∑ i, N i * (A * X * Aᴴ) * (N i)ᴴ
  simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]

theorem traceNorm_three_kraus_bound (A C : q → Matrix b d ℂ) (K : p → Matrix b d ℂ)
    (B : ℝ) (hB : 0 ≤ B)
    (hgram : (B • (1 : Matrix d d ℂ) -
      ((∑ i, (A i)ᴴ * A i) + (∑ i, (C i)ᴴ * C i) + ∑ j, (K j)ᴴ * K j)).PosSemidef)
    (X : Matrix d d ℂ) :
    traceNorm (rectKrausMap A X - rectKrausMap C X - rectKrausMap K X) ≤ B * traceNorm X := by
  let L : q ⊕ (q ⊕ p) → Matrix b d ℂ := Sum.elim A (Sum.elim C K)
  let s : q ⊕ (q ⊕ p) → ℝ := Sum.elim (fun _ => 1) (fun _ => -1)
  have hh := traceNorm_signed_kraus_bound L s (by intro i; rcases i with i | i <;> simp [s])
    B hB (by simpa [L, Fintype.sum_sum_type, add_assoc] using hgram) X
  simpa [L, s, Fintype.sum_sum_type, rectKrausMap, sub_eq_add_neg, add_assoc, add_comm, add_left_comm] using hh

/-- Balanced signed Kraus proof including the selected defect. The intermediate
map is allowed to decrease trace, and inputs may be arbitrary complex matrices. -/
theorem perfect_residual_balanced (N : q → Matrix b d ℂ) (K : p → Matrix b d ℂ)
    (D R : Matrix d d ℂ) (hD : D.IsHermitian) (hR : R.IsHermitian)
    (hRR : R * R = R) (hDR : D * R = 0)
    (hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef)
    (hK : (∑ j, (K j)ᴴ * K j) = D * D)
    (δ k : ℝ) (hk : 0 < k) (hbalance : (k + 1 / 2) ^ 2 * δ = 1)
    (hgap : (δ • (1 - R) - D * D).PosSemidef) (X : Matrix d d ℂ) :
    traceNorm (rectKrausMap N ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) -
      rectKrausMap K X) ≤ k⁻¹ * traceNorm X := by
  have hRD : R * D = 0 := by
    have hh := congrArg Matrix.conjTranspose hDR
    simpa only [Matrix.conjTranspose_mul, hD.eq, hR.eq, Matrix.conjTranspose_zero] using hh
  let A := (1 / 2 + k) • D + R
  let C := (1 / 2 - k) • D + R
  let t := Real.sqrt (2 * k)
  have ht : t ^ 2 = 2 * k := Real.sq_sqrt (by positivity)
  have hgram : Aᴴ * A + Cᴴ * C + (2 * k) • (D * D) =
      (2 * (k + 1 / 2) ^ 2) • (D * D) + (2 : ℝ) • R := by
    dsimp [A, C]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      hD.eq, hR.eq, Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, hDR, hRD, hRR, smul_zero, add_zero, zero_add]
    module
  have hbase : ((2 : ℝ) • (1 : Matrix d d ℂ) -
      (Aᴴ * A + Cᴴ * C + (2 * k) • (D * D))).PosSemidef := by
    have hp := hgap.smul (show 0 ≤ 2 * (k + 1 / 2) ^ 2 by positivity)
    rw [smul_sub, smul_smul,
      show 2 * (k + 1 / 2) ^ 2 * δ = 2 by nlinarith [hbalance], smul_sub] at hp
    rw [hgram]
    convert hp using 1 <;> module
  have hscaled : (∑ j, (t • K j)ᴴ * (t • K j)) = (2 * k) • (D * D) := by
    simp only [Matrix.conjTranspose_smul, star_trivial, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, ← pow_two, ht, ← Finset.smul_sum, hK]
  have hbound : ((2 : ℝ) • (1 : Matrix d d ℂ) -
      ((∑ i, (N i * A)ᴴ * (N i * A)) + (∑ i, (N i * C)ᴴ * (N i * C)) +
      ∑ j, (t • K j)ᴴ * (t • K j))).PosSemidef := by
    have hp := (hbase.add (hN.conjTranspose_mul_mul_same A)).add (hN.conjTranspose_mul_mul_same C)
    rw [kraus_composition_gram, kraus_composition_gram, hscaled]
    convert hp using 1
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one]
    abel
  have hid : (2 * k) • ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) =
      A * X * Aᴴ - C * X * Cᴴ := by
    dsimp [A, C]
    simp only [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, star_trivial,
      Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    module
  have hout : rectKrausMap (fun i => N i * A) X - rectKrausMap (fun i => N i * C) X -
      rectKrausMap (fun j => t • K j) X =
      (2 * k) • (rectKrausMap N ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) - rectKrausMap K X) := by
    change (∑ i, (N i * A) * X * (N i * A)ᴴ) - (∑ i, (N i * C) * X * (N i * C)ᴴ) - _ = _
    rw [kraus_composition_output, kraus_composition_output, ← map_sub, ← hid]
    change (∑ i, N i * ((2 * k) • _) * (N i)ᴴ) -
      (∑ j, (t • K j) * X * (t • K j)ᴴ) = (2 * k) • ((∑ i, N i * _ * (N i)ᴴ) - ∑ j, K j * X * (K j)ᴴ)
    simp only [Matrix.conjTranspose_smul, star_trivial, Matrix.smul_mul, Matrix.mul_smul,
      smul_smul, ← pow_two, ht, ← Finset.smul_sum, smul_sub,
      Matrix.mul_sub, Matrix.sub_mul, Finset.sum_sub_distrib]
  have hn := traceNorm_three_kraus_bound (fun i => N i * A) (fun i => N i * C)
    (fun j => t • K j) 2 (by norm_num) hbound X
  rw [hout, traceNorm_real_smul, abs_of_pos (show 0 < 2 * k by positivity)] at hn
  calc
    _ ≤ traceNorm X / k := (le_div_iff₀ hk).mpr (by nlinarith)
    _ = _ := by ring

theorem perfect_residual_bound (N : q → Matrix b d ℂ) (K : p → Matrix b d ℂ)
    (D R : Matrix d d ℂ) (hD : D.IsHermitian) (hR : R.IsHermitian)
    (hRR : R * R = R) (hDR : D * R = 0)
    (hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef)
    (hK : (∑ j, (K j)ᴴ * K j) = D * D)
    (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    (hgap : (δ • (1 - R) - D * D).PosSemidef) (X : Matrix d d ℂ) :
    traceNorm (rectKrausMap N ((R + D) * X * (R + D)ᴴ - R * X * Rᴴ) -
      rectKrausMap K X) ≤ perfectEnvelope (Real.sqrt δ) * traceNorm X := by
  let k := (Real.sqrt δ)⁻¹ - 1 / 2
  have hs : 0 < Real.sqrt δ := Real.sqrt_pos.mpr hδ
  have hs1 : Real.sqrt δ < 1 := by nlinarith [Real.sq_sqrt hδ.le]
  have hk : 0 < k := by
    have hi : 1 < (Real.sqrt δ)⁻¹ := (one_lt_inv₀ hs).mpr hs1
    dsimp [k]
    linarith
  have hbalance : (k + 1 / 2) ^ 2 * δ = 1 := by
    dsimp [k]
    rw [sub_add_cancel, inv_pow, Real.sq_sqrt hδ.le, inv_mul_cancel₀ hδ.ne']
  have hinv : k⁻¹ = perfectEnvelope (Real.sqrt δ) := by
    dsimp [k, perfectEnvelope]
    field_simp
    <;> ring
  simpa only [hinv] using perfect_residual_balanced N K D R hD hR hRR hDR hN hK δ k hk hbalance hgap X

end RCProof
