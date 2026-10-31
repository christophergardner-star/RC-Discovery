# Full-Work Audit of RC-Discovery

**Date:** 31 October 2026  
**Repository:** `christophergardner-star/RC-Discovery`  
**Audit basis:** current canonical work through commit `a37570c1cb89a0ecae22f5af01bfd147e8e87dbe`  
**Human author and research director:** Christopher Gardner  
**Status:** internal technical audit; not peer review, external verification, or a novelty opinion

## Executive verdict

No fatal algebraic or logical defect was found in the current canonical theorem chain during this review. The principal construction, typed-map identities, spectral-gap argument, coefficient-two channel estimate, sharp Record-Margin theorem, POVM spectral-gap extension, and direct accessibility certificate reconstruct coherently from their stated hypotheses.

The strongest responsible description remains

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

This audit does not convert the theorem candidate into an externally established theorem. The remaining credibility gates are independent specialist reconstruction, fuller formalisation, and definitive prior-art assessment.

## 1. Repository and executable audit

The repository already contains a detailed end-to-end verification record in

[`END_TO_END_VERIFICATION_2026-10-31.md`](END_TO_END_VERIFICATION_2026-10-31.md).

That audit established:

- the canonical fourteen-entry full profile passed with required Lean;
- all sixteen `test_*.py` scripts passed;
- eighteen of nineteen executable scripts passed;
- the one blocked executable was the optional PyTorch TCL neural smoke test, owing to a missing Microsoft C++ runtime for `torch/lib/c10.dll` on the audited Windows machine;
- the block is separate from the quantum-measurement theorem;
- all retained source hashes used by the evidence audit matched the executed files.

The corrected theorem-contract validator reported:

- 10 valid theorem cases;
- 16 expected hypothesis rejections;
- 6 primal/dual SDP checks;
- maximum exact-identity residual approximately `6.42e-15`.

The adversarial programme retained:

- 408 valid cases;
- 12 full primal/dual channel SDPs;
- higher-rank, unequal-rank, many-outcome, small-\(\alpha\), residual-extreme, threshold and ancilla-assisted regimes.

The direct-accessibility and residual-rate suites retained a further 26 and 20 primal/dual SDP checks respectively.

### Validator defect found and repaired

A genuine input-validation defect was found during the full audit. The former `build_rounding` path symmetrised effects before checking raw Hermiticity. It could therefore test a modified POVM instead of rejecting a non-Hermitian input. It also rejected valid single-outcome measurements and exact zero labels.

The corrected validator now checks raw:

- shape;
- finite entries;
- Hermiticity;
- positivity;
- normalization;

before any numerical cleanup. It accepts single-outcome POVMs and exact zero effects while continuing to reject nonzero labels without the required near-unit sector.

This was a meaningful improvement: the pre-existing test suite passed before the defect was noticed, demonstrating why independent test-design review matters.

## 2. Canonical geometric construction

Let \(P_j\) be the full spectral projector of \(E_j\) for eigenvalues at least \(1-\delta\), and let

\[
T:\bigoplus_j\operatorname{ran}(P_j)\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j.
\]

Under \(\alpha=\sigma_{\min}(T)>0\), write \(T=UH\). Define

\[
Q_j=U R_j^{\mathcal K}U^*,
\qquad
S=UU^*=\sum_jQ_j,
\qquad
R=I-S.
\]

The following steps reconstruct correctly:

1. The \(Q_j\) are pairwise orthogonal and preserve sector ranks.
2. `ran(U)=ran(T)` is the span of all original near-unit sectors.
3. Therefore \(P_jR=RP_j=0\).
4. Principal-angle geometry gives
   \[
   \|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}.
   \]

The use of the synthesis operator, polar decomposition, and principal-angle geometry is established mathematics and is not a standalone novelty claim.

## 3. Same-label completion and repeatability gap

The canonical completion is

\[
F_j=Q_j+R E_jR.
\]

It satisfies

\[
\sum_jF_j=I,
\qquad
F_iQ_j=\delta_{ij}Q_j.
\]

Because \(P_j\) is the full threshold projector,

\[
E_j\le P_j+(1-\delta)(I-P_j).
\]

Compression by \(R\) yields

\[
R E_jR\le(1-\delta)R,
\]

and hence

\[
\boxed{\gamma_F\ge\delta.}
\]

No separate residual spectral-radius hypothesis is required for this completion.

## 4. Typed hybrid dilation

The labelled map must be typed explicitly:

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)
\]

as a map from the original direct-sum sector space into the labelled dilation space. It is not the historical alternative map sending coordinate vectors to polar-rounded sector vectors.

With

\[
(Wz)_j=\sqrt{E_j}\,z,
\]

the identities

\[
J_{\mathcal K}^*WU=DH,
\qquad
J_{\mathcal K}^*WR=0
\]

reconstruct correctly. Therefore

\[
V=J_{\mathcal K}U^*+WR
\]

is an isometry and

\[
V^*\Lambda_jV=Q_j+R E_jR=F_j.
\]

The historical conflict over the symbol \(J\) was a real notation/type problem. The canonical typed definition resolves it.

## 5. Coefficient-two measurement-channel estimate

Set

\[
d=\sqrt{1-\delta},
\qquad
r=1-d,
\qquad
M=\|H\|.
\]

The positive-matrix argument in `theory/BOUND_CANDIDATE_2026-10-31.md` handles noncommuting \(H,D\) explicitly. With

