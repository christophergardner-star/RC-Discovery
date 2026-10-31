# VIBE MATH: Packing-Conditioned Rounding of Approximate Quantum Measurements

## Doctoral-Style Research Monograph and External-Audit Document

**Author and research direction:** Christopher Gardner  
**Programme:** VIBE MATH / RC-Discovery  
**Date:** 31 October 2026  
**Status:** Doctoral-style research document; internally reconstructed theorem candidates; not peer reviewed; novelty unverified

---

## Declaration of scope

This document is written at doctoral-research level, but it is not represented as an awarded PhD thesis, an examined dissertation, or an externally certified theorem. It consolidates the programme into one coherent, technically explicit object suitable for hostile expert review.

The work was developed through the VIBE MATH workflow: rapid human–AI conjecture and derivation, followed by counterexample search, numerical stress testing, independent proof reconstruction, literature review, and selective Lean formalisation. AI agreement is not treated as evidence. The repository distinguishes established prior mathematics, internally derived lemmas, theorem candidates, numerical evidence, machine-checked statements, refuted conjectures, and novelty claims.

The central combined result is presently described only as:

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

---

# Abstract

We study when an approximate finite quantum measurement can be rounded to a same-label, repeatability-admissible measurement without introducing an explicit dependence on Hilbert-space dimension or outcome count.

Let \(\{E_j\}_{j=1}^m\) be a POVM on a finite-dimensional Hilbert space \(\mathcal H\). For \(0<\delta<1/2\), let \(P_j\neq0\) be the full spectral projection of every nonzero effect \(E_j\) onto eigenvalues at least \(1-\delta\). Define

\[
\mathcal K=\bigoplus_j\operatorname{ran}(P_j),
\qquad
T:\mathcal K\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j.
\]

The global packing parameter is

\[
\alpha=\sigma_{\min}(T)>0.
\]

Writing \(T=U|T|\), the polar isometry produces mutually orthogonal sectors \(Q_j\). With

\[
R=I-\sum_jQ_j,
\]

define the same-label completion

\[
F_j=Q_j+R E_jR.
\]

This family is a POVM, every nonzero effect has an exact eigenvalue-1 sector, and the repeatability spectral gap satisfies

\[
\gamma_F\ge\delta.
\]

Using the correctly typed labelled inclusion

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)
\]

and the canonical measurement isometry \(Wz=(\sqrt{E_j}z)_j\), the hybrid isometry

\[
V=J_{\mathcal K}U^*+WR
\]

implements the completion exactly. The current analytic refinement gives

\[
\boxed{
\nu_{\rm meas}
=
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\!\left\{
1,\sqrt{1-\alpha^2}+\sqrt\delta
\right\}.
}
\]

For a measure-and-prepare channel

\[
\Phi(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

with record margin \(\kappa>0\), idempotence defect \(\eta=\|\Phi^2-\Phi\|_\diamond\), and label inaccessibility \(e<1/2\), a direct record-accessibility argument constructs an exactly idempotent channel \(\Pi\) obeying

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
B_{\rm move}
+
2\sqrt{1-\alpha^2}
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2e)}
}
\right\},
}
\]

for any valid measurement-movement bound \(B_{\rm move}\). Since \(e\le\delta\), the coefficient-two movement theorem yields

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
4\sqrt{1-\alpha^2}
+
2\sqrt\delta
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2\delta)}
}
\right\}.
}
\]

The project includes exact counterexamples to stronger false statements, adversarial numerical tests, paired primal/dual SDP checks, machine-checked scalar and operator lemmas, and an explicit prior-art boundary.

---

# 1. Research problem

A finite POVM is a family of positive operators satisfying

\[
E_j\ge0,
\qquad
\sum_jE_j=I.
\]

Exact repeatability for a nonzero discrete outcome requires an eigenvalue-1 sector. The question addressed here is not that classical criterion, but a quantitative stability problem:

> Under which checkable geometric and dynamical conditions is an approximate measurement close to a measurement supporting exact repeatable records?

A useful theorem should be operational, constructive, and free of an explicit linear dependence on \(m\) or \(d=\dim\mathcal H\).

