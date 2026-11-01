import RCProof.Spectral
import RCProof.Completion

/-! The labelled Naimark isometry is constructed from the positive square
roots of a finite POVM; its label compressions recover the original effects. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d o : Type*} [Fintype d] [Fintype o] [DecidableEq d] [DecidableEq o]
variable {k l : Type*} [Fintype k] [Fintype l] [DecidableEq k] [DecidableEq l]

def stack (A : o → Matrix d k ℂ) : Matrix (o × d) k ℂ := fun x b => A x.1 x.2 b

def labelProjection (j : o) : Matrix (o × d) (o × d) ℂ :=
  Matrix.diagonal (fun x => if x.1 = j then 1 else 0)

lemma stack_gram (A : o → Matrix d k ℂ) :
    (stack A)ᴴ * stack A = ∑ j, (A j)ᴴ * A j := by
  ext a b
  simp [Matrix.mul_apply, Matrix.conjTranspose_apply, stack, Fintype.sum_prod_type,
    Matrix.sum_apply]

lemma labelProjection_positive (j : o) : (labelProjection (d := d) j).PosSemidef := by
  apply Matrix.posSemidef_diagonal_iff.mpr
  intro x
  split_ifs <;> simp

lemma labelProjection_idempotent (j : o) :
    labelProjection (d := d) j * labelProjection j = labelProjection j := by
  simp only [labelProjection, Matrix.diagonal_mul_diagonal]
  congr 1
  funext x
  split_ifs <;> simp

lemma labelProjection_sum : ∑ j : o, labelProjection (d := d) j = 1 := by
  ext x y
  simp [labelProjection, Matrix.sum_apply, Matrix.diagonal_apply, Matrix.one_apply]

lemma stack_label_compression (A : o → Matrix d k ℂ) (j : o) :
    (stack A)ᴴ * labelProjection j * stack A = (A j)ᴴ * A j := by
  ext a b
  simp [Matrix.mul_apply, Matrix.conjTranspose_apply, labelProjection, stack,
    Matrix.diagonal_apply, Fintype.sum_prod_type]

lemma stack_cross (A : o → Matrix d k ℂ) (B : o → Matrix d l ℂ) :
    (stack A)ᴴ * stack B = ∑ j, (A j)ᴴ * B j := by
  ext a b
  simp [Matrix.mul_apply, Matrix.conjTranspose_apply, stack, Fintype.sum_prod_type,
    Matrix.sum_apply]

lemma stack_label_cross (A : o → Matrix d k ℂ) (B : o → Matrix d l ℂ) (j : o) :
    (stack A)ᴴ * labelProjection j * stack B = (A j)ᴴ * B j := by
  ext a b
  simp [Matrix.mul_apply, Matrix.conjTranspose_apply, labelProjection, stack,
    Matrix.diagonal_apply, Fintype.sum_prod_type]

noncomputable def naimark (E : FinitePOVM d o) : Matrix (o × d) d ℂ :=
  stack (fun j => positiveRoot (E.effect j) (E.positive j))

lemma naimark_isometry (E : FinitePOVM d o) : (naimark E)ᴴ * naimark E = 1 := by
  rw [naimark, stack_gram]
  simp only [positiveRoot_gram]
  exact E.normalized

lemma naimark_compression (E : FinitePOVM d o) (j : o) :
    (naimark E)ᴴ * labelProjection j * naimark E = E.effect j := by
  rw [naimark, stack_label_compression, positiveRoot_gram]

end RCProof
