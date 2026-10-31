#!/usr/bin/env bash
set -euo pipefail

PROFILE="full"
SKIP_INSTALL=0
SKIP_LEAN=0
REQUIRE_LEAN=0
FAIL_FAST=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    --skip-install)
      SKIP_INSTALL=1
      shift
      ;;
    --skip-lean)
      SKIP_LEAN=1
      shift
      ;;
    --require-lean)
      REQUIRE_LEAN=1
      shift
      ;;
    --fail-fast)
      FAIL_FAST=1
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: scripts/run_phd_audit.sh [options]

Options:
  --profile quick|full   Validation depth (default: full)
  --skip-install        Reuse an existing .venv-audit environment
  --skip-lean           Do not run lake build
  --require-lean        Fail when lake is not installed
  --fail-fast           Stop at the first failed test
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ "$PROFILE" != "quick" && "$PROFILE" != "full" ]]; then
  echo "--profile must be quick or full" >&2
  exit 2
fi
if [[ "$SKIP_LEAN" -eq 1 && "$REQUIRE_LEAN" -eq 1 ]]; then
  echo "--skip-lean and --require-lean are incompatible" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

VENV="$REPO_ROOT/.venv-audit"
PYTHON="$VENV/bin/python"

if [[ "$SKIP_INSTALL" -eq 0 ]]; then
  if [[ ! -x "$PYTHON" ]]; then
    echo "Creating isolated validation environment at $VENV"
    python3 -m venv "$VENV"
  fi
  "$PYTHON" -m pip install --upgrade pip
  "$PYTHON" -m pip install -r experiments/requirements_validation.txt
fi

if [[ ! -x "$PYTHON" ]]; then
  echo "Validation Python not found at $PYTHON. Run without --skip-install first." >&2
  exit 2
fi

OUTPUT="research/local_validation/phd_${PROFILE}"
ARGS=(experiments/run_phd_validation.py --profile "$PROFILE" --output "$OUTPUT")
[[ "$SKIP_LEAN" -eq 1 ]] && ARGS+=(--skip-lean)
[[ "$REQUIRE_LEAN" -eq 1 ]] && ARGS+=(--require-lean)
[[ "$FAIL_FAST" -eq 1 ]] && ARGS+=(--fail-fast)

echo "Auditing human authorship and AI-provider non-claim boundary"
"$PYTHON" experiments/test_ai_rights_notice.py

echo "Running VIBE MATH PhD audit profile '$PROFILE'"
"$PYTHON" "${ARGS[@]}"

echo
echo "PASS. Evidence written to $OUTPUT"
echo "Summary: $OUTPUT/summary.md"
