#!/bin/bash
# Check expense claim status
# Usage: ./check-expense-status.sh <expense_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <expense_id>" >&2
  exit 1
fi

EXPENSE_ID="$1"

: "${FINANCE_API_URL:?FINANCE_API_URL environment variable is required}"
: "${FINANCE_API_KEY:?FINANCE_API_KEY environment variable is required}"

curl -s "${FINANCE_API_URL}/expenses/${EXPENSE_ID}" \
  -H "Authorization: Bearer ${FINANCE_API_KEY}" \
  | jq '.'
