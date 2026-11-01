"""Verify rational certificates for two strict completion-distance orderings.

Standard library only: all acceptance decisions use Fraction/integer arithmetic.
The analytic error bounds are proved in theory/exact_completion_comparison.md.
This is an exact arithmetic certificate checker, not a Lean formalization.
"""
from __future__ import annotations

import argparse
from fractions import Fraction as F
import hashlib
import json
import sys
from math import isqrt
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if not __debug__:
    raise RuntimeError("Run the exact certificate verifier without -O or PYTHONOPTIMIZE.")


def eye(n):
    return [[F(int(i == j)) for j in range(n)] for i in range(n)]


def zero(n, m):
    return [[F(0) for _ in range(m)] for _ in range(n)]


def add(a, b):
    assert len(a) == len(b) and all(len(ar) == len(br) for ar, br in zip(a, b))
    return [[x+y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def sub(a, b):
    assert len(a) == len(b) and all(len(ar) == len(br) for ar, br in zip(a, b))
    return [[x-y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def scale(c, a):
    return [[c*x for x in row] for row in a]


def transpose(a):
    return list(map(list, zip(*a)))


def mul(a, b):
    assert a and b and all(len(row) == len(b) for row in a)
    bt = transpose(b)
    return [[sum((x*y for x, y in zip(row, col)), F(0)) for col in bt] for row in a]


def diag(values):
    return [[x if i == j else F(0) for j in range(len(values))]
            for i, x in enumerate(values)]


def trace(a):
    return sum((row[i] for i, row in enumerate(a)), F(0))


def op_bound(a):
    """||A||_2 <= sqrt(||A||_1 ||A||_infinity) <= max of those two norms."""
    return max(max(sum(abs(x) for x in row) for row in a),
               max(sum(abs(x) for x in col) for col in zip(*a)))


def selected(a, columns):
    return [[row[c] for c in columns] for row in a]


def unpack(packed):
    """Realification [[Re A,-Im A],[Im A,Re A]] of an exact complex matrix."""
    denominator = packed["denominator"]
    assert isinstance(denominator, int) and denominator > 0
    real, imag = packed["real"], packed["imag"]
    assert len(real) == len(imag) > 0 and len(real[0]) > 0
    n, m = len(real), len(real[0])
    assert all(len(row) == m for row in real+imag)
    assert all(isinstance(x, int) for row in real+imag for x in row)
    r = [[F(x, denominator) for x in row] for row in real]
    q = [[F(x, denominator) for x in row] for row in imag]
    return [ar+[-x for x in ai] for ar, ai in zip(r, q)] + [
        ai+ar for ar, ai in zip(r, q)]


def complex_transpose(a):
    # For a Hermitian complex matrix, transpose is complex conjugation.
    n = len(a)//2
    assert a == transpose(a)
    return [[x * (1 if (i < n) == (j < n) else -1)
             for j, x in enumerate(row)] for i, row in enumerate(a)]


def positive_definite(a):
    """Exact symmetric LDL^T elimination; positive pivots imply positive definite."""
    assert a == transpose(a), "matrix must be exactly symmetric"
    work = [row.copy() for row in a]
    pivots = []
    for k in range(len(a)):
        pivot = work[k][k]
        assert pivot > 0, f"nonpositive exact LDL pivot {k}"
        pivots.append(pivot)
        for i in range(k+1, len(a)):
            for j in range(i, len(a)):
                work[i][j] -= work[i][k]*work[j][k]/pivot
                work[j][i] = work[i][j]
    return min(pivots)


def ceil_root(x, denominator=10**9):
    assert x >= 0
    target = x.numerator*denominator**2
    k = isqrt(target//x.denominator)
    if k*k*x.denominator < target:
        k += 1
    answer = F(k, denominator)
    assert answer*answer >= x
    return answer


def interval(x, digits=12):
    """Outward rational decimal enclosure for display, without float conversion."""
    unit = 10**digits
    low = (x.numerator*unit)//x.denominator
    high = -((-x.numerator*unit)//x.denominator)
    def decimal(k):
        sign = "-" if k < 0 else ""
        k = abs(k)
        return f"{sign}{k//unit}.{k%unit:0{digits}d}"
    return {"lower": decimal(low), "upper": decimal(high)}


def polar_error(a0, input_error, packed, lower):
    u, h = unpack(packed["isometry"]), unpack(packed["positive_factor"])
    assert len(u) == len(a0) and len(u[0]) == len(a0[0])
    assert len(h) == len(u[0]) and all(len(row) == len(h) for row in h)
    eta = op_bound(sub(mul(transpose(u), u), eye(len(u[0]))))
    assert eta < F(1, 2)
    positive_definite(sub(h, scale(lower, eye(len(h)))))
    assert lower >= F(3, 4) and op_bound(h) <= 2
    factor_residual = op_bound(sub(a0, mul(u, h)))
    z = input_error+factor_residual+eta*op_bound(h)
    assert z < F(1, 4)
    error = 42*z+eta
    return u, error, lower-z, {
        "gram_error": eta, "factor_residual": factor_residual,
        "reference_perturbation": z, "polar_error": error,
    }


def verify_case(case):
    d, m = case["dimension"], case["outcomes"]
    assert isinstance(d, int) and isinstance(m, int) and d > 0 and m > 1
    assert len(case["ranks"]) == m
    assert all(isinstance(r, int) and r > 0 for r in case["ranks"])
    n = 2*d
    identity = eye(n)
    effects = [unpack(p) for p in case["effects_head"]]
    assert len(effects) == m-1
    effects.append(sub(identity, sum_matrices(effects)))
    for e in effects:
        assert len(e) == n and len(e[0]) == n
        positive_definite(e)
    # Positivity and exact normalization prove 0 <= E_j <= I.
    assert sum_matrices(effects) == identity
    delta = F(case["delta"])
    assert 0 < delta < F(1, 2)
    threshold = 1-delta
    models, indices, weights, reports = [], [], [], []
    t_error, weighted_error = F(0), F(0)
    assert len(case["spectral_models"]) == m
    for e, model, requested_rank in zip(effects, case["spectral_models"], case["ranks"]):
        z = unpack(model["vectors"])
        assert len(z) == n and len(z[0]) == n
        lam = [F(x, model["denominator"]) for x in model["eigenvalues"]]
        roots = [F(x, model["denominator"]) for x in model["root_weights"]]
        assert len(lam) == d and len(roots) == d and all(0 <= x <= 1 for x in lam)
        eta = op_bound(sub(mul(transpose(z), z), identity))
        assert eta < F(1, 2)
        residual = op_bound(sub(mul(e, z), mul(z, diag(lam+lam))))
        epsilon = residual+2*eta
        gap = min(abs(x-threshold) for x in lam)
        assert gap > epsilon
        ix = [i for i, value in enumerate(lam) if value > threshold]
        assert len(ix) == requested_rank > 0
        p_error = n*epsilon/gap
        assert p_error < F(1, 4)
        assert all(F(1, 2) <= roots[i] <= 1 for i in ix)
        root_error = max(2*abs(lam[i]-roots[i]**2) for i in ix)
        t_error += 2*p_error+eta
        weighted_error += 2*p_error+2*epsilon+eta+root_error
        models.append(z)
        indices.append(ix)
        weights += [roots[i] for i in ix]
        reports.append({
            "rank": requested_rank, "gram_error": eta, "eigen_residual": residual,
            "model_error": epsilon, "threshold_margin": gap,
            "projector_error": p_error, "root_error": root_error,
        })
    k = len(weights)
    assert 0 < k <= d
    t0 = [
        [z[row][i] for z, ix in zip(models, indices) for i in ix]
        + [z[row][d+i] for z, ix in zip(models, indices) for i in ix]
        for row in range(n)]
    a0 = mul(t0, diag(weights+weights))
    u, u_error, alpha_lower, u_report = polar_error(
        t0, t_error, case["unweighted_polar"], F(case["alpha_reference_lower"]))
    w, w_error, _, w_report = polar_error(
        a0, weighted_error, case["weighted_polar"], F(3, 4))
    assert 0 < alpha_lower < 1
    residual = sub(identity, mul(u, transpose(u)))
    approximations = {
        field: [unpack(p) for p in case[field]["effects"]]
        for field in ("unweighted", "weighted")}
    for matrices in approximations.values():
        assert len(matrices) == m
        assert all(len(a) == n and all(len(row) == n for row in a) for a in matrices)
    completion_errors = {"unweighted": [], "weighted": []}
    offset = 0
    for label, rank in enumerate(case["ranks"]):
        ix = list(range(offset, offset+rank))+list(range(k+offset, k+offset+rank))
        r_e_r = mul(mul(residual, effects[label]), residual)
        for field, isometry, error in (
            ("unweighted", u, 12*u_error),
            ("weighted", w, 3*w_error+9*u_error),
        ):
            block = selected(isometry, ix)
            model = add(mul(block, transpose(block)), r_e_r)
            discrepancy = op_bound(sub(approximations[field][label], model))
            completion_errors[field].append(error+discrepancy)
        offset += rank
    bounds, sdp_reports = {}, {}
    pad = F(case["sdp_padding"])
    assert pad > 0
    for field in ("unweighted", "weighted"):
        data = case[field]
        differences = [complex_transpose(sub(e, f))
                       for e, f in zip(effects, approximations[field])]
        raw_rho = unpack(data["rho"])
        assert len(raw_rho) == n and all(len(row) == n for row in raw_rho)
        assert raw_rho == transpose(raw_rho)
        normalization = trace(raw_rho)/2+d*pad
        assert normalization > 0
        rho = scale(1/normalization, add(raw_rho, scale(pad, identity)))
        xs = [scale(1/normalization, unpack(p)) for p in data["x"]]
        ys = [add(unpack(p), scale(pad, identity)) for p in data["y"]]
        assert len(xs) == len(ys) == m
        assert all(len(a) == n and all(len(row) == n for row in a) for a in xs+ys)
        assert trace(rho) == 2
        pivots = [positive_definite(rho)]
        for difference, x, y in zip(differences, xs, ys):
            for sign in (F(-1), F(1)):
                pivots += [
                    positive_definite(add(rho, scale(sign, x))),
                    positive_definite(add(y, scale(sign, difference))),
                ]
        upper = F(data["dual_upper"])+(m+1)*pad
        pivots.append(positive_definite(sub(scale(upper, identity), sum_matrices(ys))))
        lower = sum((trace(mul(a, x))/2 for a, x in zip(differences, xs)), F(0))
        assert lower <= upper
        error = sum(completion_errors[field], F(0))
        bounds[field] = (max(F(0), lower-error), min(F(2), upper+error))
        assert bounds[field][0] <= bounds[field][1]
        sdp_reports[field] = {
            "rational_primal": lower, "rational_dual": upper,
            "completion_error_sum": error, "minimum_LDL_pivot": min(pivots),
        }
    expected = case["expected_closer"]
    other = "weighted" if expected == "unweighted" else "unweighted"
    assert expected in ("unweighted", "weighted")
    separation = bounds[other][0]-bounds[expected][1]
    assert separation > 0, "strict ordering not certified"
    a_upper, b_upper = ceil_root(1-alpha_lower**2), ceil_root(delta)
    theorem_upper = 2*(a_upper+b_upper)
    assert theorem_upper < 2, "certificate must be in informative regime"
    return {
        "id": case["id"], "dimension": d, "outcomes": m, "delta": delta,
        "alpha_lower": alpha_lower, "theorem_upper": theorem_upper,
        "spectral_models": reports, "unweighted_polar": u_report,
        "weighted_polar": w_report, "distance_bounds": bounds,
        "sdp_certificates": sdp_reports, "strict_separation": separation,
        "closer": expected, "result": "PASS",
    }


def sum_matrices(matrices):
    assert matrices
    result = zero(len(matrices[0]), len(matrices[0][0]))
    for a in matrices:
        result = add(result, a)
    return result


def serializable(value):
    if isinstance(value, F):
        return {"exact": str(value), "decimal_enclosure": interval(value)}
    if isinstance(value, dict):
        return {key: serializable(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [serializable(item) for item in value]
    return value


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path,
                        default=ROOT/"research/exact_comparison_2026-11-01")
    args = parser.parse_args()
    directory = args.directory.resolve()
    path = directory/"certificates.json"
    raw = path.read_text(encoding="utf-8")
    certificate = json.loads(raw)
    assert certificate["format"] == "rational-completion-comparison-v1"
    results = []
    for case in certificate["cases"]:
        result = verify_case(case)
        results.append(result)
        print(f"PASS exact rational case {case['id']}: {result['closer']} closer; "
              f"separation >= {interval(result['strict_separation'])['lower']}", flush=True)
    assert {r["closer"] for r in results} == {"unweighted", "weighted"}
    output = {
        "result": "PASS", "arithmetic": "Python standard-library Fraction and integers only",
        "python_version": sys.version,
        "scope": "Exact arithmetic certificates conditional on the analytic lemmas in the accompanying proof; not a Lean proof or novelty assessment.",
        "certificate_text_sha256": hashlib.sha256(raw.encode("utf-8")).hexdigest(),
        "verifier_text_sha256": hashlib.sha256(Path(__file__).read_text(
            encoding="utf-8").encode("utf-8")).hexdigest(),
        "proof_text_sha256": hashlib.sha256((ROOT/"theory/exact_completion_comparison.md").read_text(
            encoding="utf-8").encode("utf-8")).hexdigest(),
        "results": serializable(results),
    }
    (directory/"verification.json").write_text(
        json.dumps(output, indent=2)+"\n", encoding="utf-8")


if __name__ == "__main__":
    main()
