"""Check linear reducing-span rates and residual-coupling bound (not a proof)."""
import json
from pathlib import Path
import numpy as np
import cvxpy as cp
from test_adversarial_same_label import mixed, root, herm, op, diamond_sdp
from test_spectral_threshold_rate import family

RNG = np.random.default_rng(2026103111)
OUT = Path(__file__).resolve().parents[1] / 'research/progress_validation'


def check(effects, delta, reducing, solve=False):
    d = len(effects[0])
    bases = []
    for e in effects:
        vals, vecs = np.linalg.eigh(herm(e))
        bases.append(vecs[:, vals >= 1-delta])
    t = np.concatenate(bases, axis=1)
    left, sv, right = np.linalg.svd(t, full_matrices=False)
    assert t.shape[1] <= d and sv[-1] > 1e-8
    u = left @ right
    h = (right.conj().T * sv) @ right
    s = u @ u.conj().T
    r = np.eye(d)-s
    k = len(sv)
    dm = np.zeros((k, k), complex)
    f, offset = [], 0
    high = np.zeros((d, d), complex)
    for e, b in zip(effects, bases):
        n = b.shape[1]
        assert n > 0
        p = b @ b.conj().T
        high += p @ e @ p
        dm[offset:offset+n, offset:offset+n] = b.conj().T @ root(e) @ b
        uj = u[:, offset:offset+n]
        f.append(herm(uj @ uj.conj().T + r @ e @ r))
        offset += n
    x = dm @ h
    q = op(np.eye(k)-x.conj().T @ x)
    alpha, m = float(sv[-1]), float(sv[0])
    defect = op(high-u @ x.conj().T @ x @ u.conj().T)
    assert defect < 1e-10
    offset = 0
    for e, b in zip(effects, bases):
        n = b.shape[1]
        c = np.zeros((k, k), complex)
        c[offset:offset+n, offset:offset+n] = np.eye(n)
        p = b @ b.conj().T
        assert op(p @ e @ p-u @ x.conj().T @ c @ x @ u.conj().T) < 1e-10
        offset += n
    assert op(x) <= 1+1e-10
    assert q <= 1-(1-delta)*alpha**2+1e-10
    lin = (1+op(x))*op(x-np.eye(k))+q
    beta = op(h-np.eye(k))
    scalar = 2*(beta+(1-np.sqrt(1-delta))*m)+1-(1-delta)*alpha**2
    assert lin <= scalar+1e-10
    assert scalar <= 4*(1-alpha)+5*delta+1e-10
    coupling_bound = min(2., (lin+np.sqrt(lin*lin+4*q))/2)
    if reducing:
        assert max(op(e @ s-s @ e) for e in effects) < 1e-10
    bound = min(2., lin) if reducing else coupling_bound
    differences = [herm((e-g).T) for e, g in zip(effects, f)]
    witness = 0.
    for _ in range(12):
        z = RNG.normal(size=(d, d))+1j*RNG.normal(size=(d, d))
        rho = z @ z.conj().T
        rho /= np.trace(rho)
        sr = root(rho)
        witness = max(witness, sum(np.abs(np.linalg.eigvalsh(herm(sr @ e @ sr))).sum()
                                   for e in differences))
    assert witness <= bound+1e-8
    row = dict(d=d, m=len(effects), delta=delta, alpha=alpha, q=q, L=lin,
               reducing=reducing, bound=bound, scalar_bound=scalar,
               general_bound=coupling_bound, witness=float(witness),
               decomposition_residual=defect)
    if solve:
        row['sdp'] = diamond_sdp(differences, cp)
        assert row['sdp']['dual'] <= bound+2e-6
    return row


def main():
    rows = []
    for ranks in ([1, 1], [1, 1, 1], [2, 2], [1, 3, 2]):
        for noise in (1e-5, .001, .02, .15):
            for residual in (0, 2):
                for trial in range(2):
                    # Direct-sum residual has no coupling and no near-unit eigenvalue.
                    base = mixed(ranks, 0, noise)
                    effects = []
                    for e in base:
                        full = np.zeros((len(e)+residual, len(e)+residual), complex)
                        full[:len(e), :len(e)] = e
                        if residual:
                            full[-residual:, -residual:] = np.eye(residual)/len(base)
                        effects.append(full)
                    rows.append(check(effects, noise*1.1, True,
                                      solve=(noise == .02 and trial == 0 and len(effects[0]) <= 5)))
        print('reducing ranks', ranks, flush=True)
    for ranks in ([1, 1], [1, 1, 1], [2, 2]):
        for noise in (1e-5, .001, .02, .15):
            effects = mixed(ranks, 2, noise)
            rows.append(check(effects, noise*1.1, False, solve=(noise == .02)))
    for delta in (1e-2, 1e-4, 1e-6):
        effects, _ = family(delta)
        rows.append(check(effects, delta*(1+1e-6), False, solve=True))
    exact = []
    for m in (2, 3, 5):
        for noise in (.0001, .01, .1):
            effects = []
            for j in range(m):
                e = np.eye(m)*noise/m
                e[j, j] += 1-noise
                effects.append(e)
            row = check(effects, noise, True, solve=True)
            value = 2*noise*(1-1/m)
            assert abs(row['sdp']['primal']-value) < 2e-6
            row['exact_distance'] = value
            exact.append(row)
    result = dict(seed=2026103111, imported_povm_seed=2026103107,
                  cases=rows, exact_linear_family=exact,
                  sdp_count=sum('sdp' in r for r in rows+exact))
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT/'residual_coupling.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    print('PASS', len(rows), 'general/reducing cases;', len(exact),
          'exact linear cases;', result['sdp_count'], 'primal/dual SDPs')


if __name__ == '__main__':
    main()
