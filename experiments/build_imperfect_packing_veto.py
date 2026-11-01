"""Propose a rational system-only witness for an exact conjecture veto."""
from fractions import Fraction as F
from itertools import product
import json
import math
import numpy as np
import verify_imperfect_packing as v


def main():
    alpha=F(13,27); scale=F(29,27); m=6; x=alpha**2; k=alpha+scale*(m-2)
    mu=(m-(m-1)*x)/(m*(m-x)); beta=x/(m*(m-x))
    cost=(m*(m-2)**2/mu+x*(m-2)/beta)/((m-1)*k*k)
    coupling=F(math.floor(10**7/(m*math.sqrt(float(cost)))),10**7)
    es,fs,_=v.family(alpha,scale,coupling)
    ds=[np.array(v.c.sub(e,f),float) for e,f in zip(es,fs)]
    best=(-1,None,None)
    for signs in product((-1,1),repeat=m):
        values,vectors=np.linalg.eigh(sum(s*d for s,d in zip(signs,ds)))
        if values[-1]>best[0]: best=(values[-1],signs,vectors[:,-1])
    root=F(408249,10**6); b=2*root/(2-root)
    candidate=F(math.ceil(math.sqrt(float(1-alpha**2+b*b))*10000),10000)
    lower=F(math.floor((best[0]-.00001)*10000),10000)
    document=dict(format='imperfect-packing-veto-v1',alpha=str(alpha),sector_scale=str(scale),coupling_scale=str(coupling),
                  witness_signs=list(best[1]),witness_vector=[str(F(round(float(x)*10**7),10**7)) for x in best[2]],
                  sqrt_delta_upper=str(root),candidate_upper=str(candidate),witness_lower=str(lower))
    v.OUT.mkdir(parents=True,exist_ok=True)
    (v.OUT/'veto_certificate.json').write_text(json.dumps(document,indent=2)+'\n',encoding='utf-8')
    result=v.verify(document)
    print('PASS proposed certificate:',lower,'>',candidate,'gap',result['strict_violation'],flush=True)


if __name__=='__main__': main()
