# Complete Lean assembly of the exact joint upper bound

**Historical checkpoint:** the later [full joint formalization report](LEAN_EXACT_JOINT_FULL_2026-11-09.md)
supersedes the remaining-work status below. This report and its source-hash
manifest preserve the earlier upper-only audit.

9 November 2026. The new upper theorem is now proved from the actual canonical
POVM construction, on arbitrary complex input matrices with every finite
ancillary space. Its supremum upper bound is also checked. **The general
attaining family and exact joint supremum equality are not yet fully formalized.**

## What is now checked

With `epsilon=1-alpha^2*(1-delta)`, the final theorem proves

```text
diamondSize(M_E-M_(canonicalCompletion E (1-delta)))
  <= ENNReal.ofReal (2*sqrt(epsilon)/(2-sqrt(epsilon))).
```

`diamondSize` is the unhalved stabilized induced trace norm defined in
`Distance.lean`. Its definition ranges over all finite ancillary dimensions
and all complex inputs with trace norm at most one. The proof does not assume
a pure-state reduction, an unproved norm inequality, or the desired canonical
factorization as a hypothesis.

The upper theorem assumes a finite POVM, `0<c<1`, a nonempty full threshold
sector index, and injective canonical synthesis. Thus it applies in particular
to the frozen admissible class with `c=1-delta`, `0<delta<1/2` and active
sectors. No width condition or commutation condition is added.

The formal dependency chain is:

| Module | Established step |
| --- | --- |
| `UniformThreshold` | Common-floor split, positive remainder and canonical filter bounds |
| `UniformRemainder` | Constructs G with `G R=0`, `G^2=U(I-C^2)U*`, the correct remainder sum and vanished residual compression of the selected floor |
| `CoupledFilter` | Signed selected pair and the full-range coupled spectral polynomial bound |
| `CoupledChannel` | Actual combined signed Kraus families, their map identity and total Gram bound |
| `CoupledBound` | Trace-norm estimate for every complex amplified input |
| `CoupledMeasurement` | Constructs the residual contraction from positive effects, including singular sums, and identifies both measurement maps |
| `ExactJointUpper` | Instantiates the data from E, identifies its actual canonical completion, and proves the diamond and worst-case supremum upper bounds |

The final named declarations are `canonical_exact_joint_all_inputs`,
`canonical_exact_joint_diamond_upper`, and `packingWorstCase_exact_joint_upper`.
The latter uses the existing `PackedMeasurement` class; it does not introduce
a scalar surrogate supremum or change the admissible class.

## Verification

The [retained manifest](lean_exact_joint_upper_2026-11-09/manifest.json) records
355 written lemmas/theorems, 642 kernel theorem declarations including generated
ones, and 749 total namespace declarations audited. The only permitted
transitive axioms are `propext`, `Classical.choice`, and `Quot.sound`.
The extra-axiom and unfinished-proof controls both fail for the intended
forbidden-axiom reason. The root import and required-theorem list include the
entire new upper chain, so a build of unrelated helper modules is insufficient
to pass the audit.

The toolchain is unchanged: Lean 4.35.0 and Mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679`.

```powershell
python experiments/test_lean_formalization.py --negative-controls --out research/lean_exact_joint_upper_2026-11-09
python experiments/verify_joint_lower_symbolic.py
python -I experiments/verify_joint_lower_exact.py
```

The new [symbolic lower-family audit](exact_joint_lower_symbolic_2026-11-09/verification.json)
passes 21 nontrivial identities with symbolic dimension and rejects four
corruptions. Seven tautological bookkeeping equalities from its first draft
were removed from the final check count. The existing rational verifier was
rerun: three rational POVMs, 126 exact positivity checks and five rejection
controls pass. Its retained output is unchanged. These checks remain distinct
from Lean's kernel verification.

The earlier [144-case operator and four-SDP diagnostic run](exact_joint_envelope_2026-11-09/verification.json)
is retained as prior evidence, not represented as rerun in this assembly pass.
No numerical implementation changed here. Its solver caveats remain recorded.

## Proof review and novelty

The [expanded lower audit](../theory/exact_joint_lower_audit.md) makes the
parameter-dependent dimension, strict clean-sector spectral gap, basis
invariance and actual supremum connection explicit. In particular the lower
example has old selected eigenvalues exactly at the closed threshold and
permits zero residual coefficients.

The [focused literature comparison](../literature/EXACT_JOINT_COMPARISON_2026-11-09.md)
finds a direct reduction of the signed Kraus norm step to the established
positive-minus-positive Choi SDP. The candidate addition is the explicit
optimal certificate and attaining family for the prescribed completion.
No inspected statement supplies the complete equality; that bounded finding
does not establish novelty or rule out a corollary of other work.

The [reconstruction packet](../review/EXACT_JOINT_RECONSTRUCTION.md) gives the
precise theorem, reading order, source comparison, commands and verification
boundary. No external contact or external reconstruction occurred.

## Remaining work

The variable-size general attaining POVM still needs a Lean construction with
proved positivity/normalization, full threshold recognition, exact packing,
canonical polar identification and witness value. Those results must then
instantiate `PackedMeasurement` to prove the reverse supremum inequality.
The existing perfect-packing construction does not discharge these obligations
for `alpha<1`. Accordingly the analytic exact equality is not described as
fully machine checked.

The older outstanding final record correction and saved comparison-certificate
instantiations are separate paper formalizations. Independent reconstruction
and publication priority remain open. This is a substantial verification
milestone for the stated extremal problem, not evidence of solving a famous
open problem in quantum information.
