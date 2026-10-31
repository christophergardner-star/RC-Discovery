#!/usr/bin/env python3
"""Counterexample to the residual-to-extra-outcome gamma=1 closure.

E1 = diag(1,0,1/2), E2 = diag(0,1,1/2).
The near-unit sectors are exactly orthogonal: alpha=1, delta can be 0
for the selected sectors.

Adding a residual projective outcome F3=|e3><e3| gives gamma=1 but
changes the residual measurement distribution from (1/2,1/2,0)
to (0,0,1), whose l1 distance is 2.
"""

import numpy as np


def main() -> None:
    e1 = np.diag([1.0, 0.0, 0.5])
    e2 = np.diag([0.0, 1.0, 0.5])
    e3 = np.zeros((3, 3))

    f1 = np.diag([1.0, 0.0, 0.0])
    f2 = np.diag([0.0, 1.0, 0.0])
    f3 = np.diag([0.0, 0.0, 1.0])

    rho = np.diag([0.0, 0.0, 1.0])

    p = np.array([np.trace(e @ rho).real for e in (e1, e2, e3)])
    q = np.array([np.trace(f @ rho).real for f in (f1, f2, f3)])

    l1 = float(np.abs(p - q).sum())

    print("original:", p)
    print("extra-outcome PVM:", q)
    print("l1 distance:", l1)

    assert np.allclose(p, [0.5, 0.5, 0.0])
    assert np.allclose(q, [0.0, 0.0, 1.0])
    assert abs(l1 - 2.0) < 1e-12

    print("PASS")


if __name__ == "__main__":
    main()
