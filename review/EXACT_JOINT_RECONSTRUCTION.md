# Exact joint theorem: reconstruction packet

Christopher Gardner — RC-Discovery, 9 November 2026.
Prepared locally; no reviewer has been contacted and no external review is
represented as completed. VIBE MATH describes the human-directed research
workflow, not a mathematical hypothesis or proof method.

The focused claim is the exact worst-case unhalved diamond distance of the
prescribed completion `F_j=Q_j+R E_j R`:

```text
W(alpha,delta) = 2*sqrt(1-alpha^2*(1-delta))
                 / (2-sqrt(1-alpha^2*(1-delta))),
0<alpha<=1, 0<delta<1/2.
```

The class fixes alpha and delta exactly, uses every eigenvector at or above
the closed threshold, requires injective synthesis and an active sector for
every nonzero outcome, and permits arbitrary finite dimensions and outcomes.
The target is fixed by unweighted polar rounding and residual compression.

Read these three documents in order:

1. [The exact upper proof](../theory/exact_joint_envelope.md): the common-floor
   split, shared squared defect, combined signed Kraus certificate and its
   scalar factorization.
2. [The expanded lower-family audit](../theory/exact_joint_lower_audit.md):
   full-sector recognition, exact conditioning, basis independence, the
   density witness and membership in the written extremal class.
3. [The prior-art reduction](../literature/EXACT_JOINT_COMPARISON_2026-11-09.md):
   the norm-certificate principle is standard; the precise remaining
   contribution under review is the optimal structured certificate and family.

## Verification boundary

| Claim | Current evidence |
| --- | --- |
| Canonical construction, original frozen theorem and repeatable instrument | Lean checked |
| New upper bound for every complex input and finite ancilla | Lean checked in `canonical_exact_joint_all_inputs` |
| New canonical diamond bound and supremum upper bound | Lean checked in `canonical_exact_joint_diamond_upper` and `packingWorstCase_exact_joint_upper` |
| Perfect-packing attaining family and supremum equality | Lean checked |
| General attaining family and exact joint supremum equality | Lean checked in `JointFamilyData.packed_distance` and `packingWorstCase_exact_joint` |
| Joint leading coefficient and subleading coefficient 1/2 | Lean checked for the actual supremum along every admissible path |
| Novelty and independent reconstruction | Open |

The [current Lean evidence](../research/lean_exact_joint_full_2026-11-09/manifest.json)
records source hashes and rejected extra-axiom and unfinished-proof controls.
The [numerical evidence](../research/exact_joint_envelope_2026-11-09/verification.json)
includes four full primal/dual SDPs; one primal status is `optimal_inaccurate`,
with separately checked feasibility and repaired bounds. These numerical
checks are not proofs. The symbolic audit uses exact polynomial remainders,
but is not a replacement for Lean sector recognition.

## Reconstruction targets

Check especially: the common-floor remainder may have selected support;
its sum may be singular; no support inverse is assumed; the selected and
residual errors share the same C; the coupled Gram estimate holds over the
whole interval; and the lower family's chosen dimension exists for every pair.
The old effects have eigenvalues exactly at the threshold. Degenerate Gram
eigenvalues and sector basis phases must not change the completed POVM.

A decisive response is one of: a reconstruction with clearly stated
hypotheses; a specific failed step or counterexample; or a prior theorem and
an explicit derivation of this exact statement. Merely recognizing polar
decomposition, gentle measurement, or the diamond-norm SDP does not settle
whether the combined extremal equality was previously known.

## Local reproduction

From the repository root, with the pinned Lean toolchain installed:

```powershell
python experiments/test_lean_formalization.py --negative-controls
python -m pip install -r scripts/requirements-joint-symbolic.txt
python experiments/verify_joint_lower_symbolic.py
python -I experiments/verify_joint_lower_exact.py
```

The first command builds every imported theorem and runs the transitive axiom
gate. The second installs optional symbolic-audit dependencies into the active
Python environment; a virtual environment is recommended. The last two
commands separately check symbolic identities and finite rational instances.
The existing frozen PDF remains a historical paper release; the exact joint
proof and this packet are the current supplement.
