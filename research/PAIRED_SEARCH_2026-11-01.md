# Adaptive comparison and bound attack

Date: 1 November 2026.

The local search found numerical examples in both directions: the prescribed
unweighted completion can be closer to the input measurement, and the weighted
completion can be closer. Both orderings occur where the frozen theorem gives
a bound below two. No candidate violation of that theorem was found.

This is finite numerical evidence of a meaningful distinction between the
constructions. It does not establish a new theorem, universal dominance,
optimal constants, practical superiority, or literature priority.

## Retained result

- [Search implementation](../experiments/search_prescribed_completion.py)
- [Machine-readable summary](paired_search_2026-11-01/summary.json)
- [All accepted search evaluations](paired_search_2026-11-01/search_trace.csv)
- [Independent implementation replay](paired_search_2026-11-01/replay.json)
- [Physical witness and artifact checks](paired_search_2026-11-01/artifact_checks.json)

The run used seed 2026110101 and attempted 3,074 candidates. Of these, 3,004
met the requested full-sector hypotheses and 70 were rejected: 56 lacked an
admissible threshold for the requested ranks, and 14 selected a different rank
pattern. There were 2,104 valid evaluations in the informative regime, where
the theorem's uncapped right-hand side is below two.

Twenty-five finalists received paired full diamond-distance calculations,
including reference assistance. Each distance was evaluated with both a
primal and a dual SDP. Twenty-one selected finalists favored the unweighted
construction and four favored the weighted construction. These are deliberately
selected optimization finalists, not a random sample or a frequency estimate
for general measurements.

## Concrete comparisons

The entries below are unhalved diamond distances; smaller is better.

| Saved case | Dimension / outcomes | Unweighted distance | Weighted distance | Theorem bound | Numerical ordering |
| --- | --- | --- | --- | --- | --- |
| [324](paired_search_2026-11-01/case_00324.npz) | 3 / 3 | 1.156754449 | 1.184944460 | 2.000000000 | Unweighted closer |
| [771](paired_search_2026-11-01/case_00771.npz) | 4 / 3 | 1.068551876 | 1.067563410 | 2.000000000 | Weighted closer |
| [1676](paired_search_2026-11-01/case_01676.npz) | 6 / 3 | 0.749960676 | 0.750940042 | 1.879354556 | Unweighted closer |
| [2003](paired_search_2026-11-01/case_02003.npz) | 6 / 3 | 0.518692807 | 0.518402339 | 1.762890135 | Weighted closer |

The first two are the largest observed advantages in their respective
directions. Their theorem bounds equal the universal ceiling and therefore
say little about the quality of the constant. The last two establish that
the observed comparison is not confined to that trivial-bound region.

The largest full-distance/bound ratio among the 12 informative finalists was
approximately 0.49120350, in
[case 2201](paired_search_2026-11-01/case_02201.npz). Its distance was approximately
0.943231194. The largest ratio including the trivial-bound region was
0.57837722, in case 324. These are different statistics; the latter must not
be represented as a sharpness result for the informative coefficient-two bound.
No search score or evaluated full distance exceeded the applicable bound.

In six finalists, the ordering under system-only distance reversed after
allowing a reference system: cases 207, 483, 1003, 1213, 2287, and 2484.
For example, case 483 had system-only distances 0.447131680 and 0.446804497
for unweighted and weighted completion, respectively, but full distances
0.454287126 and 0.454447058. This is a reason to evaluate the operational
norm actually claimed by the theorem. It is not a claim that reference
assistance is a new phenomenon.

## Search design

The six geometries used sector ranks [1,1,1], [1,1,1] with one residual
dimension, [2,1,1] with one residual dimension, [2,2,1] with one residual
dimension, [1,1,1,1] with one residual dimension, and [2,1,1,1] with one
residual dimension. Thus dimensions ranged from three to six, with three
or four outcomes. Binary measurements were a control rather than a search
target because their two completions coincide under these hypotheses.

