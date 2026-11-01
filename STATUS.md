# Research Status Ledger

Updated: 1 November 2026

This ledger separates mathematical correctness, numerical evidence, formal verification, provenance, external review and novelty. They are not interchangeable.

## Canonical scientific status

\[
\boxed{
\text{internally reconstructed, computationally audited, partially formalised, novelty unverified}.
}
\]

No public file should represent the work as externally proved, peer reviewed, fully machine checked, prior-art free, patentable, or a proven breakthrough.

## Exact comparison of the two completions

The subsequent [four-dimensional family](research/COMPLETION_SWITCH_FAMILY_2026-11-01.md)
varies one off-diagonal coupling while keeping every diagonal entry fixed.
Exact endpoint certificates show opposite distance orderings; a uniform
certificate proves the theorem hypotheses and an informative bound for all
parameters in [2,4]. Continuity guarantees at least one equality point.
This simplifies the earlier examples without settling literature novelty.

The [exact comparison certificates](research/EXACT_COMPARISON_2026-11-01.md)
give two rational six-dimensional, three-outcome measurements with opposite
strict full-diamond-distance orderings between the unweighted and weighted
completions. Both have informative frozen-theorem bounds. The analytic
error-bound proof is backed by exact rational verification, an independent
integer-determinant positivity audit, and corrupted-certificate controls.
This is a finite computer-assisted comparison, not a complete Lean proof,
external specialist review, or a novelty finding.

## Latest theorem-level literature comparison

The subsequent [adaptive paired search](research/PAIRED_SEARCH_2026-11-01.md)
evaluated 3,004 valid measurements and 25 paired full-distance finalists.
It found numerical examples favoring each completion, including both
orderings where the theorem bound is below two, and no candidate violation
of that bound. These are numerical comparison results, not exact
non-dominance certificates, a proof of optimal constants, or novelty findings.

The [combined-statement audit](literature/COMBINED_STATEMENT_COMPARISON_2026-10-31.md)
identifies the coefficient-two overlap lemma as a special case of
Strang/de Bruijn and reconstructs a weighted polar completion with an
unconditional joint measurement bound from established machinery. The broad
existence claim therefore has a short reduction; the prescribed unweighted
map and explicit record correction remain the narrower comparison targets.
Novelty remains unverified. The additional comparison checks passed 104
weighted constructions and six primal/dual SDPs, alongside exact rational
examples; these are separate from the earlier full-suite results below.

## Core record-stability results

| Item | Status | Notes |
|---|---|---|
| Sharp Record-Margin theorem | **Internally proved; reconstruction passed** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/\kappa}\); equality family recorded. |
| POVM spectral-gap extension | **Internally proved; reconstruction passed** | \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/(\kappa\gamma)}\); qutrit sharpness family recorded. |
| General exact rounding of arbitrary almost-idempotent channels | **False / obstructed** | No unrestricted dimension-free modulus is claimed. |
| RC as a fundamental physical theory | **Not established** | No such claim is made. |

## Same-label moving-POVM theorem candidate

| Component | Status | Notes |
|---|---|---|
| Near-unit sectors | **Explicit hypothesis** | Every nonzero label must have a nonzero full threshold sector at \(1-\delta\). |
| Packing conditioner | **Valid parameter; underlying geometry is prior art** | \(\alpha=\sigma_{\min}(T)>0\). |
| Polar-rounded sectors | **Internally proved / standard machinery** | Pairwise orthogonal, rank preserving. |
| Per-sector movement | **Internally proved; stress-tested** | \(\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}\). |
| Correct labelled map | **Reconciled and typed** | \(J_{\mathcal K}(x_1,\ldots,x_m)=(x_1,\ldots,x_m)\), not the historical polar-vector map. |
| Same-label completion | **Internally proved** | \(F_j=Q_j+RE_jR\) is a POVM with exact unit sectors. |
| Repeatability gap | **Internally proved** | \(\gamma_F\ge\delta\). |
| Hybrid isometry | **Internally reconstructed** | \(V=J_{\mathcal K}U^*+WR\), with \(V^*V=I\) and \(V^*\Lambda_jV=F_j\). |
| Dimension-free measurement movement | **Internally reconstructed; numerically cross-checked** | \(\nu\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}\). |
| Direct exact-idempotent certificate | **Internally derived; tested** | Accessibility route avoids putting movement inside the gap denominator. |
| Sharpness of coefficient two | **Open** | Valid searches show substantial slack; no saturating family is known. |
| Higher-rank uniformity | **Supported internally** | No rank factor appears in the typed operator-norm construction. |
| Perturbative robustness | **Conditional/sketch level** | Requires an isolated threshold and quantified conditioning hypotheses. |
| External specialist verification | **Pending** | Principal credibility gate. |
| Novelty | **Unverified** | No exact full-chain prior theorem located; absence is not proved. |

## Negative results and boundary findings

| Statement | Status |
|---|---|
| Local diagnostics alone force nearby repeatability | **Refuted** |
| More than \(d\) nonzero same-label repeatable sectors fit in dimension \(d\) | **Impossible** |
| Threshold-only movement is generically linear in \(\delta\) | **Refuted; \(\sqrt\delta\) can be necessary** |
| Residual mass can be dumped into a new projective outcome for free | **Refuted; distance can be 2** |
| Pure-state system-only sampling always equals the diamond norm | **Not assumed / false in general** |
| Historical polar-vector map equals the direct-sum inclusion | **Refuted by typed negative control** |
| Imported single-defect sketch proves coefficient-two sharpness | **Not established** |
| Global Lipschitz robustness without threshold isolation | **Not established** |

