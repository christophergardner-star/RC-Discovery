# PhD-Accuracy Validation Report

**Date:** 31 October 2026  
**Repository:** `christophergardner-star/RC-Discovery`  
**Validated commit:** `d46b7ebdf83a23323486397ec4ac8187600ff687`  
**GitHub Actions run:** `41225093436`  
**Workflow:** `VIBE MATH PhD audit`  
**Overall result:** **PASS**

## 1. Scope

This report records an actual clean-run execution of the canonical validation suite on GitHub-hosted Ubuntu infrastructure with Python 3.13.17 and the repository's pinned validation dependencies.

Three independent jobs completed successfully:

1. **Python quick audit** — PASS;
2. **Python full SDP audit** — PASS;
3. **Lean build** — PASS.

The run also executed the canonical human-authorship and AI-provider non-claim audit successfully.

A passing run is computational and formalisation evidence. It does not establish external peer review, theorem novelty, legal ownership, patentability, or correctness of statements that remain outside the formalised scope.

## 2. Full Python audit

The full profile ran fourteen checks. Every process returned exit code zero.

| Check | Result | Wall time |
|---|---:|---:|
| `test_repository_claim_discipline` | PASS | 0.064 s |
| `test_theorem_v1_contract` | PASS | 2.470 s |
| `test_record_margin` | PASS | 2.219 s |
| `test_synthesis_packing` | PASS | 16.301 s |
| `test_spectral_threshold_rate` | PASS | 0.114 s |
| `test_same_label_hybrid_dilation` | PASS | 0.215 s |
| `test_adversarial_same_label` | PASS | 13.395 s |
| `test_constant_two_bound` | PASS | 1.117 s |
| `test_record_accessibility` | PASS | 4.624 s |
| `test_residual_coupling_rates` | PASS | 5.275 s |
| `test_extra_outcome_gap_closure` | PASS | 0.114 s |
| `test_gamma_extra_outcome_counterexample` | PASS | 0.114 s |
| `test_moving_povm` | PASS | 8.283 s |
| `test_three_extensions` | PASS | 3.422 s |

The retained full-audit artifact is named:

`phd-audit-full-d46b7ebdf83a23323486397ec4ac8187600ff687`

Artifact digest:

`sha256:4da6be077c373dbe9d8464a1cf0cd7827e23b4158fdf85eb8a2a35b2dd7550ad`

## 3. Frozen theorem contract

`test_theorem_v1_contract.py` reported:

- **8 valid theorem cases**;
- **6 expected hypothesis rejections**;
- **5 primal/dual SDP checks**, including normalization anchors;
- maximum algebraic/isometry identity error
  
  \[
  4.96689102124391\times10^{-15}.
  \]

The valid cases covered exact, residual, rank-one, higher-rank, unequal-rank, moderate-noise, and threshold-endpoint inputs.

The expected rejections covered:

- nonzero labels without near-unit sectors;
- total packed rank exceeding ambient dimension;
- singular synthesis maps;
- eigenvalues strictly below the threshold;
- invalid threshold endpoints.

The test also required the historical polar-vector embedding `J_q` to fail at least one identity on a discriminating example. This protects the canonical direct-sum definition of \(J_{\mathcal K}\).

One solver emitted CVXPY's generic “solution may be inaccurate” warning. The test nevertheless required independently formulated primal and dual values, explicit feasibility checks, and a numerical gap below the stated tolerance before passing. The warning is retained rather than hidden.

## 4. Adversarial same-label audit

`test_adversarial_same_label.py` reported:

- **408 valid adversarial cases**;
- **3 expected rejections**;
- **12 full primal/dual diamond-norm SDPs**;
- maximum exact-identity residual
  
  \[
  1.354472090042691\times10^{-14}.
  \]

The tested families included:

- rank-one and higher-rank sectors;
- unequal ranks;
- 16- and 32-outcome systems;
- residual subspaces;
- extremely small synthesis singular values;
- lifted-simplex families;
- square-root threshold-rate families;
- threshold endpoints;
- extreme residual spectra;
- ancilla-assisted witnesses.

The largest displayed SDP feasibility residual was approximately \(1.52\times10^{-8}\), below the script's acceptance tolerance. Primal-dual gaps were independently checked.

## 5. Record-accessibility and exact-idempotent certificate

`test_record_accessibility.py` reported:

- **7 exact binary cases**;
- **12 random complex quantum cases**;
- **26 primal/dual SDPs**.

The test checked:

\[
(1-2e)D_{\rm rec}\le\eta\le D_{\rm rec},
\]

record concentration in the protected sectors, projected record construction, numerical idempotence of the completed process, and the repaired certificate against independently computed channel distances.

Several random cases produced nontrivial certificates strictly below the maximum channel distance \(2\). Cases attaining the cap were retained and reported rather than discarded.

## 6. Counterexamples and negative controls

The full run reproduced the repository's known failure boundaries:

- local diagnostics do not remove the packing obstruction;
- linear threshold-only movement is false in general;
- the extra-outcome residual dump may be maximally far;
- incomplete sector data do not provide the claimed gap;
- the incorrect `J_q` embedding is not interchangeable with \(J_{\mathcal K}\);
- removal of the noncommuting-matrix width condition is blocked by a deliberate negative control.

The presence of expected negative controls is part of the validation standard. A suite containing only positive examples would not be sufficient.

## 7. Lean build

The pinned Lean project built successfully through `leanprover/lean-action@v1` using the `lean/` Lake package.

The successful build covers only the current formalisation scope documented in `lean/README.md`, including scalar geometric lemmas and selected matrix/projection identities under explicit hypotheses. It does not yet constitute a machine proof of the complete Hilbert-space, diamond-norm, or record-process theorem.

## 8. Human authorship and AI-provider claim boundary

`test_ai_rights_notice.py` passed.

The audit verified that the repository:

- identifies Christopher Gardner as human research director;
- discloses AI assistance as tool use;
- does not designate OpenAI or another AI provider as author, inventor, owner, sponsor, institution, endorser, or claimant;
- links the official OpenAI ownership terms cited by the notice;
- preserves provider rights in provider technology;
- does not pretend that a repository notice overrides mandatory law or governing contracts.

Canonical notice:

`AI_RIGHTS_AND_ATTRIBUTION.md`

This is a governance audit, not a legal opinion.

## 9. Reproduction

### Windows PowerShell

```powershell
.\scripts\run_phd_audit.ps1 -Profile full
```

### Linux or macOS

```bash
bash scripts/run_phd_audit.sh --profile full
```

### Direct Python entry point

```bash
python experiments/run_phd_validation.py \
  --profile full \
  --output research/local_validation/phd_full
```

Detailed instructions are in:

- `experiments/PHD_VALIDATION_PROTOCOL.md`;
- `experiments/README.md`;
- `review/TEST_CLAIM_MATRIX.md`;
- `review/REPRODUCIBILITY_GUIDE.md`.

## 10. Correct interpretation

The strongest justified statement from this run is:

> The canonical repository was reproducible on the tested clean CI environment and was internally consistent across its full finite numerical suite, primal/dual SDPs, expected rejection tests, negative controls, governance checks, and currently formalised Lean lemmas.

The run does **not** justify saying that the combined theorem is externally verified, novel, optimal, peer reviewed, patentable, prior-art free, or a fundamental physical theory.

The scientific status remains:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
