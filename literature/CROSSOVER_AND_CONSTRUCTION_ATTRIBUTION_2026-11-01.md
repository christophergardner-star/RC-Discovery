# Construction attribution and the remaining novelty question

Date: 1 November 2026. This supplements the
[combined-statement comparison](COMBINED_STATEMENT_COMPARISON_2026-10-31.md).
It is an internal literature and implication audit, not external review.

## What can be closed

**Neither polar construction is new.** Eldar and Forney, *On Quantum Detection
and the Square-Root Measurement*, IEEE Transactions on Information Theory
47(3), 858–872 (2001), treat the unweighted and weighted least-squares
measurements directly. Theorem 2 gives the unweighted polar formula; Section V
gives its weighted counterpart. Section VII relates the weights to square
roots of prior probabilities. Sources:
[published author PDF](https://www.weizmann.ac.il/math/yonina/sites/math.yonina/files/quantumDetection_0.pdf),
[arXiv record](https://arxiv.org/abs/quant-ph/0005132),
[v2 formulas, Section 5, equation (35)](https://arxiv.org/html/quant-ph/0005132v2#S5).
The journal PDF and arXiv record establish the historical date; the HTML
conversion contains a misleading generated date and is used only for formulas.

Here is our explicit identification. Choose an eigenbasis inside each full
sector, concatenate its unit columns into \(T=[t_a]\), and write
\(D=\operatorname{diag}(\sqrt{\lambda_a})\), where \(\lambda_a\) are the
selected eigenvalues. Injectivity makes these columns linearly independent.
Substituting their \(\Phi=T\) and weight matrix \(W=D\) gives exactly

\[
U=T(T^*T)^{-1/2},\qquad
\widehat U=TD(DT^*TD)^{-1/2}.
\]

The unweighted construction is their least-squares measurement on the packed
span. The weighted construction is their weighted version, equivalently the
square-root measurement with priors proportional to \(\lambda_a\). Grouping
columns by their original sector gives our \(Q_j\) and \(\widehat Q_j\).
Their result does not itself specify our extension \(RE_jR\) on the residual
space or our distance bounds from the original measurement.

For completeness, the objective identification can also be checked directly,
without a literature-dependent lemma. For \(X^*X=I\) with range in the packed
span and column weights \(d_a>0\),

\[
\sum_a d_a\|t_a-x_a\|^2
=2\operatorname{Tr}D-2\operatorname{Re}\operatorname{Tr}(X^*TD).
\]

If \(TD=\widehat U H_D\), diagonalize \(H_D>0\). Since
\(X^*\widehat U\) is unitary, every real diagonal entry in this basis is at
most one. Consequently the trace is at most \(\operatorname{Tr}H_D\),
attained by \(X=\widehat U\). Taking \(D=I\) gives the unweighted formula.
This verifies the substitution for arbitrary sector ranks after choosing
sector eigenbases; it is not a new orthogonalization principle.

## What the combined result adds to the inspected results

| Claim | Assessment after this audit |
|---|---|
| Unweighted/weighted sector orthogonalization | Explicit prior-art formulas; no construction novelty claim. |
| Dimension-free closeness of some same-label repeatable target | The previous audit reconstructs a short weighted-polar reduction from existing machinery. No broad existence novelty claim. |
| Coefficient-two Jordan-product step | Exact Strang/de Bruijn specialization, as previously identified. |
| Bound for the prescribed unweighted completion, using full sectors and the packing parameter | A concrete quantitative application proved in this repository; publication priority and depth beyond standard results remain unverified. |
| Parameter-controlled correction of supplied record states | A specific corollary under extra assumptions; no new general idempotent-channel structure is asserted. |
| Opposite full-diamond preferences and the explicit four-dimensional path | Exact certificates establish these examples. They show neither completion uniformly dominates the other in this metric. No priority claim is justified by the search. |
| A root in (2.33690021, 2.33690023) | Certified family-specific localization. It is not a universal threshold or evidence of a new physical transition. |

The broad-existence reduction uses the finite polar step in
[de la Salle, Section 3](https://arxiv.org/pdf/2103.14126v2) plus a residual
extension. Its published metric is state-dependent squared error; our
uniform channel conclusion is the reconstructed specialization in the linked
comparison, not a quotation of that theorem. The matrix step is identified
with [de Bruijn, Theorem 3.2 and Sections 4–5](https://pure.tue.nl/ws/portalfiles/portal/2165089/597564.pdf).
The use of dilation estimates is also established machinery; see
[Kretschmann–Schlingemann–Werner](https://arxiv.org/abs/0710.2495).

Least-squares optimization concerns vector error. State discrimination concerns
an ensemble's success probability. Our comparison concerns the worst-case
channel distance from a fixed input POVM, allowing a reference system. These
are different objectives; their distinction alone is not new. The exact
examples settle the two proposed dominance inequalities for our completions,
not optimality among all admissible repeatable targets.

## Search scope and limits

The fresh web search combined these terms, in addition to re-reading the
earlier theorem comparison:

- `POVM orthogonalization polar decomposition diamond norm repeatable measurement perturbation`
- `measurement weighted Lowdin optimal orthogonalization`
- `POVM synthesis repeatable`
- `weighted square-root measurement Eldar Forney least squares`
- `repeatable POVM approximation polar`
- `orthogonalization POVM diamond`
- `POVM polar diamond norm`
- `weighted unweighted square-root measurement optimal`
- `synthesis POVM rounding`
- `orthogonalization measurement channels`
- `repeatable diamond rounding measurement`
- `POVM rounding operator norm`
- `same-label measurement polar`

Search snippets were used to find sources, not to certify theorem implications.
The Eldar–Forney formulas were inspected in the primary text. Broader queries
also returned irrelevant material and approximate-repeatability literature
with different definitions; such hits are not evidence of an exact match.

No matching combined theorem or the specific diamond-distance comparison was
identified in the inspected texts. This statement is about the search performed,
not the whole literature. Neither failed searches nor these certificates can
certify global novelty. The defensible presentation is a quantitative
specialization of established constructions, with explicit bounds, limitations,
and certified comparison examples. Whether that merits an original research
claim remains an external assessment; no external review was requested or
performed in this task.
