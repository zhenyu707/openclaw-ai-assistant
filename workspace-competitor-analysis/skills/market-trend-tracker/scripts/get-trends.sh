#!/bin/bash
# Get market trends
# Usage: ./get-trends.sh [segment] [range]

set -euo pipefail

SEGMENT="${1:-all}"
RANGE="${2:-last-quarter}"

: "${INTEL_API_URL:?INTEL_API_URL environment variable is required}"
: "${INTEL_API_KEY:?INTEL_API_KEY environment variable is required}"

curl -s "${INTEL_API_URL}/market-trends?segment=${SEGMENT}&range=${RANGE}" \
  -H "Authorization: Bearer ${INTEL_API_KEY}" | jq '.'
