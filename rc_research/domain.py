from __future__ import annotations

from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re


def digest(text: str) -> str:
    return hashlib.sha256(text.replace("\r\n", "\n").encode()).hexdigest()


@dataclass(frozen=True)
class Problem:
    id: str
    statement: str
    split: str
    tags: tuple[str, ...]
    context: tuple[str, ...]
    provenance: str

    @property
    def fingerprint(self) -> str:
        return digest(json.dumps(self.__dict__, sort_keys=True))

    @property
    def domain(self) -> str:
        return self.tags[0] if self.tags else "general"


def load_problems(path: Path) -> list[Problem]:
    data = json.loads(path.read_text(encoding="utf-8"))
    problems = []
    seen = set()
    for item in data["problems"]:
        problem = Problem(item["id"], item["statement"], item["split"],
                          tuple(item["tags"]), tuple(item.get("context", [])), item["provenance"])
        if not re.fullmatch(r"[a-z][a-z0-9_]{0,79}", problem.id) or problem.id in seen:
            raise ValueError("Problem IDs must be unique lowercase identifiers")
        if problem.split not in {"train", "holdout", "research"}:
            raise ValueError("Unknown problem split")
        if not problem.statement.strip() or len(problem.statement) > 20000:
            raise ValueError("Invalid trusted problem statement")
        seen.add(problem.id)
        problems.append(problem)
    if not problems:
        raise ValueError("Empty problem registry")
    return problems


PROPOSAL_SCHEMA = {
    "type": "object",
    "properties": {"proof": {"type": "string"}, "rationale": {"type": "string"}},
    "required": ["proof", "rationale"], "additionalProperties": False,
}

FORBIDDEN = re.compile(
    r"\b(?:sorry\w*|admit|axiom|unsafe|partial|native_decide|run_tac|run_elab|run_cmd|"
    r"elab|elab_rules|macro|macro_rules|syntax|initialize|builtin_initialize|"
    r"theorem|lemma|def|opaque|abbrev|instance|attribute|set_option|import|namespace|"
    r"section|end|open|export|noncomputable|mutual|where|deriving|"
    r"eval_expr|eval_tactic|dbg_trace|trace|Lean|IO|System)\b"
)


def validate_proof(proof: str) -> None:
    """Reject command injection and common metaprogramming escape syntax.

    This is a restricted proposal language, not an operating-system sandbox.
    The separate Lean axiom audit is authoritative for proof acceptance.
    """
    if not isinstance(proof, str) or not proof.strip() or len(proof) > 24000:
        raise ValueError("Proof must contain 1 to 24000 characters")
    if any(token in proof for token in ['"', '`', '#', '--', '/-', '-/', '«', '»', '\x00']):
        raise ValueError("Comments, quotations and command syntax are outside the proof language")
    match = FORBIDDEN.search(proof)
    if match:
        raise ValueError(f"Forbidden proof token: {match.group(0)}")


def parse_proposal(raw: str) -> dict:
    proposal = json.loads(raw)
    if not isinstance(proposal, dict) or set(proposal) != {"proof", "rationale"}:
        raise ValueError("Expected exactly proof and rationale")
    if not isinstance(proposal["rationale"], str) or len(proposal["rationale"]) > 8000:
        raise ValueError("Invalid rationale")
    validate_proof(proposal["proof"])
    return proposal
