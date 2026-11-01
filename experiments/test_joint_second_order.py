"""Numerical attacks on the new joint second-order argument.

The analytic proof is in theory/joint_second_order.md; finite tests do not
replace that proof or its unfinished Lean formalization. No historical
certificate output is overwritten.
"""
from pathlib import Path
import json
import sys
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_theorem_v1_contract import build_rounding, mixed_povm, operator_norm, psd_sqrt
from search_prescribed_completion import choose_threshold

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research/joint_second_order_2026-11-01"


def norm1(x):
    return float(np.linalg.svd(x, compute_uv=False).sum())


def envelope(eps):
    return 2 * np.sqrt(eps) / (2 - np.sqrt(eps))


def lifted_example(alpha, delta):
    """Pure selected simplex effects plus four clean labels receiving remainder."""
    m = max(2, int(np.ceil((1-delta)*(1-alpha**2)/delta)) + 1)
    n = m + 5
    u = np.zeros(n); u[:m] = 1 / np.sqrt(m)
    rr = np.zeros(n); rr[-1] = 1
    uu = np.outer(u, u); R = np.outer(rr, rr)
    S0 = np.diag([1.] * m + [0.] * 5)
    gamma2 = (m-alpha**2)/(m-1)
    T = np.sqrt(gamma2)*np.eye(m) + (alpha-np.sqrt(gamma2))*np.ones((m,m))/m
    eps = 1 - (1-delta)*alpha**2
    b = np.sqrt(eps); h = np.sqrt(1-b); z = 2-b
    plus = np.outer(b*u+h*rr, b*u+h*rr)/z
    minus = np.outer(b*h*u-rr, b*h*u-rr)/z
    remainder = (1-(1-delta)*gamma2)*(S0-uu)
    effects=[]; projectors=[]; targets=[]
    for j in range(m):
        v=np.zeros(n); v[:m]=T[:,j]
        p=np.outer(v,v); q=np.zeros((n,n)); q[j,j]=1
        effects.append((1-delta)*p); projectors.append(p); targets.append(q)
    for j in range(4):
        p=np.zeros((n,n)); p[m+j,m+j]=1
        low=(plus if j<2 else minus)/2+remainder/4
        effects.append(p+low); projectors.append(p); targets.append(p)
    completed=[q+R@e@R for q,e in zip(targets,effects)]
    psi=(u+h*rr)/np.sqrt(z)
    return effects,projectors,targets,completed,psi,T,eps,m


def main():
    if not __debug__:
        raise RuntimeError("Run without -O")
    OUT.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(2026110131)
    examples=[]
    for delta in [.2,.1,.03,.003,.00003]:
        for ratio in [0.,.25,1.,2.,4.,8.]:
            if ratio*delta >= 1: continue
            alpha=np.sqrt(1-ratio*delta)
            es,ps,qs,fs,psi,T,eps,m=lifted_example(alpha,delta)
            n=len(es[0]); ident=np.eye(n)
            assert operator_norm(sum(es)-ident)<2e-12
            assert abs(np.linalg.svd(T,compute_uv=False).min()-alpha)<2e-12
            assert np.linalg.norm(psi)**2 > 1-2e-12
            assert abs(np.linalg.norm(psi)**2-1)<2e-12
            max_low=0.
            for j,(e,p) in enumerate(zip(es,ps)):
                assert np.linalg.eigvalsh(e).min()>-2e-12
                lam=1-delta if j<m else 1.
                assert operator_norm(e@p-lam*p)<2e-12
                low=(ident-p)@e@(ident-p)
                lowmax=np.linalg.eigvalsh(low).max()
                max_low=max(max_low,lowmax)
                assert lowmax<1-delta-1e-8
            witness=sum(abs(np.vdot(psi,(e-f)@psi)) for e,f in zip(es,fs))
            assert abs(witness-envelope(eps))<2e-11
            examples.append(dict(alpha=alpha,delta=delta,ratio=ratio,dimension=n,outcomes=len(es),
                witness=float(witness),predicted=envelope(eps),epsilon=eps,max_low_eigenvalue=max_low))

    checks=[]
    for ranks in [[1,1,1],[2,1,1],[1,1,1,1]]:
        for noise in [.0001,.003,.02,.06]:
            for trial in range(3):
                es=mixed_povm(ranks,2,noise,rng)
                delta,_=choose_threshold(es,ranks)
                data=build_rounding(es,delta)
                alpha=min(1.,data.alpha); s=1-alpha**2+delta
                if s>.25: continue
                H=data.absolute; D=data.sector_square_root; K=D@H
                A=(K+K.conj().T)/2; skew=(K-K.conj().T)/2
                tau=operator_norm(skew); eps=1-alpha**2*(1-delta)
                assert tau<=delta*s+2e-12
                lower=np.sqrt(1-eps)-tau
                assert lower>.5
                assert np.linalg.eigvalsh(A).min()>=lower-2e-11
                assert np.linalg.eigvalsh(A).max()<=1+2e-11
                loss=1-lower**2
                assert loss<=eps+2*tau+2e-12
                t=np.sqrt((1-lower)/(4*(1+lower)))
                v=1/(4*t)
                I=np.eye(len(A))
                plus=t*(A+I)+v*(A-I); minus=t*(A+I)-v*(A-I)
                gram=plus.conj().T@plus+minus.conj().T@minus
                assert np.linalg.eigvalsh(loss*I-gram).min()>-2e-10
                worst=0.
                for anc in [1,2]:
                    for _ in range(6):
                        n=len(es[0]); X=rng.normal(size=(n*anc,n*anc))+1j*rng.normal(size=(n*anc,n*anc))
                        X/=norm1(X)
                        blocks=[]
                        for e,f in zip(es,data.completed_effects):
                            blocks.append(np.einsum('ji,iajb->ab',e-f,X.reshape(n,anc,n,anc)))
                        actual=sum(norm1(x) for x in blocks)
                        bound=envelope(eps)+4*tau
                        assert actual<=bound+2e-9
                        worst=max(worst,actual/bound)
                checks.append(dict(alpha=alpha,delta=delta,s=s,epsilon=eps,tau=tau,
                    upper=envelope(eps)+4*tau,coarse_upper=envelope(eps)+4*s*s,
                    input_bound_ratio=worst))
    result=dict(result="PASS",scope="Finite numerical attacks, not a universal proof or Lean closure",
        examples=examples,upper_checks=checks,complex_input_checks=12*len(checks),
        ratio_one_dimensions=sorted(set(x['dimension'] for x in examples if x['ratio']==1)))
    (OUT/'verification.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf8')
    print('PASS',len(examples),'constructed lower examples;',len(checks),'upper cases;',
          result['complex_input_checks'],'complex-input checks; ratio-one dimensions',result['ratio_one_dimensions'])


if __name__=='__main__': main()
