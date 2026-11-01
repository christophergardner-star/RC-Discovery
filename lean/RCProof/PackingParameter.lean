import RCProof.Packing

/-! The packing parameter is the square root of the least Gram eigenvalue.
This definition also applies to singular matrices; positivity is proved from
injectivity. The empty-domain case is excluded only for taking a minimum. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

noncomputable def packingEigenvalue [Nonempty k] (T : Matrix d k ℂ) : ℝ :=
  Finset.univ.inf' Finset.univ_nonempty (Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues

noncomputable def packingAlpha [Nonempty k] (T : Matrix d k ℂ) : ℝ :=
  Real.sqrt (packingEigenvalue T)

lemma packingEigenvalue_le [Nonempty k] (T : Matrix d k ℂ) (i : k) :
    packingEigenvalue T ≤ (Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues i :=
  Finset.inf'_le _ (Finset.mem_univ i)

lemma packingEigenvalue_nonneg [Nonempty k] (T : Matrix d k ℂ) :
    0 ≤ packingEigenvalue T := by
  apply Finset.le_inf'
  intro i _
  exact (Matrix.posSemidef_conjTranspose_mul_self T).eigenvalues_nonneg i

lemma packingAlpha_sq [Nonempty k] (T : Matrix d k ℂ) :
    packingAlpha T ^ 2 = packingEigenvalue T :=
  Real.sq_sqrt (packingEigenvalue_nonneg T)

lemma packingAlpha_pos [Nonempty k] (T : Matrix d k ℂ) (hT : Function.Injective T.mulVec) :
    0 < packingAlpha T := by
  apply Real.sqrt_pos.mpr
  rw [packingEigenvalue, Finset.lt_inf'_iff]
  intro i _
  exact (Matrix.PosDef.conjTranspose_mul_self T hT).eigenvalues_pos i

lemma packing_gram_lower [Nonempty k] (T : Matrix d k ℂ) :
    (Tᴴ * T - packingAlpha T ^ 2 • (1 : Matrix k k ℂ)).PosSemidef := by
  have h := Matrix.isHermitian_conjTranspose_mul_self T
  have heq : Tᴴ * T - packingAlpha T ^ 2 • (1 : Matrix k k ℂ) =
      inEigenbasis h.eigenvectorUnitary (fun i => h.eigenvalues i - packingAlpha T ^ 2) := by
    rw [inEigenbasis_sub, inEigenbasis_const, ← spectral_representation _ h]
  rw [heq]
  apply inEigenbasis_positive
  intro i
  rw [packingAlpha_sq]
  exact sub_nonneg.mpr (packingEigenvalue_le T i)

lemma packing_polar_lower [Nonempty k] (T : Matrix d k ℂ) :
    (polarRoot T - packingAlpha T • (1 : Matrix k k ℂ)).PosSemidef := by
  have heq : polarRoot T - packingAlpha T • (1 : Matrix k k ℂ) =
      inEigenbasis (Matrix.isHermitian_conjTranspose_mul_self T).eigenvectorUnitary
        (fun i => Real.sqrt ((Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues i) - packingAlpha T) := by
    rw [inEigenbasis_sub, inEigenbasis_const]
    rfl
  rw [heq]
  apply inEigenbasis_positive
  intro i
  exact sub_nonneg.mpr (Real.sqrt_le_sqrt (packingEigenvalue_le T i))

variable {o : Type*} [Fintype o] [DecidableEq o]

lemma canonicalSynthesis_gram_diag (E : FinitePOVM d o) (c : ℝ) (x : SectorIndex E c) :
    ((canonicalSynthesis E c)ᴴ * canonicalSynthesis E c) x x = 1 := by
  have hu := congrArg (fun A : Matrix d d ℂ => A x.val.2 x.val.2)
    (Unitary.coe_star_mul_self (E.positive x.val.1).1.eigenvectorUnitary)
  simpa [canonicalSynthesis, Matrix.mul_apply, Matrix.conjTranspose_apply] using hu

lemma canonical_packing_le_one (E : FinitePOVM d o) (c : ℝ) [Nonempty (SectorIndex E c)] :
    packingAlpha (canonicalSynthesis E c) ≤ 1 := by
  let x : SectorIndex E c := Classical.choice inferInstance
  have hd := (packing_gram_lower (canonicalSynthesis E c)).diag_nonneg (i := x)
  have hr := (Complex.nonneg_iff.mp hd).1
  simp only [Matrix.sub_apply, Matrix.smul_apply, canonicalSynthesis_gram_diag,
    Matrix.one_apply_eq, Complex.real_smul, mul_one, Complex.sub_re,
    Complex.one_re, Complex.ofReal_re] at hr
  have hs : packingAlpha (canonicalSynthesis E c) ^ 2 ≤ 1 := by linarith
  nlinarith [Real.sqrt_nonneg (packingEigenvalue (canonicalSynthesis E c))]

end RCProof
