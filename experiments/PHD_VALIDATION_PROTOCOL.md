# PhD-Accuracy Validation Protocol

**Programme:** VIBE MATH / RC-Discovery  
**Purpose:** local reproduction and hostile pre-publication audit  
**Status:** executable evidence protocol; not a substitute for proof, peer review or novelty assessment

## 1. What this protocol is for

This protocol packages the repository's canonical mathematical checks into a reproducible local workflow. It is designed to expose errors before external review by testing:

1. theorem hypotheses and expected rejection cases;
2. synthesis packing and polar-sector geometry;
3. same-label completion and repeatability-gap control;
4. the correctly typed labelled embedding \(J_{\mathcal K}\);
5. exact hybrid-isometry identities;
6. low-dimensional ancilla-assisted diamond-norm SDPs;
7. the coefficient-two movement bound;
8. record accessibility and the repaired exact-idempotent certificate;
9. known counterexamples to stronger false claims;
10. repository provenance, prior-art wording and claim discipline;
11. the current Lean build.

A passing run means that all implemented finite tests and formalised lemmas agree with the stated repository version. It does **not** establish the full theorem, its optimality, its novelty, or publication readiness.

## 2. Clean local setup

From a fresh clone:

```bash
git clone https://github.com/christophergardner-star/RC-Discovery.git
cd RC-Discovery
python -m venv .venv-audit
```

### Windows PowerShell

```powershell
.\.venv-audit\Scripts\python.exe -m pip install --upgrade pip
.\.venv-audit\Scripts\python.exe -m pip install -r experiments\requirements_validation.txt
```

### Linux or macOS

```bash
./.venv-audit/bin/python -m pip install --upgrade pip
./.venv-audit/bin/python -m pip install -r experiments/requirements_validation.txt
```

The pinned validation requirements include NumPy, SciPy, CVXPY, Clarabel and SCS. The TCL neural smoke test has separate dependencies and is not part of the canonical quantum-measurement theorem audit.

## 3. Quick profile

The quick profile checks theorem algebra, hypotheses, negative controls, provenance and lightweight numerical families. It skips SDP optimization.

### Windows

```powershell
.\.venv-audit\Scripts\python.exe experiments\run_phd_validation.py `
  --profile quick `
  --skip-lean `
  --output research\local_validation\phd_quick
```

### Linux or macOS

```bash
./.venv-audit/bin/python experiments/run_phd_validation.py \
  --profile quick \
  --skip-lean \
  --output research/local_validation/phd_quick
```

Quick profile order:

1. repository claim-discipline audit;
2. theorem-v1 contract audit without SDP;
3. sharp Record-Margin stress test;
4. synthesis-packing test;
5. spectral-threshold rate and lower-bound family;
6. extra-outcome counterexample;
7. residual/gap counterexample.

## 4. Full profile

The full profile adds the expensive adversarial and SDP work. It is the preferred pre-review run.

### Windows

```powershell
.\.venv-audit\Scripts\python.exe experiments\run_phd_validation.py `
  --profile full `
  --output research\local_validation\phd_full
```

### Linux or macOS

```bash
./.venv-audit/bin/python experiments/run_phd_validation.py \
  --profile full \
  --output research/local_validation/phd_full
