#!/bin/bash
# Get social media analytics
# Usage: ./get-social-stats.sh <channel> [range]

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <channel> [range]" >&2
  exit 1
fi

CHANNEL="$1"
RANGE="${2:-last-7-days}"

: "${MARKETING_API_URL:?MARKETING_API_URL environment variable is required}"
: "${MARKETING_API_KEY:?MARKETING_API_KEY environment variable is required}"

curl -s "${MARKETING_API_URL}/social/analytics?channel=${CHANNEL}&range=${RANGE}" \
  -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
