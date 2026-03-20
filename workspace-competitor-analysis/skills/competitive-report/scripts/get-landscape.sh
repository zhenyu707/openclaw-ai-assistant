#!/bin/bash
# Get competitive landscape report data
# Usage: ./get-landscape.sh [range]

set -euo pipefail

RANGE="${1:-last-quarter}"

: "${INTEL_API_URL:?INTEL_API_URL environment variable is required}"
: "${INTEL_API_KEY:?INTEL_API_KEY environment variable is required}"

curl -s "${INTEL_API_URL}/reports/competitive-landscape?range=${RANGE}" \
  -H "Authorization: Bearer ${INTEL_API_KEY}" | jq '.'
