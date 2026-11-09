"""Exact, dimension-independent algebra audit of the general attaining family.

Polynomial identities are checked over QQ modulo the defining parameter
relations. This is a symbolic algebra check, NOT a Lean proof of the family or
its membership in PackedMeasurement. Positivity and sector recognition use the
explicit decompositions documented in theory/exact_joint_lower_audit.md.
"""
from pathlib import Path
import hashlib
import json
import sympy as s

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research/exact_joint_lower_symbolic_2026-11-09"
a, g, h, b, c, n = s.symbols("a g h b c n", real=True)
relations = [(n - 1) * g**2 + a**2 - n, h**2 + b - 1, b**2 + c * a**2 - 1]
basis = s.groebner(relations, g, h, b, a, c, n, domain=s.QQ)
z = 2 - b
t = 1 - c * g**2
P = s.diag(1, 0)
R = s.diag(0, 1)
plus_v, minus_v, psi = s.Matrix([b, h]), s.Matrix([b*h, -1]), s.Matrix([1, h])
Lp, Lm = plus_v * plus_v.T / z, minus_v * minus_v.T / z
rho = psi * psi.T / z
records = []


def remainder(expression):
    numerator, denominator = s.fraction(s.cancel(expression))
    return s.factor(basis.reduce(s.expand(numerator))[1]), s.factor(denominator)


def check(name, lhs, rhs):
    pairs = list(zip(lhs, rhs)) if isinstance(lhs, s.MatrixBase) else [(lhs, rhs)]
    denominators = []
    for left, right in pairs:
        residual, denominator = remainder(left - right)
        if residual != 0:
            raise AssertionError(f"{name}: nonzero exact remainder {residual}")
        denominators.append(str(denominator))
    records.append({"name": name, "entries": len(pairs), "result": "ZERO_REMAINDER",
                    "denominators": sorted(set(denominators))})


def main():
    check("unit_column_norm", g**2 + (a**2-g**2)/n, 1)
    check("g_squared_above_one", g**2-1, (1-a**2)/(n-1))
    check("g_squared_above_a_squared", g**2-a**2, n*(1-a**2)/(n-1))
    check("nonnegative_residual_coefficient", t, ((1-c)*(n-1)-c*(1-a**2))/(n-1))
    check("residual_coefficient_at_most_one", 1-t, c*g**2)
    check("largest_defect_is_b_squared", b**2-t, c*(g**2-a**2))
    check("two_residual_effects_sum", Lp+Lm, b**2*P+R)
    check("POVM_normalization_core", c*a**2*P+Lp+Lm, s.eye(2))
    check("POVM_normalization_perpendicular", c*g**2+t, 1)
    for name, low, other in (("plus", Lp, Lm), ("minus", Lm, Lp)):
        # Half the complement of a clean sector minus its low effect.
        check(f"strict_sector_gap_{name}_core", s.eye(2)/2-low/2,
              other/2+c*a**2*P/2)
        check(f"strict_sector_gap_{name}_perpendicular", s.Rational(1,2)-t/4,
              (1+c*g**2)/4)
    check("density_trace", s.trace(rho), 1)
    check("density_rank_one", rho*rho, rho)
    old = (c*a**2-1)/z
    dp = s.trace((Lp-R*Lp*R)*rho)/2
    dm = s.trace((Lm-R*Lm*R)*rho)/2
    check("aggregate_old_difference", old, -b**2/z)
    check("each_old_difference", (c*a**2-1)/(n*z), -b**2/(n*z))
    check("each_plus_difference", dp, b/(2*z))
    check("each_minus_difference", dm, -b*h**2/(2*z))
    check("outcome_differences_sum_zero", old+2*dp+2*dm, 0)
    check("attaining_signed_test", -old+2*dp-2*dm, 2*b/z)
    controls = []
    for name, expression in (
        ("wrong_envelope_factor", -old+2*dp-2*dm-b/z),
        ("omit_residual_compression", s.trace(Lp*rho)/2-b/(2*z)),
        ("wrong_frame_column_normalization", g**2+(a**2-g**2)/(n+1)-1),
        ("wrong_clean_split", old+3*dp+2*dm),
    ):
        residual, _ = remainder(expression)
        if residual == 0:
            raise AssertionError(f"negative control escaped: {name}")
        controls.append({"name": name, "result": "REJECTED", "remainder": str(residual)})
    OUT.mkdir(parents=True, exist_ok=True)
    result = {
        "result": "PASS", "scope": __doc__.strip(), "sympy_version": s.__version__,
        "parameter_domain": "n integer >= 2; 0<a<=1; 1/2<c<1; (1-c)(n-1)>=c(1-a^2); g>0; b>0; h>=0",
        "relations": [str(x) for x in relations],
        "domain_denominators_nonzero": ["n", "n-1", "a", "g", "2-b"],
        "identities": records, "negative_controls": controls,
        "source_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "not_checked_by_this_program": ["universal matrix positivity", "full spectral-projector recognition",
            "canonical basis invariance", "Lean PackedMeasurement membership", "novelty"],
    }
    (OUT / "verification.json").write_text(json.dumps(result, indent=2)+"\n", encoding="utf-8")
    print(f"PASS: {len(records)} exact symbolic identities; {len(controls)} corruptions rejected")


if __name__ == "__main__":
    main()
