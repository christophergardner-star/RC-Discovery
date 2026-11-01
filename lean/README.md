# Lean 4 formalization

The full theorem is **not yet formalized**. As of 1 November 2026, the project
contains 69 explicitly written lemmas/theorems, up from the 13 in the frozen
review release. The additional proofs construct spectral projectors, positive
square roots, labelled Naimark dilations and polar isometries, establish the
completed POVM algebra, and prove the noncommuting Jordan-product inequality.

The toolchain remains Lean 4.35.0 with Mathlib pinned to
`56a005855ea17e0b0958f73ec801ae140b0a1679`. No external quantum-information
library has been added as a dependency.

## Checked content

| File | Written lemmas/theorems | Scope |
|---|---:|---|
| [Core](RCProof/Core.lean) | 4 | Earlier scalar supporting inequalities |
| [Hybrid](RCProof/Hybrid.lean) | 4 | Rectangular hybrid matrix identities under explicit hypotheses |
| [Gap](RCProof/Gap.lean) | 5 | Residual projections, positivity and compression |
| [Spectral](RCProof/Spectral.lean) | 19 | Full threshold projector, positive square root, commutation, spectral envelope and residual gap |
| [Completion](RCProof/Completion.lean) | 7 | Finite POVM definition, completion positivity/normalization, exact sector action |
| [Naimark](RCProof/Naimark.lean) | 9 | Explicit block construction, label projections, `W*W=I`, `W*Lambda_j W=E_j` |
| [Jordan](RCProof/Jordan.lean) | 7 | Spectral square bounds and the paper's width-conditioned Jordan inequality, including `M=alpha` |
| [Polar](RCProof/Polar.lean) | 5 | Constructed polar isometry and factorization from a positive definite Gram matrix |
| [Assembly](RCProof/Assembly.lean) | 9 | Spectral-frame cross terms, hybrid dilation and residual gap; polar version constructs `U` |

The threshold uses `c <= eigenvalue`, so eigenvalues at the threshold are
included. `threshold_spectral_envelope` derives its conclusion from
`(I-E).PosSemidef`; it no longer assumes the spectral envelope itself.
`FinitePOVM.effect_le_one` proves this effect bound from POVM normalization.

`SpectralFrame.hybrid_dilation_from_polar` constructs
`U=T*(sqrt(T* T))^{-1}` and `V=J U*+W(I-U U*)`, then proves both `V*V=I` and
every label compression. It does **not** take those identities, Naimark
compression identities or vanishing cross terms as hypotheses.

Its geometric input is still explicit: a `SpectralFrame` supplies block
embeddings with spectral support, full sector range and normalized block
Gram matrices; the theorem also assumes `B_j=T C_j` and positive definiteness
of `T* T`. There is not yet a constructor deriving this whole input from the
paper's original sector/synthesis assumptions. Passing the axiom audit does
not remove these ordinary mathematical hypotheses.

## What remains before “full formalization” is justified

1. Construct the canonical direct-sum spectral frame from the POVM and prove
   the coordinate/synthesis relations. Connect synthesis injectivity to the
   Gram condition and `alpha` to the smallest singular value, including all
   nonzero-label and degenerate-sector cases in the paper.
2. Prove the quantitative polar/principal-angle estimates, the block `D`
   bounds and the overlap factorization `W*J=U H D` from those objects.
   The abstract Jordan inequality is checked; its complete measurement
   specialization and coefficient-two conclusion are not.
3. Formalize density operators, the repeatable instrument and its complete
   positivity/trace preservation, including construction of the prepared
   states on every nonzero sector.
4. Supply the trace-norm, arbitrary-ancilla, pure-input and CPTP-contraction
   steps with the paper's **unhalved diamond-norm** convention. Prove the
   final bound from the original theorem hypotheses without assuming an
   equivalent norm estimate.

The paper's later sharp envelopes, joint asymptotics, record correction and
computer-assisted comparisons are additional targets, not consequences of
this Lean build. This development proves no new mathematical claim beyond
the stated lemmas and does not establish novelty or external review.

## Axiom gate and reproduction

`lake build` also builds [RCProofAudit](RCProofAudit.lean). It traverses **all**
declarations in the `RCProof` namespace and rejects any transitive axiom except
`propext`, `Classical.choice` and `Quot.sound`. The present environment has
105 theorem declarations and 143 total declarations including generated
equations, structure projections and tactic helpers. These are **not** 105
independently written theorems; the written count is 69.

From `lean` on Windows:

```powershell
$env:PATH = "$env:USERPROFILE\.elan\bin;$env:PATH"
$env:MATHLIB_CACHE_DIR = Join-Path (Get-Location) '.lake\mathlib-cache'
lake exe cache get  # Initial setup only, if the pinned Mathlib cache is absent.
lake build
```

From the repository root, for a logged build, source hashes and two negative
controls that must reject an extra axiom and an unfinished proof:

```powershell
python experiments/test_lean_formalization.py --negative-controls
```

The validation script uses only Python's standard library. It locates Lake
on `PATH` or in the usual Elan installation. The local Mathlib cache setting
avoids the unwritable default cache previously encountered on this laptop.
Module-system and unused-variable warnings do not invalidate proofs.

See the [operator formalization report](../research/LEAN_OPERATOR_FORMALIZATION_2026-11-01.md)
for the recorded run. The frozen review paper's count of 13 describes its
earlier snapshot; this README tracks the subsequent development.
