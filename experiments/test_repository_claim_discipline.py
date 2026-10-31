"""Repository-level claim-discipline, provenance, and source-parity audit.

This test does not prove mathematics. It prevents avoidable publication and
repository mistakes: stale source provenance, incomplete source imports,
ambiguous theorem typing, broken canonical links, accidental promotion of
historical drafts, unsupported novelty or degree language, and erosion of the
human-authorship / AI-provider non-claim boundary.
"""

from __future__ import annotations

import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research" / "local_validation" / "claim_discipline.json"

SOURCE_COMMIT = "fcef89be09dd9167a5a94d887e34d5ef1a8d0746"
SOURCE_TREE = "2d0e9ef233a39aea8b1555a8d51db31bf934ef44"
SOURCE_PREFIX = "imports/RC-Packing-Feasible-Note"

# Git-object parity with the exact Cruxy source snapshot. The import directory
# has one deliberate extra file, SNAPSHOT_MANIFEST.md, so its top-level tree is
# not expected to equal SOURCE_TREE. The source-controlled root blobs and the
# complete lean/, paper/, and theory/ subtrees must match exactly.
EXPECTED_SOURCE_OBJECTS = {
    f"{SOURCE_PREFIX}/NOVELTY_STATEMENT.md":
        "3de4de1c91951cb8bd6acb0a0d7e4d35e1abe8f8",
    f"{SOURCE_PREFIX}/README.md":
        "acfa204d11a43342814d8db1a1ce7167b0369f4f",
    f"{SOURCE_PREFIX}/REVIEW_PACKAGE.md":
        "afaedc8c2b6b03ac6d662bd69bf44c5427227559",
    f"{SOURCE_PREFIX}/REVIEW_REQUEST.md":
        "cc8462c2672da120aef69f8ad3ac74e4635833e2",
    f"{SOURCE_PREFIX}/STATUS.md":
        "229c2a46fe0dd24f77928f6a61dfb0b6f36f327a",
    f"{SOURCE_PREFIX}/lean":
        "c2b7e33e591d9e89d1859655052d85759352b031",
    f"{SOURCE_PREFIX}/paper":
        "23b5f1a2a565d6a578ecc4c751f6a19755d5aeb7",
    f"{SOURCE_PREFIX}/theory":
        "7beb09564e84e019160b42f4c674441bb3a3cd28",
}


def read_required(relative: str) -> str:
    path = ROOT / relative
    if not path.is_file():
        raise AssertionError(f"required canonical file is missing: {relative}")
    text = path.read_text(encoding="utf-8")
    if not text.strip():
        raise AssertionError(f"required canonical file is empty: {relative}")
    return text


def require_markers(relative: str, markers: list[str]) -> None:
    text = read_required(relative)
    for marker in markers:
        if marker not in text:
            raise AssertionError(f"{relative} is missing required marker: {marker!r}")


def forbid_patterns(relative: str, patterns: list[str]) -> None:
    text = read_required(relative)
    for pattern in patterns:
        if re.search(pattern, text, flags=re.IGNORECASE):
            raise AssertionError(
                f"{relative} contains unsupported positive wording matching {pattern!r}"
            )


def git_object_sha(relative: str) -> str:
    """Return the Git blob/tree SHA for a path at HEAD."""
    try:
        return subprocess.check_output(
            ["git", "rev-parse", f"HEAD:{relative}"],
            cwd=ROOT,
            text=True,
            encoding="utf-8",
            stderr=subprocess.STDOUT,
        ).strip()
    except (OSError, subprocess.CalledProcessError) as exc:
        raise AssertionError(f"could not resolve Git object for {relative}") from exc


def check_source_object_parity() -> dict[str, str]:
    observed: dict[str, str] = {}
    for relative, expected in EXPECTED_SOURCE_OBJECTS.items():
        if not (ROOT / relative).exists():
            raise AssertionError(f"source snapshot path is missing: {relative}")
        actual = git_object_sha(relative)
        if actual != expected:
            raise AssertionError(
                f"source snapshot mismatch for {relative}: expected {expected}, got {actual}"
            )
        observed[relative] = actual
    return observed


