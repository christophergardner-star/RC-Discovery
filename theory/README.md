# Theory Directory: Canonical Map and Historical Boundaries

This directory contains both the current theorem chain and earlier development notes. It must not be read as a flat set of equally current claims.

## Canonical entry points

For the analytic main proof and external-review presentation, read the
[short paper](../paper/prescribed_repeatable_completion.pdf) and its
[review brief](../review/SHORT_PAPER_REVIEW_BRIEF.md). The files below retain
the frozen statement and supporting derivations. The paper's computer-assisted
comparison proposition additionally uses its linked certificate supplement.
The [completed reduction audit](../literature/PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
identifies the established results and measurement-specific steps in the proof.

The [perfect-packing sharpness theorem](perfect_packing_sharpness.md)
proves the exact prescribed-completion envelope
`2*sqrt(delta)/(2-sqrt(delta))` for `alpha=1`, with a matching family for every
allowed threshold. It is now Theorem 7 in the paper. The
[reference-advantage certificate](reference_advantage.md) and
[imperfect-packing lower bound and vetoes](imperfect_packing_lower_bound.md)
support Propositions 8--9. The general `alpha<1` sharp finite-error bound remains open.

The new [joint second-order supplement](joint_second_order.md) derives
`W = sqrt(s) + s/2 + O(s^(3/2))` internally and gives a stronger lower family
at every exact parameter pair. It is not yet fully Lean checked. The
[formalization report](../research/LEAN_PERFECT_SHARPNESS_2026-11-01.md) records
the now-checked exact perfect-packing operator theorem, attaining family,
actual supremum and direct accessibility estimate.

The subsequent [joint small-error theorem](joint_small_error_asymptotics.md)
determines the sharp leading envelope `sqrt(1-alpha^2+delta)` as both errors
vanish, with a uniform remainder bound and matching lower construction.
This closes the leading-order gap, including `1-alpha^2=delta`. The exact
finite-error envelope remains open. It is now Theorem 10 in the fourteen-page
paper and is covered by the combined internal proof audit.

The [minimum-outcome corollary](minimum_outcomes_square_root.md) gives the
exact binary envelope `2 delta` and shows that three outcomes are necessary
and sufficient for square-root asymptotics. It is an elementary consequence
of the existing results, not a claim to resolve a recognized literature-open
problem. The same note defines a precise remaining joint-asymptotic problem.

Read these files first and in this order:

1. [`THEOREM_V1_FREEZE.md`](THEOREM_V1_FREEZE.md) — frozen hypotheses and conclusions.
2. [`same_label_dimension_free_theorem.md`](same_label_dimension_free_theorem.md) — fully typed same-label construction and proof architecture.
3. [`BOUND_CANDIDATE_2026-10-31.md`](BOUND_CANDIDATE_2026-10-31.md) — coefficient-two operational bound.
4. [`../research/CERTIFICATE_PROGRESS_2026-10-31.md`](../research/CERTIFICATE_PROGRESS_2026-10-31.md) — direct record-accessibility certificate.
5. [`record_margin_stability.md`](record_margin_stability.md) — sharp projective Record-Margin theorem.
6. [`povm_spectral_gap_stability.md`](povm_spectral_gap_stability.md) — fixed-POVM spectral-gap extension.
7. [`RESIDUAL_COUPLING_RATES_2026-10-31.md`](RESIDUAL_COUPLING_RATES_2026-10-31.md) — stronger rates under extra reducing/coupling information.

The current scientific label is

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

## Canonical theorem chain

Under the stated finite-dimensional hypotheses, the canonical construction is

\[
P_j
\longrightarrow
T
\longrightarrow
U,Q_j,R
\longrightarrow
F_j=Q_j+RE_jR
\longrightarrow
V=J_{\mathcal K}U^*+WR.
\]

The typed labelled map is

\[
J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m).
\]

It is not the historical alternative that embeds polar-rounded vectors into the output blocks.

The current internally reconstructed operational estimate is

\[
\|\mathcal M_E-\mathcal M_F\|_\diamond
\le
2\min\left\{1,\sqrt{1-\alpha^2}+\sqrt\delta\right\},
\]

with

\[
\gamma_F\ge\delta.
\]

The coefficient is not claimed optimal, and the full theorem is not yet machine-checked or externally verified.

## Development notes that are no longer canonical

The following files are retained for research history and should not be quoted as the current status:

- [`dimension_free_nu_via_naimark.md`](dimension_free_nu_via_naimark.md) — an earlier Naimark-completion route preceding the exact same-label hybrid construction; its notation is also damaged in places by historical text conversion.
- [`packing_conditioned_rounding.md`](packing_conditioned_rounding.md) — an earlier outcome-count-dependent stage of the programme.
- [`packing_feasible_moving_povm.md`](packing_feasible_moving_povm.md) — an earlier audited boundary note written before the dimension-free same-label step was closed internally.

These files remain useful for provenance, failed routes, and counterexample development. They do not override the frozen theorem or current status ledger.

## Supporting corollaries and applications

- [`sharpness_example.md`](sharpness_example.md) — equality family for the sharp Record-Margin theorem.
- [`redundancy_stability.md`](redundancy_stability.md) — record-discrimination corollaries and a correlated-redundancy failure mode.
- [`metastable_record_rounding.md`](metastable_record_rounding.md) — structured transfer corollary; not a general removal of slow-rank assumptions.
- [`moving_povm_boundary.md`](moving_povm_boundary.md) — obstruction and boundary results.
- [`rc_language.md`](rc_language.md) — minimal translation of RC vocabulary into ordinary mathematics.

## Imported Cruxy material

The exact source snapshot is under

`../imports/RC-Packing-Feasible-Note/`.

It is provenance, not canonical truth. In particular, imported novelty statements, closing-proof notes, informal robustness claims, and Lean files under assumed conclusions must be interpreted through the snapshot manifest and the canonical status ledger.

## Verification boundary

The executable and formal evidence is indexed by:

- [`../research/END_TO_END_VERIFICATION_2026-10-31.md`](../research/END_TO_END_VERIFICATION_2026-10-31.md);
- [`../experiments/README.md`](../experiments/README.md);
- [`../lean/README.md`](../lean/README.md);
- [`../review/TEST_CLAIM_MATRIX.md`](../review/TEST_CLAIM_MATRIX.md).

Passing numerical tests supports implemented finite cases. Passing Lean checks proves only the declarations actually formalised. Neither establishes novelty, peer review, or the complete end-to-end theorem.

**Human author and research director:** Christopher Gardner. AI systems and their providers are research tools only and are not designated claimants to the work.
