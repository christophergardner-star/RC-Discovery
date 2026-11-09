import RCProof.ExactJointUpper

namespace RCProof
set_option autoImplicit false
open Matrix
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
variable {d k o : Type*} [Fintype d] [Fintype k] [Fintype o]
  [DecidableEq d] [DecidableEq k] [DecidableEq o]

lemma polar_eq_of_positive_factor (T V : Matrix d k ℂ) (H : Matrix k k ℂ)
    (hV : Vᴴ * V = 1) (hH : H.PosSemidef) (hf : V * H = T)
    (hT : Function.Injective T.mulVec) : polarIsometry T = V := by
  have hs : H * H = Tᴴ * T := by
    rw [← hf, Matrix.conjTranspose_mul, hH.1.eq]
    calc
      _ = H * (Vᴴ * V) * H := by rw [hV, Matrix.mul_one]
      _ = _ := by simp only [Matrix.mul_assoc]
  have hr : polarRoot T = H := by
    rw [polarRoot, positiveRoot_eq_cfc]
    exact CFC.sqrt_unique hs hH.nonneg
  have hu := polarRoot_det_unit T (Matrix.PosDef.conjTranspose_mul_self T hT)
  rw [hr] at hu
  rw [polarIsometry, hr, ← hf, Matrix.mul_assoc, Matrix.mul_nonsing_inv H hu, Matrix.mul_one]

/-- Exact packing recognition from a positive physical factor and a nonzero
least-eigenvalue projector, without choosing canonical eigenvector phases. -/
theorem packing_eq_of_physical_factor [Nonempty k]
    (T V : Matrix d k ℂ) (D P : Matrix d d ℂ)
    (hV : Vᴴ * V = 1) (hD : D.IsHermitian) (hf : D * V = T)
    (hP : P.IsHermitian) (hPP : P * P = P) (htr : P.trace = 1)
    (hVP : V * Vᴴ * P = P) (a : ℝ) (ha : 0 ≤ a)
    (hDP : D * P = a • P) (hl : (D * D - a ^ 2 • (1 : Matrix d d ℂ)).PosSemidef) :
    packingAlpha T = a := by
  have hg : (Tᴴ * T - a ^ 2 • (1 : Matrix k k ℂ)).PosSemidef := by
    have hh := hl.conjTranspose_mul_mul_same V
    rw [← hf]
    simpa only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul,
      Matrix.conjTranspose_mul, hD.eq, Matrix.mul_one, Matrix.mul_assoc, hV] using hh
  have hlo : a ^ 2 ≤ packingEigenvalue T := by
    have heq : Tᴴ * T - a ^ 2 • (1 : Matrix k k ℂ) =
        inEigenbasis (Matrix.isHermitian_conjTranspose_mul_self T).eigenvectorUnitary
          (fun i => (Matrix.isHermitian_conjTranspose_mul_self T).eigenvalues i - a ^ 2) := by
      rw [inEigenbasis_sub, inEigenbasis_const, ← spectral_representation]
    rw [heq, inEigenbasis_positive_iff] at hg
    apply Finset.le_inf'
    intro i _
    linarith [hg i]
  let Z := Vᴴ * P
  have hZ : Zᴴ * Z = P := by
    dsimp only [Z]
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, hP.eq]
    calc
      _ = P * (V * Vᴴ * P) := by simp only [Matrix.mul_assoc]
      _ = P := by rw [hVP, hPP]
  have hTZ : T * Z = a • P := by
    rw [← hf]
    change D * V * (Vᴴ * P) = a • P
    calc
      _ = D * (V * Vᴴ * P) := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hVP, hDP]
  have heq : Zᴴ * (Tᴴ * T - packingAlpha T ^ 2 • 1) * Z =
      (a ^ 2 - packingAlpha T ^ 2) • P := by
    rw [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one]
    have hprod : Zᴴ * (Tᴴ * T) * Z = (T * Z)ᴴ * (T * Z) := by
      simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
    rw [hprod, hTZ, hZ]
    simp only [Matrix.conjTranspose_smul, star_trivial, hP.eq, Matrix.smul_mul,
      Matrix.mul_smul, smul_smul, hPP, ← pow_two a, sub_smul]
  have hp := (packing_gram_lower T).conjTranspose_mul_mul_same Z
  rw [heq] at hp
  have hu := (Complex.nonneg_iff.mp hp.trace_nonneg).1
  simp only [Matrix.trace_smul, htr, Complex.real_smul, mul_one, Complex.ofReal_re] at hu
  have hsq := packingAlpha_sq T
  have hn : 0 ≤ packingAlpha T := Real.sqrt_nonneg _
  nlinarith

