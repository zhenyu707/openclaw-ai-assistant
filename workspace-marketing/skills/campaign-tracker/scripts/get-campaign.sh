#!/bin/bash
# Get campaign details
# Usage: ./get-campaign.sh [campaign_id]

set -euo pipefail

: "${MARKETING_API_URL:?MARKETING_API_URL environment variable is required}"
: "${MARKETING_API_KEY:?MARKETING_API_KEY environment variable is required}"

if [[ $# -ge 1 ]]; then
  curl -s "${MARKETING_API_URL}/campaigns/$1" \
    -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
else
  curl -s "${MARKETING_API_URL}/campaigns" \
    -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
fi
