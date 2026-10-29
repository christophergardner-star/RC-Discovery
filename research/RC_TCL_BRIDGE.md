# RC–TCL Bridge Pilot

Updated: 29 October 2026

Status: **derived diagnostic / application bridge; novelty unverified**

This note connects the RC stability programme to the canonical Thermodynamic Continual Learning (TCL) memory regularizer in:

`christophergardner-star/Thermodynamic-Continual-Learning-delivered`

The purpose is not to claim that the quantum RC theorem automatically applies to neural networks. It does not. The useful observation is that TCL's frozen quadratic memory penalty has an exactly solvable affine dynamics, so an RC-style "almost idempotent -> nearest exact projection" diagnostic can be derived directly in the classical parameter space.

## 1. TCL memory penalty

For stored tasks (t=1,dots,T), TCL uses

[
L_{\rm mem}(\theta)
=
\lambda
\sum_t w_t
\sum_i I_i^{(t)}
(\theta_i-\theta_i^{(t)})^2,
]

where:

- (\theta^{(t)}) is the task-end checkpoint,
- (I^{(t)}\ge 0) is the per-parameter ThermalImportance map,
- (w_t) is the task-decay weight,
- (\lambda) is `lambda_tcl`.

For one coordinate define

[
A_i=\sum_t w_t I_i^{(t)}.
]

If (A_i>0), define the importance-weighted anchor barycentre

[
\mu_i
=
\frac{\sum_t w_t I_i^{(t)}\theta_i^{(t)}}{A_i}.
]

Then

[
L_{\rm mem}
=
\lambda\sum_i A_i(\theta_i-\mu_i)^2
+
\lambda\sum_i A_i C_i,
]

where

[
C_i
=
\frac{1}{A_i}
\sum_t w_t I_i^{(t)}
(\theta_i^{(t)}-\mu_i)^2
]

is the **anchor-conflict variance**.

The second term is constant in (\theta). It is the irreducible disagreement among the task records at that parameter.

## 2. Exact affine consolidation map

Isolate the TCL penalty and take one plain-SGD probe step of size (h):

[
F(\theta)=\theta-h\nabla L_{\rm mem}(\theta).
]

Then coordinatewise,

[
F_i(\theta)
=
\mu_i+d_i(\theta_i-\mu_i),
\qquad
d_i=1-2h\lambda A_i.
]

After (K) repeated probe steps,

[
F_i^K(\theta)
=
\mu_i+r_i(\theta_i-\mu_i),
\qquad
r_i=d_i^K.
]

Assume (0\le r_i\le1).

The nearest coordinatewise idempotent affine map chooses

[
p_i=
\begin{cases}
0,&r_i\le1/2,\\
1,&r_i>1/2,
\end{cases}
]

so the rounded map either:

- locks the coordinate exactly to the anchor barycentre ((p_i=0)), or
- leaves the coordinate exactly free ((p_i=1)).

In Euclidean operator norm,

[
\delta_K
=
\min_P\|F^K-P\|
=
\max_i \min(r_i,1-r_i).
]

The idempotence defect is

[
\eta_K
=
\|F^{2K}-F^K\|
=
\max_i r_i(1-r_i).
]

Since (x(1-x)) is monotone for (x\in[0,1/2]),

[
\boxed{
\delta_K
=
\frac{1-\sqrt{1-4\eta_K}}{2}
}
]

for this diagonal affine class.

This is an elementary spectral-rounding identity, not currently claimed as new mathematics.

## 3. Why one-step idempotence is misleading

For canonical TCL, the per-step correction is deliberately small.

A tiny step gives (d_i\approx1), therefore

[
d_i(1-d_i)\ll1
]

even when the memory force is too weak to protect anything.

So a one-step "idempotence defect" can be small for the wrong reason: the update is almost the identity.

The useful RC-TCL object is therefore the **task-horizon map**, not the individual optimizer step.

This is the classical analogue of the RC lesson that local near-repeatability is not by itself enough.

## 4. Canonical Split-CIFAR-10 pilot

Current canonical benchmark settings in the TCL repository are:

- base learning rate (h=0.01),
- TCL penalty coefficient (\lambda=0.01),
- batch size (64),
- 40 epochs per task,
- approximately 10,000 training examples per Split-CIFAR-10 task,
- default optimizer backend: SGD with momentum (m=0.9).

This gives approximately

[
K=\lceil10000/64\rceil\times40=6280
]

updates per task.

### Plain-SGD probe

For one task with normalized importance (A\in[0,1]),

[
r(A)=(1-0.0002A)^{6280}.
]

Selected values:

| (A) | horizon factor (r(A)) |
|---:|---:|
| 0.01 | 0.9875 |
| 0.05 | 0.9391 |
| 0.10 | 0.8820 |
| 0.20 | 0.7779 |
| 0.50 | 0.5336 |
| 1.00 | 0.2848 |

The 50% rounding boundary (r=0.5) occurs at

