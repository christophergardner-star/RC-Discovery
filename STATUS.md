# Research Status Ledger

Updated: 31 October 2026

This ledger separates mathematical correctness, numerical evidence, formal verification, provenance and novelty. They are not interchangeable.

## Core record-stability results

| Item | Status | Notes |
|---|---|---|
| Sharp Record-Margin theorem | **Internally proved; independent reconstruction passed** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/\kappa}\). Exact prior theorem not located; novelty unverified. |
| POVM spectral-gap extension | **Internally proved; independent reconstruction passed** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/(\kappa\gamma)}\). Novelty unverified. |
| General dimension-free exact rounding of arbitrary almost-idempotent channels | **False / known obstruction** | General negative examples include regular-simplex entanglement-breaking channels. |
| RC as a fundamental physical theory | **Not established** | No such claim is made. |

## Moving-POVM programme

| Item | Status | Notes |
|---|---|---|
| Local diagnostics alone imply nearby repeatability | **Refuted** | Constant-channel and regular-simplex obstructions. |
| Same-label repeatability when \(m>d\) | **Impossible** | At most \(d\) nonzero mutually orthogonal unit sectors. |
| Synthesis conditioner \(\alpha=\sigma_{\min}(T)\) | **Valid conditioning parameter; underlying geometry is prior art** | Detects linear dependence and the simplex endpoint. |
| Polar orthogonalisation of rank-one and higher-rank sectors | **Internally proved / standard machinery** | Polar/Löwdin/fusion-frame ingredients are not claimed as new. |
| Per-sector movement | **Internally proved; stress-tested** | \(\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}\). |
| Same-label completion | **Internally proved** | \(F_j=Q_j+R E_jR\) is a POVM with exact unit sectors. |
| Repeatability gap | **Internally proved** | For full threshold projections, \(\gamma_F\ge\delta\). |
| Linear \(O(\delta)\) movement from threshold data alone | **Refuted** | Explicit perfectly packed family needs \(\Omega(\sqrt\delta)\) movement. |
| Extra-outcome residual dump preserves closeness for free | **Refuted** | Exact counterexample gives measurement-channel distance \(2\). |
| Residual spectral radius as independent missing invariant | **Eliminated** | It is automatically bounded by \(1-\delta\) on the residual complement. |

## Same-label dimension-free theorem candidate

| Component | Status | Notes |
|---|---|---|
| Correct labelled embedding | **Reconciled and explicitly typed** | The theorem uses \(J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)\), not the alternative map embedding polar vectors \(q_j\). |
| Identity \(J_{\mathcal K}^*WU=D|T|\) | **Internally re-derived** | The source counter-check used a different map \(J_q\). |
| Hybrid isometry \(V=J_{\mathcal K}U^*+WR\) | **Internally reconstructed theorem candidate** | Implements \(F_j=Q_j+R E_jR\) exactly. |
| Outcome-count-independent movement | **Analytically refined; internally cross-checked** | \(\nu\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}\). Coefficient 2 not claimed optimal. |
| Composite exact-idempotent certificate | **Repaired; useful explicit examples verified** | Direct record accessibility removes movement from the gap denominator. |
| External specialist verification | **Pending** | Required before publication as an established theorem. |
| Full Lean verification | **Open; operator progress verified** | Four scalar and nine matrix/projection lemmas compile; complete spectral/channel proof remains open. |
| Novelty | **Unverified** | No exact combined theorem located in searches, but absence of prior art is not proved. |

## Numerical evidence

Current proof statements, exact examples and limitations are collected in `research/VERIFIED_PROGRESS_2026-10-31.md` and `research/CERTIFICATE_PROGRESS_2026-10-31.md`.

| Item | Status | Notes |
|---|---|---|
| Record-Margin stress tests | **Passed** | 10,000 random two-record cases; zero violations; analytic equality family. |
| Moving-POVM stress tests | **Passed for implemented families** | Includes simplex obstruction and binary transfer tests. |
| Synthesis-packing tests | **Passed** | 20,000 rank-one and 10,000 higher-rank random cases; zero violations. |
| Same-label hybrid-dilation tests | **Passed for implemented finite examples** | Exact isometry and effect implementation to numerical precision using the direct-sum embedding. |
| SDP validation | **Passed for retained low-dimensional test set** | Paired primal/dual problems and normalization anchors retained with solver diagnostics. |
| Pure-state total-variation proxy | **Evidence only** | Not treated as a full diamond-norm computation. |

