import RCProof.ExactJointAttainment

namespace RCProof
set_option autoImplicit false
open Filter
open scoped Topology

lemma joint_scalar_root_range (a δ : ℝ) (ha : 0<a) (ha1 : a≤1)
    (hδ : 0<δ) (hδ2 : δ<1/2) :
    0<Real.sqrt (1-a^2*(1-δ)) ∧ Real.sqrt (1-a^2*(1-δ))<1 := by
  have ha2 : a^2≤1 := by nlinarith
  have he : 0<1-a^2*(1-δ) := by
    have hh := mul_le_mul_of_nonneg_right ha2 (show 0≤1-δ by linarith)
    nlinarith
  constructor
  · exact Real.sqrt_pos.mpr he
  · have hh := Real.sq_sqrt he.le
    nlinarith [Real.sqrt_nonneg (1-a^2*(1-δ)), mul_pos (sq_pos_of_pos ha) (show 0<1-δ by linarith)]

theorem joint_worstCase_expansion (a δ : ℝ) (ha : 0<a) (ha1 : a≤1)
    (hδ : 0<δ) (hδ2 : δ<1/2) :
    let b := Real.sqrt (1-a^2*(1-δ))
    (packingWorstCase a δ).toReal=b+b^2/2+b^3/(2*(2-b)) := by
  obtain ⟨hb, hb1⟩ := joint_scalar_root_range a δ ha ha1 hδ hδ2
  dsimp only
  rw [packingWorstCase_exact_joint a δ ha ha1 hδ hδ2,
    ENNReal.toReal_ofReal (show 0≤perfectEnvelope (Real.sqrt (1-a^2*(1-δ))) from
      div_nonneg (by positivity) (by linarith))]
  exact perfectEnvelope_expansion _ (by linarith)

theorem joint_worstCase_uniform_lower (a δ : ℝ) (ha : 0<a) (ha1 : a≤1)
    (hδ : 0<δ) (hδ2 : δ<1/2) :
    (1-2*δ)*Real.sqrt (1-a^2+δ) ≤ (packingWorstCase a δ).toReal := by
  let b := Real.sqrt (1-a^2*(1-δ))
  let s := 1-a^2+δ
  have ha2 : a^2≤1 := by nlinarith
  have hs : 0<s := by dsimp [s]; linarith
  obtain ⟨hb, hb1⟩ := joint_scalar_root_range a δ ha ha1 hδ hδ2
  have hb2 : b^2=1-a^2*(1-δ) := Real.sq_sqrt (le_of_lt (Real.sqrt_pos.mp hb))
  have hr2 : (Real.sqrt s)^2=s := Real.sq_sqrt hs.le
  have hpoly : (1-2*δ)^2≤1-δ := by nlinarith
  have hm := mul_le_mul_of_nonneg_right hpoly hs.le
  have hbs : (1-δ)*s≤b^2 := by dsimp [s]; nlinarith [sq_nonneg δ]
  have hr : (1-2*δ)*Real.sqrt s≤b := by
    have hp : ((1-2*δ)*Real.sqrt s)^2≤b^2 := by
      calc
        _ = (1-2*δ)^2*s := by rw [mul_pow, hr2]
        _ ≤ _ := hm.trans hbs
    nlinarith [Real.sqrt_nonneg s]
  have hBb : b≤perfectEnvelope b := by
    unfold perfectEnvelope
    apply (le_div_iff₀ (by linarith : 0<2-b)).mpr
    nlinarith
  rw [packingWorstCase_exact_joint a δ ha ha1 hδ hδ2,
    ENNReal.toReal_ofReal (show 0≤perfectEnvelope b from hb.le.trans hBb)]
  exact hr.trans hBb

/-- The leading joint asymptotic coefficient belongs to the actual supremum.
The path may approach the origin at any relative rates. -/
theorem joint_worstCase_leading_limit (a δ : ℕ → ℝ)
    (ha : ∀ n, 0<a n) (ha1 : ∀ n, a n≤1)
    (hδ : ∀ n, 0<δ n) (hδ2 : ∀ n, δ n<1/2)
    (hlim : Tendsto (fun n => 1-(a n)^2+δ n) atTop (𝓝 0)) :
    Tendsto (fun n => (packingWorstCase (a n) (δ n)).toReal / Real.sqrt (1-(a n)^2+δ n))
      atTop (𝓝 1) := by
  let s := fun n => 1-(a n)^2+δ n
  have hs : ∀ n, 0<s n := by intro n; dsimp [s]; nlinarith [ha n, ha1 n, hδ n]
  have hδs : ∀ n, δ n≤s n := by intro n; dsimp [s]; nlinarith [ha n, ha1 n]
  have hδlim : Tendsto δ atTop (𝓝 0) := squeeze_zero (fun n => (hδ n).le) hδs hlim
  have hroot : Tendsto (fun n => Real.sqrt (s n)) atTop (𝓝 0) := by simpa using hlim.sqrt
  have hlo : Tendsto (fun n => 1-2*δ n) atTop (𝓝 1) := by
    simpa using tendsto_const_nhds.sub (tendsto_const_nhds.mul hδlim)
  have hup : Tendsto (fun n => 1+5*Real.sqrt (s n)) atTop (𝓝 1) := by
    simpa using tendsto_const_nhds.add (tendsto_const_nhds.mul hroot)
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le' hlo hup
  · exact Filter.Eventually.of_forall (fun n => (le_div_iff₀ (Real.sqrt_pos.mpr (hs n))).mpr
      (joint_worstCase_uniform_lower (a n) (δ n) (ha n) (ha1 n) (hδ n) (hδ2 n)))
  · have hev : ∀ᶠ n in atTop, s n<1/4 := hlim.eventually (gt_mem_nhds (by norm_num : (0 : ℝ)<1/4))
    filter_upwards [hev] with n hn
    have hu := packingWorstCase_uniform_upper (a n) (δ n) (hδ n) (by linarith [hδ2 n]) hn.le
    have huR := ENNReal.toReal_mono ENNReal.ofReal_ne_top hu
    rw [ENNReal.toReal_ofReal (show 0≤Real.sqrt (s n)+5*s n from
      add_nonneg (Real.sqrt_nonneg _) (mul_nonneg (by norm_num) (hs n).le))] at huR
    apply (div_le_iff₀ (Real.sqrt_pos.mpr (hs n))).mpr
    have hh := Real.sq_sqrt (hs n).le
    nlinarith

end RCProof
