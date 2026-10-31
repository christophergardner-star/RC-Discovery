# Research Status Ledger

Updated: 31 October 2026

| Item | Status | Notes |
|---|---|---|
| Almost-idempotent UCP maps induce approximate (C^*)-algebra structure | **Known** | Kitaev (2024). |
| General dimension-independent exact rounding fails | **Known / 2026 preprint** | Regular-simplex entanglement-breaking counterexamples. |
| Discrete repeatable POVM iff each nonzero effect has eigenvalue 1 | **Known** | Standard repeatable-measurement theory. |
| Sharp Record-Margin theorem | **Internally proved; independent reconstruction passed** | (|Phi-Pi|_diamondlesqrt{2eta/kappa}). |
| POVM spectral-gap extension | **Internally proved; independent reconstruction passed** | (|Phi-Pi|_diamondlesqrt{2eta/(kappagamma)}). |
| Moving-POVM theorem from (eta,kappa), local accessibility alone | **Refuted** | Constant-channel and regular-simplex obstructions. |
| Record-packing inequality (sum_j a_jle d) | **Derived elementary lemma** | Forces (m(1-epsilon)le d). |
| Same-label exact repeatability with (m>d) | **Impossible** | At most (d) nonzero unit-eigenvalue outcome sectors. |
| Regular-simplex moving-POVM obstruction | **Derived / aligns with known 2026 counterexample mechanism** | Local diagnostics improve while same-label rounding remains order-one impossible. |
| Binary moving-POVM transfer bound | **Internally proved** | Positive result using reachability plus post-move spectral gap. |
| Synthesis-operator packing conditioner | **Validated geometric invariant** | (alpha=sigma_{min}(T)); polar factor gives simultaneous orthogonalization. |
| Higher-rank polar packing lemma | **Internally proved** | Same synthesis construction works for arbitrary near-unit sector ranks. |

| Per-sector polar movement bound | **Internally proved; numerically stress-tested** | For all ranks, \(\|P_j-R_j\|_\infty\le\sqrt{1-\alpha^2}\); 20k rank-1 + 10k higher-rank random cases gave 0 violations. |
| Repeatability-admissible completion (F_j=R_j+CE_jC) | **Internally proved** | Handles (m<d) without forcing rank-one PVM completeness. |
| Linear (O(delta)) spectral-threshold movement | **Refuted** | Explicit (alpha=1) family requires (Omega(sqrtdelta)) movement. |
| Packing-conditioned many-outcome channel theorem | **Internally proved; non-optimal** | Positive bound with current (m)-dependent measurement-channel perturbation. |
| Outcome-count-independent many-outcome diamond bound | **Open** | Current top mathematical target. |
| Two pure independent records: (kappa_R=sqrt{1-s^{2R}}) | **Known math / derived RC corollary** | Redundancy certificate. |
| Correlated redundancy always helps | **Refuted** | Common-mode noise can keep (kappa_R) fixed. |
| Record-structured metastability transfer | **Internally proved corollary** | No explicit phase-count dependence inside classical-record subclass. |
| RC is a fundamental theory | **Not established** | No such claim is made. |

## 31 October proof-audit files

- research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md
- theory/packing_conditioned_rounding.md
- experiments/test_spectral_threshold_rate.py

## Prior-art warning

The polar orthogonalization step is standard matrix analysis.

POVM projectivization / orthogonalization is also established prior art; de la Salle (2022) is now a mandatory comparison.

The potentially distinct RC contribution is the combination of packing conditioning, repeatability-admissible completion, record-margin/idempotence control, and a diamond-norm channel certificate.

Novelty remains unverified.

## RC-TCL application bridge

| Item | Status | Notes |
|---|---|---|
| RC-TCL task-horizon affine rounding identity | **Derived elementary result** | Exact for frozen quadratic memory under isolated plain-SGD probe; not claimed novel. |
| Momentum-aware TCL horizon probe | **Computed** | Canonical Split-CIFAR-10 settings give a 50% contraction boundary near total importance (A=0.05521). |
| TCL anchor-conflict variance | **Derived diagnostic** | Detects stable compromise anchors that may represent no stored task. |
| “Locked conflict predicts more next-step forgetting” | **Refuted in smoke test** | Immediate forgetting moved in the opposite direction. |
| Locked conflict vs joint accuracy | **Supported in smoke test** | Pearson (r=-0.312), (p=7.97	imes10^{-7}). |
| “Idempotence in continual learning” as novelty | **Vetoed** | IDER, ICLR 2026, already uses idempotence as a CL principle. |
