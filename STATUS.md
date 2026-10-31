# Research Status Ledger

Updated: 31 October 2026

This ledger separates mathematical correctness, numerical evidence, formal verification, and novelty. They are not interchangeable.

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
| Synthesis-operator packing conditioner \(\alpha=\sigma_{\min}(T)\) | **Valid conditioning parameter; underlying frame geometry is prior art** | Detects linear dependence and the simplex endpoint. |
| Polar orthogonalisation of rank-one and higher-rank sectors | **Internally proved / standard machinery** | Polar/Löwdin/fusion-frame ingredients are not claimed as new. |
| Per-sector movement | **Internally proved; stress-tested** | \(\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}\). |
| Same-label completion | **Internally proved** | \(F_j=Q_j+R E_jR\) is a POVM with exact unit sectors. |
| Repeatability gap of same-label completion | **Internally proved** | For full threshold projections, \(\gamma_F\ge\delta\). |
| Linear \(O(\delta)\) movement from threshold data alone | **Refuted** | Explicit perfectly packed family needs \(\Omega(\sqrt\delta)\) movement. |
| Extra-outcome residual dump preserves closeness for free | **Refuted** | Exact counterexample gives measurement-channel distance \(2\). |
| Residual spectral radius as an independent missing invariant | **Eliminated** | It is automatically bounded by \(1-\delta\) on the residual complement. |

## Same-label dimension-free theorem candidate

| Component | Status | Notes |
|---|---|---|
| Correct labelled embedding | **Reconciled and explicitly typed** | The theorem uses \(J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)\), not the alternative map embedding polar vectors \(q_j\). |
| Identity \(J_{\mathcal K}^*WU=D|T|\) | **Internally re-derived** | The Cruxy source counter-check used a different map \(J_q\); it does not refute the typed identity. |
| Hybrid isometry \(V=J_{\mathcal K}U^*+WR\) | **Internally reconstructed theorem candidate** | Implements \(F_j=Q_j+R E_jR\) exactly. |
| Outcome-count-independent measurement move | **Internally reconstructed theorem candidate** | \(\nu\le2\varepsilon\le4(\sqrt{1-\alpha^2}+\sqrt\delta)\), with no explicit \(m,d\) factor. |
| Composite exact-idempotent certificate | **Internally closed theorem candidate** | \(\|\Phi_E-\Pi\|_\diamond\le\nu+\sqrt{2(\eta+3\nu)/(\kappa\delta)}\). |
| External specialist verification | **Pending** | Required before publication as an established theorem. |
| Full Lean verification | **Open** | Current Lean work covers only scalar algebraic lemmas. |
| Novelty | **Unverified** | No exact combined theorem located in searches, but absence of prior art is not proved. |

## Numerical evidence

| Item | Status | Notes |
|---|---|---|
| Record-Margin stress tests | **Passed** | 10,000 random two-record cases; zero violations; analytic equality family. |
| Moving-POVM stress tests | **Passed for implemented families** | Includes simplex obstruction and binary transfer tests. |
| Synthesis-packing tests | **Passed** | 20,000 rank-one and 10,000 higher-rank random cases; zero violations. |
| Same-label hybrid-dilation tests | **Passed for implemented finite examples** | Exact isometry and effect implementation to numerical precision using the direct-sum embedding. |
| Pure-state total-variation proxy | **Evidence only** | It is not treated as a full diamond-norm computation; ancilla assistance can matter in measurement/channel discrimination. |

## Lean formalisation

| Item | Status |
|---|---|
| `projector_const_one` | **Machine checked; zero `sorry`** |
| `polar_residual_le` | **Machine checked; zero `sorry`** |
| `near_orthonormal_overlap` | **Machine checked; zero `sorry`** |
| `rank1_core_package` | **Machine checked; zero `sorry`** |
| Hilbert-space polar theorem | **Not formalised** |
| Typed hybrid isometry | **Not formalised** |
| Diamond-norm transfer and composite theorem | **Not formalised** |

## Prior-art boundary

The following are explicitly treated as prior art and are not claimed by RC-Discovery:

- polar / Löwdin / Fan–Hoffman / Higham orthogonalisation and nearest-isometry results;
- frame and fusion-frame synthesis-operator theory;
- Naimark and Stinespring dilation;
- Kretschmann–Schlingemann–Werner continuity;
- repeatability criteria for discrete POVMs;
- de la Salle and earlier POVM orthogonalisation/projectivisation;
- projective simulation of POVMs, including Kotowski–Oszmaniec's dimension-deficient Naimark theorem;
- Watrous diamond-norm and SDP theory;
- Kitaev's almost-idempotent channel structure;
- the general regular-simplex obstruction to exact rounding.

Canonical policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`

The only potentially distinct object is the complete, correctly typed synthesis-conditioned same-label chain. It remains **novelty-unverified**.

## Refreshed Cruxy source merge

Exact source snapshot:

- source: `Cruxy234/RC-Packing-Feasible-Note`
- source commit: `78be7962931f9f95e6e6aecd93f4dde00c3fe14d`
- imported path: `imports/RC-Packing-Feasible-Note/`

The imported snapshot is provenance, not canonical truth. It contains exploratory, superseded, and contradictory notes.

Canonical reconciliation:

- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`
- `theory/same_label_dimension_free_theorem.md`
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`

## RC-TCL application bridge

| Item | Status | Notes |
|---|---|---|
| Task-horizon affine rounding identity | **Derived elementary result** | Exact for frozen quadratic memory under isolated probe dynamics. |
| Anchor-conflict variance | **Derived diagnostic** | Detects stable compromise anchors. |
| “Locked conflict predicts more next-step forgetting” | **Refuted in smoke test** | Immediate forgetting moved in the opposite direction. |
| Locked conflict vs joint accuracy | **Supported in smoke test** | Pearson \(r=-0.312\), \(p=7.97\times10^{-7}\). |
| Idempotence in continual learning as an RC novelty | **Vetoed** | IDER and other prior work already use idempotence in continual learning. |
