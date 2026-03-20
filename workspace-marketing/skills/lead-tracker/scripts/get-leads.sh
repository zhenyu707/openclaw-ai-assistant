#!/bin/bash
# Get lead pipeline summary
# Usage: ./get-leads.sh [stage]

set -euo pipefail

: "${MARKETING_API_URL:?MARKETING_API_URL environment variable is required}"
: "${MARKETING_API_KEY:?MARKETING_API_KEY environment variable is required}"

if [[ $# -ge 1 ]]; then
  curl -s "${MARKETING_API_URL}/leads/pipeline?stage=$1" \
    -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
else
  curl -s "${MARKETING_API_URL}/leads/pipeline" \
    -H "Authorization: Bearer ${MARKETING_API_KEY}" | jq '.'
fi
