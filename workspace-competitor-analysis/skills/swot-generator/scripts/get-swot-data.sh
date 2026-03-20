#!/bin/bash
# Get data for SWOT analysis
# Usage: ./get-swot-data.sh <competitor_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <competitor_id>" >&2
  exit 1
fi

: "${INTEL_API_URL:?INTEL_API_URL environment variable is required}"
: "${INTEL_API_KEY:?INTEL_API_KEY environment variable is required}"

echo "=== Competitor Profile ==="
curl -s "${INTEL_API_URL}/competitors/$1" \
  -H "Authorization: Bearer ${INTEL_API_KEY}" | jq '.'

echo "=== Competitor Products ==="
curl -s "${INTEL_API_URL}/competitors/$1/products" \
  -H "Authorization: Bearer ${INTEL_API_KEY}" | jq '.'
