# Synthesis-Conditioned Same-Label Rounding of Approximate Quantum Measurements

**Author:** Christopher Gardner  
**Affiliation:** Independent / RC-Discovery programme  
**Date:** 31 October 2026  
**Status:** external-review draft; not peer-reviewed; novelty unverified; not yet submission-ready  
**Research workflow:** VIBE MATH — AI-assisted conjecture, adversarial testing, proof reconstruction, prior-art review and formalisation support

## Abstract

We study a record-structured class of finite positive-operator-valued measurements (POVMs) with near-unit spectral sectors. Let \(P_j\) be the full spectral projection of \(E_j\) onto eigenvalues at least \(1-\delta\), and let

\[
T:\bigoplus_j\operatorname{ran}(P_j)\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j
\]

be the sector synthesis operator. Under the packing condition \(\alpha=\sigma_{\min}(T)>0\), the polar isometry of \(T\) produces pairwise orthogonal sectors \(Q_j\). We consider the same-label completion

\[
F_j=Q_j+R E_jR,
\qquad
R=I-\sum_jQ_j.
\]

For every nonzero outcome we assume a nonzero near-unit sector at the chosen threshold. The completion is repeatability-admissible and has repeatability spectral gap \(\gamma_F\ge\delta\).

Using the labelled direct-sum inclusion

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)
\]

and the hybrid Naimark/Stinespring isometry

\[
V=J_{\mathcal K}U^*+WR,
\]

we obtain the internally reconstructed bound

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\left(\sqrt{1-\alpha^2}+\sqrt\delta\right),
\]

with no explicit dependence on the number of outcomes, Hilbert-space dimension or total packed rank. Direct record accessibility and projection yield an exactly idempotent measure-and-prepare channel \(\Pi\) satisfying

\[
\|\Phi_E-\Pi\|_\diamond
\le
b+2\sqrt{1-\alpha^2}+
\sqrt{\frac{2\eta}{\kappa\delta(1-2\delta)}},
\]

where \(b\) is any valid upper bound on the measurement-channel movement,
\(\eta=\|\Phi_E^2-\Phi_E\|_\diamond\), and \(\kappa\) is the record margin.
Both distance bounds can be capped at 2. The result remains a theorem candidate
pending external specialist audit and a complete novelty review.

## 1. Motivation

Local diagnostics do not guarantee proximity to a repeatable measurement. Regular-simplex families show that idempotence defect, record separation, near-unit effects and record reachability may all look favourable while the candidate repeatable sectors cannot be packed simultaneously.

The synthesis lower bound \(\alpha=\sigma_{\min}(T)\) is used here as a global conditioning parameter. The polar/fusion-frame machinery itself is standard; the question is whether it can be combined with a same-label residual completion and a channel-level operational bound.

## 2. Setting and packing geometry

Let \(\{E_j\}_{j=1}^m\) be a POVM on a finite-dimensional Hilbert space \(\mathcal H\), and fix \(0<\delta<1/2\). For every nonzero \(E_j\), let \(P_j\neq0\) be the full spectral projection onto eigenvalues in \([1-\delta,1]\).

Define

\[
\mathcal S_j=\operatorname{ran}(P_j),
\qquad
\mathcal K=\bigoplus_j\mathcal S_j,
\]

and

\[
T:\mathcal K\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j.
\]

Assume \(\alpha=\sigma_{\min}(T)>0\), and write

\[
T=UH,
\qquad H=|T|.
\]

Let \(R_j^{\mathcal K}\) be the coordinate projector onto \(\mathcal S_j\), and set

\[
Q_j=UR_j^{\mathcal K}U^*.
\]

The \(Q_j\) are pairwise orthogonal, preserve the sector ranks and satisfy the principal-angle bound

\[
\|P_j-Q_j\|_\infty
\le
\sqrt{1-\alpha^2}.
\]

This step uses established polar/Löwdin and frame/fusion-frame geometry and is not claimed as new.

## 3. Same-label completion and spectral gap

Put

\[
S=UU^*=\sum_jQ_j,
\qquad
R=I-S.
\]

Since \(\operatorname{ran}(U)=\operatorname{ran}(T)=\sum_j\mathcal S_j\),

\[
P_jR=RP_j=0.
\]

Define

\[
F_j=Q_j+R E_jR.
\]

Then

\[
\sum_jF_j=S+R\left(\sum_jE_j\right)R=I,
\]

