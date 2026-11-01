import RCProof.PerfectMeasurement

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k o : Type*} [Fintype d] [Fintype k] [Fintype o]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]

lemma isometry_mulVec_injective (T : Matrix d k ℂ) (hT : Tᴴ * T = 1) :
    Function.Injective T.mulVec := by
  intro x y hxy
  have hh := congrArg (fun z => Tᴴ *ᵥ z) hxy
  simpa only [Matrix.mulVec_mulVec, hT, Matrix.one_mulVec] using hh

lemma packingAlpha_isometry [Nonempty k] (T : Matrix d k ℂ) (hT : Tᴴ * T = 1) :
    packingAlpha T = 1 := by
  have heig (i : k) : (Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues i = 1 := by
    have hh := (Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues_mem_spectrum_real i
    have hspec := congrArg (fun A : Matrix k k ℂ => spectrum ℝ A) hT
    rw [hspec] at hh
    simpa using hh
  simp [packingAlpha, packingEigenvalue, heig]

lemma canonicalSynthesis_eq_sum_blocks (E : FinitePOVM d o) (c : ℝ) :
    canonicalSynthesis E c = ∑ j, canonicalBlock E c j := by
  ext i x
  simp [Matrix.sum_apply, canonicalBlock]

theorem orthogonal_sectors_synthesis_isometry (E : FinitePOVM d o) (c : ℝ)
    (horth : ∀ i j, i ≠ j →
      thresholdProjector (E.effect i) (E.positive i).1 c *
        thresholdProjector (E.effect j) (E.positive j).1 c = 0) :
    (canonicalSynthesis E c)ᴴ * canonicalSynthesis E c = 1 := by
  let P := fun j => thresholdProjector (E.effect j) (E.positive j).1 c
  let B := canonicalBlock E c
  have hcross (i j : o) : (B i)ᴴ * B j = if i = j then sectorCoordinate E c i else 0 := by
    by_cases hij : i = j
    · subst j
      simpa using canonicalBlock_gram E c i
    · rw [if_neg hij]
      have hleft : (B i)ᴴ * P i = (B i)ᴴ := by
        have hh := congrArg Matrix.conjTranspose (canonicalBlock_supported E c i)
        simpa only [Matrix.conjTranspose_mul, (thresholdProjector_positive (E.effect i) (E.positive i).1 c).1.eq] using hh
      have hright : P j * B j = B j := canonicalBlock_supported E c j
      calc
        _ = (B i)ᴴ * (P i * P j) * B j := by
          rw [← Matrix.mul_assoc, hleft, Matrix.mul_assoc, hright]
        _ = 0 := by rw [horth i j hij, Matrix.mul_zero, Matrix.zero_mul]
  rw [canonicalSynthesis_eq_sum_blocks]
  simp only [Matrix.conjTranspose_sum, Matrix.sum_mul, Matrix.mul_sum]
  change (∑ x, ∑ a, (B a)ᴴ * B x) = 1
  simpa only [hcross, Finset.sum_ite_eq', Finset.mem_univ, if_true] using sectorCoordinate_sum E c

lemma canonical_sectorProjection_sum (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) :
    ∑ j, sectorProjection E c U j = U * Uᴴ := by
  simp only [sectorProjection, ← Matrix.sum_mul, ← Matrix.mul_sum, sectorCoordinate_sum, Matrix.mul_one]

end RCProof
