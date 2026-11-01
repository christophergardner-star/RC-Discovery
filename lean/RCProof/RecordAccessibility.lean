import RCProof.DiamondWitness

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

def recordChannel (E : FinitePOVM d o) (σ : o → Matrix d d ℂ) : RectMatrixMap d d :=
  ∑ j, prepareMap (E.effect j) (σ j)

lemma recordChannel_apply (E : FinitePOVM d o) (σ : o → Matrix d d ℂ) (X : Matrix d d ℂ) :
    recordChannel E σ X = ∑ j, (E.effect j * X).trace • σ j := by
  simp [recordChannel, prepareMap]

lemma positive_trace_product (A B : Matrix d d ℂ) (hA : A.PosSemidef) (hB : B.PosSemidef) :
    0 ≤ (A * B).trace := by
  have hh := (hB.mul_mul_conjTranspose_same (positiveRoot A hA)).trace_nonneg
  rwa [Matrix.trace_mul_cycle, positiveRoot_gram] at hh

lemma traceNorm_finset_sum (s : Finset o) (V : o → Matrix d d ℂ) :
    traceNorm (∑ j ∈ s, V j) ≤ ∑ j ∈ s, traceNorm (V j) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert j s hj ih =>
    simp only [Finset.sum_insert hj]
    exact (traceNorm_add _ _).trans (add_le_add_right ih _)

theorem weighted_record_reverse_bound (V : o → Matrix d d ℂ) (p : o → ℝ)
    (hp : ∀ j, 0 ≤ p j) (hsum : ∑ j, p j = 1) (j : o)
    (hmax : ∀ i, traceNorm (V i) ≤ traceNorm (V j)) :
    (2 * p j - 1) * traceNorm (V j) ≤ traceNorm (∑ i, p i • V i) := by
  let rest := ∑ i ∈ Finset.univ.erase j, p i • V i
  have hs : (∑ i, p i • V i) = rest + p j • V j :=
    (Finset.sum_erase_add _ _ (Finset.mem_univ j)).symm
  have hrest : traceNorm rest ≤ (1 - p j) * traceNorm (V j) := by
    have hh := traceNorm_finset_sum (Finset.univ.erase j) (fun i => p i • V i)
    have hb : (∑ i ∈ Finset.univ.erase j, traceNorm (p i • V i)) ≤
        ∑ i ∈ Finset.univ.erase j, p i * traceNorm (V j) := by
      apply Finset.sum_le_sum
      intro i _
      rw [traceNorm_real_smul, abs_of_nonneg (hp i)]
      exact mul_le_mul_of_nonneg_left (hmax i) (hp i)
    have hsp : ∑ i ∈ Finset.univ.erase j, p i = 1 - p j := by
      have he := Finset.sum_erase_add Finset.univ p (Finset.mem_univ j)
      rw [hsum] at he
      linarith
    rw [← Finset.sum_mul, hsp] at hb
    exact hh.trans hb
  have ht := traceNorm_add (∑ i, p i • V i) (-rest)
  have heq : (∑ i, p i • V i) + -rest = p j • V j := by rw [hs]; abel
  rw [heq, traceNorm_real_smul, abs_of_nonneg (hp j), traceNorm_neg] at ht
  nlinarith

/-- The lower half of the direct accessibility estimate, at an actual
maximizing residual and an actual accessible density input. No channel norm
bound is supplied as a hypothesis. -/
theorem record_accessibility_lower (E : FinitePOVM d o) (σ : o → Matrix d d ℂ)
    (j : o) (ρ : Matrix d d ℂ) (hρ : ρ.PosSemidef) (htr : ρ.trace = 1)
    (e : ℝ) (haccess : 1 - e ≤ (E.effect j * ρ).trace.re)
    (hmax : ∀ i, traceNorm (recordChannel E σ (σ i) - σ i) ≤
      traceNorm (recordChannel E σ (σ j) - σ j)) :
    ENNReal.ofReal ((1 - 2 * e) * traceNorm (recordChannel E σ (σ j) - σ j)) ≤
      diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) := by
  let Φ := recordChannel E σ
  let V := fun i => Φ (σ i) - σ i
  let p := fun i => (E.effect i * ρ).trace.re
  have hp (i : o) : 0 ≤ p i := (Complex.nonneg_iff.mp (positive_trace_product _ _ (E.positive i) hρ)).1
  have hcast (i : o) : (p i : ℂ) = (E.effect i * ρ).trace := by
    apply Complex.ext
    · rfl
    · exact (Complex.nonneg_iff.mp (positive_trace_product _ _ (E.positive i) hρ)).2
  have hsum : ∑ i, p i = 1 := by
    have hh : ∑ i, (E.effect i * ρ).trace = 1 := by
      rw [← Matrix.trace_sum, ← Matrix.sum_mul, E.normalized, Matrix.one_mul, htr]
    have hh' := congrArg Complex.re hh
    simpa only [Complex.re_sum, Complex.one_re] using hh'
  have hout : (Φ.comp Φ - Φ) ρ = ∑ i, p i • V i := by
    change Φ (Φ ρ) - Φ ρ = _
    rw [recordChannel_apply E σ ρ]
    rw [map_sum]
    simp only [map_smul, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [← smul_sub, ← hcast i]
    rfl
  have hl := weighted_record_reverse_bound V p hp hsum j hmax
  have hl' : (1 - 2 * e) * traceNorm (V j) ≤ traceNorm ((Φ.comp Φ - Φ) ρ) := by
    rw [hout]
    have hm := mul_le_mul_of_nonneg_right (show 1 - 2 * e ≤ 2 * p j - 1 by dsimp [p]; linarith)
      (traceNorm_nonneg (V j))
    exact hm.trans hl
  obtain ⟨K, hK, hk⟩ := traceNorm_attaining_contraction ((Φ.comp Φ - Φ) ρ)
  have hd := diamondSize_ge_state_test (Φ.comp Φ - Φ) ρ hρ htr K hK
  rw [hk] at hd
  exact (ENNReal.ofReal_le_ofReal hl').trans hd

end RCProof