and

\[
F_iQ_j=\delta_{ij}Q_j.
\]

Thus the completion retains the original labels and gives each nonzero outcome an exact eigenvalue-1 sector.

Because \(P_j\) is the full threshold projection,

\[
E_j\le P_j+(1-\delta)(I-P_j).
\]

Compression by \(R\) gives

\[
R E_jR\le(1-\delta)R,
\]

so

\[
\gamma_F\ge\delta.
\]

## 4. The typed labelled embedding

A notation issue discovered during the source re-merge must be stated explicitly.

Let

\[
\mathcal Y=\bigoplus_{j=1}^m\mathcal H
\]

and define the canonical measurement isometry

\[
Wz=(\sqrt{E_1}z,\ldots,\sqrt{E_m}z).
\]

The labelled map used in the theorem is

\[
J_{\mathcal K}:\mathcal K\to\mathcal Y,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

It embeds the original sector vector in its outcome block. In a rank-one sector, the coordinate vector representing \(v_j\in\mathcal S_j\) is sent to \(v_j\), not to its polar-rounded image \(q_j\).

An alternative source note defined a different map by embedding \(q_j\) in block \(j\) and correctly found a different overlap matrix. That calculation does not refute the theorem with \(J_{\mathcal K}\); it reveals that the two maps must not share one symbol without a type declaration.

Define

\[
D=\bigoplus_j\left.\sqrt{E_j}\right|_{\mathcal S_j}.
\]

Then

\[
J_{\mathcal K}^*WU=DH.
\]

Indeed, the \(j\)-th component is

\[
P_j\sqrt{E_j}Ux
=
\sqrt{E_j}P_jUx,
\]

while the \(j\)-th component of \(T^*Ux=Hx\) is \(P_jUx\).

## 5. Hybrid dilation and operational distance

Because \(P_jR=0\) and \(P_j\) commutes with \(\sqrt{E_j}\),

\[
J_{\mathcal K}^*WR=0.
\]

Define

\[
V=J_{\mathcal K}U^*+WR.
\]

Then

\[
V^*V=I
\]

and, for the label projector \(\Lambda_j\subset\mathcal Y\),

\[
V^*\Lambda_jV=Q_j+R E_jR=F_j.
\]

Thus \(V\) is an exact dilation of the same-label completion.

Both \(WU\) and \(J_{\mathcal K}\) are isometries, and

\[
(WU-J_{\mathcal K})^*(WU-J_{\mathcal K})
=
2I-HD-DH.
\]

Let

\[
\varepsilon=\|WU-J_{\mathcal K}\|_\infty,
\quad
\beta=\|H-I\|_\infty,
\quad
r_\delta=1-\sqrt{1-\delta},
\quad
M=\|H\|_\infty.
\]

Then

\[
\varepsilon^2
\le
2\beta+2r_\delta M.
\]

The POVM condition gives

\[
M\le(1-\delta)^{-1/2},
\]

and

\[
\beta\le
\max\left\{
1-\alpha,
(1-\delta)^{-1/2}-1
\right\}.
\]

Also,

\[
\|V-W\|_\infty=\varepsilon.
\]

By standard Stinespring continuity and common label-reading post-processing,

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\varepsilon.
\]

For \(0<\delta<1/2\), a conservative simplification is

\[
\boxed{
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
4\left(\sqrt{1-\alpha^2}+\sqrt\delta\right).
}
\]

The constant is not claimed optimal.

### 5a. Refinement to coefficient 2

Let \(d=\sqrt{1-\delta}\), \(r=1-d\). For
\(X=H-\alpha I\), \(Y=D-dI\), and \(h=M-\alpha\), positivity of
\((\sqrt t X+t^{-1/2}Y)^2\) implies
\(XY+YX\ge-thX-(r/t)Y\). Choosing \(t=2d/h\) when \(h>0\) shows
\(\operatorname{Re}(HD)\ge\alpha dI\) whenever \(hr\le4\alpha d\);
the case \(h=0\) is immediate. The exact overlap
\(W^*V=UHD U^*+R\) then bounds the pure-state output trace distance, including
arbitrary ancillas, by \(2\sqrt{1-\alpha^2(1-\delta)}\).

