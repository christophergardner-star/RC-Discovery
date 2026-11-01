"""Generate exact analytic witnesses, without numerical optimization."""
from fractions import Fraction as F
import json
from verify_perfect_packing_sharpness import OUT, family, verify_document


def serialize(value):
    if isinstance(value,F): return str(value)
    if isinstance(value,list): return [serialize(x) for x in value]
    if isinstance(value,dict): return {k:serialize(v) for k,v in value.items()}
    return value


def main():
    cases=[family(h) for h in [F(11,20),F(3,5),F(4,5),F(9,10),F(99,100),F(999,1000),F(9999,10000)]]
    document=dict(format='perfect-packing-sharpness-v1',cases=serialize(cases))
    verify_document(document)
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'certificates.json').write_text(json.dumps(document,indent=2)+'\n',encoding='utf-8')
    print('Prepared',len(cases),'exact analytic primal/dual certificates.')


if __name__=='__main__':
    main()
