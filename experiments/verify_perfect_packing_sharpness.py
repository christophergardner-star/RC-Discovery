"""Exact SDP certificates for the sharp alpha=1 family. Standard library only.

The universal bound is proved in theory/perfect_packing_sharpness.md.
These finite checks do not formalize that universal argument or assess novelty.
"""
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import verify_exact_completion_comparison as c

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/perfect_packing_sharpness_2026-11-01'


def psd(a, strict=False):
    """Exact Schur elimination, including the necessary zero-pivot row test."""
    assert a and all(len(row)==len(a) for row in a)
    assert a==c.transpose(a)
    work=[row.copy() for row in a]
    for k in range(len(a)):
        pivot=work[k][k]
        assert pivot>0 if strict else pivot>=0
        if pivot==0:
            assert all(work[k][i]==0 for i in range(k+1,len(a)))
            continue
        for i in range(k+1,len(a)):
            for j in range(i,len(a)):
                work[i][j]-=work[i][k]*work[j][k]/pivot
                work[j][i]=work[i][j]


def embed(a):
    out=c.zero(6,6)
    for i,ii in enumerate((0,5)):
        for j,jj in enumerate((0,5)):
            out[ii][jj]=a[i][j]
    return out


def family(h):
    h=F(h); b=1-h*h; delta=b*b; z=2-b
    assert 0<h<1 and 0<delta<F(1,2)
    plus=c.scale(1/z,[[b*b,b*h],[b*h,h*h]])
    minus=c.scale(1/z,[[b*b*h*h,-b*h],[-b*h,F(1)]])
    es=[c.diag([1-delta,F(0),F(0),F(0),F(0),F(0)])]
    fs=[c.diag([F(1),F(0),F(0),F(0),F(0),F(0)])]
    for j,low in enumerate((plus,plus,minus,minus),1):
        p=c.diag([F(int(i==j)) for i in range(6)])
        e=c.add(p,c.scale(F(1,2),embed(low)))
        f=[row.copy() for row in p]; f[5][5]=e[5][5]
        es.append(e); fs.append(f)
    rho=embed(c.scale(1/z,[[F(1),h],[h,h*h]]))
    q=c.sub(embed(c.eye(2)),rho)
    differences=[c.sub(e,f) for e,f in zip(es,fs)]
    ys=[c.scale(-1,differences[0])]
    ys += [c.add(d,c.scale(b*(1-b)/z,q)) for d in differences[1:3]]
    ys += [c.add(c.scale(-1,d),c.scale(b/z,q)) for d in differences[3:]]
    return dict(h=h,b=b,delta=delta,effects=es,completion=fs,rho=rho,
                x=[c.scale(s,rho) for s in (-1,1,1,-1,-1)],y=ys,value=2*b/z)


def parse_matrix(a):
    assert isinstance(a,list) and len(a)==6 and all(len(row)==6 for row in a)
    return [[F(v) for v in row] for row in a]


def verify_case(case):
    h=F(case['h']); b=1-h*h; delta=b*b
    assert 0<h<1 and 0<delta<F(1,2)
    assert F(case['b'])==b and F(case['delta'])==delta
    es=[parse_matrix(a) for a in case['effects']]
    fs=[parse_matrix(a) for a in case['completion']]
    assert len(es)==len(fs)==5
    expected=family(h)
    assert es==expected['effects'], 'wrong prescribed family'
    assert fs==expected['completion'], 'wrong prescribed completion'
    assert c.sum_matrices(es)==c.sum_matrices(fs)==c.eye(6)
    for j,(e,f) in enumerate(zip(es,fs)):
        psd(e); psd(f)
        assert e[j][j]>=1-delta
        assert all(e[j][k]==e[k][j]==0 for k in range(6) if k!=j)
        ix=[k for k in range(6) if k!=j]
        low=[[e[i][k] for k in ix] for i in ix]
        psd(c.sub(c.scale(1-delta,c.eye(5)),low),strict=True)
    rho=parse_matrix(case['rho']); psd(rho); assert c.trace(rho)==1
    xs=[parse_matrix(a) for a in case['x']]
    ys=[parse_matrix(a) for a in case['y']]
    assert len(xs)==len(ys)==5
    # All effects are real symmetric, so the Choi transpose leaves D_j unchanged.
    ds=[c.sub(e,f) for e,f in zip(es,fs)]
    for d,x,y in zip(ds,xs,ys):
        for sign in (-1,1):
            psd(c.add(rho,c.scale(sign,x)))
            psd(c.add(y,c.scale(sign,d)))
    value=F(case['value'])
    psd(c.sub(c.scale(value,c.eye(6)),c.sum_matrices(ys)))
    primal=sum((c.trace(c.mul(d,x)) for d,x in zip(ds,xs)),F(0))
    assert primal==value==2*b/(2-b)
    witness=sum((abs(c.trace(c.mul(d,rho))) for d in ds),F(0))
    assert witness==value
    return dict(h=h,delta=delta,sqrt_delta=b,diamond_distance=value,
                ratio_to_sqrt_delta=value/b,system_only_witness=witness,
                primal=primal,dual=value,alpha=F(1),sector_ranks=[1]*5,result='PASS')


def verify_document(document):
    assert document['format']=='perfect-packing-sharpness-v1'
    assert document['cases']
    return [verify_case(case) for case in document['cases']]


def main():
    source=OUT/'certificates.json'
    results=verify_document(json.loads(source.read_text(encoding='utf-8')))
    paths=[source,Path(__file__).resolve(),ROOT/'experiments/verify_exact_completion_comparison.py',
           ROOT/'theory/perfect_packing_sharpness.md']
    report=dict(result='PASS',arithmetic='Exact integer and Fraction arithmetic; no solver or tolerance.',
                scope='Finite primal/dual SDP certificates; the universal bound uses the separate written proof. No novelty or external-review claim.',
                source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths},
                cases=c.serializable(results))
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    for row in results:
        print('PASS delta =',row['delta'],'diamond =',row['diamond_distance'],'ratio =',row['ratio_to_sqrt_delta'])


if __name__=='__main__':
    main()
