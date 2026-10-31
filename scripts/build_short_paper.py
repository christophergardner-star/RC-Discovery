"""Build the short paper from its Markdown and BibTeX sources.

Requires Pandoc and Tectonic. Tools may be on PATH or supplied explicitly.
The ignored local paper_tools directory is also searched for this laptop.
No executables are installed by this script. Tectonic may populate its TeX
bundle cache on the first build.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT / "paper"
TOOLS = ROOT / "research/local_validation/phd_audit/paper_tools"
EVIDENCE = ROOT / "research/short_paper_build"
STEM = "prescribed_repeatable_completion"


def executable(name: str, supplied: str | None) -> str:
    if supplied:
        path = Path(supplied).expanduser().resolve()
        if not path.is_file():
            raise FileNotFoundError(path)
        return str(path)
    found = shutil.which(name)
    if found:
        return found
    for filename in (name + ".exe", name):
        candidates = sorted(TOOLS.rglob(filename)) if TOOLS.exists() else []
        if candidates:
            return str(candidates[0])
    raise RuntimeError(f"{name} is required; put it on PATH or pass --{name}.")


def normalized_hash(path: Path) -> str:
    return hashlib.sha256(path.read_text(encoding="utf-8").encode("utf-8")).hexdigest()


def run(command: list[str], log: Path, body: str | None = None) -> None:
    environment = os.environ.copy()
    environment.setdefault("TECTONIC_CACHE_DIR", str(TOOLS / "tectonic-cache"))
    result = subprocess.run(
        command, cwd=PAPER, input=body, text=True, encoding="utf-8",
        errors="replace", stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        check=False, env=environment,
    )
    log.write_text(result.stdout, encoding="utf-8")
    if result.stdout.strip():
        print(result.stdout.rstrip())
    if result.returncode:
        raise RuntimeError(f"{Path(command[0]).name} exited {result.returncode}; see {log}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pandoc")
    parser.add_argument("--tectonic")
    args = parser.parse_args()
    pandoc = executable("pandoc", args.pandoc)
    tectonic = executable("tectonic", args.tectonic)
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    source = PAPER / "arxiv_ready.md"
    bibliography = PAPER / f"{STEM}.bib"
    header = PAPER / "short_paper_header.tex"
    raw = source.read_text(encoding="utf-8")
    preamble, body = raw.split("<!-- paper-body -->", 1)
    title = preamble.splitlines()[0].removeprefix("# ").strip()
    author = re.search(r"\*\*Author:\*\*\s*(.+)", preamble).group(1).strip()
    date = re.search(r"\*\*Date:\*\*\s*(.+)", preamble).group(1).strip()
    keys = set(re.findall(r"@[\w]+\s*\{\s*([^,\s]+)", bibliography.read_text(encoding="utf-8")))
    used = set(re.findall(r"@([a-zA-Z][\w-]*)", body))
    if used - keys:
        raise ValueError(f"Missing bibliography keys: {sorted(used-keys)}")
    tex = PAPER / f"{STEM}.tex"
    command = [
        pandoc, "--from=markdown+tex_math_single_backslash",
        "--to=latex", "--standalone", "--citeproc",
        f"--bibliography={bibliography.name}",
        "--shift-heading-level-by=-1",
        f"--include-in-header={header.name}",
        "--metadata", f"title={title}",
        "--metadata", f"author={author}",
        "--metadata", f"date={date}",
        "--variable", "documentclass=article",
        "--variable", "fontsize=11pt",
        "--variable", "papersize=a4",
        "--variable", "geometry=margin=25mm",
        "--variable", "colorlinks=true",
        "--variable", "linkcolor=blue",
        "--variable", "urlcolor=blue",
        "--variable", "citecolor=blue",
        "--output", tex.name,
    ]
    run(command, EVIDENCE / "pandoc.log", body)
    readable = PAPER / f"{STEM}.md"
    run(
        [pandoc, "--from=markdown+tex_math_single_backslash",
         "--to=gfm+tex_math_dollars", "--citeproc",
         f"--bibliography={bibliography.name}", "--output", readable.name],
        EVIDENCE / "pandoc_markdown.log", body,
    )
    rendered = readable.read_text(encoding="utf-8")
    readable.write_text(
        f"# {title}\n\n**Author:** {author}  \n**Date:** {date}\n\n"
        "<!-- Generated from arxiv_ready.md; edit that source and rebuild. -->\n\n"
        + rendered, encoding="utf-8")
    # Generated TeX is self-contained: citation processing embeds references.
    text = tex.read_text(encoding="utf-8")
    text = "% Generated from paper/arxiv_ready.md; edit that source and rebuild.\n" + text
    tex.write_text(text, encoding="utf-8")
    run(
        [tectonic, "--keep-logs", "--outdir", str(EVIDENCE), tex.name],
        EVIDENCE / "tectonic_console.log",
    )
    built_pdf = EVIDENCE / f"{STEM}.pdf"
    pdf = PAPER / built_pdf.name
    if not built_pdf.is_file() or built_pdf.stat().st_size < 1000:
        raise RuntimeError("Compiler did not produce a nonempty PDF.")
    shutil.copyfile(built_pdf, pdf)
    # The PDF in paper/ is the artifact; keep only one tracked copy.
    built_pdf.unlink()
    versions = {}
    for name, tool in (("pandoc", pandoc), ("tectonic", tectonic)):
        version = subprocess.check_output([tool, "--version"], text=True, encoding="utf-8")
        versions[name] = version.splitlines()[0]
    manifest = {
        "tools": versions,
        "source_revision": subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        "source_hash_kind": "SHA256 of UTF-8 text with LF-normalized line endings",
        "source_hashes": {
            str(p.relative_to(ROOT)).replace("\\", "/"): normalized_hash(p)
            for p in (source, bibliography, header, Path(__file__).resolve())
        },
        "tex_sha256": normalized_hash(tex),
        "rendered_markdown_sha256": normalized_hash(readable),
        "pdf_sha256": hashlib.sha256(pdf.read_bytes()).hexdigest(),
        "pdf_bytes": pdf.stat().st_size,
        "citations_used": sorted(used),
        "scope": "Document build and citation resolution; not a mathematical proof or external review.",
    }
    (EVIDENCE / "manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"Built {pdf.relative_to(ROOT)} ({pdf.stat().st_size} bytes).")


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError) as exc:
        print(f"Paper build failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
