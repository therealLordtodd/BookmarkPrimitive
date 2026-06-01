#!/usr/bin/env bash
#
# verify.sh — package pre-handoff verify. Resolves the package root from THIS
# script location (cwd-independent), then runs the shared library verify lane
# (strict style -> swift build -> swift test) via verify-app --library.
set -euo pipefail
SELF="$(cd "$(dirname "$0")" && pwd)"
export PROJECT_ROOT="$(dirname "$SELF")"
d="$SELF"
while [[ "$d" != "/" && ! -d "$d/Shared Scripts" ]]; do d="$(dirname "$d")"; done
exec "$d/Shared Scripts/verify-app/verify.sh" --library "$@"
