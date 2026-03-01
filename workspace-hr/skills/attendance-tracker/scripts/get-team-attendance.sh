#!/bin/bash
# Fetch attendance summary for a manager's team
# Usage: ./get-team-attendance.sh <team_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <team_id>" >&2
  exit 1
fi

TEAM_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

curl -s -X GET "${HRIS_API_URL}/teams/${TEAM_ID}/attendance-summary" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '[.[] | {
    employee: .full_name,
    employee_id: .employee_id,
    vacation_remaining: .vacation_remaining,
    sick_used_30d: .sick_days_last_30,
    pending_requests: .pending_leave_count,
    anomaly_flag: (if .sick_days_last_30 > 3 then "REVIEW: frequent unplanned absence" elif .vacation_remaining < 2 then "NOTE: low balance" else "OK" end)
  }]'
