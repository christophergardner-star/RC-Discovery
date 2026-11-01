import RCProof.Spectral

/-! A finite-matrix proof of the Jordan-product estimate used in the paper.
No commutation between the two positive matrices is assumed. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d : Type*} [Fintype d] [DecidableEq d]

lemma inEigenbasis_const (B : Matrix.unitaryGroup d ℂ) (c : ℝ) :
    inEigenbasis B (fun _ => c) = c • (1 : Matrix d d ℂ) := by
  simpa only [mul_one, inEigenbasis_one] using
    inEigenbasis_smul B c (fun _ => 1)

lemma eigenvalues_le_of_upper (X : Matrix d d ℂ) (hX : X.IsHermitian) (h : ℝ)
    (hu : (h • (1 : Matrix d d ℂ) - X).PosSemidef) :
    ∀ i, hX.eigenvalues i ≤ h := by
  have heq : h • (1 : Matrix d d ℂ) - X =
      inEigenbasis hX.eigenvectorUnitary (fun i => h - hX.eigenvalues i) := by
    rw [inEigenbasis_sub, inEigenbasis_const, ← spectral_representation X hX]
  rw [heq, inEigenbasis_positive_iff] at hu
  intro i
  linarith [hu i]

lemma positive_square_upper (X : Matrix d d ℂ) (hX : X.PosSemidef) (h : ℝ)
    (hu : (h • (1 : Matrix d d ℂ) - X).PosSemidef) :
    (h • X - X * X).PosSemidef := by
  have heq : h • X - X * X =
      inEigenbasis hX.1.eigenvectorUnitary
        (fun i => h * hX.1.eigenvalues i - hX.1.eigenvalues i * hX.1.eigenvalues i) := by
    rw [inEigenbasis_sub, inEigenbasis_smul, ← inEigenbasis_mul,
      ← spectral_representation X hX.1]
  rw [heq]
  apply inEigenbasis_positive
  intro i
  have hl := hX.eigenvalues_nonneg i
  have hh := eigenvalues_le_of_upper X hX.1 h hu i
  nlinarith [mul_nonneg hl (sub_nonneg.mpr hh)]

/-- Positivity of a square plus the two spectral square bounds controls the
anticommutator. `X` and `Y` need not commute. -/
lemma anticommutator_lower (X Y : Matrix d d ℂ) (hX : X.PosSemidef)
    (hY : Y.PosSemidef) (h r s : ℝ) (hs : 0 < s)
    (hXu : (h • (1 : Matrix d d ℂ) - X).PosSemidef)
    (hYu : (r • (1 : Matrix d d ℂ) - Y).PosSemidef) :
    (X * Y + Y * X + (s * h) • X + (r / s) • Y).PosSemidef := by
  have hXX := (positive_square_upper X hX h hXu).smul hs.le
  have hYY := (positive_square_upper Y hY r hYu).smul (inv_nonneg.mpr hs.le)
  have hZ : (s • X + Y)ᴴ = s • X + Y := by
    simp [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, hX.1.eq, hY.1.eq]
  have hZZ := (Matrix.posSemidef_conjTranspose_mul_self (s • X + Y)).smul
    (inv_nonneg.mpr hs.le)
  rw [hZ] at hZZ
  have hp := (hZZ.add hXX).add hYY
  have hid : s⁻¹ • ((s • X + Y) * (s • X + Y)) +
      s • (h • X - X * X) + s⁻¹ • (r • Y - Y * Y) =
      X * Y + Y * X + (s * h) • X + (r / s) • Y := by
    simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul,
      smul_add, smul_sub, smul_smul]
    have hs0 : s ≠ 0 := ne_of_gt hs
    simp only [inv_mul_cancel₀ hs0, inv_mul_cancel_left₀ hs0, one_smul]
    module
  rwa [hid] at hp

