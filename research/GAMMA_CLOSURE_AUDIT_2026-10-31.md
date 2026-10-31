# Independent Audit of the Proposed (gamma_F=1) Closure

Status: **extra-outcome closure refuted in general; complete-sector case closes cleanly**  
Date: 31 October 2026

## Executive result

The proposed idea

> route all residual mass to an extra outcome, so the moved POVM is projective and (gamma_F=1)

is algebraically correct as a POVM construction, but **not compatible in general with the previously proved dimension-free Naimark closeness bound**.

The obstruction is simple: the original measurement may carry substantial, genuinely distributed outcome probability on the residual subspace. Sending that residual subspace to one new reject label changes the measurement channel by order one, even when

[
alpha=1,qquad delta=0.
]

So the extra-outcome route does not close the general theorem.

However, it does reveal a clean positive special case:

> if the packed near-unit sectors already span the whole Hilbert space, then there is no residual subspace, the Naimark construction directly yields a PVM with (gamma_F=1), and the full dimension-free certificate closes.

---

## 1. Counterexample to residual-to-extra-outcome closeness

Let

[
mathcal H=mathbb C^3
]

with basis (e_0,e_1,e_2). Define the two-outcome POVM

[
E_1
=
|e_0anglelangle e_0|
+
rac12|e_2anglelangle e_2|,
]

[
E_2
=
|e_1anglelangle e_1|
+
rac12|e_2anglelangle e_2|.
]

Then

[
E_1+E_2=I.
]

The exact unit-eigenvalue sectors are

[
P_1=|e_0anglelangle e_0|,
qquad
P_2=|e_1anglelangle e_1|.
]

They are already orthogonal, so

[
alpha=sigma_{min}(T)=1,
qquad
delta=0.
]

The residual projector is

[
R=|e_2anglelangle e_2|.
]

Now route the residual to a new reject outcome:

[
F_1=P_1,qquad
F_2=P_2,qquad
F_3=R.
]

This is a PVM and therefore has

[
gamma_F=1.
]

But on the residual input state

[
ho=|e_2anglelangle e_2|,
]

the original measurement distribution is

[
left(rac12,rac12,0ight),
]

while the new distribution is

[
(0,0,1).
]

Their (ell_1) distance is

[
2.
]

Hence the classical-output measurement channels satisfy

[
oxed{
|mathcal M_E^+-mathcal M_F|_diamond=2,
}
]

where (E^+) denotes the original POVM padded with a zero third outcome.

Thus no bound of the form

[
C f(alpha,delta),
qquad
f(1,0)=0,
]

can hold for this residual-to-extra-outcome construction.

The same problem appears if the residual outcome is folded into one existing label. For example,

[
G_1=P_1+R,qquad G_2=P_2
]

is a same-label PVM, but on (|e_2angle) its distribution is ((1,0)), which remains order-one far from ((1/2,1/2)).

---

## 2. Why this does not refute the Naimark (
u) theorem

The dimension-free Naimark theorem candidate does **not** route the entire residual subspace to a fresh label.

Instead, it extends the labelled packed-sector isometry by taking a polar correction of the original residual dilation inside the orthogonal complement of the packed labelled sectors.

That extension preserves the original residual measurement behaviour up to the dimension-free Stinespring perturbation.

Consequently:

- the Naimark (
u) theorem candidate survives this counterexample;
- the resulting POVM is repeatability-admissible because each label contains an exact eigenvalue-(1) sector;
- but its residual blocks need not be projections;
- therefore its repeatability spectral gap need not equal (1).

---

## 3. (gamma_F) cannot be bounded from ((alpha,delta,eta,kappa)) alone

The obstruction can be sharpened.

For (0<arepsilon<1/2), define

[
E_1
=
|e_0anglelangle e_0|
+
(1-arepsilon)|e_2anglelangle e_2|,
]

[
E_2
=
|e_1anglelangle e_1|
+
arepsilon|e_2anglelangle e_2|.
]

Again,

[
alpha=1,qquad delta=0.
]

Choose record states

