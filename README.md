# VIBE MATH — RC-Discovery

**Human author and research director:** Christopher Gardner  
**Research workflow:** VIBE MATH  
**Repository status:** internally reconstructed, computationally audited, partially formalised, novelty unverified

> **Vibe to generate. Audit to believe.**

RC-Discovery separates conjecture, numerical evidence, internal proof reconstruction, machine-checked lemmas, external verification, provenance and novelty. Those categories are not interchangeable.

AI systems are used as research tools for derivation support, coding, testing, adversarial auditing, editing, literature triage and formalisation assistance. They are not designated as authors, inventors, owners, sponsors, endorsers or claimants. See [`AI_RIGHTS_AND_ATTRIBUTION.md`](AI_RIGHTS_AND_ATTRIBUTION.md).

## Current strongest theorem candidate

Let \(\{E_j\}_{j=1}^m\) be a finite POVM. Fix \(0<\delta<1/2\). For every nonzero outcome, let \(P_j\neq0\) be the full spectral projection of \(E_j\) onto eigenvalues at least \(1-\delta\).

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

Let \(T=U|T|\), let \(Q_j\) be the mutually orthogonal polar-rounded sectors, and put

\[
R=I-\sum_jQ_j.
\]

The same-label residual completion is

\[
\boxed{F_j=Q_j+R E_jR.}
\]

Internally reconstructed consequences include

\[
\boxed{\gamma_F\ge\delta}
\]

and the outcome-count- and dimension-independent measurement movement estimate

\[
\boxed{
\nu_{\rm meas}
=
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
}
\]

The coefficient-two refinement is derived in [`theory/BOUND_CANDIDATE_2026-10-31.md`](theory/BOUND_CANDIDATE_2026-10-31.md). Optimality is not claimed.

## Correctly typed hybrid dilation

The canonical theorem uses the labelled direct-sum inclusion

\[
J_{\mathcal K}:\mathcal K\to\bigoplus_j\mathcal H,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m),
\]

not the historical alternative map that embeds polar-rounded vectors into the label blocks.

With the canonical measurement isometry

\[
(Wz)_j=\sqrt{E_j}\,z,
\]

define

\[
\boxed{V=J_{\mathcal K}U^*+WR.}
\]

Then

\[
V^*V=I,
\qquad
V^*\Lambda_jV=Q_j+R E_jR=F_j.
\]

The typed distinction is essential and is covered by the theorem-contract test and a deliberate negative control for the incorrect map.

## Repaired exact-idempotent record certificate

Let

\[
\Phi_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

have record margin \(\kappa>0\), idempotence defect

\[
\eta=\|\Phi_E^2-\Phi_E\|_\diamond,
\]

and label inaccessibility \(e<1/2\).

For any valid measurement-movement upper bound \(b\), direct record accessibility and projection construct an exactly idempotent channel \(\Pi\) satisfying

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\min\left\{
2,
\ b+2\sqrt{1-\alpha^2}
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2e)}
}
\right\}.
}
\]

Since \(e\le\delta\), substitution of the coefficient-two movement bound gives

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\min\left\{
2,
4\sqrt{1-\alpha^2}+2\sqrt\delta
+
\sqrt{
\frac{2\eta}
{\kappa\delta(1-2\delta)}
}
\right\}.
}
\]

The full derivation and limitations are in [`research/CERTIFICATE_PROGRESS_2026-10-31.md`](research/CERTIFICATE_PROGRESS_2026-10-31.md).

## Core results and refutations

### Record-Margin Stability

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
}
\]

Internal proof reconstruction: passed.

### POVM spectral-gap extension

\[
\boxed{
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
}
\]

Internal proof reconstruction: passed.

### Refuted stronger claims

The programme has established that:

- local near-repeatability diagnostics do not remove the regular-simplex packing obstruction;
- \(m>d\) blocks same-label exact repeatability;
- threshold data alone do not support a generic linear \(O(\delta)\) movement bound;
- routing all residual mass to a new projective outcome can move the measurement channel by distance \(2\);
- pure-state total-variation sampling is not automatically a diamond-norm calculation;
- the historical polar-vector embedding is not interchangeable with \(J_{\mathcal K}\).

## Executable validation

The canonical validation entry point is

```bash
python experiments/run_phd_validation.py --profile full
```

Convenience launchers:

```powershell
.\scripts\run_phd_audit.ps1 -Profile full
```

```bash
bash scripts/run_phd_audit.sh --profile full
```

The completed clean CI audit at commit `d46b7ebdf83a23323486397ec4ac8187600ff687` passed:

- Python quick audit;
- Python full SDP audit;
- pinned Lean build;
- theorem-contract tests;
- adversarial many-outcome and higher-rank tests;
- record-accessibility and repaired-certificate tests;
- provenance, claim-discipline and AI-provider non-claim audits.

