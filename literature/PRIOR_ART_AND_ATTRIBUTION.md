# Prior Art, Attribution, and Claim Boundary

Updated: 31 October 2026  
Status: canonical attribution policy for RC-Discovery / VIBE MATH

## Purpose

This file exists to prevent RC-Discovery from presenting established mathematics as its own discovery.

A literature search cannot prove the absence of prior art. It can only report what was found. Nothing in this repository is a legal novelty opinion, patentability opinion, freedom-to-operate opinion, or substitute for review by a specialist researcher or qualified intellectual-property professional.

The repository therefore uses the following rule:

> **Known ingredients are credited explicitly. Only the precisely defined combination may be investigated as potentially distinct, and even that remains novelty-unverified until external review.**

## Established ingredients not claimed by RC-Discovery

| Ingredient used in RC-Discovery | Established source / area | RC claim boundary |
|---|---|---|
| Polar decomposition and nearest isometry/unitary properties | Fan & Hoffman, *Some Metric Inequalities in the Space of Matrices*, Proc. AMS 6 (1955), 111–116, DOI `10.1090/S0002-9939-1955-0067841-7`; Higham, *Computing the Polar Decomposition—with Applications*, SIAM J. Sci. Stat. Comput. 7 (1986), 1160–1174, DOI `10.1137/0907079`; Löwdin orthogonalisation, DOI `10.1063/1.1747632` | The polar factor, Löwdin orthogonalisation, closest-frame facts, and singular-value residual formulas are **not** claimed as new. |
| Synthesis operators, Riesz/fusion bases, and equivalence to orthonormal fusion structures | Frame and fusion-frame theory, including Asgari, *On the Riesz Fusion Bases in Hilbert Spaces*, J. Egyptian Math. Soc. 21 (2013), 79–86 | The use of a synthesis operator or its smallest singular value as a conditioning quantity is **not** claimed by itself. |
| Naimark dilation | Classical quantum measurement theory | Naimark dilation itself is **not** claimed as new. |
| Stinespring dilation and continuity of dilations/channels | Kretschmann, Schlingemann & Werner, IEEE Trans. Inf. Theory 54 (2008), 1708–1717, DOI `10.1109/TIT.2008.917696`; J. Funct. Anal. 255 (2008), 1889–1904, DOI `10.1016/j.jfa.2008.07.023` | The implication “nearby isometries give nearby channels” and dimension-independent Stinespring continuity are **not** claimed as new. |
| Repeatability criteria for discrete POVMs | Busch, Grabowski & Lahti, *Repeatable Measurements in Quantum Theory: Their Role and Feasibility*, Foundations of Physics 25 (1995), 1239–1266, DOI `10.1007/BF02055331` | The eigenvalue-1 / norm-1 repeatability condition is **not** claimed as new. |
| Quantitative orthogonalisation/projectivisation of almost-orthogonal POVMs | de la Salle, *Orthogonalization of Positive Operator Valued Measures*, Comptes Rendus Mathématique 360 (2022), 549–560, DOI `10.5802/crmath.326`, arXiv `2103.14126`; earlier Kempe–Vidick and Ji–Natarajan–Vidick–Wright–Yuen lemmas | The general fact that almost-orthogonal POVMs may be rounded to orthogonal/projective measurements is **not** claimed as new. |
| Simulation of POVMs by projective measurements | Oszmaniec et al., *Simulating Positive-Operator-Valued Measures with Projective Measurements*, Phys. Rev. Lett. 119, 190501 (2017), DOI `10.1103/PhysRevLett.119.190501`; Oszmaniec & Biswas, Phys. Rev. A 100, 012351 (2019), DOI `10.1103/PhysRevA.100.012351`; Kotowski & Oszmaniec, *Pretty Good Simulation of All Quantum Measurements by Projective Measurements*, IEEE Trans. Inf. Theory 72 (2026), 3156–3174, DOI `10.1109/TIT.2026.3678498`, arXiv `2501.09339` | Projective simulation, postselection schemes, noisy/projectively simulable POVMs, and the dimension-deficient Naimark theorem are **not** claimed as new. |
| Diamond norm and SDP methods | Watrous, *Semidefinite Programs for Completely Bounded Norms*, Theory of Computing 5 (2009), 217–238, DOI `10.4086/toc.2009.v005a011`; Watrous, *The Theory of Quantum Information* (2018) | Diamond-norm definitions, channel discrimination interpretations, and SDP computation methods are **not** claimed as new. Pure-state total-variation sampling is never presented as a complete diamond-norm proof. |
| Entanglement-assisted discrimination of channels and measurements | Piani & Watrous, Phys. Rev. Lett. 102, 250501 (2009), DOI `10.1103/PhysRevLett.102.250501`; Puchała et al., Phys. Rev. A 98, 042103 (2018), DOI `10.1103/PhysRevA.98.042103`; related measurement-discrimination literature | Ancilla assistance can matter. Statements equating a pure-state system-only proxy with the diamond norm require proof and are not assumed. |
| Approximate structure of almost-idempotent quantum channels | Kitaev, *Almost-idempotent quantum channels and approximate C*-algebras*, arXiv `2405.02434` | Approximate algebraic structure for almost-idempotent UCP maps is **not** claimed as new. |
| General obstruction to exact rounding of almost-idempotent channels | Chenxiao, *Almost-Idempotent Quantum Channels Need Not Be Close to Idempotent Channels*, Zenodo record `22906336`, DOI `10.5281/zenodo.22906336` | The regular-simplex obstruction mechanism and unrestricted negative result are **not** claimed as new. |

## Potentially distinct theorem candidate

The only result currently being assessed as potentially distinct is the complete, precisely typed chain:

1. choose full near-unit spectral sectors `P_j` of the POVM effects;
2. condition their synthesis operator by `α = σ_min(T) > 0`;
3. use the polar isometry to define mutually orthogonal sectors `Q_j`;
4. retain the original labels through the residual completion
   \[
   F_j=Q_j+R E_jR;
   \]
5. construct the correctly typed labelled isometry using the original direct-sum sector space;
6. derive outcome-count- and dimension-independent operational channel control;
7. combine this with Record-Margin Stability to obtain proximity to an exactly idempotent record process.

Even this combined statement is currently labelled:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

No document should call it “the first”, “new”, “novel”, “a breakthrough”, or “previously unknown” without external specialist confirmation.

## Required wording

Acceptable wording:

- “theorem candidate”;
- “internally reconstructed”;
- “no exact prior theorem was located in the searches performed”;
- “potentially distinct combination”;
- “novelty unverified”;
- “requires external review.”

Prohibited wording until expert review:

- “we proved the first…”;
- “this is unprecedented”;
- “no one has done this”;
- “breakthrough theorem”;
- “prior-art free”;
- “patentable” or “freedom to operate.”

## Imported Cruxy material

The exact source snapshot under `imports/RC-Packing-Feasible-Note/` is retained for provenance. Some source drafts state stronger novelty conclusions than the canonical policy permits. Those statements are historical research notes and are not adopted by RC-Discovery.

## Current literature-review files

- `literature/NOVELTY_LEDGER.md`
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`
- `literature/PRIOR_ART_AND_ATTRIBUTION.md`
- `research/CRUXY_REMERGE_AUDIT_2026-10-31.md`

## External-review requirement

Before public novelty claims, the combined theorem should be reviewed by researchers familiar with:

- quantum measurements and instruments;
- operator algebras;
- POVM orthogonalisation/projectivisation;
- Naimark/Stinespring perturbation theory;
- fusion-frame perturbation;
- diamond-norm channel discrimination.
