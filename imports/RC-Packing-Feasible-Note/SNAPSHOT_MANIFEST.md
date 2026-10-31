# Source Snapshot Manifest

Source: `https://github.com/Cruxy234/RC-Packing-Feasible-Note`  
Source branch: `main`  
Source commit: `f94275addb491f1b4be428e2a65939bd4c153897`  
Source Git tree: `ef0eaf35289b2f489031baaa28163cc2bd97dff0`  
Previously imported commit: `78be7962931f9f95e6e6aecd93f4dde00c3fe14d`  
Imported into: `christophergardner-star/RC-Discovery`  
Import date: 31 October 2026

## Purpose

This directory preserves the Cruxy repository as source provenance. It is an exact imported research-history snapshot plus this manifest. It is not the canonical status layer of RC-Discovery.

Files in this snapshot may contain:

- exploratory conjectures;
- numerical evidence;
- later-refuted constructions;
- prior-art searches that are not legal or formal novelty opinions;
- notation that was subsequently corrected;
- drafts that should not be submitted unchanged;
- statements superseded by the canonical coefficient-two bound, accessibility certificate, typed-map audit, or later Lean work.

Canonical claims live outside `imports/`, especially in:

- `theory/`
- `research/`
- `literature/`
- `paper/`
- `review/`
- `STATUS.md`
- `README.md`

## Delta from the previous source snapshot

GitHub comparison from `78be7962931f9f95e6e6aecd93f4dde00c3fe14d` to `f94275addb491f1b4be428e2a65939bd4c153897` reports six source commits and exactly four changed paths:

1. `README.md` — modified;
2. `STATUS.md` — added;
3. `theory/full_proof.md` — added;
4. `theory/full_proof_verification.md` — added.

No source path in that comparison was omitted from this import.

## Source file inventory

### Root

- `README.md`
- `REVIEW_REQUEST.md`
- `STATUS.md`

### Lean

- `lean/README.md`
- `lean/RCProof/Core.lean`

### Papers

- `paper/arxiv_draft.md`
- `paper/arxiv_ready.md`
- `paper/end_to_end_demo.md`
- `paper/long_paper.md`
- `paper/short_paper.md`

### Theory and audit notes

- `theory/DEFINITIVE_CONCLUSION.md`
- `theory/MQC_complete_status.md`
- `theory/PRIOR_ART_VETO.md`
- `theory/PRIOR_ART_VETO_UPDATED.md`
- `theory/adversarial_theorem_audit.md`
- `theory/constant_tightening.md`
- `theory/correct_WU_J_relation.md`
- `theory/diamond_norm_computation.md`
- `theory/full_proof.md`
- `theory/full_proof_verification.md`
- `theory/gamma_F_closure_path.md`
- `theory/hybrid_isometry_verification.md`
- `theory/hybrid_stinespring_isometry.md`
- `theory/items_5_7_complete.md`
- `theory/measurement_quality_certificate.md`
- `theory/naimark_identity_audit.md`
- `theory/nu_dimension_free_attack.md`
- `theory/packing_feasible_moving_povm.md`
- `theory/residual_spectral_radius.md`
- `theory/same_label_nu_attack.md`

## Critical canonical reconciliation

The source snapshot uses two inequivalent operators under the name `J`:

1. the direct-sum labelled inclusion of original sector vectors;
2. an embedding of polar-rounded vectors.

The canonical theorem uses the first. See:

- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`
- `research/CRUXY_SYNC_REPORT_F94275_2026-10-31.md`
- `theory/same_label_dimension_free_theorem.md`
- `theory/THEOREM_V1_FREEZE.md`

The newly imported `theory/full_proof.md` uses the second/ambiguous rank-one wording and the superseded coefficient-four distance estimate. It is retained exactly as source provenance and is not promoted over the typed canonical theorem, the coefficient-two audit, or the repaired record-accessibility certificate.

## Attribution and prior art

The source repository belongs to the same Christopher Gardner research programme. The import preserves source provenance and does not erase or transfer credit from any external prior-art authors cited in the research.

Nothing in this manifest or snapshot is a legal novelty, patentability, or freedom-to-operate opinion. Canonical attribution policy is in:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`