[
sigma_1=|e_0anglelangle e_0|,
qquad
sigma_2=|e_1anglelangle e_1|.
]

Then the associated measure-and-prepare channel is exactly idempotent:

[
eta=0,
]

and the record margin is maximal:

[
kappa=1.
]

Yet the repeatability spectral gap of the original repeatability-admissible POVM is

[
gamma
=
min{arepsilon,1-arepsilon}
=
arepsilon
	o0.
]

Therefore

[
oxed{
gamma_F
	ext{ cannot be lower-bounded by any positive function of }
(alpha,delta,eta,kappa)
	ext{ alone.}
}
]

This is not just a proof gap; it is a genuine structural obstruction.

---

## 4. Clean positive case: complete packed sectors

There is an important regime in which the full programme **does** close.

Assume

[
sum_j operatorname{rank}(P_j)=d.
]

Since (alpha>0), the synthesis operator

[
T:igoplus_jmathcal S_j	omathcal H
]

is then a square injective map, hence bijective. Its polar factor

[
U:mathcal K	omathcal H
]

is unitary.

Therefore the orthogonalised sectors

[
Q_j=UR_jU^*
]

satisfy

[
sum_jQ_j=I.
]

Thus

[
{Q_j}
]

is already a PVM, with

[
oxed{gamma_F=1.}
]

No residual extension is required.

The same Naimark overlap estimate gives an outcome- and dimension-independent measurement-channel perturbation

[

u
=
O!left(
sqrt{1-alpha^2}+sqrt{delta}
ight).
]

The moved channel therefore satisfies

[
|widetildePhi^2-widetildePhi|_diamond
le
eta+3
u.
]

Applying the sharp projective Record-Margin theorem yields

[
oxed{
|Phi-Pi|_diamond
le

u
+
sqrt{
rac{2(eta+3
u)}
{kappa}
}.
}
]

This is fully dimension- and outcome-count independent.

So the complete-sector regime gives a strong theorem candidate:

> **If the well-packed near-unit sectors span the whole Hilbert space, approximate repeatability plus record separation implies proximity to an exact idempotent projective record process with a dimension-free certificate.**

---

## 5. What remains in the incomplete-sector regime

When

[
sum_joperatorname{rank}(P_j)<d,
]

the residual subspace can carry arbitrary non-projective measurement structure while leaving

[
alpha,delta,eta,kappa
]

excellent.

Therefore a fully projective or (gamma=1) conclusion needs one more residual-control quantity.

Possible choices include:

1. a residual spectral-gap parameter;
2. a residual determinism / ambiguity parameter,
   [
   chi
   =
   sup_{ho:operatorname{supp}hosubseteq R}
   left(
   1-max_joperatorname{Tr}(E_jho)
   ight);
   ]
3. direct control of the residual measurement channel's distance to a deterministic coarse-graining;
4. retaining the existing (gamma_F) as an explicit parameter.

The Naimark theorem still supplies the dimension-free movement (
u). The unresolved part is now strictly residual geometry.

---

## 6. Revised theorem boundary

The current programme naturally splits into two regimes.

### Complete packed sectors

[
sum_joperatorname{rank}(P_j)=d.
]

Here:

- synthesis packing controls the polar move;
- Naimark gives dimension-free (
u);
- the moved measurement is a PVM;
- (gamma_F=1);
- the RC Record-Margin theorem closes the end-to-end certificate.

This is the strongest current publishable theorem candidate.

### Incomplete packed sectors

[
sum_joperatorname{rank}(P_j)<d.
]

Here:

- synthesis packing still controls the exact repeatable sectors;
- Naimark still gives dimension-free measurement-channel movement;
- but the residual subspace can support arbitrarily small repeatability gap;
- an additional residual invariant is necessary for a projective / gap-free final theorem.

---

## 7. Verdict

The proposed extra-outcome shortcut is **not valid as a general closure step**.

The more important result is actually sharper:

1. **the complete-sector case closes fully and dimension-independently**;
2. **the incomplete-sector case provably needs additional residual information**.

That is a useful classification theorem rather than a failed proof attempt.
