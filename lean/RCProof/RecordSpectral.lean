import RCProof.RecordNorm

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

lemma spectral_density_input (A : Matrix d d ℂ) (hA : A.IsHermitian) (i : d) :
    ∃ ρ : Matrix d d ℂ, ρ.PosSemidef ∧ ρ.trace = 1 ∧ (A * ρ).trace.re = hA.eigenvalues i := by
  let ρ := inEigenbasis hA.eigenvectorUnitary (fun j => if j = i then 1 else 0)
  have hp : ρ.PosSemidef := inEigenbasis_positive _ _ (by intro j; split_ifs <;> norm_num)
  have ht : ρ.trace.re = 1 := by simp [ρ, trace_inEigenbasis]
  refine ⟨ρ, hp, ?_, ?_⟩
  · rw [← positive_trace_real ρ hp, ht]; norm_num
  · change (A * inEigenbasis hA.eigenvectorUnitary _).trace.re = _
    conv_lhs => arg 1; arg 1; lhs; rw [spectral_representation A hA]
    rw [inEigenbasis_mul, trace_inEigenbasis]
    simp

noncomputable def largestEffectEigenvalue [Nonempty d] (E : FinitePOVM d o) (j : o) : ℝ :=
  (E.positive j).1.eigenvalues (Classical.choose (Finite.exists_max (E.positive j).1.eigenvalues))

lemma effect_eigenvalue_le_largest [Nonempty d] (E : FinitePOVM d o) (j : o) (i : d) :
    (E.positive j).1.eigenvalues i ≤ largestEffectEigenvalue E j :=
  Classical.choose_spec (Finite.exists_max (E.positive j).1.eigenvalues) i

noncomputable def recordInaccessibility [Nonempty d] [Nonempty o] (E : FinitePOVM d o) : ℝ :=
  1 - largestEffectEigenvalue E (Classical.choose (Finite.exists_min (largestEffectEigenvalue E)))

lemma record_accessible_density [Nonempty d] [Nonempty o] (E : FinitePOVM d o) (j : o) :
    ∃ ρ : Matrix d d ℂ, ρ.PosSemidef ∧ ρ.trace = 1 ∧
      1 - recordInaccessibility E ≤ (E.effect j * ρ).trace.re := by
  obtain ⟨ρ, hp, ht, hv⟩ := spectral_density_input (E.effect j) (E.positive j).1
    (Classical.choose (Finite.exists_max (E.positive j).1.eigenvalues))
  refine ⟨ρ, hp, ht, ?_⟩
  rw [hv]
  have hh := Classical.choose_spec (Finite.exists_min (largestEffectEigenvalue E)) j
  dsimp only [recordInaccessibility]
  rw [sub_sub_cancel]
  exact hh

/-- The direct accessibility certificate with the actual spectral
inaccessibility and an attained maximum over record residuals. -/
theorem record_accessibility_spectral [Nonempty d] [Nonempty o]
    (E : FinitePOVM d o) (σ : o → Matrix d d ℂ) (hσ : ∀ j, (σ j).PosSemidef) :
    ∃ j : o,
      (∀ i, traceNorm (recordChannel E σ (σ i) - σ i) ≤ traceNorm (recordChannel E σ (σ j) - σ j)) ∧
      ENNReal.ofReal ((1 - 2 * recordInaccessibility E) * traceNorm (recordChannel E σ (σ j) - σ j)) ≤
        diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) ∧
      diamondSize ((recordChannel E σ).comp (recordChannel E σ) - recordChannel E σ) ≤
        ENNReal.ofReal (traceNorm (recordChannel E σ (σ j) - σ j)) := by
  obtain ⟨j, hj⟩ := Finite.exists_max (fun i => traceNorm (recordChannel E σ (σ i) - σ i))
  obtain ⟨ρ, hp, ht, ha⟩ := record_accessible_density E j
  exact ⟨j, hj, record_accessibility_two_sided E σ hσ j hj ρ hp ht (recordInaccessibility E) ha⟩

end RCProof
