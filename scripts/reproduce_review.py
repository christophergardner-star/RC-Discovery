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
OUT = ROOT / 'research/reviewer_reproduction'
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
    args = parser.parse_args()
    if not __debug__:
        raise RuntimeError('Run without -O: verifiers use assertions.')
    OUT.mkdir(parents=True, exist_ok=True)
    report = dict(result='RUNNING', source_revision=subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
        python=sys.version, platform=platform.platform(),
        python_prefix=sys.prefix, python_base_prefix=sys.base_prefix,
        packages={name: importlib.metadata.version(name)
                  for name in ('pypdf', 'pypdfium2', 'Pillow')},
        tectonic_cache=os.environ.get('TECTONIC_CACHE_DIR'),
        tools={}, runs=[],
        scope='Exact certificates, rejection controls and document build; not external review or complete formal proof.')
    for name in ('pandoc', 'tectonic'):
        path = Path(getattr(args, name)).resolve(strict=True)
        report['tools'][name] = dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
            version=subprocess.check_output([str(path), '--version'], text=True).splitlines()[0])
    commands = [[sys.executable, '-I', '-S', 'experiments/' + name] for name in CHECKS]
    commands += [[sys.executable, 'scripts/build_short_paper.py', '--pandoc', args.pandoc, '--tectonic', args.tectonic],
                 [sys.executable, 'scripts/check_short_paper.py']]
    for index, command in enumerate(commands, 1):
        print(f'[{index}/{len(commands)}] {command[3] if "-I" in command else command[1]}', flush=True)
        start = time.monotonic()
        process = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace')
        log = f'{index:02d}.log'
        (OUT / log).write_text(process.stdout + '\nSTDERR\n' + process.stderr, encoding='utf-8')
        report['runs'].append(dict(command=command, exit_code=process.returncode,
                                  seconds=round(time.monotonic()-start, 3), log=log))
        report['result'] = 'FAIL' if process.returncode else 'RUNNING'
        (OUT / 'manifest.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
        if process.returncode:
            print(process.stdout + process.stderr)
            raise SystemExit(process.returncode)
    report['result'] = 'PASS'
    (OUT / 'manifest.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print('PASS all 12 exact verification/audit commands and both document commands.', flush=True)


if __name__ == '__main__':
    main()
