# Definitive Conclusion: Dimension-Free Packing-Conditioned Rounding

**Date:** 31 October 2026  
**Status:** Internally closed theorem candidate; independent audit of the Naimark step required  
**Primary reference:** `theory/dimension_free_nu_via_naimark.md` in christophergardner-star/RC-Discovery

---

## Statement

Let \(\{E_j\}_{j=1}^m\) be a POVM on a finite-dimensional Hilbert space \(\mathcal H\) of dimension \(d\), with near-unit spectral sectors of total rank \(R \le d\). Let \(T\) be the synthesis operator of those sectors and set

\[
\alpha = \sigma_{\min}(T) > 0.
\]

Let \(\delta \in (0,1/2)\) be a spectral threshold such that each near-unit sector of \(E_j\) lies in eigenvalues \(\ge 1-\delta\).

**Construction (Naimark + residual-to-extra-outcome).**

1. Form the polar isometry \(U\) of \(T\). The sectors \(Q_j = U R_j U^*\) are mutually orthogonal projectors.
2. Extend the labelled isometry on the packed subspace to a full isometry \(V\) via the Naimark/Stinespring construction of `dimension_free_nu_via_naimark.md`, routing any residual mass into an additional outcome label \(m+1\).
3. Define the completed POVM by
   \[
   F_j = Q_j \quad (j=1,\dots,m), \qquad F_{m+1} = I - \sum_{j=1}^m Q_j.
   \]

**Properties.**

- Each \(F_j\) for \(j \le m\) is an exact orthogonal projector. Consequently the repeatability spectral gap satisfies
  \[
  \gamma_F = 1
  \]
  exactly, with no dependence on \(\alpha\), \(\delta\), \(m\), or \(d\).
- The measurement-channel distance between the original POVM and the completed POVM satisfies the dimension-free bound of the Naimark theorem candidate:
  \[
  \nu := \|\mathcal M_E - \mathcal M_F\|_\diamond \le 2\sqrt{\varepsilon^2 + h(\varepsilon)^2},
  \]
  where
  \[
  \varepsilon^2 \le 2\beta + 2 r_\delta M, \qquad
  \beta \le \max\{1-\alpha,\,(1-\delta)^{-1/2}-1\}, \qquad
  r_\delta = 1-\sqrt{1-\delta}, \qquad
  M \le (1-\delta)^{-1/2},
  \]
  and \(h(\varepsilon) = \varepsilon + 1 - \sqrt{1-\varepsilon^2}\) (for \(\varepsilon < 1\)). Asymptotically,
  \[
  \nu = O\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big).
  \]
  The bound contains no factor of \(m\) or \(d\). The square-root dependence on \(\delta\) is sharp in general (matching the known adversarial family).

**Composite certificate.**

Let \(\Phi_E\) be a measure-and-prepare channel using the original POVM, with record margin \(\kappa > 0\) and idempotence defect \(\eta = \|\Phi_E^2 - \Phi_E\|_\diamond\). After the move above, the spectral-gap Record-Margin theorem applies with \(\gamma_F = 1\) and yields an exactly idempotent channel \(\Pi\) such that

\[
\boxed{
\|\Phi_E - \Pi\|_\diamond
\le
\nu + \sqrt{\frac{2(\eta + 3\nu)}{\kappa}}.
}
\]

All quantities on the right-hand side are controlled by packing, spectral, and record data with no outcome-count or Hilbert-space dimension factors.

---

## What is proved versus what remains to be audited

| Component | Status |
|-----------|--------|
| Polar synthesis \to orthogonal \(Q_j\) | Standard linear algebra; numerically stress-tested |
| Naimark overlap identity and \(\varepsilon\) bound | Internally derived; independent audit required |
| Extension to full isometry \(V\) and \(\nu\) bound | Internally derived; independent audit required |
| Residual-to-extra-outcome \(\Rightarrow \gamma_F = 1\) | Immediate from the definition of \(F_j = Q_j\) |
| Composition with Record-Margin Stability | Uses the existing RC theorem as a black box |
| Lean formalisation of the Hilbert-space / channel steps | Open |

The only non-elementary step whose correctness is not yet externally verified is the Naimark isometry construction and the resulting bound on \(\nu\). Once that step is audited, the dimension-free many-outcome certificate above follows by the residual-to-extra-outcome route.

---

## Same-label versus extra-outcome

The construction above enlarges the classical outcome alphabet by one (the residual/reject outcome). This is sufficient for an existence theorem: there exists a nearby repeatability-admissible measurement process whose diamond distance to the original is dimension-free.

If the application requires the original outcome labels only, residual mass must be folded back into the existing \(F_j\). In that case \(\gamma_F\) is no longer automatically 1 and must either be retained as an explicit parameter or bounded by a separate argument. The existence result does not require this.

---

## Final assessment

The packing-conditioned, record-structured subclass of approximate measurements admits a fully dimension-free and outcome-count-independent diamond-norm certificate of closeness to an exactly idempotent record process, contingent on independent verification of the Naimark isometry step. This is the precise mathematical content that the RC programme has reached.

It is a theorem candidate of publishable form. It is not yet an externally audited theorem.
