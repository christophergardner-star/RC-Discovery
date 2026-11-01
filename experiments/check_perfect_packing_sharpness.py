"""Corruption controls and all-principal-minor audit of exact PSD decisions."""
from copy import deepcopy
from fractions import Fraction as F
import hashlib
from itertools import combinations
import json
from math import lcm
from pathlib import Path
import subprocess
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_perfect_packing_sharpness as v


def determinant(a):
    """Integer Bareiss determinant after multiplying by a common denominator."""
    den=lcm(*(x.denominator for row in a for x in row))
    work=[[int(x*den) for x in row] for row in a]
    previous=1; sign=1; n=len(a)
    for k in range(n-1):
        pivot_row=next((i for i in range(k,n) if work[i][k]),None)
        if pivot_row is None: return 0
        if pivot_row!=k:
            work[k],work[pivot_row]=work[pivot_row],work[k]; sign=-sign
        pivot=work[k][k]
        for i in range(k+1,n):
            for j in range(k+1,n):
                numerator=pivot*work[i][j]-work[i][k]*work[k][j]
                assert numerator%previous==0
                work[i][j]=numerator//previous
        for i in range(k+1,n): work[i][k]=0
        previous=pivot
    return sign*work[-1][-1]


def main():
    source=v.OUT/'certificates.json'
    original=json.loads(source.read_text(encoding='utf-8'))
    mutations=[
        ('wrong_format',lambda d:d.__setitem__('format','wrong')),
        ('empty_cases',lambda d:d.__setitem__('cases',[])),
        ('wrong_parameter',lambda d:d['cases'][0].__setitem__('h','1')),
        ('wrong_delta_metadata',lambda d:d['cases'][0].__setitem__('delta','1/10')),
        ('wrong_sqrt_metadata',lambda d:d['cases'][0].__setitem__('b','1/10')),
        ('wrong_effect',lambda d:d['cases'][0]['effects'][1][0].__setitem__(0,'0')),
        ('wrong_completion',lambda d:d['cases'][0]['completion'][0][0].__setitem__(0,'0')),
        ('wrong_density_trace',lambda d:d['cases'][0]['rho'][0].__setitem__(0,'2')),
        ('missing_primal_block',lambda d:d['cases'][0]['x'].pop()),
        ('corrupt_primal',lambda d:d['cases'][0]['x'][0][0].__setitem__(0,'2')),
        ('corrupt_dual',lambda d:d['cases'][0]['y'][1][0].__setitem__(0,'-1')),
        ('false_distance',lambda d:d['cases'][0].__setitem__('value','2')),
    ]
    rejections=[]
    for name,mutation in mutations:
        proposed=deepcopy(original); mutation(proposed)
        try: v.verify_document(proposed)
        except AssertionError: rejections.append(name)
        else: raise RuntimeError('Corruption accepted: '+name)
    for name,a in [('zero_pivot_nonzero_row',[[0,1],[1,0]]),
                   ('negative_pivot',[[1,0],[0,-1]]),('nonsymmetric',[[1,1],[0,1]])]:
        try: v.psd([[F(x) for x in row] for row in a])
        except AssertionError: rejections.append(name)
        else: raise RuntimeError('Invalid PSD accepted: '+name)
    process=subprocess.run([sys.executable,'-O',str(v.ROOT/'experiments/verify_perfect_packing_sharpness.py')],capture_output=True,text=True)
    assert process.returncode!=0 and 'without -O' in process.stderr
    rejections.append('optimized_python')
    saved=v.psd; matrices=0; minors=0
    def audited(a,strict=False):
        nonlocal matrices,minors
        assert a==v.c.transpose(a)
        for size in range(1,len(a)+1):
            for ix in combinations(range(len(a)),size):
                value=determinant([[a[i][j] for j in ix] for i in ix])
                assert value>0 if strict else value>=0
                minors+=1
        matrices+=1
        return saved(a,strict)
    v.psd=audited
    try: v.verify_document(original)
    finally: v.psd=saved
    report=dict(result='PASS',expected_rejections=rejections,psd_matrices=matrices,
                independent_integer_principal_minors=minors,
                source_text_sha256={p.relative_to(v.ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in [source,Path(__file__).resolve(),v.ROOT/'experiments/verify_perfect_packing_sharpness.py']})
    (v.OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS',len(rejections),'rejection controls;',matrices,'PSD decisions;',minors,'integer principal minors.')


if __name__=='__main__':
    main()
