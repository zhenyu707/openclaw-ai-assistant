#!/bin/bash
# Fetch employee record and return only safe (non-sensitive) fields
# Usage: ./lookup-employee.sh <employee_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <employee_id>" >&2
  exit 1
fi

EMP_ID="$1"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

# Fetch and immediately strip all sensitive fields via jq
curl -s -X GET "${HRIS_API_URL}/employees/${EMP_ID}" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{
    employee_id: .employee_id,
    name: .full_name,
    title: .job_title,
    department: .department,
    manager: .manager_name,
    manager_id: .manager_id,
    work_email: .work_email,
    office_location: .office_location,
    hire_date: .hire_date,
    employment_status: .employment_status
  }'
# NOTE: salary, ssn, health_data, performance_data, disciplinary_records
# are intentionally excluded from this jq filter.
