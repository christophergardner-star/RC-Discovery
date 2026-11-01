import Mathlib.Tactic

namespace RCProof

/-- In the nontrivial regime the width condition is automatic (c >= 1/2). -/
theorem width_of_nontrivial_radius (a c : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1)
    (hc : 1 / 2 ≤ c) (hc1 : c ≤ 1)
    (hsmall : Real.sqrt (1 - a ^ 2) + Real.sqrt (1 - c) < 1) :
    ((Real.sqrt c)⁻¹ - a) * (1 - Real.sqrt c) ≤ 4 * a * Real.sqrt c := by
  have hc0 : 0 < c := by linarith
  have hs := Real.sqrt_pos.mpr hc0
  have hs1 : Real.sqrt c ≤ 1 := by simpa using Real.sqrt_le_sqrt hc1
  have hs2 := Real.sq_sqrt hc0.le
  have ht0 := Real.sqrt_nonneg (1 - c)
  have ht2 := Real.sq_sqrt (show 0 ≤ 1 - c by linarith)
  have hu0 := Real.sqrt_nonneg (1 - a ^ 2)
  have hu2 := Real.sq_sqrt (show 0 ≤ 1 - a ^ 2 by nlinarith)
  have hau : 1 ≤ a + Real.sqrt (1 - a ^ 2) := by
    nlinarith [mul_nonneg ha hu0]
  have hst : 1 ≤ Real.sqrt c + Real.sqrt (1 - c) := by
    nlinarith [mul_nonneg hs.le ht0]
  have has : 1 - Real.sqrt c ≤ a := by linarith
  have hinv : (Real.sqrt c)⁻¹ ≤ 4 * Real.sqrt c := by
    rw [← one_div]
    apply (div_le_iff₀ hs).mpr
    nlinarith
  calc
    _ ≤ (Real.sqrt c)⁻¹ * (1 - Real.sqrt c) := by gcongr; linarith
    _ ≤ (Real.sqrt c)⁻¹ * a := mul_le_mul_of_nonneg_left has (inv_nonneg.mpr hs.le)
    _ ≤ (4 * Real.sqrt c) * a := mul_le_mul_of_nonneg_right hinv ha
    _ = _ := by ring

theorem sharp_radius_le_sum (a c : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1)
    (hc : 0 ≤ c) (hc1 : c ≤ 1) :
    Real.sqrt (1 - (a * Real.sqrt c) ^ 2) ≤
      Real.sqrt (1 - a ^ 2) + Real.sqrt (1 - c) := by
  have ha2 : a ^ 2 ≤ 1 := by nlinarith
  have hs2 := Real.sq_sqrt hc
  have hr0 := Real.sqrt_nonneg (1 - (a * Real.sqrt c) ^ 2)
  have ht0 := Real.sqrt_nonneg (1 - a ^ 2)
  have hu0 := Real.sqrt_nonneg (1 - c)
  have ht2 := Real.sq_sqrt (sub_nonneg.mpr ha2)
  have hu2 := Real.sq_sqrt (sub_nonneg.mpr hc1)
  have hprod : (a * Real.sqrt c) ^ 2 = a ^ 2 * c := by rw [mul_pow, hs2]
  have hr2 := Real.sq_sqrt (show 0 ≤ 1 - (a * Real.sqrt c) ^ 2 by
    rw [hprod]
    nlinarith [mul_nonneg (sub_nonneg.mpr ha2) hc])
  rw [hprod] at hr2
  rw [hprod] at hr0 ⊢
  nlinarith [mul_nonneg (sub_nonneg.mpr ha2) (sub_nonneg.mpr hc1), mul_nonneg ht0 hu0]

end RCProof
