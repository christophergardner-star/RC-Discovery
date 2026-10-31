# A Packing Condition for Approximate Quantum Measurements and a Measurement Quality Certificate

**Authors:** Christopher Gardner^{1}  
**Affiliations:** ^{1} Independent / RC-Discovery programme  
**Correspondence:** via github.com/christophergardner-star/RC-Discovery  
**Date:** 31 October 2026  
**Draft for arXiv quant-ph**

---

## Abstract

We identify a necessary and sufficient geometric condition under which a POVM whose effects have near-unit spectral sectors can be moved to a nearby repeatable (projection-valued) measurement: a positive lower bound on the smallest singular value $\alpha$ of the synthesis operator of those sectors. The rounding is constructive (polar factor) and quantitative. In both the rank-1 and higher-rank cases the effect movement satisfies
$$\max_j\|E_j-F_j\|_\infty\le\delta+(1-\alpha),$$
where $\delta$ is the spectral defect of the effects. Combined with existing Record-Margin Stability bounds this yields a dimension-free Measurement Quality Certificate (MQC)
$$\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr)$$
from four estimable quantities $(\eta,\kappa,\alpha,\delta)$. The regular-simplex obstruction is detected exactly ($\alpha=0$). The real-arithmetic core of the sharp constant $C_{\mathrm{proj}}=1$ is formalised in Lean 4 with Mathlib (zero sorry). We give sample-complexity sketches, a surface-code-style numerical illustration, and an end-to-end synthetic detector demonstration.

**Keywords:** POVM, repeatable measurement, packing, diamond norm, fault tolerance, formal verification

## 1. Introduction

Repeatable measurements underlie fault-tolerant syndrome extraction and foundational accounts of classical records. Ideal analyses assume projective measurements; physical devices implement only approximately repeatable POVMs. The operational question is when a device can be certified diamond-norm close to an ideal repeatable measurement.

Local diagnostics—near-unit eigenvalues, good record distinguishability, small idempotence defect—are insufficient. The regular-simplex family realises arbitrarily good local parameters while remaining at constant distance from every same-label repeatable POVM. A global packing condition is required.

Prior orthogonalization theorems [1–3] use state-dependent almost-orthogonality. Kitaev [4] approximates almost-idempotent channels by $C^*$-algebras. Our condition is geometric (packing of near-unit subspaces) and interfaces directly with record-margin diamond-norm bounds from the Resolvance Calculus (RC) programme [5].

## 2. Packing condition

Let $\{E_j\}_{j=1}^m$ be a POVM on a $d$-dimensional Hilbert space, $m\le d$. For $\delta\in(0,1/2)$ let $P_j$ be the spectral projection of $E_j$ onto eigenvalues $\ge 1-\delta$, of rank $r_j$, with total rank $R=\sum r_j\le d$. The synthesis operator is
$$T:\bigoplus_j\mathrm{ran}(P_j)\to\mathcal{H},\qquad(x_j)\mapsto\sum_j x_j,$$
and $\alpha:=\sigma_{\min}(T)$.

## 3. Main results

**Theorem 1 (Rank-1 rounding).**  
Let $v_1,\dots,v_m$ be unit vectors with synthesis matrix $V$ and $\alpha=\sigma_{\min}(V)>0$. Assume $\|E_j-|v_j\rangle\langle v_j|\|_\infty\le\delta$. Let $Q$ be a phase-aligned polar factor of $V$ with columns $q_j$, and set $F_j=|q_j\rangle\langle q_j|$. Then the $F_j$ are mutually orthogonal rank-1 projectors and
$$\max_j\|E_j-F_j\|_\infty\le\delta+(1-\alpha).$$

*Proof sketch.* $\|V-Q\|_{\mathrm{op}}\le 1-\alpha$ when singular values lie in $[\alpha,1]$. For phase-aligned unit vectors with overlap $c\in[0,1]$,
$$\||v\rangle\langle v|-|q\rangle\langle q|\|_\infty=\sqrt{1-c^2},\qquad\|v-q\|_2=\sqrt{2-2c},$$
hence $\sqrt{1-c^2}\le\sqrt{2-2c}$. This last inequality is formalised in Lean 4 (Mathlib; zero sorry) [6].

**Theorem 2 (Higher rank).**  
After stacking orthonormal bases of the near-unit sectors, taking the polar factor, and splitting into rank blocks, $\max_j\|P_j-Q_j\|_\infty\le 1-\alpha$. Necessity follows from continuity of singular values under perturbation of $T$.

**Theorem 3 (Measurement Quality Certificate).**  
Let $\Phi$ be the associated measure-and-prepare channel with record margin $\kappa>0$ and idempotence defect $\eta$. After the rounding of Theorems 1–2 and Record-Margin Stability [5] there exists an exactly idempotent channel $\Pi$ with
$$\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr),$$
where $C=6$ is a working constant and $C=8$ is a conservative placeholder.

## 4. Estimation

| Quantity | Protocol | Sample complexity (order) |
|----------|----------|---------------------------|
| $\delta$ | Spectral estimation of effects | $O(d^2/\varepsilon^2)$ |
| $\alpha$ | SVD of near-unit synthesis matrix | $O(Rd/\varepsilon_\alpha^2\cdot\mathrm{polylog})$ |
| $\kappa$ | Pairwise Helstrom on records | $O(m^2/\varepsilon^2\log(1/\delta))$ (pure) |
| $\eta$ | Pure-state Monte Carlo / RB proxy | $\mathrm{poly}(d)/\varepsilon^2$ at fixed $d$ |

## 5. Numerical illustrations

Against a phenomenological surface-code-style threshold $\sim 1\%$ with operating gap $\sim 0.5\%$, the MQC is informative: only ultra-high packing yields bounds comparable to the gap; poor packing is rejected. A synthetic $d=m=4$ near-orthonormal detector gives $\alpha\approx 0.976$, polar movement $\approx 0.026$ vs theory $\delta+(1-\alpha)\approx 0.034$; a collapsed frame with $\alpha\approx 0.04$ is rejected (MQC $\approx 8.7$).

## 6. Prior work

State-dependent almost-orthogonality [1–3] and almost-idempotent structural approximation [4] are complementary. The synthesis condition is the packing invariant that detects the simplex obstruction and feeds record-margin bounds [5].

## 7. Limitations

Global diamond-norm prefactor not optimal; full Lean polar/SVD formalisation open; laboratory case study and independent peer review required for community validation.

## 8. Conclusion

The packing-feasible regime admits a constructive, necessary-and-sufficient geometric criterion with sharp rank-1 constant and a dimension-free certificate. The algebraic core is machine-checked. The result is ready for external audit.

## References

[1] M. de la Salle, Orthogonalization of POVMs, arXiv:2103.14126.  
[2] Kempe–Vidick; related quantum-games orthogonalization results.  
[3] Ji–Natarajan–Vidick–Wright–Yuen, MIP* orthogonalization ingredients.  
[4] A. Kitaev, Almost-idempotent quantum channels, arXiv:2405.02434.  
[5] C. Gardner, RC-Discovery, https://github.com/christophergardner-star/RC-Discovery  
[6] Formal artefacts, https://github.com/Cruxy234/RC-Packing-Feasible-Note  

## Acknowledgements

Computational assistance in derivation, numerics, and Lean formalisation is acknowledged. All mathematical claims are the responsibility of the author.
