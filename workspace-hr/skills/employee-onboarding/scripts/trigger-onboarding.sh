#!/bin/bash
# Trigger onboarding workflow for a new employee
# Usage: ./trigger-onboarding.sh <name> <email> <department> <title> <manager_id> <start_date>

set -euo pipefail

if [[ $# -lt 6 ]]; then
  echo "Usage: $0 <name> <email> <department> <title> <manager_id> <start_date>" >&2
  exit 1
fi

NAME="$1"
EMAIL="$2"
DEPARTMENT="$3"
TITLE="$4"
MANAGER_ID="$5"
START_DATE="$6"

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

echo "Creating HRIS record for ${NAME}..."
RESPONSE=$(curl -s -X POST "${HRIS_API_URL}/employees" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"full_name\": \"${NAME}\",
    \"work_email\": \"${EMAIL}\",
    \"department\": \"${DEPARTMENT}\",
    \"job_title\": \"${TITLE}\",
    \"manager_id\": \"${MANAGER_ID}\",
    \"start_date\": \"${START_DATE}\",
    \"employment_status\": \"active\"
  }")

echo "${RESPONSE}" | jq '.'

EMP_ID=$(echo "${RESPONSE}" | jq -r '.employee_id')
echo "Created employee: ${EMP_ID}"

echo "Triggering onboarding workflow..."
curl -s -X POST "${HRIS_API_URL}/onboarding" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"employee_id\": \"${EMP_ID}\",
    \"start_date\": \"${START_DATE}\",
    \"department\": \"${DEPARTMENT}\"
  }" | jq '.'
