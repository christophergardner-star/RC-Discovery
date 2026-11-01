# A four-dimensional family with a change of preferred completion

1 November 2026. This is a finite computer-assisted result about the prescribed
unweighted and weighted completions, not a literature-priority or optimality claim.

## Explicit family

On \(\mathbb C^4\), with three fixed labels, define
\[
 E_1(t)=\frac1{40}
 \begin{pmatrix}
 32&0&3&1\\
 0&2&2&2\\
 3&2&4&4\\
 1&2&4&8
 \end{pmatrix},
 \qquad
 E_2(t)=\frac1{40}
 \begin{pmatrix}
 4&2&-2&t\\
 2&34&-3&-1\\
 -2&-3&2&-2\\
 t&-1&-2&12
 \end{pmatrix},
 \qquad E_3(t)=I-E_1(t)-E_2(t),
 \quad 2\le t\le4. \tag{1}
\]
Thus
\[
 E_3(t)=\frac1{40}
 \begin{pmatrix}
 4&-2&-1&-1-t\\
 -2&4&1&-1\\
 -1&1&34&-2\\
 -1-t&-1&-2&20
 \end{pmatrix}. \tag{2}
\]
Only one symmetric off-diagonal pair is transferred between effects 2 and 3.
Every diagonal entry is independent of t. In particular, all outcome
probabilities on the four coordinate-basis states stay fixed.

Fix \(\delta=1/4\). Let \(P_j(t)\) be the full spectral sector of \(E_j(t)\)
at or above \(3/4\). Use their synthesis map T, its unweighted polar isometry U,
and \(R=I-UU^*\) to define
\[
 F^u_j=UC_jU^*+RE_jR.
\]
With D restricting the positive square roots of the effects to their sectors,
let \(\widehat U=\operatorname{polar}(TD)\) and define
\[
 F^w_j=\widehat UC_j\widehat U^*+RE_jR.
\]
Write \(\nu_u(t)\) and \(\nu_w(t)\) for the unhalved diamond distances of the
original measurement channel to these two completions, respectively.

**Proposition.** For every real \(t\in[2,4]\), (1) is a POVM satisfying the
frozen theorem, with sector ranks \((1,1,1)\) and
\[
 \alpha(t)>\frac9{10},\qquad
 \nu_u(t)\le 1+\frac{\sqrt{19}}5<2. \tag{3}
\]
At the endpoints,
\[
 \nu_u(2)<\nu_w(2),\qquad \nu_w(4)<\nu_u(4). \tag{4}
\]
Both distance functions are continuous on \([2,4]\). Consequently at least
one \(t_*\in(2,4)\) satisfies \(\nu_u(t_*)=\nu_w(t_*)\).
The proposition does not assert uniqueness or an exact value of \(t_*\).

## 1. Positivity and full sectors throughout the interval

The exact checker verifies strict positive-definiteness of the three matrices
at both endpoints. Each effect is affine in t, so positivity holds on the
entire closed interval by convexity. Their sum is exactly I.

For each effect, the Rayleigh quotient on its designated coordinate gives
the lower bound a in the following table. Since the effects are positive,
the remaining three eigenvalues sum to at most beta, and hence are each at
most beta.

| Effect | Designated coordinate | \(a\le\lambda_{\max}(E_j(t))\) | \(\beta=\operatorname{Tr}(E_j(t))-a\) |
| --- | --- | --- | --- |
| \(E_1\) | \(e_1\) | \(4/5\) | \(7/20\) |
| \(E_2\) | \(e_2\) | \(17/20\) | \(9/20\) |
| \(E_3\) | \(e_3\) | \(17/20\) | \(7/10\) |

In each row \(\beta<3/4<a\), uniformly in t. Thus the full threshold sector
is exactly the one-dimensional top eigenspace. This argument covers every
real parameter in the interval; it is not a grid test.

## 2. Uniform packing certificate

The certificate proposes three fixed rational column vectors \(z_j\), reference
values \(\mu_j\), and a rational polar-factor model for \(T_0=(z_1,z_2,z_3)\).
They are generated from the midpoint \(t=3\), but no numerical eigensystem is
assumed correct by the verifier.

Set \(\eta_j=|z_j^*z_j-1|<1/2\), and let \(v_j=z_j/\|z_j\|\).
Then \(\|v_j-z_j\|\le\eta_j\).
The verifier checks \(\beta_j<\mu_j\le1\) and constructs rational upper bounds
\[
 r_j\ge\max_{t\in\{2,4\}}\|(E_j(t)-\mu_j I)z_j\|.
\]
These vector norms are enclosed by integer square-root calculations applied
to their exact rational squared norms.
Affinity implies the same residual bound for every intermediate t. Hence
\[
 \|(E_j(t)-\mu_j I)v_j\|\le r_j+2\eta_j.
\]
On the orthogonal complement of the top eigenspace the spectrum is at most
\(\beta_j\). The restricted eigenvalue equation therefore gives
\[
 \|(I-P_j(t))v_j\|
 \le p_j:=\frac{r_j+2\eta_j}{\mu_j-\beta_j}<\frac14. \tag{5}
\]
Normalize \(P_j(t)v_j\) to obtain a unit basis vector \(b_j(t)\) in that sector.
Its distance from \(v_j\) is at most \(p_j+p_j^2\):
projection costs at most \(p_j\), and normalization at most
\(1-\sqrt{1-p_j^2}\le p_j^2\).
Therefore
\[
 \|T(t)-T_0\|\le
 e_T:=\sum_j(p_j+p_j^2+\eta_j),\qquad
 T(t)=(b_1(t),b_2(t),b_3(t)). \tag{6}
\]

