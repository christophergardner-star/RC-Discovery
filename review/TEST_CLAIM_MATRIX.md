# Test-to-Claim Matrix

**Purpose:** map every executable check to the precise mathematical statement it supports, while recording what it does **not** establish.

A test result is evidence only. The analytic and formal proof obligations remain separate.

| Claim or risk | Primary analytic source | Executable checks | What a pass supports | What a pass does not prove |
|---|---|---|---|---|
| POVM normalization and positivity | `theory/THEOREM_V1_FREEZE.md` | `test_theorem_v1_contract.py`, `test_adversarial_same_label.py` | Implemented inputs are valid finite POVMs to tolerance | All mathematical POVMs satisfy later conclusions |
| Every nonzero label has a near-unit sector | Frozen theorem hypotheses | `test_theorem_v1_contract.py` expected rejections | Code rejects missing-sector inputs and includes threshold endpoint | The hypothesis is physically natural or necessary in every application |
| Total packed rank cannot exceed dimension | Packing geometry | `test_theorem_v1_contract.py`, `test_moving_povm.py` | Capacity obstruction is enforced | A quantitative converse for all near-singular families |
| Synthesis injectivity \(\alpha>0\) | `theory/packing_conditioned_rounding.md` | `test_synthesis_packing.py`, `test_theorem_v1_contract.py` | Singular and near-singular finite cases behave as expected | Novelty of using the synthesis condition |
| Polar sectors are orthogonal | Standard polar/fusion-frame geometry | `test_synthesis_packing.py`, `test_theorem_v1_contract.py` | Numerical polar factor is isometric and sectors are orthogonal | Standard polar theory itself, which is prior art |
| Per-sector movement \(\|P_j-Q_j\|\le\sqrt{1-\alpha^2}\) | Canonical packing theorem | `test_synthesis_packing.py`, `test_theorem_v1_contract.py` | Bound holds across implemented rank-one and higher-rank cases | Optimality for all sector families |
| Same-label completion is a POVM | Canonical same-label theorem | `test_same_label_hybrid_dilation.py`, `test_theorem_v1_contract.py` | \(F_j\ge0\), \(\sum F_j=I\) numerically | End-to-end formal proof |
| Exact repeatable-sector action | Canonical same-label theorem | same as above | \(F_iQ_j=\delta_{ij}Q_j\) to tolerance | Instrument-level repeatability beyond the stated measure-and-prepare construction |
| Gap \(\gamma_F\ge\delta\) | `theory/same_label_dimension_free_theorem.md` | `test_theorem_v1_contract.py`, `test_adversarial_same_label.py` | Residual compression stays below \(1-\delta\) | Optimality of the gap estimate |
| Correct typing of \(J_{\mathcal K}\) | `research/CRUXY_REMERGE_AUDIT_2026-10-31.md` | `test_theorem_v1_contract.py` wrong-embedding negative control | Direct-sum inclusion satisfies identities; alternative \(J_q\) is not interchangeable | That no other notation ambiguity exists elsewhere |
| Overlap identity \(J_{\mathcal K}^*WU=D|T|\) | Typed theorem proof | `test_theorem_v1_contract.py`, `test_same_label_hybrid_dilation.py` | Exact matrix identity on implemented cases | General theorem without analytic proof |
| Hybrid isometry \(V^*V=I\) | Typed theorem proof; Lean matrix lemmas | same as above; `lake build` | Numerical identity and formal sublemmas under explicit hypotheses | Complete derivation of all spectral-sector hypotheses in Lean |
| Exact implementation \(V^*\Lambda_jV=F_j\) | Typed theorem proof; Lean matrix lemmas | same as above | Completed POVM is exactly the one implemented by the hybrid dilation | Full channel theorem formalisation |
| No explicit \(m,d\) factor | `theory/BOUND_CANDIDATE_2026-10-31.md` | `test_adversarial_same_label.py`, `test_constant_two_bound.py`, theorem-contract SDPs | Tested many-outcome families show no count growth and satisfy stated bound | That the theorem is novel or coefficient 2 is optimal |
| Coefficient-two movement bound | Bound-candidate proof | `test_constant_two_bound.py`, `test_theorem_v1_contract.py` SDPs | Primal/dual SDP values and witnesses remain within bound | Analytic proof by computation alone |
| Ancilla-assisted diamond distance | Watrous SDP formulation | `test_adversarial_same_label.py`, `test_record_accessibility.py`, theorem-contract SDPs | Low-dimensional primal/dual optimizations include reference assistance | Arbitrary-dimensional certification or interval arithmetic |
| Accessibility inequality \((1-2e)D_{rec}\le\eta\le D_{rec}\) | `research/CERTIFICATE_PROGRESS_2026-10-31.md` | `test_record_accessibility.py` | Exact binary sharpness and random quantum cases pass | Optimality of later projection/triangle steps |
| Exactly idempotent constructed \(\Pi\) | Accessibility certificate | `test_record_accessibility.py` | Constructed finite examples have negligible idempotence residual | Universal proof without analytic argument |
| Repaired certificate is nonvacuous | Accessibility certificate | `test_record_accessibility.py` | Explicit families and random tested cases yield bounds below 2 | Tightness or broad experimental usefulness |
| Linear \(O(\delta)\) threshold rate is false | Threshold lower-bound note | `test_spectral_threshold_rate.py` | Explicit family exhibits square-root scaling | Exact optimal mixed-rate theorem |
| Extra-outcome shortcut can fail maximally | Counterexample audit | `test_extra_outcome_gap_closure.py`, `test_gamma_extra_outcome_counterexample.py` | Exact finite counterexamples reproduce distance 2 / gap failure | Every extra-outcome construction fails |
| Sharp Record-Margin theorem | `theory/record_margin_stability.md` | `test_record_margin.py` | Random tests and equality family pass | External proof review or novelty |
| Spectral-gap, redundancy and metastability extensions | corresponding theory files | `test_three_extensions.py` | Implemented formulas and counterexamples pass | Complete physical applicability |
| Provenance and public claim discipline | prior-art policy and sync reports | `test_repository_claim_discipline.py` | Canonical files, source commit, wording and links are internally consistent | Legal novelty, patentability or freedom-to-operate opinion |
| Lean source compiles | `lean/README.md` | `lake build` via `run_phd_validation.py` or CI | Formalised lemmas have no build errors or `sorry` in the checked source | The unformalised end-to-end theorem |

## Required interpretation

A full passing run supports the statement:

> The canonical repository is executable and internally consistent across its stated finite numerical tests, primal/dual SDPs, negative controls, documentation safeguards and currently formalised Lean lemmas.

It does **not** justify the statement:

> The theorem is externally proved, novel, optimal, peer reviewed, patentable, or a fundamental physical theory.

The current permitted status remains:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]
