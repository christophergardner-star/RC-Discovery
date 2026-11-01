# Frozen theorem: principal angles and full diamond bound

1 November 2026. This extends the historical
[152-lemma construction report](LEAN_COMPLETION_FORMALIZATION_2026-11-01.md).
The two remaining proof gaps identified there are closed. The project now has
194 written lemmas/theorems. The broader paper remains partially formalized;
novelty and external review remain unresolved.

## Checked statement

[`RCProof.frozen_theorem`](../lean/RCProof/FrozenTheorem.lean) starts with a
finite complex POVM, `0 < delta < 1/2`, injective canonical sector synthesis,
and a nonzero threshold sector for each nonzero effect. It assembles:

- the prescribed completed POVM, with positivity and normalization in its type;
- `||P_j-Q_j|| <= sqrt(1-alpha^2)` and equal ranks;
- exact same-label unit-sector action and the residual spectral gap;
- the explicit CP instrument, correct outcome probabilities, total trace
  preservation and exact repeatability;
- the unhalved bound
  `diamondSize(M_E-M_F) <= 2 min(1, sqrt(1-alpha^2)+sqrt(delta))`.

The least Gram eigenvalue defines `alpha`. The theorem takes a nonempty
sector index for this minimum. On a nonzero physical space,
`sectorIndex_nonempty` derives nonemptiness from the same active-label
hypothesis; this does not exclude individual empty sectors or zero outcomes.
Threshold eigenvalues are included, without a simplicity assumption.

[`FrozenDiamond`](../lean/RCProof/FrozenDiamond.lean) also proves the conditional
bound `2 sqrt(1-alpha^2 c)` for `c=1-delta` under the paper's width condition.
The unconditional theorem removes that condition: if the sum of error radii
is below one, the condition follows; otherwise the universal channel bound
two applies.

## How the sharp norm argument closes

[`CanonicalAngles`](../lean/RCProof/CanonicalAngles.lean) derives the projection
compression inequalities from the canonical polar factor. The general
two-sided compression lemma controls the operator norm of the difference.
No principal-angle estimate is supplied as a hypothesis.

The channel proof takes a shorter route than a pure-state reduction. For
isometries W,V with `Re(W*V) >= eta I`, `0 <= eta <= 1`, Lean proves

```text
||W-eta V|| <= sqrt(1-eta^2)
||eta W-V|| <= sqrt(1-eta^2)
WXW* - VXV* = (W-eta V)XW* + VX(eta W-V)*.
```

The rectangular trace-norm sandwich inequality and triangle inequality then
give `2 sqrt(1-eta^2) ||X||_1` for **every complex X**. The isometry and overlap
facts lift to every finite ancilla. The common labelled readout is expressed
as a normalized rectangular Kraus family, and its trace-norm contraction is
proved on every complex input as well.

The required trace-norm duality is proved locally. A spectral pseudoinverse
constructs an attaining contraction even for singular matrices; no
invertibility, unit-trace, positivity or Hermiticity restriction is imposed
on X. No external quantum-information library or proof axiom was added.

`diamondSize` is unchanged: an extended nonnegative-real supremum over every
finite ancilla and every complex matrix with trace norm at most one. It is
not a supremum only over states. The resulting numerical upper bound also
establishes finiteness for the channel difference.

## Reproduction and limits

```powershell
python experiments/test_lean_formalization.py --negative-controls --out research/lean_frozen_theorem_2026-11-01
python experiments/test_repository_claim_discipline.py
```

The [run manifest](lean_frozen_theorem_2026-11-01/manifest.json) records source
hashes, the required theorem names and both rejection controls. The default
build audits all 379 project declarations, including 310 kernel theorem
declarations (generated equations and helpers included). These are distinct
from the 194 explicitly written lemmas/theorems. The only permitted transitive
axioms are `propext`, `Classical.choice`, and `Quot.sound`; an injected custom
axiom and an injected unfinished proof must both be rejected.

This closes the frozen operator/channel chain. It does not formalize the
paper's later exact perfect-packing envelope, joint asymptotics, record
correction, accessibility certificate or numerical comparison certificates.
It does not establish novelty or replace an external specialist's check that
the formal statement captures the intended mathematical claim. The frozen
PDF and older validation reports retain their historical counts.
