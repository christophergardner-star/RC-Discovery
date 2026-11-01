import RCProof.SharpDistance
import RCProof.KrausContraction

namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b o q r : Type*} [Fintype d] [Fintype b] [Fintype o] [Fintype q] [Fintype r]
  [DecidableEq d] [DecidableEq b] [DecidableEq o] [DecidableEq q] [DecidableEq r]

def rectKrausMap (A : q → Matrix b d ℂ) : RectMatrixMap d b where
  toFun X := ∑ i, A i * X * (A i)ᴴ
  map_add' X Y := by simp [Matrix.mul_add, Matrix.add_mul, Finset.sum_add_distrib]
  map_smul' z X := by simp [Matrix.mul_smul, Matrix.smul_mul, Finset.smul_sum]

lemma amplifyRect_kraus (A : q → Matrix b d ℂ) (X : Matrix (d × r) (d × r) ℂ) :
    amplifyRect (rectKrausMap A) X =
      ∑ i, (A i ⊗ₖ (1 : Matrix r r ℂ)) * X * (A i ⊗ₖ (1 : Matrix r r ℂ))ᴴ := by
  ext x y
  simp [amplifyRect, rectKrausMap, Matrix.sum_apply, Matrix.mul_apply, Matrix.conjTranspose_apply,
    Matrix.kroneckerMap_apply, Matrix.kronecker, Matrix.one_apply, Fintype.sum_prod_type,
    apply_ite, mul_ite, ite_mul] <;> rfl

