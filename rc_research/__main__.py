from __future__ import annotations

import argparse
from dataclasses import asdict
import json
import os
from pathlib import Path
import sys
from urllib.request import urlopen

from .domain import digest, load_problems
from .engine import Budget, run_research
from .memory import Memory, workspace_lock
from .verifier import environment_fingerprint, find_lake

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_STATE = ROOT / "research/local_validation/rc_research"


def main() -> int:
    parser = argparse.ArgumentParser(description="Adaptive, Lean-verified RC research loop")
    parser.add_argument("--state", type=Path, default=DEFAULT_STATE)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("doctor")
    commands.add_parser("status")
    commands.add_parser("list")
    run = commands.add_parser("run")
    run.add_argument("--registry", type=Path, default=Path(__file__).with_name("problems.json"))
    run.add_argument("--provider", choices=["tactics", "openai", "ollama"], default="tactics")
    run.add_argument("--model", default=os.environ.get("RC_RESEARCH_MODEL", ""))
    run.add_argument("--ollama-url", default="http://127.0.0.1:11434")
    run.add_argument("--split", choices=["train", "holdout", "research"], default="train")
    run.add_argument("--problem")
    run.add_argument("--max-attempts", type=int, default=12)
    run.add_argument("--max-seconds", type=float, default=300)
    run.add_argument("--proof-timeout", type=float, default=60)
    run.add_argument("--max-model-calls", type=int, default=4)
    run.add_argument("--max-output-tokens", type=int, default=4096)
    export = commands.add_parser("export")
    export.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    try:
        if args.command == "doctor":
            try:
                with urlopen("http://127.0.0.1:11434/api/tags", timeout=1) as response:
                    local_models = [entry["name"] for entry in json.load(response).get("models", [])]
            except (OSError, ValueError):
                local_models = []
            print(json.dumps({"python": sys.version, "lake": find_lake(),
                              "compiled_project": (ROOT / "lean/.lake/build/lib/lean/RCProof.olean").exists(),
                              "openai_api_key_configured": bool(os.environ.get("OPENAI_API_KEY")),
                              "ollama_models": local_models, "environment": environment_fingerprint(ROOT)}, indent=2))
            return 0
        if args.command == "list":
            print(json.dumps([asdict(problem) for problem in load_problems(Path(__file__).with_name("problems.json"))], indent=2))
            return 0
        if args.command == "status":
            database = args.state / "memory.sqlite3"
            if not database.exists():
                print(json.dumps({"current_splits": [], "historical_splits": [], "runs": []}))
                return 0
            memory = Memory(database, readonly=True)
            try:
                print(json.dumps(memory.summary(environment_fingerprint(ROOT)), indent=2))
            finally:
                memory.close()
            return 0
        if args.command == "run":
            budget = Budget(args.max_attempts, args.max_seconds, args.proof_timeout,
                            args.max_model_calls, args.max_output_tokens)
            report = run_research(ROOT, args.registry.resolve(), args.state, args.provider,
                                  args.model, budget, args.split, args.problem, args.ollama_url)
            print(json.dumps(report, indent=2))
            return 0 if report["status"] == "completed" else 2
        with workspace_lock(args.state / "research.lock"):
            memory = Memory(args.state / "memory.sqlite3")
            try:
                if args.command == "export":
                    current = environment_fingerprint(ROOT)
                    rows = memory.db.execute('''SELECT * FROM trials WHERE accepted=1
                      AND environment=? AND split='train' ORDER BY id''', (current,)).fetchall()
                    records = []
                    for row in rows:
                        source = Path(row["source_path"])
                        if not source.is_file() or digest(source.read_text(encoding="utf-8")) != row["source_hash"]:
                            raise RuntimeError("Verified artifact changed or is missing. Re-run verification before export")
                        records.append({"problem_id": row["problem_id"], "fingerprint": row["fingerprint"],
                                        "proof": row["proof"], "environment": current,
                                        "source": source.read_text(encoding="utf-8"), "source_hash": row["source_hash"]})
                    args.out.parent.mkdir(parents=True, exist_ok=True)
                    if args.out.exists():
                        raise ValueError("Export destination exists. Choose a new file")
                    with args.out.open("x", encoding="utf-8") as stream:
                        for record in records:
                            stream.write(json.dumps(record, ensure_ascii=False) + "\n")
                    print(json.dumps({"verified_training_records": len(records), "path": str(args.out.resolve())}))
            finally:
                memory.close()
        return 0
    except (OSError, ValueError, RuntimeError) as error:
        print(json.dumps({"error": str(error)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
