import RCProof.Distance
import RCProof.Jordan

/-! Spectral trace-norm formula and contractivity for positive trace-preserving
maps on Hermitian inputs. This does not assume a norm inequality as a premise. -/
namespace RCProof
open Matrix Unitary
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d b : Type*} [Fintype d] [Fintype b] [DecidableEq d] [DecidableEq b]

lemma trace_inEigenbasis (B : Matrix.unitaryGroup d ℂ) (f : d → ℝ) :
    (inEigenbasis B f).trace.re = ∑ i, f i := by
  simp [inEigenbasis, Unitary.conjStarAlgAut_apply, Matrix.trace_mul_cycle,
    Unitary.coe_star_mul_self, realDiagonal, Matrix.trace_diagonal]

noncomputable def hermitianAbs (H : Matrix d d ℂ) (hH : H.IsHermitian) : Matrix d d ℂ :=
  inEigenbasis hH.eigenvectorUnitary (fun i => |hH.eigenvalues i|)

lemma hermitianAbs_positive (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    (hermitianAbs H hH).PosSemidef := inEigenbasis_positive _ _ (fun _ => abs_nonneg _)

lemma hermitianAbs_square (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    hermitianAbs H hH * hermitianAbs H hH = Hᴴ * H := by
  rw [hH.eq]
  unfold hermitianAbs
  rw [inEigenbasis_mul]
  calc
    _ = inEigenbasis hH.eigenvectorUnitary (fun i => hH.eigenvalues i * hH.eigenvalues i) := by
      congr 1
      funext i
      simpa only [pow_two] using sq_abs (hH.eigenvalues i)
    _ = _ := by rw [← inEigenbasis_mul, ← spectral_representation H hH]

lemma traceNorm_hermitian (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    traceNorm H = ∑ i, |hH.eigenvalues i| := by
  have hh := CFC.sqrt_unique (hermitianAbs_square H hH) (hermitianAbs_positive H hH).nonneg
  rw [traceNorm, hh]
  exact trace_inEigenbasis _ _

lemma hermitianAbs_trace (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    (hermitianAbs H hH).trace.re = traceNorm H := by
  rw [traceNorm_hermitian H hH]
  exact trace_inEigenbasis _ _

lemma hermitianAbs_dominates (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    (hermitianAbs H hH - H).PosSemidef ∧ (hermitianAbs H hH + H).PosSemidef := by
  have hm : hermitianAbs H hH - H =
      inEigenbasis hH.eigenvectorUnitary (fun i => |hH.eigenvalues i| - hH.eigenvalues i) := by
    rw [inEigenbasis_sub, ← spectral_representation H hH]; rfl
  have hp : hermitianAbs H hH + H =
      inEigenbasis hH.eigenvectorUnitary (fun i => |hH.eigenvalues i| + hH.eigenvalues i) := by
    rw [inEigenbasis_add, ← spectral_representation H hH]; rfl
  rw [hm, hp]
  exact ⟨inEigenbasis_positive _ _ (fun i => sub_nonneg.mpr (le_abs_self _)),
    inEigenbasis_positive _ _ (fun i => by linarith [neg_le_abs (hH.eigenvalues i)])⟩

theorem traceNorm_le_trace_of_dominates (H A : Matrix d d ℂ) (hH : H.IsHermitian)
    (hm : (A - H).PosSemidef) (hp : (A + H).PosSemidef) :
    traceNorm H ≤ A.trace.re := by
  let B : Matrix.unitaryGroup d ℂ := hH.eigenvectorUnitary
  have hd : (B : Matrix d d ℂ)ᴴ * H * (B : Matrix d d ℂ) = realDiagonal hH.eigenvalues := by
    simpa [B, Unitary.conjStarAlgAut_apply, realDiagonal, Matrix.star_eq_conjTranspose,
      Function.comp_def] using
      hH.conjStarAlgAut_star_eigenvectorUnitary
  have hm' := hm.conjTranspose_mul_mul_same (B : Matrix d d ℂ)
  have hp' := hp.conjTranspose_mul_mul_same (B : Matrix d d ℂ)
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_add, Matrix.add_mul, hd] at hm' hp'
  have hdiag : ∀ i, |hH.eigenvalues i| ≤ (((B : Matrix d d ℂ)ᴴ * A * B) i i).re := by
    intro i
    have hmre := (Complex.nonneg_iff.mp (hm'.diag_nonneg (i := i))).1
    have hpre := (Complex.nonneg_iff.mp (hp'.diag_nonneg (i := i))).1
    simp only [Matrix.sub_apply, Matrix.add_apply, realDiagonal, Matrix.diagonal_apply_eq,
      Complex.sub_re, Complex.add_re, Complex.ofReal_re] at hmre hpre
    exact abs_le.mpr ⟨by linarith, by linarith⟩
  rw [traceNorm_hermitian H hH]
  calc
    _ ≤ ∑ i, (((B : Matrix d d ℂ)ᴴ * A * B) i i).re := Finset.sum_le_sum (fun i _ => hdiag i)
    _ = (((B : Matrix d d ℂ)ᴴ * A * B).trace).re := by simp [Matrix.trace]
    _ = A.trace.re := by
      have hBB : (B : Matrix d d ℂ) * (B : Matrix d d ℂ)ᴴ = 1 := Unitary.coe_mul_star_self B
      rw [Matrix.trace_mul_cycle, hBB, Matrix.one_mul]

theorem traceNorm_contracts_hermitian (Φ : RectMatrixMap d b)
    (hpos : ∀ A, A.PosSemidef → (Φ A).PosSemidef)
    (htrace : ∀ A, (Φ A).trace = A.trace) (H : Matrix d d ℂ) (hH : H.IsHermitian) :
    traceNorm (Φ H) ≤ traceNorm H := by
  obtain ⟨hm, hp⟩ := hermitianAbs_dominates H hH
  have hm' := hpos _ hm
  have hp' := hpos _ hp
  rw [map_sub] at hm'
  rw [map_add] at hp'
  have ha' := hpos _ (hermitianAbs_positive H hH)
  have hherm : (Φ H).IsHermitian := by
    have hh := hp'.1.sub ha'.1
    simpa only [add_sub_cancel_left] using hh
  calc
    _ ≤ (Φ (hermitianAbs H hH)).trace.re := traceNorm_le_trace_of_dominates _ _ hherm hm' hp'
    _ = _ := by rw [htrace, hermitianAbs_trace]

end RCProof