## End-to-end executable validation

The latest comprehensive review is recorded in:

- `research/END_TO_END_VERIFICATION_2026-10-31.md`;
- `research/FULL_WORK_AUDIT_2026-10-31.md`.

| Item | Status | Notes |
|---|---|---|
| All canonical `test_*.py` scripts | **Passed** | 16/16 in the retained end-to-end audit. |
| Corrected theorem contract | **Passed implemented cases** | 10 valid cases, 16 expected rejections, 6 primal/dual SDP checks; max identity residual about \(6.42\times10^{-15}\). |
| Adversarial same-label suite | **Passed implemented cases** | 408 valid cases and 12 full SDPs. |
| Record-accessibility suite | **Passed implemented cases** | 26 primal/dual SDPs. |
| Residual-rate suite | **Passed implemented cases** | 20 primal/dual SDPs. |
| Canonical full profile | **Passed** | Numerical, algebraic, provenance and counterexample tests. |
| Pinned Lean build | **Passed within formalised scope** | Does not prove the complete theorem. |
| Input-validation review | **Defect found and repaired** | Raw Hermiticity/PSD/normalisation now checked before cleanup; one-outcome and exact-zero labels handled correctly. |
| Optional PyTorch TCL neural smoke | **Environment-separated** | Blocked on audited Windows runtime; dedicated Linux CI job added for tagged full audits. |
| Numerical interpretation | **Evidence, not proof** | Finite checks do not establish the universal theorem or novelty. |

Canonical runner:

- `experiments/run_phd_validation.py`

Canonical theory map:

- `theory/README.md`

## Lean formalisation

| Item | Status |
|---|---|
| Scalar/core lemmas | **Machine checked; zero `sorry`** |
| Hybrid matrix identities | **Machine checked under explicit hypotheses** |
| Residual projection/compression | **Machine checked under explicit hypotheses** |
| Axiom audit | **Passed current declarations** | No `sorryAx` or custom axioms in audited theorem declarations. |
| Full spectral-sector construction | **Not formalised** |
| Principal-angle theorem end to end | **Not formalised** |
| Coefficient-two analytic bridge | **Not formalised** |
| Diamond-norm transfer | **Not formalised** |
| Accessibility certificate end to end | **Not formalised** |

The validation runner now hashes only repository-owned Lean sources, not downloaded `.lake` dependencies.

## Cruxy source synchronisation

| Item | Status | Notes |
|---|---|---|
| Source repository | **Synced** | `Cruxy234/RC-Packing-Feasible-Note`, branch `main`. |
| Source commit | **Recorded** | `297ec2fcf6114598418863c5fcf13b7090364652`. |
| Source tree | **Recorded** | `99d063fea0157aa4afcbd0664a0aa0cf7161e387`. |
| Source paths | **Complete at recorded commit** | Git-object parity checked under `imports/RC-Packing-Feasible-Note/`. |
| Canonical promotion | **Audited, not blind** | Imported material does not override stronger typed and tested canonical work. |

Imported material remains provenance. In particular, source novelty statements, `CLOSING_PROOFS.md`, informal robustness claims, and source Lean declarations under supplied hypotheses are not promoted as final conclusions.

## Prior-art boundary

Established ingredients are credited and not claimed, including polar/Löwdin orthogonalisation, frame/fusion-frame synthesis, Naimark and Stinespring dilation, KSW continuity, repeatability criteria, POVM projectivisation, projective simulation, diamond-norm/SDP methods, almost-idempotent channel structure, and known obstruction families.

The only object being investigated as potentially distinct is the complete typed chain

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

Current label:

\[
\boxed{\text{potentially distinct; novelty unverified}.}
\]

Canonical policies:

- `literature/PRIOR_ART_AND_ATTRIBUTION.md`;
- `literature/NOVELTY_LEDGER.md`;
- `literature/DEEP_PRIOR_ART_VETO_2026-10-31.md`.

## Human authorship and AI-provider non-claim boundary

| Item | Status |
|---|---|
| Human author and research director | **Christopher Gardner** |
| AI systems | **Research tools only** |
| OpenAI or another provider designated as author/inventor/owner/claimant | **No** |
| Automated tool or bot commit metadata treated as scientific attribution | **No** |

Canonical notice:

- `AI_RIGHTS_AND_ATTRIBUTION.md`

This is a repository-governance statement, not a legal opinion.

## Secondary RC applications

| Item | Status | Notes |
|---|---|---|
| Redundancy-to-margin formulas | **Exact known-information corollaries** | Independent fragments can improve margin; correlated multiplicity can fail. |
| Metastability transfer | **Internally derived structured corollary** | Applies only near classical record-producing structure. |
| TCL affine horizon identity | **Derived elementary result** | Separate from the quantum theorem. |
| Locked conflict predicts immediate forgetting | **Refuted in smoke test** | Initial hypothesis failed. |
| Locked conflict versus joint accuracy | **Supported in synthetic smoke test** | Application evidence only. |

## Current external gates

1. Independent human reconstruction of the typed same-label theorem.
2. Specialist audit of the coefficient-two bridge and accessibility certificate.
3. Complete Lean formalisation of the operator/channel chain.
4. Definitive prior-art and novelty assessment.
5. Independent reproduction outside the author-controlled repository.
6. Optimal-constant and quantified robustness work.
