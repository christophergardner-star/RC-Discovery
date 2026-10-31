# Research Status Ledger

Updated: 31 October 2026

This ledger separates mathematical correctness, numerical evidence, formal verification, provenance, external review and novelty. They are not interchangeable.

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
| Correct labelled embedding | **Reconciled and explicitly typed** | The theorem uses \(J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)\), not the alternative polar-vector embedding. |
| Identity \(J_{\mathcal K}^*WU=D|T|\) | **Internally re-derived** | Historical source counter-checks used a different map \(J_q\). |
| Hybrid isometry \(V=J_{\mathcal K}U^*+WR\) | **Internally reconstructed theorem candidate** | Implements \(F_j=Q_j+R E_jR\) exactly. |
| Outcome-count-independent movement | **Analytically refined; internally cross-checked** | \(\nu\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}\). Coefficient 2 not claimed optimal. |
| Composite exact-idempotent certificate | **Repaired; useful explicit examples verified** | Direct record accessibility removes movement from the spectral-gap denominator. |
| External specialist verification | **Pending** | Required before presentation as an externally established theorem. |
| Full Lean verification | **Open; operator progress verified** | Scalar and selected matrix/projection lemmas compile; complete spectral/channel proof remains open. |
| Novelty | **Unverified** | No exact combined theorem located in searches, but absence of prior art is not proved. |

## Executable validation

| Item | Status | Notes |
|---|---|---|
| Clean CI quick audit | **Passed** | Theorem algebra, hypotheses, provenance, claim discipline and counterexamples. |
| Clean CI full SDP audit | **Passed** | Fourteen checks, including adversarial families and primal/dual SDPs. |
| Pinned Lean build | **Passed within current scope** | Does not formalise the complete theorem. |
| Frozen theorem contract | **Passed implemented cases** | 8 valid cases, 6 expected rejections, 5 primal/dual SDP checks; maximum identity error \(4.97\times10^{-15}\). |
| Adversarial same-label audit | **Passed implemented cases** | 408 valid cases, 3 expected rejections, 12 SDPs; maximum identity residual \(1.35\times10^{-14}\). |
| Record-accessibility audit | **Passed implemented cases** | 7 exact binary cases, 12 random quantum cases, 26 primal/dual SDPs. |
| Numerical interpretation | **Evidence, not proof** | Passing finite computations do not establish the general theorem, novelty or peer review. |

Canonical validation report:

- `research/PHD_VALIDATION_REPORT_2026-10-31.md`

Canonical local runner:

- `experiments/run_phd_validation.py`

## Lean formalisation

| Item | Status |
|---|---|
| `projector_const_one` | **Machine checked; zero `sorry`** |
| `polar_residual_le` | **Machine checked; zero `sorry`** |
| `near_orthonormal_overlap` | **Machine checked; zero `sorry`** |
| `rank1_core_package` | **Machine checked; zero `sorry`** |
| Hilbert-space polar theorem | **Not formalised** |
| Hybrid isometry and label compression | **Machine checked under explicit matrix hypotheses** |
| Residual projection and spectral-envelope compression | **Machine checked under explicit hypotheses** |
| Derivation of all spectral-sector hypotheses | **Not formalised** |
| Coefficient-two analytic bridge | **Not fully formalised** |
| Diamond-norm transfer and end-to-end certificate | **Not formalised** |

The imported Cruxy Lean files are preserved exactly under `imports/`. They prove elementary algebraic consequences under supplied hypotheses and are not promoted as an end-to-end formalisation.

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

The only potentially distinct object is the complete, correctly typed synthesis-conditioned same-label chain. It remains:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Canonical policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`;
- `literature/NOVELTY_LEDGER.md`;
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`.

## Complete Cruxy source synchronisation

| Item | Status | Notes |
|---|---|---|
| Source repository | **Synced** | `Cruxy234/RC-Packing-Feasible-Note`, branch `main`. |
| Source commit | **Frozen in manifest** | `fcef89be09dd9167a5a94d887e34d5ef1a8d0746`. |
| Source tree | **Recorded** | `2d0e9ef233a39aea8b1555a8d51db31bf934ef44`. |
| Delta from previous import | **Complete** | Ten commits; exactly nine changed paths, all imported. |
| Root source files | **Hash-identical** | NOVELTY_STATEMENT, README, REVIEW_PACKAGE, REVIEW_REQUEST and STATUS match source blob SHAs. |
| `lean/` subtree | **Hash-identical** | Tree SHA `c2b7e33e591d9e89d1859655052d85759352b031`. |
| `paper/` subtree | **Hash-identical** | Tree SHA `23b5f1a2a565d6a578ecc4c751f6a19755d5aeb7`. |
| `theory/` subtree | **Hash-identical** | Tree SHA `7beb09564e84e019160b42f4c674441bb3a3cd28`. |
| Canonical promotion | **Audited, not blind** | New source files are preserved exactly but do not replace stronger typed, coefficient-two, accessibility and validation material. |

Detailed records:

- `imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`;
- `research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md`;
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`.

Important source/canonical distinctions:

- source `NOVELTY_STATEMENT.md` is not adopted as verified novelty;
- source `REVIEW_PACKAGE.md` retains coefficient-four framing;
- source `full_proof.md` uses ambiguous notation for \(J\);
- source `paper/FINAL.md` is useful source material but not the canonical paper;
- source Lean files do not formalise the complete theorem;
- source recheck notes are evidence history, not the canonical executable validation suite.

## Human authorship and AI-provider non-claim boundary

| Item | Status | Notes |
|---|---|---|
| Human research direction | **Christopher Gardner** | Selects questions, controls canonical statements, interprets evidence and controls publication decisions. |
| AI systems | **Research tools only** | Used for assistance with derivation, code, testing, auditing, editing, literature triage and formalisation. |
| AI providers as claimants | **Not designated** | Not designated as authors, inventors, owners, assignees, sponsors, endorsers or claimants. |

Canonical notice:

- `AI_RIGHTS_AND_ATTRIBUTION.md`

This is a repository-governance statement, not a legal opinion or substitute for qualified advice.

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
