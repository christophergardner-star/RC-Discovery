# Novelty and Prior-Art Ledger

Updated: 28 October 2026.

This is a veto ledger, not a bibliography assembled to make RC look novel.

## 1. Alexei Kitaev — almost-idempotent quantum channels

**Title:** Almost-idempotent quantum channels and approximate \(C^*\)-algebras  
**arXiv:** 2405.02434  
**First submitted:** 3 May 2024  
**URL:** https://arxiv.org/abs/2405.02434

Kitaev studies UCP maps with small completely bounded idempotence defect and constructs associated approximate \(C^*\)-algebra structure with universal dimension-independent approximation statements.

**Relation to RC:** essential prior art. From the material checked so far, it does not state the record-margin exact-rounding theorem for sharp measure-and-prepare channels.

---

## 2. 2026 negative exact-rounding result

**Title:** Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels  
**Author listed by Zenodo:** Chenxiao  
**Date:** 23 September 2026  
**DOI:** 10.5281/zenodo.22906336  
**URL:** https://zenodo.org/records/22906336

The preprint constructs explicit bistochastic entanglement-breaking maps on \(M_n\) whose cb-norm idempotence defects tend to zero while their distance from all UCP idempotents has a lower bound tending to one.

**Relation to RC:** this rules out dimension-independent exact rounding for general quantum channels, even inside a broad entanglement-breaking class. A positive theorem therefore needs genuinely stronger structure.

---

## 3. Quantum Markov State Models for metastable dynamics

**Title:** Quantum Markov State Models for Metastable Dynamics  
**Authors:** Hao-En Li, Lin Lin, Michael Ragone  
**arXiv:** 2609.40214  
**Submitted:** 30 September 2026  
**URL:** https://arxiv.org/abs/2609.40214

The authors obtain exact idempotent approximation for channels with small diamond-norm idempotence defect when the number of slow degrees of freedom is bounded independently of microscopic system size. Their abstract reports \(O(\eta^{1/3})\) on all inputs and \(O(\eta^{1/2})\) on metastable states, with constants depending only on slow dimension.

**Relation to RC:** different positive regime.

- QMSM assumption: bounded slow dimension.
- RC assumption: sharp projective readout plus record separation \(\kappa>0\).
- RC target: constants controlled by record geometry rather than state-space size.

---

## 4. Objective records versus decoherence

**Title:** Hamiltonian thresholds for objective records  
**Author:** Jie Gu  
**Phys. Rev. A 114, L020201 (2026)**  
**Published:** 13 August 2026  
**DOI:** 10.1103/fm9j-m9lh  
**URL:** https://journals.aps.org/pra/abstract/10.1103/fm9j-m9lh

This work explicitly separates decoherence from the creation of readable environmental witnesses. Objective records require sufficient record distinguishability, not merely suppression of coherence.

**Relation to RC:** supports treating record distinguishability as physically meaningful. The RC theorem adds a different statement: under its hypotheses, record separation controls stability of approximate repeatability.

---

## 5. State objectivity and information scrambling

**Title:** State objectivity and information scrambling in realistic qubit-bosonic systems  
**Authors:** Feng Tian, Wenting Lu, Jinzhu Jiang, Junxiao Wang, Haiqing Xie, Jian Zou  
**Phys. Rev. A 114, 042424 (2026)**  
**Published:** 13 October 2026  
**DOI:** 10.1103/ry8r-1ts9  
**URL:** https://journals.aps.org/pra/abstract/10.1103/ry8r-1ts9

The paper reports a dynamical association between genuine objective records and absence of scrambling in the studied models, while explicitly stopping short of a universal causal relation.

**Relation to RC:** potential future test bed for comparing \(\kappa\) with accessible-information and scrambling diagnostics.

# Current novelty judgement

The exact statement

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}
\]

for sharp measure-and-prepare channels, with \(\kappa\) defined as distance from each record to the convex hull of all competitors, has **not yet been located** in the literature search performed on 28 October 2026.

That is not proof of novelty.

## Before a publication claim

Required:

1. independent proof reconstruction,
2. specialist search in operator algebras, perturbation of CP maps, quantum instruments, repeatable measurements, conditional expectations, and stability of entanglement-breaking channels,
3. search for equivalent theorems expressed without RC vocabulary,
4. proof-assistant or second-researcher verification if practical,
5. precise comparison of diamond/cb norm conventions under Schrödinger-Heisenberg duality.

Until those steps are complete, status remains **provisionally novel**.
