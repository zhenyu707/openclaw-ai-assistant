#!/bin/bash
# Create an operational task
# Usage: ./create-task.sh <title> <priority> <assignee> <due_date>

set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <title> <priority> <assignee> <due_date>" >&2
  exit 1
fi

TITLE="$1"; PRIORITY="$2"; ASSIGNEE="$3"; DUE="$4"

: "${OPS_API_URL:?OPS_API_URL environment variable is required}"
: "${OPS_API_KEY:?OPS_API_KEY environment variable is required}"

curl -s -X POST "${OPS_API_URL}/tasks" \
  -H "Authorization: Bearer ${OPS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"title\":\"${TITLE}\",\"priority\":\"${PRIORITY}\",\"assignee\":\"${ASSIGNEE}\",\"due_date\":\"${DUE}\"}" \
  | jq '.'
