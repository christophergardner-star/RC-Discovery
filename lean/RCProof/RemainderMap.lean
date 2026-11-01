import RCProof.PositiveFamily
import RCProof.SharpResidual

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d k b o r : Type*} [Fintype d] [Fintype k] [Fintype b] [Fintype o] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq b] [DecidableEq o] [DecidableEq r]

lemma amplifyRect_comp (Φ : RectMatrixMap d o) (Ψ : RectMatrixMap k d)
    (X : Matrix (k × r) (k × r) ℂ) : amplifyRect (Φ.comp Ψ) X = amplifyRect Φ (amplifyRect Ψ X) := rfl

lemma amplifyRect_sub_input (Φ : RectMatrixMap d o) (X Y : Matrix (d × r) (d × r) ℂ) :
    amplifyRect Φ (X - Y) = amplifyRect Φ X - amplifyRect Φ Y := by
  ext x y
  exact congrArg (fun A : Matrix o o ℂ => A x.1 y.1)
    (map_sub Φ (fun a b => X (a,x.2) (b,y.2)) (fun a b => Y (a,x.2) (b,y.2)))

lemma effectMap_compressed (A : o → Matrix d d ℂ) (K : Matrix d k ℂ) :
    effectMap (fun j => Kᴴ * A j * K) = (effectMap A).comp (rectKrausMap (fun _ : Unit => K)) := by
  apply LinearMap.ext
  intro X
  change Matrix.diagonal (fun j => (Kᴴ * A j * K * X).trace) =
    Matrix.diagonal (fun j => (A j * (∑ _ : Unit, K * X * Kᴴ)).trace)
  simp only [Fintype.sum_unique]
  congr 1
  funext j
  rw [Matrix.mul_assoc (Kᴴ * A j), Matrix.mul_assoc Kᴴ, Matrix.trace_mul_comm Kᴴ]
  simp only [Matrix.mul_assoc]

lemma amplify_effectMap_compressed (A : o → Matrix d d ℂ) (K : Matrix d k ℂ)
    (X : Matrix (k × r) (k × r) ℂ) :
    amplifyRect (effectMap (fun j => Kᴴ * A j * K)) X =
      amplifyRect (effectMap A) ((K ⊗ₖ (1 : Matrix r r ℂ)) * X * (K ⊗ₖ (1 : Matrix r r ℂ))ᴴ) := by
  rw [effectMap_compressed, amplifyRect_comp, amplifyRect_kraus, Fintype.sum_unique]

theorem remainder_measurement_bound (B : o → Matrix d d ℂ) (hB : ∀ j, (B j).PosSemidef)
    (D R : Matrix d d ℂ) (hD : D.PosSemidef) (hR : R.PosSemidef)
    (hRR : R * R = R) (hDR : D * R = 0)
    (hsum : ∑ j, B j = (R + D) * (R + D))
    (ε : ℝ) (hε : 0 < ε) (hε1 : ε < 1)
    (hgap : (ε • (1 - R) - D * D).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap B - effectMap (fun j => R * B j * R)) X) ≤
      (2 * Real.sqrt ε / Real.sqrt (4 - ε)) * traceNorm X := by
  obtain ⟨V, hV, hfactor⟩ := positive_family_factorization B hB
  have hroot : positiveRoot (∑ j, B j) (Matrix.posSemidef_sum _ (fun j _ => hB j)) = R + D := by
    rw [positiveRoot_eq_cfc]
    exact CFC.sqrt_unique hsum.symm (hR.add hD).nonneg
  rw [hroot] at hfactor
  let N := rectKrausMap (fun p : o × d => readoutKraus p * V)
  have hN (Y : Matrix (d × r) (d × r) ℂ) : traceNorm (amplifyRect N Y) ≤ traceNorm Y := by
    have hg := gram_bound_of_norm V 1 zero_le_one hV
    have hh := rectKraus_amplify_bound (fun p : o × d => readoutKraus p * V) 1 zero_le_one
      (by simpa only [readout_composition_gram, one_pow, one_smul] using hg) Y
    simpa only [one_mul] using hh
  have hf (Y : Matrix (d × r) (d × r) ℂ) : amplifyRect (effectMap B) Y =
      amplifyRect N (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * Y * ((R + D) ⊗ₖ (1 : Matrix r r ℂ))ᴴ) := by
    rw [hfactor, amplifyRect_kraus_composition]
  have hHR : (R + D) * R = R := by rw [Matrix.add_mul, hRR, hDR, add_zero]
  have hten : ((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * (R ⊗ₖ (1 : Matrix r r ℂ)) = R ⊗ₖ (1 : Matrix r r ℂ) := by
    rw [← Matrix.mul_kronecker_mul, hHR, Matrix.one_mul]
  have hsub : amplifyRect (effectMap B - effectMap (fun j => R * B j * R)) X =
      amplifyRect (effectMap B) X - amplifyRect (effectMap (fun j => R * B j * R)) X := rfl
  rw [hsub]
  have hc : (fun j => R * B j * R) = (fun j => Rᴴ * B j * R) := by rw [hR.1.eq]
  rw [hc, amplify_effectMap_compressed, hf X, hf]
  have heq : ((R + D) ⊗ₖ (1 : Matrix r r ℂ)) *
      ((R ⊗ₖ (1 : Matrix r r ℂ)) * X * (R ⊗ₖ (1 : Matrix r r ℂ))ᴴ) *
      ((R + D) ⊗ₖ (1 : Matrix r r ℂ))ᴴ =
      (R ⊗ₖ (1 : Matrix r r ℂ)) * X * (R ⊗ₖ (1 : Matrix r r ℂ))ᴴ := by
    calc
      _ = (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * (R ⊗ₖ (1 : Matrix r r ℂ))) * X *
          (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * (R ⊗ₖ (1 : Matrix r r ℂ)))ᴴ := by
            simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
      _ = _ := by rw [hten]
  rw [heq, ← amplifyRect_sub_input]
  exact (hN _).trans (sharp_residual_trace_bound_ancilla D R hD.1 hR.1 hRR hDR ε hε hε1 hgap X)

end RCProof
