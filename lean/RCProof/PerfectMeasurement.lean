import RCProof.PerfectResidual
import RCProof.CanonicalRemainder
import RCProof.CanonicalAngles

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b q p r o : Type*} [Fintype d] [Fintype b] [Fintype q] [Fintype p] [Fintype r] [Fintype o]
  [DecidableEq d] [DecidableEq b] [DecidableEq q] [DecidableEq p] [DecidableEq r] [DecidableEq o]

theorem perfect_residual_bound_ancilla (N : q → Matrix b d ℂ) (K : p → Matrix b d ℂ)
    (D R : Matrix d d ℂ) (hD : D.IsHermitian) (hR : R.IsHermitian)
    (hRR : R * R = R) (hDR : D * R = 0)
    (hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef)
    (hK : (∑ j, (K j)ᴴ * K j) = D * D)
    (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    (hgap : (δ • (1 - R) - D * D).PosSemidef) (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (rectKrausMap N)
      (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * X * ((R + D) ⊗ₖ (1 : Matrix r r ℂ))ᴴ -
        (R ⊗ₖ (1 : Matrix r r ℂ)) * X * (R ⊗ₖ (1 : Matrix r r ℂ))ᴴ) -
      amplifyRect (rectKrausMap K) X) ≤ perfectEnvelope (Real.sqrt δ) * traceNorm X := by
  have hDt : (D ⊗ₖ (1 : Matrix r r ℂ)).IsHermitian := by
    change _ᴴ = _
    rw [Matrix.conjTranspose_kronecker, hD.eq, Matrix.conjTranspose_one]
  have hRt : (R ⊗ₖ (1 : Matrix r r ℂ)).IsHermitian := by
    change _ᴴ = _
    rw [Matrix.conjTranspose_kronecker, hR.eq, Matrix.conjTranspose_one]
  have hNt := tensor_kraus_gram_bound (r := r) N 1 (by simpa using hN)
  simp only [one_smul] at hNt
  have hKt : (∑ j, (K j ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (K j ⊗ₖ (1 : Matrix r r ℂ))) =
      (D ⊗ₖ (1 : Matrix r r ℂ)) * (D ⊗ₖ (1 : Matrix r r ℂ)) := by
    simp only [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
      ← Matrix.mul_kronecker_mul, Matrix.one_mul]
    rw [← hK]
    ext x y
    simp only [Matrix.sum_apply, Matrix.kroneckerMap_apply, Finset.sum_mul]
  have hgt : (δ • (1 - (R ⊗ₖ (1 : Matrix r r ℂ))) -
      (D ⊗ₖ (1 : Matrix r r ℂ)) * (D ⊗ₖ (1 : Matrix r r ℂ))).PosSemidef := by
    have hp := hgap.kronecker (Matrix.PosSemidef.one : (1 : Matrix r r ℂ).PosSemidef)
    convert hp using 1
    rw [← Matrix.mul_kronecker_mul, Matrix.one_mul]
    ext x y
    simp [Matrix.kroneckerMap_apply, Matrix.sub_apply, Matrix.smul_apply,
      Matrix.one_apply, Complex.real_smul, sub_mul, mul_sub, Prod.ext_iff, ite_mul, mul_ite]
    split_ifs <;> simp_all
  have hh := perfect_residual_bound (fun i => N i ⊗ₖ (1 : Matrix r r ℂ))
    (fun j => K j ⊗ₖ (1 : Matrix r r ℂ)) _ _ hDt hRt
    (by rw [← Matrix.mul_kronecker_mul, hRR, Matrix.one_mul])
    (by rw [← Matrix.mul_kronecker_mul, hDR, Matrix.zero_kronecker])
    hNt hKt δ hδ hδ1 hgt X
  rw [amplifyRect_kraus, amplifyRect_kraus, Matrix.add_kronecker]
  exact hh

theorem perfect_remainder_measurement_bound (B A : o → Matrix d d ℂ)
    (hB : ∀ j, (B j).PosSemidef) (hA : ∀ j, (A j).PosSemidef)
    (D R : Matrix d d ℂ) (hD : D.PosSemidef) (hR : R.PosSemidef)
    (hRR : R * R = R) (hDR : D * R = 0)
    (hsumB : ∑ j, B j = (R + D) * (R + D)) (hsumA : ∑ j, A j = D * D)
    (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    (hgap : (δ • (1 - R) - D * D).PosSemidef) (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap B - effectMap (fun j => R * B j * R) - effectMap A) X) ≤
      perfectEnvelope (Real.sqrt δ) * traceNorm X := by
  obtain ⟨V, hV, hfactor⟩ := positive_family_factorization B hB
  have hroot : positiveRoot (∑ j, B j) (Matrix.posSemidef_sum _ (fun j _ => hB j)) = R + D := by
    rw [positiveRoot_eq_cfc]
    exact CFC.sqrt_unique hsumB.symm (hR.add hD).nonneg
  rw [hroot] at hfactor
  let N := fun p : o × d => readoutKraus p * V
  let K := fun p : o × d => readoutKraus p * stack (fun j => positiveRoot (A j) (hA j))
  have hN : ((1 : Matrix d d ℂ) - ∑ i, (N i)ᴴ * N i).PosSemidef := by
    have hh := gram_bound_of_norm V 1 zero_le_one hV
    simpa only [N, readout_composition_gram, one_pow, one_smul] using hh
  have hK : (∑ j, (K j)ᴴ * K j) = D * D := by
    dsimp only [K]
    rw [readout_composition_gram, stack_gram]
    simpa only [positiveRoot_gram] using hsumA
  have hf (Y : Matrix (d × r) (d × r) ℂ) : amplifyRect (effectMap B) Y =
      amplifyRect (rectKrausMap N)
        (((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * Y * ((R + D) ⊗ₖ (1 : Matrix r r ℂ))ᴴ) := by
    rw [hfactor, amplifyRect_kraus_composition]
  have hHR : (R + D) * R = R := by rw [Matrix.add_mul, hRR, hDR, add_zero]
  have hten : ((R + D) ⊗ₖ (1 : Matrix r r ℂ)) * (R ⊗ₖ (1 : Matrix r r ℂ)) = R ⊗ₖ (1 : Matrix r r ℂ) := by
    rw [← Matrix.mul_kronecker_mul, hHR, Matrix.one_mul]
  change traceNorm ((amplifyRect (effectMap B) X - amplifyRect (effectMap (fun j => R * B j * R)) X) -
    amplifyRect (effectMap A) X) ≤ _
  have hc : (fun j => R * B j * R) = (fun j => Rᴴ * B j * R) := by rw [hR.1.eq]
  rw [hc, amplify_effectMap_compressed, hf X, hf, positive_effectMap_kraus A hA]
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
  exact perfect_residual_bound_ancilla N K D R hD.1 hR.1 hRR hDR hN hK δ hδ hδ1 hgap X

lemma perfect_packing_sectors (E : FinitePOVM d o) (c : ℝ) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hα : packingAlpha (canonicalSynthesis E c) = 1) (j : o) :
    thresholdProjector (E.effect j) (E.positive j).1 c =
      sectorProjection E c (polarIsometry (canonicalSynthesis E c)) j := by
  have hh := canonical_principal_angle E c hT j
  rw [hα] at hh
  norm_num at hh
  exact sub_eq_zero.mp hh

lemma selected_defect_positive (E : FinitePOVM d o) (c : ℝ) (j : o) :
    (thresholdProjector (E.effect j) (E.positive j).1 c - selectedEffect E c j).PosSemidef := by
  have hp := (E.effect_le_one j).conjTranspose_mul_mul_same
    (thresholdProjector (E.effect j) (E.positive j).1 c)
  simpa only [(thresholdProjector_positive (E.effect j) (E.positive j).1 c).1.eq,
    Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, thresholdProjector_idempotent,
    selectedEffect] using hp

theorem perfect_packing_all_inputs (E : FinitePOVM d o) (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    [Nonempty (SectorIndex E (1 - δ))]
    (hT : Function.Injective (canonicalSynthesis E (1 - δ)).mulVec)
    (hα : packingAlpha (canonicalSynthesis E (1 - δ)) = 1)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (measurementMap E - measurementMap (canonicalCompletion E (1 - δ) hT)) X) ≤
      perfectEnvelope (Real.sqrt δ) * traceNorm X := by
  let c := 1 - δ
  let U := polarIsometry (canonicalSynthesis E c)
  let R := 1 - U * Uᴴ
  let P := fun j => thresholdProjector (E.effect j) (E.positive j).1 c
  let B := fun j => E.effect j - selectedEffect E c j
  let A := fun j => P j - selectedEffect E c j
  have hU : Uᴴ * U = 1 := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  have hRp := residual_projection_properties U hU
  have hRh : Rᴴ = R := hRp.1
  have hRR : R * R = R := hRp.2.1
  have hP (j : o) : P j = sectorProjection E c U j := perfect_packing_sectors E c hT hα j
  have hsumP : ∑ j, P j = U * Uᴴ := by
    simp only [hP, sectorProjection, ← Matrix.sum_mul, ← Matrix.mul_sum,
      sectorCoordinate_sum, Matrix.mul_one]
  obtain ⟨G, hG, hGR, hgap, hsum, hAR⟩ := canonical_remainder_data E c (by dsimp [c]; linarith) hT
  change G * R = 0 at hGR
  have hRG : R * G = 0 := by
    have hh := congrArg Matrix.conjTranspose hGR
    simpa only [Matrix.conjTranspose_mul, hRh, hG.1.eq, Matrix.conjTranspose_zero] using hh
  have hsumA : ∑ j, A j = G * G := by
    have hb : (∑ j, B j) = R + G * G := by
      change (∑ j, (E.effect j - selectedEffect E c j)) = _
      rw [hsum]
      change (R + G) * (R + G) = _
      rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_add, hRR, hRG, hGR, add_zero, zero_add]
    dsimp only [B] at hb
    rw [Finset.sum_sub_distrib, E.normalized] at hb
    dsimp only [A]
    rw [Finset.sum_sub_distrib, hsumP]
    dsimp only [R] at hb
    calc
      _ = (1 - ∑ j, selectedEffect E c j) - (1 - U * Uᴴ) := by abel
      _ = _ := by rw [hb]; abel
  have hgap' : (δ • (1 - R) - G * G).PosSemidef := by
    simpa only [c, R, U, hα, one_pow, one_mul, sub_sub_cancel] using hgap
  have hh := perfect_remainder_measurement_bound B A (remainderEffect_positive E c)
    (selected_defect_positive E c) G R hG hRp.2.2 hRR hGR hsum hsumA δ hδ hδ1 hgap' X
  have heffect : (fun j => E.effect j - (canonicalCompletion E c hT).effect j) =
      fun j => (B j - R * B j * R) - A j := by
    funext j
    rw [canonicalCompletion_effect]
    change E.effect j - (sectorProjection E c U j + R * E.effect j * R) = _
    have hBR : R * B j * R = R * E.effect j * R := by
      dsimp only [B]
      rw [Matrix.mul_sub R (E.effect j) (selectedEffect E c j),
        Matrix.sub_mul (R * E.effect j) (R * selectedEffect E c j) R, hAR j, sub_zero]
    rw [hBR, ← hP]
    dsimp only [B, A]
    abel
  have hmaps : measurementMap E - measurementMap (canonicalCompletion E c hT) =
      effectMap B - effectMap (fun j => R * B j * R) - effectMap A := by
    change effectMap E.effect - effectMap (canonicalCompletion E c hT).effect = _
    rw [← effectMap_sub, heffect]
    simp only [effectMap_sub]
  rwa [hmaps]

theorem perfect_packing_diamond_upper (E : FinitePOVM d o) (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    [Nonempty (SectorIndex E (1 - δ))]
    (hT : Function.Injective (canonicalSynthesis E (1 - δ)).mulVec)
    (hα : packingAlpha (canonicalSynthesis E (1 - δ)) = 1) :
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E (1 - δ) hT)) ≤
      ENNReal.ofReal (perfectEnvelope (Real.sqrt δ)) := by
  apply diamondSize_le_of_all_inputs
  intro n X hX
  have hh := perfect_packing_all_inputs E δ hδ hδ1 hT hα X
  have hs : Real.sqrt δ < 1 := by nlinarith [Real.sq_sqrt hδ.le, Real.sqrt_nonneg δ]
  have hB : 0 ≤ perfectEnvelope (Real.sqrt δ) :=
    div_nonneg (by positivity) (by linarith)
  exact hh.trans (by nlinarith)

end RCProof
