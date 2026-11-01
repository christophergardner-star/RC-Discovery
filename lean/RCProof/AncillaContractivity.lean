import RCProof.TraceNorm
import RCProof.CanonicalInstrument

/-! Trace preservation and trace-norm contraction for the constructed channel
with arbitrary finite references. This is contractivity, not the E-versus-F
distance bound. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d r o : Type*} [Fintype d] [Fintype r] [Fintype o]
  [DecidableEq d] [DecidableEq r] [DecidableEq o]

def amplifyMap (Φ : MatrixMap d) : MatrixMap (d × r) where
  toFun := amplify Φ
  map_add' X Y := by
    ext x y
    exact congrArg (fun A : Matrix d d ℂ => A x.1 y.1)
      (Φ.map_add (fun a b => X (a, x.2) (b, y.2)) (fun a b => Y (a, x.2) (b, y.2)))
  map_smul' z X := by
    ext x y
    exact congrArg (fun A : Matrix d d ℂ => A x.1 y.1)
      (map_smul Φ z (fun a b => X (a, x.2) (b, y.2)))

lemma amplify_trace_preserving (Φ : MatrixMap d) (htrace : ∀ A, (Φ A).trace = A.trace)
    (X : Matrix (d × r) (d × r) ℂ) : (amplify Φ X).trace = X.trace := by
  calc
    _ = ∑ s : r, (Φ (fun a b => X (a, s) (b, s))).trace := by
      simp only [Matrix.trace, Matrix.diag, amplify, Fintype.sum_prod_type]
      rw [Finset.sum_comm]
    _ = ∑ s : r, Matrix.trace (fun a b : d => X (a, s) (b, s)) := by
      apply Finset.sum_congr rfl
      intro s _
      exact htrace (fun a b => X (a, s) (b, s))
    _ = X.trace := by
      simp only [Matrix.trace, Matrix.diag, Fintype.sum_prod_type]
      rw [Finset.sum_comm]

theorem completionChannel_amplify_positive (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (X : Matrix (d × r) (d × r) ℂ) (hX : X.PosSemidef) :
    (amplify (completionChannel E c U) X).PosSemidef := by
  rw [completionChannel, amplify_sum_maps]
  apply Matrix.posSemidef_sum
  intro j _
  apply prepareMap_amplify_positive _ _ _ _ X hX
  · apply completedEffect_positive U hU _ _ _ (E.positive j)
    rw [← canonicalFrame_coordinates]
    exact (canonicalFrame E c).coordinates.positive j
  · exact normalizedPositive_positive _ (sectorProjection_positive E c U j)

theorem completionChannel_ancilla_contracts (E : FinitePOVM d o) (c : ℝ)
    (U : Matrix d (SectorIndex E c) ℂ) (hU : Uᴴ * U = 1)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 c ≠ 0)
    (X : Matrix (d × r) (d × r) ℂ) (hX : X.IsHermitian) :
    traceNorm (amplify (completionChannel E c U) X) ≤ traceNorm X := by
  apply traceNorm_contracts_hermitian (amplifyMap (completionChannel E c U))
  · exact completionChannel_amplify_positive E c U hU
  · intro A
    apply amplify_trace_preserving
    intro Z
    simpa only [completionChannel, LinearMap.sum_apply] using
      completionInstrument_trace_preserving E c U hU hsector Z
  · exact hX

end RCProof
