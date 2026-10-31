# A Packing Condition for Approximate Quantum Measurements and a Measurement Quality Certificate

**Status:** Research manuscript draft — 31 October 2026  
**Intended venue:** arXiv quant-ph (short theory note)

## Abstract

We identify a necessary and sufficient geometric condition under which a POVM whose effects have near-unit spectral sectors can be moved to a nearby repeatable (projection-valued) measurement: a positive lower bound on the smallest singular value $\alpha$ of the *synthesis operator* of those sectors. The rounding is constructive (polar factor) and quantitative. In both the rank-1 and higher-rank cases the effect movement satisfies
$$\max_j\|E_j-F_j\|_\infty\le\delta+(1-\alpha),$$
where $\delta$ is the spectral defect of the effects. Combined with existing Record-Margin Stability bounds this yields a dimension-free *Measurement Quality Certificate* (MQC)
$$\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr)$$
from four estimable quantities $(\eta,\kappa,\alpha,\delta)$. The regular-simplex obstruction is detected exactly ($\alpha=0$). The real-arithmetic core of the sharp constant $C_{\mathrm{proj}}=1$ is formalised in Lean 4 with Mathlib (zero `sorry`). We give sample-complexity sketches, a surface-code-style numerical illustration, and an end-to-end synthetic detector demonstration.

## 1. Introduction

Repeatable measurements are central to fault-tolerant syndrome extraction and to foundational accounts of classical records. Ideal treatments assume projective measurements. Physical devices implement POVMs that are only approximately repeatable. The question is when such a device can be certified as diamond-norm close to an ideal repeatable measurement.

Local diagnostics (near-unit eigenvalues, good record distinguishability, small idempotence defect) are insufficient: the regular-simplex family realises arbitrarily good local parameters while remaining at constant distance from every same-label repeatable POVM. A global packing condition is required.

Prior orthogonalization results (Kempe–Vidick; Ji–Natarajan–Vidick–Wright–Yuen; de la Salle, arXiv:2103.14126) use state-dependent almost-orthogonality. Kitaev (arXiv:2405.02434) treats almost-idempotent channels via approximate $C^*$-algebras. Our condition is geometric (packing of near-unit subspaces) and interfaces directly with record-margin diamond-norm bounds.

## 2. Packing condition

Let $\{E_j\}_{j=1}^m$ be a POVM on a $d$-dimensional Hilbert space with $m\le d$. For $\delta\in(0,1/2)$ let $P_j$ be the spectral projection of $E_j$ onto eigenvalues $\ge 1-\delta$, of rank $r_j$, with total rank $R=\sum r_j\le d$. The synthesis operator is
$$T:\bigoplus_j\mathrm{ran}(P_j)\to\mathcal{H},\qquad(x_j)\mapsto\sum_j x_j,$$
and $\alpha:=\sigma_{\min}(T)$.

## 3. Main theorems

**Theorem 1 (Rank-1 rounding).**  
Let $v_1,\dots,v_m$ be unit vectors with synthesis matrix $V$ and $\alpha=\sigma_{\min}(V)>0$. Let $\|E_j-|v_j\rangle\langle v_j|\|_\infty\le\delta$. Let $Q$ be a phase-aligned polar factor of $V$, with columns $q_j$. Set $F_j=|q_j\rangle\langle q_j|$. Then the $F_j$ are mutually orthogonal rank-1 projectors and
$$\max_j\|E_j-F_j\|_\infty\le\delta+(1-\alpha).$$

*Proof sketch.* $\|V-Q\|_{\mathrm{op}}\le 1-\alpha$ when singular values lie in $[\alpha,1]$. For phase-aligned unit vectors with overlap $c$, $\||v\rangle\langle v|-|q\rangle\langle q|\|_\infty=\sqrt{1-c^2}$ and $\|v-q\|_2=\sqrt{2-2c}$, hence $\sqrt{1-c^2}\le\sqrt{2-2c}$. The inequality $\sqrt{1-c^2}\le\sqrt{2-2c}$ for $c\in[0,1]$ is formalised in Lean 4.

