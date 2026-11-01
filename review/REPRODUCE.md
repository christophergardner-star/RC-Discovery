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

For the combined release, also rerun the joint theorem's numerical operator
and full SDP checks using the additional pinned dependencies:

```powershell
.venv-review/Scripts/python.exe -m pip --isolated --disable-pip-version-check install -r scripts/requirements-review-numerical.txt
.venv-review/Scripts/python.exe scripts/reproduce_review.py --joint-numerics --output-dir research/combined_review_release_2026-11-01 --pandoc C:/path/to/pandoc.exe --tectonic C:/path/to/tectonic.exe
```

This mode runs fifteen commands: twelve exact checks, one numerical audit,
and two document commands. The numerical audit uses `-I` with the fresh
environment's scientific packages; its outputs are floating-point evidence,
not exact certificates or the proof of Theorem 10. It regenerates five SDP
artifacts and records their hashes. The document checker verifies the retained
numerical evidence's source hashes and counts even in the default mode.
Use `--output-dir` to preserve the logs of an earlier reproduction.

The release's Windows/Python 3.12 wheel files and SHA256 values are listed in
[the wheel manifest](../research/combined_review_release_2026-11-01/wheel_manifest.json).
If index-based resolution stalls, download those files from their recorded
PyPI file URLs into a local wheel directory, verify every SHA256, then install
with `pip --isolated --disable-pip-version-check install --no-index
--find-links PATH_TO_WHEELS -r scripts/requirements-review-numerical.txt`.
The release used this fallback and retains its successful installation log.
Other operating systems or Python versions require their compatible wheels.

The runner does not build Lean, validate historical experiments, prove the
analytic-to-certificate interpretation, or establish novelty. Its scope is the
finished paper and its exact computational dependencies. PDF bytes may change
with build metadata; compare generated TeX, resolved Markdown and extracted
page text as well as the recorded hashes. A second checkout on the same laptop
is environment isolation, not independent external reproduction.
