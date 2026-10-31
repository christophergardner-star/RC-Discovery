# Novelty and Prior-Art Ledger

Updated: 31 October 2026

This ledger records what is known, what RC-Discovery has internally derived, and what remains novelty-unverified.

A literature search cannot certify absence of prior art. The canonical no-overclaim policy is:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`

## Focused laptop prior-art and certificate audit

See [the focused search and implication audit](SAME_LABEL_PRIOR_ART_VETO_2026-10-31.md) and [local validation results](../research/LOCAL_VALIDATION_2026-10-31.md). No direct prior statement or complete implication was located in the sources examined; novelty remains unverified. The report distinguishes inspected theorem statements from inaccessible originals and records search limitations.

**Certificate limitation:** substituting either current scalar movement envelope into the threshold-based exact-idempotent certificate always gives a bound greater than the trivial maximum of 2. This does not refute the measurement-rounding theorem or the certificate using actual/instance-dependent movement. Section 4 of the focused report gives the proof and the condition for a nontrivial certificate.

## Established ingredients

Subsequent internal progress reduces coefficient 4 to 2, repairs the certificate
through a sharp record-accessibility estimate, and gives linear rates when the
packed span reduces every effect. These are improvements over this repository's
previous analysis, **not established literature novelty**. See
[the proof and verification overview](../research/VERIFIED_PROGRESS_2026-10-31.md).

### Polar and Löwdin orthogonalisation

Established sources include Fan–Hoffman, Löwdin and Higham. Nearest-isometry properties of the polar factor, orthogonalisation of frames, singular-value residual formulas and related perturbation facts are prior art.

**RC claim:** none for the polar step itself.

### Frame and fusion-frame synthesis operators

Synthesis operators, lower Riesz bounds, fusion Riesz bases and equivalence/perturbation relationships with orthonormal fusion structures are established frame-theory concepts.

**RC claim:** none for introducing a synthesis operator or using its smallest singular value as a conditioning quantity by itself.

### Repeatable POVMs

Busch, Grabowski and Lahti (1995), DOI `10.1007/BF02055331`, and related measurement theory establish the structure and feasibility limits of repeatable measurements. The eigenvalue-1/norm-1 criterion for nonzero discrete effects is prior art.

**RC claim:** none for the criterion.

### POVM orthogonalisation and projectivisation

Mikael de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), DOI `10.5802/crmath.326`, arXiv `2103.14126`, proves dimension-independent quantitative rounding of almost-orthogonal POVMs and improves earlier finite-dimensional results of Kempe–Vidick and Ji–Natarajan–Vidick–Wright–Yuen.

**RC claim:** none for the general idea that almost-orthogonal/almost-projective POVMs can be rounded.

### POVM simulation by projective measurements

Prior art includes Oszmaniec and collaborators' simulation/postselection results and Kotowski–Oszmaniec, *Pretty Good Simulation of All Quantum Measurements by Projective Measurements*, IEEE Trans. Inf. Theory 72 (2026), 3156–3174, DOI `10.1109/TIT.2026.3678498`, arXiv `2501.09339`, including a dimension-deficient Naimark theorem.

**RC claim:** none for projective simulation, noisy simulation or dimension-deficient Naimark constructions generally.

### Naimark/Stinespring dilation and continuity

Naimark dilation and Stinespring representation are classical. Kretschmann–Schlingemann–Werner (2008), DOI `10.1109/TIT.2008.917696` and `10.1016/j.jfa.2008.07.023`, establish dimension-independent continuity between channels and suitable dilations.

**RC claim:** none for the generic implication that nearby isometries induce nearby channels.

### Diamond norm and channel discrimination

Watrous and the channel/measurement-discrimination literature establish diamond-norm SDP methods and show that ancilla assistance can matter.

**RC policy:** pure-state total-variation sampling is numerical evidence only, not a complete diamond-norm computation unless a theorem proves ancillas unnecessary in the exact class considered.

### Almost-idempotent channels

- Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*, arXiv `2405.02434`.
- Chenxiao, *Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels*, Zenodo `22906336`, DOI `10.5281/zenodo.22906336`.

The unrestricted structural theory and the regular-simplex negative mechanism are prior art.

## RC theorem candidates

### Sharp Record-Margin Stability

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}}.
\]

Status:

- internally proved;
- independent reconstruction passed;
- numerical equality family available;
- exact prior theorem not located;
- novelty unverified.

### Repeatability-admissible spectral-gap extension

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa\gamma}}.
\]

Status:

- internally proved;
- independent reconstruction passed;
- exact prior theorem not located;
- novelty unverified.

### Same-label synthesis-conditioned theorem candidate

Under the stated nonzero-sector and packing hypotheses, define

\[
F_j=Q_j+R E_jR.
\]

The internally reconstructed candidate gives

\[
\gamma_F\ge\delta
\]

and

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
4\left(
\sqrt{1-\alpha^2}+\sqrt\delta
\right).
\]

Combined with Record-Margin Stability,

\[
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{
\frac{2(\eta+3\nu)}
{\kappa\delta}
}.
\]

The labelled map must be typed as

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m),
\]

embedding original sector vectors. It is not the alternative map embedding polar-rounded vectors. The refreshed Cruxy source notes exposed this ambiguity; see `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`.

Status:

- internally reconstructed with the typed map;
- finite numerical tests support the exact isometry/effect identities;
- full Lean formalisation open;
- external specialist audit pending;
- no exact combined prior theorem located in searches;
- novelty remains unverified.

## Negative results established or adopted

- Local diagnostics alone do not remove global packing obstructions.
- Same-label exact repeatability with more nonzero labels than dimension is impossible.
- A generic linear \(O(\delta)\) threshold movement rate is false.
- Routing the residual subspace to an extra projective outcome can produce maximum channel distance.
- The broad unrestricted almost-idempotent-to-idempotent theorem is false by known negative results.

## Refreshed Cruxy source status

The exact source snapshot at commit `78be7962931f9f95e6e6aecd93f4dde00c3fe14d` is preserved under:

- `imports/RC-Packing-Feasible-Note/`

The snapshot includes historical documents with stronger novelty language and inconsistent definitions. They are not canonical novelty claims.

## Current claim boundary

No novelty claim is attached to any individual standard ingredient.

The only potentially distinct object is the complete, precisely typed combination:

\[
\text{synthesis-conditioned near-unit sectors}
\to
\text{same-label residual completion}
\to
\text{dimension-free operational control}
\to
\text{repeatability gap}
\to
\text{exact-idempotent record certificate}.
\]

Current label:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Prohibited until external review:

- “first”;
- “unprecedented”;
- “prior-art free”;
- “breakthrough theorem”;
- legal or patentability conclusions.

## Before publication

1. external reconstruction by a quantum measurement/operator-theory specialist;
2. full comparison with de la Salle, Kotowski–Oszmaniec, KSW and fusion-frame perturbation theory;
3. proof-assistant formalisation of the typed hybrid construction if practical;
4. norm and endpoint audit;
5. reproducible diamond-norm checks beyond pure-state proxies;
6. conservative wording that separates known ingredients from the potentially distinct combination.

## Continual-learning bridge

Idempotence, projection-style stability and quadratic parameter anchoring already have substantial continual-learning prior art, including IDER. RC-TCL claims remain application/diagnostic hypotheses only, not foundational novelty claims.
