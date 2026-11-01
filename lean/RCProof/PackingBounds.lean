import RCProof.PackingParameter

/-! Upper synthesis bound derived from the POVM, and its polar consequence. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

lemma threshold_spectral_lower (A : Matrix d d ℂ) (hA : A.PosSemidef) (c : ℝ) :
    (A - c • thresholdProjector A hA.1 c).PosSemidef := by
  have heq : A - c • thresholdProjector A hA.1 c =
      inEigenbasis hA.1.eigenvectorUnitary
        (fun i => hA.1.eigenvalues i - c * (if c ≤ hA.1.eigenvalues i then 1 else 0)) := by
    rw [inEigenbasis_sub, inEigenbasis_smul, ← spectral_representation A hA.1]
    rfl
  rw [heq]
  apply inEigenbasis_positive
  intro i
  split_ifs with hi
  · simpa using sub_nonneg.mpr hi
  · simpa using hA.eigenvalues_nonneg i

lemma canonical_projector_factor (E : FinitePOVM d o) (c : ℝ) (j : o) :
    thresholdProjector (E.effect j) (E.positive j).1 c =
      canonicalSynthesis E c * sectorCoordinate E c j * (canonicalSynthesis E c)ᴴ := by
  have hs : (sectorCoordinate E c j)ᴴ = sectorCoordinate E c j := by
    rw [← canonicalFrame_coordinates]
    exact ((canonicalFrame E c).coordinates.positive j).1.eq
  have hi : sectorCoordinate E c j * sectorCoordinate E c j = sectorCoordinate E c j := by
    simpa only [canonicalFrame_coordinates] using (canonicalFrame E c).coordinate_idempotent j
  rw [← canonicalBlock_full, canonicalBlock_factor, Matrix.conjTranspose_mul, hs]
  calc
    _ = canonicalSynthesis E c * (sectorCoordinate E c j * sectorCoordinate E c j) *
        (canonicalSynthesis E c)ᴴ := by simp only [Matrix.mul_assoc]
    _ = _ := by rw [hi]

lemma canonical_range_gram (E : FinitePOVM d o) (c : ℝ) :
    canonicalSynthesis E c * (canonicalSynthesis E c)ᴴ =
      ∑ j, thresholdProjector (E.effect j) (E.positive j).1 c := by
  simp only [canonical_projector_factor, ← Matrix.sum_mul, ← Matrix.mul_sum,
    sectorCoordinate_sum, Matrix.mul_one]

lemma canonical_synthesis_upper (E : FinitePOVM d o) (c : ℝ) :
    ((1 : Matrix d d ℂ) - c • (canonicalSynthesis E c * (canonicalSynthesis E c)ᴴ)).PosSemidef := by
  have hp := Matrix.posSemidef_sum Finset.univ
    (fun j _ => threshold_spectral_lower (E.effect j) (E.positive j) c)
  simpa only [Finset.sum_sub_distrib, E.normalized, ← Finset.smul_sum,
    ← canonical_range_gram] using hp

lemma canonical_gram_upper (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    (c⁻¹ • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) -
      (canonicalSynthesis E c)ᴴ * canonicalSynthesis E c).PosSemidef := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  have hG := Matrix.PosDef.conjTranspose_mul_self T hT
  have hU : Uᴴ * U = 1 := polarIsometry_isometry T hG
  have hUH : U * H = T := polar_factorization T hG
  have hUT : Uᴴ * T = H := by rw [← hUH, ← Matrix.mul_assoc, hU, Matrix.one_mul]
  have hTU : Tᴴ * U = H := by
    simpa only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      H, polarRoot_hermitian] using congrArg Matrix.conjTranspose hUT
  have hp := (canonical_synthesis_upper E c).conjTranspose_mul_mul_same U
  have heq : Uᴴ * (1 - c • (T * Tᴴ)) * U = 1 - c • (Tᴴ * T) := by
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, Matrix.mul_smul, Matrix.smul_mul, hU]
    have hh : Uᴴ * (T * Tᴴ) * U = Tᴴ * T := by
      calc
        _ = (Uᴴ * T) * (Tᴴ * U) := by simp only [Matrix.mul_assoc]
        _ = _ := by rw [hUT, hTU]; exact polarRoot_square T
    rw [hh]
  change (Uᴴ * (1 - c • (T * Tᴴ)) * U).PosSemidef at hp
  rw [heq] at hp
  have hscaled := hp.smul (inv_nonneg.mpr hc.le)
  simpa only [smul_sub, smul_smul, inv_mul_cancel₀ (ne_of_gt hc), one_smul] using hscaled

theorem canonical_polar_upper (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    ((Real.sqrt c)⁻¹ • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) -
      polarRoot (canonicalSynthesis E c)).PosSemidef := by
  let T := canonicalSynthesis E c
  let h := Matrix.isHermitian_conjTranspose_mul_self T
  have heq : (Real.sqrt c)⁻¹ • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) - polarRoot T =
      inEigenbasis h.eigenvectorUnitary (fun i => (Real.sqrt c)⁻¹ - Real.sqrt (h.eigenvalues i)) := by
    rw [inEigenbasis_sub, inEigenbasis_const]
    rfl
  rw [heq]
  apply inEigenbasis_positive
  intro i
  have hu := eigenvalues_le_of_upper (Tᴴ * T) h c⁻¹ (canonical_gram_upper E c hc hT) i
  have hs := Real.sqrt_le_sqrt hu
  rw [Real.sqrt_inv] at hs
  exact sub_nonneg.mpr hs

end RCProof
