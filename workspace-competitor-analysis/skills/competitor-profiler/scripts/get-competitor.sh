#!/bin/bash
# Get competitor profile
# Usage: ./get-competitor.sh <competitor_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <competitor_id>" >&2
  exit 1
fi

: "${INTEL_API_URL:?INTEL_API_URL environment variable is required}"
: "${INTEL_API_KEY:?INTEL_API_KEY environment variable is required}"

curl -s "${INTEL_API_URL}/competitors/$1" \
  -H "Authorization: Bearer ${INTEL_API_KEY}" | jq '.'