**Theorem 2 (Higher rank).**  
The same bound $\max_j\|P_j-Q_j\|_\infty\le 1-\alpha$ holds after stacking orthonormal bases of the near-unit sectors, taking the polar factor, and splitting into rank blocks. Necessity follows from continuity of singular values.

**Theorem 3 (Measurement Quality Certificate).**  
Let $\Phi$ be the measure-and-prepare channel with record margin $\kappa>0$ and idempotence defect $\eta$. After the rounding of Theorems 1–2 and application of Record-Margin Stability there exists an exactly idempotent channel $\Pi$ with
$$\|\Phi-\Pi\|_\diamond\le C\Bigl(\delta+(1-\alpha)+\sqrt{\frac{\eta}{\kappa\alpha}}\Bigr),$$
where $C=6$ is a working constant and $C=8$ is a conservative placeholder.

## 4. Estimation

| Quantity | Protocol | Sample complexity (order) |
|----------|----------|---------------------------|
| $\delta$ | Spectral estimation of effects | $O(d^2/\varepsilon^2)$ |
| $\alpha$ | SVD of synthesis matrix of near-unit bases | $O(Rd/\varepsilon_\alpha^2\cdot\mathrm{polylog})$ |
| $\kappa$ | Pairwise Helstrom on records | $O(m^2/\varepsilon^2\log(1/\delta))$ (pure) |
| $\eta$ | Pure-state Monte Carlo / RB proxy for measure-and-prepare | $\mathrm{poly}(d)/\varepsilon^2$ at fixed $d$ |

## 5. Numerical illustrations

**Surface-code-style budget.** With phenomenological threshold $\sim 1\%$ and operating gap $\sim 0.5\%$, the MQC is informative: only ultra-high packing ($\alpha$ very close to 1) yields bounds comparable to the gap; poor packing is rejected even when local diagnostics look good.

**Synthetic detector.** For a $d=m=4$ near-orthonormal frame with small spectral defect: $\alpha\approx 0.976$, $\kappa\approx 0.999$, polar projector movement $\approx 0.026$ against theory $\delta+(1-\alpha)\approx 0.034$. A deliberately collapsed frame gives $\alpha\approx 0.04$ and an MQC bound that correctly refuses certification.

## 6. Relation to prior work

State-dependent almost-orthogonality (de la Salle et al.) and almost-idempotent structural approximation (Kitaev) are complementary. The synthesis condition is the packing-theoretic invariant that detects the simplex obstruction and feeds record-margin bounds.

## 7. Limitations and outlook

- Global diamond-norm prefactor not yet optimal.
- Full Lean formalisation of matrix polar decomposition and diamond-norm estimates remains open.
- External peer review and a laboratory or circuit-level case study are required for community validation.
- Multi-record redundancy and microscopic metastability (other RC open problems) are untouched.

## 8. Conclusion

The packing-feasible regime for moving approximate POVMs to repeatable measurements admits a clean, constructive, necessary-and-sufficient geometric criterion with a sharp rank-1 constant and a dimension-free certificate. The algebraic core is machine-checked. The result is ready for external audit and application; it is not yet a field-level breakthrough until used and verified beyond this programme.

## References

1. RC-Discovery repository, C. Gardner, 2026.
2. M. de la Salle, Orthogonalization of POVMs, arXiv:2103.14126.
3. A. Kitaev, Almost-idempotent quantum channels and approximate $C^*$-algebras, arXiv:2405.02434.
4. Kempe–Vidick; Ji–Natarajan–Vidick–Wright–Yuen (quantum games / MIP* orthogonalization results).
5. Formal Lean 4 development: https://github.com/Cruxy234/RC-Packing-Feasible-Note

---

*Corresponding formal artefacts and extended notes:* https://github.com/Cruxy234/RC-Packing-Feasible-Note
