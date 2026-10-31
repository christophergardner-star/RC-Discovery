# Open Problems

Updated: 31 October 2026 after the refreshed Cruxy merge and typed-space audit.

## Resolved or substantially narrowed

The following are no longer the main open problems:

- local diagnostics alone are insufficient: regular-simplex and constant-channel obstructions are known;
- the global packing variable is identified as the conditioning of the near-unit-sector synthesis operator;
- polar orthogonalisation works at arbitrary rank using standard machinery;
- the same-label completion
  \[
  F_j=Q_j+R E_jR
  \]
  is a genuine POVM with exact unit sectors;
- its repeatability spectral gap satisfies
  \[
  \gamma_F\ge\delta;
  \]
- with the correctly typed direct-sum labelled map \(J_{\mathcal K}\), the hybrid isometry
  \[
  V=J_{\mathcal K}U^*+WR
  \]
  implements the completion exactly;
- the internal reconstruction gives an outcome-count- and dimension-independent operational estimate;
- the extra-outcome shortcut is false and has been removed from the canonical route;
- the residual spectral radius is not an independent missing invariant for the explicit same-label completion.

## A. External correctness audit

The highest-priority gate is now external reconstruction of the correctly typed theorem by a specialist in quantum measurements/operator theory.

Specific points to verify:

1. the direct-sum type of
   \[
   J_{\mathcal K}:\bigoplus_j\mathcal S_j\to\bigoplus_j\mathcal H;
   \]
2. the identity
   \[
   J_{\mathcal K}^*WU=D|T|;
   \]
3. the orthogonality
   \[
   J_{\mathcal K}^*WR=0;
   \]
4. exact implementation
   \[
   V^*\Lambda_jV=Q_j+R E_jR;
   \]
5. all norm conventions in the Stinespring-to-diamond step;
6. threshold endpoint and zero-effect cases;
7. the transfer estimate
   \[
   \|\widetilde\Phi_F^2-\widetilde\Phi_F\|_\diamond
   \le
   \eta+3\nu.
   \]

The imported Cruxy notes use a second map \(J_q\) that embeds polar-rounded vectors. Its matrix-element calculation must not be conflated with the theorem's \(J_{\mathcal K}\).

## B. Prior-art and novelty review

A broad first search found no exact theorem matching the complete typed chain, but that does not establish novelty.

Required specialist comparisons:

- de la Salle and predecessor POVM orthogonalisation lemmas;
- Kotowski–Oszmaniec and other projective-simulation / dimension-deficient Naimark results;
- fusion-frame and Riesz-fusion-basis perturbation theory;
- Naimark/Stinespring perturbation and continuity theorems;
- repeatable-instrument theory;
- diamond-norm measurement discrimination.

Canonical no-overclaim policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`

The current label is:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

## C. Formal verification

The current Lean artefact checks only the scalar algebraic core.

High-value formalisation targets:

1. direct sums of finite-dimensional Hilbert spaces;
2. synthesis operator and polar isometry;
3. equality of total ranges;
4. the typed labelled inclusion \(J_{\mathcal K}\);
5. \(J_{\mathcal K}^*WR=0\);
6. \(V^*V=I\);
7. \(V^*\Lambda_jV=F_j\);
8. the spectral-gap compression bound;
9. the easy Stinespring-to-channel estimate;
10. eventual composition with Record-Margin Stability.

## D. Optimal constants and rates

The current conservative estimate is

\[
\nu
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right).
\]

Open questions:

- can the constant \(4\) be reduced analytically?
- is the packing dependence \(\sqrt{1-\alpha^2}\) optimal?
- the \(\sqrt\delta\) lower-bound family shows threshold dependence cannot generally be linear, but what is the sharp joint bound?
- can a matching converse be proved away from the singular simplex endpoint?

## E. Reproducible operational verification

Pure-state total-variation sampling is not a complete diamond-norm computation by itself.

Next computational targets:

- implement a reliable Watrous-style SDP for selected finite cases;
- include ancilla-assisted discrimination explicitly;
- compare exact SDP values with the Stinespring upper bound;
- stress-test degenerate/high-rank sectors and tiny nonzero sectors;
- package all random seeds and generated fixtures.

## F. Experimental estimation

Develop practical protocols to estimate or lower-bound:

- \(\alpha=\sigma_{\min}(T)\);
- the threshold \(\delta\);
- record margin \(\kappa\);
- idempotence defect \(\eta\);
- the resulting certificate without full process tomography.

## G. Application programmes

### Quantum readout

Obtain exact reconstructed POVM/instrument data and apply the certificate to repeated superconducting-qubit readout.

### Metastability

Derive RC parameters from a microscopic open-system model rather than assuming them.

### Redundancy

Extend sharp results from two pure records to many mixed and correlated records.

### Continual learning

Test anchor-conflict and horizon-rounding diagnostics on canonical TCL checkpoints and real benchmarks. This remains an application programme, not evidence for the quantum theorem.

## H. Publication gate

Before an arXiv or journal claim:

1. external theorem audit;
2. specialist prior-art review;
3. exact statement/notation freeze;
4. reproducible tests;
5. conservative novelty wording;
6. clear attribution of every standard ingredient;
7. ideally, formalisation of the hybrid core.

The refreshed Cruxy source snapshot is preserved under `imports/`, but only the canonical root files should be used to prepare a submission.
