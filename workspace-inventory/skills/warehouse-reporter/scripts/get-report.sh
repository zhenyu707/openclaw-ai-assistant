#!/bin/bash
# Get inventory report
# Usage: ./get-report.sh <report_type> [period]

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <turnover|aging|valuation> [period]" >&2
  exit 1
fi

REPORT="$1"
PERIOD="${2:-last-month}"

: "${INVENTORY_API_URL:?INVENTORY_API_URL environment variable is required}"
: "${INVENTORY_API_KEY:?INVENTORY_API_KEY environment variable is required}"

curl -s "${INVENTORY_API_URL}/reports/${REPORT}?period=${PERIOD}" \
  -H "Authorization: Bearer ${INVENTORY_API_KEY}" | jq '.'
