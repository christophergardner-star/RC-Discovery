import RCProof.PackingParameter
import Mathlib.Analysis.Matrix.Order

/-! Finite matrix maps, arbitrary finite reference amplification and completely
positive measure-and-prepare operations. Complete positivity is proved by an
explicit Kraus representation, not supplied as a hypothesis. -/
namespace RCProof
open Matrix
open scoped ComplexOrder Kronecker
variable {d : Type*} [Fintype d] [DecidableEq d]

abbrev MatrixMap (d : Type*) [Fintype d] := Matrix d d ℂ →ₗ[ℂ] Matrix d d ℂ

def amplify {r : Type*} (Φ : MatrixMap d) (X : Matrix (d × r) (d × r) ℂ) :
    Matrix (d × r) (d × r) ℂ :=
  fun x y => Φ (fun a b => X (a, x.2) (b, y.2)) x.1 y.1

/-- Positivity at every finite matrix level, including arbitrary ancillas by
finite reindexing. The lemmas below directly handle any finite reference type. -/
def CompletelyPositive (Φ : MatrixMap d) : Prop :=
  ∀ n : ℕ, ∀ X : Matrix (d × Fin n) (d × Fin n) ℂ,
    X.PosSemidef → (amplify Φ X).PosSemidef

def krausMap {q : Type*} [Fintype q] (A : q → Matrix d d ℂ) : MatrixMap d where
  toFun X := ∑ i, A i * X * (A i)ᴴ
  map_add' X Y := by simp [Matrix.mul_add, Matrix.add_mul, Finset.sum_add_distrib]
  map_smul' z X := by simp [Matrix.mul_smul, Matrix.smul_mul, Finset.smul_sum]

lemma amplify_kraus {q r : Type*} [Fintype q] [Fintype r] [DecidableEq r]
    (A : q → Matrix d d ℂ) (X : Matrix (d × r) (d × r) ℂ) :
    amplify (krausMap A) X =
      ∑ i, (A i ⊗ₖ (1 : Matrix r r ℂ)) * X * (A i ⊗ₖ (1 : Matrix r r ℂ))ᴴ := by
  ext x y
  simp [amplify, krausMap, Matrix.sum_apply, Matrix.mul_apply, Matrix.conjTranspose_apply,
    Matrix.kroneckerMap_apply, Matrix.kronecker, Matrix.one_apply, Fintype.sum_prod_type,
    apply_ite, mul_ite, ite_mul] <;> rfl

theorem krausMap_amplify_positive {q r : Type*} [Fintype q] [Fintype r] [DecidableEq r]
    (A : q → Matrix d d ℂ) (X : Matrix (d × r) (d × r) ℂ) (hX : X.PosSemidef) :
    (amplify (krausMap A) X).PosSemidef := by
  rw [amplify_kraus]
  exact Matrix.posSemidef_sum _ (fun i _ => hX.mul_mul_conjTranspose_same _)

theorem krausMap_completelyPositive {q : Type*} [Fintype q] (A : q → Matrix d d ℂ) :
    CompletelyPositive (krausMap A) := by
  intro n X hX
  exact krausMap_amplify_positive A X hX

def prepareMap (E τ : Matrix d d ℂ) : MatrixMap d where
  toFun X := (E * X).trace • τ
  map_add' X Y := by simp [Matrix.mul_add, Matrix.trace_add, add_smul]
  map_smul' z X := by simp [Matrix.mul_smul, Matrix.trace_smul, smul_smul]

def prepareKraus (L B : Matrix d d ℂ) (p : d × d) : Matrix d d ℂ :=
  fun a b => L a p.1 * B p.2 b

lemma prepareKraus_output (L B X : Matrix d d ℂ) (p : d × d) (a b : d) :
    (prepareKraus L B p * X * (prepareKraus L B p)ᴴ) a b =
      (B * X * Bᴴ) p.2 p.2 * (L a p.1 * star (L b p.1)) := by
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply, prepareKraus, star_mul,
    Finset.sum_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s _
  apply Finset.sum_congr rfl
  intro r _
  ring

lemma prepareKraus_sum (L B X : Matrix d d ℂ) :
    krausMap (prepareKraus L B) X = (B * X * Bᴴ).trace • (L * Lᴴ) := by
  ext a b
  simp only [krausMap, LinearMap.coe_mk, AddHom.coe_mk, Matrix.sum_apply]
  simp only [prepareKraus_output, Fintype.sum_prod_type]
  rw [Finset.sum_comm]
  simp only [← Finset.mul_sum, ← Finset.sum_mul]
  rfl

theorem prepareMap_eq_kraus (E τ : Matrix d d ℂ) (hE : E.PosSemidef) (hτ : τ.PosSemidef) :
    prepareMap E τ = krausMap (prepareKraus (positiveRoot τ hτ) (positiveRoot E hE)) := by
  apply LinearMap.ext
  intro X
  rw [prepareKraus_sum, Matrix.trace_mul_cycle, positiveRoot_gram,
    (positiveRoot_positive τ hτ).1.eq, positiveRoot_square]
  rfl

theorem prepareMap_amplify_positive {r : Type*} [Fintype r] [DecidableEq r]
    (E τ : Matrix d d ℂ) (hE : E.PosSemidef) (hτ : τ.PosSemidef)
    (X : Matrix (d × r) (d × r) ℂ) (hX : X.PosSemidef) :
    (amplify (prepareMap E τ) X).PosSemidef := by
  rw [prepareMap_eq_kraus E τ hE hτ]
  exact krausMap_amplify_positive _ X hX

theorem prepareMap_completelyPositive (E τ : Matrix d d ℂ)
    (hE : E.PosSemidef) (hτ : τ.PosSemidef) : CompletelyPositive (prepareMap E τ) := by
  intro n X hX
  exact prepareMap_amplify_positive E τ hE hτ X hX

lemma prepareMap_comp (E F τ σ : Matrix d d ℂ) (X : Matrix d d ℂ) :
    prepareMap E τ (prepareMap F σ X) = (E * σ).trace • prepareMap F τ X := by
  simp [prepareMap, Matrix.mul_smul, Matrix.trace_smul, smul_smul, mul_comm]

end RCProof