Detailed report: [`research/PHD_VALIDATION_REPORT_2026-10-31.md`](research/PHD_VALIDATION_REPORT_2026-10-31.md).

A passing suite is computational and formalisation evidence within its tested scope. It is not external proof, peer review or a novelty certificate.

## Latest Cruxy source synchronisation

The public source repository has been pulled again in full and checked at Git-object level:

- source: `Cruxy234/RC-Packing-Feasible-Note`;
- source branch: `main`;
- source commit: `fcef89be09dd9167a5a94d887e34d5ef1a8d0746`;
- source tree: `2d0e9ef233a39aea8b1555a8d51db31bf934ef44`;
- exact snapshot: `imports/RC-Packing-Feasible-Note/`.

Compared with the previous imported source commit, GitHub reports ten commits and exactly nine changed paths. All nine were imported. The imported `lean/`, `paper/` and `theory/` subtree SHAs match the source exactly.

Detailed evidence:

- [`imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`](imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md);
- [`research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md`](research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md);
- [`research/CRUXY_REMERGE_AUDIT_2026-10-31.md`](research/CRUXY_REMERGE_AUDIT_2026-10-31.md).

The imported snapshot is provenance, not canonical truth. In particular:

- its `NOVELTY_STATEMENT.md` is not adopted as a verified novelty claim;
- its `REVIEW_PACKAGE.md` retains the older coefficient-four review framing;
- its `full_proof.md` uses ambiguous notation for \(J\);
- its source Lean files prove algebraic consequences under supplied hypotheses, not the end-to-end physical theorem;
- its `paper/FINAL.md` is useful source material but does not replace the typed theorem, repaired certificate, validation report or canonical review package.

## Prior-art boundary

RC-Discovery claims no ownership of established ingredients, including:

- polar / Löwdin / Fan–Hoffman / Higham orthogonalisation;
- frame and fusion-frame synthesis theory;
- Naimark and Stinespring dilation;
- Kretschmann–Schlingemann–Werner continuity;
- repeatability criteria for discrete POVMs;
- de la Salle and earlier POVM orthogonalisation/projectivisation;
- projective simulation of POVMs, including Kotowski–Oszmaniec;
- Watrous diamond-norm and SDP theory;
- Kitaev's almost-idempotent channel structure;
- known regular-simplex negative examples.

The only object being investigated as potentially distinct is the complete, correctly typed chain

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

No exact prior theorem matching the full chain was located in the searches performed. That is not proof of novelty. The status remains

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Canonical policy:

- [`literature/PRIOR_ART_AND_ATTRIBUTION.md`](literature/PRIOR_ART_AND_ATTRIBUTION.md);
- [`literature/NOVELTY_LEDGER.md`](literature/NOVELTY_LEDGER.md);
- [`literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`](literature/DEEP_PRIOR_ART_VETO_2026-10-31.md).

## Lean formalisation

Machine checked with Lean 4 + Mathlib and zero `sorry`:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`.

Additional rectangular-matrix and projection/compression lemmas compile under explicit hypotheses. The complete spectral-sector construction, coefficient-two analytic bridge, diamond-norm transfer and end-to-end record certificate are not yet fully formalised.

Canonical formalisation scope: [`lean/README.md`](lean/README.md).

## Doctoral-style and external-review package

- [`paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md`](paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md);
- [`theory/THEOREM_V1_FREEZE.md`](theory/THEOREM_V1_FREEZE.md);
- [`review/EXTERNAL_REVIEW_PACKET.md`](review/EXTERNAL_REVIEW_PACKET.md);
- [`review/PROOF_DEPENDENCY_MAP.md`](review/PROOF_DEPENDENCY_MAP.md);
- [`review/TEST_CLAIM_MATRIX.md`](review/TEST_CLAIM_MATRIX.md);
- [`review/REPRODUCIBILITY_GUIDE.md`](review/REPRODUCIBILITY_GUIDE.md).

These materials are doctoral-style in depth and structure. They are not represented as an awarded thesis or peer-reviewed result.

## Current priorities

1. external specialist reconstruction of the correctly typed theorem and coefficient-two bridge;
2. expert prior-art review in quantum measurements, operator algebras and fusion frames;
3. complete Lean formalisation of the operator/channel proof;
4. determine optimality beyond coefficient two and the restricted linear-rate results;
5. prepare a concise external-review paper only after those gates.

## Research discipline

Before any public novelty or breakthrough claim:

1. proof audit;
2. adversarial counterexample search;
3. clean reproducibility;
4. prior-art veto;
5. independent expert reconstruction or formal verification.

**Author and research direction:** Christopher Gardner
