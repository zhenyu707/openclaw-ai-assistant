#!/bin/bash
# Get budget vs actual report for a department
# Usage: ./get-budget-report.sh <department> <period>

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <department> <period>" >&2
  exit 1
fi

DEPT="$1"
PERIOD="$2"

: "${FINANCE_API_URL:?FINANCE_API_URL environment variable is required}"
: "${FINANCE_API_KEY:?FINANCE_API_KEY environment variable is required}"

curl -s "${FINANCE_API_URL}/budgets/${DEPT}?period=${PERIOD}" \
  -H "Authorization: Bearer ${FINANCE_API_KEY}" \
  | jq '.'
