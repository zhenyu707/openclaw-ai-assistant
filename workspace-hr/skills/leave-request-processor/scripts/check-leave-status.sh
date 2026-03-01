#!/bin/bash
# Check status of a submitted leave request
# Usage: ./check-leave-status.sh <request_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <request_id>" >&2
  exit 1
fi

REQUEST_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

curl -s -X GET "${HRIS_API_URL}/leave-requests/${REQUEST_ID}" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{
    request_id: .id,
    status: .status,
    employee_id: .employee_id,
    dates: { start: .start_date, end: .end_date },
    leave_type: .leave_type,
    approved_by: .approved_by,
    approved_at: .approved_at,
    notes: .manager_notes
  }'
