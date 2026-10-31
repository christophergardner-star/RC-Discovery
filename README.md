# VIBE MATH — RC-Discovery

**VIBE MATH** is the working name for this AI-assisted mathematical discovery programme. Christopher Gardner directs the questions, judgement, counterexample search and research strategy; AI is used interactively for derivation, coding, numerical testing, proof attacks, literature triage and formalisation support.

The rule is:

> **Vibe to generate. Audit to believe.**

This repository is deliberately conservative. A conjecture, a numerical pattern, an internal proof, a machine-checked lemma and a novelty claim are treated as different things.

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

Let \(T=U|T|\) be the polar decomposition, let \(Q_j\) be the mutually orthogonal polar-rounded sectors, and put

\[
R=I-\sum_jQ_j.
\]

The same-label completion is

\[
\boxed{
F_j=Q_j+R E_jR.
}
\]

Internally reconstructed consequences:

\[
\boxed{
\gamma_F\ge\delta,
}
\]

and, for the associated measurement channels,

\[
\boxed{
\nu=
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right).
}
\]

The operational bound is constructed using a correctly typed labelled isometry

\[
J_{\mathcal K}:\mathcal K\to\bigoplus_j\mathcal H,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m),
\]

and the hybrid dilation

\[
\boxed{
V=J_{\mathcal K}U^*+WR,
}
\]

where \(Wz=(\sqrt{E_j}z)_j\) is the canonical measurement isometry.

The direct-sum definition of \(J_{\mathcal K}\) matters. In the rank-one case it embeds the original sector vector \(v_j\) in label block \(j\), not the polar-rounded vector \(q_j\). This resolves the apparent contradiction in the refreshed Cruxy source notes.

## Composite record-process certificate

Let

\[
\Phi_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]

have record margin \(\kappa>0\) and idempotence defect

\[
\eta=\|\Phi_E^2-\Phi_E\|_\diamond.
\]

Using the same records after the POVM move, the RC spectral-gap theorem gives an exactly idempotent channel \(\Pi\) satisfying

\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{
\frac{2(\eta+3\nu)}
{\kappa\delta}
}.
}
\]

There is no explicit dependence on the number of outcomes, Hilbert-space dimension or total packed rank.

This is an **internally reconstructed theorem candidate**, not yet an externally established or novelty-certified theorem.

## Core results and negative results

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

The programme has also established that:

- local near-repeatability diagnostics do not remove the regular-simplex packing obstruction;
- \(m>d\) blocks same-label exact repeatability;
- threshold data alone do not support a generic linear \(O(\delta)\) movement bound;
- routing all residual mass to a new projective outcome may move the measurement channel by the maximum distance \(2\);
- a pure-state total-variation proxy is not automatically a complete diamond-norm computation.

## Refreshed Cruxy merge

The latest public source repository was imported again in full:

- source: `Cruxy234/RC-Packing-Feasible-Note`
- source commit: `78be7962931f9f95e6e6aecd93f4dde00c3fe14d`
- exact snapshot: `imports/RC-Packing-Feasible-Note/`

The snapshot is retained as provenance. It records the evolving research process and includes conjectures, superseded conclusions, refutations, numerical proxy notes and a notation mismatch involving two inequivalent maps both called `J`.

Canonical reconciliation:

- `imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md`
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`
- `theory/same_label_dimension_free_theorem.md`

Imported source drafts are not automatically canonical claims.

## Prior-art boundary

RC-Discovery claims no ownership of established ingredients, including:

- polar / Löwdin / Fan–Hoffman / Higham orthogonalisation and nearest-isometry results;
- frame and fusion-frame synthesis operators;
- Naimark and Stinespring dilation;
- Kretschmann–Schlingemann–Werner continuity;
- repeatability criteria for discrete POVMs;
- de la Salle and earlier POVM orthogonalisation/projectivisation;
- projective simulation of POVMs, including Kotowski–Oszmaniec's dimension-deficient Naimark theorem;
- Watrous diamond-norm and SDP theory;
- Kitaev's almost-idempotent channel structure;
- known regular-simplex negative examples.

The only object being investigated as potentially distinct is the complete, precisely typed chain

\[
\boxed{
\text{synthesis packing}
\to
\text{same-label hybrid completion}
\to
\text{dimension-free operational movement}
\to
\text{spectral-gap control}
\to
\text{exact idempotent record process}.
}
\]

No exact prior theorem matching that full chain was located in the searches performed. That is not proof of novelty. The status remains:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Canonical policy:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`

## Lean formalisation

Machine checked with Lean 4 + Mathlib and zero `sorry`:

- `projector_const_one`
- `polar_residual_le`
- `near_orthonormal_overlap`
- `rank1_core_package`

Not yet formalised:

- Hilbert-space polar geometry;
- the typed hybrid isometry;
- the diamond-norm channel step;
- the complete composite theorem.

## Current priorities

1. external specialist audit of the correctly typed theorem;
2. further prior-art review by experts in quantum measurements, operator algebras and fusion frames;
3. formalisation of the operator/channel proof;
4. sharpen the constant and establish optimal rates;
5. prepare an external-review paper only after those gates;
6. continue secondary RC work on redundancy, metastability and continual learning.

## Key files

- `theory/record_margin_stability.md`
- `theory/povm_spectral_gap_stability.md`
- `theory/moving_povm_boundary.md`
- `theory/packing_conditioned_rounding.md`
- `theory/same_label_dimension_free_theorem.md`
- `research/INDEPENDENT_PROOF_AUDIT_2026-10-31.md`
- `research/INDEPENDENT_HYBRID_ISOMETRY_AUDIT_2026-10-31.md`
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `experiments/test_same_label_hybrid_dilation.py`
- `lean/RCProof/Core.lean`
- `STATUS.md`

## Research discipline

Before any public novelty or breakthrough claim:

1. proof audit;
2. adversarial counterexample search;
3. reproducibility;
4. prior-art veto;
5. independent expert reconstruction or formal verification.

Author and research direction: **Christopher Gardner**