The target chain is

\[
\text{near-unit sectors}
\to
\text{global packing}
\to
\text{same-label completion}
\to
\text{dimension-free channel movement}
\to
\text{exact idempotent records}.
\]

---

# 2. Established background and claim boundary

The programme relies on established mathematics, none of which is claimed as new:

- polar decomposition and nearest-isometry properties;
- Löwdin orthogonalisation;
- synthesis operators and fusion-frame/Riesz conditioning;
- Naimark and Stinespring dilation;
- Stinespring continuity and diamond-norm contractivity;
- repeatability criteria for discrete POVMs;
- quantitative POVM orthogonalisation and projectivisation;
- projective simulation of POVMs;
- diamond-norm SDP theory;
- approximate structure of almost-idempotent channels;
- known regular-simplex obstructions.

The only object being investigated as potentially distinct is the complete, correctly typed combination of packing geometry, same-label completion, operational movement, record accessibility, and exact-idempotent rounding.

No exact prior theorem matching that entire chain was located in the searches performed. This is not proof of novelty.

---

# 3. Why local diagnostics are insufficient

Several stronger conjectures were refuted during the project.

## 3.1 Idempotence alone

A completely unsharp measurement can define a constant, exactly idempotent channel while possessing no repeatable measurement sectors. Thus small or zero \(\eta\) does not determine measurement geometry.

## 3.2 Capacity obstruction

Exact eigenvalue-1 sectors for different labels are mutually orthogonal. Hence a \(d\)-dimensional space supports at most \(d\) nonzero same-label repeatable outcomes. In particular,

\[
m>d
\]

is an immediate obstruction.

## 3.3 Regular simplex

Regular-simplex families can have near-unit effects, good record separation, small reachability error, and small idempotence defect while remaining globally unpackable. The synthesis operator becomes singular at the obstruction.

## 3.4 Linear threshold movement

A near-unit spectral threshold does not imply whole-effect closeness to a projector. An explicit perfectly packed family requires movement of order \(\sqrt\delta\), ruling out a generic \(O(\delta)\) theorem under threshold-only assumptions.

## 3.5 Extra-outcome shortcut

Routing the residual subspace to a new projective outcome can change the measurement channel by the maximal diamond distance \(2\), even when protected sectors are perfectly packed.

## 3.6 Numerical proxies

Pure-state total-variation maximisation is useful evidence but is not automatically equal to the diamond norm. Ancilla-assisted discrimination must be handled analytically or by a complete SDP.

---

# 4. Global packing geometry

Fix \(0<\delta<1/2\). Let \(P_j\) be the full spectral projection of \(E_j\) onto eigenvalues in \([1-\delta,1]\), and assume \(P_j\neq0\) for every nonzero label.

Define

\[
\mathcal S_j=\operatorname{ran}(P_j),
\qquad
\mathcal K=\bigoplus_j\mathcal S_j,
\]

and the synthesis operator

\[
T(x_1,\ldots,x_m)=\sum_jx_j.
\]

The lower synthesis singular value

\[
\alpha=\sigma_{\min}(T)
\]

is the packing conditioner. If \(\alpha=0\), the sectors are linearly dependent. If \(\alpha>0\), the total sector rank is at most \(d\), and the polar factor is an isometry on \(\mathcal K\).

The POVM constraint also gives an upper singular-value bound. Since

\[
E_j\ge(1-\delta)P_j,
\]

we have

\[
I=\sum_jE_j
\ge
(1-\delta)\sum_jP_j
=(1-\delta)TT^*,
\]

so

\[
\|T\|\le(1-\delta)^{-1/2}.
\]

---

# 5. Polar sectors and principal-angle control

Let

\[
T=UH,
\qquad
H=|T|.
\]

Let \(R_j^{\mathcal K}\) denote the coordinate projector onto the \(j\)-th summand and set

\[
Q_j=UR_j^{\mathcal K}U^*.
\]

The \(Q_j\) are pairwise orthogonal and preserve the original sector ranks.

