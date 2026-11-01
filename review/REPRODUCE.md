# Reproduce the reviewer package

Run from a fresh clone, with Python 3.10 or later, Pandoc 3.13 and Tectonic
0.17.0. The tested host used Windows and Python 3.12.10. These commands use
PowerShell; on other systems substitute the virtual environment's Python path.

```powershell
python -m venv .venv-review
.venv-review/Scripts/python.exe -m pip --isolated --disable-pip-version-check install -r scripts/requirements-review.txt
$env:TECTONIC_CACHE_DIR = Join-Path (Get-Location) '.review-tex-cache'
.venv-review/Scripts/python.exe scripts/reproduce_review.py --pandoc C:/path/to/pandoc.exe --tectonic C:/path/to/tectonic.exe
```

Use an empty cache directory for a fresh TeX dependency download. Network
access is needed to install packages and populate that cache. The script
stops at the first failure and retains command logs, versions, tool hashes,
source revision and exit codes under `research/reviewer_reproduction/`.
It regenerates verification reports and paper artifacts in the checkout.
Do not use Python's `-O` option: exact verifiers deliberately reject it.

All twelve certificate and audit commands run with `-I -S`: no installed
scientific packages or numerical solver participate in certificate acceptance.
They verify retained witnesses, not repeat the numerical searches that found
them. The final two commands build the paper and check its content, hashes,
citations, equations and rendering. Those document checks are not mathematical
proof. The environment needs only the three pinned PDF packages above.

The runner does not build Lean, validate historical experiments, prove the
analytic-to-certificate interpretation, or establish novelty. Its scope is the
finished paper and its exact computational dependencies. PDF bytes may change
with build metadata; compare generated TeX, resolved Markdown and extracted
page text as well as the recorded hashes. A second checkout on the same laptop
is environment isolation, not independent external reproduction.
