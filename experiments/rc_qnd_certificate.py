#!/usr/bin/env python3
"""
RC-QND certificate for a Z-twirled single-qubit MCM population channel.

The learned population-transfer matrix is

    B = [[1-u, d],
         [u, 1-d]]

where
    u = eta_up   : MCM-induced 0 -> 1 excitation probability
    d = eta_down : MCM-induced 1 -> 0 decay probability

Outputs:
    kappa_state       = |1-u-d|
    idempotence_defect= 2 max(u,d) kappa_state
    exact_qnd_distance= 2 max(u,d)
    generic_rc_bound  = 2 sqrt(max(u,d))

Optionally supply readout errors eps_1_given_0 and eps_0_given_1 to
compute the readout-label separation:
    kappa_label = |1-eps_1_given_0-eps_0_given_1|
"""

from __future__ import annotations

import argparse
import math


def qnd_certificate(
    eta_up: float,
    eta_down: float,
    eps_1_given_0: float | None = None,
    eps_0_given_1: float | None = None,
) -> dict[str, float]:
    for name, value in {
        "eta_up": eta_up,
        "eta_down": eta_down,
    }.items():
        if not 0.0 <= value <= 1.0:
            raise ValueError(f"{name} must lie in [0,1]")

    kappa_state = abs(1.0 - eta_up - eta_down)
    max_backaction = max(eta_up, eta_down)
    idempotence_defect = 2.0 * max_backaction * kappa_state
    exact_qnd_distance = 2.0 * max_backaction

    generic_rc_bound = (
        2.0 * math.sqrt(max_backaction)
        if kappa_state > 0.0
        else 2.0
    )

    out = {
        "kappa_state": kappa_state,
        "idempotence_defect": idempotence_defect,
        "exact_qnd_distance": exact_qnd_distance,
        "generic_rc_bound": generic_rc_bound,
    }

    if eps_1_given_0 is not None or eps_0_given_1 is not None:
        if eps_1_given_0 is None or eps_0_given_1 is None:
            raise ValueError("provide both readout error rates or neither")
        for name, value in {
            "eps_1_given_0": eps_1_given_0,
            "eps_0_given_1": eps_0_given_1,
        }.items():
            if not 0.0 <= value <= 1.0:
                raise ValueError(f"{name} must lie in [0,1]")
        out["kappa_label"] = abs(
            1.0 - eps_1_given_0 - eps_0_given_1
        )

    return out


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--eta-up", type=float, required=True)
    parser.add_argument("--eta-down", type=float, required=True)
    parser.add_argument("--eps-1-given-0", type=float)
    parser.add_argument("--eps-0-given-1", type=float)
    args = parser.parse_args()

    result = qnd_certificate(
        args.eta_up,
        args.eta_down,
        args.eps_1_given_0,
        args.eps_0_given_1,
    )

    for key, value in result.items():
        print(f"{key}: {value:.12g}")


if __name__ == "__main__":
    main()