```

Full profile additionally runs:

- exact same-label hybrid-dilation tests;
- adversarial many-outcome and near-singular packing families;
- primal/dual measurement-channel diamond SDPs;
- the coefficient-two noncommuting-matrix audit;
- record accessibility and the repaired certificate;
- residual-coupling rate tests;
- moving-POVM and extension tests.

The adversarial script runs before the constant-two script because the latter deliberately rechecks retained adversarial evidence.

## 5. Lean

If `lake` is on the system path, the runner performs:

```bash
cd lean
lake build
```

Use `--require-lean` to make absence of Lake a failure. Use `--skip-lean` when testing only Python.

A successful Lean build certifies only the lemmas actually formalised. It does not certify the complete end-to-end theorem unless every dependency has been formalised.

## 6. New theorem-v1 contract audit

Run directly:

```bash
python experiments/test_theorem_v1_contract.py --sdp-cases 4
```

Fast algebra-only version:

```bash
python experiments/test_theorem_v1_contract.py --skip-sdp
```

The script tests valid rank-one, higher-rank, unequal-rank, residual and threshold-endpoint cases. It verifies:

\[
\sum_jE_j=I,
\qquad
U^*U=I,
\qquad
P_jR=0,
\]

\[
\|P_j-Q_j\|_\infty
\le
\sqrt{1-\alpha^2},
\]

\[
\sum_jF_j=I,
\qquad
F_iQ_j=\delta_{ij}Q_j,
\qquad
RE_jR\le(1-\delta)R,
\]

\[
J_{\mathcal K}^*WU=D|T|,
\qquad
J_{\mathcal K}^*WR=0,
\]

\[
V^*V=I,
\qquad
V^*\Lambda_jV=F_j,
\qquad
\|V-W\|=\|WU-J_{\mathcal K}\|.
\]

It also includes expected rejection tests for:

- a nonzero label with no near-unit sector;
- total packed rank exceeding dimension;
- a singular synthesis operator;
- an eigenvalue just below the threshold;
- invalid threshold endpoints \(\delta=0\) and \(\delta=1/2\).

The alternative polar-vector embedding \(J_q\) is included as a negative control. The test requires it to fail at least one identity on a discriminating nonorthogonal-sector example, preventing accidental reintroduction of the historical notation error.

When SDPs are enabled, the script solves independent primal and dual problems, checks the primal-dual gap and feasibility residual, validates distance-0 and distance-2 anchors, and verifies the coefficient-two theorem bound on low-dimensional cases.

## 7. Claim-discipline audit

Run:

```bash
python experiments/test_repository_claim_discipline.py
```

This test protects the public-facing repository from avoidable credibility failures. It checks:

- the canonical theorem, doctoral document, prior-art policy and review packet exist;
- the correct typed \(J_{\mathcal K}\) appears in canonical statements;
- the coefficient-two bound and repaired certificate are present;
- novelty remains explicitly unverified;
- the doctoral document does not claim an awarded degree;
- the Cruxy source commit and tree are current in the provenance manifest;
- the historical Cruxy `full_proof.md` remains under `imports/` rather than canonical `theory/`;
- prohibited public wording such as “first-ever”, “prior-art free”, “patentable” and “proven breakthrough” is absent;
- selected local Markdown links resolve;
- canonical Markdown contains no null or vertical-tab control characters and has balanced fenced code blocks.

This is a publication-hygiene test, not a legal prior-art opinion.

## 8. Evidence retained by the runner

Each run writes:

- `summary.json` — machine-readable result manifest;
- `summary.md` — human-readable table;
- one complete log per test;
- Python, platform and package versions;
- Git commit, branch and dirty-worktree status;
- SHA-256 hashes of every executed test script;
- Lean source hashes when Lean is run;
- `requirements.lock.txt` from the active environment.

The individual theorem scripts also retain JSON evidence in `research/local_validation/`.

## 9. Failure policy

A failed check must not be hidden by rerunning until it disappears. Record:

1. exact commit;
2. exact command;
3. environment and package lock;
4. random seed;
5. complete log;
6. whether the failure is deterministic;
7. whether it invalidates a theorem hypothesis, a proof step, a numerical claim or only a tolerance;
8. the smallest reproducible case.

Use `--fail-fast` when isolating a failure. Use the default non-fail-fast mode when collecting a full failure matrix.

## 10. Interpretation hierarchy

From weakest to strongest:

1. pure-state or random numerical witness;
2. adversarial finite numerical test;
3. independently solved primal/dual SDP with feasibility diagnostics;
4. analytic proof reconstruction;
5. machine-checked formal proof;
6. independent expert proof reconstruction;
7. peer review and community scrutiny.

A result must never be described at a stronger level than the evidence actually supports.

## 11. Current scientific status

The tests are written around the canonical status:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

They are intended to make errors easy to discover, not to manufacture certainty.
