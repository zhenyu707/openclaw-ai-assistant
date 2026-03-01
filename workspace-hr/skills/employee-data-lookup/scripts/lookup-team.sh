#!/bin/bash
# Fetch all direct reports for a given manager (safe fields only)
# Usage: ./lookup-team.sh <manager_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <manager_id>" >&2
  exit 1
fi

MANAGER_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

curl -s -X GET "${HRIS_API_URL}/employees?manager_id=${MANAGER_ID}" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '[.[] | {
    employee_id: .employee_id,
    name: .full_name,
    title: .job_title,
    department: .department,
    work_email: .work_email,
    office_location: .office_location,
    employment_status: .employment_status
  }]'
