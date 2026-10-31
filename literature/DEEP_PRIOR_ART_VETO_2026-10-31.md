# Deep Prior-Art Veto — Same-Label Dimension-Free Theorem

Date: 31 October 2026  
Status: **first deep veto passed provisionally — no exact prior theorem located; novelty not established**

## Target claim being vetoed

The theorem candidate under review is the combined statement:

- a finite POVM has, for every nonzero effect (E_j), a nonzero near-unit spectral sector (P_j) for eigenvalues at least (1-delta);
- the synthesis operator
  [
  T:igoplus_joperatorname{ran}(P_j)	omathcal H
  ]
  has lower singular value (alpha=sigma_{min}(T)>0);
- polar packing produces mutually orthogonal sectors (Q_j);
- the **same-label** completion
  [
  F_j=Q_j+R E_jR,qquad R=I-sum_jQ_j
  ]
  is repeatability-admissible with
  [
  gamma_Fgedelta;
  ]
- the hybrid dilation
  [
  V=JU^*+WR
  ]
  gives an outcome-count- and dimension-independent measurement-channel estimate
  [
  
u
  le
  4igl(sqrt{1-alpha^2}+sqrtdeltaigr);
  ]
- composition with Record-Margin Stability gives a dimension-free exact-idempotent certificate.

The literature search was aimed at finding this **combined implication**, not merely one of its standard ingredients.

---

## 1. de la Salle (2022): quantitative POVM orthogonalisation

Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), 549–560. DOI: 10.5802/crmath.326. arXiv:2103.14126.

### What it proves

For a POVM ((a_i)), a normal state / vector state, and an almost-orthogonality condition such as

[
arphi!left(sum_i a_i^2ight)>1-arepsilon,
]

there exists a PVM ((p_i)) close in a state-dependent (L_2)-type quantity. The theorem is dimension independent and improves earlier finite-dimensional orthogonalisation results of Kempe–Vidick and Ji–Natarajan–Vidick–Wright–Yuen.

### Overlap with RC

Very significant neighbouring prior art:

- POVM-to-projective rounding;
- dimension-independent constants;
- outcome-count-independent quantitative stability.

### Difference from current theorem candidate

The located theorem does **not** use:

- near-unit spectral sectors;
- the lower singular value of their synthesis operator;
- the specific same-label completion (F_j=Q_j+RE_jR);
- operator-norm / diamond-norm control derived from ((alpha,delta));
- a downstream exact-idempotent record-process certificate.

Its metric is state-dependent; the PVM produced by the theorem is not presented as the specific hybrid-dilation completion used here.

### Veto verdict

**Strong prior art, but no exact theorem match located.**  
Any paper must cite and compare directly.

---

## 2. Kempe–Vidick and JNVWY orthogonalisation line

The finite-dimensional ancestors cited by de la Salle arise in nonlocal-games / MIP* work and contain projectivisation or orthogonalisation lemmas for almost-projective POVMs.

### Overlap

- almost-projective POVM (	o) projective measurement;
- quantitative approximation;
- independence from outcome count appears in suitable state-dependent norms.

### Difference

The searched formulations use state/tracial (L_2)-type errors or game-dependent consistency errors, not the synthesis-conditioned spectral-sector hypothesis or the same-label diamond certificate.

### Veto verdict

**Neighbouring machinery, no exact match located.**

---

## 3. Kretschmann–Schlingemann–Werner (2008): Stinespring continuity

Dennis Kretschmann, Dirk Schlingemann, Reinhard F. Werner:

- *The Information-Disturbance Tradeoff and the Continuity of Stinespring's Representation*, IEEE Trans. Inf. Theory 54 (2008), 1708–1717. DOI: 10.1109/TIT.2008.917696.
- *A Continuity Theorem for Stinespring's Dilation*, J. Funct. Anal. 255 (2008), 1889–1904. DOI: 10.1016/j.jfa.2008.07.023.

### What it proves

Dimension-independent continuity relations between channel cb/diamond distance and operator-norm distance between appropriate Stinespring representations.

In particular, the easy direction used by RC,

[
|operatorname{Ad}_W-operatorname{Ad}_V|_diamond
le
2|W-V|_infty,
]

is standard.

### Veto verdict

**The Stinespring-to-diamond step is known and not novel.**

The potentially distinct content is the explicit synthesis-conditioned construction of the particular same-label isometry

[
V=JU^*+WR
]

and its parameter bound.

---

## 4. Kotowski–Oszmaniec (2026): projective simulation and dimension-deficient Naimark

Michał Kotowski and Michał Oszmaniec, *Pretty Good Simulation of All Quantum Measurements by Projective Measurements*, IEEE Transactions on Information Theory 72(5) (2026), 3156–3174. DOI: 10.1109/TIT.2026.3678498. Preprint arXiv:2501.09339.

### What it proves

Among other results:

- dimension-independent simulation statements for noisy POVMs;
- randomized implementation by projective measurements;
- a “dimension-deficient Naimark theorem” for a class of nearly projective / nearly rank-one POVMs.

### Why this is especially important

