#!/usr/bin/env bash
#
# verify.sh — package pre-handoff verify. Walks up to the Shared Scripts sibling,
# then runs the shared library verify lane (strict style -> swift build -> swift
# test) via verify-app --library. See Shared Scripts/verify-package.
set -euo pipefail
d="$(cd "$(dirname "$0")" && pwd)"
while [[ "$d" != "/" && ! -d "$d/Shared Scripts" ]]; do d="$(dirname "$d")"; done
exec "$d/Shared Scripts/verify-app/verify.sh" --library "$@"
