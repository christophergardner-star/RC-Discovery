# Open Problems

Updated after the three-track push on 28 October 2026.

## What was resolved in this session

The following are no longer open in their original form:

1. **Can projective readout be relaxed?**  
   Yes, for finite POVMs with exact eigenvalue-\(1\) repeatable sectors. The stability cost is controlled by a spectral gap \(\gamma\).

2. **What is the exact binary pure-record redundancy rate?**  
   \[
   \kappa_R=\sqrt{1-s^{2R}}.
   \]

3. **Can nominal redundancy fail to improve margin?**  
   Yes. Perfectly correlated record noise gives \(\kappa_R\) constant in \(R\).

4. **Can bounded phase count be avoided in a metastable subclass?**  
   Yes, conditionally: if the channel is close to an RC record channel with controlled \(\kappa,\gamma\), the rounding constant has no explicit phase-count dependence.

Those statements are documented in the theory directory.

# A. Moving-POVM classification

This is now the strongest mathematical target.

The current POVM theorem assumes each nonzero effect already has an exact eigenvalue-\(1\) repeatable sector.

But a general almost-repeatable measurement may have no exact unit eigenvalue.

## A1. Main question

Suppose

\[
\|\Phi^2-\Phi\|_\diamond\le\eta
\]

for a separated measure-and-prepare channel whose POVM is not repeatability-admissible.

When does there exist a **nearby POVM** \(\{\widetilde E_j\}\) and nearby exact idempotent channel \(\Pi\)?

Find a necessary-and-sufficient conditioning quantity.

Candidate ingredients:

- distance of \(E_j\) to having eigenvalue \(1\),
- separation between near-unit eigenspaces,
- record margin \(\kappa\),
- outcome accessibility.

A classification theorem here would draw the positive boundary against the 2026 entanglement-breaking counterexamples.

# B. Multi-record redundancy geometry

The binary independent case is solved exactly.

## B1. Many records

For \(m>2\),

\[
\kappa_R
=
\min_j
\frac12
\operatorname{dist}_1
\left(
\rho_j^{(R)},
\operatorname{conv}\{\rho_i^{(R)}:i\neq j\}
\right).
\]

Obtain sharp rates for independent mixed records.

The discriminator lemma gives

\[
\kappa_R\ge1-2\epsilon_R,
\]

but this need not be sharp.

## B2. Correlation structure

Classify when adding environmental fragments produces genuine margin gain.

A useful target is a condition in terms of conditional or Chernoff information that distinguishes:

- fresh independent evidence,
- partially correlated evidence,
- perfectly common-mode noise.

## B3. Coupled defect

Redundancy only improves the certificate through \(\kappa_R\) if the repeatability defect \(\eta_R\) remains controlled.

Derive models where \(\eta_R\) and \(\kappa_R\) evolve together.

# C. Microscopic metastability application

The structural transfer theorem is proved.

The next step is physical rather than algebraic.

Take an explicit open-system metastability model and derive, from its microscopic channel:

\[
\delta,\qquad
\kappa,\qquad
\gamma,\qquad
\eta.
\]

Then compare

\[
\Delta_{\rm RC}
=
\delta
+
\sqrt{
\frac{2(\eta+3\delta)}
{\kappa\gamma}
}
\]

against existing QMSM bounds.

Good targets:

- a many-phase classical metastability model,
- a dissipative spin-chain classical sector,
- a hierarchy such as the open quantum East model.

Success would mean obtaining a dimension/phase-count-independent physical certificate from microscopic parameters, not merely assuming record structure.

# D. Experimental certification

Find observable protocols that lower-bound \(\kappa\) and \(\gamma\) and upper-bound \(\eta\) without full process tomography.

The multi-record discriminator lemma is a starting point:

\[
\epsilon_{\rm discrim}
\Rightarrow
\kappa\ge1-2\epsilon_{\rm discrim}.
\]

# E. Formal verification and independent audit

Priority:

1. original sharp theorem,
2. POVM spectral-gap extension,
3. qutrit equality example,
4. metastability transfer bound.

A proof assistant or independent quantum-information researcher should reconstruct these without relying on the session narrative.
