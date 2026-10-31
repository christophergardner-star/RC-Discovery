# Proof Dependency Map

## Main output

\[
\|\Phi-\Pi\|_\diamond
\le
\min\left\{
2,\,
B_{\rm move}
+
2\sqrt{1-\alpha^2}
+
\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}
\right\}.
\]

## Dependency graph

### Layer 1: Established background

- spectral theorem and functional calculus;
- polar decomposition;
- principal angles and projector distance;
- Naimark/Stinespring dilation;
- trace-norm contractivity;
- pure-input diamond-norm characterisation;
- normalised projection inequality;
- repeatability criterion for discrete POVMs.

### Layer 2: Packing geometry

Hypotheses:
\[
P_j,\quad T,\quad \alpha>0.
\]

Outputs:
\[
Q_j,\quad
\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2},
\quad
R=I-\sum_jQ_j.
\]

### Layer 3: Same-label completion

Input:
\[
Q_j,R,E_j.
\]

Output:
\[
F_j=Q_j+R E_jR,
\quad
\sum_jF_j=I,
\quad
F_iQ_j=\delta_{ij}Q_j,
\quad
\gamma_F\ge\delta.
\]

### Layer 4: Hybrid isometry

Inputs:
\[
W,\ J_{\mathcal K},\ U,\ R.
\]

Outputs:
\[
J_{\mathcal K}^*WR=0,
\quad
V=J_{\mathcal K}U^*+WR,
\quad
V^*V=I,
\quad
V^*\Lambda_jV=F_j.
\]

### Layer 5: Operational movement

Input: overlap and noncommuting positive-matrix bound.

Output:
\[
B_{\rm move}
=
2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.
\]

### Layer 6: Record accessibility

Inputs:
\[
\eta,\kappa,e,\delta,\alpha.
\]

Outputs:
\[
D_{\rm rec}\le\eta/(1-2e),
\]
sector concentration, projected records \(\tau_j\), and exact idempotence of \(\Pi\).

### Layer 7: Final triangle inequality

Combines measurement movement and record movement.

## Failure modes

- If \(\alpha=0\): packing fails.
- If \(P_j=0\) for a nonzero label: repeatability for that label is not supplied.
- If \(e\ge1/2\): accessibility inversion fails.
- If \(\kappa=0\): record identification fails.
- If \(J\) is mistyped as a polar-vector embedding: core identities change.
- If threshold projection is not full: residual gap claim may fail.
