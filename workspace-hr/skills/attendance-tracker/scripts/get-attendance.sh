#!/bin/bash
# Fetch an employee's leave balance and pending requests
# Usage: ./get-attendance.sh <employee_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <employee_id>" >&2
  exit 1
fi

EMP_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

echo "=== Leave Balance for ${EMP_ID} ==="
curl -s -X GET "${HRIS_API_URL}/employees/${EMP_ID}/leave-balance" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{
    vacation: { used: .vacation_used, remaining: .vacation_remaining },
    sick: { used: .sick_used, remaining: .sick_remaining },
    personal: { used: .personal_used, remaining: .personal_remaining }
  }'

echo ""
echo "=== Pending Leave Requests ==="
curl -s -X GET "${HRIS_API_URL}/leave-requests?employee_id=${EMP_ID}&status=pending" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '[.[] | { id: .id, dates: "\(.start_date) to \(.end_date)", type: .leave_type, status: .status }]'
