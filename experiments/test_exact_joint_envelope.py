"""Independent numerical checks of the uniform-threshold exact-envelope proof.

Tests the original POVM, floor split, signed Kraus identities, combined Gram
bound, arbitrary complex amplified inputs, and selected full primal/dual SDPs.
All numerical checks are finite diagnostics, not universal certificates.
"""
from pathlib import Path
import json
import sys
import numpy as np
sys.path.insert(0,str(Path(__file__).resolve().parent))
from test_theorem_v1_contract import mixed_povm,build_rounding,hermitian,psd_sqrt,operator_norm,HypothesisError
from search_prescribed_completion import choose_threshold,DiamondSolver
from test_joint_second_order import lifted_example,norm1
from attack_exact_joint_envelope import construct_povm

OUT=Path(__file__).resolve().parents[1]/'research/exact_joint_envelope_2026-11-09'


def check_case(es,delta,rng):
    data=build_rounding(es,delta)
    n=len(es[0]); c=1-delta; U=data.polar; H=data.absolute
    R=data.residual_projector; C=np.sqrt(c)*H
    alpha=data.alpha; m=alpha*np.sqrt(c); b=np.sqrt(1-m*m); k=1/b-.5
    I=np.eye(len(C)); Ip=np.eye(n)
    assert 0<b<1 and 0<m<1
    selected=[c*p for p in data.projectors]
    rest=[hermitian(e-a) for e,a in zip(es,selected)]
    assert min(np.linalg.eigvalsh(a)[0] for a in rest)>-3e-10
    C2=hermitian(C@C)
    G=U@psd_sqrt(I-C2)@U.conj().T
    L=R+G
    assert operator_norm(sum(rest)-L@L)<3e-10
    assert operator_norm(G@R)<3e-10
    vals,vecs=np.linalg.eigh(hermitian(L))
    inv=(vecs*np.where(vals>1e-10,1/np.maximum(vals,1e-10),0))@vecs.conj().T
    N=[psd_sqrt(a)@inv for a in rest]
    NG=hermitian(sum(a.conj().T@a for a in N))
    assert np.linalg.eigvalsh(Ip-NG)[0]>-2e-8
    A=(C-m*I)/b; B=(I-m*C)/b
    Ar=(.5+k)*G+R; Br=(.5-k)*G+R
    total=Ar.conj().T@NG@Ar+Br.conj().T@NG@Br+2*k*U@(A@A+B@B)@U.conj().T
    gram_margin=np.linalg.eigvalsh(hermitian(2*Ip-total))[0]
    assert gram_margin>-4e-8
    polynomial=2*(k*k+.25)*(I-C2)+2*k*(A@A+B@B)
    factor=4/b**3*(C-m*I)@(m*I-(1-b)*C)
    assert operator_norm(2*I-polynomial-factor)<3e-8
    assert np.linalg.eigvalsh(hermitian(factor))[0]>-2e-8
    Y=rng.normal(size=C.shape)+1j*rng.normal(size=C.shape)
    assert operator_norm(A@Y@A-B@Y@B-(C@Y@C-Y))<2e-9
    Z=rng.normal(size=(n,n))+1j*rng.normal(size=(n,n))
    assert operator_norm(Ar@Z@Ar-Br@Z@Br-2*k*(L@Z@L-R@Z@R))<3e-8
    bound=1/k; worst=0.
    for anc in [1,2,3]:
        X=rng.normal(size=(n*anc,n*anc))+1j*rng.normal(size=(n*anc,n*anc));X/=norm1(X)
        actual=sum(norm1(np.einsum('ji,iajb->ab',e-f,X.reshape(n,anc,n,anc)))
            for e,f in zip(es,data.completed_effects))
        assert actual<=bound+2e-8
        worst=max(worst,actual/bound)
    return dict(dimension=n,outcomes=len(es),alpha=float(alpha),delta=float(delta),
        epsilon=float(b*b),bound=float(bound),gram_margin=float(gram_margin),
        complex_input_ratio=float(worst),commutator_norm=float(operator_norm(data.sector_square_root@H-H@data.sector_square_root)))


def main():
    if not __debug__:raise RuntimeError('Run without -O')
    OUT.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(2026110902); rows=[]; sdp_cases=[]
    for ranks in [[1,1,1],[2,1,1],[2,2,1],[1,1,1,1]]:
        for noise in [.001,.01,.05,.15,.3,.5,.65]:
            for _ in range(5):
                es=mixed_povm(ranks,2,noise,rng)
                try:delta,_=choose_threshold(es,ranks)
                except HypothesisError:continue
                rows.append(check_case(es,delta,rng))
    for label in ['best_small_error','filter_stress','selected_stress']:
        obj=np.load(OUT.parent/'exact_joint_attack_2026-11-09'/(label+'.npz'))
        H,D,u=obj['H'],obj['D'],obj['u']
        es,_,_,_=construct_povm(H,D,u)
        delta=1-np.diag(D).min()**2+1e-7
        rows.append(check_case(es,delta,rng))
    for alpha,delta in [(1.,.2),(.8,.4),(.4,.45),(.05,.49)]:
        es,ps,qs,fs,psi,T,eps,m=lifted_example(alpha,delta)
        # Closed-threshold equality is proved analytically; add a tiny buffer
        # for this independent numerical reconstruction of the canonical map.
        row=check_case(es,delta+1e-7,rng);rows.append(row)
        info,arrays=DiamondSolver(len(es[0]),len(es)).solve(es,fs,force_solver='CLARABEL')
        exact_value=2*np.sqrt(eps)/(2-np.sqrt(eps))
        assert info['numerical_lower']<=exact_value+2e-7
        assert info['numerical_upper']>=exact_value-2e-7
        assert info['numerical_upper']-info['numerical_lower']<3e-6
        sdp_cases.append(dict(alpha=alpha,delta=delta,epsilon=eps,predicted=exact_value,**info))
        print('SDP checked',alpha,delta,'gap',info['gap'],flush=True)
    report=dict(result='PASS',scope='Finite numerical checks; universal argument is in the proof note',
        cases=rows,complex_inputs=3*len(rows),sdp_cases=sdp_cases)
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS',len(rows),'operator cases;',3*len(rows),'complex amplified inputs;',len(sdp_cases),'primal/dual SDPs')


if __name__=='__main__':main()
