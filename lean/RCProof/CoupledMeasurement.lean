import RCProof.CoupledBound
import RCProof.UniformRemainder

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k o p q r : Type*} [Fintype d] [Fintype k] [Fintype o]
  [Fintype p] [Fintype q] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]
  [DecidableEq p] [DecidableEq q] [DecidableEq r]

lemma effectMap_compressed_kraus (A : o → Matrix k k ℂ) (J : p → Matrix o k ℂ)
    (hJ : effectMap A = rectKrausMap J) (Z : Matrix k d ℂ) :
    effectMap (fun j => Zᴴ * A j * Z) = rectKrausMap (fun i => J i * Z) := by
  rw [effectMap_compressed, hJ]
  apply LinearMap.ext
  intro X
  rw [rectangular_kraus_output]
  simp [LinearMap.comp_apply, rectKrausMap]

/-- Measurement form of the coupled certificate. The residual CP map is
constructed from its positive effects, even when their sum is singular. -/
theorem coupled_measurement_all_inputs
    (B : o → Matrix d d ℂ) (A : o → Matrix k k ℂ)
    (hB : ∀ j, (B j).PosSemidef) (hA : ∀ j, (A j).PosSemidef)
    (hsumA : ∑ j, A j = 1)
    (U : Matrix d k ℂ) (C : Matrix k k ℂ) (G R : Matrix d d ℂ)
    (hC : C.IsHermitian) (hG : G.PosSemidef) (hR : R.PosSemidef)
    (hRR : R * R = R) (hGR : G * R = 0) (hRdef : R = 1 - U * Uᴴ)
    (hGG : G * G = U * (1 - C * C) * Uᴴ)
    (hsumB : ∑ j, B j = (R + G) * (R + G))
    (b m : ℝ) (hb : 0 < b) (hb1 : b ≤ 1) (hm : 0 ≤ m)
    (hcircle : b ^ 2 + m ^ 2 = 1)
    (hl : (C - m • (1 : Matrix k k ℂ)).PosSemidef) (hu : (1 - C).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect
      (effectMap B - effectMap (fun j => R * B j * R) +
        (effectMap (fun j => U * C * A j * C * Uᴴ) - effectMap (fun j => U * A j * Uᴴ))) X) ≤
      perfectEnvelope b * traceNorm X := by
  obtain ⟨V, hV, hfactor⟩ := positive_family_factorization B hB
  have hroot : positiveRoot (∑ j, B j) (Matrix.posSemidef_sum _ (fun j _ => hB j)) = R + G := by
    rw [positiveRoot_eq_cfc]
    exact CFC.sqrt_unique hsumB.symm (hR.add hG).nonneg
  rw [hroot] at hfactor
  let N := fun p : o × d => readoutKraus p * V
  let J := fun p : o × k => readoutKraus p * stack (fun j => positiveRoot (A j) (hA j))
  have hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef := by
    have hh := gram_bound_of_norm V 1 zero_le_one hV
    simpa only [N, readout_composition_gram, one_pow, one_smul] using hh
  have hJ : (∑ i, (J i)ᴴ * J i) = 1 := by
    dsimp only [J]
    rw [readout_composition_gram, stack_gram]
    simpa only [positiveRoot_gram] using hsumA
  have hJA : effectMap A = rectKrausMap J := positive_effectMap_kraus A hA
  have hBR : effectMap (fun j => R * B j * R) = rectKrausMap (fun i => N i * R) := by
    have hh := effectMap_compressed_kraus B _ hfactor R
    have hHR : (R + G) * R = R := by rw [Matrix.add_mul, hRR, hGR, add_zero]
    simpa only [hR.1.eq, Matrix.mul_assoc, hHR, N] using hh
  have hsel : effectMap (fun j => U * C * A j * C * Uᴴ) =
      rectKrausMap (fun i => J i * (C * Uᴴ)) := by
    have hh := effectMap_compressed_kraus A J hJA (C * Uᴴ)
    simpa only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      hC.eq, Matrix.mul_assoc] using hh
  have hQ : effectMap (fun j => U * A j * Uᴴ) = rectKrausMap (fun i => J i * Uᴴ) := by
    simpa only [Matrix.conjTranspose_conjTranspose] using effectMap_compressed_kraus A J hJA Uᴴ
  rw [hfactor, hBR, hsel, hQ]
  exact coupled_channel_all_inputs N J U C G R hC hG.1 hR.1 hRR hGR hRdef hGG hN hJ
    b m hb hb1 hm hcircle hl hu X

end RCProof
