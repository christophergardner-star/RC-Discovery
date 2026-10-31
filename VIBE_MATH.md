# VIBE MATH

**VIBE MATH** is the human-directed, AI-assisted research workflow used in RC-Discovery.

Christopher Gardner directs the research questions, selects the canonical claims, demands counterexamples, interprets evidence, controls publication decisions, and assumes responsibility for the programme. AI systems are used as research instruments for derivation support, coding, numerical experiments, adversarial auditing, literature triage, technical editing, and formalisation assistance.

> **Vibe to generate. Audit to believe.**

## Method

1. **Vibe** — explore a nontrivial idea freely.
2. **Type** — define the spaces, maps, norms, hypotheses, and quantifiers precisely.
3. **Translate** — rewrite the idea in standard mathematical language.
4. **Attack** — search for counterexamples and hidden assumptions.
5. **Test** — run deterministic, adversarial, random, symbolic, and SDP checks.
6. **Prove** — reconstruct the surviving statement from definitions.
7. **Audit** — independently rederive the proof and track every constant.
8. **Formalise** — machine-check stable components where practical.
9. **Veto novelty** — compare against prior art before claiming discovery.
10. **Publish only what survives** — keep theorem, evidence, formalisation, and novelty status separate.

VIBE MATH is deliberately not “prompt and publish.” AI agreement is not evidence of correctness.

## Current theorem candidate

For a finite POVM with full near-unit spectral sectors, synthesis conditioner

\[
\alpha=\sigma_{\min}(T)>0,
\]

polar-rounded sectors \(Q_j\), and residual projector

\[
R=I-\sum_jQ_j,
\]

the canonical same-label completion is

\[
F_j=Q_j+R E_jR.
\]

The current internally reconstructed operational bound is

\[
\boxed{
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
}
\]

The repeatability gap satisfies

\[
\gamma_F\ge\delta.
\]

A direct record-accessibility argument then constructs an exactly idempotent process with a nonvacuous parameter certificate. The result remains externally unverified and novelty-unverified.

## Human authorship and AI-provider claim boundary

Research direction and human authorship: **Christopher Gardner**.

OpenAI and other AI providers are tool providers, not designated authors, co-authors, inventors, assignees, sponsors, institutions, owners, endorsers, or claimants to this work merely because their systems assisted it.

No acknowledgement of AI assistance transfers authorship, inventorship, ownership, priority, publication control, royalties, or research credit to an AI system or provider.

The canonical detailed notice is:

- [`AI_RIGHTS_AND_ATTRIBUTION.md`](AI_RIGHTS_AND_ATTRIBUTION.md)

That notice records the project's express non-claim position while recognising applicable law, governing service terms, provider rights in their own services, and the need for qualified legal advice where intellectual-property questions matter.

## Scientific status

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

The mathematics is not considered established because an AI produced, repeated, or endorsed it. Claims advance only after surviving the repository's audit pipeline.
