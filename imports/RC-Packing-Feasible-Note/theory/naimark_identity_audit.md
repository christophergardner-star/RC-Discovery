# Audit of the Naimark Overlap Identity

**Date:** 31 October 2026  
**Status:** Claimed identity fails numerical check under natural identification

## Claimed identity

In `dimension_free_nu_via_naimark.md` the key step is

\[
J^* W U = D |T|,
\]

which implies

\[
(WU - J)^*(WU - J) = 2I - D|T| - |T|D.
\]

Here \(W\) is the canonical Naimark isometry, \(U\) is the polar factor of the synthesis operator \(T\), \(J\) embeds the packed sectors into the labelled dilation space, and \(D\) is the block-diagonal restriction of \(\sqrt{E_j}\) to the near-unit sectors.

## Numerical counter-check

Under the natural identification (rank-1 sectors, polar basis used for both \(U\) and the embedding \(J\), spectral square roots of the effects), the identity \(J^* W U = D |T|\) fails.

Minimal example (\(m=2\), \(d=3\), overlap \(0.1\), \(\delta=0\)):

- Error \(\|J^*WU - DH\| \approx 0.071\)
- Quadratic identity error \(\approx 0.141\)

Repeated random trials produce errors of order \(10^{-1}\), not machine precision.

## Possible sources of the discrepancy

1. The identification between the abstract space \(K = \bigoplus_j S_j\) and the concrete embedding used by \(J\) may differ from the polar basis of \(T\).
2. The restriction that defines \(D\) may need to be taken with respect to a different basis of the sectors than the one used to define \(U\).
3. The claimed exact identity may contain an algebraic gap.

## Consequence

The dimension-free \(\nu\) bound rests on this identity. Until the identity is either corrected or shown to hold under a precisely stated identification of spaces, the Naimark theorem candidate remains unverified.

## Next action

Derive the correct relation between \(W U\) and \(J\) from first principles, without assuming the claimed form, or exhibit an explicit basis in which the identity holds to machine precision.