The rational model \(U_0H_0\) for \(T_0\) passes
\[
 \eta=N(U_0^*U_0-I)<1/2,\qquad
 H_0-\frac{927}{1000}I>0.
\]
Here \(N(A)=\max\{\|A\|_1,\|A\|_\infty\}\) is a rational upper bound for
operator norm. Let \(V_0=\operatorname{polar}(U_0)\), so
\(\|V_0-U_0\|\le\eta\).
The singular-value triangle inequality now gives the uniform lower bound
\[
 \alpha(t)\ge
 \frac{927}{1000}
 -\left[e_T+N(T_0-U_0H_0)+\eta N(H_0)\right]
 >0.900373705510>\frac9{10}. \tag{7}
\]
All inequalities in this certificate are checked with integers and fractions.
No sampled singular value is used to conclude (7).

This proves synthesis injectivity on the whole interval. Substituting
\(\alpha>9/10\) and \(\delta=1/4\) into the frozen bound yields (3).
The verifier also records the outward rational bound 1.871779790.
The estimate is conservative and is not claimed to be optimal.

## 3. Exact endpoint comparisons

For t equal to 2 and 4, the input effects have the exact integer entries shown
in (1), divided by 40. The endpoint certificates use the previously documented
[spectral, polar, and channel error bounds](exact_completion_comparison.md)
to connect rational approximate matrices to the actual completions.
They then check exact primal and dual distance witnesses, including the
completion error. Thus they bound the full channel distance, including
arbitrary reference assistance.

The exact separation bounds are
\[
 \nu_w(2)-\nu_u(2)>0.000514784608,\qquad
 \nu_u(4)-\nu_w(4)>0.000094582398. \tag{8}
\]
The full outward enclosures are retained in
[verification.json](../research/completion_switch_family_2026-11-01/verification.json).
The underlying data are
[certificates.json](../research/completion_switch_family_2026-11-01/certificates.json).
No numerical SDP status or tolerance establishes (8); numerical routines
only proposed the rational witness entries.

## 4. Continuity and a point of equal distance

For each label, the ratio of any other eigenvalue to the largest one is
uniformly bounded by \(\beta_j/a_j<1\). Consequently
\[
 P_j(t)=\lim_{k\to\infty}
 \left(\frac{E_j(t)}{\lambda_{\max}(E_j(t))}\right)^k
\]
is a uniform limit of continuous matrix functions on the interval.
Thus \(P_j(t)\) is continuous. Its overlap with the designated coordinate
cannot vanish: otherwise that coordinate's Rayleigh quotient would be at
most \(\beta_j<a_j\). The normalized vectors \(P_j(t)e_j/\|P_j(t)e_j\|\)
therefore give continuous sector bases.

The uniform lower bound (7) makes the polar factor of T continuous.
On these rank-one sectors, D is diagonal with entries
\(\sqrt{\lambda_{\max}(E_j(t))}\), bounded away from zero. Its weighted
polar factor is continuous as well. It follows that all completed effects
are continuous.

For measurement maps the diamond distance between two sets of effects is
at most the sum of their effectwise operator-norm differences. Hence both
\(\nu_u(t)\) and \(\nu_w(t)\) are continuous. Applying the intermediate value
theorem to \(\nu_w(t)-\nu_u(t)\) and (8) proves the existence of \(t_*\).
Continuity also gives neighborhoods of both endpoints with the respective
strict orderings.

There is an exact calibration of the input perturbation itself:
\[
 \|\mathcal M_{E(t)}-\mathcal M_{E(s)}\|_\diamond=\frac{|t-s|}{20}. \tag{9}
\]
Only two label blocks differ, by opposite copies of
\((t-s)(|e_1\rangle\langle e_4|+|e_4\rangle\langle e_1|)/40\).
Their measurement-map norm is twice this operator norm; a normalized
\(e_1\pm e_4\) eigenvector attains it. Thus (9) includes reference systems.

## Interpretation and limits

This family isolates a single changing coherence while all diagonal outcome
probabilities remain fixed. That change can reverse the preferred completion
under the full operational distance. It replaces the earlier unrelated
six-dimensional rational examples with one displayed, real-matrix family.

The polar factor of A minimizes the Frobenius distance from A to the
isometries: expanding that squared norm reduces the problem to maximizing
\(\operatorname{Re}\operatorname{Tr}(U^*A)\), which its singular-value
decomposition solves. The two constructions apply this standard procedure
to T and TD, respectively. Those are different alignment objectives, and
the present family shows that their ordering need not agree with the ordering
of the resulting measurement-channel errors. This is an explanation of the
comparison, not a claim that polar alignment or coherence effects are new.

No uniqueness or exact location of the equality point, closed formula for
the full distance functions, global best repeatable measurement, practical
advantage, or literature novelty is established. The uniform argument and
endpoint certificate interpretation remain subject to external mathematical
review; the complete logic has not been encoded in Lean.

## Reproduction

Verification needs no scientific Python packages:

    python -I -S experiments/verify_completion_switch_family.py
    python experiments/check_completion_switch_family.py

The first command verifies the exact endpoints and uniform certificate.
The second deliberately corrupts the data and independently checks positivity
using integer principal determinants. The
[builder](../experiments/build_completion_switch_family.py) may be run with
the audit environment to regenerate proposed witnesses and a numerical
illustration, but its numerical output is not trusted by the verifier.
