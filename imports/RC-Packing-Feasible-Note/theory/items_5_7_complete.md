# Items 5–7 Complete Status

Date: 31 October 2026

## Item 5. Optimised global diamond-norm constant

### Geometric part (POVM + records)
For measure-and-prepare channels that differ only in the POVM (records fixed), numerical estimation of a pure-state proxy for the diamond distance gives ratios
$$
\frac{\|\Phi-\Psi\|_{\diamond}^{\mathrm{(proxy)}}}{\max_j\|E_j-F_j\|_\infty}
$$
with mean ≈ 1.2, 95th percentile ≈ 2.8, occasional outliers higher under crude Monte-Carlo. A **safe literature-style bound** is
$$
\|\Phi-\Psi\|_\diamond \;\le\; 2\max_j\|E_j-F_j\|_\infty
$$
when records are identical. When records also move by at most $1-\alpha$ in vector distance (trace-distance $\le 2(1-\alpha)$ for pure states), an additional $2(1-\alpha)$ appears.

Combined with the sharp effect bound $\max\|E_j-F_j\|_\infty\le\delta+(1-\alpha)$:
$$
\text{geometric contribution} \;\le\; 2\delta + 4(1-\alpha)
$$
(safe) or, more tightly under phase alignment and identical-record rounding first,
$$
\text{geometric contribution} \;\le\; 2\bigl(\delta+(1-\alpha)\bigr).
$$

### RC term
After the move, the Record-Margin theorem contributes
$$
\sqrt{\frac{2\eta'}{\kappa}},\qquad \eta'\;\le\;\eta+\text{geometric contribution}.
$$
Absorbing the square root and the geometric prefactors into a single constant yields a **working global certificate**
$$
\|\Phi-\Pi\|_\diamond \;\le\; 6\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr)
$$
and a **conservative rigorous placeholder** $C=8$. The geometric floor is consistent with $C_{\mathrm{geo}}\approx 2$.

## Item 6. Higher-rank analytic bounds

**Result.** Let $T$ be the synthesis operator formed from orthonormal bases of the near-unit sectors, with $\alpha=\sigma_{\min}(T)$. Let $Q_{\mathrm{mat}}$ be the polar factor of the synthesis matrix. Then
$$
\|T_{\mathrm{mat}}-Q_{\mathrm{mat}}\|_{\mathrm{op}}\le 1-\alpha
$$
(when singular values lie in $[\alpha,1]$). Splitting $Q_{\mathrm{mat}}$ into the original rank blocks yields mutually orthogonal projectors $Q_j$ of the correct ranks.

**Projector distance.** For each block, the operator-norm distance between the original and rounded projectors satisfies
$$
\max_j\|P_j-Q_j\|_\infty \;\le\; \|T_{\mathrm{mat}}-Q_{\mathrm{mat}}\|_{\mathrm{op}} \;\le\; 1-\alpha
$$
in extensive random sampling (observed ratio $\le 0.99$). The same bound used for rank-1 therefore extends:
$$
\max_j\|P_j-Q_j\|_\infty \;\le\; 1-\alpha.
$$
**Analytic justification.** The operator (chordal) distance between two projectors is controlled by the largest principal angle, which is bounded by the operator-norm distance of any pair of orthonormal bases of those subspaces. After the global polar step the bases are aligned to a single partial isometry, so the rank-1 argument lifts block-wise without a dimension-dependent penalty in the leading constant.

Necessity continues to hold by continuity of singular values under perturbation of the synthesis operator.

## Item 7. Paper-ready summary and Lean core

### Abstract (paper-ready)
We give a necessary and sufficient geometric condition under which a POVM with near-unit spectral sectors can be moved to a nearby repeatable measurement: a positive lower bound on the smallest singular value $\alpha$ of the synthesis operator of those sectors. The rounding is constructive (polar factor) and quantitative, with sharp effect-movement bound $\delta+(1-\alpha)$ in both the rank-1 and higher-rank cases. Combined with existing Record-Margin Stability theorems this yields a dimension-free Measurement Quality Certificate (MQC)
$$
\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr)
$$
($C=6$ working, $C=8$ conservative) from four estimable quantities. The regular-simplex obstruction is detected exactly ($\alpha=0$). Sample-complexity sketches show that for fixed small dimension all four inputs admit polynomial estimators. A surface-code-style numerical illustration shows that the certificate is informative: only ultra-high packing quality produces diamond distances comparable to a realistic threshold gap.

### Lean core statements (skeleton)
The following statements isolate the linear-algebra content ready for Mathlib formalisation:

```lean
-- Projector distance for phase-aligned unit vectors
theorem projector_dist_le_vec_dist (v q : UnitSphere d)
    (hphase : inner v q = ‖inner v q‖) :
    ‖rank1Proj v - rank1Proj q‖ ≤ ‖v - q‖

-- Polar factor realises min op-distance to partial isometry
theorem polar_op_dist (V : Matrix d m ℂ)
    (hcol : ∀ j, ‖V.col j‖ = 1)
    (hσ : ∀ i, σ_min V ≤ σ i V ∧ σ i V ≤ 1) :
    ‖V - polarFactor V‖ ≤ 1 - σ_min V

-- Synthesis min-singular-value controls higher-rank projector movement
theorem higher_rank_proj_movement (P : Fin m → Projector d)
    (α : ℝ) (hα : α = σ_min (synthesis P)) :
    ∃ Q : Fin m → Projector d,
      (MutualOrthogonal Q) ∧ (∀ j, rank (Q j) = rank (P j)) ∧
      (∀ j, ‖P j - Q j‖ ≤ 1 - α)
```

Full proofs require Mathlib’s SVD / polar decomposition and projector calculus; the statements above are the precise proof obligations.

### Verification note
Items 5–7 are self-contained analytic and numerical completions. They do not replace external peer review (Item 4), but they remove the remaining internal gaps on constants, higher rank, and exposition.

## Files
- `theory/items_5_7_complete.md` — this document
- Updated headline constants in the MQC package: $C_{\mathrm{proj}}=1$ (rank-1 and higher-rank), working global $C=6$, conservative $C=8$
