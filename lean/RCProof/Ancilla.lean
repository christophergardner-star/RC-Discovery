import RCProof.PackingBounds
import RCProof.CanonicalInstrument

/-! The measurement-specific overlap bound and its arbitrary-reference lift.
This is an operator inequality; a trace-norm/diamond-norm theorem is separate. -/
namespace RCProof
open Matrix
open scoped ComplexOrder Kronecker
variable {d k y r : Type*} [Fintype d] [Fintype k] [Fintype y] [Fintype r]
  [DecidableEq d] [DecidableEq k] [DecidableEq y] [DecidableEq r]

noncomputable def realPart (A : Matrix d d ℂ) : Matrix d d ℂ := (1 / 2 : ℝ) • (A + Aᴴ)

lemma hybrid_overlap_identity (U : Matrix d k ℂ) (J : Matrix y k ℂ)
    (W : Matrix y d ℂ) (H D : Matrix k k ℂ)
    (hW : Wᴴ * W = 1) (hoverlap : Wᴴ * J = U * H * D) :
    Wᴴ * (J * Uᴴ + W * (1 - U * Uᴴ)) =
      U * H * D * Uᴴ + (1 - U * Uᴴ) := by
  rw [Matrix.mul_add, ← Matrix.mul_assoc Wᴴ J, hoverlap,
    ← Matrix.mul_assoc Wᴴ W, hW, Matrix.one_mul]

lemma lifted_overlap_floor (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (H D : Matrix k k ℂ) (hH : Hᴴ = H) (hD : Dᴴ = D) (η : ℝ) (hη : η ≤ 1)
    (hfloor : (realPart (H * D) - η • (1 : Matrix k k ℂ)).PosSemidef) :
    (realPart (U * H * D * Uᴴ + (1 - U * Uᴴ)) - η • (1 : Matrix d d ℂ)).PosSemidef := by
  have hp := hfloor.mul_mul_conjTranspose_same U
  have hr := (residual_projection_properties U hU).2.2.smul (sub_nonneg.mpr hη)
  have hall := hp.add hr
  convert hall using 1
  simp only [realPart, Matrix.conjTranspose_add, Matrix.conjTranspose_sub,
    Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, Matrix.conjTranspose_one,
    hH, hD, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_add, Matrix.add_mul,
    Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one, Matrix.one_mul,
    Matrix.mul_assoc, smul_add, smul_sub, smul_smul]
  module

lemma tensor_isometry (A : Matrix y d ℂ) (hA : Aᴴ * A = 1) :
    (A ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (A ⊗ₖ (1 : Matrix r r ℂ)) = 1 := by
  rw [Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul, hA]
  simp

theorem tensor_overlap_floor (W V : Matrix y d ℂ) (η : ℝ)
    (hf : (realPart (Wᴴ * V) - η • (1 : Matrix d d ℂ)).PosSemidef) :
    (realPart ((W ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (V ⊗ₖ (1 : Matrix r r ℂ))) -
      η • (1 : Matrix (d × r) (d × r) ℂ)).PosSemidef := by
  have hp := hf.kronecker (Matrix.PosSemidef.one : (1 : Matrix r r ℂ).PosSemidef)
  convert hp using 1
  simp [realPart, Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul,
    sub_eq_add_neg, Matrix.add_kronecker, Matrix.smul_kronecker]
  simp only [← neg_smul, Matrix.smul_kronecker, Matrix.one_kronecker_one]

variable {o : Type*} [Fintype o] [DecidableEq o]

theorem canonical_jordan_floor (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c ≤ 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hwidth : ((Real.sqrt c)⁻¹ - packingAlpha (canonicalSynthesis E c)) * (1 - Real.sqrt c) ≤
      4 * packingAlpha (canonicalSynthesis E c) * Real.sqrt c) :
    (realPart (polarRoot (canonicalSynthesis E c) * sectorRoot E c) -
      (packingAlpha (canonicalSynthesis E c) * Real.sqrt c) •
        (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ)).PosSemidef := by
  have hs : 0 < Real.sqrt c := Real.sqrt_pos.mpr hc
  have hs1 : Real.sqrt c ≤ 1 := by simpa using Real.sqrt_le_sqrt hc1
  have hM : packingAlpha (canonicalSynthesis E c) ≤ (Real.sqrt c)⁻¹ :=
    (canonical_packing_le_one E c).trans ((one_le_inv₀ hs).mpr hs1)
  have hj := jordan_lower_of_width (polarRoot (canonicalSynthesis E c)) (sectorRoot E c)
    (packingAlpha (canonicalSynthesis E c)) (Real.sqrt c) (Real.sqrt c)⁻¹
    (Real.sqrt_nonneg _) hs hM (packing_polar_lower _) (sectorRoot_lower E c)
    (canonical_polar_upper E c hc hT) (sectorRoot_upper E c) hwidth
  simpa only [realPart, Matrix.conjTranspose_mul, polarRoot_hermitian,
    (sectorRoot_positive E c).1.eq] using hj

theorem canonical_hybrid_overlap_floor (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c ≤ 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hwidth : ((Real.sqrt c)⁻¹ - packingAlpha (canonicalSynthesis E c)) * (1 - Real.sqrt c) ≤
      4 * packingAlpha (canonicalSynthesis E c) * Real.sqrt c) :
    let U := polarIsometry (canonicalSynthesis E c)
    let V := stack (canonicalBlock E c) * Uᴴ + naimark E * (1 - U * Uᴴ)
    (realPart ((naimark E)ᴴ * V) -
      (packingAlpha (canonicalSynthesis E c) * Real.sqrt c) • (1 : Matrix d d ℂ)).PosSemidef := by
  dsimp only
  rw [hybrid_overlap_identity _ _ _ _ _ (naimark_isometry E) (canonical_polar_overlap E c hT)]
  apply lifted_overlap_floor _ (polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT))
    _ _ (polarRoot_hermitian _) (sectorRoot_positive E c).1.eq
  · exact mul_le_one₀ (canonical_packing_le_one E c) (Real.sqrt_nonneg _) (by simpa using Real.sqrt_le_sqrt hc1)
  · exact canonical_jordan_floor E c hc hc1 hT hwidth

/-- The derived overlap floor survives every finite reference system. -/
theorem canonical_ancilla_overlap_floor (E : FinitePOVM d o) (c : ℝ) (hc : 0 < c) (hc1 : c ≤ 1)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hwidth : ((Real.sqrt c)⁻¹ - packingAlpha (canonicalSynthesis E c)) * (1 - Real.sqrt c) ≤
      4 * packingAlpha (canonicalSynthesis E c) * Real.sqrt c) :
    let U := polarIsometry (canonicalSynthesis E c)
    let V := stack (canonicalBlock E c) * Uᴴ + naimark E * (1 - U * Uᴴ)
    (realPart (((naimark E) ⊗ₖ (1 : Matrix r r ℂ))ᴴ * (V ⊗ₖ (1 : Matrix r r ℂ))) -
      (packingAlpha (canonicalSynthesis E c) * Real.sqrt c) •
        (1 : Matrix (d × r) (d × r) ℂ)).PosSemidef :=
  tensor_overlap_floor _ _ _ (canonical_hybrid_overlap_floor E c hc hc1 hT hwidth)

end RCProof
