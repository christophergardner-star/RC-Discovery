from __future__ import annotations

from dataclasses import dataclass
import os
from pathlib import Path
import shutil
import signal
import subprocess
import time

from .domain import Problem, digest, validate_proof


def find_lake() -> str:
    path = shutil.which("lake")
    fallback = Path.home() / ".elan/bin" / ("lake.exe" if os.name == "nt" else "lake")
    if path:
        return path
    if fallback.is_file():
        return str(fallback)
    raise RuntimeError("Pinned Lake executable not found. Follow lean/README.md")


def run_process(command: list[str], cwd: Path, timeout: float, stdin: str | None = None,
                env: dict | None = None) -> tuple[int, str]:
    process = subprocess.Popen(command, cwd=cwd, stdin=subprocess.PIPE,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                               text=True, encoding="utf-8", errors="replace", env=env,
                               start_new_session=os.name != "nt")
    try:
        output, _ = process.communicate(stdin, timeout=timeout)
        return process.returncode, output
    except (subprocess.TimeoutExpired, KeyboardInterrupt) as error:
        if os.name == "nt":
            subprocess.run(["taskkill", "/PID", str(process.pid), "/T", "/F"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
        else:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
        process.kill()
        output, _ = process.communicate()
        if isinstance(error, KeyboardInterrupt):
            raise
        return 124, output + "\nPROCESS TIME LIMIT OR INTERRUPTION\n"


def environment_fingerprint(root: Path) -> str:
    paths = sorted((root / "lean").glob("*.lean"))
    paths += sorted((root / "lean/RCProof").glob("*.lean"))
    paths += [root / "lean" / name for name in ["lean-toolchain", "lake-manifest.json", "lakefile.toml"]]
    paths += sorted(Path(__file__).parent.glob("*.py"))
    return digest("\n".join(str(path.relative_to(root)).replace("\\", "/") + ":" +
                            digest(path.read_text(encoding="utf-8")) for path in paths))


@dataclass(frozen=True)
class Verdict:
    accepted: bool
    status: str
    feedback: str
    seconds: float
    source_hash: str
    source_path: str


class LeanVerifier:
    def __init__(self, root: Path):
        self.root = root
        self.lake = find_lake()

    @staticmethod
    def source(problem: Problem, proof: str) -> tuple[str, str]:
        validate_proof(proof)
        marker = "RC_RESEARCH_ACCEPTED_" + digest(problem.fingerprint + proof)
        body = "\n".join("  " + line for line in proof.strip().splitlines())
        source = f'''import RCProof
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 1024
namespace RCSearch
open Matrix RCProof
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
set_option maxHeartbeats 400000 in
theorem candidate {problem.statement} := by
{body}
end RCSearch
open Lean Elab Command
run_cmd do
  let axioms ← Lean.collectAxioms ``RCSearch.candidate
  let allowed := [``propext, ``Classical.choice, ``Quot.sound]
  for ax in axioms do
    unless allowed.contains ax do
      throwError "Forbidden axiom {{ax}}"
  logInfo "{marker}"
'''
        return source, marker

    def verify(self, problem: Problem, proof: str, folder: Path, timeout: float) -> Verdict:
        started = time.monotonic()
        folder.mkdir(parents=True, exist_ok=True)
        try:
            source, marker = self.source(problem, proof)
        except ValueError as error:
            return Verdict(False, "rejected_syntax", str(error), 0, digest(str(proof)), "")
        source_path = folder / "Candidate.lean"
        source_path.write_text(source, encoding="utf-8")
        clean_env = {key: value for key, value in os.environ.items()
                     if not any(word in key.upper() for word in ["API_KEY", "TOKEN", "PASSWORD", "SECRET"])}
        code, output = run_process([self.lake, "env", "lean", "--memory=4096", str(source_path.resolve())],
                                   self.root / "lean", timeout, env=clean_env)
        (folder / "lean.log").write_text(output, encoding="utf-8")
        accepted = code == 0 and marker in output
        status = "verified" if accepted else ("timeout" if code == 124 else "failed")
        return Verdict(accepted, status, output[-12000:], time.monotonic() - started,
                       digest(source), str(source_path.resolve()))
