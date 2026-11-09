import RCProof.JointFamilyRelabel
import RCProof.JointFamilyParameters

namespace RCProof
set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator

lemma measurement_difference_test_trace {d o : Type*} [Fintype d] [Fintype o]
    [DecidableEq d] [DecidableEq o] (E F : FinitePOVM d o) (X : Matrix d d ℂ) (z : o → ℝ) :
    (((measurementMap E-measurementMap F) X)*realDiagonal z).trace=
      ∑ j, ((E.effect j-F.effect j)*X).trace*(z j : ℂ) := by
  simp [measurementMap, realDiagonal, Matrix.trace, Matrix.mul_diagonal,
    Matrix.diagonal_apply, Matrix.sub_mul, Matrix.sub_apply, Finset.sum_sub_distrib]

namespace JointFamilyData
variable (p : JointFamilyData) {e q : Type*} [Fintype e] [Fintype q]
  [DecidableEq e] [DecidableEq q] (s : JointDim p.n ≃ e) (t : JointLabels p.n ≃ q)

theorem relabel_attaining_test :
    (((measurementMap (relabelPOVM s t p.povm)-measurementMap
      (canonicalCompletion (relabelPOVM s t p.povm) p.c (p.relabel_transport s t).1))
      (matrixRelabel s p.state))*realDiagonal (fun j => p.testSigns (t.symm j))).trace=
      (perfectEnvelope p.b : ℂ) := by
  rw [measurement_difference_test_trace]
  simp only [p.relabel_completion]
  change (∑ j : q, ((matrixRelabel s (p.povm.effect (t.symm j))-
    matrixRelabel s ((canonicalCompletion p.povm p.c p.canonical_transport.1).effect (t.symm j)))*
    matrixRelabel s p.state).trace*(p.testSigns (t.symm j) : ℂ)) = _
  simp only [← map_sub, ← map_mul, matrixRelabel_trace]
  rw [t.symm.sum_comp (fun j => ((p.povm.effect j-
    (canonicalCompletion p.povm p.c p.canonical_transport.1).effect j)*p.state).trace*(p.testSigns j : ℂ))]
  have hh := p.attaining_test
  change (((measurementMap p.povm-measurementMap (canonicalCompletion p.povm p.c p.canonical_transport.1))
    p.state)*realDiagonal p.testSigns).trace=_ at hh
  rwa [measurement_difference_test_trace] at hh

theorem relabel_diamond_attains :
    diamondSize (measurementMap (relabelPOVM s t p.povm)-measurementMap
      (canonicalCompletion (relabelPOVM s t p.povm) p.c (p.relabel_transport s t).1))=
      ENNReal.ofReal (perfectEnvelope p.b) := by
  letI := p.relabel_sectors_nonempty s t
  have hdef : jointDefect (relabelPOVM s t p.povm) p.c=p.b^2 := by
    unfold jointDefect
    rw [p.relabel_packing_exact]
    nlinarith [p.defect]
  apply le_antisymm
  · have hh := canonical_exact_joint_diamond_upper (relabelPOVM s t p.povm) p.c
      (by linarith [p.c_gt_half]) p.c_lt_one (p.relabel_transport s t).1
    simpa only [hdef, Real.sqrt_sq p.b_pos.le] using hh
  · have htest : ‖realDiagonal (fun j => p.testSigns (t.symm j))‖ ≤ 1 := by
      apply realDiagonal_sign_contraction
      intro j
      rcases t.symm j with i | i
      · norm_num [testSigns]
      · dsimp only [testSigns, Sum.elim_inr]
        split_ifs <;> norm_num
    have hh := diamondSize_ge_state_test
      (measurementMap (relabelPOVM s t p.povm)-measurementMap
        (canonicalCompletion (relabelPOVM s t p.povm) p.c (p.relabel_transport s t).1))
      (matrixRelabel s p.state) (matrixRelabel_positive s _ p.state_positive)
      (by rw [matrixRelabel_trace, p.state_trace])
      (realDiagonal (fun j => p.testSigns (t.symm j))) htest
    rw [p.relabel_attaining_test, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (show 0<perfectEnvelope p.b from div_pos (by linarith [p.b_pos]) (by linarith [p.b_lt_one]))] at hh
    exact hh

/-- The same attaining family is placed in the pre-existing finite-indexed
admissible class. No enlargement of the worst-case domain is used. -/
noncomputable def packed : PackedMeasurement p.a (1-p.c) where
  dimension := Fintype.card (JointDim p.n)
  outcomes := Fintype.card (JointLabels p.n)
  povm := relabelPOVM (Fintype.equivFin _) (Fintype.equivFin _) p.povm
  sectors_nonempty := by
    simpa only [sub_sub_cancel] using p.relabel_sectors_nonempty (Fintype.equivFin _) (Fintype.equivFin _)
  synthesis_injective := by
    rw [sub_sub_cancel]
    exact (p.relabel_transport (Fintype.equivFin _) (Fintype.equivFin _)).1
  exact_alpha := by
    letI : Nonempty (SectorIndex (relabelPOVM (Fintype.equivFin _) (Fintype.equivFin _) p.povm)
        (1-(1-p.c))) := by
      simpa only [sub_sub_cancel] using p.relabel_sectors_nonempty (Fintype.equivFin _) (Fintype.equivFin _)
    have ht (c : ℝ) (hc : c=p.c)
        [Nonempty (SectorIndex (relabelPOVM (Fintype.equivFin _) (Fintype.equivFin _) p.povm) c)] :
        packingAlpha (canonicalSynthesis (relabelPOVM (Fintype.equivFin _) (Fintype.equivFin _) p.povm) c)=p.a := by
      subst c
      exact p.relabel_packing_exact (Fintype.equivFin _) (Fintype.equivFin _)
    exact ht _ (sub_sub_cancel _ _)
  active_sector := by
    intro j _
    simpa only [sub_sub_cancel] using p.relabel_sector_nonzero (Fintype.equivFin _) (Fintype.equivFin _) j

theorem packed_distance : packedDistance p.packed=ENNReal.ofReal (perfectEnvelope p.b) := by
  unfold packedDistance packed
  simpa only [sub_sub_cancel] using p.relabel_diamond_attains (Fintype.equivFin _) (Fintype.equivFin _)

end JointFamilyData

/-- Exact finite-error optimum over the original admissible class of finite
POVMs, for every positive packing parameter and 0<delta<1/2. -/
theorem packingWorstCase_exact_joint (a δ : ℝ) (ha : 0<a) (ha1 : a≤1)
    (hδ : 0<δ) (hδ2 : δ<1/2) :
    packingWorstCase a δ=ENNReal.ofReal (perfectEnvelope (Real.sqrt (1-a^2*(1-δ)))) := by
  apply le_antisymm (packingWorstCase_exact_joint_upper a δ hδ hδ2)
  obtain ⟨p, hpa, hpc⟩ := exists_jointFamilyData a δ ha ha1 hδ hδ2
  have hb : Real.sqrt (1-a^2*(1-δ))=p.b := by
    have hh : 1-a^2*(1-δ)=p.b^2 := by rw [← hpa, ← hpc]; nlinarith [p.defect]
    rw [hh, Real.sqrt_sq p.b_pos.le]
  have hl := packedDistance_le_worstCase p.packed
  rw [p.packed_distance, hpa, hpc, sub_sub_cancel] at hl
  simpa only [hb] using hl

end RCProof
