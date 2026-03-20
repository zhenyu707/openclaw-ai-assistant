#!/bin/bash
# Get content calendar
# Usage: ./get-calendar.sh [range]

set -euo pipefail

RANGE="${1:-this-week}"

: "${MARKETING_API_URL:?MARKETING_API_URL environment variable is required}"
: "${MARKETING_API_KEY:?MARKETING_API_KEY environment variable is required}"

curl -s "${MARKETING_API_URL}/content-calendar?range=${RANGE}" \
  -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
