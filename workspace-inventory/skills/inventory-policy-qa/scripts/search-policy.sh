#!/bin/bash
# Search inventory policy documents
# Usage: ./search-policy.sh <keyword>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <keyword>" >&2
  exit 1
fi

KEYWORD="$1"
POLICY_DIR="$(dirname "$0")/../../policies"

grep -r -i -n --include="*.md" "${KEYWORD}" "${POLICY_DIR}" || echo "No matches found for '${KEYWORD}'"
