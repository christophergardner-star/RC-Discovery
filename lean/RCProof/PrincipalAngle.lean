import RCProof.CanonicalInstrument
import RCProof.PackingParameter
import RCProof.Distance
import Mathlib.Analysis.CStarAlgebra.GelfandDuality
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order

/-! Operator-norm estimates for orthogonal projections and canonical sectors. -/
namespace RCProof
set_option maxHeartbeats 400000
set_option backward.isDefEq.respectTransparency false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

lemma positive_norm_le (A : Matrix d d ℂ) (hA : A.PosSemidef)
    (b : ℝ) (hb : 0 ≤ b) (h : (b • (1 : Matrix d d ℂ) - A).PosSemidef) :
    ‖A‖ ≤ b := by
  apply (CStarAlgebra.norm_le_iff_le_algebraMap A hb hA.nonneg).mpr
  simpa only [Algebra.algebraMap_eq_smul_one] using sub_nonneg.mp h.nonneg

/-- Two-sided compression bounds control the largest principal angle. -/
theorem projection_distance_of_compressions (P Q : Matrix d d ℂ)
    (hP : P.IsHermitian) (hPP : P * P = P)
    (hQ : Q.IsHermitian) (hQQ : Q * Q = Q)
    (b : ℝ) (hb : 0 ≤ b)
    (hPQ : (b • P - (P - P * Q * P)).PosSemidef)
    (hQP : (b • Q - (Q - Q * P * Q)).PosSemidef) :
    ‖P - Q‖ ≤ Real.sqrt b := by
  have hPPa (A : Matrix d d ℂ) : P * (P * A) = P * A := by rw [← Matrix.mul_assoc, hPP]
  have hQQa (A : Matrix d d ℂ) : Q * (Q * A) = Q * A := by rw [← Matrix.mul_assoc, hQQ]
  have hPc : (1 - P).PosSemidef := by
    convert Matrix.posSemidef_conjTranspose_mul_self (1 - P) using 1
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hP.eq]
    noncomm_ring [hPP, hPPa]
  have hQc : (1 - Q).PosSemidef := by
    convert Matrix.posSemidef_conjTranspose_mul_self (1 - Q) using 1
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hQ.eq]
    noncomm_ring [hQQ, hQQa]
  let A := P - P * Q * P
  let B := (1 - P) * Q * (1 - P)
  have hA : A.PosSemidef := by
    convert hQc.conjTranspose_mul_mul_same P using 1
    rw [hP.eq]
    dsimp [A]
    noncomm_ring [hPP, hPPa]
  have hB : B.PosSemidef := by
    have hqpos : Q.PosSemidef := by
      simpa only [hQ.eq, hQQ] using Matrix.posSemidef_conjTranspose_mul_self Q
    have ht := hqpos.conjTranspose_mul_mul_same (1 - P)
    rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hP.eq] at ht
    exact ht
  have hAn : ‖A‖ ≤ b := by
    apply positive_norm_le A hA b hb
    convert hPQ.add (hPc.smul hb) using 1
    dsimp [A]
    module
  have hBn : ‖B‖ ≤ b := by
    have heq : ‖B‖ = ‖Q - Q * P * Q‖ := by
      have hleft : ((1 - P) * Q)ᴴ * ((1 - P) * Q) = Q - Q * P * Q := by
        simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_sub,
          Matrix.conjTranspose_one, hP.eq, hQ.eq]
        noncomm_ring [hPP, hQQ, hPPa, hQQa]
      have hright : (((1 - P) * Q)ᴴ)ᴴ * ((1 - P) * Q)ᴴ = B := by
        simp only [Matrix.conjTranspose_conjTranspose, Matrix.conjTranspose_mul,
          Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hP.eq, hQ.eq]
        dsimp [B]
        noncomm_ring [hQQ, hQQa]
      rw [← hright, Matrix.l2_opNorm_conjTranspose_mul_self,
        Matrix.l2_opNorm_conjTranspose, ← Matrix.l2_opNorm_conjTranspose_mul_self, hleft]
    rw [heq]
    apply positive_norm_le _ (by
      convert hPc.conjTranspose_mul_mul_same Q using 1
      rw [hQ.eq]
      noncomm_ring [hQQ, hQQa]) b hb
    convert hQP.add (hQc.smul hb) using 1
    module
  have hAB : A * B = 0 := by dsimp [A, B]; noncomm_ring [hPP, hPPa]
  have hsq : (P - Q)ᴴ * (P - Q) = A + B := by
    simp only [Matrix.conjTranspose_sub, hP.eq, hQ.eq]
    dsimp [A, B]
    noncomm_ring [hPP, hQQ, hPPa, hQQa]
  have hn : ‖P - Q‖ ^ 2 ≤ b := by
    rw [pow_two, ← Matrix.l2_opNorm_conjTranspose_mul_self, hsq,
      hA.1.isSelfAdjoint.norm_add_eq_max hB.1.isSelfAdjoint hAB]
    exact max_le hAn hBn
  exact (Real.le_sqrt (norm_nonneg _) hb).mpr hn

end RCProof
