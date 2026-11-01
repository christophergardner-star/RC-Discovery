import RCProof.Instrument
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Data.ENNReal.BigOperators

/-! Trace norm and the full stabilized induced trace-norm target. The final
measurement-channel bound is proved in FrozenDiamond using these definitions. -/
namespace RCProof
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d b : Type*} [Fintype d] [Fintype b] [DecidableEq d] [DecidableEq b]

noncomputable def traceNorm (A : Matrix d d ℂ) : ℝ := (CFC.sqrt (Aᴴ * A)).trace.re

lemma positiveRoot_eq_cfc (A : Matrix d d ℂ) (hA : A.PosSemidef) :
    positiveRoot A hA = CFC.sqrt A :=
  (CFC.sqrt_unique (positiveRoot_square A hA) (positiveRoot_positive A hA).nonneg).symm

lemma traceNorm_nonneg (A : Matrix d d ℂ) : 0 ≤ traceNorm A := by
  have hp : (CFC.sqrt (Aᴴ * A)).PosSemidef := (CFC.sqrt_nonneg _).posSemidef
  exact (Complex.nonneg_iff.mp hp.trace_nonneg).1

lemma traceNorm_positive (A : Matrix d d ℂ) (hA : A.PosSemidef) : traceNorm A = A.trace.re := by
  rw [traceNorm, hA.1.eq, CFC.sqrt_mul_self A hA.nonneg]

@[simp] lemma traceNorm_zero : traceNorm (0 : Matrix d d ℂ) = 0 := by
  simp [traceNorm]

lemma traceNorm_neg (A : Matrix d d ℂ) : traceNorm (-A) = traceNorm A := by
  simp [traceNorm]

abbrev RectMatrixMap (d b : Type*) := Matrix d d ℂ →ₗ[ℂ] Matrix b b ℂ

def amplifyRect {r : Type*} (Φ : RectMatrixMap d b) (X : Matrix (d × r) (d × r) ℂ) :
    Matrix (b × r) (b × r) ℂ := fun x y => Φ (fun a a' => X (a, x.2) (a', y.2)) x.1 y.1

lemma amplifyRect_zero {r : Type*} (X : Matrix (d × r) (d × r) ℂ) :
    amplifyRect (0 : RectMatrixMap d b) X = 0 := by
  ext x y
  rfl

/-- Unhalved completely bounded induced trace norm: every finite ancilla and
every complex input matrix of trace norm at most one. Extended nonnegative
reals avoid assuming boundedness before it has been proved. -/
noncomputable def diamondSize (Φ : RectMatrixMap d b) : ENNReal :=
  ⨆ n : ℕ, ⨆ X : Matrix (d × Fin n) (d × Fin n) ℂ,
    ⨆ (_h : traceNorm X ≤ 1), ENNReal.ofReal (traceNorm (amplifyRect Φ X))

/-- General supremum rule used by MeasurementDistance after proving the
all-complex-input estimate. No pure-state reduction is assumed here. -/
lemma diamondSize_le_of_all_inputs (Φ : RectMatrixMap d b) (B : ℝ)
    (h : ∀ n (X : Matrix (d × Fin n) (d × Fin n) ℂ), traceNorm X ≤ 1 →
      traceNorm (amplifyRect Φ X) ≤ B) : diamondSize Φ ≤ ENNReal.ofReal B := by
  apply iSup_le
  intro n
  apply iSup_le
  intro X
  apply iSup_le
  intro hX
  exact ENNReal.ofReal_le_ofReal (h n X hX)

@[simp] lemma diamondSize_zero : diamondSize (0 : RectMatrixMap d b) = 0 := by
  simp [diamondSize, amplifyRect_zero, traceNorm_zero]

variable {o : Type*} [Fintype o] [DecidableEq o]

def measurementMap (E : FinitePOVM d o) : RectMatrixMap d o where
  toFun X := Matrix.diagonal (fun j => (E.effect j * X).trace)
  map_add' X Y := by
    ext i j
    simp [Matrix.mul_add, Matrix.trace_add, Matrix.diagonal_apply]
    split_ifs <;> simp
  map_smul' z X := by
    ext i j
    simp [Matrix.mul_smul, Matrix.trace_smul, Matrix.diagonal_apply] <;> split_ifs <;> simp

lemma measurementMap_trace_preserving (E : FinitePOVM d o) (X : Matrix d d ℂ) :
    (measurementMap E X).trace = X.trace := by
  change (Matrix.diagonal (fun j => (E.effect j * X).trace)).trace = X.trace
  rw [Matrix.trace_diagonal, ← Matrix.trace_sum, ← Matrix.sum_mul, E.normalized, Matrix.one_mul]

end RCProof
