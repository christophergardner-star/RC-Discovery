import RCProof.CanonicalRemainder

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d k o r : Type*} [Fintype d] [Fintype k] [Fintype o] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq o] [DecidableEq r]

theorem measurement_compression_difference_bound (E : FinitePOVM k o) (A B : Matrix k d ℂ)
    (hA : ‖A‖ ≤ 1) (hB : ‖B‖ ≤ 1) (h : ℝ) (hh : ‖A - B‖ ≤ h)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap (fun j => Aᴴ * E.effect j * A) -
      effectMap (fun j => Bᴴ * E.effect j * B)) X) ≤ 2 * h * traceNorm X := by
  change traceNorm (amplifyRect (effectMap (fun j => Aᴴ * E.effect j * A)) X -
    amplifyRect (effectMap (fun j => Bᴴ * E.effect j * B)) X) ≤ _
  rw [amplify_effectMap_compressed, amplify_effectMap_compressed, effectMap_measurement,
    ← amplifyRect_sub_input]
  exact (measurement_amplify_contracts E _).trans
    (contraction_difference_trace_bound_ancilla A B hA hB h hh X)

theorem canonical_selected_measurement_bound (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 < c) (hc1 : c ≤ 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap (selectedEffect E c) -
      effectMap (sectorProjection E c (polarIsometry (canonicalSynthesis E c)))) X) ≤
      2 * selectedCorrectionRadius E c * traceNorm X := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  let D := sectorRoot E c
  have hU : Uᴴ * U = 1 := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hUH : U * H = T := polar_factorization T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hnU : ‖Uᴴ‖ ≤ 1 := by rw [Matrix.l2_opNorm_conjTranspose]; exact isometry_norm_le_one U hU
  have hnDH := canonical_selected_contraction E c hT
  have hnK : ‖D * H * Uᴴ‖ ≤ 1 := by
    apply (Matrix.l2_opNorm_mul _ _).trans
    nlinarith [norm_nonneg (D * H)]
  have hnclose : ‖D * H * Uᴴ - Uᴴ‖ ≤ selectedCorrectionRadius E c := by
    have hclose := canonical_selected_operator_close E c hc hc1 hT
    have heq : D * H * Uᴴ - Uᴴ = (D * H - 1) * Uᴴ := by rw [Matrix.sub_mul, Matrix.one_mul]
    rw [heq]
    apply (Matrix.l2_opNorm_mul _ _).trans
    have hmul := mul_le_mul_of_nonneg_left hnU (norm_nonneg (D * H - 1))
    have hmul' : ‖D * H - 1‖ * ‖Uᴴ‖ ≤ ‖D * H - 1‖ := by
      simpa only [mul_one] using hmul
    exact hmul'.trans hclose
  have hA : (fun j => (D * H * Uᴴ)ᴴ * (canonicalFrame E c).coordinates.effect j * (D * H * Uᴴ)) =
      selectedEffect E c := by
    funext j
    rw [canonicalFrame_coordinates, selectedEffect_factor,
      Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      (sectorRoot_positive E c).1.eq, polarRoot_hermitian]
    change (U * (H * D)) * sectorCoordinate E c j * (D * H * Uᴴ) = _
    rw [← Matrix.mul_assoc U H D, hUH, Matrix.conjTranspose_mul, (sectorRoot_positive E c).1.eq]
    have ht : Tᴴ = H * Uᴴ := by rw [← hUH, Matrix.conjTranspose_mul, polarRoot_hermitian]
    rw [ht]
    simp only [Matrix.mul_assoc]
    rfl
  have hQ : (fun j => (Uᴴ)ᴴ * (canonicalFrame E c).coordinates.effect j * Uᴴ) = sectorProjection E c U := by
    funext j
    rw [Matrix.conjTranspose_conjTranspose, canonicalFrame_coordinates]
    rfl
  have hb := measurement_compression_difference_bound (canonicalFrame E c).coordinates
    (D * H * Uᴴ) Uᴴ hnK hnU (selectedCorrectionRadius E c) hnclose X
  rw [hA, hQ] at hb
  exact hb

end RCProof
