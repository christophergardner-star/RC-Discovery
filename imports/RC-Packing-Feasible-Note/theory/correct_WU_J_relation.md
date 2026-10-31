# Correct Relation Between WU and J

**Date:** 31 October 2026  
**Status:** Derived from first principles; replaces the claimed identity

## Setup (rank-1 for clarity)

Let \(v_1,\dots,v_m\in\mathcal H\) be unit vectors. Let \(V\) be the matrix with these columns. The synthesis operator is \(T c = V c\). Let \(U\) be its polar factor (partial isometry) with orthonormal columns \(q_j = U e_j\), and let \(H = |T|\).

Let \(E_j\) be effects with \(\sqrt{E_j}\) their positive square roots. The Naimark isometry is \(W: \mathcal H \to \bigoplus_j \mathcal H\), \((W y)_j = \sqrt{E_j}\, y\).

Define the embedding \(J: \mathbb C^m \to \bigoplus_j \mathcal H\) by placing the polar basis vector in the corresponding block:

\[
(J e_j)_j = q_j, \qquad (J e_j)_i = 0 \ (i\ne j).
\]

## Exact matrix elements

The operator \(W U: \mathbb C^m \to \bigoplus_j \mathcal H\) has \(j\)-th block \(\sqrt{E_j}\, U\).

Therefore the matrix elements of \(J^* W U\) are exactly

\[
\boxed{
(J^* W U)_{jk} = \langle q_j | \sqrt{E_j} | q_k \rangle.
}
\]

There is no sum on \(j\). In particular, this is **not** equal to \(D |T|\) in general, where \(D\) is the diagonal matrix of sector expectations \(\langle q_j | \sqrt{E_j} | q_j \rangle\).

## Quadratic form

Since \(J\) is an isometry (the \(q_j\) are orthonormal) while \(W U\) is not necessarily an isometry,

\[
(WU - J)^*(WU - J) = (WU)^*(WU) - J^*WU - (J^*WU)^* + I.
\]

The term \((WU)^*(WU)\) equals \(U^* (\sum_j E_j) U = U^* U = I\) only if the effects form a POVM and the residual is handled correctly; in the presence of residual mass it differs.

## Consequence for the Naimark argument

The claimed identity \(J^* W U = D |T|\) does not hold under this natural identification. The dimension-free bound on \(\nu\) that rested on that identity therefore requires a corrected derivation starting from the exact matrix elements above.

The qualitative idea (controlling the distance by how close \(\sqrt{E_j}\) is to the identity on the packed sectors, plus packing) remains plausible, but the quantitative steps must be re-derived.

## Numerical confirmation

In explicit low-dimensional examples the matrix elements match \(\langle q_j | \sqrt{E_j} | q_k \rangle\) to machine precision, while the difference from \(D |T|\) is order \(10^{-1}\) when sectors are imperfect.
