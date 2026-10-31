# A constant-two bound for the same-label construction

Date: 31 October 2026.
Status: analytic refinement, independently reconstructed internally and numerically checked; not a novelty or optimality claim. The operator inequalities in this note are not yet Lean-formalized.

## Statement

Under exactly the finite-dimensional hypotheses of
[the same-label theorem](same_label_dimension_free_theorem.md), the particular
completion \(F_j=Q_j+RE_jR\) satisfies

\[
\boxed{\nu_{\mathrm{meas}}\le
2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.}
\]

The same upper bound holds after common record-state preparation. This replaces
the previous coefficient 4 by 2, without an outcome-count or dimension factor.
We do not claim coefficient 2 is optimal.

There is a stronger conditional estimate. Set
\(d=\sqrt{1-\delta}\), \(r=1-d\), and \(M=\|H\|\). If

\[
(M-\alpha)r\le4\alpha d, \tag{C}
\]

then

\[
\boxed{\nu_{\mathrm{meas}}\le
2\sqrt{1-\alpha^2(1-\delta)}.} \tag{1}
\]

Condition (C) is sufficient, not necessary. The stronger formula (1) is not
asserted without it. In particular, (C) holds throughout the parameter region
where \(\sqrt{1-\alpha^2}+\sqrt\delta<1\).

## Positive-matrix lemma

Suppose \(\alpha I\le H\le MI\) and \(dI\le D\le I\), with
\(\alpha,d>0\). Put \(X=H-\alpha I\), \(Y=D-dI\), and
\(h=M-\alpha\). Thus \(0\le X\le hI\), \(0\le Y\le rI\).

For every \(t>0\), positivity of
\((\sqrt t X+t^{-1/2}Y)^2\) gives

\[
XY+YX\ge-tX^2-t^{-1}Y^2\ge-thX-(r/t)Y.
\]

Consequently

\[
\operatorname{Re}(HD)-\alpha dI
=dX+\alpha Y+\tfrac12(XY+YX)
\ge(d-th/2)X+(\alpha-r/(2t))Y.
\]

If \(h>0\), choose \(t=2d/h\). Under (C) both coefficients are
nonnegative. If \(h=0\), then \(H=\alpha I\) and the conclusion is
immediate. Therefore

\[
\boxed{\operatorname{Re}(HD)\ge\alpha dI.} \tag{2}
\]

This argument explicitly handles noncommuting \(H,D\). A lower bound on the
eigenvalues of their product alone would not imply (2).

## From overlap to diamond distance

For the already-constructed isometries \(W,V\), the typed sector identities
give \(W^*J_{\mathcal K}=TD=UHD\), so

\[
W^*V=UHD U^*+R.
\]

Because \(\alpha\le1\), (2) implies
\(\operatorname{Re}(W^*V)\ge\alpha dI\). Here
\(\alpha\le1\) follows also directly from the unit diagonal blocks of
\(T^*T\): its average eigenvalue equals 1.

For any normalized input \(\psi\), including an arbitrary reference system,
the two pure output vectors \((W\otimes I)\psi\) and \((V\otimes I)\psi\)
have overlap with real part at least \(\alpha d\). Their density operators
therefore differ in trace norm by at most
\(2\sqrt{1-\alpha^2d^2}\). Reading out labels is common CPTP
post-processing, so it cannot increase this trace distance. Taking the
supremum over reference-assisted pure inputs proves (1).

The pure-input characterization of the diamond norm for Hermiticity-preserving
maps is standard: see Theorem 3.51 in
[Watrous, *The Theory of Quantum Information*, Chapter 3](https://cs.uwaterloo.ca/~watrous/TQI/TQI.3.pdf).
No new channel-discrimination principle is claimed here.

## Why coefficient 2 is unconditional

Write \(a=\sqrt{1-\alpha^2}\), \(b=\sqrt\delta\).
If \(a+b\ge1\), the general channel-distance bound \(\nu\le2\)
proves the stated estimate.

Otherwise \(a<1-b\), so
\(\alpha^2>2b-b^2>b^2\), and hence \(\alpha>b\).
The POVM bound \(M\le1/d\) and \(0<\delta<1/2\) give
\(Mr\le\delta\). Therefore

\[
(M-\alpha)r\le Mr\le\delta<4\alpha d.
\]

Indeed, \(\alpha>\sqrt\delta\) and
\(4\sqrt{1-\delta}>\sqrt\delta\) on this interval. Thus (C) holds.
By (1),

\[
\nu\le2\sqrt{a^2+\alpha^2\delta}
\le2(a+\alpha\sqrt\delta)
\le2(a+b).
\]

## Checks and limitations

`experiments/test_constant_two_bound.py` uses seed `2026103111` for abstract
matrix tests and the existing deterministic POVM generators. It checks the
positive-matrix lemma on 1,982 admissible samples among 6,000 generated
noncommuting matrix pairs, plus 136 physical POVMs. A deliberate negative
control violates (C) and invalidates (2), preventing accidental removal of
the condition. It additionally checks all 408 previously saved
ancilla-assisted witnesses and 12 saved primal SDP values against the new
unconditional bound. The SDP problems are not rerun by this script.

Results are retained in
[`research/local_validation/constant_two.json`](../research/local_validation/constant_two.json).
The maximum saved SDP-value/new-bound ratio is approximately 0.5352. These
checks support the derivation but do not replace its proof, establish optimality,
or establish novelty. The coefficient improvement alone does not resolve the
vacuity of the composed exact-idempotence certificate when a coarse scalar
movement envelope is substituted.
