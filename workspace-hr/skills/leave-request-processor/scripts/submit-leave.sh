#!/bin/bash
# Submit a leave request to the HRIS API
# Usage: ./submit-leave.sh <employee_id> <start_date> <end_date> <leave_type> <reason>
# Example: ./submit-leave.sh EMP-001 2026-03-20 2026-03-22 vacation "Family trip"

set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <employee_id> <start_date> <end_date> <leave_type> <reason>" >&2
  exit 1
fi

EMP_ID="$1"
START="$2"
END="$3"
TYPE="$4"
REASON="$5"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

curl -s -X POST "${HRIS_API_URL}/leave-requests" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"employee_id\": \"${EMP_ID}\",
    \"start_date\": \"${START}\",
    \"end_date\": \"${END}\",
    \"leave_type\": \"${TYPE}\",
    \"reason\": \"${REASON}\"
  }" \
  | jq '.'
