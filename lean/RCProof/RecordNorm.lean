import RCProof.RecordAccessibility
import RCProof.MeasurementCertificate

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o r : Type*} [Fintype d] [Fintype o] [Fintype r]
  [DecidableEq d] [DecidableEq o] [DecidableEq r]

lemma prepareKraus_gram (L B : Matrix d d ℂ) :
    (∑ p, (prepareKraus L B p)ᴴ * prepareKraus L B p) = (L * Lᴴ).trace • (Bᴴ * B) := by
  apply Matrix.ext_iff_trace_mul_right.mpr
  intro X
  have hh := congrArg Matrix.trace (prepareKraus_sum L B X)
  change (∑ p, prepareKraus L B p * X * (prepareKraus L B p)ᴴ).trace = _ at hh
  rw [Matrix.trace_sum, Matrix.trace_smul, Matrix.trace_mul_cycle] at hh
  rw [Matrix.sum_mul, Matrix.trace_sum, Matrix.smul_mul, Matrix.trace_smul]
  have hcycle (p : d × d) : (((prepareKraus L B p)ᴴ * prepareKraus L B p) * X).trace =
      (prepareKraus L B p * X * (prepareKraus L B p)ᴴ).trace := by
    exact (Matrix.trace_mul_cycle (prepareKraus L B p) X (prepareKraus L B p)ᴴ).symm
  simp only [hcycle]
  exact hh.trans (mul_comm _ _)

lemma positive_trace_real (A : Matrix d d ℂ) (hA : A.PosSemidef) : (A.trace.re : ℂ) = A.trace := by
  apply Complex.ext
  · rfl
  · exact (Complex.nonneg_iff.mp hA.trace_nonneg).2

lemma prepare_positive_gram (E P : Matrix d d ℂ) (hE : E.PosSemidef) (hP : P.PosSemidef) :
    (∑ p, (prepareKraus (positiveRoot P hP) (positiveRoot E hE) p)ᴴ *
      prepareKraus (positiveRoot P hP) (positiveRoot E hE) p) = P.trace.re • E := by
  rw [prepareKraus_gram, (positiveRoot_positive P hP).1.eq, positiveRoot_square, positiveRoot_gram]
  rw [← positive_trace_real P hP]
  rfl

lemma recordChannel_eq_kraus (E : FinitePOVM d o) (P : o → Matrix d d ℂ)
    (hP : ∀ j, (P j).PosSemidef) :
    recordChannel E P = rectKrausMap (fun p : o × (d × d) =>
      prepareKraus (positiveRoot (P p.1) (hP p.1)) (positiveRoot (E.effect p.1) (E.positive p.1)) p.2) := by
  apply LinearMap.ext
  intro X
  change (∑ j, prepareMap (E.effect j) (P j)) X = _
  simp only [LinearMap.sum_apply, prepareMap_eq_kraus _ _ (E.positive _) (hP _)]
  change (∑ j, ∑ p, prepareKraus _ _ p * X * (prepareKraus _ _ p)ᴴ) = _
  change (∑ j, ∑ p, prepareKraus (positiveRoot (P j) (hP j))
    (positiveRoot (E.effect j) (E.positive j)) p * X *
    (prepareKraus (positiveRoot (P j) (hP j)) (positiveRoot (E.effect j) (E.positive j)) p)ᴴ) =
    ∑ p : o × (d × d), prepareKraus (positiveRoot (P p.1) (hP p.1))
    (positiveRoot (E.effect p.1) (E.positive p.1)) p.2 * X *
    (prepareKraus (positiveRoot (P p.1) (hP p.1)) (positiveRoot (E.effect p.1) (E.positive p.1)) p.2)ᴴ
  rw [Fintype.sum_prod_type]

theorem recordChannel_positive (E : FinitePOVM d o) (P : o → Matrix d d ℂ)
    (hP : ∀ j, (P j).PosSemidef) (X : Matrix d d ℂ) (hX : X.PosSemidef) :
    (recordChannel E P X).PosSemidef := by
  rw [recordChannel_eq_kraus E P hP]
  change (∑ p, _ * X * _).PosSemidef
  apply Matrix.posSemidef_sum
  intro p _
  exact hX.mul_mul_conjTranspose_same _

lemma recordChannel_sub (E : FinitePOVM d o) (P M : o → Matrix d d ℂ) :
    recordChannel E (fun j => P j - M j) = recordChannel E P - recordChannel E M := by
  apply LinearMap.ext
  intro X
  simp only [LinearMap.sub_apply, recordChannel_apply, smul_sub, Finset.sum_sub_distrib]

