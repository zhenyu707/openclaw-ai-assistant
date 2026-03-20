#!/bin/bash
# Get operational tasks
# Usage: ./get-tasks.sh [status]

set -euo pipefail

: "${OPS_API_URL:?OPS_API_URL environment variable is required}"
: "${OPS_API_KEY:?OPS_API_KEY environment variable is required}"

STATUS="${1:-open}"

curl -s "${OPS_API_URL}/tasks?status=${STATUS}" \
  -H "Authorization: Bearer ${OPS_API_KEY}" | jq '.'
