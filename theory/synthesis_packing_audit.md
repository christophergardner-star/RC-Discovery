# Synthesis-Packing Audit

Status: **geometric core proved; full channel theorem still open**  
Date: 31 October 2026

This note audits the proposed synthesis-operator solution of the packing-feasible moving-POVM problem.

## Verdict

The central geometric invariant is sound. If
\[
T:\bigoplus_j \mathcal S_j\to\mathcal H,\qquad T(x_j)=\sum_jx_j
\]
has
\[
\alpha=\sigma_{\min}(T)>0,
\]
then the polar factor of (T) produces mutually orthogonal sectors with a dimension-free per-sector movement bound.

What is **not yet proved** is the claimed absolute-constant diamond-norm transfer for the whole measure-and-prepare channel.

## 1. All-rank polar orthogonalisation lemma

Let (T=U|T|) be the polar decomposition. Since (T) is injective, (U) is an isometry from the direct sum into \(\mathcal H\).

Let (R_j) be the coordinate projection onto the (j)-th summand and define
\[
Q_j=UR_jU^*.
\]

Then the (Q_j) are pairwise orthogonal and
\[
\operatorname{rank}Q_j=\dim\mathcal S_j.
\]

If (P_j) is the original projection onto \(\mathcal S_j\), then
\[
\boxed{\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}}
\]
for every (j).

### Proof

Take unit (x\in\mathcal S_j), and identify it with the coordinate vector (e\) in the direct sum. Then (Te=x) and (Ue\in\operatorname{ran}Q_j). Since (T=U|T|) and (|T|\ge\alpha I),
\[
\langle x,Ue\rangle
=
\langle Te,Ue\rangle
=
\langle |T|e,e\rangle
\ge\alpha.
\]

Hence the largest principal angle between \(\mathcal S_j\) and \(\operatorname{ran}Q_j\) has cosine at least \(\alpha\). Equal-dimensional projection geometry gives
\[
\|P_j-Q_j\|_\infty\le\sqrt{1-\alpha^2}.
\]

So the higher-rank geometric extension is already obtained by the same synthesis operator; it is not conceptually different from rank one.

The regular simplex is correctly vetoed because its synthesis operator is singular.

## 2. Rank-one specialisation

For unit columns (V=[v_1\cdots v_m]), the polar factor
\[
Q=V(V^*V)^{-1/2}
\]
has orthonormal columns (q_j). Thus
\[
\boxed{
\bigl\||v_j\rangle\langle v_j|-|q_j\rangle\langle q_j|\bigr\|_\infty
\le\sqrt{1-\sigma_{\min}(V)^2}.
}
\]

This per-label bound is more useful here than the classical global identity
\[
\|V-Q\|_F^2=\sum_k(\sigma_k(V)-1)^2.
\]

The polar / Löwdin nearest-isometry step itself is classical linear algebra and should not be claimed as novel.

## 3. Constructive POVM rounding under global projection closeness

Assume the stronger condition
\[
\|E_j-P_j\|_\infty\le\delta
\]
for every outcome. Put
\[
s=\sqrt{1-\alpha^2},\qquad e=\delta+s.
\]

Then
\[
\|E_j-Q_j\|_\infty\le e.
\]

Let
\[
Q=\sum_jQ_j,\qquad R=I-Q
\]
and define
\[
\boxed{F_j=Q_j+R E_jR.}
\]

Then (F_j\ge0), \(\sum_jF_j=I\), and
\[
F_iQ_j=\delta_{ij}Q_j.
\]

So \(\{F_j\}\) is repeatability-admissible. Moreover
\[
\boxed{\|E_j-F_j\|_\infty\le2e.}
\]

Also
\[
\|R E_jR\|_\infty\le e,
\]
so if (e<1), the spectral gap below the exact unit sector is at least
\[
\gamma_F\ge1-e.
\]

## 4. Why this does not yet solve the original near-unit-sector problem

Knowing only that (P_j) is the spectral projection of (E_j) onto eigenvalues \(\ge1-\delta\) does **not** imply
\[
\|E_j-P_j\|_\infty\ll1.
\]

An effect may have a near-unit sector and still retain substantial spectrum outside that sector.

Therefore the global projection-closeness assumption above is stronger than the original moving-POVM setup.

## 5. Exact remaining channel bottleneck

Let
\[
\Phi_E(\rho)=\sum_j\operatorname{Tr}(E_j\rho)\sigma_j
\]
and let \(\widetilde\Phi_F\) use the moved POVM (F_j) with the same records.

Define
\[
\nu=\|\Phi_E-\widetilde\Phi_F\|_\diamond.
\]

Then
\[
\|\widetilde\Phi_F^2-\widetilde\Phi_F\|_\diamond
\le\eta+3\nu.
\]

Applying the existing RC spectral-gap theorem gives an exactly idempotent channel \(\Pi\) with
\[
\boxed{
\|\Phi_E-\Pi\|_\diamond
\le
\nu+
\sqrt{\frac{2(\eta+3\nu)}{\kappa\gamma_F}}.
}
\]

A crude general estimate is
\[
\nu\le\sum_j\|E_j-F_j\|_\infty\le2me.
\]

That is outcome-count dependent. The proposed absolute-constant channel bound therefore remains unproved.

The next decisive question is:

> Does the structured polar correction satisfy a dimension/outcome-independent bound \(\nu\le C f(e)\), or is outcome-count dependence unavoidable?

## 6. Correction to one overstatement

Orthogonalising the POVM sectors does **not** by itself make the channel idempotent.

The output records must also be rounded into the exact sectors. That is where the RC Record-Margin / spectral-gap theorem enters after the POVM movement has been controlled.

## Current status

**Proved / checked**
- synthesis conditioning detects the simplex obstruction;
- polar orthogonalisation works for all ranks;
- per-sector movement is bounded by \(\sqrt{1-\alpha^2}\);
- under global effect-to-projection closeness, a nearby repeatability-admissible POVM is explicit.

**Still open**
- replacing global projection closeness by the weaker near-unit spectral-sector hypothesis;
- dimension-independent diamond-norm control for the POVM move;
- necessity/converse estimates;
- literature veto for the combined POVM-stability statement.

The most accurate summary is:

> **the geometric packing bottleneck is essentially solved; the full moving-channel theorem is not yet solved.**
