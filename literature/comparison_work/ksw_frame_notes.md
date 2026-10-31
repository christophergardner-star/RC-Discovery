# KSW, polar geometry, Jordan products and repeatability: comparison notes

Date: 31 October 2026. Primary theorem statements and relevant proof passages
were inspected. These notes identify implications, not absence of other prior art.

## 1. The channel-continuity step is fully inherited

Kretschmann--Schlingemann--Werner,
[A Continuity Theorem for Stinespring's Dilation](https://arxiv.org/html/0710.2495),
Theorem 1, Eq. (6), compares completely bounded distance with the infimum
of distances between common-representation dilations. For unital maps it gives
\(\|T_1-T_2\|_{\rm cb}/2\le\beta(T_1,T_2)\le
\sqrt{\|T_1-T_2\|_{\rm cb}}\).
Proposition 3 and its proof, Eqs. (13)--(14), give the easy direction directly
for any specified pair of dilations. In finite dimensions duality converts
the Heisenberg cb norm into the Schrödinger diamond norm.

For measurements use the common representation
\(\pi(z)=\bigoplus_j z_j I\) of \(\mathbb C^m\). Once RC supplies
\(W,V\), its estimate \(\nu\le2\|W-V\|\) is an immediate instance.
KSW does not select a second channel satisfying prescribed unit sectors or
the particular residual compression. Its reverse direction assumes channel
closeness and cannot supply that missing construction without additional work.

The earlier [Information--Disturbance paper](https://arxiv.org/html/quant-ph/0605009)
states finite-dimensional continuity in Theorem 1, Eq. (18). Its proof also
uses polar decomposition to optimize dilation overlaps. Thus neither the
dimension-free transfer nor the polar-alignment strategy should be presented
as a new channel principle.

## 2. An exact prior-art reduction for the coefficient-two proof

The positive-matrix lemma is precisely the \(a+b\le1\) branch of
de Bruijn's Theorem 3.2 and Sections 4--5, pp. 206--207, in
[Remarks on Hermitian Matrices (1980)](https://pure.tue.nl/ws/portalfiles/portal/2165089/597564.pdf),
which rederives Strang's 1962 Jordan-product bounds. The complete substitution
and condition equivalence are now recorded in
[the coefficient-two proof](../../theory/BOUND_CANDIDATE_2026-10-31.md).
The matrix inequality itself is established prior art. Applying it to RC's
specified dilation still requires the measurement-specific overlap identity.

The web PDF text was inspected; its OCR drops some displayed formulas.
The branch can independently be recovered from the paper's circle reduction:
when \(a+b\le1\), the minimum of
\(\operatorname{Re}(1+z)(1+w)\), \(|z|=a,|w|=b\), is
\((1-a)(1-b)\). This follows from
\(2\operatorname{Re}(1+z)(1+w)=1-a^2-b^2+|1+z+\bar w|^2\),
with conjugation chosen consistently in the circle parametrization.

## 3. Fusion geometry is standard; norm conversion is extra

Asgari, [On the Riesz fusion bases in Hilbert spaces (2013)](https://www.researchgate.net/publication/234155169_On_the_Riesz_fusion_bases_in_Hilbert_spaces),
Theorem 3.6, identifies a fusion Riesz basis with a Riesz basis formed by
orthonormal bases of its constituent subspaces. Theorem 3.9 identifies it with
an invertible image of an orthonormal fusion basis. Both statements and the
proof of Theorem 3.9 were inspected in the paper's available full text.
Apply this geometry to the packed span, rather than assuming the subspaces
span the entire physical Hilbert space. Lower synthesis conditioning and
orthogonalization are not separate RC contributions. These theorems do not
state a diamond-norm estimate for \(Q_j+RE_jR\).

[Higham (1986)](https://eprints.maths.manchester.ac.uk/694/1/high86p.pdf),
Theorem 1.1 and Section 2.1, provide rectangular polar decomposition and its
singular-value description. Theorem 2.2 gives polar alignment for the complex
orthogonal Procrustes problem in Frobenius norm; Corollary 2.3 discusses the
nearest-unitary property and credits Fan--Hoffman for unitarily invariant norms.
These are appropriate attributions for the geometry, not substitutes for
proving a channel bound.

## 4. Repeatability and same-label existence are inherited

Busch--Grabowski--Lahti (1995),
[Repeatable measurements in quantum theory](https://www.researchgate.net/publication/227080396_Repeatable_measurements_in_quantum_theory_Their_role_and_feasibility),
Section 4 immediately after Theorem C, states the eigenvalue-one criterion
and Eq. (20) constructs a repeatable instrument by preparing a corresponding
unit eigenstate after each outcome. The author-uploaded original full text
was inspected. A repeatable POVM need not be projective.

An elementary consequence makes the scope narrower still. If \(Q_j\) are the
exact unit eigenspace projections of a POVM \(F\), then positivity and
normalization imply \(F_iQ_j=\delta_{ij}Q_j\). With
\(R=I-\sum_jQ_j\), therefore \(F_j=Q_j+RF_jR\).
The residual-block shape is the ordinary normal form of a norm-one POVM.
RC's particular choice \(RF_jR=RE_jR\), coupled with its specific polar sectors
and quantitative proximity to the original measurement, is the comparison
target. Mere existence of a same-label repeatable realization is not that target.

## 5. The hybrid formula is an elementary orthogonal sum

In RC the spectral relation gives the labelwise identity
\(J^*\Lambda_jWR=0\), not only its sum \(J^*WR=0\). Consequently
\(JU^*\) and \(WR\) have orthogonal initial and final spaces, so their sum is
an isometry; the labelwise identity gives the claimed effect compression.
Once the spaces and spectral commutation are supplied, these are direct matrix
calculations. The gap \(RE_jR\le(1-\delta)R\) is also a direct spectral
compression. A paper should present these as the construction and its proof,
without claiming a new general gluing, Naimark, or repeatability theorem.

## 6. Independent check of the weighted polar comparison

The root audit proposed \(B=W^*J=TD\) and its polar factor
\(B=\widehat U K\). Since \(D\) is invertible on the sector space,
\(\operatorname{ran}B=\operatorname{ran}T\) and
\(K\ge\alpha\sqrt{1-\delta}\,I\). The same labelwise orthogonality gives
\[
\widehat V=J\widehat U^*+WR,\qquad
\widehat V^*\Lambda_j\widehat V
=\widehat U R_j^{\mathcal K}\widehat U^*+RE_jR.
\]
Moreover
\[
W^*\widehat V=\widehat U K\widehat U^*+R
\ge\alpha\sqrt{1-\delta}\,I.
\]
The usual pure-output trace-distance formula and common label readout then
give \(\nu\le2\sqrt{1-\alpha^2(1-\delta)}\) without a Jordan-product
condition. This calculation has been independently checked algebraically.
It concerns a generally different completion from the frozen
\(U=\operatorname{polar}(T)\) construction.

This is an explicit adaptation of classical polar alignment and channel
geometry, not a claim that a cited paper states this weighted measurement
theorem verbatim. It shows why the broad existential rounding statement
deserves a more conservative novelty assessment than the prescribed-map
statement. The frozen unweighted construction still needs its own comparison
bound; selecting a different polar factor does not prove that bound for it.
