# Open Problems

Updated after the moving-POVM push on 28 October 2026.

## Resolved

The original moving-POVM question is now partially resolved.

### No-go side

A theorem based only on

- small idempotence defect,
- large record margin,
- almost reachable records,
- almost norm-1 POVM effects

is impossible.

The regular-simplex family defeats all of those local diagnostics simultaneously.

### Binary side

For two outcomes, moving the POVM is possible under explicit reachability and edge-gap control. See:

- theory/moving_povm_boundary.md

# A. Main target: packing-feasible many-outcome classification

The unresolved regime is

[
3\le m\le d.
]

Find a sufficient, and ideally necessary-and-sufficient, global condition ensuring that near-unit outcome sectors can be simultaneously rounded to orthogonal repeatable sectors.

## Candidate conditioning parameters

1. Gram matrix of near-unit eigenvectors.
2. Smallest singular value of the synthesis map.
3. Principal angles between near-unit subspaces.
4. Total packing defect rather than worst-case local error.
5. Hall-type dimension conditions for families of near-unit subspaces.

The regular simplex shows that any successful condition must detect rank/packing even when pairwise/local quantities look excellent.

# B. Multi-record redundancy geometry

Obtain sharp \(\kappa_R\) rates for many mixed records and correlated fragments.

# C. Microscopic metastability

Apply the record-structured transfer theorem to an explicit open-system model and derive \(\eta,\delta,\kappa,\gamma\) from microscopic parameters.

# D. Experimental certification

Find protocols that estimate enough of \(\eta,\kappa,\gamma\), and the new packing conditioner, without full process tomography.

# E. Independent audit

Priority order:

1. sharp Record-Margin theorem,
2. POVM spectral-gap theorem,
3. moving-POVM binary theorem,
4. regular-simplex packing derivation,
5. metastability transfer theorem.
