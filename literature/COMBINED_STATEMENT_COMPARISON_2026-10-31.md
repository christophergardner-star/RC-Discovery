# What the combined statement adds: theorem and proof comparison

Date: 31 October 2026. Scope: the current frozen coefficient-two theorem and
direct accessibility certificate. This supersedes the novelty assessment of
the older coefficient-four/coarse-composition route, not its historical record.

## Assessment

The defensible contribution is a **quantitative specialization for a prescribed
measurement correction and its supplied records**. The audit does not establish
a new general orthogonalization, dilation, matrix-inequality, or idempotent
structure theorem.

Two findings narrow the previous assessment substantially:

1. The noncommuting matrix lemma behind coefficient two is exactly a branch
   of a classical Jordan-product bound, identified below.
2. The polar construction in de la Salle's proof, specialized to our sectors,
   gives a weighted alternative. With an elementary residual extension it has
   a uniform joint channel bound at least as strong as our displayed
   measurement envelope. Broad existence of a nearby same-label repeatable
   measurement therefore has a short derivation from established machinery.

The inspected papers do not state the guarantee for the particular
**unweighted** completion frozen in this repository, or our explicit
parameter-controlled correction of the original record states. Those are
narrower comparison targets, not certified discoveries. Even if unpublished,
they may be regarded as useful corollaries or elementary specializations.

## 1. Exactly which statement is being compared?

Use the hypotheses of [the frozen theorem](../theory/THEOREM_V1_FREEZE.md):
full near-unit sectors \(P_j=1_{[1-\delta,1]}(E_j)\), nonzero for each nonzero
effect, \(0<\delta<1/2\), injective synthesis \(T\), and
\(\alpha=\sigma_{\min}(T)>0\). Let \(T=UH\), let \(C_j\) be the coordinate
projections of the direct-sum sector space, and write
\[
Q_j=UC_jU^*,\qquad S=UU^*,\qquad R=I-S,\qquad F_j=Q_j+RE_jR.
\]
The claim controls this particular \(F\), not only the existence of some
approximating measurement:
\[
\|P_j-Q_j\|\le\sqrt{1-\alpha^2},\qquad
\gamma_F\ge\delta,\qquad
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.
\]
The diamond norm is the full norm, with maximum channel distance two.
The record corollary additionally controls an explicitly constructed exactly
idempotent measure-and-prepare channel near the supplied channel.

The domain is restrictive: injectivity forces
\(\sum_j\operatorname{rank}P_j\le\dim\mathcal H\). Thus the number of nonzero
outcomes is at most the dimension. The output need not be a PVM, and a small
bound requires favorable conditioning parameters.

## 2. Source-to-claim comparison

