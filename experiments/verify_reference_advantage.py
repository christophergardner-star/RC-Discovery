"""Exact reference-advantage certificate. Standard library; no SDP solver."""
from fractions import Fraction as F
import hashlib
from itertools import product
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/reference_advantage_2026-11-01'
positive_definite=c.positive_definite


def verify(document):
    assert document['format']=='reference-advantage-v1'
    d=document['dimension']; m=document['outcomes']
    assert d==10 and m==8
    n=2*d; identity=c.eye(n)
    es=[c.unpack(x) for x in document['effects']]
    assert len(es)==m and all(len(e)==n and all(len(row)==n for row in e) for e in es)
    assert c.sum_matrices(es)==identity
    delta=F(document['delta']); assert 0<delta<F(1,2)
    fs=[]
    for j,e in enumerate(es):
        positive_definite(e)
        own=[j,j+d]; other=[k for k in range(n) if k not in own]
        assert e[j][j]==e[j+d][j+d]>=1-delta
        assert all(e[i][k]==e[k][i]==0 for i in own for k in range(n) if k!=i)
        low=[[e[i][k] for k in other] for i in other]
        positive_definite(c.sub(c.scale(1-delta,c.eye(n-2)),low))
        f=c.zero(n,n)
        for i in own: f[i][i]=F(1)
        residual=list(range(m,d))+list(range(m+d,n))
        for i in residual:
            for k in residual: f[i][k]=e[i][k]
        fs.append(f)
    assert c.sum_matrices(fs)==identity
    ds=[c.complex_transpose(c.sub(e,f)) for e,f in zip(es,fs)]
    upper=F(document['system_upper']); lower=F(document['reference_lower'])
    assert 0<upper<lower<2
    rho=c.unpack(document['rho_raw']); xs=[c.unpack(x) for x in document['x_raw']]
    assert len(rho)==n and all(len(row)==n for row in rho)
    assert len(xs)==m and all(len(x)==n and all(len(row)==n for row in x) for x in xs)
    shift=F(document['identity_shift']); assert shift>0
    rho=c.add(rho,c.scale(shift,identity))
    normalization=c.trace(rho)/2; assert normalization>0
    rho=c.scale(1/normalization,rho); xs=[c.scale(1/normalization,x) for x in xs]
    assert c.trace(rho)==2
    positive_definite(rho)
    for x in xs:
        for sign in (-1,1): positive_definite(c.add(rho,c.scale(sign,x)))
    objective=sum((c.trace(c.mul(a,x))/2 for a,x in zip(ds,xs)),F(0))
    assert objective>=lower
    # Maximizing all signed expectation sums is the system-only optimization.
    for signs in product((-1,1),repeat=m):
        signed=c.sum_matrices([c.scale(s,a) for s,a in zip(signs,ds)])
        positive_definite(c.sub(c.scale(upper,identity),signed))
    return dict(result='PASS',dimension=d,outcomes=m,alpha=F(1),delta=delta,
                system_only_upper=upper,reference_assisted_lower=lower,
                primal_objective=objective,strict_advantage=lower-upper,
                signed_operator_checks=2**m,sector_ranks=[1]*m)


def main():
    source=OUT/'certificate.json'
    result=verify(json.loads(source.read_text(encoding='utf-8')))
    paths=[source,Path(__file__).resolve(),ROOT/'experiments/verify_exact_completion_comparison.py',
           ROOT/'theory/reference_advantage.md']
    report=dict(**c.serializable(result),
                scope='Exact strict reference advantage for one prescribed completion; not an exact diamond value or novelty finding.',
                source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths})
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS system-only <=',result['system_only_upper'],'<',result['reference_assisted_lower'],
          '<= diamond; advantage >=',result['strict_advantage'],flush=True)


if __name__=='__main__': main()
