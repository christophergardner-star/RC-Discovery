"""Corruption controls and independent integer positivity audit."""
from copy import deepcopy
from fractions import Fraction as F
import hashlib
import json
from math import lcm
from pathlib import Path
import subprocess
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_reference_advantage as v


def leading_minors(a):
    assert a==v.c.transpose(a)
    den=lcm(*(x.denominator for row in a for x in row))
    work=[[int(x*den) for x in row] for row in a]
    previous=1; count=0
    for k in range(len(a)):
        pivot=work[k][k]; assert pivot>0
        count+=1
        for i in range(k+1,len(a)):
            for j in range(k+1,len(a)):
                numerator=pivot*work[i][j]-work[i][k]*work[k][j]
                assert numerator%previous==0
                work[i][j]=numerator//previous
        for i in range(k+1,len(a)): work[i][k]=0
        previous=pivot
    return count


def main():
    source=v.OUT/'certificate.json'; original=json.loads(source.read_text(encoding='utf-8'))
    mutations=[
        ('wrong_format',lambda d:d.__setitem__('format','wrong')),
        ('wrong_dimension',lambda d:d.__setitem__('dimension',9)),
        ('missing_effect',lambda d:d['effects'].pop()),
        ('normalization_error',lambda d:d['effects'][0]['real'][0].__setitem__(0,0)),
        ('wrong_threshold',lambda d:d.__setitem__('delta','1/100000')),
        ('false_system_bound',lambda d:d.__setitem__('system_upper','1/100')),
        ('false_reference_bound',lambda d:d.__setitem__('reference_lower','19/10')),
        ('reversed_gap',lambda d:d.__setitem__('reference_lower','1/100')),
        ('zero_shift',lambda d:d.__setitem__('identity_shift','0')),
        ('bad_density',lambda d:d['rho_raw']['real'][0].__setitem__(0,-10**10)),
        ('bad_primal',lambda d:d['x_raw'][0]['real'][0].__setitem__(0,10**10)),
        ('nonhermitian_density',lambda d:d['rho_raw']['imag'][0].__setitem__(0,1)),
    ]
    rejections=[]
    for name,mutation in mutations:
        document=deepcopy(original); mutation(document)
        try: v.verify(document)
        except AssertionError: rejections.append(name)
        else: raise RuntimeError('Invalid certificate accepted: '+name)
    process=subprocess.run([sys.executable,'-O',str(v.ROOT/'experiments/verify_reference_advantage.py')],capture_output=True,text=True)
    assert process.returncode!=0 and 'without -O' in process.stderr
    rejections.append('optimized_python')
    matrices=0; minors=0; original_check=v.positive_definite
    def audited(a):
        nonlocal matrices,minors
        minors+=leading_minors(a); matrices+=1
        return original_check(a)
    v.positive_definite=audited
    try: v.verify(original)
    finally: v.positive_definite=original_check
    report=dict(result='PASS',expected_rejections=rejections,positive_definite_matrices=matrices,
                independent_integer_leading_minors=minors,
                source_text_sha256={p.relative_to(v.ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in [source,Path(__file__).resolve(),v.ROOT/'experiments/verify_reference_advantage.py']})
    (v.OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS',len(rejections),'rejections;',matrices,'PD matrices;',minors,'integer leading minors.',flush=True)


if __name__=='__main__': main()
