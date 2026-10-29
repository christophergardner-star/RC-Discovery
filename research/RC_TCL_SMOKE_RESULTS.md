# RC-TCL Synthetic Conflict Smoke Test

Date: 29 October 2026

Status: **completed smoke test; not a CIFAR/ResNet result**

## Question

The first RC-TCL hypothesis was:

> strongly locked + strongly conflicting parameter modes should predict more subsequent forgetting.

That hypothesis was tested before touching the main TCL training code.

## Setup

The smoke test uses small sequential binary-classification tasks but preserves the structural pieces of canonical TCL:

- squared-gradient EMA importance,
- per-tensor normalization,
- task-end parameter anchors,
- importance-weighted quadratic memory,
- SGD with momentum,
- an RC-TCL horizon factor for each parameter direction.

Configuration:

- 80 independent task sequences,
- 5 tasks per sequence,
- 10-dimensional linear classifier,
- 256 examples,
- 18 epochs per task,
- batch size 64,
- learning rate 0.05,
- TCL lambda 0.02,
- SGD momentum 0.9,
- 240 scored transitions.

The tested score was mean over coordinates of (1-r_i) C_i, where C_i is importance-weighted anchor-conflict variance and r_i is the isolated memory horizon factor.

The operating regime was genuinely mixed rather than trivially all-locked:

- mean r_i = 0.27044,
- mean locked fraction (r_i <= 0.1) = 0.33,
- mean ambiguous fraction (0.1 < r_i < 0.9) = 0.67.

## Result

### Original forgetting prediction: not supported

Higher locked-conflict did **not** predict a larger immediate forgetting increment.

Pearson correlations:

- signed forgetting: r = -0.448, p = 2.89e-13,
- positive-only accuracy drop: r = -0.270, p = 2.29e-5.

The sign is opposite to the original hypothesis.

Interpretation: a conflicting memory penalty can resist movement during the new task, so the incremental drop in old-task accuracy need not be large. Conflict is therefore not synonymous with next-step forgetting.

### What did survive

Locked-conflict predicted worse **retained performance** and worse **joint performance**:

- post-old-task accuracy: r = -0.225, p = 4.57e-4,
- joint old+new accuracy: r = -0.312, p = 7.97e-7,
- new-task accuracy alone: r = +0.055, p = 0.40 (no detectable linear relation).

Spearman for joint accuracy was also negative: rho = -0.346, p = 3.73e-8.

So the smoke test supports a revised interpretation:

> anchor conflict is a marker of a structurally incompatible retained state, not necessarily a predictor of the next incremental forgetting step.

## Controls

### Shuffled-anchor control

Anchor coordinates were independently permuted within each stored task, destroying the real cross-task parameter correspondence while preserving each task's anchor distribution.

For joint accuracy: r = -0.045, p = 0.49.

The signal essentially disappeared.

This is evidence that the actual cross-task anchor geometry matters.

### Shuffled-importance control

Importance coordinates were independently permuted while anchors were left intact.

For joint accuracy: r = -0.286, p = 6.60e-6.

The signal remained substantial.

This is an important negative result: in this toy setting, most of the predictive information appears to come from **anchor geometry itself**, not from exact alignment with the ThermalImportance weights.

Therefore the current RC-TCL idea should not be sold as a new importance-weighting theory.

## Revised hypothesis

The next real-data test should be:

> Does anchor conflict, optionally modulated by the horizon locking factor, predict poor retained/joint accuracy in canonical TCL runs better than importance magnitude, anchor distance, or ordinary forgetting metrics alone?

Primary outcomes:

1. post-old-task accuracy,
2. joint accuracy / JAF-style retention-plasticity score,
3. per-layer retained accuracy associations,
4. incremental forgetting only as a secondary outcome.

Controls:

- anchor-coordinate shuffle,
- importance-coordinate shuffle,
- unweighted anchor variance,
- EWC anchor/Fisher analogue,
- ordinary parameter displacement.

## Conclusion

The first falsifiable RC-TCL prediction was partially refuted rather than confirmed.

That is useful.

The smoke test says the promising object is not "idempotence predicts forgetting." It is:

**stable memory can encode mutually incompatible anchors, and that incompatibility tracks poorer retained/joint performance.**

The full claim remains unestablished until tested on canonical TCL checkpoints from real continual-learning runs.

Reproduce with:

python experiments/rc_tcl_conflict_smoke.py