## Lean formalisation

| Item | Status |
|---|---|
| `projector_const_one` | **Machine checked; zero `sorry`** |
| `polar_residual_le` | **Machine checked; zero `sorry`** |
| `near_orthonormal_overlap` | **Machine checked; zero `sorry`** |
| `rank1_core_package` | **Machine checked; zero `sorry`** |
| Hilbert-space polar theorem | **Not formalised** |
| Hybrid isometry and label compression | **Machine checked under explicit matrix hypotheses** |
| Residual projection and spectral-envelope compression | **Machine checked; five lemmas** |
| Derivation of all spectral-sector hypotheses | **Not formalised** |
| Diamond-norm transfer and end-to-end certificate | **Not formalised** |

## Prior-art boundary

The following are treated explicitly as prior art and are not claimed by RC-Discovery:

- polar / Löwdin / Fan–Hoffman / Higham orthogonalisation;
- frame and fusion-frame synthesis theory;
- Naimark and Stinespring dilation;
- Kretschmann–Schlingemann–Werner continuity;
- repeatability criteria for discrete POVMs;
- de la Salle and earlier POVM orthogonalisation/projectivisation;
- projective simulation of POVMs, including Kotowski–Oszmaniec;
- Watrous diamond-norm and SDP theory;
- Kitaev's almost-idempotent channel structure;
- the general regular-simplex obstruction.

The only potentially distinct object is the complete, correctly typed synthesis-conditioned same-label chain. It remains **novelty unverified**.

Canonical policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`;
- `literature/NOVELTY_LEDGER.md`;
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`.

## Complete Cruxy source synchronisation

| Item | Status | Notes |
|---|---|---|
| Source repository | **Synced** | `Cruxy234/RC-Packing-Feasible-Note`, branch `main`. |
| Source commit | **Frozen in manifest** | `f94275addb491f1b4be428e2a65939bd4c153897`. |
| Source tree | **Recorded** | `ef0eaf35289b2f489031baaa28163cc2bd97dff0`. |
| Delta from previous import | **Complete** | Six commits; exactly four changed paths, all imported. |
| Root source files | **Hash-identical** | README, REVIEW_REQUEST and STATUS match source blob SHAs. |
| `lean/` subtree | **Hash-identical** | Tree SHA `e2f1ea07c75d82167feb1218d9a8ea8553fa1bdf`. |
| `paper/` subtree | **Hash-identical** | Tree SHA `d6ffe6859cd62a8cbd5a85b2a4e7ab5301b8e9b4`. |
| `theory/` subtree | **Hash-identical** | Tree SHA `7f00df5376076a716dedefb64e61b8bbe434157e`. |
| Canonical promotion | **Audited, not blind** | Source `full_proof.md` is preserved but does not replace the typed coefficient-two canonical theorem. |

Detailed records:

- `imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`;
- `research/CRUXY_SYNC_REPORT_F94275_2026-10-31.md`;
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`.

The imported snapshot is provenance, not canonical truth. It contains exploratory, superseded and contradictory notes.

## RC-TCL application bridge

| Item | Status | Notes |
|---|---|---|
| Task-horizon affine rounding identity | **Derived elementary result** | Exact for frozen quadratic memory under isolated probe dynamics. |
| Anchor-conflict variance | **Derived diagnostic** | Detects stable compromise anchors. |
| “Locked conflict predicts more next-step forgetting” | **Refuted in smoke test** | Immediate forgetting moved in the opposite direction. |
| Locked conflict vs joint accuracy | **Supported in smoke test** | Pearson \(r=-0.312\), \(p=7.97\times10^{-7}\). |
| Idempotence in continual learning as RC novelty | **Vetoed** | Prior work already uses idempotence in continual learning. |

## Doctoral-style consolidation

| Item | Status | Notes |
|---|---|---|
| Doctoral-style monograph | **Pushed** | `paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md`. |
| Theorem v1 freeze | **Pushed** | `theory/THEOREM_V1_FREEZE.md`. |
| External-review packet | **Pushed** | `review/`. |
| Degree status | **Not applicable** | Doctoral-style in depth and structure; not an awarded or examined thesis. |
