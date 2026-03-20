#!/bin/bash
# Get payroll summary for an employee (read-only)
# Usage: ./get-payroll-summary.sh <employee_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <employee_id>" >&2
  exit 1
fi

EMP_ID="$1"

: "${FINANCE_API_URL:?FINANCE_API_URL environment variable is required}"
: "${FINANCE_API_KEY:?FINANCE_API_KEY environment variable is required}"

curl -s "${FINANCE_API_URL}/payroll/${EMP_ID}/summary" \
  -H "Authorization: Bearer ${FINANCE_API_KEY}" \
  | jq '.'
