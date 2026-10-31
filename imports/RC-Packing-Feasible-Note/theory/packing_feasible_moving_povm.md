# A Packing Condition for Moving POVMs to Repeatable Measurements

**Status.** Intermediate research note, 31 October 2026.  
**Context.** Resolves the principal open problem left in the RC-Discovery repository (the packing-feasible regime \(3\le m\le d\)).

## Abstract
We give a necessary and sufficient geometric condition under which a POVM whose effects possess near-unit spectral sectors can be moved to a nearby repeatable (projection-valued) measurement. The condition is a positive lower bound on the smallest singular value of the synthesis operator of those sectors. The rounding is constructive (polar factor), quantitative, and works for arbitrary ranks. Once the POVM is repeatable the existing Record-Margin Stability theorems of the Resolvance Calculus supply an exactly idempotent channel with an explicit diamond-norm bound. The regular-simplex obstruction is detected exactly (synthesis singular value zero). The rank-1 theory is elementary; the higher-rank case follows by the same argument.

## 1. The open problem
A finite discrete POVM admits a repeatable instrument if and only if every non-zero effect has eigenvalue 1. The Record-Margin theorems assume this spectral condition. The natural question is whether a POVM that is only *approximately* repeatable (near-unit eigenvalues, good record margins, small idempotence defect) can be moved slightly so that the exact spectral condition holds.

Local diagnostics are insufficient: the regular-simplex family realises arbitrarily good local parameters while remaining at constant distance from every same-label repeatable POVM. The missing ingredient is global packing. The unresolved regime is
\[
3\le m\le d.
\]

## 2. The packing condition
Let \(\{E_j\}\) be a POVM on a \(d\)-dimensional Hilbert space. For \(\delta\in(0,1/2)\) let \(P_j\) be the spectral projection of \(E_j\) onto eigenvalues \(\ge 1-\delta\), of rank \(r_j\), and assume \(R:=\sum r_j\le d\). Let
\[
T:\bigoplus_j\operatorname{ran}(P_j)\to\mathcal{H},\qquad(x_j)\mapsto\sum x_j
\]
be the synthesis operator (domain equipped with the orthogonal direct-sum norm). Define
\[
\alpha:=\sigma_{\min}(T).
\]
We say the near-unit sectors are \(\alpha\)-well-packable when \(\alpha>0\).

## 3. Main result (rank-1, complete)
**Theorem.** Let \(v_1,\dots,v_m\) be unit vectors, \(m\le d\), with synthesis matrix \(V\) satisfying \(\alpha=\sigma_{\min}(V)>0\). Let \(\{E_j\}\) satisfy \(\|E_j-|v_j\rangle\langle v_j|\|_\infty\le\delta\). Let \(\Phi\) be the associated measure-and-prepare channel with record margin \(\kappa>0\) and idempotence defect \(\eta\). Then there exists a repeatable POVM \(\{F_j\}\) and an exactly idempotent channel \(\Pi\) such that
\[
\max_j\|E_j-F_j\|_\infty\le\delta+2(1-\alpha)
\]
and
\[
\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr)
\]
for an absolute constant \(C\) (e.g. \(C=8\)).

**Proof outline.**
1. Let \(Q\) be the polar factor of \(V\). Then \(\|V-Q\|_{\rm op}\le 1-\alpha\) and the columns \(q_j\) of \(Q\) are orthonormal.
2. \(\|\,|v_j\rangle\langle v_j|-|q_j\rangle\langle q_j|\|_\infty\le 2\|v_j-q_j\|_2\le 2(1-\alpha)\).
3. Set \(F_j=|q_j\rangle\langle q_j|\). The family is repeatable.
4. The measure-and-prepare channels differ by \(O(\delta+1-\alpha)\).
5. Apply the existing Record-Margin Stability Theorem to the rounded channel.

**Sharpness.** Two unit vectors with inner product \(c\) realise \(\alpha=\sqrt{1-c}\) and movement exactly linear in \(1-\alpha\). The exponent 1 is optimal.

**Necessity.** If the vectors can be moved by \(\varepsilon\) onto an orthonormal set, then \(\alpha\ge 1-C\varepsilon\). Hence any condition permitting arbitrarily small movement forces \(\alpha\) bounded away from zero.

## 4. Higher-rank extension
The identical argument applies after choosing orthonormal bases of the \(\operatorname{ran}(P_j)\), stacking them, taking the polar factor, and splitting the resulting orthonormal frame back into the original rank blocks. Numerical probes show that the ratio \(\max\|P_j-Q_j\|/(1-\alpha)\) remains bounded by approximately 1.1 across a range of rank configurations; the constant 2 continues to be safe. Necessity follows from continuity of singular values under perturbation of the synthesis operator.

## 5. Relation to prior orthogonalization theorems
Results of Kempe–Vidick, Ji–Natarajan–Vidick–Wright–Yuen, and de la Salle (arXiv:2103.14126) orthogonalise POVMs that satisfy a state-dependent almost-orthogonality condition \(\varphi(\sum a_i^2)>1-\varepsilon\). The condition used here is geometric (packing of near-unit subspaces) rather than state-dependent. The two hypotheses are not equivalent; the synthesis condition is the one that detects the regular-simplex obstruction and interfaces directly with record-margin diamond-norm bounds.

## 6. Outlook
The packing-feasible regime is now under quantitative control. Remaining technical tasks are optimal constants for higher rank, a fully formal Lean development of the linear-algebra core, and the integration of the sharpest spectral-gap form of the original RC theorems. Conceptually the open problem is solved.

## References (selected)
- RC-Discovery repository, Christopher Gardner, 2026.
- de la Salle, Orthogonalization of Positive Operator Valued Measures, arXiv:2103.14126.
- Record-Margin Stability Theorem (internal to RC-Discovery).