\[
X=H-\alpha I,
\qquad
Y=D-dI,
\qquad
h=M-\alpha,
\]

positivity of \((\sqrt t X+t^{-1/2}Y)^2\) gives a lower bound on \(XY+YX\). Under

\[
(M-\alpha)r\le4\alpha d,
\]

it follows that

\[
\operatorname{Re}(HD)\ge\alpha dI.
\]

The overlap identity

\[
W^*V=UHD U^*+R
\]

then controls every ancilla-assisted pure input. The nontrivial parameter region implies the sufficient condition, and the complementary region is covered by the universal channel-distance cap. The result is

\[
\boxed{
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
}
\]

No error was found in this internal derivation. The coefficient is not known to be optimal and the operator inequalities are not yet formalised in Lean.

## 6. Record-Margin results

The sharp projective theorem

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}
\]

reconstructs correctly. The postselected records are supported in their sharp sectors, making the constructed channel exactly idempotent. The ancilla-assisted channel bound follows from positive conditional ancilla operators and a maximum record displacement.

The POVM spectral-gap extension

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}
\]

also reconstructs correctly under the stated repeatability-admissible POVM and full eigenvalue-1 sector assumptions. The recorded qubit/qutrit families support sharpness of the respective square-root dependences within those classes.

These are internal proof assessments, not external novelty findings.

## 7. Direct accessibility certificate

For

\[
v_j=\Phi(\sigma_j)-\sigma_j,
\qquad
D_{\rm rec}=\max_j\|v_j\|_1,
\]

and label inaccessibility \(e<1/2\), the estimate

\[
(1-2e)D_{\rm rec}\le\eta\le D_{\rm rec}
\]

is correct. The binary diagonal family shows sharpness of the lower coefficient.

Record margin and the threshold inequality concentrate each record into its original sector. Sector movement then transfers that concentration to \(Q_j\), and normalized projection constructs exact records \(\tau_j\). The resulting same-label channel is exactly idempotent and obeys

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\min\left\{
2,
\ b+2\sqrt{1-\alpha^2}
+
\sqrt{\frac{2\eta}{\kappa\delta(1-2e)}}
\right\}.
}
\]

This route correctly avoids inserting the measurement movement inside the spectral-gap denominator. It is more useful than the earlier coarse transfer route on the explicit families tested.

## 8. Formalisation boundary

The canonical Lean project builds. Thirteen theorem declarations were checked for axioms and had no `sorryAx` or custom axiom; only standard foundational dependencies were reported.

The formalised scope includes scalar geometric lemmas and selected matrix/projection identities under explicit assumptions. It does not yet include:

- construction of all spectral projectors from a POVM;
- the full Hilbert-space polar/principal-angle derivation;
- the noncommuting coefficient-two bridge;
- the Stinespring-to-diamond theorem in the repository's final form;
- the direct record-accessibility certificate end to end.

Imported Lean files compile but do not enlarge the canonical proof boundary merely by restating conclusions as hypotheses.

## 9. Source-history findings

The imported Cruxy snapshot is complete at source commit

`297ec2fcf6114598418863c5fcf13b7090364652`.

Several imported stronger assertions are not canonical:

- the proposed single-defect sharpness family conflicts with the trace constraint on a normalized synthesis Gram matrix;
- a singular-value polar residual \(|\sigma-1|\) is not the same quantity as the projector-angle expression \(\sqrt{1-\sigma^2}\);
- threshold crossings obstruct an unqualified global Lipschitz robustness statement;
- chaining a factor-two isometry estimate with a separate factor-two channel transfer gives coefficient four, not coefficient two.

These points do not refute the canonical coefficient-two overlap proof. They explain why imported development notes remain quarantined as provenance.

## 10. Repository-quality issues identified

The following nonfatal issues were identified during this review:

1. Several old root `theory/` notes describe earlier open problems as if still current. A canonical theory map is now provided in `theory/README.md`.
2. The root README and status ledger lagged behind the later end-to-end audit counts.
3. The validation runner hashed every Lean dependency under `.lake`, creating unnecessarily huge evidence files; only repository-owned Lean source should be hashed.
4. Automated Git commit metadata can name an AI tool. Such metadata is operational provenance, not an authorship, inventorship, ownership, priority, endorsement, or claimant designation.
5. The optional neural TCL smoke test needs a working PyTorch runtime; its failure does not affect the quantum theorem but should be tested separately in a suitable environment.

## 11. What remains genuinely open

- independent specialist reconstruction of the complete same-label theorem;
- external review of the coefficient-two overlap argument;
- complete end-to-end Lean formalisation;
- definitive prior-art and novelty assessment;
- the optimal movement constant;
- rigorously quantified perturbative robustness across fixed isolated thresholds;
- physical/model-specific applications with parameters derived from microscopic dynamics;
- independent reproduction outside the author-controlled repository.

## 12. Final responsible statement

The canonical work is substantially stronger than a collection of numerical guesses: it contains coherent analytic proofs, explicit counterexamples, executable adversarial checks, SDP verification, and partial formalisation. It is not yet an externally established theorem or a certified novel contribution.

The correct public statement is:

> RC-Discovery contains a human-directed theorem candidate for dimension- and outcome-count-independent same-label rounding in a structured class of finite quantum measurements. The canonical derivation has survived extensive internal reconstruction and computation, but external correctness and novelty review remain pending.

OpenAI and other AI providers are research-tool providers only. They are not designated authors, inventors, owners, sponsors, endorsers, or claimants to this work.