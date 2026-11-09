"""Attack the exact-envelope conjecture using admissible noncommuting POVMs.

Numerical diagnostics only; neither a universal proof nor an exact certificate.
The construction has normalized rank-one selected columns and four clean labels
receiving the positive remainder. No numerical threshold rounding is used.
"""
from pathlib import Path
import argparse
import json
import sys
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_theorem_v1_contract import hermitian, psd_sqrt, operator_norm

OUT = Path(__file__).resolve().parents[1] / "research/exact_joint_attack_2026-11-09"


def envelope(e):
    b = np.sqrt(e)
    return 2*b/(2-b)


def evaluate(H, D):
    m = len(H)
    K = D @ H
    alpha = np.linalg.eigvalsh(H)[0]
    delta = 1 - np.diag(D).min()**2
    s = 1-alpha**2+delta
    eps = 1-alpha**2*(1-delta)
    vals, vecs = np.linalg.eigh(hermitian(np.eye(m)-K.conj().T@K))
    beta2 = vals[-1]
    if not (0 < delta < .5 and 0 < beta2 < 1):
        return None
    u = vecs[:, -1]
    b = np.sqrt(beta2)
    z = 2-b
    selected = np.abs(K@u)**2 - np.abs(u)**2
    witness = envelope(beta2) + 2*np.maximum(selected, 0).sum()/z
    floor = np.sqrt(1-eps)
    t = np.sqrt((1-floor)/(4*(1+floor)))
    v = 1/(4*t)
    I = np.eye(m)
    A = t*(K+I)+v*(K-I)
    B = t*(K+I)-v*(K-I)
    gram_excess = np.linalg.eigvalsh(hermitian(A.conj().T@A+B.conj().T@B-eps*I))[-1]
    return dict(alpha=float(alpha),delta=float(delta),s=float(s),epsilon=float(eps),
        beta2=float(beta2),witness=float(witness),candidate=float(envelope(eps)),
        excess=float(witness-envelope(eps)),ratio=float(witness/envelope(eps)),
        selected_positive_mass=float(np.maximum(selected,0).sum()),
        filter_gram_excess=float(gram_excess),
        commutator_norm=float(operator_norm(D@H-H@D)),sector_dimension=m), u


def construct_povm(H, D, u):
    m=len(H); n=m+5
    K=D@H; Delta=hermitian(np.eye(m)-K.conj().T@K)
    b=np.sqrt(np.vdot(u,Delta@u).real); h=np.sqrt(1-b); z=2-b
    uu=np.zeros(n,dtype=complex); uu[:m]=u
    r=np.zeros(n,dtype=complex); r[-1]=1
    plus=np.outer(b*uu+h*r,(b*uu+h*r).conj())/z
    minus=np.outer(b*h*uu-r,(b*h*uu-r).conj())/z
    remainder=np.zeros((n,n),dtype=complex)
    remainder[:m,:m]=Delta-b*b*np.outer(u,u.conj())
    effects=[]; targets=[]; sectors=[]
    for j in range(m):
        v=np.zeros(n,dtype=complex); v[:m]=H[:,j]
        p=np.outer(v,v.conj()); q=np.zeros((n,n));q[j,j]=1
        effects.append(D[j,j]**2*p); sectors.append(p);targets.append(q)
    for j in range(4):
        q=np.zeros((n,n));q[m+j,m+j]=1
        effects.append(q+(plus if j<2 else minus)/2+remainder/4)
        sectors.append(q);targets.append(q)
    R=np.outer(r,r)
    completed=[q+R@e@R for q,e in zip(targets,effects)]
    psi=(uu+h*r)/np.sqrt(z)
    return effects,sectors,completed,psi


def check_full_povm(H,D,u,row):
    es,ps,fs,psi=construct_povm(H,D,u)
    I=np.eye(len(es[0])); m=len(H)
    assert operator_norm(sum(es)-I)<3e-11
    assert operator_norm(sum(fs)-I)<3e-11
    assert abs(np.vdot(psi,psi)-1)<3e-11
    threshold=1-row['delta']
    for j,(e,p,f) in enumerate(zip(es,ps,fs)):
        assert np.linalg.eigvalsh(e)[0]>-3e-11
        assert np.linalg.eigvalsh(f)[0]>-3e-11
        assert operator_norm(p@p-p)<3e-11
        eigenvalue=D[j,j]**2 if j<m else 1.
        assert eigenvalue>=threshold-3e-11
        assert operator_norm(e@p-eigenvalue*p)<3e-11
        assert np.linalg.eigvalsh(hermitian((I-p)@e@(I-p)))[-1]<threshold-1e-8
    actual=sum(abs(np.vdot(psi,(e-f)@psi)) for e,f in zip(es,fs))
    assert abs(actual-row['witness'])<3e-11
    return es,fs


def main():
    if not __debug__:raise RuntimeError('Run without -O')
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--samples',type=int,default=12000)
    args=parser.parse_args()
    OUT.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(2026110901)
    best=None; filter_best=None; small_best=None; accepted=0; small=0
    checked=0; records=[]
    for trial in range(args.samples):
        m=int(rng.choice([2,3,4,6,8]))
        Z=rng.normal(size=(m,m))+1j*rng.normal(size=(m,m))
        Z=hermitian(Z);np.fill_diagonal(Z,0)
        Z/=operator_norm(Z)
        width=10**rng.uniform(-4,-.12)
        H=psd_sqrt(np.eye(m)+width*Z)
        losses=10**rng.uniform(-4,-.2)*rng.uniform(.01,1,m)
        D=np.diag(np.sqrt(1-losses))
        D/=max(1.,operator_norm(D@H))*(1+1e-12)
        result=evaluate(H,D)
        if result is None:continue
        row,u=result; row['trial']=trial
        accepted+=1
        if row['s']<=.25:small+=1
        if trial%137==0:
            check_full_povm(H,D,u,row); checked+=1
        item=(row,H.copy(),D.copy(),u.copy())
        if best is None or row['ratio']>best[0]['ratio']:best=item
        if row['s']<=.25 and (small_best is None or row['ratio']>small_best[0]['ratio']):small_best=item
        if filter_best is None or row['filter_gram_excess']>filter_best[0]['filter_gram_excess']:filter_best=item
        if row['excess']>1e-8:records.append(row)
    for label,item in [('best_witness',best),('best_small_error',small_best),('filter_stress',filter_best)]:
        row,H,D,u=item
        check_full_povm(H,D,u,row);checked+=1
        np.savez(OUT/(label+'.npz'),H=H,D=D,u=u)
    report=dict(status='COMPLETED_NUMERICAL_ATTACK',scope='Finite tests only; not proof or exact disproof',
        attempted=args.samples,accepted=accepted,small_error_cases=small,full_povm_checks=checked,
        best_witness=best[0],best_small_error=small_best[0],filter_stress=filter_best[0],
        apparent_violations=records)
    (OUT/'search.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))


if __name__=='__main__':main()
