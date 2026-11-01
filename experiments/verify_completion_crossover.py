"""Exact rational sign certificates plus the existing whole-interval certificate.

Run with python -I -S. No solver or third-party library is imported.
Existence uses the continuity proof in theory/completion_switch_family.md.
This does not assert uniqueness or exclusion of other roots.
"""
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c
import verify_completion_switch_family as family

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'research/completion_crossover_2026-11-01'


def packed_family_heads(t):
    t = F(t)
    a = [[v*t.denominator for v in row] for row in family.A]
    b = [[v*t.denominator for v in row] for row in family.B0]
    b[0][3] = b[3][0] = t.numerator
    return [dict(denominator=40*t.denominator, real=m, imag=[[0]*4 for _ in range(4)])
            for m in (a,b)]


def verify_crossover(document):
    assert document['format'] == 'completion-crossover-v1'
    cases = document['cases']
    assert len(cases) == 2
    lo, hi = [F(case['parameter']) for case in cases]
    assert 2 <= lo < hi <= 4
    results, gaps = [], []
    for case, t, expected in zip(cases,(lo,hi),('unweighted','weighted')):
        assert case['dimension'] == 4 and case['outcomes'] == 3
        assert case['ranks'] == [1,1,1] and F(case['delta']) == F(1,4)
        assert case['expected_closer'] == expected
        assert len(case['effects_head']) == 2
        assert [c.unpack(p) for p in case['effects_head']] == [c.unpack(p) for p in packed_family_heads(t)]
        result = c.verify_case(case)
        results.append(result)
        u, w = result['distance_bounds']['unweighted'], result['distance_bounds']['weighted']
        gaps.append([w[0]-u[1], w[1]-u[0]])
    assert gaps[0][0] > 0 > gaps[1][1]
    return dict(result='PASS', bracket=[lo,hi], width=hi-lo,
                endpoint_results=results, weighted_minus_unweighted=gaps,
                conclusion='At least one equality point lies strictly inside this bracket, using the separately verified uniform family certificate and its continuity proof. Uniqueness is not asserted.')


def main():
    source = OUT/'certificates.json'
    uniform = ROOT/'research/completion_switch_family_2026-11-01/certificates.json'
    uniform_result = family.verify_family(json.loads(uniform.read_text(encoding='utf-8')))
    result = verify_crossover(json.loads(source.read_text(encoding='utf-8')))
    paths = [source, uniform, Path(__file__).resolve(),
             ROOT/'experiments/verify_completion_switch_family.py',
             ROOT/'experiments/verify_exact_completion_comparison.py',
             ROOT/'theory/completion_switch_family.md',
             ROOT/'theory/exact_completion_comparison.md']
    report = dict(arithmetic='Exact integers and fractions; no numerical acceptance tests.',
                  scope='Finite certificates with analytic error and continuity arguments; not a full Lean proof, a uniqueness proof, or a novelty finding.',
                  source_text_sha256={p.relative_to(ROOT).as_posix(): hashlib.sha256(
                      p.read_text(encoding='utf-8').encode('utf-8')).hexdigest() for p in paths},
                  uniform_alpha_lower=c.serializable(uniform_result['uniform_alpha_lower']),
                  **c.serializable(result))
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS certified bracket:', result['bracket'], 'width',result['width'])
    for case,gap in zip(result['endpoint_results'],result['weighted_minus_unweighted']):
        print(case['id'], 'g(t) in', c.interval(gap[0],15)['lower'],c.interval(gap[1],15)['upper'])


if __name__ == '__main__':
    main()
