import RCProof.SharpDistance
import RCProof.PackingBounds

namespace RCProof
set_option autoImplicit false
set_option maxHeartbeats 600000
set_option backward.isDefEq.respectTransparency false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d k r : Type*} [Fintype d] [Fintype k] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq r]

lemma tensor_norm_bound (A : Matrix d k ℂ) (b : ℝ) (hb : 0 ≤ b) (hA : ‖A‖ ≤ b) :
    ‖A ⊗ₖ (1 : Matrix r r ℂ)‖ ≤ b := by
  apply norm_le_of_gram _ b hb
  have hp := (gram_bound_of_norm A b hb hA).kronecker
    (Matrix.PosSemidef.one : (1 : Matrix r r ℂ).PosSemidef)
  convert hp using 1
  simp only [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
    ← Matrix.mul_kronecker_mul, Matrix.one_mul]
  ext x y
  simp [Matrix.kroneckerMap_apply, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply,
    Complex.real_smul, sub_mul, Prod.ext_iff, ite_mul, mul_ite]
  split_ifs <;> simp_all

lemma contraction_difference_trace_bound (A B : Matrix d k ℂ)
    (hA : ‖A‖ ≤ 1) (hB : ‖B‖ ≤ 1) (h : ℝ) (hh : ‖A - B‖ ≤ h) (X : Matrix k k ℂ) :
    traceNorm (A * X * Aᴴ - B * X * Bᴴ) ≤ 2 * h * traceNorm X := by
  have hsplit := shifted_telescoping A B X 1
  simp only [one_smul] at hsplit
  rw [hsplit]
  have hn := traceNorm_nonneg X
  have hh0 : 0 ≤ h := (norm_nonneg _).trans hh
  calc
    _ ≤ traceNorm ((A - B) * X * Aᴴ) + traceNorm (B * X * (A - B)ᴴ) := traceNorm_add _ _
    _ ≤ ‖A - B‖ * traceNorm X * ‖A‖ + ‖B‖ * traceNorm X * ‖A - B‖ :=
      add_le_add (traceNorm_mul_sandwich _ _ _) (traceNorm_mul_sandwich _ _ _)
    _ ≤ h * traceNorm X * 1 + 1 * traceNorm X * h := by gcongr
    _ = _ := by ring

lemma contraction_difference_trace_bound_ancilla (A B : Matrix d k ℂ)
    (hA : ‖A‖ ≤ 1) (hB : ‖B‖ ≤ 1) (h : ℝ) (hh : ‖A - B‖ ≤ h)
    (X : Matrix (k × r) (k × r) ℂ) :
    traceNorm ((A ⊗ₖ (1 : Matrix r r ℂ)) * X * (A ⊗ₖ (1 : Matrix r r ℂ))ᴴ -
      (B ⊗ₖ (1 : Matrix r r ℂ)) * X * (B ⊗ₖ (1 : Matrix r r ℂ))ᴴ) ≤ 2 * h * traceNorm X := by
  apply contraction_difference_trace_bound _ _ (tensor_norm_bound A 1 zero_le_one hA)
    (tensor_norm_bound B 1 zero_le_one hB)
  have ht := tensor_norm_bound (r := r) (A - B) h ((norm_nonneg _).trans hh) hh
  convert ht using 1
  congr 1
  ext x y
  simp [Matrix.kroneckerMap_apply, sub_mul]

