import RCProof.JointFamilyPOVM

namespace RCProof
set_option autoImplicit false

/-- The admissible variable-size family exists at every requested exact pair;
the dimension constraint is obtained by the Archimedean property. -/
theorem exists_jointFamilyData (a δ : ℝ) (ha : 0 < a) (ha1 : a ≤ 1)
    (hδ : 0 < δ) (hδ2 : δ < 1/2) :
    ∃ p : JointFamilyData, p.a=a ∧ p.c=1-δ := by
  let c := 1-δ
  have hc : 0 < c := by dsimp [c]; linarith
  have hc1 : c < 1 := by dsimp [c]; linarith
  have ha2 : a^2 ≤ 1 := by nlinarith
  obtain ⟨n, hn⟩ := exists_nat_gt (max 1 (c*(1-a^2)/δ+1))
  have hn1 : (1 : ℝ) < n := lt_of_le_of_lt (le_max_left _ _) hn
  have hn2 : 2 ≤ n := by
    have hni : 1 < n := by exact_mod_cast hn1
    omega
  have hnratio : c*(1-a^2)/δ+1 < n := lt_of_le_of_lt (le_max_right _ _) hn
  have hdim : c*(1-a^2) ≤ δ*((n : ℝ)-1) := by
    have hh := (div_lt_iff₀ hδ).mp (show c*(1-a^2)/δ < (n : ℝ)-1 by linarith)
    nlinarith
  let g := Real.sqrt (((n : ℝ)-a^2)/((n : ℝ)-1))
  have hratio : 1 ≤ ((n : ℝ)-a^2)/((n : ℝ)-1) := by
    apply (le_div_iff₀ (by linarith : 0 < (n : ℝ)-1)).mpr
    nlinarith
  have hg2 : g^2=((n : ℝ)-a^2)/((n : ℝ)-1) := Real.sq_sqrt (by linarith)
  have hg1 : 1 ≤ g := by
    have hh := Real.sqrt_le_sqrt hratio
    simpa only [Real.sqrt_one] using hh
  have hunit : a^2+((n : ℝ)-1)*g^2=(n : ℝ) := by
    rw [hg2]
    field_simp
    <;> ring
  have ht : 0 ≤ 1-c*g^2 := by
    have hh := congrArg (fun x : ℝ => c*x) hunit
    have hcδ : c+δ=1 := by dsimp [c]; ring
    nlinarith
  let w := (Real.sqrt (n : ℝ))⁻¹
  have hwn : Real.sqrt (n : ℝ) > 0 := Real.sqrt_pos.mpr (by linarith)
  have hw : (n : ℝ)*w^2=1 := by
    dsimp only [w]
    rw [inv_pow, Real.sq_sqrt (by positivity), mul_inv_cancel₀ (by linarith)]
  let b := Real.sqrt (1-c*a^2)
  have heps : 0 < 1-c*a^2 := by
    have hh := mul_le_mul_of_nonneg_left ha2 hc.le
    nlinarith
  have heps1 : 1-c*a^2 < 1 := by nlinarith [mul_pos hc (sq_pos_of_pos ha)]
  have hb2 : b^2=1-c*a^2 := Real.sq_sqrt heps.le
  have hb : 0 < b := Real.sqrt_pos.mpr heps
  have hb1 : b < 1 := by nlinarith
  let h := Real.sqrt (1-b)
  have hh : h^2=1-b := Real.sq_sqrt (by linarith)
  let p : JointFamilyData := {
    n := n, a := a, g := g, w := w, b := b, h := h, c := c
    n_ge_two := hn2, a_pos := ha, a_le_one := ha1, g_ge_one := hg1
    w_pos := inv_pos.mpr hwn
    c_gt_half := by dsimp [c]; linarith
    c_lt_one := hc1, b_pos := hb, b_lt_one := hb1, h_nonneg := Real.sqrt_nonneg _
    column_unit := hunit, mean_unit := hw, defect := by linarith [hb2]
    root := hh, residual_nonneg := ht }
  exact ⟨p, rfl, rfl⟩

end RCProof
