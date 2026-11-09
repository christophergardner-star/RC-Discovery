import RCProof.CoupledChannel

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k o p q r : Type*} [Fintype d] [Fintype k] [Fintype o]
  [Fintype p] [Fintype q] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]
  [DecidableEq p] [DecidableEq q] [DecidableEq r]

theorem scaled_signed_certificate_bound (Φ : RectMatrixMap d o)
    (A B : q → Matrix o d ℂ) (z M : ℝ) (hz : 0 < z) (hM : 0 ≤ M)
    (hgram : (M • (1 : Matrix d d ℂ) -
      ((∑ i, (A i)ᴴ * A i) + ∑ i, (B i)ᴴ * B i)).PosSemidef)
    (hmap : ∀ X, rectKrausMap A X - rectKrausMap B X = z • Φ X)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect Φ X) ≤ (M / z) * traceNorm X := by
  have heq : rectKrausMap A - rectKrausMap B = z • Φ := by
    apply LinearMap.ext
    exact hmap
  have hh := two_kraus_bound_ancilla A B M hM hgram X
  rw [heq] at hh
  have hs : amplifyRect (z • Φ) X = z • amplifyRect Φ X := by
    ext i j
    change (z • Φ (fun a a' => X (a, i.2) (a', j.2))) i.1 j.1 =
      (z • Φ (fun a a' => X (a, i.2) (a', j.2))) i.1 j.1
    rfl
  rw [hs, traceNorm_real_smul, abs_of_pos hz] at hh
  calc
    _ ≤ (M * traceNorm X) / z := (le_div_iff₀ hz).mpr (by nlinarith [hh])
    _ = _ := by ring

theorem coupled_channel_all_inputs
    (N : q → Matrix o d ℂ) (J : p → Matrix o k ℂ)
    (U : Matrix d k ℂ) (C : Matrix k k ℂ) (G R : Matrix d d ℂ)
    (hC : C.IsHermitian) (hG : G.IsHermitian) (hR : R.IsHermitian)
    (hRR : R * R = R) (hGR : G * R = 0) (hRdef : R = 1 - U * Uᴴ)
    (hGG : G * G = U * (1 - C * C) * Uᴴ)
    (hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef)
    (hJ : (∑ i, (J i)ᴴ * J i) = 1)
    (b m : ℝ) (hb : 0 < b) (hb1 : b ≤ 1) (hm : 0 ≤ m)
    (hcircle : b ^ 2 + m ^ 2 = 1)
    (hl : (C - m • (1 : Matrix k k ℂ)).PosSemidef) (hu : (1 - C).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect
      (rectKrausMap (fun i => N i * (R + G)) - rectKrausMap (fun i => N i * R) +
        (rectKrausMap (fun i => J i * (C * Uᴴ)) - rectKrausMap (fun i => J i * Uᴴ))) X) ≤
      perfectEnvelope b * traceNorm X := by
  let Φ := rectKrausMap (fun i => N i * (R + G)) - rectKrausMap (fun i => N i * R) +
        (rectKrausMap (fun i => J i * (C * Uᴴ)) - rectKrausMap (fun i => J i * Uᴴ))
  obtain ⟨A, B, hg, hf⟩ := coupled_channel_certificate N J U C G R hC hG hR hRR hGR hRdef hGG
    hN hJ b m hb hb1 hm hcircle hl hu
  have hz : 0 < 2 * (b⁻¹ - 1 / 2) := by
    have hh : 1 ≤ b⁻¹ := (one_le_inv₀ hb).mpr hb1
    linarith
  have hout (Y : Matrix d d ℂ) : rectKrausMap A Y - rectKrausMap B Y =
      (2 * (b⁻¹ - 1 / 2)) • Φ Y := by
    rw [hf]
    congr 1
    dsimp only [Φ]
    simp only [LinearMap.add_apply, LinearMap.sub_apply, rectangular_kraus_output,
      map_sub, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, Matrix.mul_assoc]
  have hh := scaled_signed_certificate_bound Φ A B _ 2 hz (by norm_num) hg hout X
  have hcst : 2 / (2 * (b⁻¹ - 1 / 2)) = perfectEnvelope b := by
    dsimp [perfectEnvelope]
    field_simp
    <;> ring
  simpa only [hcst] using hh

end RCProof