For a unit coordinate vector \(e\in\mathcal S_j\),

\[
\langle Te,Ue\rangle
=
\langle He,e\rangle
\ge\alpha.
\]

Principal-angle geometry therefore yields

\[
\boxed{
\|P_j-Q_j\|_\infty
\le
\sqrt{1-\alpha^2}.
}
\]

This is a geometric ingredient, not an independent novelty claim.

---

# 6. Same-label repeatable completion

Define

\[
S=\sum_jQ_j=UU^*,
\qquad
R=I-S.
\]

The polar factor changes the decomposition inside the total sector span but preserves that total span:

\[
\operatorname{ran}U
=
\operatorname{ran}T
=
\sum_j\operatorname{ran}P_j.
\]

Consequently,

\[
P_jR=RP_j=0.
\]

Define

\[
\boxed{
F_j=Q_j+R E_jR.
}
\]

Then

\[
\sum_jF_j
=
S+R\left(\sum_jE_j\right)R
=S+R=I,
\]

and

\[
F_iQ_j=\delta_{ij}Q_j.
\]

Thus the completion retains the original outcome alphabet and has exact repeatable sectors.

Because \(P_j\) is the full threshold projector,

\[
E_j
\le
P_j+(1-\delta)(I-P_j).
\]

Compression to the residual subspace gives

\[
R E_jR\le(1-\delta)R,
\]

so

\[
\boxed{
\gamma_F\ge\delta.
}
\]

---

# 7. Correctly typed hybrid dilation

Let

\[
\mathcal Y=\bigoplus_{j=1}^m\mathcal H
\]

and define the canonical measurement isometry

\[
W:\mathcal H\to\mathcal Y,
\qquad
(Wz)_j=\sqrt{E_j}\,z.
\]

The critical labelled map is the direct-sum inclusion

\[
J_{\mathcal K}:\mathcal K\to\mathcal Y,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

In a rank-one sector this embeds the original sector vector, not the polar-rounded vector. This distinction resolves an apparent contradiction in exploratory source notes.

Since \(P_jR=0\) and \(P_j\) commutes with \(\sqrt{E_j}\),

\[
P_j\sqrt{E_j}R=0
\]

and hence

\[
J_{\mathcal K}^*WR=0.
\]

Define

\[
\boxed{
V=J_{\mathcal K}U^*+WR.
}
\]

The two summands have orthogonal initial and final spaces, so

\[
V^*V=I.
\]

If \(\Lambda_j\) is the projector onto output block \(j\), then

\[
\boxed{
V^*\Lambda_jV
=
Q_j+R E_jR
=
F_j.
}
\]

Thus the hybrid map is an exact dilation of the same-label completion.

---

# 8. Dimension-free measurement movement

Define

\[
D=
\bigoplus_j
\left.\sqrt{E_j}\right|_{\mathcal S_j}.
\]

Then

\[
\sqrt{1-\delta}\,I\le D\le I
\]

and the typed overlap identity is

\[
J_{\mathcal K}^*WU=DH.
\]

A noncommuting positive-matrix estimate controls the Hermitian part of this overlap. The current unconditional result is

\[
\boxed{
\nu_{\rm meas}
\le
2\min\!\left\{
1,\sqrt{1-\alpha^2}+\sqrt\delta
\right\}.
}
\]

The same bound holds after common record-state preparation.

A stronger sufficient-condition estimate is available. Put

\[
d=\sqrt{1-\delta},
\qquad
r=1-d,
\qquad
M=\|H\|.
\]

If

\[
(M-\alpha)r\le4\alpha d,
\]

then

\[
\nu_{\rm meas}
\le
2\sqrt{1-\alpha^2(1-\delta)}.
\]

The coefficient \(2\) is not claimed optimal.

---

# 9. Record accessibility and exact-idempotent rounding

The earlier transfer route placed movement error inside a term divided by \(\delta\), which could make the composed bound vacuous. The repaired route acts directly on the original records.

Define

\[
v_j=\Phi(\sigma_j)-\sigma_j,
\qquad
D_{\rm rec}=\max_j\|v_j\|_1.
\]

Suppose each label can be produced with probability at least \(1-e\), with \(e<1/2\). Then

\[
\boxed{
(1-2e)D_{\rm rec}\le\eta\le D_{\rm rec}.
}
\]

The lower coefficient is sharp for a binary diagonal family.

Let

\[
a_j=\operatorname{Tr}(E_j\sigma_j).
\]

The convex-hull record margin implies

\[
2\kappa(1-a_j)
\le
\|v_j\|_1
\le
\frac{\eta}{1-2e}.
\]

Writing \(w_j=\operatorname{Tr}(P_j\sigma_j)\), threshold fullness gives

\[
1-w_j
\le
q,
\qquad
q=
\frac{\eta}
{2\kappa\delta(1-2e)}.
\]

Projection into the rounded sector \(Q_j\) produces a state \(\tau_j\) satisfying

\[
\|\sigma_j-\tau_j\|_1
\le
2\sqrt q+2\sqrt{1-\alpha^2}.
\]

Define

\[
\Pi(\rho)
=
\sum_j\operatorname{Tr}(F_j\rho)\tau_j.
\]

Since \(\operatorname{Tr}(F_i\tau_j)=\delta_{ij}\),

\[
\Pi^2=\Pi.
\]

For any valid movement bound \(B_{\rm move}\),

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
B_{\rm move}
+
2\sqrt{1-\alpha^2}
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2e)}
}
\right\}.
}
\]

