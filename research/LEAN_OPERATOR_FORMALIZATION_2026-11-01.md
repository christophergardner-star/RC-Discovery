# Lean operator formalization extension

1 November 2026. **Partial operator formalization, not a machine-checked proof
of the full theorem.** The project now contains 69 written lemmas/theorems,
56 more than the 13 in the frozen review release. There is no change to the
mathematical theorem or novelty claim.

## What was proved

The [spectral module](../lean/RCProof/Spectral.lean) constructs the full
threshold projector using Mathlib's Hermitian eigenbasis. It proves positivity,
idempotence and commutation, constructs a positive square root, and proves its
square and Gram identities. The spectral upper envelope is derived from
`I-E >= 0`; compression then gives the residual spectral-gap inequality.
Eigenvalues at the threshold are included. No assumed spectral envelope is
needed by the new construction.

The [completion module](../lean/RCProof/Completion.lean) defines finite POVMs
and proves each effect is at most the identity. It constructs the completed
POVM from a coordinate POVM and an isometry, proving positivity, normalization
and exact action on matching and orthogonal coordinate sectors.

The [Naimark module](../lean/RCProof/Naimark.lean) explicitly stacks positive
roots and constructs the label projections. It proves `W*W=I` and each
`W*Lambda_j W=E_j`, as well as rectangular cross-compression formulas.

The [polar module](../lean/RCProof/Polar.lean) constructs the positive root of
the Gram matrix and the polar isometry using its inverse. Positive definiteness
of the Gram matrix implies invertibility; `U*U=I` and `UH=T` are then proved,
not assumed.

The [assembly module](../lean/RCProof/Assembly.lean) connects these constructions.
Given a spectral frame, an isometry containing its range and the stated
coordinate factorization, it derives the global and labelwise cross-zero
identities. The constructed hybrid has `V*V=I` and
`V*Lambda_j V=UC_jU*+RE_jR`. Its polar version constructs the isometry from the
synthesis matrix. Its residual-gap theorem obtains the effect upper bound
from the POVM and obtains the spectral envelope from the actual projector.

The [Jordan module](../lean/RCProof/Jordan.lean) proves the noncommuting estimate
used in Lemma 2 of the paper. It first proves `X^2 <= hX` from
`0 <= X <= hI`, controls `XY+YX` using a positive square, and proves

`(HD+DH)/2 >= alpha*d0*I`

under the explicit Loewner bounds and width condition
`(M-alpha)*(1-d0) <= 4*alpha*d0`, with `alpha >= 0`, `d0 > 0` and `M >= alpha`.
The proof includes `M=alpha` and assumes no commutation of `H` and `D`.

## Validation and trust boundary

The recorded command was:

```text
python experiments/test_lean_formalization.py --negative-controls --out research/lean_operator_formalization_2026-11-01
```

- [Build log](lean_operator_formalization_2026-11-01/build.log): passed with the
  pinned Lean 4.35.0 / Mathlib toolchain. All new proof modules were compiled
  during development; the recorded final build replays their successful results.
- [Manifest](lean_operator_formalization_2026-11-01/manifest.json): records the
  repository-owned Lean source/configuration hashes, required theorem names,
  counts and explicit partial scope.
- [Extra-axiom control](lean_operator_formalization_2026-11-01/extra_axiom.log):
  rejected for the intended forbidden axiom.
- [Unfinished-proof control](lean_operator_formalization_2026-11-01/unfinished_proof.log):
  rejected for `sorryAx`, rather than merely emitting a warning.

The [default-build axiom gate](../lean/RCProofAudit.lean) checks all 143
declarations in the `RCProof` namespace and their transitive axiom dependencies.
Only `propext`, `Classical.choice` and `Quot.sound` are permitted. There are
105 theorem declarations after Lean-generated equations, projections and tactic
helpers are counted; **69** is the number of explicitly written lemmas/theorems.
No additional axioms or unfinished proofs occur in the checked development.

This is a local Lean kernel check, not an external reconstruction. An axiom
audit does not certify that the chosen formal definitions match every word of
the paper, nor does it eliminate explicit hypotheses in a theorem statement.
Two external quantum-information libraries were inspected locally for possible
future reuse; neither was imported, vendored or made a trusted dependency.

## Obligations that remain open

The `SpectralFrame` structure is still supplied as input. Its fields assert
spectral support, full range and normalized block Gram matrices. The polar
assembly additionally assumes `B_j=T C_j` and a positive definite synthesis
Gram matrix. A constructor proving all these properties from the original
POVM/direct-sum assumptions remains to be written. Thus even the assembled
dilation theorem does not yet start from only the paper's original hypotheses.

Also outstanding are the definition/identification of the packing parameter,
quantitative polar and principal-angle estimates, construction and bounds for
the block operator `D`, and the overlap identity `W*J=UHD`. The checked Jordan
lemma has not yet been connected to the complete measurement-specific norm
estimate.

The development has no complete density-operator/instrument construction,
trace-norm infrastructure, arbitrary-reference contraction proof or final
unhalved diamond-norm theorem. It also does not formalize the later exact
envelopes, joint asymptotics or rational comparison certificates.

The acceptance criterion for full formalization is an exported theorem whose
only mathematical premises are the frozen theorem's original hypotheses and
whose conclusion uses the correctly defined completion and diamond norm.
Assuming a missing spectral, overlap or channel estimate would not meet that
criterion. See [the current Lean README](../lean/README.md) for the dependency
boundary and reproduction commands.

The frozen review manuscript and its previous verification evidence retain
their earlier count of 13. Current README/status/reviewer guidance identifies
this subsequent extension without rewriting the historical release evidence.
