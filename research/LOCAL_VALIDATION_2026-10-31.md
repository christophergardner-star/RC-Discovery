# Laptop validation — 31 October 2026

## Outcome

The nine pre-existing mathematical test scripts passed. The TCL certificate
checks and illustrative QND calculation also passed. The additional adversarial
audit passed 408 valid cases, rejected three deliberately invalid inputs, and
completed 12 full ancilla-assisted diamond-distance SDPs. No numerical
counterexample was found. Finite tests do not establish a universal theorem or
novelty.

The separate PyTorch neural-network smoke test could not start: the installed
PyTorch DLL requires a missing Microsoft Visual C++ runtime. Automatic approval
review rejected the runtime installation with only `blocked by policy`. No
installation bypass was attempted. This is an environment failure, not an
observed mathematical counterexample.

## Reproducible evidence

- [Original suite results](local_validation/summary.json): commands, exit codes,
  source hashes and durations; adjacent `.log` files retain output.
- [Adversarial results](local_validation/adversarial.json): all 408 cases and
  individual solver results. Seed: `2026103107`.
- [Lean build log](local_validation/lean-build.log).
- [Installed Python versions](local_validation/requirements.lock.txt).

Machine: Windows 11, Python 3.12.10, 12 logical processors, approximately 64 GiB
RAM. Work was performed locally in the existing checkout. No new branch,
commit, push or publication was made. Mathematical numerical work used two
BLAS/OpenMP threads.

## Adversarial coverage

The new `experiments/test_adversarial_same_label.py` checks:

- 378 random POVMs, complex basis rotations, mixed sector ranks, and residual
  spaces of dimensions 0, 2 and 5;
- 20 lifted-simplex examples, with prescribed synthesis singular values as low
  as `1e-7`, plus two higher-rank examples with degenerate sector eigenvalues;
- four threshold-rate examples down to delta approximately `1e-8`;
- three extreme residual POVMs and one exact threshold endpoint;
- rejection of missing sectors, a just-below-threshold eigenvalue, and singular
  synthesis (three trine sectors in dimension two).

Maximum tested Hilbert-space dimension and outcome count: 64. Each valid case
checks the dilation identities, normalization, residual spectral bound,
`2 epsilon <= 4(sqrt(1-alpha^2)+sqrt(delta))`, and six ancilla-assisted input
witnesses. Maximum identity residual: `2.4202861936828413e-14`, against a
`5e-7` assertion tolerance. Tiny-alpha tests use SVD rather than Gram inversion.
These finite parameter grids do not cover arbitrarily large ranks, arbitrarily
small positive parameters or all residual POVMs.

For 12 selected examples, independent primal and dual semidefinite programs
optimize the full measurement-channel diamond distance. Zero and distance-two
anchor problems verify normalization. CVXPY uses its SciPy canonicalization
backend; CLARABEL is tried first and SCS is used when CLARABEL does not return
`optimal`. Both accepted programs must report `optimal`, pass explicit primal
and dual feasibility checks and have gap below `2e-6`.

Observed maximum primal-dual gap: `5.453904994290326e-9`; maximum feasibility
violation: `1.5211872659952377e-8`. These are floating-point solutions, not
interval-certified bounds. CVXPY emits an optional OSQP import warning because
that solver's runtime is unavailable; OSQP is not used. Initial stricter
CLARABEL solves reported inaccuracy, motivating the explicit SCS fallback.

## Formalization scope

Lean 4.35.0 and Mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679` are pinned by the new Lake project.
The four original scalar theorems compile. `RCProof/Hybrid.lean` adds actual
rectangular complex-matrix proofs of:

1. `spectral_cross_zero`: commuting a matrix through a projection preserves a
   vanishing cross term;
2. `hybrid_cross_zero`: `J* W (I-U U*)=0`, assuming `U*U=I` and the explicit
   factorization `J*W=A U*`;
3. `hybrid_isometry`: `V*V=I` for `V=J U*+W R`, given the isometry, residual
   projection, complement and cross-zero identities;
4. `hybrid_compression`: `V* L V=U C U*+R E R`, given self-adjointness, the two
   compression identities and the label-specific cross-zero identity.

The spectral definition of the sectors, construction of the factorization,
derivation of the label-specific cross terms, spectral-gap estimate, operator
norm bound and diamond-channel step are **not yet formalized**. The new results
are reusable algebraic parts with explicit hypotheses, not a Lean proof of the
whole theorem. No `sorry` or additional axioms were introduced.

## Interpretation and next work

The prior-art veto remains [qualified](../literature/SAME_LABEL_PRIOR_ART_VETO_2026-10-31.md).
No exact prior combined theorem was identified in that search; novelty remains
unestablished. The earlier finding that the coarse movement bound makes the
composed certificate vacuous also remains: passing these tests does not repair
that bound. Instance-specific movement estimates are needed for a useful
composed certificate. Constants and optimal exponents have not been settled by
these laptop runs.

## Run again (PowerShell)

```powershell
.venv\Scripts\python.exe -m pip install -r experiments\requirements_validation.txt
.venv\Scripts\python.exe experiments\run_local_validation.py
```

The runner includes the optional neural smoke test and intentionally exits
nonzero if it remains unable to start. To run the adversarial audit alone:

```powershell
$env:OPENBLAS_NUM_THREADS='2'
$env:OMP_NUM_THREADS='2'
.venv\Scripts\python.exe experiments\test_adversarial_same_label.py
```

Lean instructions are in [lean/README.md](../lean/README.md). The cache was
placed inside `.lake` because the default user-cache path was not writable.
