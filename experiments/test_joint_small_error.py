"""Adversarial numerical checks of the joint-asymptotic proof's operator steps.

The universal theorem is the written proof, not this finite experiment.
Uses existing generators and full diamond SDP code; retains solver diagnostics.
"""
from fractions import Fraction as F
import hashlib
from importlib.metadata import version
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import numpy as np
from test_theorem_v1_contract import build_rounding, mixed_povm, operator_norm, psd_sqrt
from search_prescribed_completion import DiamondSolver, choose_threshold
from search_imperfect_packing import coupled_simplex

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'research/joint_small_error_2026-11-01'
SEED=2026110117


def trace_norm(x):
    return float(np.abs(np.linalg.eigvalsh((x+x.conj().T)/2)).sum())


def check_case(es,delta,rng,label):
    data=build_rounding(es,delta)
    alpha=min(1.,data.alpha); d=np.sqrt(1-delta)
    eps=1-alpha*alpha*(1-delta)
    h=max(1-alpha,1/d-1)+1-d
    upper=min(2.,2*np.sqrt(eps)/np.sqrt(4-eps)+2*h)
    u,H,D=data.polar,data.absolute,data.sector_square_root
    s,r=data.total_projector,data.residual_projector
    aa=[p@e@p for p,e in zip(data.projectors,es)]
    bb=[e-a for e,a in zip(es,aa)]
    delta_op=s-sum(aa); ll=r+delta_op
    identity_defect=operator_norm(sum(aa)-u@H@D@D@H@u.conj().T)
    assert identity_defect<2e-8
    assert min(np.linalg.eigvalsh(delta_op))>-2e-8
    assert min(np.linalg.eigvalsh(eps*s-delta_op))>-2e-8
    assert operator_norm(D@H)<=1+2e-8
    eta=operator_norm(D@H-np.eye(len(H)))
    assert eta<=h+2e-8
    assert min(min(np.linalg.eigvalsh(b)) for b in bb)>-2e-8
    vals,vecs=np.linalg.eigh((ll+ll.conj().T)/2)
    mask=vals>1e-11
    inv=(vecs[:,mask]/np.sqrt(vals[mask]))@vecs[:,mask].conj().T
    support=vecs[:,mask]@vecs[:,mask].conj().T
    ns=[inv@b@inv for b in bb]
    ns[0]+=np.eye(len(ll))-support
    assert operator_norm(sum(ns)-np.eye(len(ll)))<2e-6
    root=psd_sqrt(ll)
    identity_defect=max(identity_defect,max(operator_norm(b-root@n@root) for b,n in zip(bb,ns)))
    assert identity_defect<2e-8
    worst=0.; correction_ratio=0.; residual_ratio=0.; inputs=0
    for ancilla in [1,2,len(ll)]:
        for _ in range(5):
            psi=rng.normal(size=(len(ll),ancilla))+1j*rng.normal(size=(len(ll),ancilla))
            psi/=np.linalg.norm(psi)
            p=float(np.trace(psi.conj().T@s@psi).real)
            q=max(0.,1-p)
            t=max(0.,float(np.trace(psi.conj().T@delta_op@psi).real))
            x=root@psi; y=r@psi
            first=[x.conj().T@n@x-y.conj().T@n@y for n in ns]
            second=[psi.conj().T@(a-qj)@psi for a,qj in zip(aa,data.sector_projectors)]
            actual=[psi.conj().T@(e-f)@psi for e,f in zip(es,data.completed_effects)]
            # All blocks are transposes of the usual output-reference convention;
            # simultaneous transposition preserves each Hermitian trace norm.
            assert max(operator_norm(v-b-c) for v,b,c in zip(actual,first,second))<3e-8
            n1=sum(trace_norm(b) for b in first); n2=sum(trace_norm(b) for b in second)
            bound1=np.sqrt(t*t+4*t*q)
            assert n1<=bound1+3e-7
            assert n2<=2*eta*p+3e-8
            value=sum(trace_norm(v) for v in actual)
            state_upper=2*h*p+np.sqrt(max(0.,eps*eps*p*p+4*eps*p*(1-p)))
            assert value<=state_upper+3e-7
            assert value<=upper+3e-7
            if upper<2:
                assert state_upper<=upper+3e-7
            worst=max(worst,value/upper)
            correction_ratio=max(correction_ratio,n2/max(2*eta*p,1e-12))
            residual_ratio=max(residual_ratio,n1/max(bound1,1e-12))
            inputs+=1
    return dict(label=label,dimension=len(ll),outcomes=len(es),alpha=alpha,delta=delta,
                epsilon=eps,h=h,actual_alignment_error=eta,upper=upper,
                noncommutativity=operator_norm(H@D-D@H),identity_defect=identity_defect,
                input_checks=inputs,max_input_bound_ratio=worst,
                max_correction_ratio=correction_ratio,max_residual_ratio=residual_ratio),data.completed_effects


