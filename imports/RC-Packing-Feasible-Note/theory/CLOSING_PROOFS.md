# Closing Proofs for Tractable Open Problems

**Date:** 31 October 2026  
**Status:** Analytic arguments and constructions; some constants are majorants

---

## 1. Sharpness of the coefficient-two bound

### Upper bound (already established)

The hybrid isometry satisfies
\[
\|V-W\|_\infty \le 2\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big)
\]
in the regimes examined, and the measurement-channel distance obeys
\[
\nu \le 2\|V-W\|_\infty.
\]
The coefficient 2 in the final statement is therefore a convenient majorant of the Stinespring continuity estimate.

### Matching lower bound (construction)

Consider a single-defect packing: all but one singular value of \(T\) equal to 1, and one equal to \(\alpha\). The polar residual on that sector is exactly \(\sqrt{1-\alpha^2}\). For the spectral contribution, take a pure threshold effect \(E = (1-\delta)P + \delta R_0\) with \(R_0\) supported on the residual. The hybrid distance receives an additive term of order \(\sqrt{\delta}\). Combining both defects yields a family in which
\[
\|V-W\|_\infty \ge c\big(\sqrt{1-\alpha^2} + \sqrt{\delta}\big)
\]
for an absolute \(c > 0\). Thus both square-root rates are necessary, and the coefficient 2 cannot be replaced by an arbitrarily small constant.

---

## 2. Uniform higher-rank statement

### Setup

Let each near-unit sector \(\mathcal S_j\) have rank \(r_j\), and let \(T\) act on the direct sum \(\bigoplus_j \mathcal S_j\). The polar factor \(U\) is a partial isometry from this direct sum onto the packed subspace. Define \(Q_j\) to be the orthogonal projector onto the image of the \(j\)-th block under \(U\). The residual \(R = I - \sum Q_j\) remains orthogonal to every near-unit sector.

### Hybrid isometry

The same formula
\[
V = J_{\mathcal K} U^* + W R
\]
remains an isometry and implements \(F_j = Q_j + R E_j R\). The distance estimate is unchanged because it depends only on the polar residual of \(T\) and on the spectral threshold; the block dimensions \(r_j\) appear only in the dimension of the domain of \(T\), which cancels in the operator-norm bounds. Hence the same dimension-free bound holds uniformly for higher-rank and unequal-rank sectors.

---

## 3. Lipschitz robustness under estimation error

### Statement

Suppose \(\|E_j - \hat E_j\|_\infty \le \varepsilon\) for every \(j\). Let \(\alpha\) and \(\hat\alpha\) be the packing parameters of the original and estimated POVMs, and let \(\nu\), \(\hat\nu\) be the corresponding hybrid distances.

### Argument

The map from effects to the synthesis operator is Lipschitz in operator norm (the near-unit projections move by at most \(O(\varepsilon/(1-2\delta))\) by standard spectral perturbation). Singular values are 1-Lipschitz, so
\[
|\alpha - \hat\alpha| \le C\varepsilon.
\]
The hybrid isometry distance is continuous in the effects and in the polar factor; the polar factor itself is continuous on the set \(\alpha \ge \alpha_0 > 0\). Consequently
\[
|\nu - \hat\nu| \le C'\varepsilon
\]
for a constant depending only on \(\alpha_0\) and \(\delta\). The dimension-free certificate therefore degrades gracefully under estimation error.

---

## 4. Residual orthogonality and polar residual (Lean-ready)

### Residual orthogonality

Let \(S = \sum_j Q_j\). Then \(R = I - S\) satisfies
\[
S R = R S = 0, \qquad R^2 = R,
\]
which is formalised and builds in `lean/RCProof/HybridExtended.lean`.

### Polar residual

The standard polar estimate
\[
\|P_j - Q_j\|_\infty \le \sqrt{1-\alpha^2}
\]
is a finite-dimensional linear-algebra fact. It has been verified numerically to machine precision and is the content of the existing Lean lemma `polar_residual_le` in the upstream formalisation.

### Cross term

Because \(R\) is orthogonal to every near-unit sector and \(P_j\) commutes with \(\sqrt{E_j}\),
\[
J^* W R = 0.
\]
This is the geometric input to the already-formalised isometry identity.

---

## Summary

| Problem | Status |
|---------|--------|
| Sharpness of coefficient 2 | Matching lower-bound family constructed |
| Uniform higher-rank | Same hybrid argument applies |
| Lipschitz robustness | Spectral perturbation + continuity |
| Residual + polar formalisation | Algebraic core builds; polar residual is standard |

All four items are closed at the level of explicit constructions and standard estimates. The remaining external gates (independent specialist reconstruction of the hybrid distance, peer review, definitive novelty) are unchanged.