lemma tensor_kraus_normalized (A : q → Matrix b d ℂ) (hA : ∑ i, (A i)ᴴ * A i = 1) :
    ∑ i, (A i ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (A i ⊗ₖ (1 : Matrix r r ℂ)) = 1 := by
  simp only [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
    ← Matrix.mul_kronecker_mul, Matrix.one_mul]
  have heq : (∑ i, (A i)ᴴ * A i) ⊗ₖ (1 : Matrix r r ℂ) =
      ∑ i, ((A i)ᴴ * A i) ⊗ₖ (1 : Matrix r r ℂ) := by
    ext x y
    simp [Matrix.kroneckerMap_apply, Matrix.sum_apply, Finset.sum_mul]
  rw [← heq, hA, Matrix.one_kronecker_one]

def readoutKraus (p : o × d) : Matrix o (o × d) ℂ := Matrix.single p.1 p 1

lemma readoutKraus_normalized : ∑ p : o × d, (readoutKraus p)ᴴ * readoutKraus p = 1 := by
  simp only [readoutKraus, Matrix.conjTranspose_single, star_one,
    Matrix.single_mul_single_same, mul_one]
  ext x y
  by_cases hxy : x = y
  · subst y
    simp [Matrix.sum_apply, Matrix.single, Matrix.one_apply]
  · have hh (p : o × d) : ¬ (p = x ∧ p = y) := by aesop
    simp [Matrix.sum_apply, Matrix.single, Matrix.one_apply, hxy, hh]

lemma readoutKraus_output (Z : Matrix (o × d) (o × d) ℂ) :
    ∑ p : o × d, readoutKraus p * Z * (readoutKraus p)ᴴ =
      Matrix.diagonal (fun j => ∑ a, Z (j, a) (j, a)) := by
  simp only [readoutKraus, Matrix.conjTranspose_single, star_one,
    Matrix.single_mul_mul_single, one_mul, mul_one]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [Matrix.sum_apply, Matrix.single, Matrix.diagonal_apply, Fintype.sum_prod_type,
      ← Finset.sum_ite_irrel]
    rw [Finset.sum_comm]
    simp
  · have hh (x : o) : ¬ (x = i ∧ x = j) := by aesop
    simp [Matrix.sum_apply, Matrix.single, Matrix.diagonal_apply, Fintype.sum_prod_type, hij, hh]

lemma dilation_readout_trace (W : Matrix (o × b) d ℂ) (X : Matrix d d ℂ) (j : o) :
    ∑ a, (W * X * Wᴴ) (j, a) (j, a) = (Wᴴ * labelProjection j * W * X).trace := by
  rw [Matrix.mul_assoc (Wᴴ * labelProjection j), Matrix.mul_assoc Wᴴ,
    Matrix.trace_mul_comm Wᴴ]
  simp only [Matrix.mul_assoc]
  simp [labelProjection, Matrix.trace, Matrix.diag, Matrix.diagonal_mul, Fintype.sum_prod_type,
    ← Finset.sum_ite_irrel]
  rw [Finset.sum_comm]
  simp

lemma measurementMap_eq_dilation_readout (E : FinitePOVM d o) (W : Matrix (o × b) d ℂ)
    (hc : ∀ j, Wᴴ * labelProjection j * W = E.effect j) :
    measurementMap E = rectKrausMap (fun p : o × b => readoutKraus p * W) := by
  apply LinearMap.ext
  intro X
  change Matrix.diagonal (fun j => (E.effect j * X).trace) =
    ∑ p : o × b, (readoutKraus p * W) * X * (readoutKraus p * W)ᴴ
  have heq : (∑ p : o × b, (readoutKraus p * W) * X * (readoutKraus p * W)ᴴ) =
      ∑ p : o × b, readoutKraus p * (W * X * Wᴴ) * (readoutKraus p)ᴴ := by
    simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
  rw [heq, readoutKraus_output]
  congr 1
  funext j
  rw [dilation_readout_trace, hc]

lemma amplified_measurement_difference (E F : FinitePOVM d o)
    (W V : Matrix (o × b) d ℂ)
    (hcW : ∀ j, Wᴴ * labelProjection j * W = E.effect j)
    (hcV : ∀ j, Vᴴ * labelProjection j * V = F.effect j)
    (X : Matrix (d × r) (d × r) ℂ) :
    amplifyRect (measurementMap E - measurementMap F) X =
      ∑ p : o × b, (readoutKraus p ⊗ₖ (1 : Matrix r r ℂ)) *
        ((W ⊗ₖ (1 : Matrix r r ℂ)) * X * (W ⊗ₖ (1 : Matrix r r ℂ))ᴴ -
          (V ⊗ₖ (1 : Matrix r r ℂ)) * X * (V ⊗ₖ (1 : Matrix r r ℂ))ᴴ) *
        (readoutKraus p ⊗ₖ (1 : Matrix r r ℂ))ᴴ := by
  have hsub : amplifyRect (measurementMap E - measurementMap F) X =
      amplifyRect (measurementMap E) X - amplifyRect (measurementMap F) X := rfl
  rw [hsub, measurementMap_eq_dilation_readout E W hcW,
    measurementMap_eq_dilation_readout F V hcV, amplifyRect_kraus, amplifyRect_kraus]
  have hprod (A : Matrix o (o × b) ℂ) (B : Matrix (o × b) d ℂ) :
      (A * B) ⊗ₖ (1 : Matrix r r ℂ) = (A ⊗ₖ (1 : Matrix r r ℂ)) * (B ⊗ₖ (1 : Matrix r r ℂ)) := by
    rw [← Matrix.mul_kronecker_mul, Matrix.one_mul]
  simp only [hprod, Matrix.conjTranspose_mul, Matrix.mul_sub, Matrix.sub_mul,
    Finset.sum_sub_distrib, Matrix.mul_assoc]

/-- The unhalved measurement-channel estimate, with every finite ancilla and
every complex input included in diamondSize. -/
theorem measurement_diamond_of_overlap (E F : FinitePOVM d o)
    (W V : Matrix (o × b) d ℂ)
    (hW : Wᴴ * W = 1) (hV : Vᴴ * V = 1)
    (hcW : ∀ j, Wᴴ * labelProjection j * W = E.effect j)
    (hcV : ∀ j, Vᴴ * labelProjection j * V = F.effect j)
    (η : ℝ) (hη : 0 ≤ η) (hη1 : η ≤ 1)
    (hf : (realPart (Wᴴ * V) - η • (1 : Matrix d d ℂ)).PosSemidef) :
    diamondSize (measurementMap E - measurementMap F) ≤
      ENNReal.ofReal (2 * Real.sqrt (1 - η ^ 2)) := by
  apply diamondSize_le_of_all_inputs
  intro n X hX
  rw [amplified_measurement_difference E F W V hcW hcV X]
  calc
    _ ≤ traceNorm ((W ⊗ₖ (1 : Matrix (Fin n) (Fin n) ℂ)) * X * (W ⊗ₖ (1 : Matrix (Fin n) (Fin n) ℂ))ᴴ -
        (V ⊗ₖ (1 : Matrix (Fin n) (Fin n) ℂ)) * X * (V ⊗ₖ (1 : Matrix (Fin n) (Fin n) ℂ))ᴴ) :=
      traceNorm_kraus_contraction _ (tensor_kraus_normalized _ readoutKraus_normalized) _
    _ ≤ 2 * Real.sqrt (1 - η ^ 2) * traceNorm X :=
      sharp_isometry_trace_distance_ancilla W V hW hV η hη hη1 hf X
    _ ≤ _ := by nlinarith [Real.sqrt_nonneg (1 - η ^ 2)]

lemma kraus_composition_normalized (A : q → Matrix b d ℂ) (hA : ∑ i, (A i)ᴴ * A i = 1)
    {k : Type*} [Fintype k] [DecidableEq k] (W : Matrix d k ℂ) (hW : Wᴴ * W = 1) :
    ∑ i, (A i * W)ᴴ * (A i * W) = 1 := by
  simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
  have heq : (∑ i, Wᴴ * ((A i)ᴴ * (A i * W))) = Wᴴ * (∑ i, (A i)ᴴ * A i) * W := by
    simp only [Matrix.mul_sum, Matrix.sum_mul, Matrix.mul_assoc]
  rw [heq, hA, Matrix.mul_one, hW]

theorem measurement_amplify_contracts (E : FinitePOVM d o) (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (measurementMap E) X) ≤ traceNorm X := by
  rw [measurementMap_eq_dilation_readout E (naimark E) (naimark_compression E), amplifyRect_kraus]
  apply traceNorm_kraus_contraction
  apply tensor_kraus_normalized
  exact kraus_composition_normalized _ readoutKraus_normalized _ (naimark_isometry E)

theorem measurement_diamond_le_two (E F : FinitePOVM d o) :
    diamondSize (measurementMap E - measurementMap F) ≤ ENNReal.ofReal 2 := by
  apply diamondSize_le_of_all_inputs
  intro n X hX
  have heq : amplifyRect (measurementMap E - measurementMap F) X =
      amplifyRect (measurementMap E) X - amplifyRect (measurementMap F) X := rfl
  rw [heq, sub_eq_add_neg]
  have h := traceNorm_add (amplifyRect (measurementMap E) X) (-amplifyRect (measurementMap F) X)
  rw [traceNorm_neg] at h
  have hE := measurement_amplify_contracts E X
  have hF := measurement_amplify_contracts F X
  linarith

end RCProof
