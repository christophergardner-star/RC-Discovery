import RCProof.Assembly

/-! Construct the direct sum of all threshold eigenspaces. Its index type
retains every selected eigenvector with its original outcome label. -/
namespace RCProof
open Matrix Unitary
open scoped ComplexOrder
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

abbrev SectorIndex (E : FinitePOVM d o) (c : ℝ) :=
  {x : o × d // c ≤ (E.positive x.1).1.eigenvalues x.2}

noncomputable instance sectorIndexFintype (E : FinitePOVM d o) (c : ℝ) :
    Fintype (SectorIndex E c) := Fintype.ofFinite _

noncomputable def canonicalSynthesis (E : FinitePOVM d o) (c : ℝ) :
    Matrix d (SectorIndex E c) ℂ :=
  fun a x => (E.positive x.val.1).1.eigenvectorUnitary a x.val.2

def sectorCoordinate (E : FinitePOVM d o) (c : ℝ) (j : o) :
    Matrix (SectorIndex E c) (SectorIndex E c) ℂ :=
  Matrix.diagonal (fun x => if x.val.1 = j then 1 else 0)

noncomputable def canonicalBlock (E : FinitePOVM d o) (c : ℝ) (j : o) :
    Matrix d (SectorIndex E c) ℂ :=
  fun a x => if x.val.1 = j then canonicalSynthesis E c a x else 0

lemma canonicalBlock_factor (E : FinitePOVM d o) (c : ℝ) (j : o) :
    canonicalBlock E c j = canonicalSynthesis E c * sectorCoordinate E c j := by
  ext a x
  simp [canonicalBlock, sectorCoordinate, Matrix.mul_diagonal]

lemma canonicalBlock_gram (E : FinitePOVM d o) (c : ℝ) (j : o) :
    (canonicalBlock E c j)ᴴ * canonicalBlock E c j = sectorCoordinate E c j := by
  ext x y
  by_cases hx : x.val.1 = j
  · by_cases hy : y.val.1 = j
    · have hxy : x = y ↔ x.val.2 = y.val.2 := by
        constructor
        · intro h; rw [h]
        · intro h
          apply Subtype.ext
          exact Prod.ext (hx.trans hy.symm) h
      have hu := congrArg (fun A : Matrix d d ℂ => A x.val.2 y.val.2)
        (Unitary.coe_star_mul_self (E.positive j).1.eigenvectorUnitary)
      simpa [canonicalBlock, canonicalSynthesis, sectorCoordinate, Matrix.mul_apply,
        Matrix.conjTranspose_apply, Matrix.diagonal_apply, Matrix.one_apply, hx, hy, hxy] using hu
    · have hxy : x ≠ y := by intro h; apply hy; rw [← h]; exact hx
      simp [canonicalBlock, sectorCoordinate, Matrix.mul_apply, Matrix.conjTranspose_apply,
        Matrix.diagonal_apply, hx, hy, hxy]
  · by_cases hxy : x = y
    · subst y
      simp [canonicalBlock, sectorCoordinate, Matrix.mul_apply, Matrix.conjTranspose_apply,
        Matrix.diagonal_apply, hx]
    · simp [canonicalBlock, sectorCoordinate, Matrix.mul_apply, Matrix.conjTranspose_apply,
        Matrix.diagonal_apply, hx, hxy]

lemma sectorCoordinate_sum (E : FinitePOVM d o) (c : ℝ) :
    ∑ j, sectorCoordinate E c j = 1 := by
  ext x y
  simp [sectorCoordinate, Matrix.sum_apply, Matrix.diagonal_apply, Matrix.one_apply]

lemma sectorIndex_sum (E : FinitePOVM d o) (c : ℝ) (f : o × d → ℂ) :
    ∑ x : SectorIndex E c, f x.val =
      ∑ x : o × d, if c ≤ (E.positive x.1).1.eigenvalues x.2 then f x else 0 := by
  classical
  rw [← Finset.sum_subtype (Finset.univ.filter
    (fun x : o × d => c ≤ (E.positive x.1).1.eigenvalues x.2)) (by simp) f]
  rw [Finset.sum_filter]

lemma canonicalBlock_full (E : FinitePOVM d o) (c : ℝ) (j : o) :
    canonicalBlock E c j * (canonicalBlock E c j)ᴴ =
      thresholdProjector (E.effect j) (E.positive j).1 c := by
  classical
  ext a b
  change (∑ x : SectorIndex E c,
    (if x.val.1 = j then (E.positive x.val.1).1.eigenvectorUnitary a x.val.2 else 0) *
    star (if x.val.1 = j then (E.positive x.val.1).1.eigenvectorUnitary b x.val.2 else 0)) = _
  rw [sectorIndex_sum E c (fun x : o × d =>
    (if x.1 = j then (E.positive x.1).1.eigenvectorUnitary a x.2 else 0) *
      star (if x.1 = j then (E.positive x.1).1.eigenvectorUnitary b x.2 else 0)),
    Fintype.sum_prod_type]
  rw [Finset.sum_eq_single j]
  · simp [thresholdProjector, inEigenbasis, realDiagonal, Unitary.conjStarAlgAut_apply,
      Matrix.mul_diagonal, Matrix.mul_apply, Matrix.diagonal_apply, Matrix.conjTranspose_apply, apply_ite,
      mul_ite, ite_mul]
  · intro i _ hij
    simp [hij]
  · simp

lemma canonicalBlock_supported (E : FinitePOVM d o) (c : ℝ) (j : o) :
    thresholdProjector (E.effect j) (E.positive j).1 c * canonicalBlock E c j =
      canonicalBlock E c j := by
  rw [← canonicalBlock_full, Matrix.mul_assoc, canonicalBlock_gram]
  ext a x
  simp [sectorCoordinate, Matrix.mul_diagonal, canonicalBlock]
  aesop

noncomputable def canonicalFrame (E : FinitePOVM d o) (c : ℝ) :
    SpectralFrame E c (SectorIndex E c) where
  block := canonicalBlock E c
  supported := canonicalBlock_supported E c
  full := canonicalBlock_full E c
  normalized := by simp only [canonicalBlock_gram]; exact sectorCoordinate_sum E c

lemma canonicalFrame_coordinates (E : FinitePOVM d o) (c : ℝ) (j : o) :
    (canonicalFrame E c).coordinates.effect j = sectorCoordinate E c j :=
  canonicalBlock_gram E c j

/-- The hybrid dilation now starts from the POVM and its canonical synthesis
matrix; no spectral-frame existence or coordinate-factorization input remains. -/
theorem canonical_hybrid_dilation (E : FinitePOVM d o) (c : ℝ)
    (hT : ((canonicalSynthesis E c)ᴴ * canonicalSynthesis E c).PosDef) :
    let U := polarIsometry (canonicalSynthesis E c)
    let V := stack (canonicalBlock E c) * Uᴴ + naimark E * (1 - U * Uᴴ)
    Vᴴ * V = 1 ∧ ∀ j, Vᴴ * labelProjection j * V =
      completedEffect U (sectorCoordinate E c j) (E.effect j) := by
  have h := (canonicalFrame E c).hybrid_dilation_from_polar (canonicalSynthesis E c) hT
    (fun j => by rw [canonicalFrame_coordinates]; exact canonicalBlock_factor E c j)
  dsimp only [canonicalFrame, SpectralFrame.coordinates] at h
  simpa only [canonicalBlock_gram] using h

theorem canonical_hybrid_dilation_of_injective (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) :
    let U := polarIsometry (canonicalSynthesis E c)
    let V := stack (canonicalBlock E c) * Uᴴ + naimark E * (1 - U * Uᴴ)
    Vᴴ * V = 1 ∧ ∀ j, Vᴴ * labelProjection j * V =
      completedEffect U (sectorCoordinate E c j) (E.effect j) :=
  canonical_hybrid_dilation E c (Matrix.PosDef.conjTranspose_mul_self _ hT)

theorem sectorIndex_nonempty (E : FinitePOVM d o) (c : ℝ) [Nonempty d]
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0) :
    Nonempty (SectorIndex E c) := by
  classical
  by_contra hn
  letI : IsEmpty (SectorIndex E c) := ⟨fun x => hn ⟨x⟩⟩
  have hP : ∀ j, thresholdProjector (E.effect j) (E.positive j).1 c = 0 := by
    intro j
    rw [← canonicalBlock_full]
    ext a b
    simp [Matrix.mul_apply]
  have hE : ∀ j, E.effect j = 0 := by
    intro j
    by_contra hne
    exact hsector j hne (hP j)
  have hi : (1 : Matrix d d ℂ) = 0 := by
    rw [← E.normalized]
    simp only [hE, Finset.sum_const_zero]
  exact one_ne_zero hi

end RCProof
