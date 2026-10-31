# Proof-level comparison: de la Salle and Kotowski--Oszmaniec

Date: 31 October 2026.

Status: primary theorem statements and relevant proofs inspected. The weighted
construction below is our reconstructed consequence/application of established
polar alignment, not a theorem quoted verbatim from either paper and not a
novelty claim. No canonical theorem files were changed in this assessment.

## Primary statements inspected

### de la Salle

Source: Mikael de la Salle, *Orthogonalization of Positive Operator Valued
Measures*, [arXiv:2103.14126v2](https://arxiv.org/pdf/2103.14126v2), 11 January
2022; Theorems 1.1--1.2, Lemmas 3.1--3.2 and the finite-case proof in Section 3,
PDF pages 1--2 and 5--8.

Theorem 1.2: for a von Neumann algebra M, normal state phi and POVM (a_i),

    phi(sum_i a_i^2) > 1-epsilon

implies existence of a PVM (p_i) in M satisfying

    phi(sum_i |a_i-p_i|^2) < 9 epsilon.

Theorem 1.1 is its vector-state formulation and also preserves commutants.
The output uses the SAME labels; some output projections may be zero.
Its metric is a state-weighted squared operator error, not diamond distance.

In the finite proof, Lemma 3.1 selects commuting projections q_i with total
central trace one and phi(sum_i q_i a_i) >= 1-epsilon. The selection maximizes
a phi-dependent objective. The proof polarizes the column

    x = sum_i e_(i,1) tensor q_i sqrt(a_i),

then pulls coordinate projections back through its polar isometry.

### Kotowski--Oszmaniec

Source: Michal Kotowski and Michal Oszmaniec, *Pretty-good simulation of all
quantum measurements by projective measurements*,
[arXiv:2501.09339v1](https://arxiv.org/pdf/2501.09339v1), 16 January 2025;
Result 2, Lemma 3, Theorem 6 and its complete proof, PDF pages 5, 10 and 13;
Appendix A.3--A.4, PDF pages 17--18. Version-specific constants below refer to
this inspected preprint.

Theorem 6 assumes l <= d/2 and a POVM N on C^d with
N_i=A_i |psi_i><psi_i| for i<=l. Put W=span{psi_i}. It constructs

    F_i=N_i+(1-A_i) P_(W-perp)/dim(W-perp), i<=l,
    F_(l+1)=I-sum_(i<=l) F_i,

and proves F is projectively simulable. The proof uses a Naimark dilation of
N restricted to W inside C^d, followed by unitary averaging on W-perp.
There is no diamond-distance conclusion in this theorem.

Lemma 3 gives projective simulability after depolarization with visibility

    min_i dim(W-perp) A_i / [dim(W)(1-A_i)+dim(W-perp)].

Result 2 applies to arbitrary POVMs and proves projective simulability after
depolarization with visibility 0.02. Projective simulability means a classical
randomization of projective measurements; it does not imply exact unit sectors.

## Why the published de la Salle statement alone is not our theorem

The quantifiers are, schematically, for every state phi and eligible POVM,
there exists an approximating PVM depending on phi. Applying that statement
separately to all states does not produce one approximation valid uniformly.
Moreover, our target F is generally a POVM with exact unit sectors rather than
a PVM. These differences are genuine but are NOT a sufficient novelty argument:
the proof can be adapted using projections supplied by our stronger hypotheses.

For completeness, the naive tracial reduction on a k-dimensional packed space
only yields

    Tr(sum_i |a_i-p_i|^2) < 9 k epsilon,
    ||sum_i |a_i-p_i|^2|| <= 9 k epsilon.

That conversion incurs a dimension factor. The fixed-projection construction
below avoids this problem, so it would be misleading to use the naive loss as
evidence that prior orthogonalization methods cannot address our situation.

## Exact bridge from our sectors to de la Salle's polar column

Use the notation of the frozen theorem. Let K be the direct sum of the full
near-unit sectors, T:K->H their synthesis map, S the projection onto ran(T),
R=I-S, and alpha=sigma_min(T)>0. Write d0=sqrt(1-delta).

On the Hilbert space ran(S), define a_j=S E_j S. These form a POVM. Each P_j
commutes with a_j because E_j commutes with its spectral projection P_j and
P_j<=S. Also

    sum_j rank(P_j) = dim(ran(S)),
    a_j^2 >= (1-delta)^2 P_j,
    sum_j a_j^2 >= (1-delta)^2 alpha^2 I_S,
    sum_j P_j a_j >= (1-delta) alpha^2 I_S.

The final two inequalities use sum_j P_j=T T* >= alpha^2 S.
Thus the P_j themselves can replace the projections selected in Lemma 3.1;
they are fixed independently of phi. Its finite-matrix central-trace condition
is exactly the displayed rank identity. Taking epsilon slightly greater than
1-(1-delta)^2 alpha^2 handles the strict inequality in the theorem statement.

Define D on K blockwise by D_j=sqrt(E_j)|ran(P_j). Then

    d0 I_K <= D <= I_K.

The column in de la Salle's finite proof, with q_j=P_j, is precisely

    x:ran(S)->K, x z=(P_j sqrt(a_j) z)_j = D T* z.

Indeed sqrt(a_j) agrees with sqrt(E_j) on ran(P_j), and P_j is reducing for
a_j. Its adjoint is A=T D:K->ran(S). The projections obtained by this polar
step are the polar orthogonalization of WEIGHTED synthesis A, not necessarily
the frozen theorem's polar orthogonalization of unweighted T.

This is a proof-level overlap, not just a resemblance in terminology.

## A weighted completion and unconditional joint bound

This paragraph is an independently reconstructed application of that polar
construction and the usual purification/trace-distance argument.

Let A=T D=Uhat |A|. Since D is invertible,

    ran(A)=ran(T), Uhat* Uhat=I_K, Uhat Uhat*=S,
    sigma_min(A) >= alpha d0.

Let J:K->direct_sum_j H be the correctly typed labelled inclusion from the
frozen theorem and W:H->direct_sum_j H be Wz=(sqrt(E_j)z)_j. Then

    W*J=T D=A, J*W R=0.

Set

    Vhat=J Uhat*+W R,
    Qhat_j=Uhat C_j Uhat*,
    Fhat_j=Qhat_j+R E_j R,

where C_j is the jth coordinate projection on K. The identical orthogonality
calculation used for the canonical hybrid proves

    Vhat* Vhat=I,
    Vhat* Lambda_j Vhat=Fhat_j.

Thus Fhat is a POVM with the same labels and prescribed sector ranks. Its
exact unit sectors and residual gap follow as in the frozen construction;
the residual R has not changed.

Crucially,

    W*Vhat=A Uhat*+R
           =Uhat |A| Uhat*+R
           >= alpha d0 S+R
           >= alpha d0 I.

The last inequality uses alpha<=1. This lower bound survives tensoring with
any reference system. The two pure dilated outputs consequently have trace
distance at most 2 sqrt(1-alpha^2(1-delta)). Common measurement of the labels
cannot increase trace distance. Therefore

    ||M_E-M_Fhat||_diamond <= 2 sqrt(1-alpha^2(1-delta)).

This bound is unconditional under the frozen hypotheses; the noncommuting
width condition needed for the canonical UNWEIGHTED joint estimate is absent.
It is no larger than 2 min{1,sqrt(1-alpha^2)+sqrt(delta)}.

A conservative sector estimate is also immediate. Writing T_j for the
inclusion of sector j and H_A=|A|,

    T_j* Uhat_j=D_j^(-1) (H_A)_(jj).

Since (H_A)_(jj)>=alpha d0 I and ||D_j||<=1, its smallest singular value is
at least alpha d0. Equal sector dimensions then give

    ||P_j-Qhat_j|| <= sqrt(1-alpha^2(1-delta)).

This is not the frozen sharper packing-only projection bound
sqrt(1-alpha^2). The weighted construction does not by itself prove that
specific bound, or the coefficient-two assertion for the specific unweighted F.

## Explicit separation from global closeness to a PVM

For m>=2, work on C^(m+1), take orthogonal rank-one Q_1,...,Q_m and the
remaining rank-one projection R, and put E_j=Q_j+R/m. For every
delta in (0,1/2), the near-unit sectors are P_j=Q_j, alpha=1 and the frozen
completion equals E exactly. Yet

    I-sum_j E_j^2=(1-1/m)R.

Consequently no global nearprojectivity defect tending to zero with delta
can follow from alpha=1 and small delta.

More strongly, its diamond distance to the closest same-label PVM is exactly
2(1-1/m). In any m-label PVM on C^(m+1), at least one effect L_j has rank at
least two. Choose a unit vector in ran(L_j) orthogonal to ran(Q_j). The PVM
outputs j with probability one; E outputs j with probability at most 1/m.
The output l1-distance is at least 2(1-1/m). Assigning all of R to one Q_j
attains that distance, including reference-assisted inputs.

A nontrivial rounding variant is binary on C^3:

    E_0(t)=diag(1-t,t,1/2), E_1(t)=I-E_0(t), 0<t<1/2,
    delta=t, alpha=1,
    F_0=diag(1,0,1/2), F_1=I-F_0.

The canonical movement is 2t. Distance to every binary PVM is at least one:
the middle eigenvalue 1/2 of E_0 differs by at least 1/2 from the middle
eigenvalue of any projection, and binary measurement diamond distance is
twice the effect operator-norm difference. The bound one is attained by
the projection diag(1,0,0).

These examples rule out a route that first approximates the ENTIRE original
POVM by a globally close PVM with error vanishing with our parameters. They do
not rule out the packed-subspace reduction and weighted polar argument above.

## Kotowski--Oszmaniec: precise overlap and limitation

Theorem 6 also keeps its input labels and adds terms on a complementary
subspace. Those features alone therefore cannot support a novelty claim.
Its construction instead preserves the rank-one effects on W and adds
isotropic complement noise, proving a simulation property. It neither
orthogonalizes all chosen sectors into exact unit sectors nor controls our
prescribed completion in diamond norm.

For example, take d=2, l=1,

    N_1=(1-t)|0><0|,
    N_2=t|0><0|+|1><1|, 0<t<1/2.

Theorem 6 outputs

    F_1=(1-t)|0><0|+t|1><1|,
    F_2=t|0><0|+(1-t)|1><1|.

Neither output effect has eigenvalue one. Our threshold delta=t gives alpha=1,
zero residual space and the exact computational-basis PVM instead. This
separates the conclusions even on shared inputs.

The uniform-residual example above is already projectively simulable, so it
does NOT separate our domain from projective simulability and should not be
used to exclude all applications of Kotowski--Oszmaniec. Fine-graining,
compression and post-processing must be considered before asserting any
broader non-derivability.

## Assessment

Neither inspected published statement directly asserts the frozen canonical
unweighted coefficient-two theorem. However, de la Salle's proof contains
the relevant weighted polar orthogonalization, and our hypotheses allow it
to be chosen uniformly. With the standard hybrid completion and channel
overlap step, this gives a same-label EXISTENCE result with a stronger joint
movement estimate. That substantially weakens any novelty claim based merely
on existence of dimension-free same-label rounding.

The remaining exact comparison target is the prescribed UNWEIGHTED completion,
its packing-only sector estimate and channel bound, and the separate record
certificate. No conclusion that those are new follows from this comparison.
