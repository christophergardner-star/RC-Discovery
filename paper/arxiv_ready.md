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
4\left(\sqrt{1-\alpha^2}+\sqrt\delta\right),
\]

with no explicit dependence on the number of outcomes, Hilbert-space dimension or total packed rank. Combined with the RC spectral-gap Record-Margin theorem, this yields an exactly idempotent measure-and-prepare channel \(\Pi\) satisfying

\[
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{\frac{2(\eta+3\nu)}{\kappa\delta}},
\]

where \(\nu=\|\Phi_E-\widetilde\Phi_F\|_\diamond\), \(\eta=\|\Phi_E^2-\Phi_E\|_\diamond\), and \(\kappa\) is the record margin. The result remains a theorem candidate pending external specialist audit and a complete novelty review.

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

## 6. Record-process certificate

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

Machine checked in Lean only at the scalar algebraic core:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`.

Novelty and external correctness remain open review gates.

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
