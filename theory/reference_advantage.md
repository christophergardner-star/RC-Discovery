# Exact reference advantage for a prescribed completion

1 November 2026. Computer-assisted mathematical result, internally checked;
not externally reviewed or established as new in the literature.

## Statement

There is a rational complex POVM on \(\mathbb C^{10}\), with eight outcomes,
full rank-one sectors at threshold \(1-\delta\), \(\delta=17/100\), and
\(\alpha=1\), whose prescribed completion \(F_j=P_j+RE_jR\) satisfies

\[
\sup_{\rho\in\mathcal D(\mathbb C^{10})}
\sum_j|\operatorname{Tr}((E_j-F_j)\rho)|
\le\frac{1161}{10000}
<\frac{151}{1250}
\le\|\mathcal M_E-\mathcal M_F\|_\diamond.
\tag{1}
\]

The reference advantage is therefore at least \(47/10000\). This is a
strict separation, not an assertion of the exact value of either distance.
It shows that the system-only attaining family in the
[sharp perfect-packing theorem](perfect_packing_sharpness.md) does not
justify discarding reference systems for arbitrary POVMs in that subclass.

## Specified rational example

The [certificate](../research/reference_advantage_2026-11-01/certificate.json)
is part of the statement: it specifies all eight effects by integer real
and imaginary entries divided by a positive integer. Indices are zero-based.
Set \(P_j=|j\rangle\langle j|\), \(0\le j<8\), and
\(R=|8\rangle\langle8|+|9\rangle\langle9|\). The target is exactly
\(F_j=P_j+RE_jR\); it is computed from the effects rather than independently
rounded.

This is a rationalized, slightly regularized version of the earlier numerical
example, not an exact claim about its floating-point matrices. A commuting
POVM mixed in with weight \(1/100\) creates strict positivity margins.
Entrywise rational rounding is followed by exact normalization in entries
that do not couple a label to its own sector. The exact verifier, rather
than the proposal procedure, determines acceptance.

## Full hypotheses

The [standard-library verifier](../experiments/verify_reference_advantage.py)
proves, using exact rational arithmetic:

1. Every effect is positive definite and their sum is the identity.
2. Row and column \(j\) of \(E_j\) decouple, and its eigenvalue there is at
   least \(1-\delta\).
3. On the orthogonal complement of \(e_j\),
   \((1-\delta)I-E_j\) is strictly positive definite. Thus the **full**
   threshold sector is exactly \(P_j\), with no omitted eigenvectors.

The sectors are mutually orthogonal, so their synthesis is an isometry and
\(\alpha=1\). The completed effects are therefore the prescribed ones and
satisfy the frozen theorem. No spectral or polar approximation enters (1).

## System-only upper certificate

Write \(D_j=E_j-F_j\). For any state,
\[
\sum_j|\operatorname{Tr}D_j\rho|
=\max_{s\in\{-1,1\}^8}\operatorname{Tr}\left(\sum_js_jD_j\right)\rho.
\]
The finite maximum can be interchanged with the supremum over states, giving
\[
\nu_{\rm sys}=\max_{s\in\{-1,1\}^8}
\lambda_{\max}\left(\sum_js_jD_j\right).
\tag{2}
\]
For every one of the 256 sign choices, the verifier checks
\[
\frac{1161}{10000}I-\sum_js_jD_j^T>0.
\]
Transpose preserves the spectrum, so these exact inequalities prove the
left side of (1) uniformly over all system-only inputs.

## Reference-assisted lower certificate

The standard measurement-channel diamond-norm primal SDP uses
\(\rho\ge0\), \(\operatorname{Tr}\rho=1\), and Hermitian \(X_j\) satisfying
\(-\rho\le X_j\le\rho\), with objective
\(\sum_j\operatorname{Tr}(D_j^TX_j)\).
These are established channel-norm SDP tools, not a new characterization;
see [Watrous, 2012](https://arxiv.org/abs/1207.5726).

The certificate supplies rational Hermitian proposals \(\rho_0,X_{j,0}\).
With \(\varepsilon=10^{-6}\), set
\[
c=\operatorname{Tr}(\rho_0+\varepsilon I),\qquad
\rho=(\rho_0+\varepsilon I)/c,\qquad X_j=X_{j,0}/c.
\]
The verifier proves \(c>0\), normalization, and strict positivity of
\(\rho\) and every \(\rho\pm X_j\). It evaluates the objective exactly
and proves it is at least \(151/1250\). Primal feasibility proves the
right side of (1), including arbitrary reference-assisted optimization.

Complex Hermitian matrices are verified through their realification
\[
\mathfrak R(A)=\begin{pmatrix}\Re A&-\Im A\\\Im A&\Re A\end{pmatrix}.
\]
This preserves positivity and products, and doubles traces. The checker
therefore uses half the real trace for both normalization and objectives.

## Independent audit and scope

The [verification output](../research/reference_advantage_2026-11-01/verification.json)
retains exact values and source hashes. The
[separate audit](../research/reference_advantage_2026-11-01/audit.json)
checks all 289 positive-definiteness decisions by integer Bareiss leading
minors: 5,764 positive minors, independently of Fraction LDL elimination.
Thirteen controls reject corrupt certificates and optimized Python that
would disable assertions.

```powershell
python -I -S experiments/verify_reference_advantage.py
python -I -S experiments/check_reference_advantage.py
```

Reference-assisted measurement discrimination is an established subject;
see [Puchala, Pawela, Krawiec and Kukulski, 2018](https://arxiv.org/abs/1804.05856v2).
No novelty is claimed for the general phenomenon. The exact result here is
its occurrence within this prescribed-completion subclass, with the stated
hypotheses and rational certificates. This does not establish publication
priority, a full diamond-distance value, or a complete Lean formalization.
