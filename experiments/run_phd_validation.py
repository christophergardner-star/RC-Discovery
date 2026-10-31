"""Canonical local validation harness for the frozen theorem package.

The harness runs tests in a dependency-aware order, retains complete logs,
records the exact environment and source hashes, and optionally builds Lean.
It is designed for clean-clone reproduction and external-review handoff.

Profiles
--------
quick:
    Fast algebraic, hypothesis, provenance, and counterexample checks. The
    theorem-contract test omits SDP optimization.

full:
    Adds adversarial many-outcome tests, primal/dual SDPs, accessibility
    certificates, residual-rate tests, and the remaining canonical experiments.

A successful run is evidence that the repository's executable claims are
internally consistent on the tested finite cases. It is not a proof, peer
review, or novelty certificate.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys
import time
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "research" / "local_validation" / "phd_audit"

QUICK_TESTS: list[tuple[str, list[str]]] = [
    ("test_repository_claim_discipline.py", []),
    ("test_theorem_v1_contract.py", ["--skip-sdp"]),
    ("test_record_margin.py", []),
    ("test_synthesis_packing.py", []),
    ("test_spectral_threshold_rate.py", []),
    ("test_extra_outcome_gap_closure.py", []),
    ("test_gamma_extra_outcome_counterexample.py", []),
]

FULL_TESTS: list[tuple[str, list[str]]] = [
    ("test_repository_claim_discipline.py", []),
    ("test_theorem_v1_contract.py", ["--sdp-cases", "4"]),
    ("test_record_margin.py", []),
    ("test_synthesis_packing.py", []),
    ("test_spectral_threshold_rate.py", []),
    ("test_same_label_hybrid_dilation.py", []),
    # This writes adversarial.json, which the constant-two test consumes.
    ("test_adversarial_same_label.py", []),
    ("test_constant_two_bound.py", []),
    ("test_record_accessibility.py", []),
    ("test_residual_coupling_rates.py", []),
    ("test_extra_outcome_gap_closure.py", []),
    ("test_gamma_extra_outcome_counterexample.py", []),
    ("test_moving_povm.py", []),
    ("test_three_extensions.py", []),
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def command_output(args: list[str], cwd: Path = ROOT) -> str | None:
    try:
        return subprocess.check_output(
            args,
            cwd=cwd,
            text=True,
            encoding="utf-8",
            stderr=subprocess.STDOUT,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return None


def git_metadata() -> dict[str, Any]:
    commit = command_output(["git", "rev-parse", "HEAD"])
    branch = command_output(["git", "branch", "--show-current"])
    status = command_output(["git", "status", "--porcelain"])
    return {
        "commit": commit,
        "branch": branch,
        "dirty": bool(status) if status is not None else None,
        "porcelain": status,
    }


def package_versions() -> dict[str, str | None]:
    names = ["numpy", "scipy", "cvxpy", "clarabel", "scs"]
    versions: dict[str, str | None] = {}
    for name in names:
        try:
            versions[name] = importlib.metadata.version(name)
        except importlib.metadata.PackageNotFoundError:
            versions[name] = None
    return versions


def run_logged(
    name: str,
    args: list[str],
    cwd: Path,
    env: dict[str, str],
    log_path: Path,
    timeout: int,
) -> dict[str, Any]:
    start = time.monotonic()
    with log_path.open("w", encoding="utf-8") as log:
        log.write(f"$ {' '.join(args)}\n\n")
        log.flush()
        try:
            process = subprocess.run(
                args,
                cwd=cwd,
                env=env,
                stdout=log,
                stderr=subprocess.STDOUT,
                timeout=timeout,
                check=False,
            )
            exit_code = process.returncode
            timed_out = False
        except subprocess.TimeoutExpired:
            log.write(f"\nTIMEOUT after {timeout} seconds\n")
            exit_code = 124
            timed_out = True

    return {
        "name": name,
        "command": args,
        "cwd": str(cwd.relative_to(ROOT) if cwd != ROOT else Path(".")),
        "exit_code": exit_code,
        "timed_out": timed_out,
        "seconds": round(time.monotonic() - start, 3),
        "log": log_path.name,
    }


def write_markdown(summary: dict[str, Any], path: Path) -> None:
    lines = [
        "# PhD Audit Run",
        "",
        f"- Started: `{summary['started_utc']}`",
        f"- Finished: `{summary.get('finished_utc', 'incomplete')}`",
        f"- Profile: `{summary['profile']}`",
        f"- Python: `{summary['python']['version'].splitlines()[0]}`",
        f"- Platform: `{summary['python']['platform']}`",
        f"- Git commit: `{summary['git'].get('commit')}`",
        f"- Dirty worktree: `{summary['git'].get('dirty')}`",
        "",
        "## Results",
        "",
        "| Check | Exit | Seconds | Log |",
        "|---|---:|---:|---|",
    ]
    for row in summary["runs"]:
        lines.append(
            f"| `{row['name']}` | {row['exit_code']} | "
            f"{row['seconds']:.3f} | `{row['log']}` |"
        )
    lines.extend(
        [
            "",
            f"**Overall:** `{'PASS' if summary.get('passed') else 'FAIL'}`",
            "",
            "A passing run is computational evidence only; it does not establish "
            "the theorem, novelty, or peer review.",
        ]
    )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--profile",
        choices=("quick", "full"),
        default="full",
        help="Validation depth. Default: full.",
    )
    parser.add_argument(
        "--output",
        default=str(DEFAULT_OUT),
        help="Directory for retained logs and manifests.",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=1800,
        help="Per-process timeout in seconds. Default: 1800.",
    )
    parser.add_argument(
        "--skip-lean",
        action="store_true",
        help="Do not attempt `lake build`.",
    )
    parser.add_argument(
        "--require-lean",
        action="store_true",
        help="Fail if Lake is unavailable. Implies a Lean build unless skipped.",
    )
    parser.add_argument(
        "--fail-fast",
        action="store_true",
        help="Stop after the first failed check.",
    )
    args = parser.parse_args()

    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    if args.skip_lean and args.require_lean:
        parser.error("--skip-lean and --require-lean are incompatible")

    output = Path(args.output)
    if not output.is_absolute():
        output = ROOT / output
    output.mkdir(parents=True, exist_ok=True)

    tests = QUICK_TESTS if args.profile == "quick" else FULL_TESTS
    missing = [
        name for name, _ in tests
        if not (ROOT / "experiments" / name).is_file()
    ]
    if missing:
        parser.error("missing required test scripts: " + ", ".join(missing))

    env = dict(
        os.environ,
        PYTHONUTF8="1",
        PYTHONHASHSEED="0",
        OPENBLAS_NUM_THREADS="2",
        OMP_NUM_THREADS="2",
        MKL_NUM_THREADS="2",
    )

    summary: dict[str, Any] = {
        "schema": 1,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "profile": args.profile,
        "python": {
            "executable": sys.executable,
            "version": sys.version,
            "platform": platform.platform(),
        },
        "git": git_metadata(),
        "packages": package_versions(),
        "runs": [],
        "script_hashes": {},
    }

    summary_path = output / "summary.json"
    markdown_path = output / "summary.md"

    failed = False
    for filename, extra in tests:
        script = ROOT / "experiments" / filename
        summary["script_hashes"][str(script.relative_to(ROOT))] = sha256(script)
        log_path = output / f"{script.stem}.log"
        command = [sys.executable, str(script), *extra]
        row = run_logged(
            script.stem,
            command,
            ROOT,
            env,
            log_path,
            args.timeout,
        )
        summary["runs"].append(row)
        failed = failed or row["exit_code"] != 0
        summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
        write_markdown(summary, markdown_path)
        print(
            "PASS" if row["exit_code"] == 0 else "FAIL",
            row["name"],
            f"{row['seconds']:.3f}s",
            flush=True,
        )
        if failed and args.fail_fast:
            break

    if not args.skip_lean and not (failed and args.fail_fast):
        lake = shutil.which("lake")
        if lake is None:
            row = {
                "name": "lean_lake_build",
                "command": ["lake", "build"],
                "cwd": "lean",
                "exit_code": 127 if args.require_lean else 0,
                "timed_out": False,
                "seconds": 0.0,
                "log": "lean_lake_build.log",
                "skipped": not args.require_lean,
                "reason": "lake executable not found",
            }
            (output / row["log"]).write_text(
                "SKIPPED: lake executable not found\n"
                if not args.require_lean
                else "FAIL: lake executable not found\n",
                encoding="utf-8",
            )
        else:
            lean_files = sorted((ROOT / "lean").rglob("*.lean"))
            summary["lean_source_hashes"] = {
                str(path.relative_to(ROOT)): sha256(path)
                for path in lean_files
            }
            row = run_logged(
                "lean_lake_build",
                [lake, "build"],
                ROOT / "lean",
                env,
                output / "lean_lake_build.log",
                args.timeout,
            )
        summary["runs"].append(row)
        failed = failed or row["exit_code"] != 0

    freeze = command_output(
        [sys.executable, "-m", "pip", "freeze"],
        cwd=ROOT,
    )
    if freeze is not None:
        (output / "requirements.lock.txt").write_text(
            freeze + "\n", encoding="utf-8"
        )

    summary["finished_utc"] = datetime.now(timezone.utc).isoformat()
    summary["passed"] = not failed
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    write_markdown(summary, markdown_path)

    print(
        f"{'PASS' if not failed else 'FAIL'} profile={args.profile}; "
        f"evidence={output}",
        flush=True,
    )
    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
