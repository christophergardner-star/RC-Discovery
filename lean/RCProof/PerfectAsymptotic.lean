import RCProof.WorstCase

namespace RCProof
set_option autoImplicit false
open Filter
open scoped Topology

theorem perfect_worstCase_expansion (b : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2) :
    (packingWorstCase 1 (b ^ 2)).toReal = b + b ^ 2 / 2 + b ^ 3 / (2 * (2 - b)) := by
  rw [packingWorstCase_perfect_exact (b ^ 2) (sq_pos_of_pos hb) hb2, Real.sqrt_sq hb.le,
    ENNReal.toReal_ofReal (show 0 ≤ perfectEnvelope b from div_nonneg (by linarith) (by nlinarith))]
  exact perfectEnvelope_expansion b (by nlinarith)

lemma perfect_worstCase_second_ratio (b : ℝ) (hb : 0 < b) (hb2 : b ^ 2 < 1 / 2) :
    ((packingWorstCase 1 (b ^ 2)).toReal - b) / b ^ 2 = 1 / (2 - b) := by
  rw [packingWorstCase_perfect_exact (b ^ 2) (sq_pos_of_pos hb) hb2, Real.sqrt_sq hb.le,
    ENNReal.toReal_ofReal (show 0 ≤ perfectEnvelope b from div_nonneg (by linarith) (by nlinarith))]
  unfold perfectEnvelope
  field_simp [hb.ne', show (2 : ℝ) - b ≠ 0 by nlinarith]
  <;> ring

/-- The coefficient 1/2 belongs to the actual perfect-packing worst-case
envelope, not just to a candidate scalar expression. -/
theorem perfect_worstCase_second_order_limit (b : ℕ → ℝ)
    (hb : ∀ n, 0 < b n) (hb2 : ∀ n, (b n) ^ 2 < 1 / 2)
    (hlim : Tendsto b atTop (𝓝 0)) :
    Tendsto (fun n => ((packingWorstCase 1 ((b n) ^ 2)).toReal - b n) / (b n) ^ 2)
      atTop (𝓝 (1 / 2)) := by
  have heq : (fun n => ((packingWorstCase 1 ((b n) ^ 2)).toReal - b n) / (b n) ^ 2) =
      fun n => 1 / (2 - b n) := by
    funext n
    exact perfect_worstCase_second_ratio (b n) (hb n) (hb2 n)
  rw [heq]
  have hh := (tendsto_const_nhds (x := (1 : ℝ))).div
    (tendsto_const_nhds.sub hlim) (show (2 : ℝ) - 0 ≠ 0 by norm_num)
  change Tendsto (fun n => 1 / (2 - b n)) atTop (𝓝 (1 / (2 - 0))) at hh
  norm_num at hh
  simpa only [one_div] using hh

end RCProof
