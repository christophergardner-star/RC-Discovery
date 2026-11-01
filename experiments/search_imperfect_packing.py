"""Structured lower-bound family and numerical attacks for alpha<1.

The analytic lower bound is proved in theory/imperfect_packing_lower_bound.md.
Tested candidate upper envelopes are conjectures, not accepted theorems.
"""
import hashlib
from importlib.metadata import version
import json
import math
from pathlib import Path
import numpy as np
from search_prescribed_completion import DiamondSolver, cheap_distance, normalized_effects, choose_threshold
from test_theorem_v1_contract import build_rounding, mixed_povm, psd_sqrt, HypothesisError, operator_norm

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/imperfect_packing_2026-11-01'
SEED=2026110111


def coupled_simplex(m,alpha):
    assert m>=4 and m%2==0 and 0<alpha<=1
    x=alpha**2; c=np.sqrt((m-x)/(m-1)); k=alpha+c*(m-2)
    lam=1-1/m; mu=(m-(m-1)*x)/(m*(m-x)); beta=x/(m*(m-x))
    u=np.ones(m)/np.sqrt(m); signs=np.array([1.]*(m//2)+[-1.]*(m//2)); w=signs/np.sqrt(m)
    cost=(m*(m-2)**2/mu+x*(m-2)/beta)/((m-1)*k*k)
    es=[]; fs=[]
    for j in range(m):
        ej=np.eye(m)[:,j]; wj=(ej-u/np.sqrt(m))/np.sqrt(1-1/m)
        vj=alpha/np.sqrt(m)*u+np.sqrt(1-x/m)*wj
        zj=np.sqrt(1-x/m)*u-alpha/np.sqrt(m)*wj
        old=lam*np.outer(vj,vj)+mu*np.outer(zj,zj)+beta*(np.eye(m)-np.outer(u,u)-np.outer(wj,wj))
        raw=signs[j]*u-alpha*np.sqrt(m)/k*signs[j]*ej+alpha/k*w
        coupling=raw/np.sqrt(m*cost)
        e=np.zeros((m+1,m+1)); e[:m,:m]=old; e[:m,m]=coupling; e[m,:m]=coupling; e[m,m]=1/m
        f=np.zeros_like(e); f[j,j]=1; f[m,m]=1/m
        es.append(e); fs.append(f)
    psi=np.r_[u,1.]/np.sqrt(2)
    a=m-(m-1)*x
    lower=np.sqrt(a*(m-2)/(m*(m-2)+a))
    return es,fs,psi,lower


def metrics(es,delta,label,ranks=None):
    data=build_rounding(es,delta); fs=data.completed_effects
    _,system,entangled=cheap_distance([e-f for e,f in zip(es,fs)])
    alpha=min(1.,data.alpha); a=np.sqrt(1-alpha*alpha); b=2*np.sqrt(delta)/(2-np.sqrt(delta))
    row=dict(label=label,dimension=len(es[0]),outcomes=len(es),alpha=alpha,delta=delta,
             system_only=system,maximally_entangled=entangled,proxy=max(system,entangled),
             frozen_bound=min(2.,2*(a+np.sqrt(delta))),
             candidate_linear=min(2.,2*(1-alpha)+b),
             candidate_euclidean=min(2.,np.sqrt(a*a+b*b)))
    row['candidate_euclidean_ratio']=row['proxy']/row['candidate_euclidean']
    assert row['proxy']<=row['frozen_bound']+1e-7
    return row,fs


def main():
    OUT.mkdir(parents=True,exist_ok=True); rng=np.random.default_rng(SEED)
    structured=[]; random_rows=[]; finalists=[]; rejected=0
    for m in [4,6,8,12,24,48,64]:
        for alpha in [.001,.05,.2,.5,.8,.9,.99,1.]:
            es,fs,psi,lower=coupled_simplex(m,alpha)
            observed=sum(abs(np.vdot(psi,(e-f)@psi)) for e,f in zip(es,fs))
            assert abs(observed-lower)<2e-10
            assert operator_norm(sum(es)-np.eye(m+1))<2e-10
            assert min(np.linalg.eigvalsh(e)[0] for e in es)>-2e-10
            delta=(1+1e-8)/m # Numerical threshold buffer; analytic threshold is exactly 1/m.
            data=build_rounding(es,delta)
            assert abs(data.alpha-alpha)<2e-8
            assert max(operator_norm(f-g) for f,g in zip(fs,data.completed_effects))<2e-8
            row=dict(m=m,alpha=alpha,analytic_delta=1/m,numerical_delta=delta,
                     lower_formula=lower,observed_witness=float(observed),
                     candidate_linear=2*(1-alpha)+2/np.sqrt(m)/(2-1/np.sqrt(m)))
            structured.append(row)
            if m in [4,6] and alpha in [.5,.9]:
                detail,_=metrics(es,delta,f'structured_{m}_{alpha}')
                finalists.append((detail,es,fs))
    # Search beyond the structured family, including factor perturbations.
    for ranks,residual in [([1,1,1],1),([2,1,1],1),([1]*5,1)]:
        pool=[]; leader=None
        for trial in range(240):
            if trial<40 or not pool or rng.random()<.15:
                noise=float(np.exp(rng.uniform(np.log(.002),np.log(.65))))
                es=mixed_povm(ranks,residual,noise,rng)
                factors=np.array([psd_sqrt(e) for e in es])
            else:
                parent=pool[int(rng.integers(len(pool)))][1]
                step=float(np.exp(rng.uniform(np.log(.0003),np.log(.15))))
                factors=parent+step*(rng.normal(size=parent.shape)+1j*rng.normal(size=parent.shape))/np.sqrt(parent.size)
            try:
                factors,es=normalized_effects(factors)
                delta,_=choose_threshold(es,ranks)
                row,fs=metrics(es,delta,f'random_{ranks}_{residual}_{trial}')
            except HypothesisError:
                rejected+=1; continue
            random_rows.append(row)
            pool.append((row['candidate_euclidean_ratio'],factors)); pool.sort(key=lambda x:x[0],reverse=True); pool=pool[:8]
            if leader is None or row['candidate_euclidean_ratio']>leader[0]['candidate_euclidean_ratio']:
                leader=(row,es,fs)
        finalists.append(leader)
        print('Completed geometry',ranks,'candidate ratio',leader[0]['candidate_euclidean_ratio'],flush=True)
    sdps=[]
    paths=[Path(__file__).resolve(),ROOT/'experiments/search_prescribed_completion.py',ROOT/'experiments/test_theorem_v1_contract.py']
    def checkpoint(status):
        report=dict(result=status,scope='Numerical search; only the separate analytic lower-bound statement is proved.',
                    seed=SEED,structured=structured,random_cases=random_rows,rejected=rejected,sdps=sdps,
                    packages={x:version(x) for x in ['numpy','cvxpy','clarabel','scs']},
                    source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths})
        (OUT/'search.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    checkpoint('RUNNING')
    for row,es,fs in finalists:
        try: info,arrays=DiamondSolver(len(es[0]),len(es)).solve(es,fs,force_solver='CLARABEL')
        except RuntimeError as exc:
            sdps.append(dict(**row,error=str(exc))); checkpoint('RUNNING'); continue
        assert info['numerical_lower']<=row['frozen_bound']+3e-6
        artifact=f'case_{len(sdps)}.npz'
        np.savez_compressed(OUT/artifact,effects=np.array(es),completion=np.array(fs),rho=arrays['rho'],x=arrays['x'],y=arrays['y'])
        sdps.append(dict(**row,**info,artifact=artifact,artifact_sha256=hashlib.sha256((OUT/artifact).read_bytes()).hexdigest(),
                         candidate_euclidean_violation=bool(info['numerical_lower']>row['candidate_euclidean']+1e-6)))
        checkpoint('RUNNING')
        print('SDP',row['label'],info['primal'],'candidate',row['candidate_euclidean'],flush=True)
    checkpoint('PASS' if all('error' not in row for row in sdps) else 'PARTIAL_SDP')
    print('Completed',len(structured),'structured cases,',len(random_rows),'random/adaptive cases,',len(sdps),'SDP attempts.',flush=True)


if __name__=='__main__': main()