When \(\sqrt{1-\alpha^2}+\sqrt\delta<1\), one has
\(\alpha>\sqrt\delta\) and \(hr\le Mr\le\delta<4\alpha d\), so the
condition holds. Elsewhere the trivial distance bound 2 suffices. Thus
\(\nu_{\rm meas}\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}\).
The complete argument and checks are in
[the coefficient-two audit](../theory/BOUND_CANDIDATE_2026-10-31.md).

## 6. Record-process certificate

### 6a. Earlier transfer route

**Certificate limitation:** substituting either scalar movement envelope into the bound below with denominator \(\kappa\delta\) always exceeds 2. Only actual or sufficiently sharp instance-dependent movement can make that version nontrivial. See [the focused prior-art and certificate audit, Section 4](../literature/SAME_LABEL_PRIOR_ART_VETO_2026-10-31.md). Dimension independence alone does not establish a useful exact-idempotent stability guarantee.

Let

\[
\Phi_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

have record margin \(\kappa>0\) and idempotence defect \(\eta\). Let \(\widetilde\Phi_F\) use \(F_j\) with the same records. Record preparation is common CPTP post-processing, so

\[
\nu:=\|\Phi_E-\widetilde\Phi_F\|_\diamond
\le
\|\mathcal M_E-\mathcal M_F\|_\diamond.
\]

Moreover,

\[
\|\widetilde\Phi_F^2-\widetilde\Phi_F\|_\diamond
\le
\eta+3\nu.
\]

The RC spectral-gap theorem then gives an exactly idempotent channel \(\Pi\) satisfying

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{\frac{2(\eta+3\nu)}{\kappa\delta}}.
}
\]

### 6b. Direct accessibility route

Set \(D_{\rm rec}=\max_j\|\Phi_E(\sigma_j)-\sigma_j\|_1\) and
\(e=\max_j(1-\lambda_{\max}(E_j))\le\delta\). A label attaining the
maximum residual can be produced with probability at least \(1-e\).
Reverse triangle on the corresponding channel defect gives
\((1-2e)D_{\rm rec}\le\eta\); conversely, the measure-and-prepare
decomposition gives \(\eta\le D_{\rm rec}\), including ancillas.

Record margin and the full spectral threshold then give
\(1-\operatorname{Tr}(P_j\sigma_j)\le
\eta/[2\kappa\delta(1-2e)]\). Projecting a purification into \(Q_j\)
constructs a record \(\tau_j\) supported there with trace distance at most
\(2\sqrt{1-\alpha^2}+\sqrt{2\eta/[\kappa\delta(1-2e)]}\).
If the projection has zero weight, that upper estimate is already at least 2,
and any state in the nonzero sector works. The channel with effects \(F_j\)
and records \(\tau_j\) is exactly idempotent.

Adding measurement movement \(b\) and using \(e\le\delta\) proves the
abstract's certificate. This avoids the earlier route's movement term inside
the gap denominator. [The accessibility audit](../research/CERTIFICATE_PROGRESS_2026-10-31.md)
contains the full proof, a sharp accessibility example and nontrivial certificate
examples. When \(S\) reduces every effect, an additional high/low decomposition
gives \(\nu_{\rm meas}\le\min\{2,4(1-\alpha)+5\delta\}\), with details in
[the residual-coupling note](../theory/RESIDUAL_COUPLING_RATES_2026-10-31.md).

## 7. Negative results and limitations

The derivation is constrained by several counterexamples:

- local diagnostics without packing do not suffice;
- \(m>d\) prevents same-label exact unit sectors;
- generic threshold-only movement may require order \(\sqrt\delta\);
- dumping the residual space into an additional projective outcome can move the measurement channel by distance \(2\);
- system-only pure-state sampling is numerical evidence, not a complete diamond-norm computation.

The full operator/channel theorem has not been machine formalised. External specialist verification is still required.

## 8. Prior-art boundary

The following are established ingredients and are not claimed as contributions of this note:

- polar and Löwdin orthogonalisation, Fan–Hoffman and Higham best-approximation results;
- synthesis operators, Riesz bases and fusion-frame geometry;
- Naimark and Stinespring dilation;
- Kretschmann–Schlingemann–Werner continuity;
- Busch–Grabowski–Lahti repeatability criteria;
- de la Salle and earlier POVM orthogonalisation/projectivisation;
- Oszmaniec and collaborators' projective-simulation results, including Kotowski–Oszmaniec's dimension-deficient Naimark theorem;
- Watrous diamond-norm/SDP theory;
- Kitaev's approximate-algebraic treatment of almost-idempotent channels;
- known regular-simplex negative examples.

