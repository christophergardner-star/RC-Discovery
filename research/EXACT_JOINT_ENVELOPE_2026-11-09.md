# Exact joint envelope: internal proof and verification record

9 November 2026. The [new proof](../theory/exact_joint_envelope.md) closes the
general finite-error gap for the prescribed completion, within the original
parameter range. This is an internally proved result with partial Lean
verification, not an externally reviewed or established novel breakthrough.

## Result and change from the previous status

For every exact `0<alpha<=1`, `0<delta<1/2`, the worst-case unhalved diamond
distance is

```text
W(alpha,delta) = 2 sqrt(epsilon) / (2 - sqrt(epsilon)),
epsilon = 1 - alpha^2 (1-delta).
```

The previous enclosure `B(epsilon) <= W <= B(epsilon)+4 delta s` is superseded
by equality. This includes noncommuting selected data and arbitrary finite
ancillas. The previously supplied general lower family attains the value.
It also determines the higher asymptotic terms by expanding the exact formula.

The proof changes the selected effects from `P_j E_j P_j` to the common floor
`c P_j`. The remainder stays positive. The selected filter `C=sqrt(c) H` is
positive, and its squared deficit is exactly the residual square. Combining
the two signed Kraus decompositions gives the exact scalar certificate

```text
2-g(x) = 4/b^3 (x-m) [m-(1-b)x] >= 0,
b^2+m^2=1,  m<=x<=1,  0<b<1.
```

This removes the old commutator correction. It does not say that commutators
vanish, that ancillary references never help individual examples, or that
the prescribed target is the closest repeatable target.

## Proof audit

The written proof explicitly checks:

- positivity of `E_j-cP_j`, including equality at the closed threshold;
- `mI<=C<=I` from the synthesis bounds, without a width condition;
- `sum B_j=(R+G)^2` and the exact identity `G^2=U(I-C^2)U*`;
- residual factorization even when the remainder sum is singular;
- the two signed Kraus identities on arbitrary complex matrices;
- the combined Gram bound, with the selected/residual correlation retained;
- arbitrary finite ancillary amplification;
- attainment at every exact parameter pair by the existing full-sector family.

The conclusion concerns the finite-dimensional supremum over the admissible
class. Fixed dimension, classification of every extremizer and optimization
over freely chosen repeatable targets are different questions.

## Machine-checked components

[CoupledFilter](../lean/RCProof/CoupledFilter.lean) checks the scalar identity,
its full-interval nonnegativity and the signed operator pair with the coupled
Gram bound. [UniformThreshold](../lean/RCProof/UniformThreshold.lean) checks the
canonical floor split, positive remainder, remainder sum, positive-filter
spectral bounds and the selected-effect factorization.

The [Lean manifest](lean_exact_joint_components_2026-11-09/manifest.json)
records the complete build, source hashes and two rejected negative controls.
The project now contains 342 written lemmas/theorems; the successful audit
checks 614 kernel theorem declarations and 721 total namespace declarations.
Both the extra-axiom and unfinished-proof controls are rejected. Full formalization of
the new canonical channel upper bound and general attaining-family/supremum
assembly is still outstanding. The checked components do not by themselves
constitute a fully formalized exact joint theorem.

## Computational attacks

[The initial attack](../experiments/attack_exact_joint_envelope.py) generated
12,000 candidates, of which 11,880 were admissible and 8,904 lay in the earlier
small-error regime. No tested system witness exceeded the proposed formula.
Ninety full POVM constructions were checked, including the saved finalists.
The [search record](exact_joint_attack_2026-11-09/search.json) is numerical
evidence, not a proof of nonexistence of a counterexample. An unrestricted
version of the old separate-filter Gram estimate failed numerically outside
its proved range; the new coupled estimate does not require it.

[The independent operator test](../experiments/test_exact_joint_envelope.py)
then checked 144 cases: the common-floor split, both signed identities, the
factored Gram deficit, and 432 arbitrary complex inputs with ancillary
dimensions one, two and three. Four attaining-family cases were checked by
full primal and dual measurement-channel SDPs:

| alpha | delta | Predicted distance |
| --- | --- | --- |
| 1 | 0.2 | 0.5760143111 |
| 0.8 | 0.4 | 1.2917927598 |
| 0.4 | 0.45 | 1.8277032525 |
| 0.05 | 0.49 | 1.9974508123 |

The [retained output](exact_joint_envelope_2026-11-09/verification.json)
records solver statuses, feasibility errors and repaired numerical lower/upper
bounds. All four primal/dual gaps are below `1.2e-7`. One primal solve reports
`optimal_inaccurate`; its matrix feasibility and repaired bounds pass the same
independent checks. These are floating-point diagnostics, not exact interval
certificates. The earlier rational lower-family certificates remain available.

## Reproduction

From the repository root with the existing validation environment:

```powershell
.venv-audit/Scripts/python.exe experiments/attack_exact_joint_envelope.py --samples 12000
.venv-audit/Scripts/python.exe experiments/test_exact_joint_envelope.py
.venv-audit/Scripts/python.exe experiments/test_lean_formalization.py --negative-controls --out research/lean_exact_joint_components_2026-11-09
.venv-audit/Scripts/python.exe experiments/test_repository_claim_discipline.py
```

The new evidence has its own dated directories; earlier audit records and
the frozen paper/PDF are not rewritten as if they contained this result.
The repository claim-discipline check passes with 30 required files, eight
source Git objects and 101 canonical local links checked.

## What remains

The exact-envelope research question is closed by the internal analytic proof,
subject to reconstruction and review. Remaining work includes full Lean
assembly, the already listed record-correction and saved-comparison
formalizations, a focused prior-art audit of this exact formula, and external
specialist review. No claim is made that this solves a recognized major open
problem in the wider field. That assessment requires independent evidence.
