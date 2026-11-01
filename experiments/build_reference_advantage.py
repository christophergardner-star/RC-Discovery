"""Numerical proposal for an independently checked rational certificate."""
from fractions import Fraction as F
import hashlib
import json
import math
import numpy as np
from search_perfect_packing_sharpness import mixture, SEED
from search_prescribed_completion import DiamondSolver, cheap_distance
import verify_reference_advantage as v


def packed(a,den=10**8):
    r=np.rint(a.real*den).astype('int64'); q=np.rint(a.imag*den).astype('int64')
    r=np.triu(r)+np.triu(r,1).T; q=np.triu(q,1)-np.triu(q,1).T
    return dict(denominator=den,real=r.tolist(),imag=q.tolist())


def generate():
    rng=np.random.default_rng(SEED); selected=None
    for ranks,residual in [([1]*5,1),([2,1,2,1,1],2),([1]*8,2)]:
        for delta in [1e-4,.01,.16,.49]:
            for trial in range(12):
                es=mixture(delta,ranks,residual,rng)
                if len(ranks)==8 and delta==.16 and trial==0: selected=es
    d=10; m=8; den=10**8
    baseline=[]
    for j in range(m):
        values=[.08/(m-1)]*m+[1/m]*(d-m); values[j]=.92
        baseline.append(np.diag(values))
    # Strict spectral/positivity margins permit rational rounding.
    es=[.99*e+.01*z for e,z in zip(selected,baseline)]
    packs=[packed(e,den) for e in es]
    # Enforce normalization entrywise using a label whose own sector is absent.
    for a in range(d):
        for b in range(a,d):
            label=next(j for j in range(m) if a==b or j not in (a,b))
            for component in ('real','imag'):
                target=den if component=='real' and a==b else 0
                value=target-sum(p[component][a][b] for j,p in enumerate(packs) if j!=label)
                packs[label][component][a][b]=value
                packs[label][component][b][a]=value if component=='real' else -value
    es=[(np.array(p['real'])+1j*np.array(p['imag']))/den for p in packs]
    fs=[]
    for j,e in enumerate(es):
        f=np.zeros((d,d),complex); f[j,j]=1; f[m:,m:]=e[m:,m:]; fs.append(f)
    _,system,_=cheap_distance([e-f for e,f in zip(es,fs)])
    info,arrays=DiamondSolver(d,m).solve(es,fs,force_solver='CLARABEL')
    upper=F(math.ceil(system*10000)+1,10000)
    lower=F(math.floor((info['primal']-.0001)*10000),10000)
    document=dict(format='reference-advantage-v1',dimension=d,outcomes=m,delta='17/100',
                  effects=packs,rho_raw=packed(arrays['rho']),x_raw=[packed(x) for x in arrays['x']],
                  identity_shift='1/1000000',system_upper=str(upper),reference_lower=str(lower))
    v.OUT.mkdir(parents=True,exist_ok=True)
    (v.OUT/'certificate.json').write_text(json.dumps(document,indent=2)+'\n',encoding='utf-8')
    proposal=dict(scope='Floating-point proposal only; certificate must pass independent exact verification.',
                  seed=SEED,system=system,solver=info,
                  source_text_sha256={p.relative_to(v.ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in [v.ROOT/'experiments/build_reference_advantage.py',v.ROOT/'experiments/search_perfect_packing_sharpness.py',v.ROOT/'experiments/search_prescribed_completion.py']})
    (v.OUT/'proposal.json').write_text(json.dumps(proposal,indent=2)+'\n',encoding='utf-8')
    print('Proposed',upper,'<',lower,flush=True)
    result=v.verify(document)
    print('Exact verification passed:',result['strict_advantage'],flush=True)


if __name__=='__main__': generate()
