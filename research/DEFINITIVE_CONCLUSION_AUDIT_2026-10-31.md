# Audit of DEFINITIVE_CONCLUSION.md — extra-outcome closure fails as stated

Date: 31 October 2026  
Status: **counterexample found; dimension-free Naimark ν theorem candidate survives, but the γ=1 closure does not**

## Summary

The proposed final step combines two different completions:

1. the **Naimark-close completion** from `theory/dimension_free_nu_via_naimark.md`, which preserves a small, outcome-independent measurement-channel distance (
u), but leaves a residual POVM on the complement and therefore does not automatically give (gamma_F=1);

2. the **residual-to-extra-outcome PVM**
   [
   F_j=Q_jquad(jle m),qquad
   F_{m+1}=I-sum_{j=1}^mQ_j,
   ]
   which indeed has projective effects and (gamma_F=1), but can be maximally far from the original measurement channel even when (alpha=1) and (delta=0).

The dimension-free (
u) estimate from (1) cannot simply be transferred to (2).

---

## Exact counterexample

Take (mathcal H=mathbb C^3) with basis (e_1,e_2,e_3), and the two-outcome POVM

[
E_1=operatorname{diag}(1,0,1/2),
qquad
E_2=operatorname{diag}(0,1,1/2).
]

Choose a spectral threshold (delta<1/2). The near-unit sectors are

[
P_1=|e_1anglelangle e_1|,
qquad
P_2=|e_2anglelangle e_2|.
]

They are already orthogonal, so

[
oxed{alpha=1.}
]

The polar step does nothing:

[
Q_1=P_1,qquad Q_2=P_2.
]

Now apply the proposed extra-outcome completion

[
F_1=Q_1,qquad
F_2=Q_2,qquad
F_3=|e_3anglelangle e_3|.
]

Embed the original measurement into three labels by adding (E_3=0).

On input (|e_3anglelangle e_3|), the original outcome distribution is

[
(1/2,1/2,0),
]

whereas the completed projective measurement gives

[
(0,0,1).
]

Their (ell_1) distance is

[
|1/2|+|1/2|+|{-1}|=2.
]

Therefore

[
oxed{
|mathcal M_E-mathcal M_F|_diamond=2,
}
]

the maximum possible channel distance.

But the proposed dimension-free formula based only on packing and spectral threshold would give zero at (alpha=1) and (delta=0).

Thus the claim

[

u=O!left(sqrt{1-alpha^2}+sqrtdeltaight)
]

does **not** hold for the residual-to-extra-outcome PVM completion.

---

## Why the Naimark theorem candidate is not contradicted

The Naimark-close construction deliberately extends the packed-sector isometry (J) by taking the polar isometry of

[
Z=(I-JJ^*)WR.
]

That complement is chosen to stay close to the original residual measurement behavior (WR).

It generally has support across the original outcome labels. Therefore its induced effects have the form

[
F_j=Q_j+	ext{residual contribution},
]

not simply (F_j=Q_j).

That is precisely why the measurement channel can remain close.

Forcing all of the residual subspace into a brand-new orthogonal label changes a unit-norm residual Stinespring vector into an orthogonal label sector. In the worst case this costs order one (and in the example above, the induced measurement channels are maximally separated).

So the two desirable properties

- small (
u), and
- (gamma_F=1) by dumping all residual mass into one extra projective outcome,

cannot be combined for free.

---

## Record-margin issue with an extra outcome

There is a second obstruction in the measure-and-prepare layer.

In the counterexample, suppose the original records are (sigma_1,sigma_2). On the residual state (e_3), the original channel outputs

[
rac12sigma_1+rac12sigma_2.
]

To make the extra-outcome channel agree there, one would choose

[
sigma_3=rac12sigma_1+rac12sigma_2.
]

But then the augmented record margin for label (3) is zero because (sigma_3) lies in the convex hull of the competing records.

Hence the existing Record-Margin theorem cannot be invoked with the original positive (kappa) unchanged.

Choosing (sigma_3) outside that convex hull can restore positive separation, but then the channel mismatch on the residual sector is no longer forced to be small.

---

## Same-label folding has the same problem

A same-label projective completion such as

[
F_1=Q_1+left(I-Q_1-Q_2ight),
qquad
F_2=Q_2
]

does have (gamma_F=1), but in the same example the residual input changes from distribution

[
(1/2,1/2)
]

to

[
(1,0),
]

so the measurement-channel move is order one.

Thus a folding argument requires extra information about the residual outcome statistics; packing of the near-unit sectors alone does not control it.

---

## Correct current theorem boundary

### Survives

The Naimark-completion theorem candidate:

[
oxed{

u
=
O!left(
sqrt{1-alpha^2}+sqrtdelta
ight)
}
]

with no (m) or (d) dependence, for the **Naimark-close residual completion**.

### Still open

A parameter-only lower bound on the repeatability spectral gap (gamma_F) of that same close completion.

Equivalently, one needs either:

1. a construction that simultaneously keeps (
u) small and controls the residual spectral gap;
2. an additional invariant describing the residual POVM on (Rmathcal H);
3. a version of Record-Margin rounding that does not require a separate (gamma_F).

---

## Revised highest-leverage question

The live bottleneck is now:

> What condition on the residual measurement geometry allows one to keep the dimension-free Naimark closeness while preventing almost-unit eigenvalues outside the packed sectors?

The extra-outcome shortcut does not solve this without paying order-one channel distance in general.

This is a useful negative result because it identifies the missing information very sharply: **near-unit-sector packing controls the protected sectors, but not the measurement statistics on their orthogonal complement.**