lemma jordan_lower_with_scale (H D : Matrix d d ℂ) (a b M s : ℝ)
    (hX : (H - a • (1 : Matrix d d ℂ)).PosSemidef)
    (hY : (D - b • (1 : Matrix d d ℂ)).PosSemidef)
    (hH : (M • (1 : Matrix d d ℂ) - H).PosSemidef)
    (hD : ((1 : Matrix d d ℂ) - D).PosSemidef)
    (hs : 0 < s) (hleft : s * (M - a) ≤ 2 * b)
    (hright : (1 - b) / s ≤ 2 * a) :
    (H * D + D * H - (2 * a * b) • (1 : Matrix d d ℂ)).PosSemidef := by
  let X := H - a • (1 : Matrix d d ℂ)
  let Y := D - b • (1 : Matrix d d ℂ)
  have hXu : ((M - a) • (1 : Matrix d d ℂ) - X).PosSemidef := by
    convert hH using 1 <;> dsimp [X] <;> module
  have hYu : ((1 - b) • (1 : Matrix d d ℂ) - Y).PosSemidef := by
    convert hD using 1 <;> dsimp [Y] <;> module
  have hp := anticommutator_lower X Y hX hY (M - a) (1 - b) s hs hXu hYu
  have hxp := hX.smul (sub_nonneg.mpr hleft)
  have hyp := hY.smul (sub_nonneg.mpr hright)
  have hall := (hp.add hxp).add hyp
  have hid : X * Y + Y * X + (s * (M - a)) • X + ((1 - b) / s) • Y +
      (2 * b - s * (M - a)) • X + (2 * a - (1 - b) / s) • Y =
      H * D + D * H - (2 * a * b) • (1 : Matrix d d ℂ) := by
    dsimp [X, Y]
    simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.smul_mul, Matrix.mul_smul,
      Matrix.one_mul, Matrix.mul_one, smul_sub, smul_smul]
    module
  rwa [hid] at hall

lemma positive_eq_zero_of_nonpositive (X : Matrix d d ℂ)
    (hX : X.PosSemidef) (hn : (-X).PosSemidef) : X = 0 := by
  apply hX.1.eigenvalues_eq_zero_iff.mp
  funext i
  have hu : ((0 : ℝ) • (1 : Matrix d d ℂ) - X).PosSemidef := by simpa using hn
  exact le_antisymm (eigenvalues_le_of_upper X hX.1 0 hu i) (hX.eigenvalues_nonneg i)

/-- The paper's width criterion, including the degenerate `M = a` case. -/
theorem jordan_lower_of_width (H D : Matrix d d ℂ) (a b M : ℝ)
    (ha : 0 ≤ a) (hb : 0 < b) (hMa : a ≤ M)
    (hX : (H - a • (1 : Matrix d d ℂ)).PosSemidef)
    (hY : (D - b • (1 : Matrix d d ℂ)).PosSemidef)
    (hH : (M • (1 : Matrix d d ℂ) - H).PosSemidef)
    (hD : ((1 : Matrix d d ℂ) - D).PosSemidef)
    (hwidth : (M - a) * (1 - b) ≤ 4 * a * b) :
    ((1 / 2 : ℝ) • (H * D + D * H) - (a * b) • (1 : Matrix d d ℂ)).PosSemidef := by
  have htwice : (H * D + D * H - (2 * a * b) • (1 : Matrix d d ℂ)).PosSemidef := by
    rcases eq_or_lt_of_le hMa with heq | hlt
    · have hn : (-(H - a • (1 : Matrix d d ℂ))).PosSemidef := by
        simpa only [← heq, neg_sub] using hH
      have hh := sub_eq_zero.mp (positive_eq_zero_of_nonpositive _ hX hn)
      have hp := hY.smul (by positivity : 0 ≤ 2 * a)
      rw [hh]
      convert hp using 1
      simp only [Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, Matrix.mul_one,
        smul_sub, smul_smul]
      module
    · have hgap : 0 < M - a := sub_pos.mpr hlt
      have hs : 0 < 2 * b / (M - a) := div_pos (by positivity) hgap
      apply jordan_lower_with_scale H D a b M (2 * b / (M - a)) hX hY hH hD hs
      · rw [div_mul_cancel₀ _ (ne_of_gt hgap)]
      · apply (div_le_iff₀ hs).mpr
        rw [← mul_div_assoc]
        apply (le_div_iff₀ hgap).mpr
        nlinarith [hwidth]
  have hp := htwice.smul (by norm_num : (0 : ℝ) ≤ 1 / 2)
  convert hp using 1 <;> module

end RCProof
