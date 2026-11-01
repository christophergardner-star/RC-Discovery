import RCProof.FrozenDiamond

namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

theorem canonical_residual_gap (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) (j : o) :
    let U := polarIsometry (canonicalSynthesis E c)
    let R := 1 - U * Uᴴ
    (c • R - R * E.effect j * R).PosSemidef := by
  apply (canonicalFrame E c).residual_gap _
    (polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT))
    (fun i => polarRoot (canonicalSynthesis E c) * sectorCoordinate E c i)
  intro i
  rw [← Matrix.mul_assoc, polar_factorization _ (Matrix.PosDef.conjTranspose_mul_self _ hT)]
  exact canonicalBlock_factor E c i

/-- One assembled statement for the frozen construction. `FinitePOVM` supplies
positivity and normalization of F; every other displayed conclusion is proved.
Nonemptiness of the sector index follows from the active-label hypothesis on
a nonzero input space by `sectorIndex_nonempty`. -/
theorem frozen_theorem (E : FinitePOVM d o) (δ : ℝ) (hδ : 0 < δ) (hδhalf : δ < 1 / 2)
    [Nonempty (SectorIndex E (1 - δ))]
    (hT : Function.Injective (canonicalSynthesis E (1 - δ)).mulVec)
    (hsector : ∀ j, E.effect j ≠ 0 → thresholdProjector (E.effect j) (E.positive j).1 (1 - δ) ≠ 0) :
    let c := 1 - δ
    let U := polarIsometry (canonicalSynthesis E c)
    let F := canonicalCompletion E c hT
    let I := completionInstrument E c U
    (∀ j, ‖thresholdProjector (E.effect j) (E.positive j).1 c - sectorProjection E c U j‖ ≤
      Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2)) ∧
    (∀ j, (thresholdProjector (E.effect j) (E.positive j).1 c).rank = (sectorProjection E c U j).rank) ∧
    (∀ i j, F.effect i * sectorProjection E c U j = if i = j then sectorProjection E c U j else 0) ∧
    (∀ j, (c • (1 - U * Uᴴ) - (1 - U * Uᴴ) * E.effect j * (1 - U * Uᴴ)).PosSemidef) ∧
    (∀ j, CompletelyPositive (I j)) ∧
    (∀ j X, (I j X).trace = (F.effect j * X).trace) ∧
    (∀ X, (∑ j, I j X).trace = X.trace) ∧
    (∀ i j X, I i (I j X) = if i = j then I j X else 0) ∧
    diamondSize (measurementMap E - measurementMap F) ≤
      ENNReal.ofReal (2 * min 1 (Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2) + Real.sqrt δ)) := by
  dsimp only
  have hU := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  refine ⟨canonical_principal_angle E (1 - δ) hT, canonical_sector_rank E (1 - δ) hT,
    ?_, canonical_residual_gap E (1 - δ) hT, completionInstrument_cp E (1 - δ) _ hU,
    ?_, completionInstrument_trace_preserving E (1 - δ) _ hU hsector,
    completionInstrument_repeatable E (1 - δ) _ hU hsector,
    frozen_measurement_diamond_bound E δ hδ hδhalf hT⟩
  · intro i j
    rw [canonicalCompletion_effect]
    exact completedEffect_projection E (1 - δ) _ hU i j
  · intro j X
    rw [canonicalCompletion_effect]
    exact completionInstrument_probability E (1 - δ) _ hU hsector j X

end RCProof
