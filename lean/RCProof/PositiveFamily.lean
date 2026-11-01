import RCProof.MeasurementDistance
import RCProof.SignedKraus
import RCProof.SelectedCorrection

/-! Positive effect families admit a contraction factorization through the
positive square root of their sum, including singular sums. -/
namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b o q r : Type*} [Fintype d] [Fintype b] [Fintype o] [Fintype q] [Fintype r]
  [DecidableEq d] [DecidableEq b] [DecidableEq o] [DecidableEq q] [DecidableEq r]

def effectMap (A : o → Matrix d d ℂ) : RectMatrixMap d o where
  toFun X := Matrix.diagonal (fun j => (A j * X).trace)
  map_add' X Y := by
    ext i j
    simp [Matrix.mul_add, Matrix.trace_add, Matrix.diagonal_apply]
    split_ifs <;> simp
  map_smul' z X := by
    ext i j
    simp [Matrix.trace_smul, Matrix.diagonal_apply]

lemma effectMap_measurement (E : FinitePOVM d o) : effectMap E.effect = measurementMap E := rfl

lemma effectMap_add (A B : o → Matrix d d ℂ) :
    effectMap (fun j => A j + B j) = effectMap A + effectMap B := by
  ext X i j
  simp [effectMap, Matrix.add_mul, Matrix.trace_add, Matrix.diagonal_apply]
  split_ifs <;> simp

lemma effectMap_sub (A B : o → Matrix d d ℂ) :
    effectMap (fun j => A j - B j) = effectMap A - effectMap B := by
  ext X i j
  simp [effectMap, Matrix.sub_mul, Matrix.trace_sub, Matrix.diagonal_apply]
  split_ifs <;> simp

lemma effectMap_compressions (W : Matrix (o × b) d ℂ) :
    effectMap (fun j => Wᴴ * labelProjection j * W) =
      rectKrausMap (fun p : o × b => readoutKraus p * W) := by
  apply LinearMap.ext
  intro X
  change Matrix.diagonal (fun j => (Wᴴ * labelProjection j * W * X).trace) =
    ∑ p : o × b, (readoutKraus p * W) * X * (readoutKraus p * W)ᴴ
  have heq : (∑ p : o × b, (readoutKraus p * W) * X * (readoutKraus p * W)ᴴ) =
      ∑ p : o × b, readoutKraus p * (W * X * Wᴴ) * (readoutKraus p)ᴴ := by
    simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
  rw [heq, readoutKraus_output]
  congr 1
  funext j
  exact (dilation_readout_trace W X j).symm

lemma positive_effectMap_kraus (A : o → Matrix d d ℂ) (hA : ∀ j, (A j).PosSemidef) :
    effectMap A = rectKrausMap (fun p : o × d => readoutKraus p * stack (fun j => positiveRoot (A j) (hA j))) := by
  have hc : (fun j => (stack (fun j => positiveRoot (A j) (hA j)))ᴴ * labelProjection j *
      stack (fun j => positiveRoot (A j) (hA j))) = A := by
    funext j
    rw [stack_label_compression, positiveRoot_gram]
  exact (congrArg effectMap hc).symm.trans (effectMap_compressions _)

lemma readout_composition_gram (V : Matrix (o × b) d ℂ) :
    ∑ p : o × b, (readoutKraus p * V)ᴴ * (readoutKraus p * V) = Vᴴ * V := by
  simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
  have heq : (∑ p : o × b, Vᴴ * ((readoutKraus p)ᴴ * (readoutKraus p * V))) =
      Vᴴ * (∑ p : o × b, (readoutKraus p)ᴴ * readoutKraus p) * V := by
    simp only [Matrix.mul_sum, Matrix.sum_mul, Matrix.mul_assoc]
  rw [heq, readoutKraus_normalized, Matrix.mul_one]

lemma tensor_kraus_gram_bound (A : q → Matrix b d ℂ) (B : ℝ)
    (hA : (B • (1 : Matrix d d ℂ) - ∑ i, (A i)ᴴ * A i).PosSemidef) :
    (B • (1 : Matrix (d × r) (d × r) ℂ) -
      ∑ i, (A i ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (A i ⊗ₖ (1 : Matrix r r ℂ))).PosSemidef := by
  have hp := hA.kronecker (Matrix.PosSemidef.one : (1 : Matrix r r ℂ).PosSemidef)
  simp only [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
    ← Matrix.mul_kronecker_mul, Matrix.one_mul]
  convert hp using 1
  ext x y
  simp [Matrix.kroneckerMap_apply, Matrix.sub_apply, Matrix.smul_apply, Matrix.sum_apply,
    Matrix.one_apply, Complex.real_smul, sub_mul, Finset.sum_mul, Prod.ext_iff, ite_mul, mul_ite]
  split_ifs <;> simp_all

theorem rectKraus_amplify_bound (A : q → Matrix b d ℂ) (B : ℝ) (hB : 0 ≤ B)
    (hA : (B • (1 : Matrix d d ℂ) - ∑ i, (A i)ᴴ * A i).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (rectKrausMap A) X) ≤ B * traceNorm X := by
  rw [amplifyRect_kraus]
  have hh := traceNorm_signed_kraus_bound (fun i => A i ⊗ₖ (1 : Matrix r r ℂ)) (fun _ => 1)
    (by intro i; norm_num) B hB (tensor_kraus_gram_bound A B hA) X
  simpa only [one_smul] using hh

lemma amplifyRect_kraus_composition (A : q → Matrix b d ℂ) (H : Matrix d d ℂ)
    (X : Matrix (d × r) (d × r) ℂ) :
    amplifyRect (rectKrausMap (fun i => A i * H)) X =
      amplifyRect (rectKrausMap A) ((H ⊗ₖ (1 : Matrix r r ℂ)) * X * (H ⊗ₖ (1 : Matrix r r ℂ))ᴴ) := by
  rw [amplifyRect_kraus, amplifyRect_kraus]
  have hprod (i : q) : (A i * H) ⊗ₖ (1 : Matrix r r ℂ) =
      (A i ⊗ₖ (1 : Matrix r r ℂ)) * (H ⊗ₖ (1 : Matrix r r ℂ)) := by
    rw [← Matrix.mul_kronecker_mul, Matrix.one_mul]
  simp only [hprod, Matrix.conjTranspose_mul, Matrix.mul_assoc]

/-- The factorization is constructed; no support inverse or kernel-annihilation
condition is supplied by the caller. Its intermediate map may decrease trace. -/
theorem positive_family_factorization (A : o → Matrix d d ℂ) (hA : ∀ j, (A j).PosSemidef) :
    ∃ V : Matrix (o × d) d ℂ, ‖V‖ ≤ 1 ∧
      effectMap A = rectKrausMap (fun p : o × d => readoutKraus p * V *
        positiveRoot (∑ j, A j) (Matrix.posSemidef_sum _ (fun j _ => hA j))) := by
  let W := stack (fun j => positiveRoot (A j) (hA j))
  have hW : Wᴴ * W = ∑ j, A j := by
    dsimp only [W]
    rw [stack_gram]
    simp only [positiveRoot_gram]
  obtain ⟨V, hV, hf, _⟩ := exists_contraction_polar W
  refine ⟨V, hV, ?_⟩
  rw [positive_effectMap_kraus A hA]
  change rectKrausMap (fun p : o × d => readoutKraus p * W) = _
  rw [hf]
  congr 1
  funext p
  simp only [Matrix.mul_assoc, positiveRoot_eq_cfc, hW]

end RCProof
