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
| Outcome-count-independent same-label measurement-channel move | **Internally proved theorem candidate** | Exact hybrid dilation realizes F_j=Q_j+R E_j R and gives ν≤2ε≤4(√(1-α²)+√δ), independent of m,d. |
| Extra-outcome gamma=1 closure | **Refuted** | Exact α=1 counterexample gives maximal measurement-channel distance 2 after routing residual to a new projective outcome. |
| Residual spectral radius as independent invariant | **Eliminated** | For residual projector orthogonal to the total near-unit span, \(\rho_{res}\le1-\delta\) automatically; explicit residual completion has \(\gamma_F\ge\delta\). |
| Same-label dimension-free chain | **Internally closed theorem candidate** | ν is outcome-independent and γ_F≥δ, yielding a fully dimension-free composite certificate for the record-structured class. |
| Extra-outcome route forces gamma_F=1 without cost | **Refuted** | Residual-to-reject can be diamond distance 2 even at alpha=1, delta=0. |
| Complete packed sectors (total rank = d) | **Internally closed theorem candidate** | No residual subspace; Naimark move is dimension-free, moved POVM is a PVM, gamma_F=1. |
| Incomplete packed sectors need residual control | **Proved obstruction** | gamma can tend to 0 with alpha=1, delta=0, eta=0, kappa=1. |
| Two pure independent records: (kappa_R=sqrt{1-s^{2R}}) | **Known math / derived RC corollary** | Redundancy certificate. |
| Correlated redundancy always helps | **Refuted** | Common-mode noise can keep (kappa_R) fixed. |
| Record-structured metastability transfer | **Internally proved corollary** | No explicit phase-count dependence inside classical-record subclass. |
| RC is a fundamental theory | **Not established** | No such claim is made. |

## 31 October proof-audit files

- research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md
- theory/packing_conditioned_rounding.md
- theory/dimension_free_nu_via_naimark.md
- research/GAMMA_CLOSURE_AUDIT_2026-10-31.md
- experiments/test_spectral_threshold_rate.py
- experiments/test_dimension_free_naimark.py
- experiments/test_gamma_extra_outcome_counterexample.py

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
