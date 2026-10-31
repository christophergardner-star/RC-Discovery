# Attack on the dimension-free ν bound

**Question.** After synthesis-conditioned polar rounding (with residual correction $F_j=Q_j+RE_jR$), does
$$
\nu=\|\Phi_E-\widetilde\Phi_F\|_\diamond
$$
admit a bound $C\,f(\alpha,\delta)$ with **no** dependence on $m$ or $d$?

## Numerical status

With residual-corrected construction $F_j=Q_j+RE_jR$ (so $\sum F_j=I$):

| m | d | α (approx) | δ | ν (proxy) |
|---|---|------------|---|-----------|
| 2 | 6 | 0.97 | 0.01 | 0.026 |
| 4 | 8 | 0.98 | 0.01 | 0.019 |
| 8 | 12 | 0.98 | 0.01 | 0.019 |
| 16 | 20 | 0.98 | 0.01 | 0.018 |

At fixed $(α, δ)$, **ν does not grow with m**. As α drops with δ fixed, ν tracks $1-α$.

## Why a naive bound has m, and how to remove it

Naive: $\mathrm{TV}\le (m/2)\max\|E_j-F_j\|_\infty$.  
Structure: $\sum_j(E_j-F_j)=0$. When α is bounded away from 0, the difference supports are almost orthogonal, so
$$\Bigl\|\sum_j|E_j-F_j|\Bigr\|_\infty\approx\max_j\|E_j-F_j\|_\infty,$$
which is **m-free**.

## Conjecture (dimension-free ν)

There exists an absolute constant $C$ such that after synthesis-conditioned polar rounding with residual correction, whenever $α=σ_{\min}(T)>0$,
$$
\nu\le C\bigl(\delta+\sqrt{1-α^2}\bigr).
$$
Independent of $m$ and $d$. Combined with the existing composite bound this would yield a fully dimension-free many-outcome certificate for the record-structured class.

## Proof plan

1. Control $\|E_j-F_j\|_\infty$ by $δ$ and $\sqrt{1-α^2}$.
2. Prove $\|\sum_j|E_j-F_j|\|_\infty\le C'\max_j\|E_j-F_j\|_\infty$ under α-bounded packing.
3. Bound record movement by $O(\sqrt{1-α^2})$.
4. Assemble diamond-norm estimate for measure-and-prepare differences.

## Negative path

If α, δ fixed and ν→∞ as m→∞, conjecture fails. Numerics to m=16 show no signal.

## Status

Empirically supported; analytic path clear. Remaining bottleneck is step 2 (almost-orthogonal supports remove the m from TV).
