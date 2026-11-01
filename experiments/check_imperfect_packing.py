"""Negative controls and integer-minor audit for the rational conjecture veto."""
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_imperfect_packing as v
from check_reference_advantage import leading_minors


def main():
    source=v.OUT/'veto_certificate.json'; original=json.loads(source.read_text(encoding='utf-8'))
    mutations=[
        ('wrong_format',lambda d:d.__setitem__('format','wrong')),
        ('wrong_synthesis',lambda d:d.__setitem__('alpha','1/2')),
        ('nonpositive_effect',lambda d:d.__setitem__('coupling_scale','1')),
        ('false_root_enclosure',lambda d:d.__setitem__('sqrt_delta_upper','1/10')),
        ('false_candidate_enclosure',lambda d:d.__setitem__('candidate_upper','1')),
        ('false_witness_lower',lambda d:d.__setitem__('witness_lower','19/10')),
        ('zero_vector',lambda d:d.__setitem__('witness_vector',['0']*7)),
        ('invalid_sign',lambda d:d['witness_signs'].__setitem__(0,2)),
        ('zero_signed_sum',lambda d:d.__setitem__('witness_signs',[-1]*6)),
    ]
    rejections=[]
    for name,mutation in mutations:
        proposed=deepcopy(original); mutation(proposed)
        try: v.verify(proposed)
        except AssertionError: rejections.append(name)
        else: raise RuntimeError('Invalid certificate accepted: '+name)
    process=subprocess.run([sys.executable,'-O',str(v.ROOT/'experiments/verify_imperfect_packing.py')],capture_output=True,text=True)
    assert process.returncode!=0 and 'without -O' in process.stderr
    rejections.append('optimized_python')
    matrices=0; minors=0; original_check=v.c.positive_definite
    def audited(a):
        nonlocal matrices,minors
        minors+=leading_minors(a); matrices+=1
        return original_check(a)
    v.c.positive_definite=audited
    try: v.verify(original)
    finally: v.c.positive_definite=original_check
    paths=[source,Path(__file__).resolve(),v.ROOT/'experiments/verify_imperfect_packing.py',v.ROOT/'experiments/check_reference_advantage.py']
    report=dict(result='PASS',expected_rejections=rejections,positive_definite_matrices=matrices,
                independent_integer_leading_minors=minors,
                source_text_sha256={p.relative_to(v.ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths})
    (v.OUT/'veto_audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS',len(rejections),'rejections;',matrices,'PD matrices;',minors,'integer leading minors.')


if __name__=='__main__': main()
