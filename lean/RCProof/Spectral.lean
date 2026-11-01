import RCProof.Gap

/-! Explicit finite spectral calculus. The threshold projector and positive
square root below are constructed from Mathlib's Hermitian spectral theorem. -/
namespace RCProof
open Matrix Unitary
open scoped ComplexOrder
variable {d : Type*} [Fintype d] [DecidableEq d]

noncomputable def realDiagonal (f : d → ℝ) : Matrix d d ℂ :=
  Matrix.diagonal (fun i => (f i : ℂ))

lemma realDiagonal_mul (f g : d → ℝ) :
    realDiagonal f * realDiagonal g = realDiagonal (fun i => f i * g i) := by
  simp [realDiagonal, Matrix.diagonal_mul_diagonal]

lemma realDiagonal_positive (f : d → ℝ) (hf : ∀ i, 0 ≤ f i) :
    (realDiagonal f).PosSemidef := by
  apply Matrix.posSemidef_diagonal_iff.mpr
  intro i
  exact_mod_cast hf i

noncomputable def inEigenbasis (B : Matrix.unitaryGroup d ℂ) (f : d → ℝ) :
    Matrix d d ℂ := conjStarAlgAut ℝ _ B (realDiagonal f)

lemma inEigenbasis_mul (B : Matrix.unitaryGroup d ℂ) (f g : d → ℝ) :
    inEigenbasis B f * inEigenbasis B g =
      inEigenbasis B (fun i => f i * g i) := by
  simp only [inEigenbasis, ← map_mul, realDiagonal_mul]

lemma inEigenbasis_positive (B : Matrix.unitaryGroup d ℂ) (f : d → ℝ)
    (hf : ∀ i, 0 ≤ f i) : (inEigenbasis B f).PosSemidef := by
  exact (realDiagonal_positive f hf).mul_mul_conjTranspose_same (B : Matrix d d ℂ)

lemma inEigenbasis_one (B : Matrix.unitaryGroup d ℂ) :
    inEigenbasis B (fun _ => 1) = 1 := by
  simp [inEigenbasis, realDiagonal]

lemma inEigenbasis_sub (B : Matrix.unitaryGroup d ℂ) (f g : d → ℝ) :
    inEigenbasis B (fun i => f i - g i) = inEigenbasis B f - inEigenbasis B g := by
  have hd : realDiagonal (fun i => f i - g i) = realDiagonal f - realDiagonal g := by
    ext i j
    simp [realDiagonal, Matrix.diagonal_apply]
    split_ifs <;> simp
  simp only [inEigenbasis, hd, map_sub]

lemma inEigenbasis_add (B : Matrix.unitaryGroup d ℂ) (f g : d → ℝ) :
    inEigenbasis B (fun i => f i + g i) = inEigenbasis B f + inEigenbasis B g := by
  have hd : realDiagonal (fun i => f i + g i) = realDiagonal f + realDiagonal g := by
    ext i j
    simp [realDiagonal, Matrix.diagonal_apply]
    split_ifs <;> simp
  simp only [inEigenbasis, hd, map_add]

lemma inEigenbasis_smul (B : Matrix.unitaryGroup d ℂ) (c : ℝ) (f : d → ℝ) :
    inEigenbasis B (fun i => c * f i) = c • inEigenbasis B f := by
  have hd : realDiagonal (fun i => c * f i) = c • realDiagonal f := by
    ext i j
    simp [realDiagonal, Matrix.diagonal_apply, Complex.real_smul, mul_ite]
  simp only [inEigenbasis, hd, map_smul]

lemma inEigenbasis_positive_iff (B : Matrix.unitaryGroup d ℂ) (f : d → ℝ) :
    (inEigenbasis B f).PosSemidef ↔ ∀ i, 0 ≤ f i := by
  simp [inEigenbasis, Unitary.conjStarAlgAut_apply,
    Unitary.isUnit_coe.posSemidef_star_right_conjugate_iff, realDiagonal,
    Matrix.posSemidef_diagonal_iff]

/-- The full spectral projector, including every eigenvalue at the threshold. -/
noncomputable def thresholdProjector (E : Matrix d d ℂ) (hE : E.IsHermitian)
    (c : ℝ) : Matrix d d ℂ :=
  inEigenbasis hE.eigenvectorUnitary (fun i => if c ≤ hE.eigenvalues i then 1 else 0)

lemma thresholdProjector_positive (E : Matrix d d ℂ) (hE : E.IsHermitian) (c : ℝ) :
    (thresholdProjector E hE c).PosSemidef := by
  apply inEigenbasis_positive
  intro i
  split_ifs <;> norm_num

