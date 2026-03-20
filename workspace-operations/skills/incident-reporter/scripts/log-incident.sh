#!/bin/bash
# Log an operational incident
# Usage: ./log-incident.sh <severity> <title> <description>

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <severity> <title> <description>" >&2
  exit 1
fi

SEVERITY="$1"; TITLE="$2"; DESC="$3"

: "${OPS_API_URL:?OPS_API_URL environment variable is required}"
: "${OPS_API_KEY:?OPS_API_KEY environment variable is required}"

curl -s -X POST "${OPS_API_URL}/incidents" \
  -H "Authorization: Bearer ${OPS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"severity\":\"${SEVERITY}\",\"title\":\"${TITLE}\",\"description\":\"${DESC}\"}" \
  | jq '.'
