# Executable Validation Suite

This directory contains numerical, algebraic, SDP and integration checks for the canonical RC-Discovery theorem package.

The primary entry point is:

```bash
python experiments/run_phd_validation.py --profile full
```

For a fast smoke audit:

```bash
python experiments/run_phd_validation.py --profile quick --skip-lean
```

Detailed protocol:

- [`PHD_VALIDATION_PROTOCOL.md`](PHD_VALIDATION_PROTOCOL.md)
- [`../review/TEST_CLAIM_MATRIX.md`](../review/TEST_CLAIM_MATRIX.md)

## Canonical theorem tests

### `test_theorem_v1_contract.py`

An end-to-end finite-dimensional audit of the frozen theorem statement. It checks:

- all stated hypotheses;
- expected rejection of invalid inputs;
- polar packing and higher-rank sectors;
- same-label completion and repeatability gap;
- the typed direct-sum inclusion \(J_{\mathcal K}\);
- overlap, cross-term, isometry and implementation identities;
- a negative control using the incorrect polar-vector embedding \(J_q\);
- low-dimensional primal/dual diamond-norm SDPs;
- the coefficient-two bound on solved cases.

Full form:

```bash
python experiments/test_theorem_v1_contract.py --sdp-cases 4
```

Algebra-only form:

```bash
python experiments/test_theorem_v1_contract.py --skip-sdp
```

### `test_repository_claim_discipline.py`

Protects provenance and public claim boundaries. It verifies canonical files, current Cruxy source hashes, typed notation, conservative novelty wording, doctoral-status wording, selected local links and separation of historical imported proofs from canonical theory.

```bash
python experiments/test_repository_claim_discipline.py
```

## Existing supporting tests

- `test_record_margin.py` — sharp Record-Margin theorem and equality family.
- `test_three_extensions.py` — spectral-gap, redundancy and metastability checks.
- `test_moving_povm.py` — simplex obstruction and binary transfer cases.
- `test_synthesis_packing.py` — rank-one and higher-rank polar-packing stress tests.
- `test_spectral_threshold_rate.py` — square-root threshold lower-bound family.
- `test_same_label_hybrid_dilation.py` — exact hybrid-isometry implementation.
- `test_adversarial_same_label.py` — many-outcome, high-rank and near-singular adversarial families plus optional full SDPs.
- `test_constant_two_bound.py` — noncommuting positive-matrix and coefficient-two audit.
- `test_record_accessibility.py` — sharp accessibility inequality and repaired exact-idempotent certificate.
- `test_residual_coupling_rates.py` — residual-coupling and restricted linear-rate analysis.
- `test_extra_outcome_gap_closure.py` — exact counterexample to the residual-to-new-outcome shortcut.
- `test_gamma_extra_outcome_counterexample.py` — incomplete-sector gap obstruction.

## Evidence policy

Every stochastic test uses an explicit seed. The runners retain logs, script hashes, package versions and Git metadata. SDP tests record primal and dual values, feasibility residuals and solver choice.

Numerical success is not promoted to proof. Lean success applies only to the statements actually formalised. No test establishes novelty, patentability or freedom to operate.