set_option maxHeartbeats 1000000 in
/-- Identify the actual canonical polar sectors after a positive change of
physical coordinates. This removes arbitrary spectral basis phases. -/
theorem canonical_sectors_of_positive_transport (E : FinitePOVM d o) (c : ℝ)
    (D K : Matrix d d ℂ) (Q : o → Matrix d d ℂ)
    (hD : D.PosSemidef) (hK : K.PosSemidef) (hDK : D * K = 1)
    (hQ : ∀ j, (Q j).IsHermitian) (hQQ : ∀ i j, Q i * Q j = if i = j then Q i else 0)
    (hcomm : (∑ j, Q j) * D = D * (∑ j, Q j))
    (hP : ∀ j, thresholdProjector (E.effect j) (E.positive j).1 c = D * Q j * D) :
    Function.Injective (canonicalSynthesis E c).mulVec ∧
      polarIsometry (canonicalSynthesis E c) = K * canonicalSynthesis E c ∧
      ∀ j, sectorProjection E c (polarIsometry (canonicalSynthesis E c)) j = Q j := by
  let T := canonicalSynthesis E c
  let B := canonicalBlock E c
  let P := fun j => thresholdProjector (E.effect j) (E.positive j).1 c
  let V := K * T
  let S := ∑ j, Q j
  have hKD : K * D = 1 := by
    have hh := congrArg Matrix.conjTranspose hDK
    simpa only [Matrix.conjTranspose_mul, hD.1.eq, hK.1.eq, Matrix.conjTranspose_one] using hh
  have hKP (j : o) : K * P j * K = Q j := by
    dsimp only [P]
    rw [hP]
    simp only [← Matrix.mul_assoc, hKD, Matrix.one_mul]
    rw [Matrix.mul_assoc, hDK, Matrix.mul_one]
  have hPKP (j : o) : P j * K * K * P j = P j := by
    dsimp only [P]
    rw [hP]
    calc
      _ = D * Q j * (D * K) * (K * D) * Q j * D := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [hDK, hKD, Matrix.mul_one, Matrix.mul_one, Matrix.mul_assoc D, hQQ j j, if_pos rfl]
  have hPB (j : o) : P j * B j = B j := canonicalBlock_supported E c j
  have hBP (j : o) : (B j)ᴴ * P j = (B j)ᴴ := by
    have hh := congrArg Matrix.conjTranspose (hPB j)
    have hPh : (P j)ᴴ = P j := (thresholdProjector_positive (E.effect j) (E.positive j).1 c).1.eq
    simpa only [Matrix.conjTranspose_mul, hPh] using hh
  have hgram (j : o) : (K * B j)ᴴ * (K * B j) = sectorCoordinate E c j := by
    rw [Matrix.conjTranspose_mul, hK.1.eq]
    calc
      _ = (B j)ᴴ * (P j * K * K * P j) * B j := by
        simp only [← Matrix.mul_assoc, hBP]
        simp only [Matrix.mul_assoc, hPB]
      _ = (B j)ᴴ * B j := by rw [hPKP, Matrix.mul_assoc, hPB]
      _ = _ := canonicalBlock_gram E c j
  have hfull (j : o) : (K * B j) * (K * B j)ᴴ = Q j := by
    rw [Matrix.conjTranspose_mul, hK.1.eq]
    calc
      _ = K * (B j * (B j)ᴴ) * K := by simp only [Matrix.mul_assoc]
      _ = K * P j * K := by rw [canonicalBlock_full]
      _ = _ := hKP j
  have hQC (j : o) : Q j * (K * B j) = K * B j := by
    rw [← hfull, Matrix.mul_assoc, hgram, Matrix.mul_assoc]
    congr 1
    ext i x
    simp [B, canonicalBlock, sectorCoordinate, Matrix.mul_diagonal]
    aesop
  have hCQ (j : o) : (K * B j)ᴴ * Q j = (K * B j)ᴴ := by
    have hh := congrArg Matrix.conjTranspose (hQC j)
    simpa only [Matrix.conjTranspose_mul, (hQ j).eq] using hh
  have hcross (i j : o) : (K * B i)ᴴ * (K * B j) =
      if i = j then sectorCoordinate E c i else 0 := by
    by_cases hij : i = j
    · subst j; simpa using hgram i
    · rw [if_neg hij]
      calc
        _ = ((K * B i)ᴴ * Q i) * (Q j * (K * B j)) := by rw [hCQ, hQC]
        _ = (K * B i)ᴴ * (Q i * Q j) * (K * B j) := by simp only [Matrix.mul_assoc]
        _ = 0 := by rw [hQQ, if_neg hij, Matrix.mul_zero, Matrix.zero_mul]
  have hV : Vᴴ * V = 1 := by
    have heq : V = ∑ j, K * B j := by
      dsimp only [V, T, B]
      rw [← canonicalBlock_sum, Matrix.mul_sum]
    rw [heq]
    simp only [Matrix.conjTranspose_sum, Matrix.sum_mul, Matrix.mul_sum, hcross]
    simpa only [Finset.sum_ite_eq', Finset.mem_univ, if_true] using sectorCoordinate_sum E c
  have hinj : Function.Injective T.mulVec := by
    intro x y hxy
    apply isometry_mulVec_injective V hV
    simp only [V, ← Matrix.mulVec_mulVec, hxy]
  have hVV : V * Vᴴ = S := by
    dsimp only [V, S]
    rw [Matrix.conjTranspose_mul, hK.1.eq]
    calc
      _ = K * (T * Tᴴ) * K := by simp only [Matrix.mul_assoc]
      _ = K * (∑ j, P j) * K := by rw [canonical_range_gram]
      _ = _ := by simp only [Matrix.mul_sum, Matrix.sum_mul, hKP]
  have hSV : S * V = V := by
    rw [← hVV, Matrix.mul_assoc, hV, Matrix.mul_one]
  have hDV : D * V = T := by dsimp [V]; rw [← Matrix.mul_assoc, hDK, Matrix.one_mul]
  have hp : (Vᴴ * D * V).PosSemidef := hD.conjTranspose_mul_mul_same V
  have hf : V * (Vᴴ * D * V) = T := by
    calc
      _ = S * D * V := by rw [← hVV]; simp only [Matrix.mul_assoc]
      _ = D * (S * V) := by rw [hcomm]; simp only [Matrix.mul_assoc]; rfl
      _ = _ := by rw [hSV, hDV]
  have hpolar : polarIsometry T = V := polar_eq_of_positive_factor T V _ hV hp hf hinj
  refine ⟨hinj, hpolar, ?_⟩
  intro j
  rw [hpolar]
  dsimp only [sectorProjection, V]
  rw [Matrix.conjTranspose_mul, hK.1.eq]
  calc
    _ = K * (T * sectorCoordinate E c j * Tᴴ) * K := by simp only [Matrix.mul_assoc]
    _ = K * P j * K := by rw [← canonical_projector_factor]
    _ = _ := hKP j

end RCProof
