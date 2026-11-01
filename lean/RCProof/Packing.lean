import RCProof.CanonicalFrame
import RCProof.Jordan

/-! Quantitative spectral bounds and the canonical labelled overlap. -/
namespace RCProof
open Matrix Unitary
open scoped ComplexOrder
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

noncomputable def sectorRoot (E : FinitePOVM d o) (c : ℝ) :
    Matrix (SectorIndex E c) (SectorIndex E c) ℂ :=
  realDiagonal (fun x => Real.sqrt ((E.positive x.val.1).1.eigenvalues x.val.2))

lemma sectorRoot_positive (E : FinitePOVM d o) (c : ℝ) : (sectorRoot E c).PosSemidef :=
  realDiagonal_positive _ (fun _ => Real.sqrt_nonneg _)

lemma sectorRoot_lower (E : FinitePOVM d o) (c : ℝ) :
    (sectorRoot E c - Real.sqrt c • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ)).PosSemidef := by
  have heq : sectorRoot E c - Real.sqrt c • (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) =
      realDiagonal (fun x => Real.sqrt ((E.positive x.val.1).1.eigenvalues x.val.2) - Real.sqrt c) := by
    ext x y
    simp [sectorRoot, realDiagonal, Matrix.diagonal_apply, Matrix.one_apply, Complex.real_smul]
    split_ifs <;> simp
  rw [heq]
  apply realDiagonal_positive
  intro x
  exact sub_nonneg.mpr (Real.sqrt_le_sqrt x.property)

lemma sectorRoot_upper (E : FinitePOVM d o) (c : ℝ) :
    ((1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) - sectorRoot E c).PosSemidef := by
  have heq : (1 : Matrix (SectorIndex E c) (SectorIndex E c) ℂ) - sectorRoot E c =
      realDiagonal (fun x => 1 - Real.sqrt ((E.positive x.val.1).1.eigenvalues x.val.2)) := by
    ext x y
    simp [sectorRoot, realDiagonal, Matrix.diagonal_apply, Matrix.one_apply]
    split_ifs <;> simp
  rw [heq]
  apply realDiagonal_positive
  intro x
  have hu := eigenvalues_le_of_upper (E.effect x.val.1) (E.positive x.val.1).1 1
    (by simpa using E.effect_le_one x.val.1) x.val.2
  have hsqrt := Real.sqrt_le_sqrt hu
  simpa using sub_nonneg.mpr hsqrt

lemma positiveRoot_mul_eigenbasis (A : Matrix d d ℂ) (hA : A.PosSemidef) :
    positiveRoot A hA * (hA.1.eigenvectorUnitary : Matrix d d ℂ) =
      (hA.1.eigenvectorUnitary : Matrix d d ℂ) *
        realDiagonal (fun i => Real.sqrt (hA.1.eigenvalues i)) := by
  unfold positiveRoot inEigenbasis
  rw [Unitary.conjStarAlgAut_apply, Matrix.mul_assoc, Matrix.mul_assoc,
    Unitary.coe_star_mul_self, Matrix.mul_one]

lemma canonicalBlock_root_action (E : FinitePOVM d o) (c : ℝ) (j : o) :
    positiveRoot (E.effect j) (E.positive j) * canonicalBlock E c j =
      canonicalBlock E c j * sectorRoot E c := by
  ext a x
  by_cases hx : x.val.1 = j
  · have hh := congrArg (fun A : Matrix d d ℂ => A a x.val.2)
      (positiveRoot_mul_eigenbasis (E.effect j) (E.positive j))
    simpa [canonicalBlock, canonicalSynthesis, sectorRoot, realDiagonal,
      Matrix.mul_apply, Matrix.diagonal_apply, hx] using hh
  · simp [canonicalBlock, sectorRoot, realDiagonal, Matrix.mul_apply,
      Matrix.diagonal_apply, hx]

lemma canonicalBlock_sum (E : FinitePOVM d o) (c : ℝ) :
    ∑ j, canonicalBlock E c j = canonicalSynthesis E c := by
  ext a x
  simp [canonicalBlock, Matrix.sum_apply]

theorem canonical_naimark_overlap (E : FinitePOVM d o) (c : ℝ) :
    (naimark E)ᴴ * stack (canonicalBlock E c) = canonicalSynthesis E c * sectorRoot E c := by
  rw [naimark, stack_cross]
  simp only [(positiveRoot_positive _ _).1.eq]
  simp only [canonicalBlock_root_action, ← Matrix.sum_mul, canonicalBlock_sum]

theorem canonical_polar_overlap (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    (naimark E)ᴴ * stack (canonicalBlock E c) =
      polarIsometry (canonicalSynthesis E c) * polarRoot (canonicalSynthesis E c) * sectorRoot E c := by
  rw [polar_factorization _ (Matrix.PosDef.conjTranspose_mul_self _ hT), canonical_naimark_overlap]

end RCProof
