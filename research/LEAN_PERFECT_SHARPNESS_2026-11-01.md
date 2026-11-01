# Exact perfect-packing formalization and joint second-order progress

1 November 2026. This report supersedes the outstanding-work list in the
[previous formalization report](LEAN_SHARP_ASYMPTOTIC_PROGRESS_2026-11-01.md).
It does **not** declare the entire paper formalized, externally reviewed or novel.

## Exact perfect packing: closed in Lean

For the prescribed unweighted completion and `0 < delta < 1/2`, Lean now proves

```text
packingWorstCase 1 delta = ofReal (2 sqrt(delta) / (2 - sqrt(delta))).
```

`packingWorstCase` is an actual supremum over finite POVMs at the exact packing
parameter and threshold, with injective synthesis and nonzero full sectors for
active labels. It is not a scalar function assumed to represent the problem.

The checked chain comprises:

- [PerfectResidual](../lean/RCProof/PerfectResidual.lean) and
  [PerfectMeasurement](../lean/RCProof/PerfectMeasurement.lean): the signed
  Kraus operator upper bound on every complex input and finite ancillary space.
- [ThresholdRecognition](../lean/RCProof/ThresholdRecognition.lean),
  [PerfectExample](../lean/RCProof/PerfectExample.lean) and
  [PerfectExampleSectors](../lean/RCProof/PerfectExampleSectors.lean): a positive,
  normalized six-dimensional, five-outcome family with its **full closed-threshold
  spectral projectors**, including the eigenvalue exactly at the threshold.
- [PerfectGeometry](../lean/RCProof/PerfectGeometry.lean) and
  [PerfectAttainment](../lean/RCProof/PerfectAttainment.lean): exact packing
  parameter one, the actual canonical completion, a normalized density input
  and a contraction witness attaining the upper bound.
- [WorstCase](../lean/RCProof/WorstCase.lean): the supremum definition, universal
  upper bounds, and an admissible attaining family giving the displayed equality.
- [PerfectAsymptotic](../lean/RCProof/PerfectAsymptotic.lean): the exact expansion
  and actual perfect-packing limit `(W(1,b^2)-b)/b^2 -> 1/2` as `b -> 0+`.

These results do not assert that this completion is closest among all repeatable
targets. They concern the prescribed completion.

## Joint packing: stronger analytic result, partial formalization

The new [second-order proof](../theory/joint_second_order.md) constructs a lower
family at **every exact** `0 < alpha <= 1`, `0 < delta < 1/2`. With

```text
s = 1 - alpha^2 + delta
epsilon = 1 - alpha^2 (1-delta)
B(x) = 2 sqrt(x) / (2 - sqrt(x))
```

it proves internally

```text
B(epsilon) <= W(alpha,delta) <= B(epsilon) + 4 delta s   (s <= 1/4),
W(alpha,delta) = sqrt(s) + s/2 + O(s^(3/2)).
```

The remainder is uniform, with explicit constants in the note. Thus the joint
subleading coefficient is determined analytically as `1/2`; it should no longer
be listed as an untouched research question. This is an internally derived
proof, not external confirmation or a publication-priority claim.

For each fixed ratio `(1-alpha^2)/delta`, the new family has fixed dimension.
The ratio-one path needs only seven dimensions and six outcomes. The lower
family also gives nonemptiness of the exact-parameter class, connecting the
analytic lower bound to the actual supremum. The commuting canonical-filter
subclass has exact envelope `B(epsilon)` when `epsilon <= 3/4`.

The key [positive-filter signed Kraus lemma](../lean/RCProof/PositiveFilter.lean)
is checked in Lean. The variable-size joint lower family, its full canonical
identification and its membership proof for `PackedMeasurement` are **not yet
formalized**. Nor is the assembled improved noncommuting upper bound. Therefore
the full joint sharp asymptotic theorem remains outside the machine-checked
scope, despite the analytic proof and checked components.

## Accessibility and comparison certificates

[RecordAccessibility](../lean/RCProof/RecordAccessibility.lean) and
[RecordNorm](../lean/RCProof/RecordNorm.lean) prove both sides of

```text
(1 - 2e) max_j ||Phi(sigma_j)-sigma_j||_1
    <= ||Phi^2-Phi||_diamond
    <= max_j ||Phi(sigma_j)-sigma_j||_1.
```

The lower proof uses an actual accessible density input and the reverse
triangle inequality. The upper proof constructs signed preparation Kraus
operators and covers all complex inputs and finite ancillas. The additional
[spectral bridge](../lean/RCProof/RecordSpectral.lean) constructs the density
input from an eigenprojector, defines `e` from the largest eigenvalues of the
effects and attains the maximum record residual. With zero effects retained,
this definition gives `e=1` and a vacuous lower bound; discard exact zero labels
as in the paper for the informative certificate.

[MeasurementCertificate](../lean/RCProof/MeasurementCertificate.lean) proves
soundness of a measurement diamond dual certificate from the actual matrix
conditions `Y_j +/- D_j >= 0` and `sum Y_j <= B I`. It does not assume a channel
distance conclusion. It also does **not** replay the saved rational comparison
certificates or formalize their spectral/polar perturbation error transfers.

The final record-correction construction and its quantitative certificate
remain unfinished in Lean. The direct accessibility estimate is only one
part of that longer argument.

## Verification and reproduction

The pinned Lean/Mathlib toolchain is unchanged. The successful build contains
334 explicitly written lemmas/theorems, 594 kernel theorem declarations
including generated helpers, and 700 total audited namespace declarations.
The injected extra axiom and unfinished-proof controls are both rejected.
Run from the repository root:

```powershell
.venv-audit/Scripts/python.exe experiments/test_lean_formalization.py --negative-controls --out research/lean_perfect_sharpness_2026-11-01
.venv-audit/Scripts/python.exe experiments/test_joint_second_order.py
.venv-audit/Scripts/python.exe -I -S experiments/verify_joint_lower_exact.py
.venv-audit/Scripts/python.exe experiments/test_repository_claim_discipline.py
```

The [Lean manifest](lean_perfect_sharpness_2026-11-01/manifest.json) records exact
source hashes, declaration counts and rejected negative controls. Every
project declaration is audited for transitive axioms; only `propext`,
`Classical.choice` and `Quot.sound` are permitted. Linter/deprecation warnings
are not treated as mathematical failures.

The repository claim-discipline check also passes: 30 required files, eight
source Git objects and 98 canonical local links checked. Earlier audit
directories are retained unchanged.

The [numerical run](joint_second_order_2026-11-01/verification.json) checks 29
lower-family instances, 36 upper-bound cases and 432 arbitrary complex-input
and ancillary tests. The [exact rational run](joint_second_order_2026-11-01/exact_verification.json)
checks three nine-dimensional, eight-outcome POVMs with 126 exact PSD checks
and five corrupted-certificate rejection controls. Finite tests supplement
the written universal argument; they do not prove it by themselves.

## Still outstanding

1. Lean construction of the general joint lower family and its actual-supremum
   bridge, plus the assembled improved joint upper theorem and limit.
2. Lean formalization of the final record correction and of the saved
   comparison certificates with their perturbation error transfers.
3. The exact noncommuting general finite-error optimum. The current analytic
   enclosure has width at most `4 delta s` in the small-error regime; it does
   not prove equality with its lower endpoint.
4. External specialist reconstruction, publication novelty and the other
   previously listed questions such as uniqueness of the comparison crossing.

The frozen paper/PDF and prior audit directories remain historical snapshots.
The second-order note is a new supplement, not a claim that those frozen
artifacts already contain the extension.
