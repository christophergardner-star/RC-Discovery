"""Audit the repository's human-authorship and AI-provider non-claim notice.

This is a governance and publication-hygiene test, not a legal opinion. It
ensures that AI assistance is disclosed without accidentally assigning
research authorship, inventorship, ownership, priority, endorsement, or
publication control to an AI system or provider.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "research" / "local_validation" / "ai_rights_notice.json"


def read(relative: str) -> str:
    path = ROOT / relative
    if not path.is_file():
        raise AssertionError(f"missing required file: {relative}")
    return path.read_text(encoding="utf-8")


def require(text: str, relative: str, markers: list[str]) -> None:
    for marker in markers:
        if marker not in text:
            raise AssertionError(f"{relative} is missing required marker: {marker!r}")


def main() -> None:
    notice_path = "AI_RIGHTS_AND_ATTRIBUTION.md"
    notice = read(notice_path)
    vibe = read("VIBE_MATH.md")
    review = read("review/README.md")

    require(
        notice,
        notice_path,
        [
            "Human Authorship, Research Control, and AI-Provider Non-Claim Notice",
            "Christopher Gardner",
            "OpenAI and other AI providers are not authorised",
            "authorship or co-authorship",
            "inventorship or co-inventorship",
            "ownership or co-ownership",
            "research priority",
            "control over publication",
            "not legal advice",
            "https://openai.com/policies/row-terms-of-use/",
            "https://openai.com/en-GB/policies/services-agreement/",
            "providers supplied tools; they are not designated as claimants",
        ],
    )

    require(
        vibe,
        "VIBE_MATH.md",
        [
            "Human authorship and AI-provider claim boundary",
            "Research direction and human authorship: **Christopher Gardner**",
            "AI_RIGHTS_AND_ATTRIBUTION.md",
        ],
    )
    require(
        review,
        "review/README.md",
        [
            "Human authorship and AI assistance",
            "AI_RIGHTS_AND_ATTRIBUTION.md",
        ],
    )

    # The notice must preserve scientific disclosure and must not attempt to
    # appropriate provider technology or pretend to override law or contract.
    balancing_markers = [
        "The repository will continue to disclose material AI assistance honestly",
        "Nothing in this notice claims ownership of OpenAI's or another provider's models",
        "does not amend a service agreement",
        "copyright subsistence, patent inventorship, protectability, ownership, and enforceability",
    ]
    require(notice, notice_path, balancing_markers)

    result = {
        "notice": notice_path,
        "notice_bytes": len(notice.encode("utf-8")),
        "linked_from": ["VIBE_MATH.md", "review/README.md"],
        "official_openai_terms_links": 2,
        "result": "PASS",
        "qualification": "governance audit only; not a legal opinion",
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("PASS human-authorship and AI-provider non-claim notice")


if __name__ == "__main__":
    main()
