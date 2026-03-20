#!/bin/bash
# Submit an expense claim to the Finance API
# Usage: ./submit-expense.sh <employee_id> <amount> <category> <date> <description>

set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <employee_id> <amount> <category> <date> <description>" >&2
  exit 1
fi

EMP_ID="$1"
AMOUNT="$2"
CATEGORY="$3"
DATE="$4"
DESCRIPTION="$5"

: "${FINANCE_API_URL:?FINANCE_API_URL environment variable is required}"
: "${FINANCE_API_KEY:?FINANCE_API_KEY environment variable is required}"

curl -s -X POST "${FINANCE_API_URL}/expenses" \
  -H "Authorization: Bearer ${FINANCE_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"employee_id\": \"${EMP_ID}\",
    \"amount\": ${AMOUNT},
    \"category\": \"${CATEGORY}\",
    \"date\": \"${DATE}\",
    \"description\": \"${DESCRIPTION}\"
  }" \
  | jq '.'
