import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Tactic

/-! Exact scalar optimizations and limit-transfer lemmas. These do not assume
that an abstract scalar envelope is already attained by admissible POVMs. -/
namespace RCProof
set_option autoImplicit false
open Filter
open scoped Topology

noncomputable def perfectEnvelope (b : ℝ) : ℝ := 2 * b / (2 - b)

lemma perfectEnvelope_square_identity (b p : ℝ) (hb : b ≠ 2) :
    (perfectEnvelope b - b ^ 2 * p) ^ 2 - (b ^ 4 * p ^ 2 + 4 * b ^ 2 * p * (1 - p)) =
      4 * b ^ 2 * (p - 1 / (2 - b)) ^ 2 := by
  unfold perfectEnvelope
  field_simp
  ring

theorem perfectEnvelope_scalar_upper (b p : ℝ) (hb : 0 < b) (hb1 : b < 1)
    (hp : 0 ≤ p) (hp1 : p ≤ 1) :
    b ^ 2 * p + Real.sqrt (b ^ 4 * p ^ 2 + 4 * b ^ 2 * p * (1 - p)) ≤ perfectEnvelope b := by
  have hz : 0 < 2 - b := by linarith
  have hB : b ^ 2 < perfectEnvelope b := by
    unfold perfectEnvelope
    apply (lt_div_iff₀ hz).mpr
    nlinarith [mul_pos hb (show 0 < 1 - b by linarith)]
  have hbp : b ^ 2 * p ≤ b ^ 2 := by nlinarith [sq_nonneg b]
  have hrad : 0 ≤ b ^ 4 * p ^ 2 + 4 * b ^ 2 * p * (1 - p) := by positivity
  have hs := Real.sq_sqrt hrad
  have hid := perfectEnvelope_square_identity b p (by linarith)
  have hsq : 0 ≤ 4 * b ^ 2 * (p - 1 / (2 - b)) ^ 2 := by positivity
  nlinarith [Real.sqrt_nonneg (b ^ 4 * p ^ 2 + 4 * b ^ 2 * p * (1 - p))]

theorem perfectEnvelope_scalar_attained (b : ℝ) (hb : 0 < b) (hb1 : b < 1) :
    let p := 1 / (2 - b)
    0 < p ∧ p < 1 ∧ b ^ 2 * p + Real.sqrt (b ^ 4 * p ^ 2 + 4 * b ^ 2 * p * (1 - p)) = perfectEnvelope b := by
  have hz : 0 < 2 - b := by linarith
  dsimp only
  refine ⟨one_div_pos.mpr hz, (div_lt_one hz).mpr (by linarith), ?_⟩
  have hr : b ^ 4 * (1 / (2 - b)) ^ 2 + 4 * b ^ 2 * (1 / (2 - b)) * (1 - 1 / (2 - b)) = b ^ 2 := by
    field_simp
    ring
  rw [hr, Real.sqrt_sq hb.le]
  unfold perfectEnvelope
  field_simp
  ring

theorem perfectEnvelope_expansion (b : ℝ) (hb : b ≠ 2) :
    perfectEnvelope b = b + b ^ 2 / 2 + b ^ 3 / (2 * (2 - b)) := by
  unfold perfectEnvelope
  field_simp
  ring

theorem perfectEnvelope_remainder (b : ℝ) (hb : 0 ≤ b) (hb1 : b ≤ 1) :
    0 ≤ perfectEnvelope b - (b + b ^ 2 / 2) ∧
      perfectEnvelope b - (b + b ^ 2 / 2) ≤ b ^ 3 / 2 := by
  rw [perfectEnvelope_expansion b (by linarith)]
  have heq : b + b ^ 2 / 2 + b ^ 3 / (2 * (2 - b)) - (b + b ^ 2 / 2) = b ^ 3 / (2 * (2 - b)) := by ring
  rw [heq]
  constructor
  · exact div_nonneg (pow_nonneg hb 3) (by linarith)
  · apply (div_le_iff₀ (show 0 < 2 * (2 - b) by linarith)).mpr
    nlinarith [mul_nonneg (pow_nonneg hb 3) (show 0 ≤ 1 - b by linarith)]

theorem perfectEnvelope_ratio_limit : Tendsto (fun b : ℝ => 2 / (2 - b)) (𝓝 0) (𝓝 1) := by
  have h := (tendsto_const_nhds (x := (2 : ℝ))).div
    (tendsto_const_nhds.sub tendsto_id) (show (2 : ℝ) - 0 ≠ 0 by norm_num)
  change Tendsto (fun b : ℝ => 2 / (2 - b)) (𝓝 0) (𝓝 (2 / (2 - 0))) at h
  norm_num at h
  exact h

lemma perfectEnvelope_ratio (b : ℝ) (hb : b ≠ 0) : perfectEnvelope b / b = 2 / (2 - b) := by
  unfold perfectEnvelope
  field_simp

lemma residual_quadratic_square_identity (ε p : ℝ) (hε : ε ≠ 4) :
    ε ^ 2 * p ^ 2 + 4 * ε * p * (1 - p) =
      4 * ε / (4 - ε) - ε * (4 - ε) * (p - 2 / (4 - ε)) ^ 2 := by
  field_simp
  ring

/-- A genuine joint limit for arbitrary sequences obeying the uniform
sandwich. Instantiating it with the POVM supremum requires its upper and lower
construction theorems, and is not asserted by this lemma. -/
theorem joint_envelope_limit_of_uniform_bounds (s δ W : ℕ → ℝ)
    (hs : ∀ n, 0 < s n) (hδ : ∀ n, 0 ≤ δ n) (hδs : ∀ n, δ n ≤ s n)
    (hlim : Tendsto s atTop (𝓝 0))
    (hlower : ∀ n, (1 - 2 * δ n) * Real.sqrt (s n) ≤ W n)
    (hupper : ∀ n, W n ≤ Real.sqrt (s n) + 5 * s n) :
    Tendsto (fun n => W n / Real.sqrt (s n)) atTop (𝓝 1) := by
  have hδlim : Tendsto δ atTop (𝓝 0) := squeeze_zero hδ hδs hlim
  have hroot : Tendsto (fun n => Real.sqrt (s n)) atTop (𝓝 0) := by
    simpa using hlim.sqrt
  have hlo : Tendsto (fun n => 1 - 2 * δ n) atTop (𝓝 1) := by
    simpa using tendsto_const_nhds.sub (tendsto_const_nhds.mul hδlim)
  have hup : Tendsto (fun n => 1 + 5 * Real.sqrt (s n)) atTop (𝓝 1) := by
    simpa using tendsto_const_nhds.add (tendsto_const_nhds.mul hroot)
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le hlo hup
  · intro n
    exact (le_div_iff₀ (Real.sqrt_pos.mpr (hs n))).mpr (hlower n)
  · intro n
    apply (div_le_iff₀ (Real.sqrt_pos.mpr (hs n))).mpr
    have hh := Real.sq_sqrt (hs n).le
    nlinarith [hupper n]

end RCProof
