from __future__ import annotations

from contextlib import contextmanager
import json
import math
import os
from pathlib import Path
import sqlite3

from .domain import Problem, digest


@contextmanager
def workspace_lock(path: Path):
    """OS-released lock, including after an interrupted or crashed process."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a+b") as stream:
        stream.write(b"0")
        stream.flush()
        stream.seek(0)
        if os.name == "nt":
            import msvcrt
            msvcrt.locking(stream.fileno(), msvcrt.LK_NBLCK, 1)
        else:
            import fcntl
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            stream.seek(0)
            if os.name == "nt":
                msvcrt.locking(stream.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(stream, fcntl.LOCK_UN)


class Memory:
    def __init__(self, path: Path, readonly: bool = False):
        if readonly:
            self.db = sqlite3.connect(path.resolve().as_uri() + "?mode=ro", uri=True)
            self.db.row_factory = sqlite3.Row
            self.db.execute("PRAGMA query_only=ON")
            return
        path.parent.mkdir(parents=True, exist_ok=True)
        self.db = sqlite3.connect(path)
        self.db.row_factory = sqlite3.Row
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.executescript('''
        CREATE TABLE IF NOT EXISTS runs (
          id TEXT PRIMARY KEY, started TEXT, finished TEXT, status TEXT,
          environment TEXT, registry_hash TEXT, provider TEXT, config TEXT);
        CREATE TABLE IF NOT EXISTS trials (
          id INTEGER PRIMARY KEY, run_id TEXT, problem_id TEXT, fingerprint TEXT,
          environment TEXT, domain TEXT, split TEXT, strategy TEXT, proof TEXT,
          rationale TEXT, status TEXT, accepted INTEGER, seconds REAL, feedback TEXT,
          source_hash TEXT, source_path TEXT, usage TEXT);
        CREATE INDEX IF NOT EXISTS trial_scope ON trials(environment, fingerprint, accepted);
        CREATE TABLE IF NOT EXISTS problems (
          fingerprint TEXT PRIMARY KEY, statement TEXT, provenance TEXT);
        ''')

    def close(self):
        self.db.close()

    def record(self, run_id: str, problem: Problem, environment: str, strategy: str,
               proof: str, rationale: str, verdict, usage: dict):
        with self.db:
            self.db.execute("INSERT OR IGNORE INTO problems VALUES (?,?,?)",
                            (problem.fingerprint, problem.statement, problem.provenance))
            self.db.execute("INSERT INTO trials VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", (
                run_id, problem.id, problem.fingerprint, environment, problem.domain, problem.split,
                strategy, proof, rationale, verdict.status, int(verdict.accepted), verdict.seconds,
                verdict.feedback, verdict.source_hash, verdict.source_path, json.dumps(usage)))

    def solved(self, problem: Problem, environment: str) -> bool:
        return self.db.execute("SELECT 1 FROM trials WHERE fingerprint=? AND environment=? AND accepted=1 LIMIT 1",
                               (problem.fingerprint, environment)).fetchone() is not None

    def experiences(self, problem: Problem, environment: str) -> list[dict]:
        rows = self.db.execute('''SELECT t.problem_id,t.proof,t.status,t.feedback,p.statement,p.provenance
          FROM trials t LEFT JOIN problems p ON p.fingerprint=t.fingerprint
          WHERE t.environment=? AND t.split!='holdout'
          AND (t.fingerprint=? OR (t.domain=? AND t.accepted=1))
          ORDER BY t.id DESC LIMIT 4''', (environment, problem.fingerprint, problem.domain)).fetchall()
        return [dict(row) | {"feedback": row["feedback"][-3500:]} for row in rows]

    def strategies(self, environment: str) -> list[str]:
        defaults = ["rfl", "simp_all", "positivity", "nlinarith", "aesop", "exact?"]
        rows = self.db.execute('''SELECT proof FROM trials WHERE environment=? AND accepted=1
          AND split!='holdout' ORDER BY id DESC LIMIT 24''', (environment,)).fetchall()
        return list(dict.fromkeys(defaults + [row["proof"] for row in rows]))

    def choose(self, problem: Problem, environment: str, excluded: set[str], explore: bool = True) -> str | None:
        strategies = [item for item in self.strategies(environment) if item not in excluded]
        if not strategies:
            return None
        rows = self.db.execute('''SELECT strategy,COUNT(*) AS n,SUM(accepted) AS wins FROM trials
          WHERE environment=? AND domain=? AND split='train' GROUP BY strategy''',
                               (environment, problem.domain)).fetchall()
        stats = {row["strategy"]: (row["n"], row["wins"]) for row in rows}
        total = sum(item[0] for item in stats.values()) + 1
        def score(proof):
            count, wins = stats.get(digest(proof), (0, 0))
            if not explore:
                return wins / count if count else 0.5
            return math.inf if count == 0 else wins / count + math.sqrt(2 * math.log(total) / count)
        return max(strategies, key=score)

    def summary(self, environment: str) -> dict:
        rows = self.db.execute('''SELECT split,COUNT(*) AS attempts,SUM(accepted) AS accepted,
          COUNT(DISTINCT CASE WHEN accepted=1 THEN fingerprint END) AS solved
          FROM trials GROUP BY split''').fetchall()
        current = self.db.execute('''SELECT split,COUNT(*) AS attempts,SUM(accepted) AS accepted,
          COUNT(DISTINCT CASE WHEN accepted=1 THEN fingerprint END) AS solved
          FROM trials WHERE environment=? GROUP BY split''', (environment,)).fetchall()
        return {"environment": environment, "current_splits": [dict(row) for row in current],
                "historical_splits": [dict(row) for row in rows],
                "runs": [dict(row) for row in self.db.execute(
                    "SELECT id,status,provider,started,finished,environment FROM runs ORDER BY started DESC LIMIT 8")]}
