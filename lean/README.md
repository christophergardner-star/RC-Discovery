# Lean 4 formalization

The frozen construction and its coefficient-two diamond-norm estimate are
now machine checked. As of 1 November 2026, the project contains 334 explicitly
written lemmas/theorems. The assembled statement is
[`frozen_theorem`](RCProof/FrozenTheorem.lean): canonical sectors, equal ranks,
principal-angle bound, completed POVM and sector action, residual gap,
repeatable CP/TP instrument with the correct outcome probabilities, and the
unhalved diamond bound over all complex inputs and all finite ancillas.
The exact perfect-packing operator bound, attaining POVM, actual worst-case
supremum, perfect-packing second-order limit and direct accessibility estimate
are also checked. This does not formalize every later result in the paper.

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
| [PrincipalAngle](RCProof/PrincipalAngle.lean) | 2 | Operator norm from positivity; projection distance from two-sided compressions |
| [CanonicalAngles](RCProof/CanonicalAngles.lean) | 3 | Actual canonical sector displacement and equal ranks |
| [TraceDuality](RCProof/TraceDuality.lean) | 3 | Gram/norm equivalence and singular-safe contraction polar factorization |
| [TraceInequalities](RCProof/TraceInequalities.lean) | 7 | Trace-norm duality, attaining contraction, triangle and rectangular sandwich inequality |
| [SharpDistance](RCProof/SharpDistance.lean) | 4 | Sharp arbitrary-complex-input isometry comparison, with arbitrary ancillas |
| [KrausContraction](RCProof/KrausContraction.lean) | 4 | Normalized rectangular Kraus contraction on all complex inputs |
| [MeasurementDistance](RCProof/MeasurementDistance.lean) | 11 | Explicit readout, amplification, full overlap-to-diamond transfer and universal bound two |
| [DiamondScalar](RCProof/DiamondScalar.lean) | 2 | Removal of the width assumption in the nontrivial regime |
| [FrozenDiamond](RCProof/FrozenDiamond.lean) | 4 | Actual completion, conditional sharp bound and unconditional frozen diamond estimate |
| [FrozenTheorem](RCProof/FrozenTheorem.lean) | 2 | Canonical residual gap and assembled frozen theorem |
| [AncillaContractivity](RCProof/AncillaContractivity.lean) | 3 | Trace preservation and Hermitian trace-norm contraction of the constructed channel with references |
| [SignedKraus](RCProof/SignedKraus.lean) | 6 | Signed Kraus trace-norm bound from a combined Gram bound, for all complex inputs |
| [SharpResidual](RCProof/SharpResidual.lean) | 6 | Residual bound `2 sqrt(epsilon)/sqrt(4-epsilon)`, including every finite ancilla |
| [SelectedCorrection](RCProof/SelectedCorrection.lean) | 6 | Canonical selected-operator correction and contraction comparison |
| [PositiveFamily](RCProof/PositiveFamily.lean) | 10 | Constructed singular-safe positive-family factorization and amplified contraction |
| [CanonicalSplit](RCProof/CanonicalSplit.lean) | 10 | Positive selected/remainder effects, contraction and canonical defect bound |
| [RemainderMap](RCProof/RemainderMap.lean) | 5 | Residual measurement estimate through an explicit trace-nonincreasing Kraus map |
| [CanonicalRemainder](RCProof/CanonicalRemainder.lean) | 1 | Constructs the canonical remainder data from the POVM |
| [SelectedMeasurement](RCProof/SelectedMeasurement.lean) | 2 | Selected-effect measurement correction with references |
| [JointUpper](RCProof/JointUpper.lean) | 3 | Actual canonical all-input and diamond upper bounds without a width condition |
| [EnvelopeAnalysis](RCProof/EnvelopeAnalysis.lean) | 9 | Scalar perfect-envelope optimization, expansion and conditional joint-limit transfer |
| [JointAsymptotic](RCProof/JointAsymptotic.lean) | 4 | Uniform scalar estimates and actual canonical `sqrt(s)+5s` diamond upper bound |

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

## Closed gaps and remaining scope

