# External Review Package

This directory packages the canonical theorem candidate for external attack.

## Start here

1. [Short paper PDF](../paper/prescribed_repeatable_completion.pdf) or [readable manuscript](../paper/prescribed_repeatable_completion.md)
2. [Focused review brief](SHORT_PAPER_REVIEW_BRIEF.md)
   and [completed reduction audit](../literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
3. [Frozen theorem](../theory/THEOREM_V1_FREEZE.md) and [full review packet](EXTERNAL_REVIEW_PACKET.md)
4. `PROOF_DEPENDENCY_MAP.md`
5. `TEST_CLAIM_MATRIX.md`
6. `REPRODUCIBILITY_GUIDE.md`
7. `../experiments/PHD_VALIDATION_PROTOCOL.md`
8. `../AI_RIGHTS_AND_ATTRIBUTION.md`

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

## Human authorship and AI assistance

Christopher Gardner directs and authors the research programme. AI systems, including OpenAI tools, are disclosed as research instruments; they are not designated as authors, inventors, assignees, owners, sponsors, institutions, endorsers, or claimants to the work.

The canonical non-claim and attribution notice is `../AI_RIGHTS_AND_ATTRIBUTION.md`.

## Status

The short paper is a complete external-review draft with novelty unverified.
The longer research document remains supporting material; it is not an awarded
thesis. No part of this package claims external peer review.

Canonical label:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]
