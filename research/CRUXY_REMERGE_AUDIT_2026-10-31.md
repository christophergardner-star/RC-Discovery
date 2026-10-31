# Cruxy Repository Re-Merge Audit

Date: 31 October 2026  
Source repository: `Cruxy234/RC-Packing-Feasible-Note`  
Source commit: `78be7962931f9f95e6e6aecd93f4dde00c3fe14d`  
Target repository: `christophergardner-star/RC-Discovery`

## Purpose

The Cruxy repository was pulled again in full and preserved under:

`imports/RC-Packing-Feasible-Note/`

The imported tree is a provenance snapshot. Imported files are not automatically authoritative: the source repository records the chronological research process and therefore contains conjectures, later refutations, superseded conclusions, numerical proxies, and mutually inconsistent definitions.

The canonical mathematical status is maintained in the root `theory/`, `research/`, `literature/`, `paper/`, `STATUS.md`, and `README.md` of RC-Discovery.

## New source material merged

The refreshed snapshot adds or updates:

- `paper/long_paper.md`
- `paper/short_paper.md`
- `theory/DEFINITIVE_CONCLUSION.md`
- `theory/PRIOR_ART_VETO.md`
- `theory/PRIOR_ART_VETO_UPDATED.md`
- `theory/adversarial_theorem_audit.md`
- `theory/constant_tightening.md`
- `theory/correct_WU_J_relation.md`
- `theory/diamond_norm_computation.md`
- `theory/hybrid_stinespring_isometry.md`
- `theory/naimark_identity_audit.md`

The source README was refreshed to the exact content at the source commit.

## Critical reconciliation: two different operators called J

The most important newly imported issue is the apparent contradiction between:

- the canonical identity
  \[
  J^*WU=D|T|,
  \]
  used in the same-label theorem; and
- `correct_WU_J_relation.md`, which computes
  \[
  (J^*WU)_{jk}=\langle q_j,\sqrt{E_j}q_k\rangle
  \]
  and concludes that the first identity is false.

Both calculations refer to different maps called `J`.

### Canonical typed map

Let

\[
\mathcal K=\bigoplus_j\mathcal S_j,
\qquad
\mathcal Y=\bigoplus_j\mathcal H.
\]

The map used by the theorem is the labelled direct-sum inclusion

\[
J_{\mathcal K}:\mathcal K\to\mathcal Y,
\qquad
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

It embeds the **original sector vector** in the corresponding outcome block.

In the rank-one case, if the coordinate basis vector `e_j` represents the original unit vector `v_j\in\mathcal S_j`, then

\[
(J_{\mathcal K}e_j)_j=v_j,
\]

not the polar-rounded vector `q_j`.

### Alternative map in the correction note

The source correction note instead defines

\[
(J_qe_j)_j=q_j.
\]

For this different map, its matrix-element formula is correct and the identity `J_q^*WU=D|T|` generally fails.

That failure does not refute the theorem stated with `J_{\mathcal K}`. It exposes a serious notation/type ambiguity in the source drafts.

## Re-derived canonical identity

Let `T=U|T|` be the polar decomposition and let

\[
Wz=(\sqrt{E_1}z,\ldots,\sqrt{E_m}z).
\]

Let `D` act blockwise on `\mathcal K` by

\[
(Dx)_j=\sqrt{E_j}x_j.
\]

Because `P_j` is a spectral projection of `E_j`, it commutes with `\sqrt{E_j}`. For `x\in\mathcal K`,

\[
(J_{\mathcal K}^*WU x)_j
=P_j\sqrt{E_j}Ux
=\sqrt{E_j}P_jUx.
\]

Since

\[
T^*U=|T|,
\]

and the `j`-th component of `T^*Ux` is `P_jUx`,

\[
\boxed{J_{\mathcal K}^*WU=D|T|.}
\]

Also `W` and `U` are isometries, so `WU` is exactly an isometry; residual mass does not alter that fact.

## Hybrid isometry with the typed map

With

\[
R=I-UU^*,
\]

the total range of `U` equals the span of the original near-unit sectors. Hence `P_jR=0`, and

\[
J_{\mathcal K}^*WR=0.
\]

The correctly typed hybrid map is

\[
V=J_{\mathcal K}U^*+WR.
\]

It satisfies

\[
V^*V=I
\]

and

\[
V^*\Lambda_jV=Q_j+RE_jR.
\]

The canonical numerical test `experiments/test_same_label_hybrid_dilation.py` uses original spectral-sector bases in the labelled embedding and therefore tests `J_{\mathcal K}`, not `J_q`.

## Status of imported source documents

| Imported document | Canonical status |
|---|---|
| `paper/long_paper.md`, `paper/short_paper.md` | Source drafts; wording around `J` is ambiguous and they are not canonical manuscripts. |
| `DEFINITIVE_CONCLUSION.md` | Superseded: the extra-outcome shortcut was refuted by an exact diamond-distance-2 counterexample. |
| `correct_WU_J_relation.md`, `naimark_identity_audit.md` | Correct for the alternative `J_q`; not a refutation of the typed direct-sum theorem. |
| `hybrid_stinespring_isometry.md` | Construction idea retained, but its statement `Je_j=q_j` is incompatible with the cross-term proof. Use the canonical typed theorem instead. |
| `adversarial_theorem_audit.md`, `constant_tightening.md`, `diamond_norm_computation.md` | Numerical evidence only. The pure-state TV calculation is not treated as a full diamond-norm computation. |
| `PRIOR_ART_VETO*.md` | Historical searches; preserved, but superseded by the canonical prior-art and attribution ledger. |

## Prior-art policy

No imported statement is promoted as novel merely because the source search found no exact match. The canonical repository now explicitly assigns known ingredients to their prior sources and reserves any possible contribution for the combined, precisely typed theorem only.

## Current canonical status

The same-label theorem remains an internally reconstructed theorem candidate **with the direct-sum definition of `J` made explicit**. Its mathematical correctness and its novelty are separate questions:

- correctness: internally reconstructed and numerically tested with the typed map;
- novelty: not established and subject to specialist review;
- publication: not ready until the notation reconciliation and prior-art comparison are reflected in the manuscript.
