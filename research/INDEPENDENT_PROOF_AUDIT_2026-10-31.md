# Independent Proof Audit — 31 October 2026

Status: **main RC theorem survives reconstruction; packing-conditioned extension corrected and strengthened**

This audit was performed from the repository statements rather than from the previous conversational derivation.

## 1. Sharp Record-Margin theorem

Target:

[
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappa}}.
]

### Result

**PASS**, subject only to making two standard background lemmas explicit.

### Reconstruction

Let

[
Phi(ho)=sum_joperatorname{Tr}(P_jho)sigma_j
]

with orthogonal projectors (P_j).

For a state (ho_j) supported in (P_j),

[
Phi(ho_j)=sigma_j.
]

Set

[
a_j=operatorname{Tr}(P_jsigma_j).
]

Then

[
Phi(sigma_j)
=
a_jsigma_j+(1-a_j)omega_j
]

for a convex combination (omega_j) of the other records.

By the definition of the record margin,

[
|Phi(sigma_j)-sigma_j|_1
ge
2kappa(1-a_j).
]

The diamond norm dominates this ordinary state test, hence

[
1-a_j
le
rac{eta}{2kappa}.
]

Project (sigma_j) into (P_j) and normalize:

[
	au_j
=
rac{P_jsigma_jP_j}{a_j}.
]

The normalized post-selection / gentle-projection inequality gives

[
|sigma_j-	au_j|_1
le
2sqrt{1-a_j},
]

so

[
|sigma_j-	au_j|_1
le
sqrt{rac{2eta}{kappa}}.
]

Define

[
Pi(ho)
=
sum_joperatorname{Tr}(P_jho)	au_j.
]

Because every (	au_j) is supported in the (j)-sector,

[
Pi^2=Pi.
]

For the channel difference

[
Delta=Phi-Pi,
]

a bipartite state input produces

[
(Deltaotimes I)(ho)
=
sum_j(sigma_j-	au_j)otimes R_j,
]

where the conditional ancilla operators (R_j) are positive and their traces sum to (1). Therefore

[
|(Deltaotimes I)(ho)|_1
le
max_j|sigma_j-	au_j|_1.
]

For a Hermiticity-preserving map, the diamond norm can be optimized over density operators with an ancilla of input dimension. Thus the preceding state bound is sufficient.

In fact the sharp-projective case gives the useful identity

[
oxed{
|Phi-Pi|_diamond
=
max_j|sigma_j-	au_j|_1
}
]

because an input supported in sector (j) attains each record difference.

### Standard lemmas that should be cited explicitly

1. **Diamond norm state reduction for Hermiticity-preserving maps.**  
   Standard quantum-information result; e.g. Watrous, *The Theory of Quantum Information* (2018), or equivalent formulations in modern channel-distance references.

2. **Normalized post-selection trace-distance bound.**  
   Follows from Uhlmann/Fuchs–van de Graaf or the gentle measurement lemma:
   [
   |ho-Pho P/operatorname{Tr}(Pho)|_1
   le
   2sqrt{1-operatorname{Tr}(Pho)}.
   ]

No hidden dimension factor appears.

## 2. POVM spectral-gap theorem

Target:

[
|Phi-Pi|_diamond
le
sqrt{rac{2eta}{kappagamma}}.
]

### Result

**PASS** by the same reconstruction.

The only additional step is

[
E_j
le
P_j+(1-gamma_j)(I-P_j),
]

which converts high self-read probability into high weight in the exact eigenvalue-(1) sector.

The rest of the proof is the same post-selection argument.

## 3. Synthesis-operator packing invariant

The candidate

[
alpha=sigma_{min}(T)
]

survives the audit as a valid global conditioner for simultaneous subspace orthogonalization.

The strongest clean statement is now in:

- theory/packing_conditioned_rounding.md

The key facts are:

[
TT^*=sum_jP_j,
]

and because

[
E_jge(1-delta)P_j,
]

the POVM condition implies

[
TT^*
le
rac{1}{1-delta}I.
]

So the singular spectrum is automatically trapped between

[
alpha
le
sigma_k(T)
le
(1-delta)^{-1/2}.
]

The polar factor therefore gives mutually orthogonal sectors with explicit movement.

This part extends to higher rank with no conceptual change.

## 4. Correction to the claimed rank-1 theorem

The statement supplied on 31 October contained two overstatements.

### A. “Rank-1 projectors form a repeatable POVM for all (mle d)”

