# Research Status Ledger

Updated: 29 October 2026

| Item | Status | Notes |
|---|---|---|
| Almost-idempotent UCP maps induce approximate \(C^*\)-algebra structure | **Known** | Kitaev (2024). |
| General dimension-independent exact rounding fails | **Known / 2026 preprint** | Regular-simplex entanglement-breaking counterexamples. |
| Discrete repeatable POVM iff each nonzero effect has eigenvalue 1 | **Known** | Standard repeatable-measurement theory. |
| Sharp Record-Margin theorem | **Internally proved; provisionally novel** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/\kappa}\). |
| POVM spectral-gap extension | **Internally proved; provisionally novel** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/(\kappa\gamma)}\). |
| Moving-POVM theorem from \(\eta,\kappa\), local accessibility alone | **Refuted** | Constant-channel and regular-simplex obstructions. |
| Record-packing inequality \(\sum_j a_j\le d\) | **Derived elementary lemma** | Forces \(m(1-\epsilon)\le d\). |
| Same-label exact repeatability with \(m>d\) | **Impossible** | At most \(d\) nonzero unit-eigenvalue outcome sectors. |
| Regular-simplex moving-POVM obstruction | **Derived / aligns with known 2026 counterexample mechanism** | Local diagnostics all improve while same-label POVM rounding remains order-one impossible. |
| Binary moving-POVM transfer bound | **Internally proved** | Positive result using reachability plus post-move spectral gap. |
| Two pure independent records: \(\kappa_R=\sqrt{1-s^{2R}}\) | **Known math / derived RC corollary** | Redundancy certificate. |
| Correlated redundancy always helps | **Refuted** | Common-mode noise can keep \(\kappa_R\) fixed. |
| Record-structured metastability transfer | **Internally proved corollary** | No explicit phase-count dependence inside the classical-record subclass. |
| General moving-POVM classification for \(3\le m\le d\) | **Open** | Current top target. |
| RC is a fundamental theory | **Not established** | No such claim is made. |

## Application bridge status

| Item | Status | Notes |
|---|---|---|
| RC-TCL task-horizon affine rounding identity | **Derived elementary result** | Exact for frozen quadratic memory under isolated plain-SGD probe; not claimed novel. |
| Momentum-aware TCL horizon probe | **Computed** | Canonical Split-CIFAR-10 settings give a 50% contraction boundary near total importance (A=0.05521) in the isolated (m=0.9) probe. |
| TCL anchor-conflict variance | **Derived diagnostic** | Detects strongly stable compromise anchors that may represent no stored task. |
| Locked-conflict mass predicts forgetting | **Open empirical hypothesis** | Requires exporting canonical TCL checkpoints/importance maps across runs. |
| "Idempotence in continual learning" as novelty | **Vetoed** | IDER, ICLR 2026, already uses idempotence as a CL principle. |

## RC-TCL smoke-test update — 29 October 2026

| Item | Status | Notes |
|---|---|---|
| Synthetic anchor-conflict smoke test | **Completed** | 80 sequences / 240 scored transitions. |
| "Locked conflict predicts more next-step forgetting" | **Refuted in smoke test** | Immediate forgetting moved in the opposite direction. |
| Locked conflict vs joint accuracy | **Supported in smoke test** | Pearson r = -0.312, p = 7.97e-7; Spearman rho = -0.346, p = 3.73e-8. |
| Shuffled-anchor control | **Signal removed** | Joint-accuracy Pearson r = -0.045, p = 0.49. |
| Shuffled-importance control | **Signal largely remains** | Joint-accuracy Pearson r = -0.286, p = 6.60e-6. |
| Current interpretation | **Revised** | Anchor geometry looks more important than exact ThermalImportance alignment in this toy regime; full canonical TCL/CIFAR test still required. |

