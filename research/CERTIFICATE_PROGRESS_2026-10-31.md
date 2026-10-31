# Record accessibility repairs the composite certificate

Date: 31 October 2026. Status: internally derived and numerically audited;
external correctness and novelty review remain open. This note derives a new
route relative to the repository's previous proof, not a claim of literature
priority. It uses standard trace-norm inequalities and normalized projection.

## 1. A sharp accessibility estimate

Let `Phi(rho) = sum_j Tr(E_j rho) sigma_j` be a finite-dimensional
measure-and-prepare channel on one Hilbert space. All records are density
operators. Set

\[
v_j=\Phi(\sigma_j)-\sigma_j,\qquad
D_{\rm rec}=\max_j\|v_j\|_1,\qquad
\eta=\|\Phi^2-\Phi\|_\diamond.
\]

Suppose, for each label, an input state can produce that label with probability
at least `1-e`, where `0 <= e < 1/2`. Equivalently, one may take

\[
e=\max_j\bigl(1-\lambda_{\max}(E_j)\bigr)<\tfrac12.
\]

Then

\[
\boxed{(1-2e)D_{\rm rec}\le\eta\le D_{\rm rec}.}
\tag{1}
\]

For the upper bound, the action on any system-plus-ancilla state is
`sum_j v_j tensor R_j`, where the conditional ancilla operators are positive
and their traces sum to one. The trace norm is at most `D_rec`. The diamond
norm of this channel difference is attained on a state with an ancilla.

For the lower bound, choose a label `j` attaining `D_rec`, and an input
`rho_j` with probability `p_j >= 1-e`. Write its other outcome probabilities
as `p_i`. Reverse triangle gives

\[
\begin{aligned}
\eta&\ge\|\Phi^2(\rho_j)-\Phi(\rho_j)\|_1
=\Big\|\sum_i p_i v_i\Big\|_1\\
&\ge p_jD_{\rm rec}-\sum_{i\ne j}p_iD_{\rm rec}
=(2p_j-1)D_{\rm rec}\ge(1-2e)D_{\rm rec}.
\end{aligned}
\]

The coefficient is sharp. For the binary diagonal POVM

\[
E_0=\operatorname{diag}(1-e,e),\quad E_1=I-E_0,
\qquad \sigma_0=|0\rangle\langle0|,\quad
\sigma_1=|1\rangle\langle1|,
\]

one has `D_rec=2e` and `eta=2e(1-2e)`. The channel kills input coherences, so
these diamond norms equal the largest column sum of the corresponding
classical transition matrices. At `e=1/2`, the channel is constant and
idempotent, while `D_rec=1`: the strict accessibility condition is essential.

In particular, for an exactly repeatability-admissible POVM (`e=0`),
`eta=D_rec` exactly. Evaluating individual record residuals can replace a
diamond-norm optimization in that case.

## 2. Direct record concentration before measurement movement

Use the hypotheses and notation of the same-label rounding theorem: full
spectral projections `P_j` at threshold `1-delta`, injective synthesis with
smallest singular value `alpha`, polar-rounded projectors `Q_j`, and
`F_j=Q_j+R E_j R`. Assume at least two nonzero labels and record margin

\[
\kappa=\min_j\tfrac12\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\ne j\}}
\|\sigma_j-\omega\|_1>0.
\]

Each label is accessible with `e <= delta < 1/2`. For
`a_j=Tr(E_j sigma_j)`, the convex-hull argument gives

\[
2\kappa(1-a_j)\le\|v_j\|_1
\le \frac{\eta}{1-2e}.
\]

Let `w_j=Tr(P_j sigma_j)`. The full spectral threshold gives
`E_j <= P_j+(1-delta)(I-P_j)`, hence

\[
1-w_j\le q,\qquad
q:=\frac{\eta}{2\kappa\delta(1-2e)}.
\tag{2}
\]

For any purification `psi_j` of `sigma_j`, triangle inequality gives

\[
\begin{aligned}
\sqrt{1-\operatorname{Tr}(Q_j\sigma_j)}
&=\|(I-Q_j)\psi_j\|\\
&\le\|(I-P_j)\psi_j\|+\|(I-Q_j)P_j\psi_j\|\\
&\le\sqrt q+\|P_j-Q_j\|_\infty
\le\sqrt q+\sqrt{1-\alpha^2}.
\end{aligned}
\]

The operators here act trivially on the purifying system. If
`z_j=Tr(Q_j sigma_j)>0`, take `tau_j=Q_j sigma_j Q_j/z_j`. Projecting the
purification and using pure-state trace distance plus partial-trace
contractivity proves

\[
\|\sigma_j-\tau_j\|_1
\le 2\sqrt{1-z_j}
\le 2\sqrt q+2\sqrt{1-\alpha^2}.
\tag{3}
\]

If `z_j=0`, the preceding inequality for `sqrt(1-z_j)` forces the right side
of (3) to be at least 2. Any state supported in nonzero `Q_j` then works.
Thus no division by zero or assumption `q<1` is needed.

## 3. A nonvacuous same-label exact-idempotent certificate

Define `Pi(rho)=sum_j Tr(F_j rho) tau_j`. Because
`Tr(F_i tau_j)=delta_ij`, this channel is exactly idempotent. Let `b` be any
valid upper bound on the original-to-rounded measurement-channel distance.
Common record preparation contracts that distance. The triangle inequality
and (3) give

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le\min\left\{2,\ b+2\sqrt{1-\alpha^2}
+\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}\right\}.
}
\tag{4}
\]

