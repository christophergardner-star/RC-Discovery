"""Propose rational crossover endpoints; only the exact checker accepts them."""
from fractions import Fraction as F
import json
import math
from pathlib import Path
import numpy as np
import mpmath as mp
import scs
from build_exact_completion_comparison import pack
from search_prescribed_completion import DiamondSolver
from verify_completion_crossover import packed_family_heads, verify_crossover

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'research/completion_crossover_2026-11-01'
DEN = 10**40


def mp_pack(a):
    return dict(denominator=DEN,
                real=[[int(mp.nint(a[i,j]*DEN)) for j in range(a.cols)] for i in range(a.rows)],
                imag=[[0]*a.cols for _ in range(a.rows)])


def mp_polar(a):
    values, vectors = mp.eigsy(a.T*a)
    h = vectors*mp.diag([mp.sqrt(x) for x in values])*vectors.T
    u = a*h**-1
    return u, dict(isometry=mp_pack(u),positive_factor=mp_pack(h))


def as_numpy(a):
    return np.array(a.tolist(),dtype=float)


class ProposalSolver(DiamondSolver):
    def solve(self, original, rounded):
        # Even an inaccurate solver status may propose a valid rational witness.
        # Acceptance is exclusively by exact rational positive-definiteness below.
        for param, e, f in zip(self.diff, original, rounded):
            param.value = (e-f).T
        options = dict(solver='SCS',eps=1e-13,max_iters=1000000)
        pv = self.primal.solve(**options,warm_start=False,canon_backend=self.cp.SCIPY_CANON_BACKEND)
        dv = self.dual.solve(**options,warm_start=False,canon_backend=self.cp.SCIPY_CANON_BACKEND)
        return dict(primal=float(pv),dual=float(dv),primal_status=self.primal.status,
                    dual_status=self.dual.status,options=options), dict(
            rho=self.rho.value,x=[x.value for x in self.x],y=[y.value for y in self.y])


def propose(t, expected, solver):
    mp.mp.dps = 60
    heads = packed_family_heads(t)
    es = [mp.matrix(p['real'])/p['denominator'] for p in heads]
    es.append(mp.eye(4)-es[0]-es[1])
    models, columns, roots = [], [], []
    den = DEN
    for e in es:
        values, vectors = mp.eigsy(e)
        assert sum(x > mp.mpf('.75') for x in values) == 1
        z = mp_pack(vectors)
        eigs = [int(mp.nint(x*den)) for x in values]
        sqrts = [int(mp.nint(mp.sqrt(x)*den)) for x in values]
        models.append(dict(vectors=z, denominator=den, eigenvalues=eigs, root_weights=sqrts))
        columns.append(vectors[:,3])
        roots.append(mp.sqrt(values[3]))
    t0 = mp.matrix([[columns[j][i] for j in range(3)] for i in range(4)])
    u, up = mp_polar(t0)
    w, wp = mp_polar(t0*mp.diag(roots))
    r = mp.eye(4)-u*u.T
    case = dict(id=f't={t}', parameter=str(t), dimension=4, outcomes=3,
                effects_head=packed_family_heads(t), delta='1/4', ranks=[1,1,1],
                alpha_reference_lower='9/10', spectral_models=models,
                unweighted_polar=up, weighted_polar=wp,
                sdp_padding='1/1000000000000', expected_closer=expected)
    diagnostics = {}
    for field, v in [('unweighted', u), ('weighted', w)]:
        target = [v[:,j]*v[:,j].T+r*e*r for j,e in enumerate(es)]
        info, arrays = solver.solve([as_numpy(e) for e in es],[as_numpy(f) for f in target])
        diagnostics[field] = info
        case[field] = dict(effects=[mp_pack(f) for f in target],
                           rho=pack(arrays['rho'],10**15,True),
                           x=[pack(x,10**15,True) for x in arrays['x']],
                           y=[pack(y,10**15,True) for y in arrays['y']],
                           dual_upper=f"{math.ceil(info['dual']*10**12)}/{10**12}")
    return case, diagnostics


def main():
    solver = ProposalSolver(4,3)
    cases, numerical = [], []
    for t, expected in [(F('2.33690021'),'unweighted'), (F('2.33690023'),'weighted')]:
        case, info = propose(t,expected,solver)
        cases.append(case)
        numerical.append(dict(parameter=str(t), **info))
    document = dict(format='completion-crossover-v1', cases=cases)
    verify_crossover(document)
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'certificates.json').write_text(json.dumps(document,indent=2)+'\n',encoding='utf-8')
    (OUT/'proposal_diagnostics.json').write_text(json.dumps(dict(
        scope='Floating-point proposal diagnostics only; use verification.json for conclusions.',
        operator_precision_decimal_digits=60, operator_rational_denominator=DEN,
        versions=dict(mpmath=mp.__version__,numpy=np.__version__,cvxpy=solver.cp.__version__,scs=scs.__version__),
        points=numerical),indent=2)+'\n',encoding='utf-8')
    print('Prepared and exactly verified both endpoints.',flush=True)


if __name__ == '__main__':
    main()
