import RCProof.Gap

/-! POVM normalization and exact sector action of the prescribed completion.
This layer takes the synthesis isometry and coordinate projections as input;
it does not assume positivity or normalization of the completed effects. -/
namespace RCProof
open Matrix
open scoped ComplexOrder
variable {d k o : Type*} [Fintype d] [Fintype k] [Fintype o]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]

structure FinitePOVM (d o : Type*) [Fintype d] [Fintype o] [DecidableEq d] where
  effect : o → Matrix d d ℂ
  positive : ∀ j, (effect j).PosSemidef
  normalized : ∑ j, effect j = 1

lemma FinitePOVM.effect_le_one (E : FinitePOVM d o) (j : o) :
    ((1 : Matrix d d ℂ) - E.effect j).PosSemidef := by
  have hp := Matrix.posSemidef_sum (Finset.univ.erase j) (fun i _ => E.positive i)
  have heq : ∑ i ∈ Finset.univ.erase j, E.effect i = 1 - E.effect j := by
    apply eq_sub_of_add_eq
    rw [Finset.sum_erase_add _ _ (Finset.mem_univ j), E.normalized]
  rwa [heq] at hp

def completedEffect (U : Matrix d k ℂ) (C : Matrix k k ℂ) (E : Matrix d d ℂ) :
    Matrix d d ℂ := U * C * Uᴴ + (1 - U * Uᴴ) * E * (1 - U * Uᴴ)

lemma residual_annihilates_isometry (U : Matrix d k ℂ) (hU : Uᴴ * U = 1) :
    (1 - U * Uᴴ) * U = 0 := by
  rw [Matrix.sub_mul, Matrix.one_mul, Matrix.mul_assoc, hU, Matrix.mul_one, sub_self]

lemma completedEffect_positive (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C : Matrix k k ℂ) (E : Matrix d d ℂ) (hC : C.PosSemidef) (hE : E.PosSemidef) :
    (completedEffect U C E).PosSemidef := by
  obtain ⟨hR, _, _⟩ := residual_projection_properties U hU
  exact (hC.mul_mul_conjTranspose_same U).add (residual_effect_positive E _ hR hE)

lemma completedEffect_sum (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C : o → Matrix k k ℂ) (E : o → Matrix d d ℂ)
    (hC : ∑ j, C j = 1) (hE : ∑ j, E j = 1) :
    ∑ j, completedEffect U (C j) (E j) = 1 := by
  obtain ⟨_, hRR, _⟩ := residual_projection_properties U hU
  simp only [completedEffect, Finset.sum_add_distrib, ← Matrix.sum_mul, ← Matrix.mul_sum]
  rw [hC, hE, Matrix.mul_one, Matrix.mul_one, hRR]
  abel

def completedPOVM (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C : FinitePOVM k o) (E : FinitePOVM d o) : FinitePOVM d o where
  effect j := completedEffect U (C.effect j) (E.effect j)
  positive j := completedEffect_positive U hU _ _ (C.positive j) (E.positive j)
  normalized := completedEffect_sum U hU _ _ C.normalized E.normalized

/-- Exact same-label action, including zero-dimensional coordinate sectors. -/
lemma completedEffect_on_sector (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C B : Matrix k k ℂ) (E : Matrix d d ℂ) :
    completedEffect U C E * (U * B * Uᴴ) = U * (C * B) * Uᴴ := by
  have hz := residual_annihilates_isometry U hU
  unfold completedEffect
  rw [Matrix.add_mul]
  have ha : U * C * Uᴴ * (U * B * Uᴴ) = U * (C * B) * Uᴴ := by
    calc
      _ = U * C * (Uᴴ * U) * B * Uᴴ := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hU, Matrix.mul_one]; simp only [Matrix.mul_assoc]
  have hb : (1 - U * Uᴴ) * E * (1 - U * Uᴴ) * (U * B * Uᴴ) = 0 := by
    calc
      _ = (1 - U * Uᴴ) * E * ((1 - U * Uᴴ) * U) * B * Uᴴ := by
        simp only [Matrix.mul_assoc]
      _ = 0 := by rw [hz]; simp
  rw [ha, hb, add_zero]

lemma completedEffect_unit_sector (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C : Matrix k k ℂ) (E : Matrix d d ℂ) (hC : C * C = C) :
    completedEffect U C E * (U * C * Uᴴ) = U * C * Uᴴ := by
  rw [completedEffect_on_sector U hU, hC]

lemma completedEffect_other_sector (U : Matrix d k ℂ) (hU : Uᴴ * U = 1)
    (C B : Matrix k k ℂ) (E : Matrix d d ℂ) (hCB : C * B = 0) :
    completedEffect U C E * (U * B * Uᴴ) = 0 := by
  rw [completedEffect_on_sector U hU, hCB, Matrix.mul_zero, Matrix.zero_mul]

end RCProof
