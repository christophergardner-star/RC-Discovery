# Open Problems

Ordered by falsifiability and proximity to the proved theorem.

## A. Boundary of positive exact rounding

The 2026 negative result shows that general entanglement-breaking channels can be almost idempotent while remaining far from every exact idempotent.

The RC theorem gives a positive subclass.

### A1. Maximal positive subclass

Characterise the largest measure-and-prepare subclass for which a dimension-independent exact-rounding bound exists.

Questions:

- Is sharp projective readout necessary?
- Can a sufficiently well-conditioned POVM replace \(\{P_j\}\)?
- Can the output records live in a different Hilbert space?
- What is the optimal conditioning parameter replacing \(\kappa\)?

A counterexample is as valuable as a proof.

## B. Redundancy \(\rightarrow\) margin \(\rightarrow\) stability

For record families \(\rho_j^{(R)}\) built from \(R\) environmental fragments, define

\[
\kappa_R
=
\min_j
\frac12
\inf_{\omega\in\operatorname{conv}\{\rho_i^{(R)}:i\neq j\}}
\|\rho_j^{(R)}-\omega\|_1.
\]

### B1

Determine conditions under which \(\kappa_R\) increases with \(R\).

If \(\kappa_R\to1\), the theorem gives

\[
\|\Phi_R-\Pi_R\|_\diamond
\le
\sqrt{\frac{2\eta_R}{\kappa_R}}.
\]

### B2

For independent record fragments, derive the exact rate.

For two pure single-fragment records with overlap \(s\), tensor-product overlap is \(s^R\). Work out the induced \(\kappa_R\) and stability rate.

### B3

Construct correlated-record families where nominal redundancy does **not** improve \(\kappa_R\). This prevents the false claim that more copies always imply stronger objectivity.

## C. Metastable quantum dynamics

Can record-margin separation replace bounded slow dimension for a useful class of metastable channels?

A target theorem would have constants controlled by long-lived record geometry rather than the number of slow degrees of freedom.

## D. Experimental certification

Find experimentally estimable lower bounds on \(\kappa\) and upper bounds on \(\eta\) that avoid full process tomography.

A successful protocol would turn the theorem into:

\[
\text{measured repeatability}
+
\text{measured record separation}
\Rightarrow
\text{distance to ideal repeatable readout}.
\]

## E. Formal verification

Encode the theorem in a proof assistant or obtain an independent mathematical reconstruction.

Priority checks:

- post-selection trace-distance inequality,
- ancilla/diamond-norm step,
- zero-support edge cases,
- sharpness family.