With \(e\le\delta\) and the coefficient-two movement theorem,

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\min\!\left\{
2,\,
4\sqrt{1-\alpha^2}
+
2\sqrt\delta
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2\delta)}
}
\right\}.
}
\]

This expression tends to zero along compatible families with \(\alpha\to1\), \(\delta\to0\), and \(\eta/(\kappa\delta)\to0\).

---

# 10. Computational verification

The repository includes:

- 10,000 random Record-Margin cases and equality families;
- simplex and capacity obstructions;
- rank-one and higher-rank packing tests;
- spectral-threshold lower-bound families;
- exact hybrid-isometry and POVM-implementation checks;
- many-outcome and high-rank adversarial tests;
- paired primal/dual channel-distance SDPs;
- normalization anchors and retained solver diagnostics;
- deterministic negative controls preventing accidental removal of hypotheses.

Computations support the derivations but do not replace proof. Numerical tolerances are not interval-certified upper bounds.

A reproducible run should retain the exact commit, environment lock, script hashes, seeds, command-line arguments, logs, solver status, primal-dual gap, and feasibility residuals.

---

# 11. Formal verification status

Lean 4 + Mathlib currently checks, with zero `sorry`:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`;
- selected rectangular-matrix hybrid identities;
- label-compression identities;
- residual projection and spectral-envelope compression lemmas.

Not yet formalised end to end:

- construction of the spectral-sector objects from POVM hypotheses;
- full Hilbert-space polar geometry;
- the final noncommuting overlap estimate;
- the complete diamond-norm transfer;
- record accessibility and projected-record construction as one theorem;
- the final composite certificate.

A successful Lean build therefore certifies the formalised lemmas, not the entire research claim.

---

# 12. Prior art and attribution

The repository explicitly credits established sources for polar decomposition, frame and fusion-frame synthesis, Naimark/Stinespring dilation, Stinespring continuity, POVM repeatability, POVM orthogonalisation, projective simulation, diamond-norm SDP theory, almost-idempotent channel structure, and regular-simplex negative examples.

The only object under novelty investigation is

\[
\boxed{
\text{packing}
\to
\text{same-label completion}
\to
\text{dimension-free movement}
\to
\text{record accessibility}
\to
\text{exact idempotence}.
}
\]

Permitted language is “theorem candidate”, “internally reconstructed”, “no exact prior theorem located in the searches performed”, and “novelty unverified”. Claims such as “first”, “unprecedented”, “prior-art free”, “breakthrough theorem”, or “patentable” are prohibited without external specialist confirmation.

---

# 13. VIBE MATH methodology

VIBE MATH names the workflow, not a substitute for proof:

1. generate a nontrivial conjecture;
2. translate it into standard mathematics;
3. attack it with counterexamples;
4. run controlled experiments;
5. reconstruct surviving claims from definitions;
6. audit notation, spaces, and norms;
7. formalise stable components;
8. search prior art;
9. expose the claim to hostile review;
10. publish only what survives.

The negative results are part of the contribution. They identify the exact theorem boundary and prevent the framework from becoming unfalsifiable.

---

# 14. Limitations

1. No external specialist has yet certified the main theorem.
2. Full formalisation is incomplete.
3. The optimal movement constant is unknown.
4. Joint optimality of the packing and threshold rates is unresolved.
5. Every nonzero label must have a nonzero near-unit sector at the chosen threshold.
6. The current theorem is finite dimensional.
7. SDP evidence is limited to tractable dimensions.
8. Novelty has not been established by expert or legal review.
9. Experimental and fault-tolerance applications remain prospective.
10. The final record certificate may be loose because of projection and triangle inequalities.

---

# 15. Research programme

Immediate priorities:

- external proof audit by quantum-measurement and operator-theory specialists;
- expert prior-art review;
- full Lean formalisation of the typed theorem;
- optimality analysis for the coefficient and rates;
- exact diamond-norm benchmarks on adversarial low-dimensional families;
- a concise journal or arXiv manuscript after those gates.

Mathematical extensions include infinite-dimensional variants, incomplete label accessibility, quantitative converses for small \(\alpha\), mixed and correlated record redundancy, microscopic open-system models, instrument-level stability, and estimation of \(\alpha,\delta,\kappa,\eta\) without complete tomography.

The RC–TCL continual-learning bridge remains a separate application hypothesis. It is not part of the quantum theorem.

---

# 16. Conclusion

General dimension-free exact rounding of arbitrary almost-idempotent quantum channels is false. Within a record-structured and synthesis-conditioned class, however, the programme has produced a coherent, explicit theorem candidate:

- synthesis conditioning detects sector packability;
- the polar factor gives orthogonal sectors;
- the same-label residual completion preserves the POVM;
- the residual threshold supplies a repeatability gap;
- the typed hybrid dilation gives dimension-free operational movement;
- record accessibility produces an explicit exactly idempotent channel.

The work is beyond suggestive numerics but short of an externally established theorem. Its present scientific value is that it provides a precise, falsifiable, reproducible mathematical object for experts to attack.

---

# Review appendices

- Frozen theorem: `theory/THEOREM_V1_FREEZE.md`
- External reviewer checklist: `review/EXTERNAL_REVIEW_PACKET.md`
- Proof dependency map: `review/PROOF_DEPENDENCY_MAP.md`
- Reproducibility guide: `review/REPRODUCIBILITY_GUIDE.md`

# Selected references

1. Fan, K.; Hoffman, A. J. *Some Metric Inequalities in the Space of Matrices* (1955).
2. Löwdin, P.-O. *On the Non-Orthogonality Problem Connected with the Use of Atomic Wave Functions* (1950).
3. Higham, N. J. *Computing the Polar Decomposition—with Applications* (1986).
4. Busch, P.; Grabowski, M.; Lahti, P. *Repeatable Measurements in Quantum Theory* (1995).
5. Kretschmann, D.; Schlingemann, D.; Werner, R. F. Stinespring continuity papers (2008).
6. Watrous, J. *Semidefinite Programs for Completely Bounded Norms* (2009); *The Theory of Quantum Information* (2018).
7. de la Salle, M. *Orthogonalization of Positive Operator Valued Measures* (2022).
8. Asgari, M. S. *On the Riesz Fusion Bases in Hilbert Spaces* (2013).
9. Oszmaniec, M. et al. *Simulating POVMs with Projective Measurements* (2017).
10. Kotowski, M.; Oszmaniec, M. *Pretty Good Simulation of All Quantum Measurements by Projective Measurements* (2026).
11. Kitaev, A. *Almost-idempotent quantum channels and approximate C*-algebras* (2024).
12. Chenxiao. *Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels* (2026).
