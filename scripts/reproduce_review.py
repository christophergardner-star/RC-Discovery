"""Recheck paper certificates and build; no numerical solver is required.

Run with a fresh Python environment containing requirements-review.txt.
Supply Pandoc and Tectonic explicitly; set TECTONIC_CACHE_DIR for a fresh cache.
"""
import argparse
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
CHECKS = [
    'verify_exact_completion_comparison.py',
    'check_exact_certificate_negative_controls.py',
    'verify_completion_switch_family.py',
    'check_completion_switch_family.py',
    'verify_completion_crossover.py',
    'check_completion_crossover.py',
    'verify_perfect_packing_sharpness.py',
    'check_perfect_packing_sharpness.py',
    'verify_reference_advantage.py',
    'check_reference_advantage.py',
    'verify_imperfect_packing.py',
    'check_imperfect_packing.py',
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pandoc', required=True)
    parser.add_argument('--tectonic', required=True)
    parser.add_argument('--joint-numerics', action='store_true',
                        help='Also reproduce the joint-theorem numerical operator and SDP checks.')
    parser.add_argument('--output-dir', default='research/reviewer_reproduction',
                        help='Directory for this run, relative to the repository root unless absolute.')
    args = parser.parse_args()
    if not __debug__:
        raise RuntimeError('Run without -O: verifiers use assertions.')
    output = ROOT / args.output_dir
    output.mkdir(parents=True, exist_ok=True)
    report = dict(result='RUNNING', source_revision=subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
        python=sys.version, platform=platform.platform(),
        python_prefix=sys.prefix, python_base_prefix=sys.base_prefix,
        packages={name: importlib.metadata.version(name)
                  for name in ('pypdf', 'pypdfium2', 'Pillow')},
        tectonic_cache=os.environ.get('TECTONIC_CACHE_DIR'),
        tools={}, runs=[],
        scope='Exact certificates, rejection controls and document build; not external review or complete formal proof.')
    report['joint_numerics_requested'] = args.joint_numerics
    if args.joint_numerics:
        report['packages'].update({name: importlib.metadata.version(name)
            for name in ('numpy', 'scipy', 'cvxpy', 'clarabel', 'scs', 'osqp')})
    for name in ('pandoc', 'tectonic'):
        path = Path(getattr(args, name)).resolve(strict=True)
        report['tools'][name] = dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
            version=subprocess.check_output([str(path), '--version'], text=True).splitlines()[0])
    commands = [[sys.executable, '-I', '-S', 'experiments/' + name] for name in CHECKS]
    if args.joint_numerics:
        commands.append([sys.executable, '-I', 'experiments/test_joint_small_error.py'])
    commands += [[sys.executable, 'scripts/build_short_paper.py', '--pandoc', args.pandoc, '--tectonic', args.tectonic],
                 [sys.executable, 'scripts/check_short_paper.py']]
    for index, command in enumerate(commands, 1):
        print(f'[{index}/{len(commands)}] {next(x for x in command[1:] if x.endswith(".py"))}', flush=True)
        start = time.monotonic()
        process = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace')
        log = f'{index:02d}.log'
        (output / log).write_text(process.stdout + '\nSTDERR\n' + process.stderr, encoding='utf-8')
        report['runs'].append(dict(command=command, exit_code=process.returncode,
                                  seconds=round(time.monotonic()-start, 3), log=log))
        report['result'] = 'FAIL' if process.returncode else 'RUNNING'
        (output / 'manifest.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
        if process.returncode:
            print(process.stdout + process.stderr)
            raise SystemExit(process.returncode)
    report['result'] = 'PASS'
    (output / 'manifest.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(f'PASS all {len(commands)} commands: 12 exact verifications/audits, '
          f'{int(args.joint_numerics)} numerical joint-theorem check, and 2 document commands.', flush=True)


if __name__ == '__main__':
    main()
