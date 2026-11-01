"""Build and audit the scoped Lean proofs; this does not certify the full theorem.

Uses the pinned Lean/Mathlib project, records source hashes and checks transitive
axioms in Lean itself. Optional negative controls ensure that both an extra axiom
and an unfinished proof are rejected by the audit.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "lean"
REQUIRED = (
    "RCProof.threshold_spectral_envelope",
    "RCProof.threshold_residual_gap",
    "RCProof.naimark_isometry",
    "RCProof.naimark_compression",
    "RCProof.completedEffect_sum",
    "RCProof.polarIsometry_isometry",
    "RCProof.polar_factorization",
    "RCProof.SpectralFrame.cross_zero",
    "RCProof.SpectralFrame.hybrid_dilation_from_polar",
    "RCProof.SpectralFrame.residual_gap",
    "RCProof.jordan_lower_of_width",
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--negative-controls", action="store_true")
    parser.add_argument("--out", type=Path, default=ROOT / "research/local_validation/phd_audit/lean_formalization")
    args = parser.parse_args()
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=True)
    lake = shutil.which("lake")
    if lake is None:
        fallback = Path.home() / ".elan/bin" / ("lake.exe" if __import__("os").name == "nt" else "lake")
        if not fallback.is_file():
            raise RuntimeError("Lake not found. Install the pinned toolchain using lean/README.md.")
        lake = str(fallback)

    def run(name: str, command: list[str]) -> subprocess.CompletedProcess[str]:
        started = time.monotonic()
        result = subprocess.run(command, cwd=LEAN, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True, encoding="utf-8",
                                errors="replace", timeout=1800)
        (out / f"{name}.log").write_text(result.stdout, encoding="utf-8")
        print(f"{name}: exit={result.returncode}, {time.monotonic() - started:.1f}s", flush=True)
        return result

    build = run("build", [lake, "build"])
    if build.returncode:
        raise AssertionError(f"Lean build failed; inspect {out / 'build.log'}")
    match = re.search(r"AXIOM AUDIT PASSED: (\d+) theorems; (\d+) total declarations checked\.", build.stdout)
    if match is None:
        raise AssertionError("The default build did not run/replay the required transitive axiom audit")
    audited = set(re.findall(r"AXIOMS (RCProof[.\w]+):", build.stdout))
    missing = set(REQUIRED) - audited
    if missing:
        raise AssertionError(f"Required operator theorems not audited: {sorted(missing)}")

    controls = []
    if args.negative_controls:
        audit_source = (LEAN / "RCProofAudit.lean").read_text(encoding="utf-8")
        temp = ROOT / "research/local_validation/phd_audit/lean_negative_controls"
        temp.mkdir(parents=True, exist_ok=True)
        for label, declaration, expected in (
            ("extra_axiom", "axiom RCProof.auditNegativeControl : False", "RCProof.auditNegativeControl"),
            ("unfinished_proof", "theorem RCProof.auditNegativeControl : False := by sorry", "sorryAx"),
        ):
            source = audit_source.replace("open Lean Elab Command", declaration + "\n\nopen Lean Elab Command", 1)
            path = temp / f"{label}.lean"
            path.write_text(source, encoding="utf-8")
            result = run(label, [lake, "env", "lean", str(path)])
            if result.returncode == 0 or f"Forbidden axiom {expected}" not in result.stdout:
                raise AssertionError(f"Axiom audit did not reject {label} for the intended reason")
            controls.append({"name": label, "result": "REJECTED_AS_EXPECTED"})

    sources = sorted(LEAN.glob("*.lean")) + sorted((LEAN / "RCProof").glob("*.lean"))
    sources += [LEAN / name for name in ("lakefile.toml", "lake-manifest.json", "lean-toolchain")]
    hashes = {str(path.relative_to(ROOT)).replace("\\", "/"): hashlib.sha256(path.read_bytes()).hexdigest()
              for path in sources}
    source_theorems = sum(len(re.findall(r"^(?:theorem|lemma)\s", path.read_text(encoding="utf-8"), re.M))
                          for path in (LEAN / "RCProof").glob("*.lean"))
    manifest = {
        "result": "PASS", "utc": datetime.now(timezone.utc).isoformat(),
        "scope": "Partial operator formalization; the complete spectral/diamond-norm theorem is NOT machine-checked",
        "source_theorems": source_theorems,
        "kernel_theorem_declarations_including_generated": int(match.group(1)),
        "all_namespace_declarations_audited": int(match.group(2)),
        "allowed_axioms": ["propext", "Classical.choice", "Quot.sound"],
        "required_theorems": list(REQUIRED), "negative_controls": controls,
        "source_sha256": hashes,
    }
    (out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {source_theorems} source theorems; {match.group(2)} declarations audited. Full theorem remains unformalized.")


if __name__ == "__main__":
    main()
