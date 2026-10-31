# VIBE MATH — RC-Discovery

**VIBE MATH** is the working name for this AI-assisted mathematical discovery programme: Christopher Gardner drives the questions, judgement, counterexample hunting and research direction while AI is used interactively to derive, attack, test, formalise and rewrite the mathematics.

This repository contains the **Resolvance Calculus (RC)** programme and its packing-conditioned quantum-measurement results.

The repository is deliberately conservative. Claims are labelled as known, derived, internally proved, open, refuted, or novelty-unverified.

## What VIBE MATH means

VIBE MATH is not a claim that informal prompting replaces proof. It names the workflow used here: rapid human–AI mathematical exploration followed by adversarial testing, numerical stress tests, proof reconstruction, prior-art checks and formal verification where practical.

The rule is simple: **vibe to generate; audit to believe.**

## Current strongest result

The moving-POVM programme now has an internally closed **same-label, dimension-free theorem candidate** for a record-structured class.

Let ({E_j}_{j=1}^m) be a finite POVM. Fix (0<delta<1/2), and for every nonzero outcome effect let (P_j
eq0) be the full spectral projection onto eigenvalues at least (1-delta).

Define the synthesis operator

[
T:igoplus_joperatorname{ran}(P_j)	omathcal H,
qquad
T(x_j)=sum_jx_j,
]

and the global packing conditioner

[
alpha=sigma_{min}(T)>0.
]

Let (T=UH) be the polar decomposition, (Q_j) the mutually orthogonal polar-rounded sectors, and

[
R=I-sum_jQ_j.
]

Define the same-label completed POVM

[
oxed{
F_j=Q_j+R E_jR.
}
]

Then:

- ({F_j}) is a POVM;
- every nonzero (F_j) has an exact eigenvalue-1 repeatable sector (Q_j);
- the repeatability spectral gap satisfies

[
oxed{gamma_Fgedelta;}
]

- the measurement-channel move is outcome-count and dimension independent:

[
oxed{

u
=
|mathcal M_E-mathcal M_F|_diamond
le
2arepsilon
le
4left(sqrt{1-alpha^2}+sqrtdeltaight).
}
]

The proof uses the exact hybrid Naimark/Stinespring isometry

[
oxed{
V=JU^*+WR,
}
]

where (W) is the canonical measurement isometry and (J) is the labelled embedding of the packed sectors.

An independent reconstruction of this hybrid-isometry derivation has passed, with the explicit hypothesis that every nonzero outcome has a nonzero near-unit sector.

## Composite exact-idempotent certificate

Let the original measure-and-prepare channel have record margin (kappa>0) and idempotence defect

[
eta=|Phi_E^2-Phi_E|_diamond.
]

Using the same records after the POVM move, the moved channel has defect at most

[
eta+3
u.
]

Applying the RC spectral-gap Record-Margin theorem gives an exactly idempotent channel (Pi) satisfying

[
oxed{
|Phi_E-Pi|_diamond
le

u+
sqrt{
rac{2(eta+3
u)}
{kappadelta}
}.
}
]

There is no explicit dependence on:

- the number of outcomes (m),
- Hilbert-space dimension (d),
- total packed-sector rank.

This is currently the strongest internally supported RC result.

## Earlier core results

### Sharp Record-Margin Stability

For sharp record sectors,

[
oxed{
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappa}}.
}
]

Independent reconstruction: **passed**.

### POVM spectral-gap extension

For repeatability-admissible POVMs,

[
oxed{
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappagamma}}.
}
]

Independent reconstruction: **passed**.

## Important negative results

The unrestricted moving-POVM problem is false.

A regular-simplex family shows that local properties such as:

- small idempotence defect,
- large record margin,
- near-unit effects,
- near-reachable records,

do not imply proximity to a repeatable measurement. A global packing condition is necessary.

Other refutations established during the programme:

- (m>d) blocks same-label exact repeatability;
- a generic linear (O(delta)) spectral-threshold movement bound is false;
- routing all residual mass to a new projective outcome can produce diamond distance (2);
- residual spectral radius is not an independent missing invariant for the same-label completion.

## Packing geometry

The synthesis conditioner

[
alpha=sigma_{min}(T)
]

detects the global packing obstruction.

For the polar-rounded sectors,

[
oxed{
|P_j-Q_j|_infty
le
sqrt{1-alpha^2}.
}
]

This holds at arbitrary rank and has passed large numerical stress tests.

The polar / Löwdin orthogonalisation step itself is classical and is **not** claimed as novel.

## Lean formalisation

The current Lean 4 + Mathlib development machine-checks the real-arithmetic core with zero `sorry`:

- `projector_const_one`
- `polar_residual_le`
- `near_orthonormal_overlap`
- `rank1_core_package`

Not yet formalised:

- the Hilbert-space polar decomposition step,
- the hybrid isometry (V=JU^*+WR),
- the diamond-norm transfer,
- the full composite theorem.

## Prior-art boundary

Known neighbouring ingredients include:

- classical polar / Löwdin / Fan-Hoffman nearest-isometry results;
- quantitative POVM orthogonalisation, including de la Salle (2022);
- continuity of Stinespring dilations and channel distance, including Kretschmann-Schlingemann-Werner;
- Kitaev's almost-idempotent channel / approximate (C^*)-algebra programme;
- the 2026 negative result showing general almost-idempotent channels need not be close to idempotents.

No novelty claim belongs to those ingredients individually.

The potentially distinct contribution is the combined chain

[
oxed{
	ext{synthesis packing}
	o
	ext{explicit same-label hybrid dilation}
	o
	ext{dimension-free measurement move}
	o
	ext{spectral gap}
	o
	ext{exact idempotent record process}.
}
]

An initial deep literature veto has now been completed. No exact prior theorem matching the combined same-label synthesis-conditioned certificate was located, but novelty remains unverified pending expert review.

## Current next steps

The main internal proof gap is no longer open. Current priorities are:

1. external/domain-expert novelty review of the combined theorem after the first deep literature veto;
2. sharpen the constant (4);
3. test joint optimality of the (sqrt{1-alpha^2}) and (sqrtdelta) rates;
4. formalise the operator/channel proof in Lean;
5. prepare a concise external-review/arXiv note only after the literature veto;
6. continue secondary RC applications: redundancy, metastability, and the TCL bridge.

## Key files

- `theory/record_margin_stability.md`
- `theory/povm_spectral_gap_stability.md`
- `theory/moving_povm_boundary.md`
- `theory/packing_conditioned_rounding.md`
- `theory/same_label_dimension_free_theorem.md`
- `research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md`
- `research/INDEPENDENT_HYBRID_ISOMETRY_AUDIT_2026-10-31.md`
- `research/OPEN_PROBLEMS.md`
- `experiments/test_same_label_hybrid_dilation.py`
- `lean/RCProof/Core.lean`
- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`
- `STATUS.md`

## Research discipline

Before any breakthrough or novelty claim:

1. proof audit,
2. adversarial counterexample search,
3. reproducibility,
4. literature veto,
5. independent reconstruction or formal verification.

Author: **Christopher Gardner**
