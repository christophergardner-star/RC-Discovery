# PhD-Accuracy Validation Protocol

**Programme:** VIBE MATH / RC-Discovery  
**Purpose:** local reproduction and hostile pre-publication audit  
**Status:** executable evidence protocol; not proof, peer review, external verification, or novelty certification

## 1. Purpose

The protocol tests the canonical theorem package in a clean, reproducible order:

1. human-authorship and AI-provider non-claim policy;
2. source provenance and claim discipline;
3. raw theorem hypotheses and expected rejections;
4. synthesis packing and polar-sector geometry;
5. same-label completion and repeatability gap;
6. typed hybrid-isometry identities;
7. low-dimensional ancilla-assisted primal/dual SDPs;
8. the coefficient-two movement bound;
9. direct record accessibility and exact-idempotent rounding;
10. residual-coupling rates;
11. explicit counterexamples to stronger false statements;
12. the currently formalised Lean declarations.

A pass means the implemented finite checks agree with the audited repository state. It does not establish the universal theorem, optimality, novelty, or publication readiness.

## 2. Clean setup

```bash
git clone https://github.com/christophergardner-star/RC-Discovery.git
cd RC-Discovery
python -m venv .venv-audit
```

Windows:

```powershell
.\.venv-audit\Scripts\python.exe -m pip install --upgrade pip
.\.venv-audit\Scripts\python.exe -m pip install -r experiments\requirements_validation.txt
```

Linux/macOS:

```bash
./.venv-audit/bin/python -m pip install --upgrade pip
./.venv-audit/bin/python -m pip install -r experiments/requirements_validation.txt
```

## 3. Quick profile

```bash
python experiments/run_phd_validation.py \
  --profile quick \
  --skip-lean \
  --output research/local_validation/phd_quick
```

The quick profile runs:

1. AI-rights/non-claim governance audit;
2. repository claim/provenance audit;
3. theorem contract without SDPs;
4. Record-Margin stress test;
5. synthesis-packing stress test;
6. spectral-threshold lower-bound family;
7. extra-outcome counterexample;
8. incomplete-sector/gap counterexample.

## 4. Full profile

```bash
python experiments/run_phd_validation.py \
  --profile full \
  --output research/local_validation/phd_full
```

The full profile runs every canonical `test_*.py` script. It adds:

- the theorem contract with primal/dual SDPs;
- exact same-label hybrid tests;
- the earlier Naimark-completion regression test;
- many-outcome, higher-rank and near-singular adversarial families;
- the noncommuting coefficient-two audit;
- record accessibility and repaired certificate tests;
- residual-coupling and restricted linear-rate tests;
- moving-POVM, redundancy and metastability extensions.

The adversarial script runs before the coefficient-two test because the latter deliberately rechecks retained adversarial evidence.

## 5. Platform launchers

Windows:

```powershell
.\scripts\run_phd_audit.ps1 -Profile full -RequireLean
```

Linux/macOS:

```bash
bash scripts/run_phd_audit.sh --profile full --require-lean
```

The launchers use an isolated `.venv-audit` environment. The governance audit is part of the selected profile and is not run as an untracked side step.

## 6. Frozen theorem contract

```bash
python experiments/test_theorem_v1_contract.py --sdp-cases 4
```

The corrected contract validates raw inputs before numerical cleanup. It checks:

- square shape, finite entries, Hermiticity, positivity and normalization;
- single-outcome POVMs and exact zero effects;
- rejection of nonzero labels without a near-unit sector;
- synthesis injectivity and packed-rank capacity;
- higher-rank and unequal-rank polar geometry;
- \(P_jR=0\), POVM completion and \(\gamma_F\ge\delta\);
- \(J_{\mathcal K}^*WU=D|T|\) and \(J_{\mathcal K}^*WR=0\);
- \(V^*V=I\) and \(V^*\Lambda_jV=F_j\);
- the incorrect historical \(J_q\) map as a required negative control;
- channel SDPs and the coefficient-two bound.

The retained end-to-end audit reports 10 valid cases, 16 expected rejections and 6 SDP checks.

## 7. Lean

If `lake` is available, the runner performs:

```bash
cd lean
lake build
```

Use `--require-lean` to fail when Lake is absent. The evidence manifest hashes only repository-owned source under `lean/RCProof.lean` and `lean/RCProof/`; downloaded `.lake` dependencies are excluded.

A successful build proves only declarations actually formalised.

## 8. Optional application checks

The quantum theorem suite does not require PyTorch.

Application scripts:

```bash
python experiments/rc_qnd_certificate.py
python experiments/rc_tcl_certificate.py
```

The optional neural TCL smoke test requires PyTorch:

```bash
python experiments/rc_tcl_conflict_smoke.py
```

On Windows, a compatible Microsoft C++ runtime is also required. Tagged full GitHub Actions audits run the neural smoke separately on Linux with CPU PyTorch so a local runtime problem cannot be confused with a theorem failure.

## 9. Retained evidence

Each profile writes:

- `summary.json` and `summary.md`;
- one complete log per test;
- Git commit, branch and dirty-state information;
- Python/platform and package versions;
- SHA-256 hashes for executed scripts;
- repository-owned Lean source hashes;
- a package lock from the active environment.

SDP scripts separately retain primal/dual values, solver status, gaps and feasibility diagnostics.

## 10. Failure policy

Do not hide a failure by repeatedly rerunning it. Record:

1. exact commit and command;
2. package lock and platform;
3. seed and complete log;
4. determinism;
5. smallest reproducer;
6. whether it affects a hypothesis check, analytic step, numerical claim, tolerance, governance rule, or only an optional application.

## 11. Interpretation hierarchy

From weakest to strongest:

1. random or pure-state witness;
2. adversarial finite test;
3. primal/dual SDP with feasibility diagnostics;
4. analytic reconstruction;
5. machine-checked proof;
6. independent specialist reconstruction;
7. peer review and community scrutiny.

The repository must not describe a statement at a stronger level than its evidence supports.

## 12. Current status

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}

See:

- [`../research/END_TO_END_VERIFICATION_2026-10-31.md`](../research/END_TO_END_VERIFICATION_2026-10-31.md);
- [`../research/FULL_WORK_AUDIT_2026-10-31.md`](../research/FULL_WORK_AUDIT_2026-10-31.md);
- [`../theory/README.md`](../theory/README.md).
