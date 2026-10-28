# Sharpness: Two-Record Qubit Family

For the record-margin theorem,

\[
\|\Phi-\Pi\|_\diamond
\le
\sqrt{\frac{2\eta}{\kappa}},
\]

the bound can be attained exactly.

Let

\[
P_0=|0\rangle\langle0|,
\qquad
P_1=|1\rangle\langle1|.
\]

Take

\[
\sigma_1=|1\rangle\langle1|
\]

and

\[
\sigma_0=|\psi_\theta\rangle\langle\psi_\theta|,
\qquad
|\psi_\theta\rangle
=
\cos\theta|0\rangle+\sin\theta|1\rangle,
\]

with \(0\le\theta<\pi/2\).

For two records,

\[
\kappa
=
\frac12\|\sigma_0-\sigma_1\|_1
=
\cos\theta.
\]

The self-read probability of record 0 is

\[
a_0=\cos^2\theta,
\]

while \(a_1=1\). Thus

\[
\eta
=
\|\Phi^2-\Phi\|_\diamond
=
2\sin^2\theta\cos\theta.
\]

The exact idempotent rounds to

\[
\tau_0=|0\rangle\langle0|,
\qquad
\tau_1=|1\rangle\langle1|.
\]

Its distance is

\[
\|\Phi-\Pi\|_\diamond
=
2\sin\theta.
\]

But

\[
\sqrt{\frac{2\eta}{\kappa}}
=
2\sin\theta.
\]

Therefore

\[
\boxed{
\|\Phi-\Pi\|_\diamond
=
\sqrt{\frac{2\eta}{\kappa}}.
}
\]

So, in this theorem class, the square-root dependence and universal prefactor are worst-case sharp.
