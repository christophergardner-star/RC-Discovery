import RCProof.ExactJointAsymptotic

namespace RCProof
set_option autoImplicit false
open Filter
open scoped Topology

lemma coupled_root_second_order_bounds (b r : ℝ) (hr : 0<r) (hr1 : r≤1/2)
    (hb : 0≤b) (hbr : b≤r) (hfloor : r^2-r^4≤b^2) :
    r+r^2/2-2*r^3≤perfectEnvelope b ∧ perfectEnvelope b≤r+r^2/2+r^3 := by
  have hgap : r-b≤r^3 := by
    have hh : (r-b)*r≤r^3*r := by nlinarith [mul_nonneg hb (sub_nonneg.mpr hbr)]
    exact (mul_le_mul_iff_left₀ hr).mp (by simpa only [mul_comm] using hh)
  have hden : 0<2*(2-b) := by linarith
  have hcubic : b^3≤r^3 := by gcongr
  have hrem : 0≤b^3/(2*(2-b)) := div_nonneg (pow_nonneg hb _) hden.le
  have hremU : b^3/(2*(2-b))≤r^3 := by
    apply (div_le_iff₀ hden).mpr
    nlinarith [mul_nonneg (pow_nonneg hr.le 3) (show 0≤2*(2-b)-1 by linarith)]
  rw [perfectEnvelope_expansion b (by linarith)]
  constructor
  · nlinarith [mul_nonneg (pow_nonneg hr.le 3) (show 0≤2-r by linarith)]
  · nlinarith

theorem joint_worstCase_second_ratio_bounds (a δ : ℝ) (ha : 0<a) (ha1 : a≤1)
    (hδ : 0<δ) (hδ2 : δ<1/2) (hs : 1-a^2+δ≤1/4) :
    1/2-2*Real.sqrt (1-a^2+δ)≤
        ((packingWorstCase a δ).toReal-Real.sqrt (1-a^2+δ))/(1-a^2+δ) ∧
      ((packingWorstCase a δ).toReal-Real.sqrt (1-a^2+δ))/(1-a^2+δ)≤
        1/2+Real.sqrt (1-a^2+δ) := by
  let x := 1-a^2
  let s := 1-a^2+δ
  let r := Real.sqrt s
  let b := Real.sqrt (1-a^2*(1-δ))
  have hx : 0≤x := by dsimp [x]; nlinarith
  have hs0 : 0<s := by dsimp [s, x] at *; linarith
  have hr : 0<r := Real.sqrt_pos.mpr hs0
  have hr2 : r^2=s := Real.sq_sqrt hs0.le
  have hr1 : r≤1/2 := by nlinarith
  obtain ⟨hb, hb1⟩ := joint_scalar_root_range a δ ha ha1 hδ hδ2
  have hb2 : b^2=1-a^2*(1-δ) := Real.sq_sqrt (le_of_lt (Real.sqrt_pos.mp hb))
  have heq : b^2=s-x*δ := by dsimp [s, x]; nlinarith
  have hbr : b≤r := by nlinarith [mul_nonneg hx hδ.le]
  have hfloor : r^2-r^4≤b^2 := by
    have hsx : s=x+δ := rfl
    have hprod : x*δ≤s^2 := by nlinarith [mul_nonneg hx hδ.le, sq_nonneg x, sq_nonneg δ]
    have hr4 : r^4=s^2 := by nlinarith [sq_nonneg (r^2-s)]
    nlinarith
  have hh := coupled_root_second_order_bounds b r hr hr1 hb.le hbr hfloor
  have hW : (packingWorstCase a δ).toReal=perfectEnvelope b := by
    rw [packingWorstCase_exact_joint a δ ha ha1 hδ hδ2]
    exact ENNReal.toReal_ofReal (div_nonneg (by positivity) (by linarith))
  rw [hW]
  constructor
  · apply (le_div_iff₀ hs0).mpr
    nlinarith [congrArg (fun z => r*z) hr2]
  · apply (div_le_iff₀ hs0).mpr
    nlinarith [congrArg (fun z => r*z) hr2]

/-- The joint subleading coefficient 1/2 is proved for the actual extremal
problem along every admissible path, not only along perfect packing. -/
theorem joint_worstCase_second_order_limit (a δ : ℕ → ℝ)
    (ha : ∀ n, 0<a n) (ha1 : ∀ n, a n≤1)
    (hδ : ∀ n, 0<δ n) (hδ2 : ∀ n, δ n<1/2)
    (hlim : Tendsto (fun n => 1-(a n)^2+δ n) atTop (𝓝 0)) :
    Tendsto (fun n => ((packingWorstCase (a n) (δ n)).toReal-Real.sqrt (1-(a n)^2+δ n)) /
      (1-(a n)^2+δ n)) atTop (𝓝 (1/2)) := by
  have hroot : Tendsto (fun n => Real.sqrt (1-(a n)^2+δ n)) atTop (𝓝 0) := by
    simpa using hlim.sqrt
  have hlo : Tendsto (fun n => 1/2-2*Real.sqrt (1-(a n)^2+δ n)) atTop (𝓝 (1/2)) := by
    simpa using tendsto_const_nhds.sub (tendsto_const_nhds.mul hroot)
  have hup : Tendsto (fun n => 1/2+Real.sqrt (1-(a n)^2+δ n)) atTop (𝓝 (1/2)) := by
    simpa using tendsto_const_nhds.add hroot
  have hev : ∀ᶠ n in atTop, 1-(a n)^2+δ n<1/4 :=
    hlim.eventually (gt_mem_nhds (by norm_num : (0 : ℝ)<1/4))
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le' hlo hup
  · filter_upwards [hev] with n hn
    exact (joint_worstCase_second_ratio_bounds (a n) (δ n) (ha n) (ha1 n) (hδ n) (hδ2 n) hn.le).1
  · filter_upwards [hev] with n hn
    exact (joint_worstCase_second_ratio_bounds (a n) (δ n) (ha n) (ha1 n) (hδ n) (hδ2 n) hn.le).2

end RCProof
