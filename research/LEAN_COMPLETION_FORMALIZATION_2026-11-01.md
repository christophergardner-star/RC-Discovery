# Canonical completion and instrument formalization

1 November 2026. Continuation of the [69-theorem operator extension](LEAN_OPERATOR_FORMALIZATION_2026-11-01.md).
The current development has **152 explicitly written lemmas/theorems**.
The full measurement diamond-distance theorem is **not yet machine checked**.
This work formalizes existing arguments; it is not a new discovery or a novelty
assessment.

## Canonical construction: closed

[CanonicalFrame.lean](../lean/RCProof/CanonicalFrame.lean) defines the sector
index type as all pairs `(label, eigenvector index)` whose eigenvalue is at
least the threshold `c`. It builds the synthesis matrix, coordinate projections
and block embeddings explicitly. The Gram, full-range, support and normalization
identities are proved. Eigenvalues equal to the threshold and degenerate
eigenspaces are included in full.

`canonical_hybrid_dilation_of_injective` now starts with the POVM and injectivity
of this constructed synthesis matrix. It derives the Gram positivity and
constructs the frame and polar isometry before proving `V*V=I` and all label
compressions. The previously supplied `SpectralFrame`, `B_j=T C_j` and
positive-Gram inputs are no longer additional premises of this theorem.

`sectorIndex_nonempty` proves nonemptiness of the sector domain from a nonempty
physical space and the paper's condition that every nonzero effect has a
nonzero full threshold sector. This justifies taking a least eigenvalue.

## Quantitative packing: core bounds closed

[Packing.lean](../lean/RCProof/Packing.lean) constructs the selected diagonal
square-root operator `D`, proves `sqrt(c) I <= D <= I`, and derives
`W*J=TD=UHD`. It does not assume the overlap factorization.

[PackingParameter.lean](../lean/RCProof/PackingParameter.lean) defines `alpha`
as the square root of the least Gram eigenvalue, the intrinsic finite-matrix
definition of the least singular value. It proves positivity from injectivity,
`alpha <= 1` for canonical synthesis, and the Gram/polar lower bounds. No
separate compatibility theorem with Mathlib's sorted singular-value sequence
is asserted.

[PackingBounds.lean](../lean/RCProof/PackingBounds.lean) derives `E_j >= c P_j`
from the spectral construction, then `c T T* <= I` from POVM normalization.
For injective synthesis and `c>0`, it proves `T*T <= c^(-1) I` and
`H <= (sqrt(c))^(-1) I`.

[Ancilla.lean](../lean/RCProof/Ancilla.lean) specializes the checked Jordan
inequality to these objects. For `0<c<=1` and the explicit width condition it
proves the global overlap floor and its lift to **any finite reference type**.
The principal-angle/operator-norm sector displacement bound and the final
unconditional scalar-to-channel conclusion remain open.

## Repeatable instrument: closed for the prescribed completion

[Instrument.lean](../lean/RCProof/Instrument.lean) defines complex-linear
matrix maps and their entrywise reference amplification. An explicit Kraus
representation proves complete positivity of a positive measure-and-prepare
operation. The amplification positivity proof handles arbitrary finite
reference types, not only unassisted inputs.

[CanonicalInstrument.lean](../lean/RCProof/CanonicalInstrument.lean) constructs
the prepared record on each nonzero completed sector by normalizing its
projection. It proves positivity and unit trace where the corresponding
completed effect is nonzero. The zero-trace case is handled without assuming
that every outcome is active.

Under synthesis injectivity and the original nonzero-sector hypothesis,
`canonical_repeatable_instrument` proves:

- complete positivity of each operation;
- total trace preservation;
- the exact composition law `I_i(I_j(X)) = if i=j then I_j(X) else 0`.

The outcome trace equals the probability defined by the completed effect.
The summed channel is also proved completely positive and idempotent. These
are properties of the instrument realizing `F_j`, not a claim that the
original effects `E_j` themselves admit this repeatable instrument.

## Trace norm and ancillas: foundations checked, distance bound open

[Distance.lean](../lean/RCProof/Distance.lean) defines the standard trace norm
as `Re Tr sqrt(X*X)` using Mathlib's positive functional calculus, and proves
compatibility with the explicit positive root. It defines the measurement
map and proves its trace preservation.

`diamondSize` is the **unhalved** stabilized induced trace-norm supremum over
all finite ancilla sizes and all complex input matrices with trace norm at
most one. Its codomain is the extended nonnegative reals, so finiteness is not
silently assumed. This definition does not substitute pure states or density
matrices for arbitrary inputs. The supremum upper-bound lemma is a general
rule, not the missing estimate for the difference of the two measurements.

[TraceNorm.lean](../lean/RCProof/TraceNorm.lean) proves the sum-of-absolute-
eigenvalues formula for Hermitian inputs. A positive spectral majorant then
proves trace-norm contractivity of every positive trace-preserving linear
map on Hermitian inputs. The estimate is derived, not taken as a hypothesis.

[AncillaContractivity.lean](../lean/RCProof/AncillaContractivity.lean) proves
trace preservation under reference amplification, positive amplification of
the constructed completion channel, and its trace-norm contractivity on
Hermitian inputs with arbitrary finite references. **Contractivity of this
channel is not a bound on `measurementMap E - measurementMap F`.**

The remaining analytical obligations are the sharp pure-state trace-distance
estimate, its application to the common labelled readout, and the reduction
or extension to all inputs in the stabilized induced norm. The final
width-conditioned and unconditional coefficient-two distance bounds have not
been exported as Lean theorems. The later sharp envelopes and comparison
certificates are also outside this formalization.

## Reproduction and audit

```text
python experiments/test_lean_formalization.py --negative-controls --out research/lean_completion_formalization_2026-11-01
```

The [build log](lean_completion_formalization_2026-11-01/build.log) records the
successful default Lean build and transitive axiom audit. All **313** project
declarations passed; **247** are theorem declarations after generated helpers
are included, versus **152** explicitly written lemmas/theorems. Both negative
controls were rejected for the intended reason. The
[manifest](lean_completion_formalization_2026-11-01/manifest.json) records source
hashes, the written theorem count, generated-declaration counts and the
required theorem names. Generated helpers and definitions are not presented
as additional independent mathematical proofs.

The [extra-axiom control](lean_completion_formalization_2026-11-01/extra_axiom.log)
and [unfinished-proof control](lean_completion_formalization_2026-11-01/unfinished_proof.log)
must fail for the intended forbidden dependencies. The default audit permits
only `propext`, `Classical.choice` and `Quot.sound` for every declaration in
the project namespace. Toolchain and Mathlib pins are unchanged; no external
quantum-information library has been imported or vendored.

The earlier 13- and 69-theorem releases and their evidence remain historical
snapshots. The [Lean README](../lean/README.md), main README, status ledger and
reviewer guidance describe this subsequent development. No external review or
complete machine verification of the paper is claimed.
