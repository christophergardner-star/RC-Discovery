"""Run every existing executable experiment with retained logs and exit codes."""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research" / "local_validation"


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PYTHONUTF8="1", OPENBLAS_NUM_THREADS="2",
               OMP_NUM_THREADS="2", MKL_NUM_THREADS="2")
    scripts = sorted((ROOT / "experiments").glob("test_*.py"))
    scripts += [ROOT / "experiments" / name for name in
                ("rc_tcl_certificate.py", "rc_tcl_conflict_smoke.py",
                 "rc_qnd_certificate.py")]
    result = {"started_utc": datetime.now(timezone.utc).isoformat(),
              "python": sys.version, "platform": platform.platform(), "runs": []}
    for script in scripts:
        args = [sys.executable, str(script)]
        if script.stem == "rc_qnd_certificate":
            # Illustrative inputs, not measured laptop/hardware data.
            args += ["--eta-up", "0.01", "--eta-down", "0.02",
                     "--eps-1-given-0", "0.03", "--eps-0-given-1", "0.04"]
        start = time.monotonic()
        log = OUT / (script.stem + ".log")
        print("RUN", script.name, flush=True)
        with log.open("w", encoding="utf-8") as f:
            try:
                proc = subprocess.run(args, cwd=ROOT, env=env, stdout=f,
                                      stderr=subprocess.STDOUT, timeout=1800)
                code = proc.returncode
            except subprocess.TimeoutExpired:
                f.write("\nTIMEOUT after 1800 seconds\n")
                code = 124
        row = {"script": str(script.relative_to(ROOT)), "exit_code": code,
               "seconds": round(time.monotonic() - start, 3),
               "sha256": hashlib.sha256(script.read_bytes()).hexdigest(),
               "arguments": args[2:], "log": log.name}
        result["runs"].append(row)
        (OUT / "summary.json").write_text(json.dumps(result, indent=2),
                                         encoding="utf-8")
        print("PASS" if code == 0 else "FAIL", script.name, row["seconds"],
              flush=True)
    freeze = subprocess.check_output([sys.executable, "-m", "pip", "freeze"],
                                     text=True, encoding="utf-8")
    (OUT / "requirements.lock.txt").write_text(freeze, encoding="utf-8")
    raise SystemExit(any(r["exit_code"] != 0 for r in result["runs"]))


if __name__ == "__main__":
    main()
