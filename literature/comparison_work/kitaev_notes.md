# Kitaev and the record-process corollary: implication audit

Date: 31 October 2026. Working comparison for the canonical frozen theorem.
This is a statement/proof comparison, not a literature-wide novelty verdict.

## Primary statements inspected

Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*,
[arXiv:2405.02434v2, full text](https://arxiv.org/html/2405.02434v2):

- Theorem 12.3 and equations (12.23)--(12.24): for a finite-dimensional UCP map
  with cb idempotence defect at most eta, UCP maps Delta and Upsilon factor
  it up to O(eta), with Upsilon Delta close to the identity and a stronger
  approximate-product estimate, uniformly over matrix amplifications.
- Theorem 1.2 and equations (1.3)--(1.4), proved in Section 11.3: exact
  idempotents admit exact encoding/decoding structure with an arbitrary CP
  contribution from the orthogonal complement of the code space.
- Section 1.2, especially Example 1.3: spectral rounding gives a nearby
  algebraically idempotent linear map but can destroy positivity. Exact UCP
  rounding is explicitly distinguished from approximate factorization.

These statements use the Heisenberg picture. Taking adjoints converts the
cb norm into the diamond norm used in the repository.

## The exact endpoint is already a known structure

All maps in this section are indexed by active labels with E_j nonzero.
Discard zero-effect summands and their unused records first; the classical
algebra is C^(number of active labels). At least two active labels are
assumed for the competing-convex-hull margin.

For the repository's constructed states tau_j and effects F_j, define

\[
\Delta(f)=\sum_j f_jF_j,
\qquad
\Upsilon(X)=(\operatorname{Tr}(\tau_jX))_j.
\]

These are UCP maps between the classical algebra C^m and B(H).
The identity Tr(F_i tau_j)=delta_ij gives Upsilon Delta=id, while
Pi*=Delta Upsilon. Consequently Pi* is idempotent.

This is precisely an instance of the commutative exact encoding/decoding
structure. On S=sum Q_j, Delta is the representation f -> sum f_j Q_j;
on R it is the arbitrary UCP map f -> sum f_j R E_j R. Thus neither the
existence of this kind of endpoint nor the residual-POVM form alone is an
additional structure theorem.

The extra statement sought by RC is quantitative: starting from the
prescribed E_j and sigma_j, construct these particular factors with the
same labels and control their movement using alpha, delta, kappa, e, eta.

## Why approximate factorization is not the desired corollary

Let C=Delta Upsilon. Elementary multiplication gives

\[
C^2-C=\Delta(\Upsilon\Delta-I)\Upsilon.
\]

An O(eta) error in Upsilon Delta implies approximate idempotence, not exact
idempotence. Replacing Upsilon by (Upsilon Delta)^(-1) Upsilon repairs the
algebraic identity when the inverse exists, but need not preserve positivity.

For a concrete classical example, take the stochastic matrix

\[
A=\begin{pmatrix}9/10&1/10\\1/10&9/10\end{pmatrix},
\qquad
A^{-1}=\begin{pmatrix}9/8&-1/8\\-1/8&9/8\end{pmatrix}.
\]

Let Delta send a classical function to diag(Af), and Upsilon extract a
matrix's diagonal. Both are UCP, but Upsilon Delta=A. The inverse correction
maps the positive matrix diag(1,0) to (9/8,-1/8), which is not positive.
The same phenomenon persists for arbitrarily small positive off-diagonal
noise. This defeats that proposed direct reduction; it is not a proof that
no more elaborate argument from Kitaev plus additional lemmas can work.

## How much of the record argument is elementary or inherited?

The accessibility step can be restated as ordinary norm conditioning.
Choose states rho_j accessing outcome j with probability at least 1-e,
and put A_ij=Tr(E_i rho_j). Then A is column stochastic and
\|A-I\|_(1->1)<=2e. Let B map the j-th coordinate vector to
v_j=Phi(sigma_j)-sigma_j. Its induced norm is
D_rec=max_j\|v_j\|_1. Each column of BA is (Phi^2-Phi)(rho_j), so
\|BA\|_(1->1)<=eta. Neumann inversion, or directly the reverse triangle
inequality on a maximizing column, gives

\[
(1-2e)D_{\rm rec}\le\eta.
\]

The upper bound eta<=D_rec follows by the standard conditional-ancilla
decomposition of a measure-and-prepare channel difference. The binary
noisy measurement supplies equality, as already documented in the repo.
This is a useful sharp specialization, but the proof is an elementary
norm estimate and should not be presented as a new general stability tool.

The margin step is also exact convex geometry. Writing
Phi(sigma_j)=a_j sigma_j+(1-a_j)omega_j with omega_j in the competing convex
hull yields
\|Phi(sigma_j)-sigma_j\|_1>=2 kappa (1-a_j) directly from the definition.
Distance to the convex hull of the remaining points is an established
conditioning parameter: see Bittorf, Recht, Re and Tropp,
[Definition 2.1](https://proceedings.neurips.cc/paper/2012/file/08c5433a60135c32e34f46a71175850c-Paper.pdf),
for its classical l1 form. The RC trace-norm version reduces to that form
for diagonal states; the NMF theorem itself does not provide quantum
measurement rounding.

The normalized projection inequality
\|sigma-Q sigma Q/Tr(Q sigma)\|_1<=2 sqrt(1-Tr(Q sigma)) is standard gentle
measurement. See Khatri, Lami and Wilde,
[Lemma 6.15, equations (6.2.110)--(6.2.112)](https://www.markwilde.com/PQCT-khatri-wilde.pdf).

Combining those elementary steps with the already established RC measurement
rounding gives

\[
\|\Phi-\Pi\|_\diamond\le
\min\!\left\{2,
B_{\rm move}+2\sqrt{1-\alpha^2}
+\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}\right\}.
\]

The appropriate potential contribution is therefore the explicit,
parameter-controlled correction to an exact classical retract, built on
the measurement theorem. It is not a replacement for Kitaev's broader
approximate-algebra theorem, a new classification of idempotent channels,
or a new gentle-measurement principle.

## Scope of this conclusion

Kitaev's inspected theorem applies to all sufficiently almost-idempotent
finite-dimensional channels and does not require a supplied record
decomposition. RC assumes measure-and-prepare form, identifiable records,
near-unit sectors for every nonzero effect, and injective sector synthesis.
Its exactness and prescribed construction are stronger conclusions on a
much narrower class, rather than a general improvement of Kitaev's result.

The Zenodo record for Chenxiao's 2026 negative preprint was located, but its
full PDF was inaccessible through the web tool during this sub-audit.
No claim in this comparison depends on accepting that preprint's main
lower bound. The failed direct inverse correction above is elementary and
independently checkable.
