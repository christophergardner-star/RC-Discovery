import RCProof.JointUpper
import RCProof.EnvelopeAnalysis

namespace RCProof
set_option autoImplicit false
open scoped Topology

lemma selected_radius_uniform_bound (a δ : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1)
    (hδ : 0 ≤ δ) (hs : 1 - a ^ 2 + δ ≤ 1 / 4) :
    max (1 - a) ((Real.sqrt (1 - δ))⁻¹ - 1) + (1 - Real.sqrt (1 - δ)) ≤
      2 * (1 - a ^ 2 + δ) := by
  have ha2 : a ^ 2 ≤ 1 := by nlinarith
  have hδ1 : δ ≤ 1 / 4 := by linarith
  let d := Real.sqrt (1 - δ)
  have hd0 : 0 ≤ d := Real.sqrt_nonneg _
  have hd2 : d ^ 2 = 1 - δ := Real.sq_sqrt (by linarith)
  have hd : 3 / 4 ≤ d := by nlinarith
  have hd1 : d ≤ 1 := by nlinarith
  have hdpos : 0 < d := by linarith
  have hroot : 1 - d ≤ δ := by nlinarith
  have hpoly : 0 ≤ (1 - d) * (d ^ 2 + d - 1) :=
    mul_nonneg (by linarith) (by nlinarith)
  have hid : (1 + δ) * d - 1 = (1 - d) * (d ^ 2 + d - 1) := by
    nlinarith [congrArg (fun x : ℝ => x * d) hd2]
  have hinv : d⁻¹ - 1 ≤ δ := by
    have hh : 1 / d ≤ 1 + δ := (div_le_iff₀ hdpos).mpr (by linarith)
    simpa only [one_div] using (show 1 / d - 1 ≤ δ by linarith)
  have hmax : max (1 - a) (d⁻¹ - 1) ≤ 1 - a ^ 2 + δ := by
    apply max_le
    · nlinarith
    · linarith
  change max (1 - a) (d⁻¹ - 1) + (1 - d) ≤ _
  linarith

lemma residual_radius_uniform_bound (ε s : ℝ) (hε : 0 ≤ ε) (hεs : ε ≤ s)
    (hs : s ≤ 1 / 4) :
    2 * Real.sqrt ε / Real.sqrt (4 - ε) ≤ Real.sqrt s + s := by
  have hs0 : 0 ≤ s := hε.trans hεs
  let q := Real.sqrt (4 - ε)
  have hq : 0 < q := Real.sqrt_pos.mpr (by linarith)
  have hq2 : q ^ 2 = 4 - ε := Real.sq_sqrt (by linarith)
  have hprod : 2 ≤ (1 + s) * q := by
    have hp1 : 0 ≤ (s - ε) * (1 + s) ^ 2 := mul_nonneg (by linarith) (sq_nonneg _)
    have hp2 : 0 ≤ s ^ 2 * (1 - s) := mul_nonneg (sq_nonneg _) (by linarith)
    have heq := congrArg (fun x : ℝ => x * (1 + s) ^ 2) hq2
    nlinarith [sq_nonneg ((1 + s) * q - 2)]
  have hratio : 2 / q ≤ 1 + s := (div_le_iff₀ hq).mpr hprod
  have hroots : Real.sqrt ε ≤ Real.sqrt s := Real.sqrt_le_sqrt hεs
  have hsroot : Real.sqrt s ≤ 1 := by
    nlinarith [Real.sq_sqrt hs0, Real.sqrt_nonneg s]
  have hmul := mul_le_mul_of_nonneg_left hratio (Real.sqrt_nonneg ε)
  have hmul2 := mul_le_mul_of_nonneg_right hroots (show 0 ≤ 1 + s by linarith)
  have hmul3 := mul_le_mul_of_nonneg_left hsroot hs0
  change 2 * Real.sqrt ε / q ≤ _
  calc
    _ = Real.sqrt ε * (2 / q) := by ring
    _ ≤ Real.sqrt s * (1 + s) := hmul.trans hmul2
    _ ≤ Real.sqrt s + s := by nlinarith only [hmul3]

theorem joint_scalar_uniform_upper (a δ : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1)
    (hδ : 0 ≤ δ) (hs : 1 - a ^ 2 + δ ≤ 1 / 4) :
    2 * Real.sqrt (1 - a ^ 2 * (1 - δ)) / Real.sqrt (4 - (1 - a ^ 2 * (1 - δ))) +
      2 * (max (1 - a) ((Real.sqrt (1 - δ))⁻¹ - 1) + (1 - Real.sqrt (1 - δ))) ≤
      Real.sqrt (1 - a ^ 2 + δ) + 5 * (1 - a ^ 2 + δ) := by
  have ha2 : a ^ 2 ≤ 1 := by nlinarith
  have hδ1 : δ ≤ 1 / 4 := by linarith
  have hε : 0 ≤ 1 - a ^ 2 * (1 - δ) := by
    nlinarith [mul_nonneg (sq_nonneg a) hδ]
  have hεs : 1 - a ^ 2 * (1 - δ) ≤ 1 - a ^ 2 + δ := by
    nlinarith [mul_nonneg (show 0 ≤ 1 - a ^ 2 by linarith) hδ]
  have hr := residual_radius_uniform_bound _ _ hε hεs hs
  have hc := selected_radius_uniform_bound a δ ha ha1 hδ hs
  linarith

variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]

/-- The actual canonical channel has the uniform upper remainder from the
joint asymptotic theorem. No lower-example or optimality premise is assumed. -/
theorem canonical_joint_uniform_diamond_upper (E : FinitePOVM d o) (c : ℝ)
    (hc : 0 < c) (hc1 : c < 1) [Nonempty (SectorIndex E c)]
    (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (hs : 1 - packingAlpha (canonicalSynthesis E c) ^ 2 + (1 - c) ≤ 1 / 4) :
    let s := 1 - packingAlpha (canonicalSynthesis E c) ^ 2 + (1 - c)
    diamondSize (measurementMap E - measurementMap (canonicalCompletion E c hT)) ≤
      ENNReal.ofReal (Real.sqrt s + 5 * s) := by
  have hu := joint_scalar_uniform_upper (packingAlpha (canonicalSynthesis E c)) (1 - c)
    (packingAlpha_pos _ hT).le (canonical_packing_le_one E c) (by linarith) hs
  have hu' : jointUpper E c ≤ Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2 + (1 - c)) +
      5 * (1 - packingAlpha (canonicalSynthesis E c) ^ 2 + (1 - c)) := by
    simpa only [jointUpper, jointDefect, selectedCorrectionRadius, sub_sub_cancel] using hu
  exact (canonical_joint_diamond_upper E c hc hc1 hT).trans
    (ENNReal.ofReal_le_ofReal ((min_le_right _ _).trans hu'))

end RCProof