lemma thresholdProjector_idempotent (E : Matrix d d ℂ) (hE : E.IsHermitian) (c : ℝ) :
    thresholdProjector E hE c * thresholdProjector E hE c =
      thresholdProjector E hE c := by
  unfold thresholdProjector
  rw [inEigenbasis_mul]
  congr 1
  funext i
  split_ifs <;> norm_num

lemma spectral_representation (E : Matrix d d ℂ) (hE : E.IsHermitian) :
    E = inEigenbasis hE.eigenvectorUnitary hE.eigenvalues := by
  exact hE.spectral_theorem

lemma thresholdProjector_commutes (E : Matrix d d ℂ) (hE : E.IsHermitian) (c : ℝ) :
    thresholdProjector E hE c * E = E * thresholdProjector E hE c := by
  conv_lhs => rhs; rw [spectral_representation E hE]
  conv_rhs => lhs; rw [spectral_representation E hE]
  unfold thresholdProjector
  rw [inEigenbasis_mul, inEigenbasis_mul]
  congr 1
  funext i
  exact mul_comm _ _

/-- The spectral upper envelope is proved from the effect bound, not assumed. -/
lemma threshold_spectral_envelope (E : Matrix d d ℂ) (hE : E.IsHermitian)
    (hupper : (1 - E).PosSemidef) (c : ℝ) :
    (thresholdProjector E hE c + c • (1 - thresholdProjector E hE c) - E).PosSemidef := by
  have hrep := spectral_representation E hE
  have hu : ∀ i, hE.eigenvalues i ≤ 1 := by
    have heq : 1 - E = inEigenbasis hE.eigenvectorUnitary (fun i => 1 - hE.eigenvalues i) := by
      rw [inEigenbasis_sub, inEigenbasis_one, ← hrep]
    rw [heq, inEigenbasis_positive_iff] at hupper
    intro i
    linarith [hupper i]
  let f : d → ℝ := fun i => if c ≤ hE.eigenvalues i then 1 else 0
  have hid : thresholdProjector E hE c + c • (1 - thresholdProjector E hE c) - E =
      inEigenbasis hE.eigenvectorUnitary (fun i => f i + c * (1 - f i) - hE.eigenvalues i) := by
    rw [inEigenbasis_sub, inEigenbasis_add, inEigenbasis_smul, inEigenbasis_sub,
      inEigenbasis_one, ← hrep]
    rfl
  rw [hid]
  apply inEigenbasis_positive
  intro i
  dsimp [f]
  split_ifs with hi
  · linarith [hu i]
  · linarith [not_le.mp hi]

lemma threshold_residual_gap (E R : Matrix d d ℂ) (hE : E.IsHermitian)
    (hupper : (1 - E).PosSemidef) (c : ℝ)
    (hR : Rᴴ = R) (hRR : R * R = R)
    (hPR : thresholdProjector E hE c * R = 0) :
    (c • R - R * E * R).PosSemidef :=
  residual_spectral_gap_compression _ E R c hR hRR hPR
    (threshold_spectral_envelope E hE hupper c)

noncomputable def positiveRoot (E : Matrix d d ℂ) (hE : E.PosSemidef) : Matrix d d ℂ :=
  inEigenbasis hE.isHermitian.eigenvectorUnitary (fun i => Real.sqrt (hE.1.eigenvalues i))

lemma positiveRoot_positive (E : Matrix d d ℂ) (hE : E.PosSemidef) :
    (positiveRoot E hE).PosSemidef :=
  inEigenbasis_positive _ _ (fun _ => Real.sqrt_nonneg _)

lemma positiveRoot_square (E : Matrix d d ℂ) (hE : E.PosSemidef) :
    positiveRoot E hE * positiveRoot E hE = E := by
  unfold positiveRoot
  rw [inEigenbasis_mul]
  conv_rhs => rw [spectral_representation E hE.1]
  congr 1
  funext i
  exact Real.mul_self_sqrt (hE.eigenvalues_nonneg i)

lemma positiveRoot_gram (E : Matrix d d ℂ) (hE : E.PosSemidef) :
    (positiveRoot E hE)ᴴ * positiveRoot E hE = E := by
  rw [(positiveRoot_positive E hE).isHermitian.eq, positiveRoot_square]

lemma thresholdProjector_root_commutes (E : Matrix d d ℂ) (hE : E.PosSemidef) (c : ℝ) :
    thresholdProjector E hE.1 c * positiveRoot E hE =
      positiveRoot E hE * thresholdProjector E hE.1 c := by
  unfold thresholdProjector positiveRoot
  rw [inEigenbasis_mul, inEigenbasis_mul]
  congr 1
  funext i
  exact mul_comm _ _

end RCProof