Each geometry started from 32 accepted noisy repeatable measurements.
Complex matrix-factor mutations were normalized to produce positive effects
summing to the identity. Three objectives each received 160 mutation attempts:
the theorem ratio, unweighted advantage, and weighted advantage. An elite
pool and occasional returns to seed cases guided the search; this is a
heuristic optimizer, not an exhaustive or globally certified optimization.

For each fixed rank pattern, the threshold error was chosen as the smallest
value selecting those full sectors, plus a buffer of 1e-7. Candidates with
extra selected eigenvalues were rejected. The observed alpha range was
approximately 0.1950 to 0.9997 and the delta range approximately 0.00375 to
0.49984. This run did not explore arbitrarily small alpha or delta, large
dimensions, or every rank pattern.

Optimization used the larger of the system-only distance and the distance
obtained from a maximally entangled input. Those scores are lower bounds on
the full distance. Comparisons between such scores do not determine the
ordering of the full distances; only the finalist SDP calculations were used
for the reported full-distance comparisons.

## Validation and numerical limits

The zero-distance and distance-two SDP anchors passed. Binary completions
coincided, and the binary system-distance identity was checked. Each finalist
passed the existing frozen-theorem matrix contract, direct POVM validation
for both targets, and a weighted-sector repeatability check.

The principal computations used SCS after the tighter CLARABEL attempts
reported inaccurate status. Five selected cases were also submitted to
CLARABEL at a separate tolerance, with explicit constraint and gap checks;
all five retained their ordering. Some alternate-solver statuses remained
optimal_inaccurate and were accepted only after those numerical checks.
Solver status is retained alongside numerical feasibility, objective gaps,
and repaired primal/dual witnesses; it is not treated as a proof certificate.
The original repository SDP implementation separately reproduced the 25 pairs.
An additional verifier explicitly constructed the reference-assisted input
state and conditional output blocks for all 60 retained witnesses (50 main
and ten alternate-solver witnesses). All passed normalization, positivity,
output-distance, saved-constraint, and artifact-hash checks.

The main accepted primal/dual objective gaps were at most approximately
3.69e-9 and the largest recorded constraint violation was approximately
7.89e-9. The implementation also shifts the candidate primal and dual
matrices to repair feasibility numerically. Those repairs still use
floating-point eigenvalues: the resulting lower and upper numbers are not
rigorous interval certificates. An ordering requires an additional 1e-6
separation margin. Exact or interval validation remains necessary before
promoting numerical examples to a formally certified non-dominance result.

The optional OSQP backend was unavailable during CVXPY import; none of these
SDPs used OSQP. An initial diagnostic run exposed that rerunning SCS after
a CLARABEL fallback is not a second-solver check. The retained implementation
explicitly selects the alternate solver and records any unresolved check.
Development runs are not counted as additional independent samples.

## Reproduce and inspect

From the repository root, with the existing audit environment:

    .venv-audit/Scripts/python.exe experiments/search_prescribed_completion.py --output research/local_validation/phd_audit/paired_search_new

The output directory must not already contain a completed run. The default
seed and search counts reproduce this experiment. To independently re-solve
the retained matrices with the earlier SDP implementation:

    .venv-audit/Scripts/python.exe experiments/search_prescribed_completion.py --replay research/paired_search_2026-11-01

To verify the stored witnesses directly, without solving another SDP:

    .venv-audit/Scripts/python.exe experiments/verify_paired_search_artifacts.py

Each case archive stores the input effects, both completed POVMs, normalized
matrix factors, and raw and repaired primal/dual solution matrices. Archives
can be read with NumPy using allow_pickle=False. Source hashes use normalized
text; artifact hashes use exact bytes. The CSV trace and NumPy archives retain
their bytes across Git checkouts via the repository attributes file.

This run used Python 3.12.10 and the pinned numerical packages recorded in
the summary. It adds a targeted experiment; it does not rerun the complete
repository suite or extend the Lean proof.

## Consequence for the research

The weighted construction's stronger general upper bound does not, by itself,
settle which explicit completion has the smaller actual movement. The saved
examples provide concrete targets for an analytic comparison. The next
mathematical step is to simplify examples in both directions into exact
families or certify them with interval arithmetic. The frozen paper and its
novelty status are unchanged.
