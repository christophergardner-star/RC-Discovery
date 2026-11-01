import RCProof.PositiveFamily
import RCProof.FrozenDiamond

namespace RCProof
set_option autoImplicit false
open Matrix Unitary
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

noncomputable def selectedEffect (E : FinitePOVM d o) (c : ℝ) (j : o) : Matrix d d ℂ :=
  thresholdProjector (E.effect j) (E.positive j).1 c * E.effect j *
    thresholdProjector (E.effect j) (E.positive j).1 c

lemma selectedEffect_positive (E : FinitePOVM d o) (c : ℝ) (j : o) : (selectedEffect E c j).PosSemidef := by
  have hp := (E.positive j).conjTranspose_mul_mul_same (thresholdProjector (E.effect j) (E.positive j).1 c)
  rw [(thresholdProjector_positive (E.effect j) (E.positive j).1 c).1.eq] at hp
  exact hp

lemma remainderEffect_positive (E : FinitePOVM d o) (c : ℝ) (j : o) :
    (E.effect j - selectedEffect E c j).PosSemidef := by
  let h := (E.positive j).1
  have heq : E.effect j - selectedEffect E c j = inEigenbasis h.eigenvectorUnitary
      (fun i => h.eigenvalues i - (if c ≤ h.eigenvalues i then 1 else 0) * h.eigenvalues i *
        (if c ≤ h.eigenvalues i then 1 else 0)) := by
    unfold selectedEffect thresholdProjector
    conv_lhs => lhs; rw [spectral_representation (E.effect j) h]
    conv_lhs => rhs; lhs; rhs; rw [spectral_representation (E.effect j) h]
    rw [inEigenbasis_mul, inEigenbasis_mul, ← inEigenbasis_sub]
  rw [heq]
  apply inEigenbasis_positive
  intro i
  split_ifs <;> simp [E.positive j |>.eigenvalues_nonneg i]

lemma selectedEffect_root_factor (E : FinitePOVM d o) (c : ℝ) (j : o) :
    selectedEffect E c j = positiveRoot (E.effect j) (E.positive j) *
      thresholdProjector (E.effect j) (E.positive j).1 c * positiveRoot (E.effect j) (E.positive j) := by
  let h := (E.positive j).1
  unfold selectedEffect thresholdProjector positiveRoot
  conv_lhs => lhs; rhs; rw [spectral_representation (E.effect j) h]
  simp only [inEigenbasis_mul]
  congr 1
  funext i
  split_ifs <;> simp [Real.mul_self_sqrt (E.positive j |>.eigenvalues_nonneg i)]

lemma sectorCoordinate_root_commutes (E : FinitePOVM d o) (c : ℝ) (j : o) :
    sectorCoordinate E c j * sectorRoot E c = sectorRoot E c * sectorCoordinate E c j := by
  simp only [sectorCoordinate, sectorRoot, realDiagonal, Matrix.diagonal_mul_diagonal]
  congr 1
  funext i
  exact mul_comm _ _

lemma selectedEffect_factor (E : FinitePOVM d o) (c : ℝ) (j : o) :
    selectedEffect E c j = (canonicalSynthesis E c * sectorRoot E c) * sectorCoordinate E c j *
      (canonicalSynthesis E c * sectorRoot E c)ᴴ := by
  let B := canonicalBlock E c j
  let D := sectorRoot E c
  let C := sectorCoordinate E c j
  let T := canonicalSynthesis E c
  have hC : C.IsHermitian := by
    have hp := (canonicalFrame E c).coordinates.positive j
    rw [canonicalFrame_coordinates] at hp
    exact hp.1
  have hCC : C * C = C := (sectorCoordinate_mul E c j j).trans (if_pos rfl)
  have hBD : B * D = (T * D) * C := by
    dsimp only [B, D, T, C]
    rw [canonicalBlock_factor, Matrix.mul_assoc, sectorCoordinate_root_commutes, ← Matrix.mul_assoc]
  have ha : selectedEffect E c j = (B * D) * (B * D)ᴴ := by
    rw [← canonicalBlock_root_action, Matrix.conjTranspose_mul,
      (positiveRoot_positive (E.effect j) (E.positive j)).1.eq]
    rw [selectedEffect_root_factor, ← canonicalBlock_full]
    simp only [Matrix.mul_assoc]
  rw [ha, hBD, Matrix.conjTranspose_mul, hC.eq, ← Matrix.mul_assoc, Matrix.mul_assoc (T * D) C C, hCC]

