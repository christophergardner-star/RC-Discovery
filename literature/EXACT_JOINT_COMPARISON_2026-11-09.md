# What the exact joint statement adds: focused prior-art comparison

9 November 2026. Primary-source inspection plus a bounded search. **No priority
claim or external endorsement.** This updates the older coefficient-two
comparison for the exact formula in [the joint proof](../theory/exact_joint_envelope.md).

## The claim being compared

For a finite POVM, retain its full closed-threshold sectors at `c=1-delta`;
assume injective sector synthesis with least singular value `alpha`, and a
sector for each nonzero label. Orthogonalize by the unweighted polar factor
and prescribe `F_j=Q_j+R E_j R`. The proposed exact statement is

```text
sup_E ||M_E-M_F||_diamond = 2*b/(2-b),
b=sqrt(1-alpha^2*(1-delta)),
0<alpha<=1, 0<delta<1/2.
```

The supremum fixes the two parameters exactly and permits arbitrary finite
dimensions and outcome counts. The norm is unhalved and fully stabilized.
This is an extremal theorem for a specified map from POVMs to repeatable
POVMs. It is not the nearest-repeatable-measurement problem.

## Established results and the remaining specialization

| Primary source inspected | What is already available | What still has to be supplied for the displayed claim |
| --- | --- | --- |
| [Eldar–Forney, 2001, Theorem 2 and Section V](https://www.weizmann.ac.il/math/yonina/sites/math.yonina/files/quantumDetection_0.pdf) | Polar/square-root measurements and their least-squares characterization, with weighted variants. | The objective there is least-squares state-vector approximation. RC must specify the residual completion and prove its stabilized error and exact parameter-dependent extremum. The polar construction itself is not new. |
| [Kretschmann–Schlingemann–Werner, 2007, Theorem 1 and Proposition 3](https://arxiv.org/html/0710.2495) | Completely bounded distance is controlled by distances between common Stinespring dilations, and conversely after optimization. | The theorem takes two CP maps as inputs. It supplies neither the prescribed second measurement nor this exact envelope. It underlies the older dimension-free transfer; that transfer is established machinery. |
| [de la Salle, arXiv v2, Theorem 1.2](https://arxiv.org/html/2103.14126v2) | A POVM almost projective in a specified state's quadratic norm admits a nearby PVM, with a dimension-independent linear error estimate. | Its error is state-dependent and its PVM is existential. One cannot exchange “for each state there exists a PVM” with “there exists one prescribed target working for every ancilla-assisted state.” A reduction needs an actual uniform-target argument. |
| [Buscemi–Kobayashi–Minagawa, 2024, Section 2.1 and Theorem 1](https://arxiv.org/html/2303.07737v2) | Unit-eigenvalue effects characterize their sharp POVMs; measure-and-prepare implementations give repeatability. They classify maximal elements of a preprocessing resource theory. | Repeatability and its implementation are inherited. The additional question concerns the distance from a threshold-conditioned input POVM to this particular repeatable completion. |
| [Regula–Lami–Datta, v5, Appendix C, equations (170)–(175)](https://arxiv.org/html/2501.12447v5) | Sharp gentle-measurement bounds use a rank-two trace-distance calculation for a state and its filtered version. | RC's problem compares two full labelled measurement channels, with selected and residual errors constrained together. A matching rank-two witness is not itself a uniform upper theorem for that coupled class. The rank-two trace formula is not new. |
| [Regula–Takagi–Gu, 2021, Section 3, equations (12)–(14)](https://arxiv.org/html/2102.07773v3) | The diamond norm of a Hermiticity-preserving map has an exact positive-minus-positive Choi decomposition with a bound on the partial trace of the sum. | This directly supplies the norm-certificate principle used here. RC supplies a particular feasible decomposition, its closed-form Gram estimate, and a matching measurement family. See the exact substitution below. |

## Exact reduction of the channel-norm step to prior art

Let `Phi=M_E-M_F`. The constructed Kraus families satisfy

```text
K_A - K_B = 2*k*Phi,
sum A_i* A_i + sum B_i* B_i <= 2 I,
k=1/b-1/2 > 0.
```

In the Choi convention of Regula–Takagi–Gu, set
`M_+=J_(K_A)/(2*k)` and `M_-=J_(K_B)/(2*k)`.
They are positive, their difference is `J_Phi`, and their summed partial trace
is at most `I/k` (the Kraus Gram appears transposed in this convention;
transpose preserves the order bound). Equation (13) therefore gives
`||Phi||_diamond<=1/k=2*b/(2-b)`.

Thus the signed Kraus norm rule and its dimension independence are wholly
covered by that standard SDP. Lean reproves the needed inequality directly
on all complex amplified inputs; this is verification, not a new norm theorem.

The measurement-specific work preceding that substitution is:

1. Split at the common floor `c P_j`, rather than at `P_j E_j P_j`.
2. Obtain the same positive filter `C=sqrt(c) H` in the selected map and the
   residual square `G^2=U(I-C^2)U*`.
3. Combine the two signed Kraus pairs **before** estimating their Gram sum.
4. Verify, for `m<=x<=1` and `b^2+m^2=1`, the factorization
   `2-g(x)=4/b^3 (x-m)[m-(1-b)x]>=0`.
5. Realize equality by a full-sector POVM at every exact parameter pair,
   including the closed-threshold eigenvalues and the prescribed polar target.

This identifies a candidate contribution: an explicit optimal certificate
and matching family for this structured extremal problem. It does not establish
that these steps cannot be extracted from an older theorem or routine
specialization. Assessing that is the remaining novelty question.

## Search scope and outcome

Searches covered the combinations “POVM polar diamond rounding”,
“POVM perturbation repeatable diamond norm”, “measurement square-root
perturbation”, “synthesis diamond norm measurement”, “POVM residual completion
diamond”, “repeatable packing POVM”, “same-label POVM perturbation”, and
positive-filter/Schur-multiplier norm variants. Literal formula searches
were noisy and are weak evidence. Relevant primary texts above were opened
and their stated hypotheses, conclusions and norms compared; unrelated search
hits and secondary summaries were not used as theorem evidence.

Earlier [frame and fusion-frame comparisons](comparison_work/ksw_frame_notes.md)
and the [coefficient-two reduction](PRESCRIBED_BOUND_REDUCTION_2026-11-01.md)
remain applicable to those ingredients. This pass did not reproduce an
exhaustive review of every citation or operator-space monograph.

**Outcome:** no inspected theorem states the combined exact-parameter,
prescribed-completion equality. The channel-norm certificate principle has a
direct prior-art reduction. Absence of the full equality from these inspected
statements is not evidence sufficient to declare novelty, and different
hypotheses alone do not prove non-implication.

The external question should therefore be concrete: can a reviewer either
reconstruct the common-floor certificate and attaining family, identify a
counterexample, or supply a precise older theorem plus the substitutions that
recover the same target, parameter domain, norm convention and equality?