Replacing `e` by `delta` is valid and yields a certificate solely in the
original parameters and `b`. In particular, even the previous coarse
`b=4(sqrt(1-alpha^2)+sqrt(delta))` gives

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le\min\left\{2,\ 6\sqrt{1-\alpha^2}+4\sqrt\delta
+\sqrt{\frac{2\eta}{\kappa\delta(1-2\delta)}}\right\}.
}
\tag{5}
\]

The movement error is no longer placed inside the division by `delta`.
Consequently this expression tends to zero whenever `alpha -> 1`,
`delta -> 0` and `eta/(kappa delta) -> 0`. This is a conditional asymptotic
statement: the threshold-dependent sectors must satisfy the hypotheses
along the chosen sequence. It is not a free optimization over unrelated
values of `alpha`, `delta` and `eta`.

A sharper proven measurement bound can be substituted for `b` in (4).
The [coefficient-two refinement](../theory/BOUND_CANDIDATE_2026-10-31.md)
therefore gives the original-parameter bound
\(\min\{2,4\sqrt{1-\alpha^2}+2\sqrt\delta+
\sqrt{2\eta/[\kappa\delta(1-2\delta)]}\}\).
An instance-specific complement gap
`g=min_j[1-||(I-P_j)E_j(I-P_j)||] >= delta` can also replace `delta` in (2)--(4).
Alternatively, replacing `eta/(1-2e)` by the directly computed `D_rec` remains
valid and can be more accurate. None of these improvements changes the
explicit construction of `Pi`.

## 4. An actual nontrivial family

Take the sharpness family in Section 1, with noise `e=epsilon`, and choose
`delta=sqrt(epsilon)`, for `0<epsilon<1/4`. The spectral sectors are the two
coordinate axes; `alpha=kappa=1`; the rounded POVM is the coordinate PVM;
and `Pi` is complete dephasing. Exactly,

\[
\eta=2\epsilon(1-2\epsilon),\qquad
\|\Phi-\Pi\|_\diamond=2\epsilon.
\]

Using the old coarse movement envelope in (4) gives
`6 epsilon^(1/4)`, which is below 2 for `epsilon<1/81`.
Using only the original parameters in (5), at `epsilon=1e-4`, gives about
`0.602010`. The previous composed certificate with the same coarse movement
is about `15.893224`; clipping it gives only 2. Thus the repaired bound is
nontrivial on a concrete family satisfying all hypotheses.

With coefficient 2 the same original-parameter example instead gives
`0.402010`. The updated test retains both versions; all twelve random cases
give nontrivial coefficient-two certificates.

## 5. Limits and verification

These deductions do not prove optimality of (4), optimal threshold rates,
literature novelty, or a formalized channel theorem. Accessibility estimate
(1) is sharp, but later projection and triangle inequalities need not be.
The binary example demonstrates usefulness, not sharpness of the final
certificate. The computational audit and its retained JSON are provided by
`experiments/test_record_accessibility.py` and
`research/local_validation/record_accessibility.json`.

The run passed seven exact binary cases, twelve random complex quantum cases
in dimensions two and three, and 26 primal/dual channel-distance SDPs including
two normalization anchors. Ten random cases yielded certificates below 2 even
with the older coefficient-4 movement envelope; two were clipped to 2.
Maximum observed primal-dual gap among the random cases was
`7.540110696457967e-10`, maximum feasibility violation was
`8.807006389863708e-9`, and maximum constructed idempotence residual was
`2.3314683518882363e-15`. The tests use a `3e-6` numerical tolerance and add that
slack to numerical eta estimates before applying the certificate. This does
not constitute an interval-certified upper bound. The exact binary formulas
and the analytic proof do not depend on the optimizer.

## 6. Attribution and the additional quantitative statement

The accessibility estimate (1) is an elementary norm-conditioning argument:
the chosen label-accessing inputs give a column-stochastic matrix `A` with
`||A-I||_(1->1) <= 2e`, and the reverse triangle inequality gives the lower
bound. Its sharp binary example does not make it a new general stability
method. The concentration step using `kappa` follows directly from distance
to the competing convex hull. The corresponding classical conditioning
parameter appears in Bittorf, Recht, Re and Tropp,
[Definition 2.1, *Factoring nonnegative matrices with linear programs* (2012)](https://proceedings.neurips.cc/paper/2012/file/08c5433a60135c32e34f46a71175850c-Paper.pdf).
For diagonal records, the trace-norm margin is exactly half that classical
`l1` margin. Normalized projection estimate (3) uses the standard gentle
measurement bound; see Khatri, Lami and Wilde,
[Lemma 6.15, equations (6.2.110)--(6.2.112), August 2025 text](https://www.markwilde.com/PQCT-khatri-wilde.pdf).

The exact endpoint is a classical encoding/decoding structure already
covered by Kitaev,
[arXiv:2405.02434v2, Theorem 1.2 and equations (1.3)--(1.4)](https://arxiv.org/html/2405.02434v2).
Indeed, `Delta(f)=sum_j f_j F_j` and
`Upsilon(X)=(Tr(tau_j X))_j` are UCP maps with
`Upsilon Delta=I` and `Pi*=Delta Upsilon`. The arbitrary residual POVM
contribution is allowed by that established structure. Kitaev's Theorem
12.3 instead supplies approximate factors and approximate inverse identities;
it does not itself supply the particular exact correction constructed here.

The additional quantitative statement is therefore correction of the
prescribed effects and records to those exact factors, preserving the
labels and controlling the change through the stated geometric parameters.
After the measurement-rounding estimate, this certificate follows by the
elementary and standard steps above. It is not a new classification of
idempotent channels or a general improvement of Kitaev's theorem. See the
[combined-statement comparison](../literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
for the precise comparison and its limits.
