# Constructive simulation from algorithmic spectral discrepancy

10 November 2026. Conditional reduction for explicitly supplied rational
POVM matrices. The external hypothesis is a polynomial-time signing algorithm
with discrepancy constant 13. That hypothesis is Theorem 1.1 of
Ezeunala and Jiang, arXiv 2609.17266v2, revised 3 November 2026.
The complete external algorithm and its proof require independent assessment.
This reduction uses that theorem as a black box.
[Source theorem](https://arxiv.org/html/2609.17266v2)

## Published question and input model

Kotowski and Oszmaniec ask for efficient partitions giving constant-success
simulation, and for circuit descriptions of the resulting measurements.
Their partition protocol has success probability

\[
q=\left(\sum_B\left\|\sum_{i\in B}M_i\right\|\right)^{-1}.
\]

The result below addresses explicit rational matrices. Its running time is
polynomial in the dimension, outcome count and matrix bit length. A succinct
circuit description can encode matrices exponentially larger than the circuit.
The circuit-input version therefore remains a separate complexity question.
[Published question and protocol, Theorem 2 and Section III.7](https://arxiv.org/html/2501.09339v1)

## Conditional theorem

Assume a deterministic polynomial-time algorithm takes rational Hermitian
rank-one matrices H_i and returns signs satisfying

\[
\left\|\sum_i s_iH_i\right\|\leq
13\left\|\sum_i H_i^2\right\|^{1/2}.
\tag{A}
\]

For every explicitly supplied rational complex POVM on dimension d at least 2,
there is then a polynomial-time construction of rational branch effects and
mixing probabilities giving exact postselected simulation with

\[
q\geq 1/1157.
\]

Each branch has at most d-1 rank-one success effects and one failure effect.
It admits a projective implementation on dimension at most 2d, using a single
ancillary qubit. The rational branch description is exact. A finite universal
gate description introduces the requested approximation tolerance.

## Proof

### Rational rank-one refinement

Apply pivoted rational Hermitian LDL elimination to each positive effect.
At a positive diagonal pivot a, subtract vv*/a, where v is the pivot column.
The remaining matrix is the positive Schur complement. A zero diagonal in
a positive matrix has a zero row and column. Repeating yields at most d
positive rational rank-one terms per original effect. Label each term by
its original outcome. All matrices remain rational. Standard fraction-free
elimination bounds their bit length polynomially in the input bit length.

Let A_1 through A_N be the nonzero terms, with alpha_i=Tr(A_i)>0.
Their sum is I. Set epsilon=1/(100N). Write

\[
k_i=\lfloor\alpha_i/\epsilon\rfloor,\quad
A_i=k_iC_i+R_i,\quad
C_i=\frac{\epsilon}{\alpha_i}A_i,\quad
R_i=\left(1-\frac{k_i\epsilon}{\alpha_i}\right)A_i.
\]

Keep k_i copies of C_i, omitting a zero remainder. Every full chunk has
trace epsilon. The remainders are positive rank one and satisfy

\[
\sum_i\|R_i\|=\sum_i\operatorname{Tr}R_i<N\epsilon=1/100.
\tag{1}
\]

The full chunks sum to an operator bounded by I, and their count F is at most
d/epsilon=100Nd. Tiny input eigenvalues contribute small remainders instead
of forcing a reciprocal-eigenvalue expansion of the input.

### Recursive partition

For any group with sum S, rank one and trace epsilon give
sum C_i^2=epsilon S. Applying (A) splits the group into children S_+, S_-
with

\[
\|S_\pm\|\leq\tfrac12\|S\|+
\tfrac{13}{2}\sqrt{\epsilon\|S\|}.
\tag{2}
\]

This step uses the unnormalized version (A), so it requires no matrix inverse.
Perform L halvings, where L is the least integer with 2^L epsilon at least 1.
Discard empty groups. At level l, every group satisfies

\[
\sqrt{\|S\|}\leq2^{-l/2}+16\sqrt\epsilon.
\tag{3}
\]

At l=0 this follows from S bounded by I. For the induction, the square of
sqrt(t/2)+13 sqrt(epsilon)/(2 sqrt(2)) exceeds the right side of (2).
The new coefficient of sqrt(epsilon) is at most
(16+13/2)/sqrt(2), which is less than 16 because (45/2)^2<512.
Thus (3) follows. At level L every leaf has norm at most 289 epsilon.
There are fewer than 2/epsilon leaves.

Split each nonempty leaf into groups of at most d-1 chunks. If P is their
number, then

\[
P\leq F/(d-1)+2^L
<\frac{d/(d-1)+2}{\epsilon}\leq4/\epsilon.
\tag{4}
\]

Every new group is a positive subsum of its parent, so its norm remains at
most 289 epsilon. Give each group the rational upper bound u_B=289 epsilon.
Give each nonzero remainder its own group and upper bound u_i=Tr(R_i).
Equations (1) and (4) give

\[
Z=\sum_Bu_B+\sum_i u_i<1156+1/100<1157.
\tag{5}
\]

### Exact protocol and ancillary dimension

Choose branch B with probability u_B/Z. Its success effects are A/u_B for
the refined effects in B, and its failure effect is I-S_B/u_B. These are
positive and sum to I. Their mixture gives every refined effect A/Z and
failure effect (1-1/Z)I. The operator inequality I=sum S_B bounded by ZI
also proves Z at least 1. Consequently q=1/Z is a probability and exceeds
1/1157. Restoring original outcome labels gives exactly the original POVM
conditioned on success.

A branch with k at most d-1 rank-one success effects has total effect rank
at most k+d, hence at most 2d-1. Stack rank-one square-root rows for its
success effects and the positive square root of its failure effect. This
forms an isometry with at most 2d-1 rows. Pad it to 2d rows and complete its
columns to a unitary. Measuring the corresponding orthogonal blocks gives
the branch POVM on a system extended by one qubit.

There are O(Nd) chunks and O(Nd) possible tree nodes. Each signing call uses
the same rational chunk matrices. Their bit lengths do not grow with tree
depth. The subsequent splitting and rational mixture operations take
polynomial time. For the rational LDL refinement, N is at most the original
outcome count times d. These bounds prove polynomial complexity in the
explicit-matrix input model, conditional on (A).

## Verification boundary and attribution

The accompanying exact-rational audit checks refinement, tiny remainders,
normalization, branch positivity and recovery of every original effect in
selected examples. It also rejects a corrupted bound and a corrupted mixing
probability. It supplies no implementation or independent verification of
the external polynomial-time signing algorithm. This conditional reduction
has a written operator proof and has not been formalised in Lean.

The substantive algorithmic ingredient (A) belongs to the cited authors.
Related September 2026 work also supplies polynomial-time discrepancy
algorithms and explicitly derives multi-way partitions. The reduction here
is a consequence of those developments. Priority for the measurement
application remains unassessed.
[Ezeunala and Jiang](https://arxiv.org/html/2609.17266v2),
[Song and Yue](https://arxiv.org/html/2609.19794v1),
[Jadbabaie, Saberi and Sra, Proposition 5.2](https://arxiv.org/html/2609.23855v1)

The RC extremal theorem does not enter this reduction. Its near-unit-sector
hypotheses require an additional bridge for the general inputs considered
here. In particular the effects (1/2)|j><j|, repeated twice for every basis
vector, form a POVM whose selected sectors are all empty above 1/2.

The broader task of obtaining an original RC-based solution to a recognised
open problem remains unresolved. The matrix-input reduction and the succinct
circuit-input question must be assessed separately.
