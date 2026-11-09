import RCProof.JointFamilySectors
import Mathlib.LinearAlgebra.Matrix.Reindex

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d e o q : Type*} [Fintype d] [Fintype e] [Fintype o] [Fintype q]
  [DecidableEq d] [DecidableEq e] [DecidableEq o] [DecidableEq q]

noncomputable def matrixRelabel (s : d ≃ e) : Matrix d d ℂ ≃ₐ[ℝ] Matrix e e ℂ :=
  Matrix.reindexAlgEquiv ℝ ℂ s

lemma matrixRelabel_positive (s : d ≃ e) (A : Matrix d d ℂ) (hA : A.PosSemidef) :
    (matrixRelabel s A).PosSemidef := hA.submatrix s.symm

lemma matrixRelabel_adjoint (s : d ≃ e) (A : Matrix d d ℂ) :
    matrixRelabel s Aᴴ = (matrixRelabel s A)ᴴ := by ext i j; rfl

lemma matrixRelabel_hermitian (s : d ≃ e) (A : Matrix d d ℂ) (hA : A.IsHermitian) :
    (matrixRelabel s A).IsHermitian := by
  change (matrixRelabel s A)ᴴ=matrixRelabel s A
  rw [← matrixRelabel_adjoint, hA.eq]

lemma matrixRelabel_trace (s : d ≃ e) (A : Matrix d d ℂ) :
    (matrixRelabel s A).trace=A.trace := by
  exact s.symm.sum_comp (fun i => A i i)

lemma matrixRelabel_sum (s : d ≃ e) (t : o ≃ q) (A : o → Matrix d d ℂ) :
    (∑ j : q, matrixRelabel s (A (t.symm j)))=matrixRelabel s (∑ j, A j) := by
  rw [← map_sum]
  congr 1
  exact t.symm.sum_comp A

noncomputable def relabelPOVM (s : d ≃ e) (t : o ≃ q) (E : FinitePOVM d o) : FinitePOVM e q where
  effect j := matrixRelabel s (E.effect (t.symm j))
  positive j := matrixRelabel_positive s _ (E.positive _)
  normalized := by rw [matrixRelabel_sum, E.normalized, map_one]

/-- Isolated spectral sectors can be recognized after a change of finite
coordinates without making a choice of transported eigenvectors. -/
lemma relabel_isolated_sector (s : d ≃ e) (A P : Matrix d d ℂ)
    (hA : A.IsHermitian) (hP : P.PosSemidef) (hPP : P*P=P)
    (ell r c : ℝ) (hr : r<c) (hc : c≤ell) (hAP : A*P=ell • P)
    (hbound : (ell • P+r • (1-P)-A).PosSemidef) :
    thresholdProjector (matrixRelabel s A) (matrixRelabel_hermitian s A hA) c=matrixRelabel s P := by
  apply thresholdProjector_eq_of_isolated_projection _ _ _ (matrixRelabel_positive s P hP)
    (by rw [← map_mul, hPP]) ell r c hr hc
  · rw [← map_mul, hAP, map_smul]
  · have hh := matrixRelabel_positive s _ hbound
    simpa only [map_sub, map_add, map_smul, map_one] using hh

end RCProof
