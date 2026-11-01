import RCProof.Naimark
import RCProof.Polar

/-! Assemble the hybrid dilation using genuine spectral projectors and the
constructed Naimark isometry. The remaining geometric input is a sector frame
and its inclusion in the range of an isometry; polar construction is separate. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d k o : Type*} [Fintype d] [Fintype k] [Fintype o]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]

structure SpectralFrame (E : FinitePOVM d o) (c : ℝ) (k : Type*)
    [Fintype k] [DecidableEq k] where
  block : o → Matrix d k ℂ
  supported : ∀ j, thresholdProjector (E.effect j) (E.positive j).1 c * block j = block j
  full : ∀ j, block j * (block j)ᴴ = thresholdProjector (E.effect j) (E.positive j).1 c
  normalized : ∑ j, (block j)ᴴ * block j = 1

def SpectralFrame.coordinates {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) : FinitePOVM k o where
  effect j := (B.block j)ᴴ * B.block j
  positive j := Matrix.posSemidef_conjTranspose_mul_self (B.block j)
  normalized := B.normalized

lemma SpectralFrame.coordinate_idempotent {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (j : o) :
    B.coordinates.effect j * B.coordinates.effect j = B.coordinates.effect j := by
  change ((B.block j)ᴴ * B.block j) * ((B.block j)ᴴ * B.block j) = _
  calc
    _ = (B.block j)ᴴ * ((B.block j * (B.block j)ᴴ) * B.block j) := by
      simp only [Matrix.mul_assoc]
    _ = _ := by rw [B.full, B.supported]; rfl

lemma SpectralFrame.isometry {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) : (stack B.block)ᴴ * stack B.block = 1 := by
  rw [stack_gram, B.normalized]

lemma SpectralFrame.label_compression {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (j : o) :
    (stack B.block)ᴴ * labelProjection j * stack B.block = B.coordinates.effect j :=
  stack_label_compression B.block j

lemma SpectralFrame.projector_residual_zero {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (Z : o → Matrix k k ℂ) (hZ : ∀ j, B.block j = U * Z j) (j : o) :
    thresholdProjector (E.effect j) (E.positive j).1 c * (1 - U * Uᴴ) = 0 := by
  have hR := (residual_projection_properties U hU).1
  have hz : (1 - U * Uᴴ) * B.block j = 0 := by
    rw [hZ, ← Matrix.mul_assoc, residual_annihilates_isometry U hU, Matrix.zero_mul]
  have hza : (B.block j)ᴴ * (1 - U * Uᴴ) = 0 := by
    simpa only [Matrix.conjTranspose_mul, hR, Matrix.conjTranspose_zero] using
      congrArg Matrix.conjTranspose hz
  rw [← B.full, Matrix.mul_assoc, hza, Matrix.mul_zero]

lemma SpectralFrame.block_cross_zero {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (R : Matrix d d ℂ)
    (hPR : ∀ j, thresholdProjector (E.effect j) (E.positive j).1 c * R = 0) (j : o) :
    (B.block j)ᴴ * positiveRoot (E.effect j) (E.positive j) * R = 0 := by
  have hP := (thresholdProjector_positive (E.effect j) (E.positive j).1 c).1.eq
  have hb : (B.block j)ᴴ * thresholdProjector (E.effect j) (E.positive j).1 c =
      (B.block j)ᴴ := by
    simpa only [Matrix.conjTranspose_mul, hP] using
      congrArg Matrix.conjTranspose (B.supported j)
  calc
    _ = (B.block j)ᴴ * (thresholdProjector (E.effect j) (E.positive j).1 c *
        positiveRoot (E.effect j) (E.positive j) * R) := by
      rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hb]
    _ = 0 := by
      rw [spectral_cross_zero _ _ R (thresholdProjector_root_commutes _ _ c) (hPR j),
        Matrix.mul_zero]

/-- Both the global and labelwise cross terms are derived from spectral support. -/
theorem SpectralFrame.cross_zero {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (Z : o → Matrix k k ℂ) (hZ : ∀ j, B.block j = U * Z j) :
    (stack B.block)ᴴ * naimark E * (1 - U * Uᴴ) = (0 : Matrix k d ℂ) ∧
    ∀ j, (stack B.block)ᴴ * labelProjection j * naimark E * (1 - U * Uᴴ) =
      (0 : Matrix k d ℂ) := by
  have hz := B.block_cross_zero (1 - U * Uᴴ) (B.projector_residual_zero U hU Z hZ)
  constructor
  · rw [naimark, stack_cross, Matrix.sum_mul]
    simp only [hz, Finset.sum_const_zero]
  · intro j
    rw [naimark, stack_label_cross B.block (fun i => positiveRoot (E.effect i) (E.positive i)) j]
    exact hz j

/-- An assembled dilation of the prescribed completed POVM. No cross-zero or
Naimark-compression identity appears among its hypotheses. -/
theorem SpectralFrame.hybrid_dilation {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (Z : o → Matrix k k ℂ) (hZ : ∀ j, B.block j = U * Z j) :
    let V := stack B.block * Uᴴ + naimark E * (1 - U * Uᴴ)
    Vᴴ * V = 1 ∧ ∀ j, Vᴴ * labelProjection j * V =
      (completedPOVM U hU B.coordinates E).effect j := by
  obtain ⟨hR, hRR, _⟩ := residual_projection_properties U hU
  obtain ⟨hz, hlabel⟩ := B.cross_zero U hU Z hZ
  constructor
  · exact hybrid_isometry U _ _ _ B.isometry (naimark_isometry E) hR hRR (by abel) hz
  · intro j
    exact hybrid_compression U _ _ _ _ _ _ hR (labelProjection_positive j).1.eq
      (B.label_compression j) (naimark_compression E j) (hlabel j)

theorem SpectralFrame.residual_gap {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (Z : o → Matrix k k ℂ) (hZ : ∀ j, B.block j = U * Z j) (j : o) :
    (c • (1 - U * Uᴴ) - (1 - U * Uᴴ) * E.effect j * (1 - U * Uᴴ)).PosSemidef := by
  obtain ⟨hR, hRR, _⟩ := residual_projection_properties U hU
  exact threshold_residual_gap _ _ (E.positive j).1 (E.effect_le_one j) c hR hRR
    (B.projector_residual_zero U hU Z hZ j)

/-- The isometry and range inclusion are now constructed from the synthesis
matrix. `hB` expresses the coordinate-frame relation; it is not a norm bound. -/
theorem SpectralFrame.hybrid_dilation_from_polar {E : FinitePOVM d o} {c : ℝ}
    (B : SpectralFrame E c k) (T : Matrix d k ℂ) (hT : (Tᴴ * T).PosDef)
    (hB : ∀ j, B.block j = T * B.coordinates.effect j) :
    let U := polarIsometry T
    let V := stack B.block * Uᴴ + naimark E * (1 - U * Uᴴ)
    Vᴴ * V = 1 ∧ ∀ j, Vᴴ * labelProjection j * V =
      completedEffect U (B.coordinates.effect j) (E.effect j) := by
  apply B.hybrid_dilation (polarIsometry T) (polarIsometry_isometry T hT)
    (fun j => polarRoot T * B.coordinates.effect j)
  intro j
  rw [← Matrix.mul_assoc, polar_factorization T hT, hB]

end RCProof
