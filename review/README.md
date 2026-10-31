# External Review and Doctoral-Style Documentation

This directory packages the canonical theorem candidate for external attack.

## Start here

1. `../paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md`
2. `../theory/THEOREM_V1_FREEZE.md`
3. `EXTERNAL_REVIEW_PACKET.md`
4. `PROOF_DEPENDENCY_MAP.md`
5. `TEST_CLAIM_MATRIX.md`
6. `REPRODUCIBILITY_GUIDE.md`
7. `../experiments/PHD_VALIDATION_PROTOCOL.md`

## Local validation

Quick audit:

```bash
python experiments/run_phd_validation.py --profile quick --skip-lean
```

Full audit with primal/dual SDPs:

```bash
python experiments/run_phd_validation.py --profile full
```

Windows launcher:

```powershell
.\scripts\run_phd_audit.ps1 -Profile full
```

Linux/macOS launcher:

```bash
bash scripts/run_phd_audit.sh --profile full
```

The runner retains complete logs, environment metadata, package versions, Git state and SHA-256 hashes of executed tests. A passing run is computational evidence, not a proof or novelty certificate.

## Status

The package is doctoral-style in depth and structure. It is not an awarded thesis and does not claim peer review.

Canonical label:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]