This is much closer to the current work than was present in the original RC ledger. It explicitly combines “nearly projective POVM” and Naimark-style constructions with dimension-insensitive conclusions.

### Difference from current theorem candidate

The located dimension-deficient Naimark theorem concerns projective **simulability**, randomisation/noise, and a particular rank-one / low-outcome structure. The RC theorem candidate instead seeks a deterministic **same-label** repeatability-admissible POVM on the original space, controlled by near-unit subspace packing, and then a diamond certificate for the associated record channel.

No statement matching

[
F_j=Q_j+RE_jR,qquad

ule C(sqrt{1-alpha^2}+sqrtdelta)
]

was located in that paper.

### Veto verdict

**Major neighbouring 2026 prior art; no exact match located. Mandatory citation.**

---

## 5. Fusion-frame / Riesz-fusion-basis literature

Fusion-frame theory uses the same synthesis operator

[
T:(x_j)mapstosum_jx_j
]

for families of subspaces. The literature characterises fusion Riesz bases through invertibility of this synthesis operator and shows equivalence with orthonormal fusion bases.

Representative source:

M. S. Asgari, *On the Riesz fusion bases in Hilbert spaces*, Journal of the Egyptian Mathematical Society 21(2) (2013), 79–86. DOI: 10.1016/j.joems.2012.11.003.

### Overlap

- synthesis-operator conditioning of subspace families;
- orthogonalisation / equivalence to orthonormal families;
- stability under perturbations.

### Veto verdict

**The packing geometry is firmly connected to standard frame/fusion-frame theory.**

No novelty claim should attach to using a synthesis operator, its lower singular value, or polar orthogonalisation by themselves.

The remaining candidate contribution is the quantum-measurement/channel combination.

---

## 6. Repeatability and norm-1 POVMs

Standard measurement theory establishes that a finite discrete POVM admits a repeatable instrument iff every nonzero effect has eigenvalue 1.

Relevant sources include:

- Busch, Grabowski, Lahti, *Repeatable measurements in quantum theory: Their role and feasibility*, Foundations of Physics 25 (1995), 1239–1266. DOI: 10.1007/BF02055331.
- modern measurement-theory summaries describing the same norm-1 criterion.

### Veto verdict

**Known.**

The RC completion uses this criterion; it does not originate it.

---

## 7. Kitaev (2024) and Chenxiao (2026): almost-idempotent channels

Alexei Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*, arXiv:2405.02434.

Kitaev gives dimension-independent approximate algebra/factorisation structure for almost-idempotent UCP maps.

Chenxiao, *Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels*, Zenodo preprint, 23 September 2026, DOI: 10.5281/zenodo.22906336.

Chenxiao constructs regular-simplex entanglement-breaking maps with idempotence defect tending to zero while distance from exact UCP idempotents remains bounded below.

### Veto verdict

These results set the general boundary:

- unrestricted dimension-free exact rounding is false;
- extra record/packing structure is genuinely necessary if an exact-rounding theorem is to hold.

The current RC theorem is a structured positive result, not a solution of the unrestricted problem.

---

## 8. Almost-sharp / norm-1 effect literature

There is older literature on “almost sharp” effects, norm-1 POVMs, and sharpness measures. This literature supplies terminology and structural context but the searches did not locate the current synthesis-conditioned same-label channel theorem.

### Veto verdict

**Terminology/prior structure only; no exact match found in this search.**

---

# Search conclusion

## What is definitely not new

- polar / Löwdin orthogonalisation;
- synthesis operators and lower frame/Riesz bounds;
- Naimark dilation;
- Stinespring continuity;
- repeatability iff nonzero effects possess eigenvalue 1;
- general POVM orthogonalisation/projectivisation;
- general dimension-independent statements about noisy/projectively simulable POVMs;
- the regular-simplex obstruction mechanism in almost-idempotent channels.

## What has not been located as a prior theorem

No source found in this veto states the combined theorem in the present parameterisation:

> near-unit spectral sectors + synthesis lower bound (alpha)  
> (Rightarrow) explicit same-label completion (F_j=Q_j+RE_jR)  
> (Rightarrow) (gamma_Fgedelta) and an (m,d)-independent diamond bound  
> (Rightarrow) an exact-idempotent record-channel certificate using ((eta,kappa)).

This is a **search result, not proof of novelty**.

## Current novelty label

[
oxed{	ext{Potentially distinct combined theorem; first deep literature veto passed provisionally.}}
]

Before a novelty claim is made publicly, the result should still be checked by a domain expert familiar with:

1. POVM orthogonalisation/projectivisation,
2. quantum-measurement simulation,
3. fusion-frame perturbation theory,
4. Stinespring/Naimark stability,
5. repeatable instruments.

## Recommended paper positioning

Do **not** sell the theorem as “a new Naimark theorem” or “a new POVM orthogonalisation theorem.”

The defensible positioning, if external review agrees, is:

> a synthesis-conditioned stability theorem for a record-structured class of approximate measurements, giving an explicit same-label repeatability-admissible completion and a dimension/outcome-independent operational channel certificate.

That wording separates the candidate contribution from the known ingredients.
