# Linear movement when the packed span reduces the POVM

Status: analytic derivation with numerical cross-checks; external review and
novelty review remain open. All norms use the unhalved diamond convention.

Use the hypotheses and notation of `same_label_dimension_free_theorem.md`.
On the packed coordinate space define

\[
 X=DH,\quad q=\|I-X^*X\|,\quad
 L=(1+\|X\|)\|X-I\|+q.
\]

The spectral high parts satisfy
\(\sum_jP_jE_jP_j=TD^2T^*\le I\), so \(X\) is a contraction and
\(0\le I-X^*X\le[1-(1-\delta)\alpha^2]I\).

**Proposition.** If every effect commutes with the total packed projector
\(S=UU^*\), then

\[
 \boxed{\nu_{\rm meas}\le\min\{2,L\}
 \le \min\{2,2(\beta+r_\delta M)+1-(1-\delta)\alpha^2\}.}
\]

In particular this holds when \(S=I\), equivalently the total packed rank
equals the Hilbert-space dimension. Since
\(\beta\le(1-\alpha)+\delta\), \(r_\delta M\le\delta\), and
\(1-(1-\delta)\alpha^2\le2(1-\alpha)+\delta\), this gives

\[
 \boxed{\nu_{\rm meas}\le\min\{2,4(1-\alpha)+5\delta\}.}
\]

Thus the rates become linear under this additional condition. This does not
contradict the general square-root threshold obstruction: its residual space
couples to the packed space.

## Proof

Let \(C_j\) be the coordinate projectors on the packed space. Since \(P_j\)
commutes with \(E_j\), split the effects into positive parts

\[
 E_j=P_jE_jP_j+(I-P_j)E_j(I-P_j).
\]

After identifying \(S\mathcal H\) with \(\mathcal K\) using \(U\), the high
part is \(X^*C_jX\). The remaining effects restricted to this space sum to
\(I-X^*X\). Their measurement map is completely positive and has diamond
norm \(q\) (the standard CP-map norm identity).

The high measurement map is the projective measurement with effects \(C_j\)
after the single-Kraus map \(\rho\mapsto X\rho X^*\). For every input and
ancilla the expansion

\[
 X\rho X^*-\rho=(X-I)\rho X^*+\rho(X^*-I)
\]

and the trace-norm ideal inequality give diamond distance at most
\((1+\|X\|)\|X-I\|\). Post-processing by the projective measurement is
contractive. Adding the positive low map gives \(L\).

When all effects commute with \(S\), both the original and rounded
measurements discard cross terms between \(S\) and \(R\); on \(R\) they
agree exactly. An arbitrary purified input decomposes into these two blocks,
and only the \(S\) block contributes, with weight at most one. Thus the same
bound holds on the entire space, including ancilla-assisted inputs.

Finally \(\|X-I\|\le\|H-I\|+\|(D-I)H\|\le\beta+r_\delta M\).
The displayed scalar estimates finish the proof.

## A bound that explicitly accounts for residual coupling

Without the commutation condition the same decomposition gives

\[
 \boxed{\nu_{\rm meas}\le
 \min\left\{2,\frac{L+\sqrt{L^2+4q}}2\right\}.}
\]

To see this, purify any input and let \(p\) be its weight on \(S\). The
diagonal contribution is at most \(Lp\). The low-part Stinespring map has
operator norm at most \(\sqrt q\) on \(S\) and at most one on \(R\).
Its cross contribution therefore has trace norm at most
\(2\sqrt{qp(1-p)}\), also after the common label-reading channel.
Maximizing \(Lp+2\sqrt{qp(1-p)}\) over \(0\le p\le1\) gives the largest
eigenvalue of \(\begin{pmatrix}L&\sqrt q\\\sqrt q&0\end{pmatrix}\), the formula above.
The high measurement has no cross contribution because all its effects are
supported in \(S\). Convexity extends the purified-input argument to all
states; the standard channel-discrimination characterization gives the diamond
bound. This is a sufficient estimate, not an optimality claim.

## Exact linear-rate family

For an \(m\)-outcome PVM \(Q_j\) with nonzero sectors, take
\(E_j=(1-t)Q_j+tI/m\), \(0<t<1/4\), and threshold \(\delta=t\).
Then \(P_j=Q_j\), \(\alpha=1\), \(S=I\), and

\[
 \|\mathcal M_E-\mathcal M_Q\|_\diamond=2t(1-1/m).
\]

Indeed this is a classical symmetric-noise channel after the projective
measurement. Its norm is the largest column \(\ell_1\) discrepancy, attained
by a state entirely in one sector. Consequently the linear threshold order in
this restricted class cannot be improved uniformly to \(o(t)\).

## Verification and provenance

`experiments/test_residual_coupling_rates.py` checks the matrix decomposition,
the linear bound in the reducing/full-span cases, the general bound with
coupling, exact noisy-PVM rates, ancilla witnesses and selected primal/dual
SDPs. Results are in `research/progress_validation/residual_coupling.json`.

The CP-map diamond norm identity, trace-norm ideal inequality and stabilized
channel-discrimination characterization are standard tools; see John Watrous,
*The Theory of Quantum Information*, Chapter 3:
https://cs.uwaterloo.ca/~watrous/TQI/TQI.pdf . This note claims an improvement
to this repository's analysis, not a verified priority claim for the literature.