def main():
    if not __debug__: raise RuntimeError('Run without -O.')
    OUT.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(SEED); rows=[]; finalists=[]
    for ranks,residual in [([1,1,1],1),([2,1,1],2),([2,2,2],0),([1]*8,1),([2,1],1)]:
        for noise in [.00001,.001,.03,.15,.3]:
            for trial in range(3):
                es=mixed_povm(ranks,residual,noise,rng)
                delta,_=choose_threshold(es,ranks)
                label=f'random_{ranks}_{residual}_{noise}_{trial}'
                row,fs=check_case(es,delta,rng,label); rows.append(row)
                if ranks==[1,1,1] and noise in [.001,.03,.15] and trial==0:
                    finalists.append((row,es,fs))
    for m in [4,6,8,16,32]:
        for ratio in [0.,.1,1.,2.]:
            alpha=np.sqrt(1-ratio/m)
            es,fs,psi,lower=coupled_simplex(m,alpha)
            row,_=check_case(es,(1+1e-8)/m,rng,f'simplex_{m}_{ratio}')
            row['analytic_witness']=lower
            observed=sum(abs(np.vdot(psi,(e-f)@psi)) for e,f in zip(es,fs))
            assert abs(observed-lower)<2e-10 and observed<=row['upper']+2e-8
            row['observed_witness']=float(observed)
            row['witness_upper_ratio']=float(observed/row['upper'])
            rows.append(row)
            if ratio==1 and m in [4,6]: finalists.append((row,es,fs))
    # Zero labels and a singular L are legitimate; exact binary projectors
    # make every remainder vanish while retaining nonempty active sectors.
    rows.append(check_case([np.diag([1.,0.]),np.diag([0.,1.]),np.zeros((2,2))],.1,rng,'zero_label_singular_L')[0])
    # Exact scalar checks of the all-threshold lower sandwich, using only fractions.
    scalar_checks=0
    for delta in [F(1,5),F(3,100),F(1,1000),F(7,1000000)]:
        inverse=1/(2*delta); m=2*((inverse.numerator+inverse.denominator-1)//inverse.denominator)
        for a2 in [F(0),delta,delta**2,F(1,10),1-delta]:
            lower2=F(m-2,1)/(m-1+a2)*(a2+F(1,m-1))
            sandwich=(1-2*delta)/(1+2*delta)*(a2+delta)
            assert lower2>=sandwich and F(2,m)<1-delta
            scalar_checks+=1
    # Two invalid simplifications: dropping the correction term at p=1,
    # and replacing the asymptotic equivalent by a finite-error upper bound.
    delta=F(1,10)
    assert 2*delta>delta # binary input: true distance vs first term alone
    b=F(9,25); assert 2*b/(2-b)>b # exact perfect-packing family
    asymptotics=[]
    for m in [10,100,1000,10000,1000000]:
        delta=1/m; alpha=np.sqrt(1-delta); eps=1-alpha**2*(1-delta)
        h=max(1-alpha,1/np.sqrt(1-delta)-1)+1-np.sqrt(1-delta)
        lower=np.sqrt((m-2)/(m-1+delta)*(delta+1/(m-1)))
        upper=2*np.sqrt(eps)/np.sqrt(4-eps)+2*h
        asymptotics.append(dict(m=m,lower_over_sqrt_delta=lower/np.sqrt(delta),upper_over_sqrt_delta=upper/np.sqrt(delta)))
    paths=[Path(__file__).resolve(),ROOT/'theory/joint_small_error_asymptotics.md',
           ROOT/'experiments/test_theorem_v1_contract.py',ROOT/'experiments/search_imperfect_packing.py',
           ROOT/'experiments/search_prescribed_completion.py']
    report=dict(result='RUNNING',scope='Finite numerical operator/ancilla checks and SDP diagnostics, not a proof or novelty finding.',
                seed=SEED,cases=rows,scalar_fraction_checks=scalar_checks,
                negative_controls=['cannot_drop_selected_correction','asymptotic_equivalent_not_finite_upper'],
                fixed_ratio_one_asymptotics=asymptotics,sdps=[],
                packages={x:version(x) for x in ['numpy','cvxpy','clarabel','scs']},
                source_text_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_text(encoding='utf-8').encode()).hexdigest() for p in paths})
    def save(): (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    save(); print('Operator checks passed:',len(rows),'cases;',sum(r['input_checks'] for r in rows),'reference-assisted inputs.',flush=True)
    for row,es,fs in finalists:
        info,arrays=DiamondSolver(len(es[0]),len(es)).solve(es,fs,force_solver='CLARABEL')
        assert info['numerical_lower']<=row['upper']+3e-6
        artifact=f'case_{len(report["sdps"])}.npz'
        np.savez_compressed(OUT/artifact,effects=np.array(es),completion=np.array(fs),rho=arrays['rho'],x=arrays['x'],y=arrays['y'])
        report['sdps'].append(dict(label=row['label'],new_upper=row['upper'],**info,
                                  artifact=artifact,artifact_sha256=hashlib.sha256((OUT/artifact).read_bytes()).hexdigest()))
        save(); print('SDP checked:',row['label'],flush=True)
    report['result']='PASS'; save()


if __name__=='__main__': main()
