import RCProof.PrincipalAngle
import RCProof.TraceNorm

/-! Trace-norm duality for arbitrary complex matrices, including singular ones.
The polar witness uses the spectral pseudoinverse, not an invertibility premise. -/
namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k : Type*} [Fintype d] [Fintype k] [DecidableEq d] [DecidableEq k]

lemma norm_le_of_gram (A : Matrix d k ℂ) (b : ℝ) (hb : 0 ≤ b)
    (h : (b ^ 2 • (1 : Matrix k k ℂ) - Aᴴ * A).PosSemidef) : ‖A‖ ≤ b := by
  have hn := positive_norm_le _ (Matrix.posSemidef_conjTranspose_mul_self A)
    (b ^ 2) (sq_nonneg b) h
  rw [Matrix.l2_opNorm_conjTranspose_mul_self] at hn
  nlinarith [norm_nonneg A]

lemma gram_bound_of_norm (A : Matrix d k ℂ) (b : ℝ) (hb : 0 ≤ b) (h : ‖A‖ ≤ b) :
    (b ^ 2 • (1 : Matrix k k ℂ) - Aᴴ * A).PosSemidef := by
  apply Matrix.le_iff.mp
  rw [← Algebra.algebraMap_eq_smul_one]
  apply (CStarAlgebra.norm_le_iff_le_algebraMap _ (sq_nonneg b)
    (Matrix.posSemidef_conjTranspose_mul_self A).nonneg).mp
  rw [Matrix.l2_opNorm_conjTranspose_mul_self]
  nlinarith [norm_nonneg A]

theorem exists_contraction_polar (X : Matrix k d ℂ) :
    ∃ W : Matrix k d ℂ, ‖W‖ ≤ 1 ∧
      X = W * positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X) ∧
      Wᴴ * W * positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X) =
        positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X) := by
  let H := positiveRoot (Xᴴ * X) (Matrix.posSemidef_conjTranspose_mul_self X)
  have hH : H.PosSemidef := positiveRoot_positive _ _
  have hHH : H * H = Xᴴ * X := positiveRoot_square _ _
  let B := hH.1.eigenvectorUnitary
  let f := hH.1.eigenvalues
  let S := inEigenbasis B (fun i => (f i)⁻¹)
  let Z := inEigenbasis B (fun i => (f i)⁻¹ * f i)
  have hrep : H = inEigenbasis B f := spectral_representation H hH.1
  have hS : S.PosSemidef := inEigenbasis_positive _ _ (fun i => inv_nonneg.mpr (hH.eigenvalues_nonneg i))
  have hSH : S * H = Z := by rw [hrep, inEigenbasis_mul]
  have hZH : Z * H = H := by
    rw [hrep, inEigenbasis_mul]
    congr 1
    funext i
    dsimp [f]
    by_cases hi : hH.1.eigenvalues i = 0 <;> simp [hi]
  have hHS : H * S = Z := by
    rw [hrep, inEigenbasis_mul]
    congr 1
    funext i
    exact mul_comm _ _
  have hSS : S * (Xᴴ * X) * S = Z := by
    rw [← hHH, ← Matrix.mul_assoc, hSH, Matrix.mul_assoc, hHS]
    dsimp [Z]
    rw [inEigenbasis_mul]
    congr 1
    funext i
    by_cases hi : f i = 0 <;> simp [hi]
  have hZle : (1 - Z).PosSemidef := by
    rw [← inEigenbasis_one B, ← inEigenbasis_sub]
    apply inEigenbasis_positive
    intro i
    by_cases hi : f i = 0 <;> simp [hi]
  have hnull : X * (1 - S * H) = 0 := by
    apply (Matrix.conjTranspose_mul_self_mul_eq_zero X _).mp
    rw [Matrix.mul_sub, Matrix.mul_one, ← hHH]
    have hz : (H * H) * (S * H) = H * H := by
      rw [Matrix.mul_assoc H H, ← Matrix.mul_assoc H S, hHS, hZH]
    rw [hz, sub_self]
  have hfactor : X = (X * S) * H := by
    rw [Matrix.mul_sub, Matrix.mul_one, ← Matrix.mul_assoc] at hnull
    exact sub_eq_zero.mp hnull
  have hgram : (X * S)ᴴ * (X * S) = Z := by
    rw [Matrix.conjTranspose_mul, hS.1.eq]
    calc
      _ = S * (Xᴴ * X) * S := by simp only [Matrix.mul_assoc]
      _ = Z := hSS
  refine ⟨X * S, ?_, hfactor, ?_⟩
  · apply norm_le_of_gram _ 1 zero_le_one
    simpa only [one_pow, one_smul, hgram] using hZle
  · rw [hgram]
    exact hZH

end RCProof