def check_markdown_integrity(relative: str) -> dict[str, int]:
    path = ROOT / relative
    text = read_required(relative)
    if "\x0b" in text or "\x00" in text:
        raise AssertionError(f"{relative} contains a control character")
    if text.count("```") % 2:
        raise AssertionError(f"{relative} has an unbalanced fenced code block")

    checked_links = 0
    for match in re.finditer(r"\[[^\]]+\]\(([^)]+)\)", text):
        target = match.group(1).strip()
        if (
            target.startswith(("http://", "https://", "mailto:", "#"))
            or "://" in target
        ):
            continue
        target = target.split("#", 1)[0]
        if not target or not target.endswith(".md"):
            continue
        resolved = (path.parent / target).resolve()
        try:
            resolved.relative_to(ROOT.resolve())
        except ValueError as exc:
            raise AssertionError(
                f"{relative} contains a link outside the repository: {target}"
            ) from exc
        if not resolved.is_file():
            raise AssertionError(f"{relative} has broken local link: {target}")
        checked_links += 1

    return {"bytes": len(text.encode("utf-8")), "checked_local_links": checked_links}


def main() -> None:
    required_files = [
        "README.md",
        "STATUS.md",
        "AI_RIGHTS_AND_ATTRIBUTION.md",
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
        "theory/BOUND_CANDIDATE_2026-10-31.md",
        "research/CERTIFICATE_PROGRESS_2026-10-31.md",
        "research/PHD_VALIDATION_REPORT_2026-10-31.md",
        "research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md",
        "literature/PRIOR_ART_AND_ATTRIBUTION.md",
        "literature/DEEP_PRIOR_ART_VETO_2026-10-31.md",
        f"{SOURCE_PREFIX}/SNAPSHOT_MANIFEST.md",
        f"{SOURCE_PREFIX}/NOVELTY_STATEMENT.md",
        f"{SOURCE_PREFIX}/REVIEW_PACKAGE.md",
        f"{SOURCE_PREFIX}/paper/FINAL.md",
        f"{SOURCE_PREFIX}/lean/RCProof/Hybrid.lean",
        f"{SOURCE_PREFIX}/lean/RCProof/HybridExtended.lean",
        f"{SOURCE_PREFIX}/theory/RECHECK_2026-10-31.md",
        "review/EXTERNAL_REVIEW_PACKET.md",
        "review/PROOF_DEPENDENCY_MAP.md",
        "review/REPRODUCIBILITY_GUIDE.md",
        "review/TEST_CLAIM_MATRIX.md",
        "experiments/PHD_VALIDATION_PROTOCOL.md",
    ]
    for relative in required_files:
        read_required(relative)

    source_objects = check_source_object_parity()

    require_markers(
        "README.md",
        [
            r"J_{\mathcal K}",
            r"2\min",
            "potentially distinct; novelty unverified",
            SOURCE_COMMIT,
            SOURCE_TREE,
            "AI_RIGHTS_AND_ATTRIBUTION.md",
        ],
    )
    require_markers(
        "STATUS.md",
        [
            SOURCE_COMMIT,
            SOURCE_TREE,
            "Ten commits; exactly nine changed paths",
            "AI-provider non-claim boundary",
        ],
    )
    require_markers(
        "theory/THEOREM_V1_FREEZE.md",
        [
            "external verification pending",
            r"2\min",
            "not novelty certified",
            r"1-2e",
        ],
    )
    require_markers(
        "theory/same_label_dimension_free_theorem.md",
        [
            r"J_{\mathcal K}",
            r"V=J_{\mathcal K}U^*+WR",
            r"2\min",
            "external review",
        ],
    )
    require_markers(
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        [
            "not represented as an awarded PhD thesis",
            "novelty unverified",
            r"2\min",
        ],
    )
    require_markers(
        "literature/PRIOR_ART_AND_ATTRIBUTION.md",
        [
            "legal novelty opinion",
            "potentially distinct; novelty unverified",
            "No document should call it",
        ],
    )
    require_markers(
        "AI_RIGHTS_AND_ATTRIBUTION.md",
        [
            "Christopher Gardner",
            "OpenAI",
            "not authorised",
            "not legal advice",
        ],
    )
    require_markers(
        f"{SOURCE_PREFIX}/SNAPSHOT_MANIFEST.md",
        [
            SOURCE_COMMIT,
            SOURCE_TREE,
            "not the canonical",
            "exactly nine changed paths",
            "AI-provider non-claim boundary",
        ],
    )
    require_markers(
        "research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md",
        [
            SOURCE_COMMIT,
            SOURCE_TREE,
            "all source-controlled files imported",
            "no blind overwrite",
        ],
    )

    # Historical source files must remain quarantined under imports/. Their
    # statements are provenance and may be weaker, ambiguous, or more assertive
    # than the canonical RC-Discovery policy.
    if (ROOT / "theory" / "full_proof.md").exists():
        raise AssertionError(
            "historical Cruxy full_proof.md must not exist in canonical theory/"
        )
    if (ROOT / "paper" / "FINAL.md").exists():
        raise AssertionError(
            "Cruxy paper/FINAL.md must remain under imports/, not canonical paper/"
        )
    if (ROOT / "NOVELTY_STATEMENT.md").exists():
        raise AssertionError(
            "Cruxy NOVELTY_STATEMENT.md must remain under imports/"
        )
    read_required(f"{SOURCE_PREFIX}/theory/full_proof.md")

    # These patterns target unsupported affirmative claims. Policy documents
    # may quote the same vocabulary when explicitly prohibiting it.
    prohibited = [
        r"\bwe (?:have )?proved the first\b",
        r"\bthis is (?:a )?first[- ]ever\b",
        r"\bthe result is prior[- ]art free\b",
        r"\bthe theorem is patentable\b",
        r"\bwe have freedom to operate\b",
        r"\bthis (?:paper|theorem) is submission[- ]ready\b",
        r"\bthis is a fully verified theorem\b",
        r"\bthis is a proven breakthrough\b",
        r"\bOpenAI (?:authored|invented|owns|originated|sponsored|controls)\b",
    ]
    public_files = [
        "README.md",
        "STATUS.md",
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
    ]
    for relative in public_files:
        forbid_patterns(relative, prohibited)

    integrity_files = [
        "README.md",
        "STATUS.md",
        "AI_RIGHTS_AND_ATTRIBUTION.md",
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
        "research/CRUXY_SYNC_REPORT_FCEF89_2026-10-31.md",
        "review/EXTERNAL_REVIEW_PACKET.md",
        "review/PROOF_DEPENDENCY_MAP.md",
        "review/REPRODUCIBILITY_GUIDE.md",
        "review/TEST_CLAIM_MATRIX.md",
        "experiments/PHD_VALIDATION_PROTOCOL.md",
    ]
    integrity = {
        relative: check_markdown_integrity(relative)
        for relative in integrity_files
    }

    output = {
        "source_commit": SOURCE_COMMIT,
        "source_tree": SOURCE_TREE,
        "source_object_parity": source_objects,
        "required_file_count": len(required_files),
        "public_files_scanned": public_files,
        "prohibited_positive_patterns": prohibited,
        "integrity": integrity,
        "result": "PASS",
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(output, indent=2), encoding="utf-8")
    print(
        "PASS",
        len(required_files),
        "required files;",
        len(source_objects),
        "source Git objects matched;",
        sum(row["checked_local_links"] for row in integrity.values()),
        "local links checked",
    )


if __name__ == "__main__":
    main()
