#!/bin/bash
# Check an employee's current leave balance
# Usage: ./check-leave-balance.sh <employee_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <employee_id>" >&2
  exit 1
fi

EMP_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

curl -s -X GET "${HRIS_API_URL}/employees/${EMP_ID}/leave-balance" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{
    employee_id: .employee_id,
    vacation: { used: .vacation_used, remaining: .vacation_remaining },
    sick: { used: .sick_used, remaining: .sick_remaining },
    personal: { used: .personal_used, remaining: .personal_remaining },
    parental_available: .parental_available
  }'