| Inspected primary result | Already supplied | Additional work for the frozen statement |
|---|---|---|
| [de la Salle, v2, Theorems 1.1–1.2 and Section 3](https://arxiv.org/pdf/2103.14126v2) | Same-index PVM rounding in a specified normal-state squared-error metric; a polar construction. | Our stronger sector hypotheses permit a uniform specialization of that construction, but it uses weighted synthesis. Identifying and bounding the prescribed unweighted completion is additional. |
| [KSW, Theorem 1 and Proposition 3](https://arxiv.org/html/0710.2495) | Dimension-independent cb/dilation continuity; for specified isometries, channel distance at most \(2\|W-V\|\). | Choose the repeatable target and estimate its particular dilation. KSW's reverse direction cannot select that target without a closeness premise. |
| [de Bruijn, Theorem 3.2 and Sections 4–5](https://pure.tue.nl/ws/portalfiles/portal/2165089/597564.pdf), rederiving Strang (1962) | The exact Jordan-product inequality used in our coefficient-two proof. | Establish the measurement-specific overlap identity and verify its spectral parameters. |
| [Higham, Theorem 2.2](https://eprints.maths.manchester.ac.uk/694/1/high86p.pdf) and the frame literature | Polar alignment and orthogonalization are established geometry. | The channel interpretation and residual-preserving quantitative application. |
| [Kotowski–Oszmaniec, v1, Theorem 6](https://arxiv.org/pdf/2501.09339v1) | A same-index complement-noise construction that is projectively simulable. | Its output is not required to have unit eigenspaces; it does not give the prescribed residual compression or our channel-distance bound. |
| [Kitaev, v2, Theorems 1.2 and 12.3](https://arxiv.org/html/2405.02434v2) | Exact idempotent encoding/decoding structure; general approximate factorization with dimension-independent errors. | Quantitatively correct the supplied effects and records to exact factors on the original space, under our additional hypotheses. |

Preserving labels, avoiding explicit dimension factors, using polar
decomposition, or ending at a repeatable POVM cannot individually establish
novelty. Detailed source locations and the proof comparisons are retained in
the [orthogonalization/simulation notes](comparison_work/de_la_salle_kotowski_notes.md),
[matrix/dilation notes](comparison_work/ksw_frame_notes.md), and
[record-factorization notes](comparison_work/kitaev_notes.md).

## 3. A complete reduction of the matrix lemma to prior art

Our proof assumes
\(\alpha I\le H\le MI\) and \(dI\le D\le I\), with
\(d=\sqrt{1-\delta}\). Define
\[
a=\frac{M-\alpha}{M+\alpha},\quad b=\frac{1-d}{1+d},\quad
c=\frac{(M+\alpha)(1+d)}4.
\]
Direct algebra gives
\[
1-a-b=
\frac{4\alpha d-(M-\alpha)(1-d)}{(M+\alpha)(1+d)},\qquad
c(1-a)(1-b)=\alpha d.
\]
The \(a+b\le1\) branch of the cited Jordan-product result therefore yields
\[
\operatorname{Re}(HD)\ge\alpha dI
\quad\text{if}\quad (M-\alpha)(1-d)\le4\alpha d.
\]
This is precisely our condition and conclusion. It is an identified prior-art
special case, not merely a similar inequality. The
[coefficient-two proof](../theory/BOUND_CANDIDATE_2026-10-31.md) now credits it.
The remaining use is its substitution into
\(W^*V=UHD\,U^*+R\), followed by standard pure-state trace distance and
contractivity under label readout.

## 4. Proof-level reduction of the broader existence claim

The following is our reconstructed application of published polar machinery.
It is not a theorem quoted verbatim from de la Salle or Higham.

On the packed space \(S\mathcal H\), set \(A_j=SE_jS\). Each \(P_j\)
commutes with \(A_j\). Also
\[
\sum_j\operatorname{rank}P_j=\dim(S\mathcal H),\qquad
\sum_jP_jA_j\ge(1-\delta)\alpha^2 I_{S\mathcal H}.
\]
Thus our \(P_j\) can serve as the fixed projections in the finite-dimensional
polar step of de la Salle's proof; its state-dependent selection is unnecessary
under these stronger hypotheses. In sector coordinates that proof's column
is \(DT^*\), where
\[
D=\bigoplus_j\sqrt{E_j}\big|_{\operatorname{ran}P_j},
\qquad dI\le D\le I.
\]
Consequently its adjoint polarizes \(TD\), rather than the frozen \(T\).

Let \(TD=\widehat U|TD|\). Since \(D\) is invertible, \(\widehat U\) has the
same total range \(S\), and
\(\sigma_{\min}(TD)\ge\alpha d\). With the original labelled inclusion \(J\)
and measurement isometry \(W\), spectral commutation gives
\[
W^*J=TD,\qquad J^*\Lambda_jWR=0.
\]
Define
\[
\widehat V=J\widehat U^*+WR,\quad
\widehat Q_j=\widehat UC_j\widehat U^*,\quad
\widehat F_j=\widehat Q_j+RE_jR.
\]
The labelwise cross-zero identities imply
\(\widehat V^*\widehat V=I\) and
\(\widehat V^*\Lambda_j\widehat V=\widehat F_j\).
This preserves all labels and sector ranks, the residual compression, and
the residual gap. In particular, it is a valid repeatable target.

Here the overlap is positive without any Jordan-product condition:
\[
W^*\widehat V
=TD\widehat U^*+R
=\widehat U|TD|\widehat U^*+R
\ge\alpha dS+R
\ge\alpha dI.
\]
For any purified input, including any reference system, the two dilated
unit vectors have overlap at least \(\alpha d\). Their trace distance is
at most \(2\sqrt{1-\alpha^2d^2}\); common label readout contracts it. Hence
\[
\boxed{\|\mathcal M_E-\mathcal M_{\widehat F}\|_\diamond
\le2\sqrt{1-\alpha^2(1-\delta)}.}
\]
This unconditional joint bound is no larger than the frozen additive
measurement envelope. It concerns a generally different completion.

A conservative sector estimate follows as well. For nonzero sector inclusions
\(T_j\), put \(G=|TD|\). Then
\[
T_j^*\widehat U_j=D_j^{-1}G_{jj},\qquad
\sigma_{\min}(T_j^*\widehat U_j)\ge\alpha d,
\]
using the singular-value product inequality, not an order inequality for a
possibly non-Hermitian product. Equal ranks give
\[
\|P_j-\widehat Q_j\|\le\sqrt{1-\alpha^2(1-\delta)}.
\]
This does not supply the frozen packing-only sector bound
\(\sqrt{1-\alpha^2}\), or the bound for its particular unweighted \(F\).
Substituting the conservative weighted sector estimate into the record
certificate is not a uniform improvement of that certificate either.

**Implication for positioning:** the broader existential measurement claim is
an elementary consequence of an adaptation of established constructions.
State-dependent quantifiers in the published theorem are not, by themselves,
evidence of a substantive gap in the prior methods.

## 5. What the different target genuinely permits

For \(0<t<1/2\), consider
\[
E_0(t)=\operatorname{diag}(1-t,t,1/2),\qquad E_1(t)=I-E_0(t).
\]
Take \(\delta=t\). Its two threshold sectors are orthogonal coordinate
lines, so \(\alpha=1\). Our completion is
\[
F_0=\operatorname{diag}(1,0,1/2),\qquad F_1=I-F_0,
\qquad\|\mathcal M_E-\mathcal M_F\|_\diamond=2t.
\]
Yet the distance to the closest binary PVM on this space is exactly one.
Indeed, for any projection \(L\), the middle ordered eigenvalue of \(E_0(t)\)
is \(1/2\), whereas that of \(L\) is zero or one. Eigenvalue perturbation
gives \(\|E_0(t)-L\|\ge1/2\). Binary measurement-channel distance equals
twice the effect operator-norm difference, including ancillas. The
projection \(\operatorname{diag}(1,0,0)\) attains the lower bound.
Also
\[
\left\|I-E_0(t)^2-E_1(t)^2\right\|=1/2.
\]
Thus our parameters can approach perfect packing and zero threshold error
without a vanishing global almost-projectivity defect or proximity to any
PVM. This rules out a reduction that first approximates the entire
measurement by a close PVM. It does not rule out the packed-subspace
construction in Section 4.

Nor can a fixed normalized-trace squared error automatically replace a
uniform channel estimate. Two diagonal binary PVMs differing on just one
coordinate in dimension \(n\) have
\[
\frac1n\operatorname{Tr}\sum_j(E_j-F_j)^2=\frac2n,\qquad
\|\mathcal M_E-\mathcal M_F\|_\diamond=2.
\]
This is a norm-conversion obstruction, not a claim that all adaptations of
state-dependent rounding must incur a dimension factor.

## 6. Exactly what is additional to Kitaev

This section uses only active labels \(J_+=\{j:E_j\ne0\}\), discarding
unused zero-effect summands and their records. The classical algebra below
is \(\mathbb C^{J_+}\); its identity map is on that algebra. Assume
\(|J_+|\ge2\) for the record margin. The measurement construction above
continues to preserve any zero labels.

For the constructed record channel, define Heisenberg-picture UCP maps
\[
\Delta(f)=\sum_j f_jF_j,\qquad
\Upsilon(X)=\bigl(\operatorname{Tr}(\tau_jX)\bigr)_j.
\]
Since \(\operatorname{Tr}(F_i\tau_j)=\delta_{ij}\),
\(\Upsilon\Delta=I\) and \(\Pi^*=\Delta\Upsilon\).
This is a commutative instance of the known exact encoding/decoding
structure. The endpoint itself is not an additional classification result.

Kitaev's approximate factors satisfy an approximate inverse identity. From
\[
(\Delta\Upsilon)^2-\Delta\Upsilon
=\Delta(\Upsilon\Delta-I)\Upsilon
\]
one obtains approximate, not exact, idempotence. Algebraically replacing
\(\Upsilon\) by \((\Upsilon\Delta)^{-1}\Upsilon\) need not preserve positivity:
\[
A=\begin{pmatrix}9/10&1/10\\1/10&9/10\end{pmatrix},\qquad
A^{-1}=\begin{pmatrix}9/8&-1/8\\-1/8&9/8\end{pmatrix}.
\]
For example, take \(\Delta(f)=\operatorname{diag}(Af)\) and let
\(\Upsilon\) extract the diagonal of a matrix. Both are UCP, but the
proposed inverse correction sends the positive matrix
\(\operatorname{diag}(1,0)\) to \((9/8,-1/8)\).
The negative entry persists for arbitrarily small positive mixing.
This blocks that particular shortcut, not every possible further derivation.

Our additional quantitative specification is to start from the given
\(E_j,\sigma_j\), retain their label correspondence, and move to explicit
exact factors with
\[
\|\Phi-\Pi\|_\diamond\le
\min\left\{2,\ B_{\rm move}+2\sqrt{1-\alpha^2}
+\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}\right\}.
\]
For the record corollary, discard zero effects and their unused records and
assume at least two remaining labels. Precisely,
\[
\kappa=\min_j\frac12
\inf_{\omega\in\operatorname{conv}\{\sigma_i:i\ne j\}}
\|\sigma_j-\omega\|_1>0,\qquad
e=\max_{j:E_j\ne0}(1-\lambda_{\max}(E_j)),
\]
with the convex hull taken over the remaining labels.
Once measurement rounding is available, the remaining proof consists of
an elementary accessibility estimate, the definition of that margin,
spectral compression, and standard normalized gentle projection.
Their attributions and complete argument are in the
[record note](../research/CERTIFICATE_PROGRESS_2026-10-31.md).

This is an exact quantitative conclusion on a much narrower supplied
measure-and-prepare class. It is not a general strengthening of Kitaev's
approximate-algebra theorem, and the accessibility estimate is not a new
general conditioning principle.

## 7. What can now be claimed?

The following description is supported by this comparison:

> Under full near-unit spectral-sector and synthesis-injectivity hypotheses,
> we give explicit channel and sector error estimates for the prescribed
> unweighted polar correction with the original residual compression, and an
> explicit exact-idempotent correction of supplied separated records.
> The arguments specialize established polar, Jordan-product, dilation, and
> gentle-measurement machinery.

The remaining publication questions are correspondingly narrow:

- Has this prescribed-map estimate or its record specialization already
  appeared, perhaps in different notation or as folklore?
- Does controlling that particular map, rather than the weighted alternative,
  solve a useful problem or simplify an existing application?
- Are its constants, parameter dependence, or record guarantees sharp enough
  to justify a separate result?

These questions are not settled by finding no identical theorem wording.
The present audit establishes concrete reductions and distinctions relative
to the inspected results. It cannot prove literature-wide non-derivability
or novelty. External specialist review remains open.

## 8. Local verification of the comparison

The standalone script
[verify_literature_comparison.py](../experiments/verify_literature_comparison.py)
and [retained results](../research/literature_comparison/validation.json) check:

- 45 exact rational substitutions and a boundary equality for the
  Jordan-product condition;
- five exact rational residual examples and nonpositive-inverse examples;
- four exact normalized-trace versus diamond-distance examples;
- 104 weighted constructions, including high-rank sectors, residual spaces,
  near-singular packing, a single outcome, and zero labels;
- six primal/dual measurement SDPs, including two analytical anchors.

Maximum observed identity error was \(8.67\times10^{-15}\). Four constructed
cases fail the unweighted sufficient width condition while satisfying the
weighted overlap estimate. Weighted and unweighted effects differed by up to
approximately \(0.00223\), confirming that the two maps must not be conflated.
All six SDPs met the existing numerical gap/feasibility checks; SCS fallback
was used where CLARABEL did not return optimal status. The largest observed
feasibility violation was approximately \(1.42\times10^{-8}\).

The rational calculations are exact for their finite inputs. Matrix and SDP
checks are floating-point evidence, not interval certificates. The
all-projections separation and universal weighted bound are analytic arguments
above; finite tests do not prove them. No new Lean theorem was added.

Reproduction from the repository root:

    .venv-audit\Scripts\python.exe experiments\verify_literature_comparison.py

The script records its seed and source hashes. It is an additional comparison
check, not yet an entry in the canonical full validation runner.
