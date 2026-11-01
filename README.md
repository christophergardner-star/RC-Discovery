# VIBE MATH — RC-Discovery

**Human author and research director:** Christopher Gardner  
**Research workflow:** VIBE MATH  
**Scientific status:** internally reconstructed, computationally audited, partially formalised, novelty unverified

> **Vibe to generate. Audit to believe.**

RC-Discovery separates conjecture, analytic proof, numerical evidence, machine-checked lemmas, external verification, provenance and novelty. These categories are not interchangeable.

AI systems are used as research tools for derivation support, coding, testing, adversarial auditing, editing, literature triage and formalisation assistance. OpenAI and other AI providers are not designated as authors, inventors, owners, sponsors, endorsers or claimants. Automated Git metadata is operational provenance, not research attribution. See [`AI_RIGHTS_AND_ATTRIBUTION.md`](AI_RIGHTS_AND_ATTRIBUTION.md).

The [completed proof-level reduction](literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
derives the prescribed unweighted bound and record correction from established
tools after explicit labelled-dilation identities and elementary conditioning.
No new general operator lemma is needed. Both sector polar constructions are
established least-squares measurements. The quantitative specialization and
certified comparison remain subjects for publication-priority and usefulness
assessment; broad existence alone is not a defensible novelty claim.

## Current theorem candidate

For a complete, focused presentation, start with the
[short paper PDF](paper/prescribed_repeatable_completion.pdf),
[readable manuscript](paper/prescribed_repeatable_completion.md), and
[external-review brief](review/SHORT_PAPER_REVIEW_BRIEF.md).
The ten-page paper gives the full analytic main argument, corrected attribution,
and explicit limitations. Proposition 6 adds the certified comparison, with a
linked computer-assisted proof supplement. It remains an external-review draft
with novelty unverified.

Let \(\{E_j\}_{j=1}^m\) be a finite POVM on a finite-dimensional Hilbert space. Fix \(0<\delta<1/2\). For every nonzero outcome, let \(P_j\neq0\) be the full spectral projection of \(E_j\) onto eigenvalues at least \(1-\delta\).

Define

\[
\mathcal K=\bigoplus_j\operatorname{ran}(P_j),
\qquad
T:\mathcal K\to\mathcal H,
\qquad
T(x_1,\ldots,x_m)=\sum_jx_j,
\]

and assume

\[
\alpha=\sigma_{\min}(T)>0.
\]

Write \(T=U|T|\). Let \(Q_j\) be the mutually orthogonal polar-rounded sectors and put

\[
R=I-\sum_jQ_j.
\]

The canonical same-label residual completion is

\[
\boxed{F_j=Q_j+R E_jR.}
\]

The internally reconstructed consequences are

\[
\boxed{\gamma_F\ge\delta}
\]

and

\[
\boxed{
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
}
\]

There is no explicit dependence on outcome count, ambient Hilbert-space dimension, or total packed rank. The coefficient two is not claimed optimal.

Canonical documents:

- [`theory/THEOREM_V1_FREEZE.md`](theory/THEOREM_V1_FREEZE.md);
- [`theory/same_label_dimension_free_theorem.md`](theory/same_label_dimension_free_theorem.md);
- [`theory/BOUND_CANDIDATE_2026-10-31.md`](theory/BOUND_CANDIDATE_2026-10-31.md);
- [`theory/README.md`](theory/README.md).

## Correctly typed hybrid dilation

Let

\[
\mathcal Y=\bigoplus_j\mathcal H,
\qquad
(Wz)_j=\sqrt{E_j}\,z.
\]

The canonical labelled map is the direct-sum inclusion

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m),
\]

not the historical map that embeds polar-rounded vectors into output blocks.

Define

\[
\boxed{V=J_{\mathcal K}U^*+WR.}
\]

Then

\[
V^*V=I,
\qquad
V^*\Lambda_jV=Q_j+R E_jR=F_j.
\]

The typed distinction is covered by an executable negative control for the incorrect historical map.

## Exact-idempotent record certificate

For

\[
\Phi_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j,
\]

let \(\kappa>0\) be the record margin, let

\[
\eta=\|\Phi_E^2-\Phi_E\|_\diamond,
\]

and let \(e<1/2\) be the label inaccessibility. Direct record accessibility and projection construct an exactly idempotent channel \(\Pi\) satisfying, for any valid measurement-movement bound \(b\),

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

Since \(e\le\delta\), the coefficient-two movement estimate gives

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\min\left\{
2,
4\sqrt{1-\alpha^2}+2\sqrt\delta
+
\sqrt{\frac{2\eta}{\kappa\delta(1-2\delta)}}
\right\}.
}
\]

The derivation, exact examples and limitations are in [`research/CERTIFICATE_PROGRESS_2026-10-31.md`](research/CERTIFICATE_PROGRESS_2026-10-31.md).

## Core stability results

### Sharp Record-Margin theorem

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
}
\]

Internal proof reconstruction: passed. An explicit two-record family attains equality.

### Fixed-POVM spectral-gap extension

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
}
\]

