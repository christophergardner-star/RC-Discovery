# Source Snapshot Manifest

Source: `https://github.com/Cruxy234/RC-Packing-Feasible-Note`  
Source branch: `main`  
Source commit: `297ec2fcf6114598418863c5fcf13b7090364652`  
Source Git tree: `99d063fea0157aa4afcbd0664a0aa0cf7161e387`  
Previously imported commit: `fcef89be09dd9167a5a94d887e34d5ef1a8d0746`  
Imported into: `christophergardner-star/RC-Discovery`  
Import date: 31 October 2026

## Purpose

This directory preserves the Cruxy repository as source provenance. It is an exact imported research-history snapshot plus this manifest. It is not the canonical status layer of RC-Discovery.

Files in this snapshot may contain:

- exploratory conjectures;
- numerical evidence;
- analytic sketches that still require reconstruction;
- later-refuted constructions;
- prior-art searches that are not legal or formal novelty opinions;
- notation that was subsequently corrected;
- drafts that should not be submitted unchanged;
- statements superseded by the canonical coefficient-two bound, accessibility certificate, typed-map audit, later Lean work, or the full RC-Discovery validation suite.

Canonical claims live outside `imports/`, especially in:

- `theory/`
- `research/`
- `literature/`
- `paper/`
- `review/`
- `STATUS.md`
- `README.md`

## Delta from the previous source snapshot

GitHub comparison from `fcef89be09dd9167a5a94d887e34d5ef1a8d0746` to `297ec2fcf6114598418863c5fcf13b7090364652` reports seven source commits and exactly six changed paths:

1. `README.md` — modified;
2. `STATUS.md` — modified;
3. `paper/FINAL.md` — modified;
4. `theory/CLOSING_PROOFS.md` — added;
5. `theory/HARDER_PUSH.md` — added;
6. `theory/HARDER_PUSH_2.md` — added.

No source path in that comparison was omitted from this import.

## Git-object parity

After import, the following target subtrees are byte-for-byte identical to the source subtrees:

| Source subtree | Source and imported SHA |
|---|---|
| `lean/` | `c2b7e33e591d9e89d1859655052d85759352b031` |
| `paper/` | `0c0dc5b187f665df811a01088fe3a7e6b5a01d72` |
| `theory/` | `0f0f76897314689c6dba981e539eb06c5969af47` |

The imported root source blobs also match the source object SHAs:

| File | SHA |
|---|---|
| `NOVELTY_STATEMENT.md` | `3de4de1c91951cb8bd6acb0a0d7e4d35e1abe8f8` |
| `README.md` | `4f86306db05e644437acd5c215b85e384e959d79` |
| `REVIEW_PACKAGE.md` | `afaedc8c2b6b03ac6d662bd69bf44c5427227559` |
| `REVIEW_REQUEST.md` | `cc8462c2672da120aef69f8ad3ac74e4635833e2` |
| `STATUS.md` | `32a8cab2eb8d96ec621ba30eb89f3841e0a1ddf5` |

The imported directory has one deliberate extra file—this manifest—so its top-level tree SHA is not expected to equal the source repository root tree SHA.

## Source file inventory

### Root

- `NOVELTY_STATEMENT.md`
- `README.md`
- `REVIEW_PACKAGE.md`
- `REVIEW_REQUEST.md`
- `STATUS.md`

### Lean

- `lean/LEAN_STATUS.md`
- `lean/README.md`
- `lean/RCProof/Core.lean`
- `lean/RCProof/Hybrid.lean`
- `lean/RCProof/HybridExtended.lean`

### Papers

- `paper/FINAL.md`
- `paper/arxiv_draft.md`
- `paper/arxiv_ready.md`
- `paper/end_to_end_demo.md`
- `paper/long_paper.md`
- `paper/short_paper.md`

### Theory and audit notes

- `theory/CLOSING_PROOFS.md`
- `theory/DEFINITIVE_CONCLUSION.md`
- `theory/HARDER_PUSH.md`
- `theory/HARDER_PUSH_2.md`
- `theory/MQC_complete_status.md`
- `theory/PRIOR_ART_VETO.md`
- `theory/PRIOR_ART_VETO_UPDATED.md`
- `theory/RECHECK_2026-10-31.md`
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
- `research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md`
- `research/CRUXY_SYNC_REPORT_297EC2_2026-10-31.md`
- `theory/same_label_dimension_free_theorem.md`
- `theory/THEOREM_V1_FREEZE.md`

The source `theory/full_proof.md` remains ambiguous about this map and retains the superseded coefficient-four proof sketch. The later source `paper/FINAL.md` uses the coefficient-two statement but still describes the typed map as an inclusion “of the polar basis,” which is not the canonical definition. Both files are retained exactly as provenance and are not promoted over the correctly typed canonical theorem.

The three new source notes are also retained as provenance rather than promoted automatically:

- `HARDER_PUSH_2.md` is a useful numerical sharpness search and explicitly reports that no valid tested POVM produced a ratio above `0.5`;
- `HARDER_PUSH.md` contains numerical probes and robustness sketches, but its Lipschitz constants require explicit spectral-gap and perturbation hypotheses before use as a theorem;
- `CLOSING_PROOFS.md` labels a “matching lower-bound family” and several items as closed without supplying a complete normalised POVM construction or a fully quantified proof. Its stronger sharpness and robustness language therefore remains unverified and is not canonical.

The source `NOVELTY_STATEMENT.md` records the source repository's literature-search position. RC-Discovery does not adopt it as a verified novelty claim. Canonical wording remains:

`potentially distinct; novelty unverified`.

The source Lean files formalise elementary algebraic consequences under assumed matrix identities. In particular, `implements_completion` simply returns its implementation hypothesis. They are useful provenance and build evidence, but they are not a full formal proof of the physical construction, the distance estimate, or the record-process certificate.

The source recheck and sharpness notes are written evidence history, not substitutes for the executable validation harness under `experiments/` and the retained report `research/PHD_VALIDATION_REPORT_2026-10-31.md`.

## Attribution and AI-provider non-claim boundary

The source repository belongs to the same Christopher Gardner research programme. The import preserves source provenance and does not erase or transfer credit from external prior-art authors.

Christopher Gardner is the human research director and author. AI systems and their providers are treated as research tools only; the import does not designate OpenAI or any other provider as an author, inventor, owner, sponsor, endorser, or claimant.

Canonical governance:

- `AI_RIGHTS_AND_ATTRIBUTION.md`
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`

Nothing in this manifest or snapshot is a legal novelty, patentability, ownership, inventorship, or freedom-to-operate opinion.
