"""Repository-level claim-discipline and provenance audit.

This test does not prove mathematics. It prevents avoidable publication
mistakes: stale source provenance, ambiguous theorem typing, broken canonical
links, accidental promotion of historical drafts, and unsupported novelty or
degree language in public-facing files.
"""

from __future__ import annotations

import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research" / "local_validation" / "claim_discipline.json"
SOURCE_COMMIT = "f94275addb491f1b4be428e2a65939bd4c153897"
SOURCE_TREE = "ef0eaf35289b2f489031baaa28163cc2bd97dff0"


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
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
        "theory/BOUND_CANDIDATE_2026-10-31.md",
        "research/CERTIFICATE_PROGRESS_2026-10-31.md",
        "research/CRUXY_SYNC_REPORT_F94275_2026-10-31.md",
        "literature/PRIOR_ART_AND_ATTRIBUTION.md",
        "literature/DEEP_PRIOR_ART_VETO_2026-10-31.md",
        "imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md",
        "review/EXTERNAL_REVIEW_PACKET.md",
        "review/PROOF_DEPENDENCY_MAP.md",
        "review/REPRODUCIBILITY_GUIDE.md",
        "review/TEST_CLAIM_MATRIX.md",
        "experiments/PHD_VALIDATION_PROTOCOL.md",
    ]
    for relative in required_files:
        read_required(relative)

    require_markers(
        "README.md",
        [
            r"J_{\mathcal K}",
            r"2\min",
            "potentially distinct; novelty unverified",
            SOURCE_COMMIT,
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
            "not a legal novelty opinion",
            "potentially distinct; novelty unverified",
            "No document should call it",
        ],
    )
    require_markers(
        "imports/RC-Packing-Feasible-Note/SNAPSHOT_MANIFEST.md",
        [SOURCE_COMMIT, SOURCE_TREE, "not the canonical"],
    )

    # The latest Cruxy full_proof is preserved only under imports because its J
    # notation and coefficient-four sketch are superseded by canonical files.
    if (ROOT / "theory" / "full_proof.md").exists():
        raise AssertionError(
            "historical Cruxy full_proof.md must not exist in canonical theory/"
        )
    read_required("imports/RC-Packing-Feasible-Note/theory/full_proof.md")

    # These expressions target unsupported affirmative claims. They do not
    # reject policy documents that quote the same words in a prohibition list.
    prohibited = [
        r"\bwe (?:have )?proved the first\b",
        r"\bthis is (?:a )?first[- ]ever\b",
        r"\bthe result is prior[- ]art free\b",
        r"\bthe theorem is patentable\b",
        r"\bwe have freedom to operate\b",
        r"\bthis (?:paper|theorem) is submission[- ]ready\b",
        r"\bthis is a fully verified theorem\b",
        r"\bthis is a proven breakthrough\b",
    ]
    public_files = [
        "README.md",
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
    ]
    for relative in public_files:
        forbid_patterns(relative, prohibited)

    integrity_files = [
        "README.md",
        "STATUS.md",
        "paper/VIBE_MATH_DOCTORAL_RESEARCH_DOCUMENT.md",
        "theory/THEOREM_V1_FREEZE.md",
        "theory/same_label_dimension_free_theorem.md",
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
        sum(row["checked_local_links"] for row in integrity.values()),
        "local links checked",
    )


if __name__ == "__main__":
    main()
