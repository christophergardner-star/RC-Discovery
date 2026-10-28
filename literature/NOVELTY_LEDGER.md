# Novelty and Prior-Art Ledger

Updated: 28 October 2026.

This is a veto ledger, not a bibliography assembled to make RC look novel.

## 1. Alexei Kitaev — almost-idempotent quantum channels

**Title:** Almost-idempotent quantum channels and approximate \(C^*\)-algebras  
**arXiv:** 2405.02434  
**First submitted:** 3 May 2024  
**URL:** https://arxiv.org/abs/2405.02434

Kitaev studies UCP maps with small completely bounded idempotence defect and associated approximate \(C^*\)-algebra structure.

**Relation to RC:** essential prior art. The exact RC record-margin statements have not been located there.

---

## 2. 2026 negative exact-rounding result

**Title:** Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels  
**Author listed by Zenodo:** Chenxiao  
**Date:** 23 September 2026  
**DOI:** 10.5281/zenodo.22906336  
**URL:** https://zenodo.org/records/22906336

The preprint constructs explicit bistochastic entanglement-breaking maps whose cb-norm idempotence defects tend to zero while their distance from all UCP idempotents remains bounded below.

**Relation to RC:** proves that general dimension-independent exact rounding is false, even in a broad measure-and-prepare-like region. Any positive result must use stronger structure.

---

## 3. Quantum Markov State Models

**Title:** Quantum Markov State Models for Metastable Dynamics  
**Authors:** Hao-En Li, Lin Lin, Michael Ragone  
**arXiv:** 2609.40214  
**Submitted:** 30 September 2026  
**URL:** https://arxiv.org/abs/2609.40214

The paper constructs exact idempotent approximations for almost-idempotent metastable channels under bounded slow rank.

The paper reports:

- global diamond/cb approximation \(O_r(\eta^{1/3})\),
- metastable-state approximation \(O_r(\sqrt{\eta})\),
- constants independent of ambient dimension but dependent on slow rank \(r\),
- no general dimension-independent modulus without bounded slow rank.

**Relation to RC:** the RC metastability transfer theorem is complementary, not a replacement. It removes phase-count dependence only for channels close to a strongly classical record structure.

---

## 4. Repeatable POVMs

**Reference:** Paul Busch, Marian Grabowski, Pekka J. Lahti,  
*Repeatable measurements in quantum theory: Their role and feasibility*,  
Foundations of Physics 25, 1239–1266 (1995).  
DOI: 10.1007/BF02055331.

Standard repeatability theory establishes that a discrete POVM admits a repeatable implementation only when each nonzero effect has eigenvalue \(1\), with converse constructions available.

**Relation to RC:** this supplies the exact structural boundary used by the new POVM spectral-gap theorem. RC adds a quantitative stability estimate around that repeatable sector.

No source located so far states the bound

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{
\frac{2\eta}{\kappa\gamma}
}.
\]

---

## 5. Quantum Darwinism and Chernoff redundancy

**Reference:** Michael Zwolak, C. Jess Riedel, Wojciech H. Zurek,  
*Amplification, Redundancy, and Quantum Chernoff Information*,  
Phys. Rev. Lett. 112, 140406 (2014).  
DOI: 10.1103/PhysRevLett.112.140406.

Quantum Chernoff information controls the asymptotic distinguishability and redundancy of environmental records.

**Relation to RC:** the exponential distinguishability gain is known. The RC contribution is to feed record distinguishability into a quantitative exact-rounding certificate.

The identity

\[
\kappa_R=\sqrt{1-s^{2R}}
\]

for two pure product records is standard state-discrimination mathematics, not claimed as new.

---

## 6. Classical metastability in open quantum systems

**Reference:** Katarzyna Macieszczak, Dominic C. Rose, Igor Lesanovsky, Juan P. Garrahan,  
*Theory of classical metastability in open quantum systems*,  
Phys. Rev. Research 3, 033047 (2021).  
DOI: 10.1103/PhysRevResearch.3.033047.

This work shows that approximately simplex-like metastable manifolds yield approximately disjoint phases and effective classical stochastic dynamics.

**Relation to RC:** highly relevant neighbouring work. The RC transfer theorem starts from a different hypothesis—diamond-norm proximity to a record channel—and produces an exact idempotent with an explicit record-geometry bound.

A careful theorem-by-theorem comparison is still required before any novelty claim in metastability.

---

## 7. Objective records versus decoherence

**Title:** Hamiltonian thresholds for objective records  
**Author:** Jie Gu  
**Phys. Rev. A 114, L020201 (2026)**  
**Published:** 13 August 2026  
**DOI:** 10.1103/fm9j-m9lh  
**URL:** https://journals.aps.org/pra/abstract/10.1103/fm9j-m9lh

This work separates decoherence from readable environmental witnesses.

**Relation to RC:** supports treating record distinguishability as a physically meaningful resource.

---

## 8. State objectivity and information scrambling

**Title:** State objectivity and information scrambling in realistic qubit-bosonic systems  
**Authors:** Feng Tian, Wenting Lu, Jinzhu Jiang, Junxiao Wang, Haiqing Xie, Jian Zou  
**Phys. Rev. A 114, 042424 (2026)**  
**Published:** 13 October 2026  
**DOI:** 10.1103/ry8r-1ts9  
**URL:** https://journals.aps.org/pra/abstract/10.1103/ry8r-1ts9

Potential future test bed for comparing record margin with scrambling and accessible-information diagnostics.

# Current novelty judgement

Two exact statements now require serious external novelty checking:

### Sharp record-margin theorem

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
\]

### Repeatability-admissible POVM extension

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{
\frac{2\eta}{\kappa\gamma}
}.
\]

Both have short internal proofs and explicit equality families.

Neither exact statement has been located in the searches performed on 28 October 2026.

That is not proof of novelty.

The redundancy and metastability results in this repository are currently treated primarily as corollaries/applications of those theorem candidates, not as independent discovery claims.

## Before publication

Required:

1. independent proof reconstruction,
2. specialist search in operator algebras, quantum instruments, POVM repeatability, perturbation of CP maps, exact/approximate conditional expectations, and entanglement-breaking channel stability,
3. explicit comparison against classical metastability theorems,
4. proof-assistant or second-researcher verification,
5. precise norm-convention audit between Schrödinger and Heisenberg pictures.

Until then, status remains **provisionally novel**.
