"""Exact rational checks of the new imperfect-packing lower construction.

Standard library only. Positivity is checked by exact Schur elimination,
including zero-pivot rows. This is finite certificate verification, not Lean
formalization of the variable-size universal family.
"""
from copy import deepcopy
from fractions import Fraction as F
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c
from verify_perfect_packing_sharpness import psd

OUT=Path(__file__).resolve().parents[1]/'research/joint_second_order_2026-11-01'


def outer(v): return [[x*y for y in v] for x in v]
def axis(n,j): return c.diag([F(int(i==j)) for i in range(n)])


def construct(t,h):
    m=4; n=m+5
    alpha=(1-6*t-3*t*t)/(1+3*t*t)
    g=(1+2*t-3*t*t)/(1+3*t*t)
    b=1-h*h; eps=b*b; delta=1-(1-eps)/(alpha*alpha)
    assert 0<alpha<1 and 0<delta<F(1,2)
    u=[F(1,2)]*m+[F(0)]*5; r=[F(0)]*(n-1)+[F(1)]
    uu=outer(u); R=outer(r); S0=c.diag([F(1)]*m+[F(0)]*5)
    T=c.add(c.scale(g,c.eye(m)),c.scale((alpha-g)/m,[[F(1)]*m for _ in range(m)]))
    plus=c.scale(1/(2-b),outer([b*x+h*y for x,y in zip(u,r)]))
    minus=c.scale(1/(2-b),outer([b*h*x-y for x,y in zip(u,r)]))
    rest=c.scale(1-(1-delta)*g*g,c.sub(S0,uu))
    es=[]; ps=[]; qs=[]
    for j in range(m):
        v=[T[i][j] for i in range(m)]+[F(0)]*5
        p=outer(v); ps.append(p); es.append(c.scale(1-delta,p)); qs.append(axis(n,j))
    for j in range(4):
        p=axis(n,m+j); ps.append(p); qs.append(p)
        es.append(c.add(p,c.add(c.scale(F(1,2),plus if j<2 else minus),c.scale(F(1,4),rest))))
    fs=[c.add(q,c.mul(c.mul(R,e),R)) for q,e in zip(qs,es)]
    rho=c.scale(1/(2-b),outer([x+h*y for x,y in zip(u,r)]))
    return dict(m=m,alpha=alpha,g=g,delta=delta,b=b,h=h,T=T,effects=es,sectors=ps,
        completion=fs,rho=rho,signs=[-1]*m+[1,1,-1,-1],value=2*b/(2-b))


def verify(v):
    m=v['m']; n=m+5; I=c.eye(n)
    a=v['alpha']; g=v['g']; d=v['delta']; b=v['b']; h=v['h']
    assert m==4 and 0<a<=1 and g>=1 and 0<d<F(1,2)
    assert a*a+(m-1)*g*g==m
    assert b*b==1-(1-d)*a*a and h*h==1-b and 0<b<1
    assert (1-d)*g*g<=1
    expectedT=c.add(c.scale(g,c.eye(m)),c.scale((a-g)/m,[[F(1)]*m for _ in range(m)]))
    assert v['T']==expectedT
    psd(expectedT,strict=True)
    es=v['effects']; ps=v['sectors']; fs=v['completion']
    assert len(es)==len(ps)==len(fs)==m+4
    assert c.sum_matrices(es)==c.sum_matrices(fs)==I
    R=axis(n,n-1)
    for j,(e,p,f) in enumerate(zip(es,ps,fs)):
        psd(e); psd(p); psd(f)
        assert c.trace(p)==1 and c.mul(p,p)==p
        if j<m:
            col=[expectedT[i][j] for i in range(m)]+[F(0)]*5
            assert p==outer(col)
        else: assert p==axis(n,j)
        lam=1-d if j<m else F(1)
        assert c.mul(e,p)==c.scale(lam,p)
        low=c.sub(e,c.scale(lam,p))
        psd(low)
        psd(c.sub(c.scale(F(1,2),c.sub(I,p)),low))
        assert f==c.add(axis(n,j),c.mul(c.mul(R,e),R))
    rho=v['rho']; psd(rho); assert c.trace(rho)==1
    assert v['signs']==[-1]*m+[1,1,-1,-1]
    diffs=[c.trace(c.mul(c.sub(e,f),rho)) for e,f in zip(es,fs)]
    value=sum((s*x for s,x in zip(v['signs'],diffs)),F(0))
    assert value==sum(map(abs,diffs),F(0))==v['value']==2*b/(2-b)
    return dict(alpha=str(a),delta=str(d),epsilon=str(b*b),value=str(value),
                dimension=n,outcomes=len(es),psd_checks=5*len(es)+2)


def main():
    if not __debug__: raise RuntimeError('Run without -O')
    OUT.mkdir(parents=True,exist_ok=True)
    cases=[construct(F(1,1000),F(9,10)),construct(F(1,10000),F(19,20)),
           construct(F(1,100000),F(49,50))]
    rows=[verify(v) for v in cases]
    controls=[]
    for label,change in [
        ('effect',lambda v:v['effects'][0][0].__setitem__(0,v['effects'][0][0][0]+F(1,1000))),
        ('state',lambda v:v['rho'][0].__setitem__(0,v['rho'][0][0]+F(1,1000))),
        ('alpha',lambda v:v.__setitem__('alpha',v['alpha']+F(1,10000))),
        ('threshold',lambda v:v.__setitem__('delta',v['delta']/2)),
        ('value',lambda v:v.__setitem__('value',v['value']+F(1,1000))),
    ]:
        bad=deepcopy(cases[0]); change(bad)
        try: verify(bad)
        except AssertionError: controls.append(dict(name=label,result='REJECTED_AS_EXPECTED'))
        else: raise AssertionError('Accepted corruption: '+label)
    (OUT/'exact_certificates.json').write_text(json.dumps(cases,default=str,indent=2)+'\n',encoding='utf8')
    (OUT/'exact_verification.json').write_text(json.dumps(dict(result='PASS',cases=rows,
        controls=controls,scope='Finite rational lower certificates; not a universal Lean proof'),indent=2)+'\n',encoding='utf8')
    print('PASS',len(cases),'rational POVMs;',sum(x['psd_checks'] for x in rows),
          'exact PSD checks;',len(controls),'rejection controls')


if __name__=='__main__': main()