lemma hermitian_norm_sub_one (H : Matrix k k ℂ) (hH : H.IsHermitian)
    (a M : ℝ) (ha : a ≤ 1) (hM : 1 ≤ M)
    (hl : (H - a • (1 : Matrix k k ℂ)).PosSemidef)
    (hu : (M • (1 : Matrix k k ℂ) - H).PosSemidef) :
    ‖H - 1‖ ≤ max (1 - a) (M - 1) := by
  have hl' : (a - 1) • (1 : Matrix k k ℂ) ≤ H - 1 := by
    apply Matrix.le_iff.mpr
    convert hl using 1 <;> module
  have hu' : H - 1 ≤ (M - 1) • (1 : Matrix k k ℂ) := by
    apply Matrix.le_iff.mpr
    convert hu using 1 <;> module
  have hn := IsSelfAdjoint.norm_le_max_of_le_of_le hl' hu' (hH.sub Matrix.isHermitian_one).isSelfAdjoint
  apply hn.trans
  apply max_le_max
  · rw [norm_smul, Real.norm_eq_abs, abs_of_nonpos (by linarith)]
    have hi : ‖(1 : Matrix k k ℂ)‖ ≤ 1 := isometry_norm_le_one _ (by simp)
    nlinarith
  · rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (by linarith)]
    have hi : ‖(1 : Matrix k k ℂ)‖ ≤ 1 := isometry_norm_le_one _ (by simp)
    nlinarith

lemma selected_product_close (H D : Matrix k k ℂ) (hH : H.IsHermitian) (hDp : D.PosSemidef)
    (a M t : ℝ) (ha : a ≤ 1) (hM : 1 ≤ M) (ht : t ≤ 1)
    (hHl : (H - a • (1 : Matrix k k ℂ)).PosSemidef)
    (hHu : (M • (1 : Matrix k k ℂ) - H).PosSemidef)
    (hDl : (D - t • (1 : Matrix k k ℂ)).PosSemidef) (hDu : (1 - D).PosSemidef) :
    ‖D * H - 1‖ ≤ max (1 - a) (M - 1) + (1 - t) := by
  have hnH := hermitian_norm_sub_one H hH a M ha hM hHl hHu
  have hnD := hermitian_norm_sub_one D hDp.1 t 1 ht le_rfl hDl (by simpa using hDu)
  rw [sub_self, max_eq_left (sub_nonneg.mpr ht)] at hnD
  have hD := positive_norm_le D hDp 1 zero_le_one (by simpa using hDu)
  have heq : D * H - 1 = D * (H - 1) + (D - 1) := by noncomm_ring
  rw [heq]
  have hsum := norm_add_le (D * (H - 1)) (D - 1)
  have hmul := Matrix.l2_opNorm_mul D (H - 1)
  have hmul2 : ‖D‖ * ‖H - 1‖ ≤ ‖H - 1‖ := by
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hD (norm_nonneg (H - 1))
  exact hsum.trans (add_le_add (hmul.trans (hmul2.trans hnH)) hnD)

variable {o : Type*} [Fintype o] [DecidableEq o]

noncomputable def selectedCorrectionRadius (E : FinitePOVM d o) (c : ℝ)
    [Nonempty (SectorIndex E c)] : ℝ :=
  max (1 - packingAlpha (canonicalSynthesis E c)) ((Real.sqrt c)⁻¹ - 1) + (1 - Real.sqrt c)

/-- Order-error norm control for the actual canonical selected operator. -/
theorem canonical_selected_operator_close (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 < c) (hc1 : c ≤ 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    ‖sectorRoot E c * polarRoot (canonicalSynthesis E c) - 1‖ ≤ selectedCorrectionRadius E c := by
  have hs : 0 < Real.sqrt c := Real.sqrt_pos.mpr hc
  have hs1 : Real.sqrt c ≤ 1 := by simpa using Real.sqrt_le_sqrt hc1
  exact selected_product_close _ _ (polarRoot_hermitian _) (sectorRoot_positive E c)
    (packingAlpha (canonicalSynthesis E c)) ((Real.sqrt c)⁻¹) (Real.sqrt c)
    (canonical_packing_le_one E c) ((one_le_inv₀ hs).mpr hs1) hs1
    (packing_polar_lower _) (canonical_polar_upper E c hc hT)
    (sectorRoot_lower E c) (sectorRoot_upper E c)

end RCProof
