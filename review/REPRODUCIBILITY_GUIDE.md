# Reproducibility Guide

## Scope

The computations are evidence and regression tests. The analytic proof is primary.

## Recommended environment

- Python 3.11 or later
- pinned packages from `experiments/requirements_validation.txt`
- Lean 4.35.0
- Mathlib version pinned by the Lean project

## Core Python checks

From the repository root:

```bash
python experiments/test_record_margin.py
python experiments/test_three_extensions.py
python experiments/test_moving_povm.py
python experiments/test_synthesis_packing.py
python experiments/test_spectral_threshold_rate.py
python experiments/test_same_label_hybrid_dilation.py
python experiments/test_constant_two_bound.py
python experiments/test_record_accessibility.py
```

Run the validation harness:

```bash
python experiments/run_local_validation.py
```

Run selected tests:

```bash
python experiments/run_local_validation.py \
  --only test_constant_two_bound test_record_accessibility
```

## Lean

```bash
cd lean
lake build
```

The current formal scope must be read from `lean/README.md`. A successful build does not certify the full theorem unless all theorem dependencies are formalised.

## Required evidence retention

Retain:

- `summary.json`;
- test logs;
- `requirements.lock.txt`;
- script SHA-256 values;
- random seeds;
- solver status;
- primal and dual objective values;
- feasibility residuals;
- exact commit SHA.

## Diamond-norm numerics

Pure-state total-variation sampling must be labelled a proxy unless equality with the diamond norm is proved for the tested class.

For SDP-based checks, report:

- primal status;
- dual status;
- primal-dual gap;
- Hermiticity residual;
- positivity violation;
- trace constraints;
- normalization anchors;
- numerical tolerance.

## Reproducibility acceptance criterion

A clean environment should be able to:

1. install dependencies;
2. run all tests without manual edits;
3. rebuild Lean;
4. regenerate retained summaries;
5. match exact examples symbolically or to stated tolerance;
6. distinguish expected negative controls from failures.
