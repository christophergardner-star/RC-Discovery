# External Review Packet

## Purpose

This packet asks reviewers to find one of three things:

1. a mathematical error;
2. a hidden hypothesis;
3. an existing theorem that subsumes the combined result.

Polite encouragement is less useful than a precise failure.

## Minimal reading order

1. [Short paper PDF](../paper/prescribed_repeatable_completion.pdf) or [readable manuscript](../paper/prescribed_repeatable_completion.md)
2. [Focused review brief](SHORT_PAPER_REVIEW_BRIEF.md)
3. [Frozen statement](../theory/THEOREM_V1_FREEZE.md)
4. [Theorem-level prior-art comparison](../literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
5. Numerical and Lean evidence only after the analytic proof

The short paper is self-contained. The longer research document is optional
background, not a prerequisite for reviewing the argument.

## Core verification questions

### A. Typing and geometry

- Is \(\mathcal K=\bigoplus_j\operatorname{ran}(P_j)\) defined consistently?
- Does \(T^*U=|T|\) hold with the stated domains?
- Is \(J_{\mathcal K}\) the direct-sum inclusion rather than the alternative polar-vector embedding?
- Does \(\operatorname{ran}U=\sum_j\operatorname{ran}P_j\) imply \(P_jR=0\)?
- Does the principal-angle proof give
  \[
  \|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}?
  \]

### B. Completion and gap

- Does
  \[
  F_j=Q_j+RE_jR
  \]
  define a POVM?
- Do the cross-sector actions vanish?
- Does threshold fullness imply
  \[
  RE_jR\le(1-\delta)R
  \]
  and therefore \(\gamma_F\ge\delta\)?

### C. Hybrid dilation

- Does \(J_{\mathcal K}^*WR=0\) hold exactly?
- Is
  \[
  V=J_{\mathcal K}U^*+WR
  \]
  an isometry?
- Is
  \[
  V^*\Lambda_jV=F_j
  \]
  exact?
- Are ancilla systems covered by the channel-distance argument?

### D. Constant-two bound

- Is the noncommuting positive-matrix lemma correct?
- Is the sufficient condition used only where proved?
- Does the case split yield the unconditional
  \[
  \nu_{\rm meas}\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}?
  \]
- Are all norm conventions consistent?

### E. Record certificate

- Is
  \[
  (1-2e)D_{\rm rec}\le\eta\le D_{\rm rec}
  \]
  correct?
- Does the convex-hull record margin imply the stated self-read estimate?
- Does projection into \(Q_j\) produce the claimed trace-distance bound?
- Is the constructed channel \(\Pi\) exactly idempotent?
- Does the final certificate avoid the earlier movement-over-gap defect?

### F. Novelty

- Is the combined theorem already implied by POVM orthogonalisation, fusion-frame perturbation, Naimark stability, or measurement simulation?
- Is there a differently phrased theorem for same-label deterministic completion?
- Are any priority claims too strong?

## Required reviewer output

A useful review should identify:

- exact equation or step;
- whether the problem is fatal, repairable, or expository;
- a counterexample if possible;
- the closest known theorem;
- any missing citation;
- whether the result remains meaningful after correction.

## Current author position

The result is described only as:

> internally reconstructed, computationally audited, partially formalised, potentially distinct, novelty unverified.
