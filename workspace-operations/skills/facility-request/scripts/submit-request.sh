#!/bin/bash
# Submit a facility request
# Usage: ./submit-request.sh <category> <priority> <location> <description>

set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <category> <priority> <location> <description>" >&2
  exit 1
fi

CATEGORY="$1"; PRIORITY="$2"; LOCATION="$3"; DESC="$4"

: "${OPS_API_URL:?OPS_API_URL environment variable is required}"
: "${OPS_API_KEY:?OPS_API_KEY environment variable is required}"

curl -s -X POST "${OPS_API_URL}/facility-requests" \
  -H "Authorization: Bearer ${OPS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"category\":\"${CATEGORY}\",\"priority\":\"${PRIORITY}\",\"location\":\"${LOCATION}\",\"description\":\"${DESC}\"}" \
  | jq '.'