lemma selectedEffect_sum (E : FinitePOVM d o) (c : ℝ) :
    ∑ j, selectedEffect E c j = (canonicalSynthesis E c * sectorRoot E c) *
      (canonicalSynthesis E c * sectorRoot E c)ᴴ := by
  simp only [selectedEffect_factor, ← Matrix.sum_mul, ← Matrix.mul_sum,
    sectorCoordinate_sum, Matrix.mul_one]

theorem canonical_weighted_synthesis_contraction (E : FinitePOVM d o) (c : ℝ) :
    ‖canonicalSynthesis E c * sectorRoot E c‖ ≤ 1 := by
  rw [← canonical_naimark_overlap]
  have hW := isometry_norm_le_one (naimark E) (naimark_isometry E)
  have hJ := isometry_norm_le_one (stack (canonicalBlock E c)) (canonicalFrame E c).isometry
  calc
    _ ≤ ‖(naimark E)ᴴ‖ * ‖stack (canonicalBlock E c)‖ := Matrix.l2_opNorm_mul _ _
    _ ≤ 1 := by rw [Matrix.l2_opNorm_conjTranspose]; nlinarith [norm_nonneg (naimark E)]

theorem canonical_selected_contraction (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    ‖sectorRoot E c * polarRoot (canonicalSynthesis E c)‖ ≤ 1 := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  let D := sectorRoot E c
  have hU := polarIsometry_isometry T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have hfactor : U * H = T := polar_factorization T (Matrix.PosDef.conjTranspose_mul_self T hT)
  have heq : H * D = Uᴴ * (T * D) := by
    rw [← hfactor, Matrix.mul_assoc U H D, ← Matrix.mul_assoc Uᴴ U, hU, Matrix.one_mul]
  have hnU := isometry_norm_le_one U hU
  have hnT := canonical_weighted_synthesis_contraction E c
  have hn : ‖H * D‖ ≤ 1 := by
    rw [heq]
    calc
      _ ≤ ‖Uᴴ‖ * ‖T * D‖ := Matrix.l2_opNorm_mul _ _
      _ ≤ 1 := by rw [Matrix.l2_opNorm_conjTranspose]; nlinarith [norm_nonneg U]
  have hstar : (H * D)ᴴ = D * H := by
    rw [Matrix.conjTranspose_mul, (sectorRoot_positive E c).1.eq, polarRoot_hermitian]
  rw [← hstar, Matrix.l2_opNorm_conjTranspose]
  exact hn

lemma sectorRoot_square_lower (E : FinitePOVM d o) (c : ℝ) :
    (sectorRoot E c * sectorRoot E c - c • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ)).PosSemidef := by
  have heq : sectorRoot E c * sectorRoot E c - c • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) =
      realDiagonal (fun x : SectorIndex E c => (E.positive x.val.1).1.eigenvalues x.val.2 - c) := by
    ext x y
    simp [sectorRoot, realDiagonal, Matrix.diagonal_mul_diagonal, Matrix.diagonal_apply,
      Matrix.one_apply, Complex.real_smul, ← Complex.ofReal_mul,
      Real.mul_self_sqrt (E.positive x.val.1 |>.eigenvalues_nonneg x.val.2)]
    split_ifs <;> simp_all
  rw [heq]
  exact realDiagonal_positive _ (fun x => sub_nonneg.mpr x.property)

theorem canonical_selected_defect_upper (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 ≤ c) [Nonempty (SectorIndex E c)] :
    let H := polarRoot (canonicalSynthesis E c)
    let D := sectorRoot E c
    (H * D * D * H - (packingAlpha (canonicalSynthesis E c) ^ 2 * c) • 1).PosSemidef := by
  dsimp only
  have hp := (sectorRoot_square_lower E c).conjTranspose_mul_mul_same (polarRoot (canonicalSynthesis E c))
  rw [polarRoot_hermitian] at hp
  have hq := (packing_gram_lower (canonicalSynthesis E c)).smul hc
  rw [← polarRoot_square] at hq
  convert hp.add hq using 1
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul,
    Matrix.mul_one, Matrix.mul_assoc, smul_sub, smul_smul]
  module

end RCProof
