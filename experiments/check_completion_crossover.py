"""Corruption controls and independent integer determinants for the bracket."""
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_completion_crossover as v
import verify_exact_completion_comparison as c
from check_exact_certificate_negative_controls import sylvester_bareiss

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'research/completion_crossover_2026-11-01'


def main():
    original = json.loads((OUT/'certificates.json').read_text(encoding='utf-8'))
    mutations = [
        ('wrong_format',lambda d:d.__setitem__('format','wrong')),
        ('missing_endpoint',lambda d:d['cases'].pop()),
        ('reversed_endpoints',lambda d:d['cases'].reverse()),
        ('outside_uniform_interval',lambda d:d['cases'][0].__setitem__('parameter','1')),
        ('parameter_input_mismatch',lambda d:d['cases'][0].__setitem__('parameter','2.3')),
        ('wrong_threshold',lambda d:d['cases'][0].__setitem__('delta','1/3')),
        ('reversed_preference',lambda d:d['cases'][0].__setitem__('expected_closer','weighted')),
        ('wrong_family_input',lambda d:d['cases'][0]['effects_head'][0]['real'][0].__setitem__(0,0)),
        ('false_dual_bound',lambda d:d['cases'][0]['unweighted'].__setitem__('dual_upper','0')),
        ('corrupt_primal',lambda d:d['cases'][0]['weighted']['rho']['real'][0].__setitem__(0,-10**15)),
        ('corrupt_polar',lambda d:d['cases'][0]['weighted_polar']['positive_factor']['real'][0].__setitem__(0,0)),
    ]
    rejected = []
    for name,mutation in mutations:
        data = deepcopy(original)
        mutation(data)
        try:
            v.verify_crossover(data)
        except AssertionError:
            rejected.append(name)
        else:
            raise RuntimeError(f'Corruption accepted: {name}')
    proc = subprocess.run([sys.executable,'-O',str(ROOT/'experiments/verify_completion_crossover.py')],
                          capture_output=True,text=True)
    assert proc.returncode != 0 and 'without -O' in proc.stderr
    rejected.append('optimized_python')
    saved, count = c.positive_definite, 0
    def independent(a):
        nonlocal count
        sylvester_bareiss(a)
        count += 1
        return saved(a)
    c.positive_definite = independent
    try:
        v.family.verify_family(json.loads((ROOT/'research/completion_switch_family_2026-11-01/certificates.json').read_text(encoding='utf-8')))
        v.verify_crossover(original)
    finally:
        c.positive_definite = saved
    report = dict(result='PASS',expected_rejections=rejected,
                  independent_integer_determinant_positivity_checks=count,
                  scope='Both the existing uniform family and new endpoint certificate inequalities.',
                  source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(
                      p.read_text(encoding='utf-8').encode('utf-8')).hexdigest()
                      for p in [Path(__file__).resolve(),ROOT/'experiments/verify_completion_crossover.py',
                                ROOT/'experiments/check_exact_certificate_negative_controls.py']})
    (OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(f'PASS {len(rejected)} expected rejections; {count} independent determinant checks.')


if __name__ == '__main__':
    main()
