# Executable Validation Suite

This directory contains the numerical, algebraic, SDP, governance and integration checks for the canonical RC-Discovery package.

## Primary entry points

For the [explicit four-dimensional family](../research/COMPLETION_SWITCH_FAMILY_2026-11-01.md),
verify both endpoint orderings and the whole-interval packing certificate:

```powershell
python -I -S experiments/verify_completion_switch_family.py
python experiments/check_completion_switch_family.py
```

The subsequent [exact comparison certificates](../research/EXACT_COMPARISON_2026-11-01.md)
can be verified without scientific Python packages:

```powershell
python -I -S experiments/verify_exact_completion_comparison.py
python experiments/check_exact_certificate_negative_controls.py
```

These apply the documented analytic error bounds to the retained rational examples;
they do not establish literature novelty or formalize the full theorem in Lean.

For the adaptive paired comparison and theorem-bound attack, see
[the 1 November report](../research/PAIRED_SEARCH_2026-11-01.md). Run a new
search in a fresh output directory:

```powershell
.venv-audit/Scripts/python.exe experiments/search_prescribed_completion.py --output research/local_validation/phd_audit/paired_search_new
```

This heuristic search evaluates both completions on matching inputs and
retains full-distance SDP finalists. It is separate from the fixed validation
suite and does not certify a universal optimum or literature novelty.

Full canonical audit:

```bash
python experiments/run_phd_validation.py --profile full
```

Quick audit:

```bash
python experiments/run_phd_validation.py --profile quick --skip-lean
```

Windows:

```powershell
.\scripts\run_phd_audit.ps1 -Profile full -RequireLean
```

Linux or macOS:

```bash
bash scripts/run_phd_audit.sh --profile full --require-lean
```

Both profiles include the human-authorship and AI-provider non-claim audit. The full profile runs every canonical `test_*.py` script, including the earlier Naimark-completion regression test.

Detailed protocol:

- [`PHD_VALIDATION_PROTOCOL.md`](PHD_VALIDATION_PROTOCOL.md)
- [`../review/TEST_CLAIM_MATRIX.md`](../review/TEST_CLAIM_MATRIX.md)
- [`../research/END_TO_END_VERIFICATION_2026-10-31.md`](../research/END_TO_END_VERIFICATION_2026-10-31.md)
- [`../research/FULL_WORK_AUDIT_2026-10-31.md`](../research/FULL_WORK_AUDIT_2026-10-31.md)
- [`../AI_RIGHTS_AND_ATTRIBUTION.md`](../AI_RIGHTS_AND_ATTRIBUTION.md)

## Frozen-theorem contract

### `test_theorem_v1_contract.py`

Checks the frozen theorem chain end to end:

- raw POVM input validation;
- one-outcome and exact-zero-label handling;
- expected rejection of non-Hermitian, non-positive, non-normalized and under-threshold inputs;
- synthesis injectivity and packing capacity;
- polar packing at rank one, higher rank and unequal rank;
- same-label completion and repeatability gap;
- typed direct-sum inclusion \(J_{\mathcal K}\);
- overlap, cross-term, isometry and implementation identities;
- negative control for the incorrect polar-vector map \(J_q\);
- low-dimensional primal/dual diamond-norm SDPs;
- the coefficient-two bound on solved cases.

```bash
python experiments/test_theorem_v1_contract.py --sdp-cases 4
```

The retained corrected audit reports 10 valid cases, 16 expected rejections and 6 SDP checks.

## Governance and provenance

### `test_repository_claim_discipline.py`

Checks:

- canonical files and links;
- current Cruxy source-object parity;
- typed notation;
- the canonical theory/history boundary;
- conservative novelty and degree language;
- full-work audit presence;
- separation of imported source claims from canonical conclusions.

### `test_ai_rights_notice.py`

Checks that Christopher Gardner is identified as human research director and that AI systems/providers are disclosed as tools rather than designated authors, inventors, owners, sponsors, endorsers or claimants. This is a governance test, not a legal opinion.

## Mathematical tests

- `test_record_margin.py` — sharp Record-Margin theorem and equality family.
- `test_three_extensions.py` — spectral-gap, redundancy and metastability checks.
- `test_moving_povm.py` — simplex obstruction and binary transfer cases.
- `test_synthesis_packing.py` — rank-one and higher-rank polar-packing stress tests.
- `test_spectral_threshold_rate.py` — square-root threshold lower-bound family.
- `test_same_label_hybrid_dilation.py` — exact same-label hybrid implementation.
- `test_dimension_free_naimark.py` — regression test for the earlier Naimark-completion route.
- `test_adversarial_same_label.py` — many-outcome, high-rank, near-singular and ancilla-assisted cases plus SDPs.
- `test_constant_two_bound.py` — noncommuting positive-matrix and coefficient-two audit.
- `test_record_accessibility.py` — accessibility inequality and repaired exact-idempotent certificate.
- `test_residual_coupling_rates.py` — residual-coupling and restricted linear-rate analysis.
- `test_extra_outcome_gap_closure.py` — counterexample to dumping residual mass into a new label.
- `test_gamma_extra_outcome_counterexample.py` — incomplete-sector gap obstruction.

## Application scripts

- `rc_qnd_certificate.py` — QND-style parameter certificate smoke check.
- `rc_tcl_certificate.py` — classical/TCL certificate calculation.
- `rc_tcl_conflict_smoke.py` — optional synthetic neural TCL experiment requiring PyTorch.

The PyTorch smoke test is intentionally separated from the canonical quantum theorem suite. On Windows, PyTorch also requires a compatible Microsoft C++ runtime. A tagged full GitHub Actions audit runs this script independently on Linux with a CPU PyTorch environment.

## Evidence policy

Every stochastic test uses an explicit seed. The runner retains:

- complete logs;
- script SHA-256 hashes;
- Git state;
- Python/platform details;
- package versions;
- solver status and primal/dual diagnostics;
- hashes of repository-owned Lean source only.

Downloaded `.lake` dependencies are deliberately excluded from the Lean source manifest.

Numerical success is not promoted to proof. Lean success applies only to declarations actually formalised. No test establishes novelty, peer review, patentability, freedom to operate, or an enforceable intellectual-property conclusion.