The principal-angle bound is derived from the canonical synthesis, not supplied
as a premise. The trace-distance argument works directly for every complex
matrix X, so no pure-state reduction is needed. From Re(W*V) >= eta I, the
shifted differences W - eta V and eta W - V both have operator norm at most
sqrt(1-eta^2). The identity

```text
WXW* - VXV* = (W - eta V)XW* + VX(eta W - V)*
```

and the proved rectangular trace-norm inequality give the sharp constant
2 sqrt(1-eta^2). The common labelled readout is an explicit normalized Kraus
family, whose contraction is proved on all complex inputs.

`diamondSize` is an extended-nonnegative-real supremum over every finite
ancilla and every complex matrix of trace norm at most one. It has no factor
of one half and does not replace this set of inputs by pure states without
proof. The all-input estimate, its transfer to this supremum, the conditional
2 sqrt(1-alpha^2 c) bound, and the unconditional
2 min(1, sqrt(1-alpha^2) + sqrt(delta)) bound are now proved. In particular the
extended-real supremum is bounded by a finite number.

The assembled theorem assumes a nonempty sector index to define its least
eigenvalue. `sectorIndex_nonempty` derives this from the active-label hypothesis
when the input space is nonzero. Individual zero labels/sectors are allowed.

For the later joint theorem, put `epsilon=1-alpha^2 c`,
`h=max(1-alpha,1/sqrt(c)-1)+1-sqrt(c)`. With `0<c<1`, nonempty canonical
sectors and injective synthesis, `canonical_joint_diamond_upper` proves

```text
diamondSize(M_E - M_F) <= min(2, 2 sqrt(epsilon)/sqrt(4-epsilon) + 2h).
```

There is no width hypothesis. `canonical_joint_uniform_diamond_upper` then
proves the bound `sqrt(s)+5s` when `s=1-alpha^2+(1-c)<=1/4`. The residual
proof uses a signed Kraus decomposition and its combined Gram bound directly
on complex inputs. The positive remainder is factored using a rectangular
contraction polar decomposition, including singular sums.

`PerfectMeasurement` proves the exact perfect-packing operator upper bound.
`PerfectExampleSectors` and `PerfectAttainment` construct a normalized attaining
POVM, recognize its full closed-threshold sectors, identify the actual canonical
completion and certify its diamond distance. `WorstCase` defines the actual
exact-parameter supremum and proves `packingWorstCase 1 delta = B(delta)` for
`0 < delta < 1/2`, where `B(x)=2 sqrt(x)/(2-sqrt(x))`. `PerfectAsymptotic`
proves the expansion and second-order limit for this actual supremum.

`RecordAccessibility`, `RecordNorm` and `RecordSpectral` prove the two-sided
direct accessibility estimate, including the spectral density-input witness
and an attained maximum of record residuals. `MeasurementCertificate` proves
generic measurement diamond dual-certificate soundness. `PositiveFilter`
proves the signed Kraus lemma used in the new joint second-order proof.

`joint_envelope_limit_of_uniform_bounds` proves a limit for arbitrary sequences
under explicit upper and lower assumptions. The actual general joint lower
family and its membership in the worst-case class remain unformalized, as does
the assembled improved noncommuting upper bound. The full joint sharp asymptotic
theorem is therefore not claimed as Lean checked.

The final record correction and the saved comparison-certificate instantiations
with their spectral/polar perturbation transfers also remain unfinished. See
the [current report](../research/LEAN_PERFECT_SHARPNESS_2026-11-01.md) for the
precise boundary. This development does not establish novelty or external review.

## Axiom gate and reproduction

`lake build` also builds [RCProofAudit](RCProofAudit.lean). It traverses **all**
declarations in the `RCProof` namespace and rejects any transitive axiom except
`propext`, `Classical.choice` and `Quot.sound`. The run manifest distinguishes
the 334 written lemmas/theorems from generated equations, structure projections
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

See the [latest progress report](../research/LEAN_SHARP_ASYMPTOTIC_PROGRESS_2026-11-01.md)
for the current run. The frozen theorem, completion and operator reports retain
the historical 194-, 152- and 69-theorem snapshots. The frozen review paper's count of 13 describes
its earlier release; this README tracks subsequent development.
