import RCProof.PrincipalAngle
import Mathlib.LinearAlgebra.Matrix.Rank

namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

theorem partial_frame_angle (X Y : Matrix d k ℂ) (C G : Matrix k k ℂ)
    (hC : C.IsHermitian) (hCC : C * C = C)
    (hX : Xᴴ * X = C) (hY : Yᴴ * Y = C)
    (hXC : X * C = X) (hYC : Y * C = Y)
    (hG : G.IsHermitian) (hCG : C * G = G) (hXY : Xᴴ * Y = G)
    (a : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1) (hlower : (G - a • C).PosSemidef) :
    ‖X * Xᴴ - Y * Yᴴ‖ ≤ Real.sqrt (1 - a ^ 2) := by
  have hGC : G * C = G := by
    have hh := congrArg Matrix.conjTranspose hCG
    simpa only [Matrix.conjTranspose_mul, hC.eq, hG.eq] using hh
  have hYX : Yᴴ * X = G := by
    have hh := congrArg Matrix.conjTranspose hXY
    simpa only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, hG.eq] using hh
  have hGG : (G * G - a ^ 2 • C).PosSemidef := by
    have hs := Matrix.posSemidef_conjTranspose_mul_self (G - a • C)
    have ht := hs.add (hlower.smul (show 0 ≤ 2 * a by positivity))
    convert ht using 1
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
      star_trivial, hG.eq, hC.eq, Matrix.mul_sub, Matrix.sub_mul,
      Matrix.mul_smul, Matrix.smul_mul, smul_smul, hCG, hGC, hCC]
    module
  have hPP : (X * Xᴴ) * (X * Xᴴ) = X * Xᴴ := by
    calc
      _ = (X * (Xᴴ * X)) * Xᴴ := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hX, hXC]
  have hQQ : (Y * Yᴴ) * (Y * Yᴴ) = Y * Yᴴ := by
    calc
      _ = (Y * (Yᴴ * Y)) * Yᴴ := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hY, hYC]
  apply projection_distance_of_compressions _ _ (Matrix.isHermitian_mul_conjTranspose_self X)
    hPP (Matrix.isHermitian_mul_conjTranspose_self Y) hQQ (1 - a ^ 2) (by nlinarith)
  · have hp := hGG.mul_mul_conjTranspose_same X
    have heq : (X * Xᴴ) * (Y * Yᴴ) * (X * Xᴴ) = X * (G * G) * Xᴴ := by
      calc
        _ = X * ((Xᴴ * Y) * (Yᴴ * X)) * Xᴴ := by simp only [Matrix.mul_assoc]
        _ = _ := by rw [hXY, hYX]
    rw [heq]
    convert hp using 1
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, hXC]
    module
  · have hp := hGG.mul_mul_conjTranspose_same Y
    have heq : (Y * Yᴴ) * (X * Xᴴ) * (Y * Yᴴ) = Y * (G * G) * Yᴴ := by
      calc
        _ = Y * ((Yᴴ * X) * (Xᴴ * Y)) * Yᴴ := by simp only [Matrix.mul_assoc]
        _ = _ := by rw [hXY, hYX]
    rw [heq]
    convert hp using 1
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, hYC]
    module

variable {o : Type*} [Fintype o] [DecidableEq o]