theorem hermitian_record_all_inputs (E : FinitePOVM d o) (V : o → Matrix d d ℂ)
    (hV : ∀ j, (V j).IsHermitian) (D : ℝ) (hD : 0 ≤ D) (hmax : ∀ j, traceNorm (V j) ≤ D)
    (X : Matrix (d × r) (d × r) ℂ) :
    traceNorm (amplifyRect (recordChannel E V) X) ≤ D * traceNorm X := by
  let P := fun j => (1 / 2 : ℝ) • (hermitianAbs (V j) (hV j) + V j)
  let M := fun j => (1 / 2 : ℝ) • (hermitianAbs (V j) (hV j) - V j)
  have hP (j : o) : (P j).PosSemidef :=
    (hermitianAbs_dominates (V j) (hV j)).2.smul (by norm_num)
  have hM (j : o) : (M j).PosSemidef :=
    (hermitianAbs_dominates (V j) (hV j)).1.smul (by norm_num)
  have hdiff : (fun j => P j - M j) = V := by funext j; dsimp [P, M]; module
  have hsum (j : o) : P j + M j = hermitianAbs (V j) (hV j) := by dsimp [P, M]; module
  have htr (j : o) : (P j).trace.re + (M j).trace.re = traceNorm (V j) := by
    have hh := congrArg (fun A : Matrix d d ℂ => A.trace.re) (hsum j)
    simpa only [Matrix.trace_add, Complex.add_re, hermitianAbs_trace] using hh
  let A := fun p : o × (d × d) => prepareKraus (positiveRoot (P p.1) (hP p.1))
    (positiveRoot (E.effect p.1) (E.positive p.1)) p.2
  let B := fun p : o × (d × d) => prepareKraus (positiveRoot (M p.1) (hM p.1))
    (positiveRoot (E.effect p.1) (E.positive p.1)) p.2
  have hAg : (∑ i, (A i)ᴴ * A i) = ∑ j, (P j).trace.re • E.effect j := by
    rw [show (∑ i, (A i)ᴴ * A i) = ∑ j, ∑ p : d × d, (A (j, p))ᴴ * A (j, p) from
      Fintype.sum_prod_type _]
    apply Finset.sum_congr rfl
    intro j _
    exact prepare_positive_gram (E.effect j) (P j) (E.positive j) (hP j)
  have hBg : (∑ i, (B i)ᴴ * B i) = ∑ j, (M j).trace.re • E.effect j := by
    rw [show (∑ i, (B i)ᴴ * B i) = ∑ j, ∑ p : d × d, (B (j, p))ᴴ * B (j, p) from
      Fintype.sum_prod_type _]
    apply Finset.sum_congr rfl
    intro j _
    exact prepare_positive_gram (E.effect j) (M j) (E.positive j) (hM j)
  have hgram : (D • (1 : Matrix d d ℂ) - ((∑ i, (A i)ᴴ * A i) + ∑ i, (B i)ᴴ * B i)).PosSemidef := by
    rw [hAg, hBg]
    simp only [← Finset.sum_add_distrib, ← add_smul, htr]
    have hp := Matrix.posSemidef_sum Finset.univ (fun j _ => (E.positive j).smul (sub_nonneg.mpr (hmax j)))
    simpa only [sub_smul, Finset.sum_sub_distrib, ← Finset.smul_sum, E.normalized] using hp
  have heq : recordChannel E V = rectKrausMap A - rectKrausMap B := by
    rw [← hdiff, recordChannel_sub, recordChannel_eq_kraus E P hP, recordChannel_eq_kraus E M hM]
  rw [heq]
  exact two_kraus_bound_ancilla A B D hD hgram X

lemma recordChannel_defect (E : FinitePOVM d o) (σ : o → Matrix d d ℂ) :
    (recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ =
      recordChannel E (fun j => recordChannel E σ (σ j) - σ j) := by
  apply LinearMap.ext
  intro X
  change recordChannel E σ (recordChannel E σ X) - recordChannel E σ X = _
  rw [recordChannel_apply E σ X, map_sum, recordChannel_apply]
  simp only [map_smul, smul_sub, Finset.sum_sub_distrib]

theorem record_accessibility_upper (E : FinitePOVM d o) (σ : o → Matrix d d ℂ)
    (hσ : ∀ j, (σ j).PosSemidef) (D : ℝ) (hD : 0 ≤ D)
    (hmax : ∀ j, traceNorm (recordChannel E σ (σ j) - σ j) ≤ D) :
    diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) ≤ ENNReal.ofReal D := by
  rw [recordChannel_defect]
  apply diamondSize_le_of_all_inputs
  intro n X hX
  have hh := hermitian_record_all_inputs E (fun j => recordChannel E σ (σ j) - σ j)
    (fun j => (recordChannel_positive E σ hσ (σ j) (hσ j)).1.sub (hσ j).1) D hD hmax X
  exact hh.trans (by nlinarith)

theorem record_accessibility_two_sided (E : FinitePOVM d o) (σ : o → Matrix d d ℂ)
    (hσ : ∀ j, (σ j).PosSemidef) (j : o)
    (hmax : ∀ i, traceNorm (recordChannel E σ (σ i) - σ i) ≤
      traceNorm (recordChannel E σ (σ j) - σ j))
    (ρ : Matrix d d ℂ) (hρ : ρ.PosSemidef) (htr : ρ.trace = 1)
    (e : ℝ) (haccess : 1 - e ≤ (E.effect j * ρ).trace.re) :
    let D := traceNorm (recordChannel E σ (σ j) - σ j)
    ENNReal.ofReal ((1 - 2 * e) * D) ≤
      diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) ∧
    diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) ≤ ENNReal.ofReal D := by
  exact ⟨record_accessibility_lower E σ j ρ hρ htr e haccess hmax,
    record_accessibility_upper E σ hσ _ (traceNorm_nonneg _) hmax⟩

end RCProof
