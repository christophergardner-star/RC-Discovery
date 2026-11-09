# Audit of the general attaining family

9 November 2026. This written proof is accompanied by exact symbolic algebra
checks and a complete Lean construction of the variable-size attaining family.
It expands the lower construction in [joint_second_order.md](joint_second_order.md)
and pairs with the now formally assembled upper bound in
[ExactJointUpper.lean](../lean/RCProof/ExactJointUpper.lean).

Fix `0<a<=1`, `0<delta<1/2`, and put `c=1-delta`. Choose an integer

```text
n >= max(2, 1 + ceil(c*(1-a^2)/delta)).
```

Thus `delta*(n-1)>=c*(1-a^2)`. On the old n-dimensional space set
`u=(1,...,1)/sqrt(n)`, `P=u u*`, `Q=I_n-P`, and

```text
g = sqrt((n-a^2)/(n-1)), T = a P + g Q,
epsilon = 1-c*a^2, b=sqrt(epsilon), h=sqrt(1-b), z=2-b,
t=1-c*g^2.
```

The domain gives `g>=1>=a>0`, `0<b<1`, `z>1`, and `0<=t<1`.
In particular all divisions below are legitimate, including at `a=1`
and at equality in the integer dimension condition. These endpoints may
make `t=0`; no inverse of `t` or of the residual sum is used.

## 1. Full sectors and exact packing

The columns `v_j=T e_j` have norm one because
`g^2+(a^2-g^2)/n=1`. Consequently each old effect `E_j=c v_j v_j*`
has the full closed-threshold projector `v_j v_j*`: its only nonzero
eigenvalue is exactly `c`. The endpoint convention is essential.

Adjoin orthonormal vectors `f_1,...,f_4,r`, orthogonal to the old space.
Write `F_i=f_i f_i*`, `R=r r*` and define

```text
L+ = (b*u+h*r)(b*u+h*r)* / z,
L- = (b*h*u-r)(b*h*u-r)* / z,
E_(n+i) = F_i + L+/2 + t Q/4   (i=1,2),
E_(n+i) = F_i + L-/2 + t Q/4   (i=3,4).
```

All these effects are positive. The identity `L+ + L- = b^2 P + R`
gives normalization, separately on `span(u,r)`, `ran Q`, and the four
clean axes. This proves that these are actual POVMs, not merely lists of
Hermitian matrices with the desired output differences.

For a clean label i, write its low effect as `K_i=L_sign/2+t Q/4`.
The following explicit positive decomposition checks the entire complement:

```text
(I-F_i)/2 - K_i
  = (sum_(k != i) F_k)/2 + L_opposite/2
      + c*a^2*P/2 + (1+c*g^2)*Q/4 >= 0.
```

Also `K_i F_i=0`. Thus the only eigenvalue at or above `c>1/2`
is the eigenvalue 1 on `F_i`. Every full selected sector is rank one,
every label is nonzero, and every label has a nonempty sector.

Choosing `v_j` and `f_i` as sector bases gives synthesis equal to the
physical inclusion of `T direct_sum I_4`. It is injective; its positive
factor has eigenvalues `a`, `g`, and `1`. Since `g>=1>=a`, its least
singular value is exactly `a`, including `a=1`.

This also identifies the canonical construction, which may choose different
eigenvector phases and an ordering of its subtype index. Any other orthonormal
basis of these same rank-one labelled sectors differs by a unitary block
change of coordinates W. Synthesis changes from `T0` to `T0 W`, its positive
factor changes from `H0` to `W* H0 W`, and its polar factor changes from `U0`
to `U0 W`. Coordinate projections change compatibly. Hence the physical
rounded projections are unchanged: they are the old coordinate axes and
the `F_i`, and the residual projection is precisely `R`. No preferred
eigenvector phase or generic eigenvalue assumption is needed.

The prescribed completed effects are therefore exactly `Q_j+R E_j R`.
They have unit eigenvectors in their selected sectors, so the previously
constructed measure-and-prepare instrument makes them repeatable.

## 2. An attaining state, not an assumed diamond value

Take the normalized positive rank-one state
`rho=(u+h*r)(u+h*r)*/z`. Its trace is `(1+h^2)/z=1`.
Each old outcome difference is `-b^2/(n*z)`. The four clean differences are

```text
b/(2*z), b/(2*z), -b*h^2/(2*z), -b*h^2/(2*z).
```

They sum to zero, and their signs are determined throughout the parameter
domain. Pairing the output with the diagonal contraction having signs
`(-1,...,-1,+1,+1,-1,-1)` gives

```text
b^2/z + b*(1+h^2)/z = 2*b/z.
```

This is a system-only witness, so it lower-bounds the full diamond norm.
The canonical upper theorem gives the same number. The family is an actual
member of the exact-parameter class, hence its value lower-bounds the
supremum W, while the uniform upper theorem bounds every member of that
class. This proves the written equality `W=2*b/(2-b)` and proves attainment,
rather than just convergence to a supremum.

The construction permits dimension to depend on the parameter pair. It does
not determine a fixed-dimension optimum or the minimum dimension for attainment.

## 3. What the additional algebra audit establishes

[verify_joint_lower_symbolic.py](../experiments/verify_joint_lower_symbolic.py)
checks 21 nontrivial identities exactly over the rational polynomial ring modulo

```text
(n-1)*g^2+a^2-n = 0,
h^2+b-1 = 0,
b^2+c*a^2-1 = 0.
```

It verifies column normalization, parameter relations, the two-dimensional
residual identities, normalization, the positive-decomposition coefficients,
the state, output differences, and the attaining signed test. Four deliberately
corrupted identities are rejected. The dimension n remains symbolic.

These algebra checks do not independently prove operator positivity,
spectral-projector recognition, basis invariance, or membership in Lean's
`PackedMeasurement`. Those steps are justified above analytically and are now
also checked in the variable-size Lean construction, culminating in
`packingWorstCase_exact_joint` in `ExactJointAttainment.lean`. The earlier
finite rational certificates and numerical SDPs remain separate corroboration.
