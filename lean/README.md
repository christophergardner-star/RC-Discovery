# Lean 4 formalization

The full theorem is **not yet formalized**. As of 1 November 2026, the project
contains 152 explicitly written lemmas/theorems, up from 69 in the first
operator extension and 13 in the frozen review release. The canonical frame,
polar/synthesis bounds and repeatable instrument are now constructed. The
ancilla overlap floor and Hermitian trace-norm contractivity are checked;
the final measurement diamond-distance estimate remains open.

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
| [CanonicalFrame](RCProof/CanonicalFrame.lean) | 10 | All selected eigenvectors with labels, frame identities, synthesis and dilation from injectivity |
| [Packing](RCProof/Packing.lean) | 8 | Constructed `D`, its lower/upper bounds, `W*J=TD=UHD` |
| [PackingParameter](RCProof/PackingParameter.lean) | 8 | Least-Gram-eigenvalue definition, `0<alpha<=1`, Gram and polar lower bounds |
| [PackingBounds](RCProof/PackingBounds.lean) | 6 | POVM-derived synthesis/Gram upper bounds and `H<=1/sqrt(c)` |
| [Instrument](RCProof/Instrument.lean) | 9 | Explicit Kraus representation and positive amplification for every finite reference |
| [CanonicalInstrument](RCProof/CanonicalInstrument.lean) | 15 | Constructed prepared states, correct outcome traces, repeatability, channel CP/TP/idempotence |
| [Ancilla](RCProof/Ancilla.lean) | 7 | Measurement-specific Jordan overlap and arbitrary-reference lift |
| [Distance](RCProof/Distance.lean) | 9 | Standard trace norm, measurement map and full stabilized induced norm definition |
| [TraceNorm](RCProof/TraceNorm.lean) | 8 | Spectral trace-norm formula and positive trace-preserving contraction on Hermitian inputs |
| [AncillaContractivity](RCProof/AncillaContractivity.lean) | 3 | Trace preservation and Hermitian trace-norm contraction of the constructed channel with references |

The threshold uses `c <= eigenvalue`, so eigenvalues at the threshold are
included. `threshold_spectral_envelope` derives its conclusion from
`(I-E).PosSemidef`; it no longer assumes the spectral envelope itself.
`FinitePOVM.effect_le_one` proves this effect bound from POVM normalization.

`SpectralFrame.hybrid_dilation_from_polar` constructs
`U=T*(sqrt(T* T))^{-1}` and `V=J U*+W(I-U U*)`, then proves both `V*V=I` and
every label compression. It does **not** take those identities, Naimark
compression identities or vanishing cross terms as hypotheses.

The later `canonical_hybrid_dilation_of_injective` removes the supplied-frame
and Gram-positivity inputs: the frame is built from all threshold eigenvectors,
and the Gram condition follows from synthesis injectivity. The sector index
type includes every eigenvector at the threshold, including degeneracies.
With a nonempty physical space and the original nonzero-sector condition,
`sectorIndex_nonempty` supplies the nonempty domain needed to take a minimum.

`packingAlpha` is defined as the square root of the least Gram eigenvalue.
`canonical_repeatable_instrument` constructs its records by normalizing the
completed sector projections, proves CP of each operation, total trace
preservation and the exact labelwise composition law. Zero outcomes do not
require dividing by a nonzero trace. The summed channel is also proved CP
and idempotent. The instrument is for the prescribed completion `F`, not the
original measurement `E`.

`canonical_ancilla_overlap_floor` derives the width-conditioned overlap
inequality from these constructed objects for every finite reference type.
`completionChannel_ancilla_contracts` proves contractivity of the repeatable
channel on Hermitian inputs with references. This is **not** an estimate of
the difference between the original and completed measurement channels.

## What remains before “full formalization” is justified

1. Prove the principal-angle/operator-norm sector displacement bound. The
   Gram/polar Loewner bounds are checked, but this additional norm conclusion
   has not been derived.
2. Prove the sharp pure-state trace-distance estimate and its application to
   the common labelled readout of the two constructed dilations.
3. Prove the input-reduction/extension argument connecting that estimate to
   the full stabilized norm over **general complex matrices**, then the final
   width-conditioned and unconditional coefficient-two bounds.

`diamondSize` is an extended-nonnegative-real supremum over every finite
ancilla and every complex matrix of trace norm at most one. It has no factor
of one half and does not replace this set of inputs by pure states without
proof. Its general supremum lemma is only an upper-bound rule; the requisite
all-input estimate for `measurementMap E - measurementMap F` is not proved.
Finiteness and the final numeric bound for that difference remain unproved.

The paper's later sharp envelopes, joint asymptotics, record correction and
computer-assisted comparisons are additional targets, not consequences of
this Lean build. This development proves no new mathematical claim beyond
the stated lemmas and does not establish novelty or external review.

## Axiom gate and reproduction

`lake build` also builds [RCProofAudit](RCProofAudit.lean). It traverses **all**
declarations in the `RCProof` namespace and rejects any transitive axiom except
`propext`, `Classical.choice` and `Quot.sound`. The run manifest distinguishes
the 152 written lemmas/theorems from generated equations, structure projections
and tactic helpers. Definitions of maps and norms are not counted as proofs.

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

See the [completion formalization report](../research/LEAN_COMPLETION_FORMALIZATION_2026-11-01.md)
for the current run and the [earlier operator report](../research/LEAN_OPERATOR_FORMALIZATION_2026-11-01.md)
for the 69-theorem snapshot. The frozen review paper's count of 13 describes
its earlier release; this README tracks subsequent development.
