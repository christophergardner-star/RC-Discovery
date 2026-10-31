# VIBE MATH — RC-Discovery

**VIBE MATH** is the working name for this AI-assisted mathematical discovery programme. Christopher Gardner directs the questions, judgement, counterexample search and research strategy; AI is used for derivation, coding, numerical testing, proof attacks, literature triage and formalisation support.

> **Vibe to generate. Audit to believe.**

This repository deliberately distinguishes conjecture, numerical evidence, internal proof, machine-checked lemmas, external verification and novelty.

## Current strongest theorem candidate

Let \(\{E_j\}_{j=1}^m\) be a finite POVM. Fix \(0<\delta<1/2\). For every nonzero outcome let \(P_j\ne0\) be the full spectral projection of \(E_j\) onto eigenvalues at least \(1-\delta\).

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

The same-label completion is

\[
\boxed{F_j=Q_j+R E_jR.}
\]

Internally reconstructed consequences include

\[
\boxed{\gamma_F\ge\delta}
\]

and the outcome-count- and dimension-independent movement bound

\[
\boxed{
\nu_{\rm meas}
=
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\}.
}
\]

The coefficient-two refinement is proved in `theory/BOUND_CANDIDATE_2026-10-31.md`; optimality is not claimed.

## Correctly typed hybrid dilation

The theorem uses the labelled direct-sum inclusion

\[
J_{\mathcal K}:\mathcal K\to\bigoplus_j\mathcal H,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m),
\]

not the alternative map that embeds polar vectors \(q_j\) into the label blocks.

With the canonical measurement isometry \(Wz=(\sqrt{E_j}z)_j\), define

\[
\boxed{V=J_{\mathcal K}U^*+WR.}
\]

Then

\[
V^*V=I,
\qquad
V^*\Lambda_jV=Q_j+R E_jR=F_j.
\]

This typed distinction resolves the apparent contradiction in the imported Cruxy notes.

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

This repaired route avoids placing movement error inside the spectral-gap denominator. See `research/CERTIFICATE_PROGRESS_2026-10-31.md`.

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
- routing all residual mass to a new projective outcome may move the measurement channel by the maximum distance \(2\);
- pure-state total-variation sampling is not automatically a complete diamond-norm calculation.

## Latest Cruxy source synchronisation

The public source repository was pulled again in full and checked at Git-object level:

- source: `Cruxy234/RC-Packing-Feasible-Note`;
- source branch: `main`;
- source commit: `f94275addb491f1b4be428e2a65939bd4c153897`;
- source tree: `ef0eaf35289b2f489031baaa28163cc2bd97dff0`;
- exact snapshot: `imports/RC-Packing-Feasible-Note/`.

Compared with the previous snapshot, GitHub reports exactly four changed paths: updated source `README.md`, plus new `STATUS.md`, `theory/full_proof.md`, and `theory/full_proof_verification.md`. All four are imported, and the imported `lean/`, `paper/`, and `theory/` tree SHAs match the source exactly.

Detailed evidence:

- `imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`;
- `research/CRUXY_SYNC_REPORT_F94275_2026-10-31.md`;
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`.

The imported snapshot is provenance, not canonical truth. In particular, the source `full_proof.md` uses ambiguous rank-one wording for \(J\), retains the older coefficient-four estimate, and leaves its distance step at sketch level. Canonical statements remain in root `theory/`, `research/`, `paper/`, `review/`, `README.md` and `STATUS.md`.

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

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`;
- `literature/NOVELTY_LEDGER.md`;
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`.

## Lean formalisation

Machine checked with Lean 4 + Mathlib and zero `sorry`:

- `projector_const_one`;
- `polar_residual_le`;
- `near_orthonormal_overlap`;
- `rank1_core_package`.

Four rectangular-matrix lemmas in `Hybrid.lean` and five projection/compression lemmas in `Gap.lean` also compile without `sorry`. They establish the hybrid isometry and compression identities under explicit hypotheses and the operator-order step behind the residual spectral gap.

Not yet formalised:

- construction of all typed spectral-sector hypotheses;
- complete Hilbert-space polar geometry;
- the diamond-norm channel step;
- the end-to-end record certificate.

## Doctoral-style research package

- `paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md`;
- `theory/THEOREM_V1_FREEZE.md`;
- `review/README.md`;
- `review/EXTERNAL_REVIEW_PACKET.md`;
- `review/PROOF_DEPENDENCY_MAP.md`;
- `review/REPRODUCIBILITY_GUIDE.md`.

These documents are doctoral-style in depth and structure, but are not represented as an awarded thesis or peer-reviewed result.

## Current priorities

1. external specialist audit of the correctly typed theorem;
2. expert prior-art review in quantum measurements, operator algebras and fusion frames;
3. complete Lean formalisation of the operator/channel proof;
4. determine optimality beyond coefficient 2 and the restricted linear-rate results;
5. prepare a concise external-review paper after those gates;
6. continue secondary work on redundancy, metastability and continual learning.

## Key files

- `theory/same_label_dimension_free_theorem.md`;
- `theory/BOUND_CANDIDATE_2026-10-31.md`;
- `theory/THEOREM_V1_FREEZE.md`;
- `research/CERTIFICATE_PROGRESS_2026-10-31.md`;
- `research/VERIFIED_PROGRESS_2026-10-31.md`;
- `research/CRUXY_SYNC_REPORT_F94275_2026-10-31.md`;
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`;
- `experiments/test_same_label_hybrid_dilation.py`;
- `experiments/test_constant_two_bound.py`;
- `experiments/test_record_accessibility.py`;
- `lean/RCProof/Core.lean`;
- `STATUS.md`.

## Research discipline

Before any public novelty or breakthrough claim:

1. proof audit;
2. adversarial counterexample search;
3. reproducibility;
4. prior-art veto;
5. independent expert reconstruction or formal verification.

Author and research direction: **Christopher Gardner**