[
A\approx0.55184.
]

Thus, without momentum, only the upper half of the normalized importance spectrum would fall on the "anchor-locked" side over one task horizon.

### Momentum-aware isolated probe

Canonical benchmark code uses SGD momentum (m=0.9).

For the isolated quadratic memory term with fresh zero momentum, define (e_k=\theta_k-\mu). The exact state recurrence is

[
\begin{bmatrix}
e_{k+1}\\
v_{k+1}
\end{bmatrix}
=
\begin{bmatrix}
1-2h\lambda A & -hm\\
2\lambda A & m
\end{bmatrix}
\begin{bmatrix}
e_k\\
v_k
\end{bmatrix}.
]

Using the same (K=6280) horizon gives:

| (A) | (e_K/e_0) |
|---:|---:|
| 0.01 | 0.8821 |
| 0.05 | 0.5338 |
| 0.10 | 0.2846 |
| 0.20 | 0.0806 |
| 0.50 | 0.00178 |
| 1.00 | 0.00000279 |

The 50% boundary becomes

[
A\approx0.05521.
]

Other useful thresholds:

[
r\le0.9 \Rightarrow A\gtrsim0.00840,
]

[
r\le0.1 \Rightarrow A\gtrsim0.18295,
]

[
r\le0.01 \Rightarrow A\gtrsim0.36462.
]

This says the isolated TCL penalty is capable of producing a strong locked/free spectral split over a full task horizon even though its individual updates are tiny.

Caveat: this is not yet a certificate for the full training trajectory. Task gradients, weight decay, nonlinear network curvature, BatchNorm state and nonzero optimizer momentum generated by the task loss are omitted.

## 5. New diagnostic: anchor conflict

The stronger RC-style observation is that **stability is not enough**.

Suppose two previous tasks assign maximum importance to one coordinate but store opposite anchors:

[
\theta^{(1)}=-1,\qquad
\theta^{(2)}=+1,\qquad
I^{(1)}=I^{(2)}=1.
]

Then

[
A=2,\qquad
\mu=0,\qquad
C=1.
]

Under the canonical momentum-aware isolated horizon the contraction factor is about

[
4.6\times10^{-12}.
]

So the coordinate is essentially perfectly stable — but stable around (0), a compromise requested by neither task.

This is the TCL analogue of RC's global packing lesson:

> A process can be strongly stable while its stored records are mutually incompatible.

For TCL this suggests that a useful certificate needs **two axes**:

1. **dynamical rounding:** do modes become cleanly locked or free?
2. **record consistency:** do the anchors of the locked modes actually agree?

A practical RC-TCL report should therefore include:

- horizon factors (r_i),
- idempotence defect (\eta_K),
- distance to the nearest locked/free projector (\delta_K),
- locked / free / ambiguous fractions,
- anchor-conflict variance (C_i),
- conflict mass restricted to strongly locked coordinates.

## 6. Immediate experimental prediction

The diagnostic makes a falsifiable prediction:

> Forgetting should be worst when a parameter direction is simultaneously strongly locked (small (r_i)) and high-conflict (large (C_i)).

Conversely, high-conflict directions should ideally remain plastic, be routed to separate subspaces, or have their memory weight reduced.

This can be tested on existing TCL runs by serialising the per-task `ThermalCheckpoint` importance maps and anchors, then correlating:

[
(1-r_i)C_i
]

or a layer-aggregated version with subsequent per-task forgetting.

If that correlation survives across seeds and datasets, RC has contributed a new **diagnostic variable** to TCL rather than merely relabelling an existing penalty.

## 7. Relationship to prior work

Idempotence is already present in continual-learning research.

Liu et al., **IDER: IDempotent Experience Replay for Reliable Continual Learning**, ICLR 2026, enforce idempotence in model outputs and an idempotence-distillation objective.

Projection-based continual learning and quadratic importance penalties are also established.

Therefore no novelty claim is made for "idempotence in continual learning", projection operators, or quadratic anchor penalties.

The potentially distinct RC-TCL contribution is narrower:

- treat the **memory/consolidation operator itself** as the object to certify,
- use a task-horizon rather than one-step idempotence defect,
- combine dynamical rounding with an explicit **anchor-conflict** quantity,
- test whether locked high-conflict modes predict forgetting.

A deeper literature veto is still required before calling that formulation novel.

## 8. Next experiment

Instrument `tcl_canonical` to export, after every task:

- checkpoint anchors,
- normalized importance tensors,
- task-decay weights,
- optimizer settings,
- number of updates in the following task.

Then compute the RC-TCL spectrum and conflict metrics before training the next task.

Primary test:

[
\mathrm{corr}(\text{locked-conflict mass},\text{subsequent forgetting}).
]

Controls:

- SGD baseline,
- EWC,
- canonical TCL,
- shuffled-anchor conflict,
- importance-shuffled control.

No main TCL code has been changed by this pilot.

Companion calculator:

`experiments/rc_tcl_certificate.py`