The only object being investigated as potentially distinct is the complete, correctly typed combination presented here. No exact prior theorem matching that full chain was located in the searches performed. That is not a novelty certificate.

Canonical attribution policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`

## 9. Verification status

Internally reconstructed:

- the sharp Record-Margin theorem;
- the POVM spectral-gap theorem;
- the typed overlap identity;
- the hybrid isometry;
- exact implementation of the same-label completion;
- the dimension-free estimate;
- \(\gamma_F\ge\delta\).

Machine checked in Lean at the scalar algebraic core:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`.

The laptop validation additionally machine-checked four rectangular complex-matrix lemmas (`spectral_cross_zero`, `hybrid_cross_zero`, `hybrid_isometry`, `hybrid_compression`) under explicit algebraic hypotheses. The spectral construction and channel-norm estimate remain unformalized. All nine original mathematical tests, 408 additional adversarial cases and 12 ancilla-assisted channel-distance SDPs passed. See [the validation report](../research/LOCAL_VALIDATION_2026-10-31.md) for assumptions, numerical tolerances and the separate blocked neural smoke test.

Novelty and external correctness remain open review gates.

Five additional Lean lemmas now prove residual projection properties and
compression of a supplied spectral envelope, and assemble the hybrid isometry
from its overlap factorization. The latest numerical run adds 46 paired
primal/dual SDP problems (including two anchors) and the rate/constant checks
in [the progress report](../research/VERIFIED_PROGRESS_2026-10-31.md). The new
analytic coefficient and accessibility bounds are not Lean-formalized.

## 10. Conclusion

The internal theorem candidate gives a synthesis-conditioned, same-label route from approximate measurement to a repeatability-admissible POVM and then to an exactly idempotent record process, with no explicit dimension or outcome-count factor. The important contribution, if external review confirms it, is not any individual classical ingredient but their precisely typed combination.

## VIBE MATH methodology and attribution

The result was developed through the VIBE MATH workflow: rapid human–AI conjecture generation followed by counterexample search, numerical testing, independent reconstruction and prior-art review. AI assistance is methodological support, not evidence of correctness.

Research direction and authorship: Christopher Gardner.

## References

1. K. Fan and A. J. Hoffman, *Some Metric Inequalities in the Space of Matrices*, Proc. AMS 6 (1955), 111–116. DOI: `10.1090/S0002-9939-1955-0067841-7`.
2. P.-O. Löwdin, *On the Non-Orthogonality Problem Connected with the Use of Atomic Wave Functions in the Theory of Molecules and Crystals*, J. Chem. Phys. 18 (1950), 365–375. DOI: `10.1063/1.1747632`.
3. N. J. Higham, *Computing the Polar Decomposition—with Applications*, SIAM J. Sci. Stat. Comput. 7 (1986), 1160–1174. DOI: `10.1137/0907079`.
4. P. Busch, M. Grabowski and P. J. Lahti, *Repeatable Measurements in Quantum Theory: Their Role and Feasibility*, Foundations of Physics 25 (1995), 1239–1266. DOI: `10.1007/BF02055331`.
5. D. Kretschmann, D. Schlingemann and R. F. Werner, *The Information-Disturbance Tradeoff and the Continuity of Stinespring's Representation*, IEEE Trans. Inf. Theory 54 (2008), 1708–1717. DOI: `10.1109/TIT.2008.917696`.
6. D. Kretschmann, D. Schlingemann and R. F. Werner, *A Continuity Theorem for Stinespring's Dilation*, J. Funct. Anal. 255 (2008), 1889–1904. DOI: `10.1016/j.jfa.2008.07.023`.
7. M. de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), 549–560. DOI: `10.5802/crmath.326`; arXiv:2103.14126.
8. M. Kotowski and M. Oszmaniec, *Pretty Good Simulation of All Quantum Measurements by Projective Measurements*, IEEE Trans. Inf. Theory 72 (2026), 3156–3174. DOI: `10.1109/TIT.2026.3678498`; arXiv:2501.09339.
9. A. Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*, arXiv:2405.02434.
10. J. Watrous, *Semidefinite Programs for Completely Bounded Norms*, Theory of Computing 5 (2009), 217–238. DOI: `10.4086/toc.2009.v005a011`.