/-- The frozen theorem's same-label principal-angle bound, for every outcome,
including empty sectors. The packing parameter is the defined least singular value. -/
theorem canonical_principal_angle (E : FinitePOVM d o) (c : ℝ)
    [Nonempty (SectorIndex E c)] (hT : Function.Injective (canonicalSynthesis E c).mulVec)
    (j : o) :
    ‖thresholdProjector (E.effect j) (E.positive j).1 c -
      sectorProjection E c (polarIsometry (canonicalSynthesis E c)) j‖ ≤
      Real.sqrt (1 - packingAlpha (canonicalSynthesis E c) ^ 2) := by
  let T := canonicalSynthesis E c
  let U := polarIsometry T
  let H := polarRoot T
  let C := sectorCoordinate E c j
  let X := canonicalBlock E c j
  let Y := U * C
  have hpd := Matrix.PosDef.conjTranspose_mul_self T hT
  have hU : Uᴴ * U = 1 := polarIsometry_isometry T hpd
  have hfactor : U * H = T := polar_factorization T hpd
  have hCpos : C.PosSemidef := by
    simpa only [canonicalFrame_coordinates] using (canonicalFrame E c).coordinates.positive j
  have hCC : C * C = C := by
    exact (sectorCoordinate_mul E c j j).trans (if_pos rfl)
  have hXC : X * C = X := by
    dsimp [X, C]
    rw [canonicalBlock_factor, Matrix.mul_assoc]
    rw [show sectorCoordinate E c j * sectorCoordinate E c j = sectorCoordinate E c j from hCC]
  have hYC : Y * C = Y := by dsimp [Y]; rw [Matrix.mul_assoc, hCC]
  have hY : Yᴴ * Y = C := by
    dsimp [Y]
    rw [Matrix.conjTranspose_mul, hCpos.1.eq]
    calc
      _ = C * (Uᴴ * U) * C := by simp only [Matrix.mul_assoc]
      _ = C := by rw [hU, Matrix.mul_one, hCC]
  have hXfactor : X = U * H * C := by rw [hfactor]; exact canonicalBlock_factor E c j
  have hXY : Xᴴ * Y = C * H * C := by
    rw [hXfactor, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul,
      hCpos.1.eq, polarRoot_hermitian]
    change C * (H * Uᴴ) * (U * C) = C * H * C
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc Uᴴ U, hU, Matrix.one_mul]
  have hG : (C * H * C).IsHermitian := by
    have hp : H.PosSemidef := positiveRoot_positive _ _
    have hh := hp.conjTranspose_mul_mul_same C
    rw [hCpos.1.eq] at hh
    exact hh.1
  have hCG : C * (C * H * C) = C * H * C := by
    simp only [← Matrix.mul_assoc, hCC]
  have hlower : (C * H * C - packingAlpha T • C).PosSemidef := by
    have hp := (packing_polar_lower T).conjTranspose_mul_mul_same C
    rw [hCpos.1.eq, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul,
      Matrix.smul_mul, Matrix.mul_one, hCC] at hp
    exact hp
  have h := partial_frame_angle X Y C (C * H * C) hCpos.1 hCC
    (canonicalBlock_gram E c j) hY hXC hYC hG hCG hXY
    (packingAlpha T) (Real.sqrt_nonneg _) (canonical_packing_le_one E c) hlower
  have hXX : X * Xᴴ = thresholdProjector (E.effect j) (E.positive j).1 c :=
    canonicalBlock_full E c j
  have hYY : Y * Yᴴ = sectorProjection E c U j := by
    change (U * C) * (U * C)ᴴ = U * C * Uᴴ
    rw [Matrix.conjTranspose_mul, hCpos.1.eq]
    rw [← Matrix.mul_assoc, Matrix.mul_assoc U C C, hCC]
  rw [hXX, hYY] at h
  exact h

theorem canonical_sector_rank (E : FinitePOVM d o) (c : ℝ)
    (hT : Function.Injective (canonicalSynthesis E c).mulVec) (j : o) :
    (thresholdProjector (E.effect j) (E.positive j).1 c).rank =
      (sectorProjection E c (polarIsometry (canonicalSynthesis E c)) j).rank := by
  let U := polarIsometry (canonicalSynthesis E c)
  let C := sectorCoordinate E c j
  have hU : Uᴴ * U = 1 := polarIsometry_isometry _ (Matrix.PosDef.conjTranspose_mul_self _ hT)
  have hC : C.IsHermitian := by
    have hp := (canonicalFrame E c).coordinates.positive j
    rw [canonicalFrame_coordinates] at hp
    exact hp.1
  have hCC : C * C = C := (sectorCoordinate_mul E c j j).trans (if_pos rfl)
  have hY : (U * C)ᴴ * (U * C) = C := by
    rw [Matrix.conjTranspose_mul, hC.eq]
    calc
      _ = C * (Uᴴ * U) * C := by simp only [Matrix.mul_assoc]
      _ = C := by rw [hU, Matrix.mul_one, hCC]
  have hYY : (U * C) * (U * C)ᴴ = sectorProjection E c U j := by
    change (U * C) * (U * C)ᴴ = U * C * Uᴴ
    rw [Matrix.conjTranspose_mul, hC.eq, ← Matrix.mul_assoc, Matrix.mul_assoc U C C, hCC]
  rw [← canonicalBlock_full, Matrix.rank_self_mul_conjTranspose,
    ← Matrix.rank_conjTranspose_mul_self (canonicalBlock E c j), canonicalBlock_gram,
    ← hYY, Matrix.rank_self_mul_conjTranspose, ← Matrix.rank_conjTranspose_mul_self (U * C), hY]

end RCProof
