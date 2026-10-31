param(
    [ValidateSet("quick", "full")]
    [string]$Profile = "full",

    [switch]$SkipInstall,
    [switch]$SkipLean,
    [switch]$RequireLean,
    [switch]$FailFast
)

$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $RepoRoot

$Venv = Join-Path $RepoRoot ".venv-audit"
$Python = Join-Path $Venv "Scripts\python.exe"

if (-not $SkipInstall) {
    if (-not (Test-Path $Python)) {
        Write-Host "Creating isolated validation environment at $Venv"
        python -m venv $Venv
    }
    & $Python -m pip install --upgrade pip
    & $Python -m pip install -r "experiments\requirements_validation.txt"
}

if (-not (Test-Path $Python)) {
    throw "Validation Python not found at $Python. Run without -SkipInstall first."
}

$Output = "research\local_validation\phd_$Profile"
$Arguments = @(
    "experiments\run_phd_validation.py",
    "--profile", $Profile,
    "--output", $Output
)

if ($SkipLean) {
    $Arguments += "--skip-lean"
}
if ($RequireLean) {
    $Arguments += "--require-lean"
}
if ($FailFast) {
    $Arguments += "--fail-fast"
}

Write-Host "Running VIBE MATH PhD audit profile '$Profile'"
& $Python @Arguments
if ($LASTEXITCODE -ne 0) {
    throw "PhD audit failed with exit code $LASTEXITCODE. See $Output for logs."
}

Write-Host ""
Write-Host "PASS. Evidence written to $Output"
Write-Host "Summary: $Output\summary.md"
