# Full repository verification — 31 October 2026

**Final outcome:** canonical full profile including required Lean **PASS**;
all **16 test scripts PASS**; **18 of 19 executable scripts PASS**, with the
optional neural smoke test blocked by the missing runtime described below.
The coverage, current-source hashes and required SDP execution were independently
checked in [the evidence audit](end_to_end_validation/evidence-audit.json).

## Revision and scope

Fetched all remote branches and tags, pruned stale remote references, and
fast-forwarded `main` by 66 commits from `454d044` to
`cb1610f3042a47a16b4b82ce79edb40e475882e7`. The checkout contains full Git
history, not a shallow clone; no submodules were present. `git fsck --full`
found no missing or corrupt objects (two unreachable tree objects are harmless
leftovers from prior local merges).

This audit runs the complete executable mathematical package, every additional
`test_*.py` script, the three application utilities, fresh Lean source checks,
and an independent remote provenance comparison. It also repairs a demonstrated
input-validation defect. It does not certify every informal mathematical claim
in historical source imports or establish literature novelty.

## Results

The baseline fourteen-script full Python profile passed on the untouched
imported revision. Inspection nevertheless found a validator bug that its
existing cases did not exercise. Baseline logs and source hashes are preserved
under `end_to_end_validation/baseline_full/` and `baseline_sources.json`.

After the validator repair, the strict full profile was rerun in a newly
created `.venv-audit` with the pinned dependencies and `--require-lean`.
All fourteen Python entries and the required Lean entry passed. The final machine-readable outcome is in
[the full run summary](end_to_end_validation/full/summary.json).

All sixteen mathematical/governance `test_*.py` scripts are covered by the full
profile plus two supplemental checks. The TCL certificate and illustrative QND
calculation also pass. The **PyTorch TCL neural smoke test cannot start** because
the Microsoft C++ runtime needed by `torch/lib/c10.dll` is missing. Its actual
failed invocation is retained. A runtime installation was rejected by automatic
approval review earlier in this session; this run did not retry or bypass that
rejection. Thus the complete repository does not have an unconditional all-pass
result, even when its canonical theorem suite passes.

The QND inputs (`0.01`, `0.02`, `0.03`, `0.04`) are illustrative values, not
experimental observations. The neural smoke test is separate from verification
of the quantum measurement theorem.

## Validator defects found and fixed

The previous `build_rounding` symmetrized effects before validation. For example,
it accepted

\[
E_0=\begin{pmatrix}.95&1\\-1&.05\end{pmatrix},\qquad E_1=I-E_0,
\]

although both have Hermiticity defect 2. It tested a modified POVM instead of
rejecting the invalid input. It also rejected valid single-outcome measurements
and exact zero labels allowed by the frozen measurement theorem.

`experiments/test_theorem_v1_contract.py` now:

- checks raw shape, finite entries and Hermiticity before symmetrization;
- accepts single-outcome POVMs and preserves exact zero labels;
- still rejects tiny nonzero labels without near-unit sectors;
- includes ten added rejection controls and two added valid cases;
- supplies four theorem cases when `--sdp-cases 4` is requested, and rejects
  requests exceeding the available cases instead of silently running fewer.

The corrected audit passes **10 valid cases, 16 expected rejections, and six
primal/dual SDP checks** (four theorem cases and two normalization anchors).
Maximum identity residual is approximately `6.42e-15`.
[Before-fix observations](end_to_end_validation/validator-regression-before.json)
and [the isolated corrected run](end_to_end_validation/validator_patch/summary.json)
retain the original and repaired source hashes.

Validation remains numerical: the input tolerance is `2e-8`, with larger
explicit allowances for propagated identity/SDP errors. Tolerated roundoff is
not an exact positivity or interval certificate.

## Formal verification

- The pinned canonical Lake project builds.
- Each of `Core.lean`, `Hybrid.lean`, `Gap.lean` and the root module was freshly
  checked by Lean, in addition to the ordinary build.
- All **13 canonical theorem declarations** were inspected with `#print axioms`.
  Their only dependencies are `propext`, `Classical.choice` and `Quot.sound`;
  there is no `sorryAx` or custom axiom.
- Both untouched imported Lean files compile using the imported directory as
  the explicit package root. Initial path-only invocation errors are retained
  and marked resolved; they were not proof errors.

[Formal outcome](end_to_end_validation/lean_outcome.json) and
[commands/source hashes](end_to_end_validation/lean_manifest.json) distinguish
the canonical and imported checks. Imported `implements_completion` assumes its
conclusion verbatim, so its compilation does not prove the construction.
Derivation of the spectral hypotheses and the full channel theorem remain
outside the formalized scope.

## Independent provenance and imported-claim checks

Live source data confirms all eight root Git objects against source commit
`297ec2fcf6114598418863c5fcf13b7090364652`, reconstructing tree
`99d063fea0157aa4afcbd0664a0aa0cf7161e387`. The imported snapshot contains all
40 source files plus the intentional local manifest. Its working files were
not altered. See [independent provenance evidence](end_to_end_validation/provenance-review.json).

The imported `CLOSING_PROOFS.md` remains historical material. Counterchecks
confirm reasons not to adopt its stronger assertions:

- a normalized sector synthesis map cannot have all singular values equal to
  one except one value below one, because its squared singular values sum to
  the packed dimension;
- a singular-direction polar residual is `|sigma-1|`, not the projector-angle
  expression `sqrt(1-sigma^2)`;
- threshold crossings can make the canonical rounding map discontinuous. An
  explicit diagonal family retains nonzero sectors and `alpha=1` while its
  measurement movement jumps from `0.4` to zero under arbitrarily small
  perturbations. Unqualified Lipschitz robustness therefore fails;
- the imported factor-two isometry estimate followed by a factor-two channel
  transfer yields coefficient four, not coefficient two.

[Exact descriptions and numerical counterchecks](end_to_end_validation/provenance-counterchecks.json)
are retained. These findings do not refute the canonical coefficient-two proof,
which uses a different overlap argument, or the direct accessibility certificate.
The repository already quarantines these imported claims.

## Reproduction

```powershell
python -m venv .venv-audit
.venv-audit\Scripts\python.exe -m pip install -r experiments\requirements_validation.txt
$env:PATH = "$env:USERPROFILE\.elan\bin;$env:PATH"
.venv-audit\Scripts\python.exe experiments\run_phd_validation.py --profile full --require-lean --output research\end_to_end_validation\full
.venv-audit\Scripts\python.exe experiments\test_ai_rights_notice.py
.venv-audit\Scripts\python.exe experiments\test_dimension_free_naimark.py
```

The last two scripts are omitted by the canonical fourteen-script runner and
were explicitly run here. Additional application commands and their interpreter
paths are retained in [the supplemental manifest](end_to_end_validation/supplemental/summary.json).
`pip check` and compilation of every Python file in `experiments/` pass.
Source hashes, dependency versions, durations, exit codes and stdout/stderr logs
are retained with the run. The final evidence audit lists all scripts and checks
that the completed runs match their current source hashes.

The detailed numerical outputs were also copied into
`end_to_end_validation/data/` so this run remains reviewable if the usual shared
result files are regenerated later. The post-repair validated state is the
pulled base commit plus the exact contract-test source hash recorded in the
full manifest and evidence audit. The original baseline run remains separate.
