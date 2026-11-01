"""Structured alpha=1 attacks and reference-assisted numerical SDP checks.

This is numerical support, not the proof. Exact certificates are separate.
"""
import hashlib
from importlib.metadata import version
import json
from pathlib import Path
import sys
import numpy as np
from search_prescribed_completion import DiamondSolver, cheap_distance
from test_theorem_v1_contract import build_rounding, operator_norm

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/perfect_packing_sharpness_2026-11-01'
SEED=2026110107


def rotated_family(delta,theta,phase=0.):
    b=np.sqrt(delta)
    v=np.array([np.cos(theta),np.exp(1j*phase)*np.sin(theta)])
    n=np.outer(v,v.conj()); root=np.diag([b,1.])
    lows=[root@n@root,root@(np.eye(2)-n)@root]
    es=[np.diag([1-delta,0,0,0,0,0]).astype(complex)]
    for j,low in enumerate([lows[0],lows[0],lows[1],lows[1]],1):
        e=np.zeros((6,6),complex); e[j,j]=1
        e[np.ix_([0,5],[0,5])]+=low/2
        es.append(e)
    return es


def mixture(delta,ranks,residual,rng):
    m=len(ranks); d=sum(ranks)+residual; offset=np.cumsum([0]+ranks)
    ps=[]
    for j in range(m):
        p=np.zeros((d,d),complex); p[offset[j]:offset[j+1],offset[j]:offset[j+1]]=np.eye(ranks[j]); ps.append(p)
    r=np.eye(d)-sum(ps); output=[np.zeros((d,d),complex) for _ in ranks]
    weights=rng.dirichlet(np.ones(8))
    for weight in weights:
        central=int(rng.integers(m))
        labels=rng.choice([j for j in range(m) if j!=central],4,replace=False)
        u=np.zeros(d,complex); v=np.zeros(d,complex)
        z=rng.normal(size=ranks[central])+1j*rng.normal(size=ranks[central]); z/=np.linalg.norm(z)
        u[offset[central]:offset[central+1]]=z
        z=rng.normal(size=residual)+1j*rng.normal(size=residual); z/=np.linalg.norm(z)
        v[-residual:]=z
        active=np.stack([u,v],axis=1)
        theta=float(rng.uniform(0,np.pi/2)); phase=float(rng.uniform(0,2*np.pi))
        nvec=np.array([np.cos(theta),np.exp(1j*phase)*np.sin(theta)])
        n=np.outer(nvec,nvec.conj()); root=np.diag([np.sqrt(delta),1.])
        lows=[root@n@root,root@(np.eye(2)-n)@root]
        unused=(r-np.outer(v,v.conj()))/m
        es=[p+unused for p in ps]
        es[central]=es[central]-delta*np.outer(u,u.conj())
        for label,low in zip(labels,[lows[0],lows[0],lows[1],lows[1]]):
            es[label]=es[label]+active@low@active.conj().T/2
        output=[old+weight*e for old,e in zip(output,es)]
    return output


def assess(es,delta,label):
    data=build_rounding(es,delta)
    assert abs(data.alpha-1)<2e-9
    fs=data.completed_effects
    errors=[operator_norm(sum(es)-np.eye(len(es[0])))]
    for p,e,f in zip(data.projectors,es,fs):
        errors += [operator_norm(p@e-e@p),operator_norm(f-(p+data.residual_projector@e@data.residual_projector))]
    proxy,system,entangled=cheap_distance([e-f for e,f in zip(es,fs)])
    bound=2*np.sqrt(delta)/(2-np.sqrt(delta))
    assert proxy<=bound+2e-8
    return dict(label=label,delta=delta,dimension=len(es[0]),outcomes=len(es),
                alpha=data.alpha,bound=bound,system_only=system,maximally_entangled=entangled,
                proxy=proxy,ratio_to_bound=proxy/bound,max_identity_error=max(errors)),fs


def main():
    rng=np.random.default_rng(SEED); rows=[]; sdp_cases=[]
    deltas=[1e-4,.01,.16,.49]
    for delta in deltas:
        for i,theta in enumerate(np.linspace(0,np.pi/2,41)):
            es=rotated_family(delta,float(theta))
            row,_=assess(es,delta,f'rotation_{delta}_{i}'); rows.append(row)
        theta=np.arctan(np.sqrt(1-np.sqrt(delta)))
        es=rotated_family(delta,theta)
        row,fs=assess(es,delta,f'sharp_{delta}'); rows.append(row)
        assert abs(row['system_only']-row['bound'])<2e-10
        sdp_cases.append((row,es,fs))
    for ranks,residual in [([1]*5,1),([2,1,2,1,1],2),([1]*8,2)]:
        for delta in deltas:
            for trial in range(12):
                es=mixture(delta,ranks,residual,rng)
                row,fs=assess(es,delta,f'mixture_{ranks}_{residual}_{delta}_{trial}')
                rows.append(row)
                if trial==0 and delta==.16:
                    sdp_cases.append((row,es,fs))
    sdps=[]; solvers={}
    OUT.mkdir(parents=True,exist_ok=True)
    def checkpoint(status, failure=None):
        report=dict(result=status,
                    scope='Floating-point structured attacks, not a universal proof or exact feasibility certificate.',
                    seed=SEED,cases=len(rows),planned_sdp_cases=len(sdp_cases),
                    sdp_cases=len(sdps),rows=rows,sdps=sdps,failure=failure,
                    python=sys.version,
                    packages={name:version(name) for name in ('numpy','cvxpy','clarabel','scs')},
                    max_identity_error=max(r['max_identity_error'] for r in rows),
                    maximum_proxy_to_sharp_bound=max(r['ratio_to_bound'] for r in rows),
                    source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in [Path(__file__).resolve(),ROOT/'experiments/search_prescribed_completion.py',ROOT/'experiments/test_theorem_v1_contract.py']})
        (OUT/'numerical_search.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    checkpoint('RUNNING')
    for row,es,fs in sdp_cases:
        key=(len(es[0]),len(es)); solver=solvers.setdefault(key,DiamondSolver(*key))
        try:
            # The largest complex problem uses the helper's 1e-7 interior-point
            # tolerances. Independent gap/feasibility checks remain mandatory;
            # an inaccurate status alone never establishes numerical success.
            info,_=solver.solve(es,fs,force_solver='CLARABEL' if key[0]>=10 else None)
            assert info['numerical_lower']<=row['bound']+3e-7
            assert info['numerical_upper']<=row['bound']+3e-6
            if row['label'].startswith('sharp'):
                assert abs(info['primal']-row['bound'])<3e-7
        except Exception as exc:
            checkpoint('FAIL',dict(label=row['label'],error=str(exc)))
            raise
        sdps.append(dict(**row,**info))
        checkpoint('RUNNING')
        print('PASS SDP',row['label'],'primal',info['primal'],'bound',row['bound'],flush=True)
    checkpoint('PASS')
    print('PASS',len(rows),'structured cases and',len(sdps),'SDPs.',flush=True)


if __name__=='__main__':
    main()
