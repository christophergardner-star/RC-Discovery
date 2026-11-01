import RCProof.DiamondWitness

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Kronecker
variable {d b q r o : Type*} [Fintype d] [Fintype b] [Fintype q] [Fintype r] [Fintype o]
  [DecidableEq d] [DecidableEq b] [DecidableEq q] [DecidableEq r] [DecidableEq o]

theorem traceNorm_two_kraus_bound (A C : q → Matrix b d ℂ) (B : ℝ) (hB : 0 ≤ B)
    (hgram : (B • (1 : Matrix d d ℂ) - ((∑ i, (A i)ᴴ * A i) + ∑ i, (C i)ᴴ * C i)).PosSemidef)
    (X : Matrix d d ℂ) : traceNorm (rectKrausMap A X - rectKrausMap C X) ≤ B * traceNorm X := by
  have hh := traceNorm_three_kraus_bound A C (fun _ : Fin 0 => (0 : Matrix b d ℂ)) B hB
    (by simpa using hgram) X
  simpa [rectKrausMap] using hh

theorem two_kraus_bound_ancilla (A C : q → Matrix b d ℂ) (B : ℝ) (hB : 0 ≤ B)
    (hgram : (B • (1 : Matrix d d ℂ) - ((∑ i, (A i)ᴴ * A i) + ∑ i, (C i)ᴴ * C i)).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (rectKrausMap A - rectKrausMap C) X) ≤ B * traceNorm X := by
  let L : q ⊕ q → Matrix b d ℂ := Sum.elim A C
  have hL := tensor_kraus_gram_bound (r := r) L B (by
    simpa only [L, Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr] using hgram)
  simp only [L, Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr] at hL
  have hh := traceNorm_two_kraus_bound (fun i => A i ⊗ₖ (1 : Matrix r r ℂ))
    (fun i => C i ⊗ₖ (1 : Matrix r r ℂ)) B hB hL X
  change traceNorm (amplifyRect (rectKrausMap A) X - amplifyRect (rectKrausMap C) X) ≤ _
  rw [amplifyRect_kraus, amplifyRect_kraus]
  exact hh

theorem positive_effect_difference_bound (P M : o → Matrix d d ℂ)
    (hP : ∀ j, (P j).PosSemidef) (hM : ∀ j, (M j).PosSemidef)
    (B : ℝ) (hB : 0 ≤ B) (hsum : (B • (1 : Matrix d d ℂ) - ∑ j, (P j + M j)).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap P - effectMap M) X) ≤ B * traceNorm X := by
  let A := fun p : o × d => readoutKraus p * stack (fun j => positiveRoot (P j) (hP j))
  let C := fun p : o × d => readoutKraus p * stack (fun j => positiveRoot (M j) (hM j))
  have hgram : (B • (1 : Matrix d d ℂ) - ((∑ i, (A i)ᴴ * A i) + ∑ i, (C i)ᴴ * C i)).PosSemidef := by
    dsimp only [A, C]
    simp only [readout_composition_gram, stack_gram, positiveRoot_gram]
    simpa only [Finset.sum_add_distrib] using hsum
  rw [positive_effectMap_kraus P hP, positive_effectMap_kraus M hM]
  exact two_kraus_bound_ancilla A C B hB hgram X

/-- Soundness of a measurement diamond dual certificate. All positivity
conditions are actual matrix inequalities, and the conclusion covers all
complex inputs and arbitrary finite ancillas. -/
theorem measurement_dual_certificate_all_inputs (D Y : o → Matrix d d ℂ)
    (hplus : ∀ j, (Y j + D j).PosSemidef) (hminus : ∀ j, (Y j - D j).PosSemidef)
    (B : ℝ) (hB : 0 ≤ B) (hsum : (B • (1 : Matrix d d ℂ) - ∑ j, Y j).PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (effectMap D) X) ≤ B * traceNorm X := by
  let P := fun j => (1 / 2 : ℝ) • (Y j + D j)
  let M := fun j => (1 / 2 : ℝ) • (Y j - D j)
  have hPM : (fun j => P j + M j) = Y := by funext j; dsimp [P, M]; module
  have hdiff : (fun j => P j - M j) = D := by funext j; dsimp [P, M]; module
  have hh := positive_effect_difference_bound P M
    (fun j => (hplus j).smul (show (0 : ℝ) ≤ 1 / 2 by norm_num))
    (fun j => (hminus j).smul (show (0 : ℝ) ≤ 1 / 2 by norm_num))
    B hB (by simpa only [hPM] using hsum) X
  rw [← effectMap_sub, hdiff] at hh
  exact hh

theorem measurement_dual_certificate (D Y : o → Matrix d d ℂ)
    (hplus : ∀ j, (Y j + D j).PosSemidef) (hminus : ∀ j, (Y j - D j).PosSemidef)
    (B : ℝ) (hB : 0 ≤ B) (hsum : (B • (1 : Matrix d d ℂ) - ∑ j, Y j).PosSemidef) :
    diamondSize (effectMap D) ≤ ENNReal.ofReal B := by
  apply diamondSize_le_of_all_inputs
  intro n X hX
  have hh := measurement_dual_certificate_all_inputs D Y hplus hminus B hB hsum X
  exact hh.trans (by nlinarith)

end RCProof