Internal proof reconstruction: passed. An explicit qutrit family saturates the \(\gamma^{-1/2}\) dependence.

## Full-work validation

The latest retained end-to-end review is:

- [`research/END_TO_END_VERIFICATION_2026-10-31.md`](research/END_TO_END_VERIFICATION_2026-10-31.md);
- [`research/FULL_WORK_AUDIT_2026-10-31.md`](research/FULL_WORK_AUDIT_2026-10-31.md).

The audit established:

- all sixteen canonical `test_*.py` scripts passed;
- the corrected frozen theorem contract passed 10 valid cases, 16 expected rejections and 6 primal/dual SDP checks;
- 408 adversarial same-label cases and 12 associated SDPs passed;
- the accessibility suite passed 26 primal/dual SDPs;
- the residual-rate suite passed 20 primal/dual SDPs;
- the canonical Lean project built and the audited theorem declarations contained no `sorryAx` or custom axiom;
- a real theorem-input validation defect was found and repaired;
- eighteen of nineteen executable scripts passed in the audited Windows environment;
- the sole blocked script was the optional PyTorch TCL neural smoke test, owing to a missing local Microsoft runtime, not a failure of the quantum theorem.

The repository workflow now runs the optional TCL neural smoke separately on Linux during a tagged full audit.

Run locally:

```bash
python experiments/run_phd_validation.py --profile full
```

or

```powershell
.\scripts\run_phd_audit.ps1 -Profile full -RequireLean
```

A passing run is evidence for the tested finite cases. It is not external proof, peer review, optimality, or a novelty certificate.

## Refuted stronger claims

The programme records explicit failures of several tempting statements:

- local near-repeatability diagnostics do not remove the regular-simplex packing obstruction;
- \(m>d\) blocks nonzero same-label exact unit sectors;
- threshold data alone do not imply a generic linear \(O(\delta)\) movement rate;
- routing all residual mass to a new projective outcome can produce channel distance \(2\);
- pure-state system-only sampling is not automatically the diamond norm;
- the historical polar-vector embedding is not interchangeable with \(J_{\mathcal K}\);
- the imported single-defect sharpness sketch and unqualified Lipschitz robustness statement are not canonical conclusions.

## Lean formalisation boundary

Machine-checked with pinned Lean 4 + Mathlib and zero `sorry` within the stated scope:

- four scalar/core lemmas;
- rectangular hybrid-isometry identities under explicit hypotheses;
- residual projection and compression lemmas under explicit hypotheses.

Not yet formalised end to end:

- construction of all spectral-sector objects from the POVM hypotheses;
- the full polar/principal-angle argument;
- the noncommuting coefficient-two bridge;
- the channel diamond-norm transfer;
- the direct accessibility certificate.

See [`lean/README.md`](lean/README.md).

## Cruxy source provenance

The synchronized source snapshot is retained under

`imports/RC-Packing-Feasible-Note/`.

Current imported source:

- commit `297ec2fcf6114598418863c5fcf13b7090364652`;
- tree `99d063fea0157aa4afcbd0664a0aa0cf7161e387`.

The snapshot is Git-object checked and complete, but it is provenance rather than canonical truth. Imported novelty statements, closing-proof notes, informal robustness arguments, and Lean files under assumed conclusions do not override the canonical theorem or claim policy.

See:

- [`imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`](imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md);
- [`research/CRUXY_SYNC_REPORT_297EC2_2026-10-31.md`](research/CRUXY_SYNC_REPORT_297EC2_2026-10-31.md).

## Prior-art boundary

RC-Discovery claims no ownership of established ingredients including polar/Löwdin orthogonalisation, synthesis and fusion-frame theory, Naimark and Stinespring dilation, KSW continuity, repeatability criteria, POVM orthogonalisation/projectivisation, projective simulation, diamond-norm/SDP theory, almost-idempotent channel structure, or known regular-simplex obstructions.

The quantitative specialization under investigation is the complete, correctly typed chain

\[
\boxed{
\text{synthesis packing}
\to
\text{same-label hybrid completion}
\to
\text{dimension-free operational movement}
\to
\text{record accessibility}
\to
\text{exact idempotent record process}.
}
\]

The supplied reduction shows how this chain follows from established tools
and measurement-specific identities. No exact prior statement of the complete
specialization was located in the inspected sources; that does not prove
novelty. The certified comparison examples have unverified priority as well.
The status of the formulation and examples remains

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Canonical policy:

- [`literature/PRIOR_ART_AND_ATTRIBUTION.md`](literature/PRIOR_ART_AND_ATTRIBUTION.md);
- [`literature/NOVELTY_LEDGER.md`](literature/NOVELTY_LEDGER.md);
- [`literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`](literature/DEEP_PRIOR_ART_VETO_2026-10-31.md).

## Current credibility gates

1. Independent specialist reconstruction of the typed same-label theorem.
2. External checking of the coefficient-two overlap argument.
3. Full operator/channel formalisation.
4. Definitive prior-art and novelty assessment.
5. Optimal-constant and quantified perturbation analysis.
6. Independent reproduction outside the author-controlled repository.

**Author and research direction:** Christopher Gardner
