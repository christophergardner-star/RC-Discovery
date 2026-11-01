"""Exact vetoes of two proposed extensions; no numerical dependencies."""
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/imperfect_packing_2026-11-01'


def outer(a,b=None):
    if b is None: b=a
    return [[x*y for y in b] for x in a]


def family(alpha,sector_scale,coupling_scale):
    m=6; x=alpha*alpha; k=alpha+sector_scale*(m-2)
    assert 0<alpha<sector_scale and alpha*alpha+(m-1)*sector_scale**2==m
    lam=F(m-1,m); mu=(m-(m-1)*x)/(m*(m-x)); beta=x/(m*(m-x))
    signs=[F(1)]*3+[F(-1)]*3; ones=[F(1)]*m
    es=[]; vs=[]; fs=[]
    for j in range(m):
        ej=[F(int(i==j)) for i in range(m)]
        v=[sector_scale*e+(alpha-sector_scale)/m for e in ej]; vs.append(v)
        z=[1-alpha*v_i for v_i in v]
        w=[e-F(1,m) for e in ej]
        low=c.sub(c.sub(c.eye(m),c.scale(F(1,m),outer(ones))),c.scale(F(m,m-1),outer(w)))
        old=c.add(c.add(c.scale(lam,outer(v)),c.scale(mu/(m-x),outer(z))),c.scale(beta,low))
        g=[signs[j]-alpha*m/k*signs[j]*e+alpha/k*s for e,s in zip(ej,signs)]
        e=[row+[coupling_scale*g[i]] for i,row in enumerate(old)]
        e.append([coupling_scale*t for t in g]+[F(1,m)])
        f=c.diag([F(int(i==j)) for i in range(m)]+[F(1,m)])
        es.append(e); fs.append(f)
    return es,fs,vs


def verify(document):
    assert document['format']=='imperfect-packing-veto-v1'
    alpha=F(document['alpha']); scale=F(document['sector_scale']); coupling=F(document['coupling_scale'])
    assert coupling>0
    es,fs,vs=family(alpha,scale,coupling); m=6; delta=F(1,m); lam=1-delta
    assert c.sum_matrices(es)==c.sum_matrices(fs)==c.eye(m+1)
    for e,v in zip(es,vs):
        c.positive_definite(e)
        assert sum(x*x for x in v)==1
        vector=[[x] for x in v]+[[F(0)]]
        assert c.mul(e,vector)==c.scale(lam,vector)
        assert c.trace(e)-lam==F(2,m)<1-delta
    synthesis=c.transpose(vs)
    expected=c.add(c.scale(scale,c.eye(m)),c.scale((alpha-scale)/m,outer([F(1)]*m)))
    assert synthesis==expected
    # Its eigenvalues are alpha on the constant vector and scale otherwise.
    # Hence its polar factor is I and the displayed F is the prescribed target.
    signs=document['witness_signs']; assert len(signs)==m and all(s in (-1,1) for s in signs)
    vector=[F(x) for x in document['witness_vector']]; assert len(vector)==m+1
    norm=sum(x*x for x in vector); assert norm>0
    rho=c.scale(1/norm,outer(vector))
    signed=c.sum_matrices([c.scale(s,c.sub(e,f)) for s,e,f in zip(signs,es,fs)])
    objective=c.trace(c.mul(signed,rho))
    root_upper=F(document['sqrt_delta_upper']); assert root_upper>0 and root_upper**2>=delta and root_upper<2
    candidate_upper=F(document['candidate_upper']); assert candidate_upper>0
    b_upper=2*root_upper/(2-root_upper)
    assert candidate_upper**2>=1-alpha**2+b_upper**2
    lower=F(document['witness_lower']); assert objective>=lower>candidate_upper
    # The written all-m construction supplies this second, analytic veto.
    large_m=64; large_alpha=F(9,10); a=large_m-(large_m-1)*large_alpha**2
    lower_squared=a*(large_m-2)/(large_m*(large_m-2)+a)
    linear_candidate=2*(1-large_alpha)+2*F(1,8)/(2-F(1,8))
    assert linear_candidate==F(1,3) and lower_squared>linear_candidate**2
    return dict(result='PASS',dimension=7,outcomes=6,alpha=alpha,delta=delta,
                system_witness_lower=lower,system_witness_value=objective,
                euclidean_candidate_upper=candidate_upper,strict_violation=lower-candidate_upper,
                linear_veto=dict(m=large_m,alpha=large_alpha,delta=F(1,large_m),
                                 analytic_lower_squared=lower_squared,candidate_upper=linear_candidate))


def main():
    source=OUT/'veto_certificate.json'; result=verify(json.loads(source.read_text(encoding='utf-8')))
    paths=[source,Path(__file__).resolve(),ROOT/'experiments/verify_exact_completion_comparison.py',ROOT/'theory/imperfect_packing_lower_bound.md']
    report=dict(**c.serializable(result),scope='Exact counterexamples to proposed extensions; the frozen bound is not contradicted.',
                source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths})
    (OUT/'veto_verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS witness >=',result['system_witness_lower'],'>',result['euclidean_candidate_upper'],'>= proposed Euclidean bound.',flush=True)


if __name__=='__main__': main()