If the effects themselves are rank-1 orthogonal projectors and sum to the identity, then necessarily

[
m=d.
]

For (m<d), a repeatable POVM must include residual effects on the unused orthogonal complement.

The completion

[
F_j=R_j+CE_jC
]

with

[
C=I-sum_jR_j
]

fixes this cleanly.

### B. Linear spectral-threshold movement is too strong

The proposed rate

[
O!left(
delta+sqrt{1-alpha^2}
ight)
]

cannot hold when (delta) means only “the selected spectral sector has eigenvalues at least (1-delta).”

An explicit (d=4,m=3) POVM has

[
alpha=1
]

but forces order-(sqrtdelta) correction.

See:

- experiments/test_spectral_threshold_rate.py
- theory/packing_conditioned_rounding.md

Thus the correct generic effect-rounding rate must allow at least a square-root dependence on the spectral-threshold defect.

This does **not** refute a theorem under the much stronger hypothesis

[
|E_j-P_j|_inftyledelta,
]

because that assumption controls the entire residual effect, not only the near-unit spectral edge.

But that stronger hypothesis does not cover the full packing-feasible POVM regime.

## 5. Positive many-outcome theorem now available

A constructive non-optimal theorem does survive.

Given:

- near-unit spectral sectors (P_j),
- (alpha=sigma_{min}(T)>0),
- sufficiently good packing so the polar sectors remain close,
- record margin (kappa>0),
- original idempotence defect (eta),

the polar factor supplies orthogonal sectors (R_j), and

[
F_j=R_j+CE_jC
]

is a repeatability-admissible POVM.

The current explicit effect movement is

[
O!left(
sqrt{delta+eta}
ight),
qquad
eta=|T-Q|_infty.
]

A crude but rigorous channel perturbation estimate is

[
Delta
=
|Phi-widetildePhi|_diamond
le
mmax_j|E_j-F_j|_infty.
]

Then

[
|widetildePhi^2-widetildePhi|_diamond
le
eta+3Delta.
]

The rounded POVM has a quantitative repeatability gap, and the existing RC spectral-gap theorem yields

[
oxed{
|Phi-Pi|_diamond
le
Delta
+
sqrt{
rac{2(eta+3Delta)}
{kappagamma_F}
}.
}
]

This is already a positive theorem for the many-outcome packing-feasible regime under explicit conditioning.

The remaining (m)-dependence is the current weak point, not the existence of the construction.

## 6. Literature veto update

Two neighbouring bodies of prior work must now be treated as mandatory comparisons.

### Polar / Löwdin orthogonalization

The fact that the polar factor is a nearest isometry / nearest orthonormal frame in unitarily invariant norms is classical (Fan–Hoffman; Higham; Löwdin orthogonalization).

No novelty claim belongs to the polar step itself.

### Orthogonalization / projectivization of POVMs

Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), proves quantitative rounding of almost-orthogonal POVMs to PVMs in a state-dependent (L_2)-type metric, improving earlier finite-dimensional results.

This is close enough that it must be discussed explicitly before any RC moving-POVM novelty claim.

The current RC statement differs in hypotheses and target metric:

- near-unit spectral-sector packing,
- synthesis-operator conditioning,
- repeatability-admissible rather than necessarily projective completion,
- operator-norm effect movement,
- downstream diamond-norm control for a measure-and-prepare channel.

Whether that combination is genuinely new remains open.

## 7. Current verdict

### Main Record-Margin theorem

**Strong candidate.** Independent reconstruction survives.

### Spectral-gap extension

**Strong candidate.** Independent reconstruction survives.

### Synthesis-operator packing invariant

**Correct and useful**, but the polar orthogonalization itself is standard mathematics.

### “Entire packing-feasible regime solved with a linear bound”

**Too strong as stated.**

### Corrected many-outcome result

**Positive theorem obtained**, with:

- constructive polar sectors,
- explicit repeatable POVM completion,
- square-root spectral-threshold rate,
- currently non-optimal (m)-dependent diamond perturbation.

## 8. Next proof target

The highest-value remaining problem is now precise:

> Prove an outcome-count-independent bound for the measurement-channel move
> [
> |mathcal M_E-mathcal M_F|_diamond
> ]
> using the joint POVM structure, rather than the crude sum
> [
> sum_j|E_j-F_j|_infty.
> ]

If that succeeds, the many-outcome theorem becomes much closer to the dimension-independent form originally sought.
