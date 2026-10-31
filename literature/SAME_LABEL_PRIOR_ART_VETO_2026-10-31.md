# Prior-art veto: same-label POVM rounding

Search and assessment date: 31 October 2026.

**Historical audit:** this report assesses the earlier coefficient-four and
coarse-composition route. The
[current theorem-level comparison](COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
supersedes its novelty positioning: the matrix lemma is classical, and a
weighted-polar adaptation supplies the broader existential movement result.
The direct accessibility certificate has also repaired the older vacuity
described below.
Local theorem reviewed: commit afab873, especially
[the same-label theorem](../theory/same_label_dimension_free_theorem.md),
[the spectral-gap theorem](../theory/povm_spectral_gap_stability.md), and
[the paper draft](../paper/arxiv_ready.md).

**Verdict: no direct prior theorem or complete implication was located in the sources examined. Novelty remains unverified.** Several ingredients and the target class have stronger precedents than the existing ledger records. There is also a substantive limitation in the proposed composite certificate: inserting either of its current scalar movement envelopes never improves on the trivial channel-distance bound of 2. That finding is proved below; it is not a counterexample to measurement rounding.

## 1. What would count as a veto?

Fix a finite-dimensional POVM \(E=(E_j)_{j=1}^m\), discard zero effects, and assume every remaining effect has a nonzero full spectral projection
\[
P_j=1_{[1-\delta,1]}(E_j),\qquad 0<\delta<1/2.
\]
On \(\mathcal K=\bigoplus_j\operatorname{ran}P_j\), let \(T(x_j)=\sum_jx_j\) be injective, with smallest singular value \(\alpha>0\). Write \(T=UH\), let \(C_j\) denote coordinate projections, and put
\[
Q_j=UC_jU^*,\quad R=I-UU^*,\quad F_j=Q_j+RE_jR.
\]

The target is a theorem, or a short verified consequence of existing theorems, that supplies:

1. the same input space and outcome labels, including a nonzero repeatable sector for each nonzero label;
2. arbitrary sector ranks and preservation of the compressed residual effects \(RE_jR\);
3. one fixed output POVM with a uniform ancilla-assisted bound
   \[
   \|\mathcal M_E-\mathcal M_F\|_\diamond
   \le 4(\sqrt{1-\alpha^2}+\sqrt\delta);
   \]
4. the residual spectral gap \(\gamma_F\ge\delta\).

An existence theorem with the same hypotheses and comparable dimension-independent rates could veto the broad rounding claim even if it used another completion. Conversely, an identical formula without a perturbation bound would veto novelty of the construction but not automatically the quantitative estimate.

The downstream record-channel claim is a separate target: for record margin \(\kappa>0\), idempotence defect \(\eta\), and actual movement \(\nu\),
\[
\|\Phi_E-\Pi\|_\diamond
\le \nu+\sqrt{\frac{2(\eta+3\nu)}{\kappa\delta}},
\qquad \Pi^2=\Pi.
\]
All diamond norms here are full norms, without a factor \(1/2\).

## 2. Closest primary sources and the implication test

The comparisons below are this audit's mathematical assessment of the cited statements. “Not a direct implication” does not mean that an adaptation of their proofs is impossible.

| Source and checked location | What is already established | Missing step to the target |
|---|---|---|
| de la Salle, *Orthogonalization of Positive Operator Valued Measures*, 2022; arXiv v2 Theorems 1.1–1.2, proof in Section 3. [Primary text](https://arxiv.org/pdf/2103.14126) | For a chosen normal state \(\varphi\), almost projectivity gives a PVM with \(\varphi(\sum_j|E_j-Q_j|^2)<9\epsilon\). The proof already uses matrix amplification and a polar partial isometry. | The rounded PVM may depend on the state. The theorem does not state one uniform diamond-norm approximation, nor the prescribed residual completion. Its global almost-projectivity hypothesis need not be small under our assumptions. |
| Ji–Natarajan–Vidick–Wright–Yuen, *Quantum soundness of the classical low individual degree test*, 2020; Theorem 5.2 and Lemma 5.5. [Primary text](https://arxiv.org/pdf/2009.12982) | Orthogonalizes strongly consistent measurements in a distance evaluated on a specified bipartite state; projective submeasurements are allowed. | An entangled test state is not a supremum over all inputs and ancillas. Nonzero-sector preservation and the arbitrary residual block are not the stated conclusion. This is the precise predecessor cited by de la Salle, rather than only the general MIP*=RE citation. |
| Eldar–Forney, *On Quantum Detection and the Square-Root Measurement*, 2001; Theorem 2 and Sections 3–4. [Primary text](https://arxiv.org/pdf/quant-ph/0005132) | The least-squares measurement for independent vectors is the polar construction \(T(T^*T)^{-1/2}\), with orthonormal output vectors. The paper also relates this construction to Naimark realization. | Its input is a state ensemble, and its objective is vector least-squares error. It does not state the spectral-sector/residual-preserving channel estimate. Nevertheless, the rank-one polar measurement construction is directly anticipated. |
| Frank–Paulsen–Tiballi, *Symmetric approximation of frames and bases in Hilbert spaces*, preprint 1998; Theorem 2.3 and the basis discussion. [Primary text](https://arxiv.org/pdf/math/9812052) | Symmetric approximation of frames by normalized tight frames and of bases by orthonormal bases, through polar decomposition, with quadratic-distance criteria. | Neither the POVM threshold constraint nor the channel norm appears in the relevant statement. Choosing orthonormal bases within sectors already reduces much of the arbitrary-rank packing step to familiar frame machinery. |
| Kutyniok–Paternostro–Philipp, *The effect of perturbations of operator-valued frame sequences and fusion frames on their duals*, 2017; Section 4, especially Corollary 4.10 and Theorems 4.12–4.13. [Primary text](https://files.ele-math.com/articles/oam-11-20.pdf) | Operator-norm perturbation estimates for frame analysis operators and their duals, with quantitative lower-frame-bound dependence. | These compare frame sequences and duals; they do not construct the specified repeatable POVM from near-unit spectral sectors. A lower synthesis bound is established frame language, not a new invariant in itself. |
| Busch–Grabowski–Lahti, *Repeatable measurements in quantum theory: Their role and feasibility*, 1995. [Publication DOI](https://doi.org/10.1007/BF02055331) | Foundational repeatability characterization cited by the repo. | The original publisher text could not be retrieved in this search. The relevant finite-dimensional eigenvalue-one characterization is independently supported by the later primary sources below. This audit does not claim a full reading of the 1995 paper. |
| Carmeli–Heinonen–Toigo, *Intrinsic unsharpness and approximate repeatability of quantum measurements*, 2006 preprint; Sections 2–3. [Primary text](https://arxiv.org/pdf/quant-ph/0611286) | Connects actualizability, resolution width, and approximately repeatable instruments; Proposition 1 identifies actualizable effects with eigenvalue one. | Approximate repeatability here concerns probabilities and outcome-resolution neighborhoods, not distance to a nearby same-label POVM in diamond norm. The shared terminology does not establish the desired implication. |
| Buscemi–D'Ariano–Keyl–Perinotti–Werner, *Clean positive operator valued measures*, 2005; Section 9, Lemma 9.1. [Primary text](https://arxiv.org/pdf/quant-ph/0505095) | In its fixed-outcome, \(m\le d\) setting, characterizes clean POVMs through maximum eigenvalue one and orthogonality of unit eigenvectors to other effects. | This is an exact structural classification, not a quantitative approximation theorem. It substantially anticipates the target class. Be explicit about the paper's preprocessing and fixed-outcome conventions. |
| Buscemi–Kobayashi–Minagawa, *A complete and operational resource theory of measurement sharpness*, Quantum 8, 1235 (2024); Definition 1 and Section 2. [Primary text](https://arxiv.org/pdf/2303.07737) | Treats finite POVMs whose effects have eigenvalue one as sharp in its terminology; relates them to repeatable implementations and the bound \(m\le d\). | No quantitative spectral-threshold-to-diamond rounding statement was located. “Repeatability-admissible nonprojective POVMs” must not be presented as a new class. |
| Kretschmann–Schlingemann–Werner, *A Continuity Theorem for Stinespring's Dilation*, 2007 preprint / 2008 publication; equation (3), main theorem and Section 3. [Primary text](https://arxiv.org/pdf/0710.2495) | Dimension-independent equivalence between cb distance and optimized dilation distance. In particular, a common representation gives the easy estimate \(\|T_1-T_2\|_{\rm cb}\le(\|V_1\|+\|V_2\|)\|V_1-V_2\|\). | It compares maps whose dilations are supplied or optimized. It does not select a nearby repeatable target from \((\alpha,\delta)\), or impose the residual formula. It completely accounts for the generic final factor 2. |
| McKenney–Vignati, *Ulam stability for some classes of C*-algebras*, 2016 preprint / 2019 journal; Theorem 1.7. [Primary text](https://arxiv.org/pdf/1601.05445) | Uniform approximation of approximate *-homomorphisms from finite-dimensional C*-algebras by actual *-homomorphisms. | The measurement's Heisenberg map need not be approximately multiplicative on the residual space. The example below blocks a direct global application. Ordinary map-norm conclusions also require a justified upgrade before claiming diamond control. |
| Alekseev–Farah–Thom, *Ulam stability for classes of nuclear C*-algebras*, 2026; introductory results and Theorem A. [Primary text](https://arxiv.org/html/2606.03757v1) | Extends the landscape of approximate *-homomorphism stability, including abelian domains and von Neumann algebra targets. | The same residual multiplicativity obstruction applies to the straightforward application. This recent source was screened at the theorem-statement level, not audited proof by proof. |
| Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*, v2, 2025; Section 1.2 and Section 12. [Primary text](https://arxiv.org/pdf/2405.02434) | Universal approximate-algebra and channel-factorization results. Section 1.2 explicitly distinguishes these from approximation by an exactly idempotent UCP map. | Approximate encoding/decoding inverses do not automatically give an exact idempotent channel on the original space with the prescribed labels and records. No direct derivation of the record-margin certificate was located. |

The [Chenxiao Zenodo preprint](https://zenodo.org/records/22906336), dated 23 September 2026, was verified to exist and to state the simplex obstruction described in the ledger. Its proof was not independently audited here. Treat it as a preprint result, not as a peer-reviewed validation of every obstruction claim in the repo.

## 3. Concrete failed reductions

### State-dependent orthogonalization is not yet uniform rounding

The quantifiers matter:
\[
\forall\rho\ \exists Q^{(\rho)}
\quad\not\Rightarrow\quad
\exists Q\ \forall\rho.
\]
A theorem applied separately to each bipartite state can choose a different measurement each time. Optimizing its state-dependent error therefore does not establish a diamond bound for one fixed output measurement. Applying a normalized-trace estimate instead also needs a norm conversion, which can introduce dimension dependence.

This identifies a missing inference, not a proof that the prior orthogonalization techniques cannot be adapted.

### The residual space prevents a direct global projectivization argument

On \(\mathbb C^3\), take
\[
E_1=\operatorname{diag}(1,0,1/2),\qquad
E_2=\operatorname{diag}(0,1,1/2).
\]
For every \(0<\delta<1/2\), the near-unit sectors are the first two coordinate lines, \(\alpha=1\), and the proposed completion satisfies \(F=E\).
Nevertheless,
\[
\left\|I-\sum_jE_j^2\right\|=1/2.
\]
Thus small threshold and perfect synthesis conditioning do not imply a small global almost-projectivity defect.

Likewise, for \(\phi(a_1,a_2)=a_1E_1+a_2E_2\) and \(a=(1,-1)\),
\[
\|\phi(a^2)-\phi(a)^2\|=1.
\]
So an approximate-*‑homomorphism theorem cannot simply be applied to the full measurement map with a defect tending to zero. Restriction to the packed space may help, but extending it back while controlling residual coherences is precisely a step that must be proved.

### The exact output structure is elementary and already belongs to the known class

For any exact repeatability-admissible finite POVM \(F\), let \(Q_j\) be its full unit eigenspaces. Positivity and \(\sum_jF_j=I\) imply
\[
F_iQ_j=\delta_{ij}Q_j.
\]
Self-adjointness then removes all cross blocks, so with \(R=I-\sum_jQ_j\),
\[
F_j=Q_j+RF_jR.
\]
Consequently, “orthogonal unit sectors plus a residual POVM” is the natural structure of the existing target class. The potentially distinct content is the quantitatively controlled selection from \(E\), including the specific use of \(RE_jR\), not this block form alone.

## 4. Adversarial finding: the scalar composite certificate is vacuous

This is a deduction from the repo's formulas, not a claim taken from the literature.

For at least two records, their definition gives \(0<\kappa\le1\). Define
\[
C_{\eta,\kappa,\delta}(b)
=b+\sqrt{\frac{2(\eta+3b)}{\kappa\delta}}.
\]
This function is increasing for \(b\ge0\). Substituting a valid upper bound \(b\ge\nu\) is legitimate, but can lose all content.

For the advertised envelope
\[
B=4(\sqrt{1-\alpha^2}+\sqrt\delta)\ge4\sqrt\delta,
\]
even the most favorable choices \(\eta=0,\kappa=1\) give
\[
C_{\eta,\kappa,\delta}(B)
\ge\sqrt{\frac{6B}{\delta}}
\ge\sqrt{\frac{24}{\sqrt\delta}}
>2.
\]
This holds throughout \(0<\delta<1/2\).

The more detailed scalar envelope in the draft also fails this test. Put
\[
B_{\rm scalar}=2\sqrt{2\beta+2r_\delta M},
\quad \beta=\|H-I\|,\quad r_\delta=1-\sqrt{1-\delta},\quad M=\|H\|.
\]
Because \(T\) restricts to an isometry on any coordinate sector, \(M\ge1\). Also \(r_\delta\ge\delta/2\), hence
\[
B_{\rm scalar}\ge2\sqrt\delta,\qquad
C_{\eta,\kappa,\delta}(B_{\rm scalar})
\ge\sqrt{\frac{12}{\sqrt\delta}}>2.
\]
Clipping either movement envelope at 2 does not help: if clipping occurs, the first term of \(C\) is already 2.

**These are lower bounds on the numerical upper-bound expressions, not on the actual movement \(\nu\).** They neither refute the rounding estimate nor show that the true distance is large.

The exact, instance-dependent dilation estimate
\[
b_{\rm exact}=2\sqrt{\|2I-HD-DH\|}
\]
can be much smaller and can be zero. A measured/certified movement, a better estimate of the moved idempotence defect, or the actual gap \(\gamma_F\) may also yield a useful certificate. With a chosen bound \(b<2\), the existing threshold-based expression is nontrivial exactly when
\[
\eta+3b<\frac{\kappa\delta}{2}(2-b)^2.
\]

For example, the residual POVM above with records \(|e_1\rangle\langle e_1|\) and \(|e_2\rangle\langle e_2|\) has \(\eta=0,\kappa=1,\nu=0\). Its exact certificate is zero; the coarse substitution is still larger than 2.

The paper should therefore distinguish the useful measurement-rounding theorem from a conditional, instance-dependent exact-idempotent certificate. Dimension independence alone does not make the latter a nontrivial a priori stability result in \((\alpha,\delta,\eta,\kappa)\) using these envelopes.

## 5. Search coverage and limits

Searches covered all six requested families: synthesis-conditioned rounding, same-label Naimark perturbation, uniform measurement-channel bounds, repeatable instruments, frame/fusion-frame perturbation, and Stinespring continuity. Additional searches covered square-root measurements, clean/norm-one POVMs, measurement sharpness, Ulam stability, and almost-idempotent channels.

Representative queries actually used:

- “POVM rounding repeatable measurement perturbation diamond norm spectral projections polar decomposition”
- “POVM synthesis perturbation” and “POVM synthesis operator”
- “Naimark perturbation measurements operator norm” and the Neumark spelling
- “measurement rounding diamond norm”
- “repeatable POVM approximate”; “approximate repeatability diamond norm quantum”
- “fusion frames perturbation orthonormal”
- “symmetric approximation frames polar decomposition Frank Paulsen Tiballi”
- “POVM spectral rounding”; “POVM Gram matrix rounding”
- “POVM spectral gap repeatable”
- “Ulam stability finite dimensional C star algebras approximate homomorphisms McKenney Vignati”
- the exact phrases “synthesis-conditioned” and “same-label” with POVM/Naimark.

The exact-phrase searches produced no relevant external theorem; this is weak evidence because the terminology is local. More weight belongs to the theorem-level comparisons above and the explicit failed reductions. Citation following included de la Salle's actual orthogonalization predecessor and the clean-POVM/sharpness lineage.

This was a web-indexed search with primary-text checks, not an exhaustive MathSciNet, zbMATH, Scopus, or Web of Science citation census. Some publisher endpoints failed; arXiv versions were used where available. No external researcher has reviewed the theorem. Unindexed papers, books, unpublished folklore, and short consequences of existing perturbation arguments remain possible sources of a veto.

## 6. Publication decision

Use the claim: **“We have not located this quantitative same-label residual-preserving rounding statement in the sources examined.”**

Do not claim novelty for polar orthogonalization, arbitrary-rank packing by itself, eigenvalue-one repeatability, the residual block structure, or the generic dilation-to-channel inequality.

The strongest surviving candidate is the explicit threshold/synthesis-conditioned diamond bound for the prescribed completion. Its short derivation from classical tools creates a real risk that experts regard it as an elementary corollary or folklore even if the precise statement is unpublished.

Before substantial Lean work or submission, the next adversarial audit should establish a nontrivial regime for the claimed final certificate and test the rounding theorem at the stated hypothesis boundaries. Any later formalization should identify this narrower operator statement as its target. The present search found no complete prior-art veto, but does not justify promoting “novelty unverified” to “new theorem.”
