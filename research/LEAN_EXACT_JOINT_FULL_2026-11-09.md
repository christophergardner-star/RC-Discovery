# Complete Lean proof of the exact joint extremal theorem

9 November 2026. The prescribed-completion extremal problem is now checked
in Lean in both directions, including an actual attaining POVM at every
admissible parameter pair. This supersedes the remaining-work status of the
[upper-only checkpoint](LEAN_EXACT_JOINT_UPPER_2026-11-09.md).

## The checked statement

For `0<a<=1` and `0<delta<1/2`,

```text
packingWorstCase a delta
  = ENNReal.ofReal (2*b/(2-b)),
b = sqrt(1-a^2*(1-delta)).
```

The final declaration is
[`packingWorstCase_exact_joint`](../lean/RCProof/ExactJointAttainment.lean).
The supremum is the existing `packingWorstCase` over `PackedMeasurement`,
defined in `WorstCase.lean`. That file and its admissibility conditions were
not changed. In particular the class uses exact packing, full closed-threshold
sectors, injective synthesis, and a nonzero selected sector for every nonzero
label. Physical dimension and outcome count range over finite integers.

The norm is the **unhalved** diamond distance of the measurement channels.
The upper proof ranges over all complex inputs and every finite ancillary
dimension. The lower witness needs no ancillary system. This proves that
an unassisted input attains the worst-case value for the constructed family;
it does not assert that ancillary assistance never helps for other POVMs.

## The newly closed lower direction

`JointFamilyParameters` proves the existence of a sufficiently large integer
dimension for every pair. `JointFamilyPOVM` constructs positive effects and
proves normalization. `JointFamilySectors` identifies their **full** threshold
projectors, including old eigenvalues exactly on the threshold and a strict
gap for the extra low effects.

`FrameRecognition` supplies a basis-independent canonical polar recognition
lemma and an exact least-Gram-eigenvalue argument. `JointFamilyCanonical`
then identifies the actual rounded sectors, proves packing exactly `a`,
and obtains the prescribed residual completion. These are proved properties
of the family, rather than supplied hypotheses of its final distance theorem.

`JointFamilyWitness` constructs a positive trace-one state, a contraction
test and its exact trace pairing `2*b/(2-b)`. Together with the independently
proved canonical upper estimate this gives the exact diamond distance.

`MatrixRelabel` and `JointFamilyRelabel` transport the example from the
convenient sum-indexed coordinates to finite indices. They reprove full
sector recognition and exact canonical packing after the transport.
`JointFamilyData.packed` is an actual member of the original supremum class;
`packed_distance` supplies the reverse inequality. No surrogate scalar
supremum, enlarged class or chosen eigenvector phase is used.

## Asymptotic consequences

`joint_worstCase_expansion` proves the exact identity

```text
W = b + b^2/2 + b^3/(2*(2-b)).
```

Writing `s=1-a^2+delta`, the new theorems
`joint_worstCase_leading_limit` and `joint_worstCase_second_order_limit`
prove, along every admissible sequence with `s -> 0`,

```text
W/sqrt(s) -> 1,
(W-sqrt(s))/s -> 1/2.
```

These are statements about the actual supremum. They no longer depend on
postulated upper/lower bounds for an unspecified scalar function.
`joint_worstCase_second_ratio_bounds` also supplies an explicit uniform
error bound when `s<=1/4`: the second ratio lies between
`1/2-2*sqrt(s)` and `1/2+sqrt(s)`. This check is sufficient for the limit;
it does not claim to formalize the tighter historical remainder constants.

## Verification and reproduction

The [full audit manifest](lean_exact_joint_full_2026-11-09/manifest.json)
records the source hashes, pinned toolchain, required final declarations,
counts and results. The audit passed with 481 explicitly written lemmas/theorems,
886 kernel theorem declarations including generated ones, and 1,043 total
namespace declarations. Both deliberate-failure controls were rejected for
their intended forbidden-axiom reasons.
The root import includes the entire upper and lower chain and both limits.
The only permitted transitive axioms are `propext`, `Classical.choice`
and `Quot.sound`. Deliberate extra-axiom and unfinished-proof controls
must be rejected. Linter warnings about proof style are not proof failures.

```powershell
python experiments/test_lean_formalization.py --negative-controls --out research/local_validation/phd_audit/lean_full
python experiments/verify_joint_lower_symbolic.py
python -I experiments/verify_joint_lower_exact.py
```

The symbolic checker additionally passes 21 nontrivial identities with symbolic
dimension and rejects four corruptions. The rational checker passes three
exact POVMs, 126 positivity checks and five rejection controls. Both were run
in this development pass. The earlier 144-case operator/four-SDP run remains
retained prior evidence, not a newly rerun test or a proof of the theorem.

The toolchain remains Lean 4.35.0 and Mathlib
`56a005855ea17e0b0958f73ec801ae140b0a1679`. No additional quantum-information
library or unproved quantum-information axiom is imported.

## What this does and does not settle

This closes the exact finite-error optimum and the joint asymptotic
coefficients **for the stated prescribed completion and admissible class**.
It does not determine the best choice among all repeatable approximations,
the optimum in each fixed dimension, minimum attaining dimension, or values
at excluded boundary parameters. It is not a claim to have solved a famous
open problem of quantum information.

The [prior-art comparison](../literature/EXACT_JOINT_COMPARISON_2026-11-09.md)
identifies the signed Kraus norm principle as a standard Choi-SDP consequence.
The potential contribution is the optimal structured certificate and attaining
family for this exact extremal problem. The inspected primary statements do
not supply the full equality, but that bounded search cannot certify novelty
or rule out a derivation from other work.

Independent reconstruction and publication priority remain open. No external
researcher has been contacted. The
[reconstruction packet](../review/EXACT_JOINT_RECONSTRUCTION.md) is ready for
that next step. Final record correction and saved comparison-certificate
instantiations remain separate unfinished paper formalizations; this is not
a claim that every statement in the repository has been formalized.
