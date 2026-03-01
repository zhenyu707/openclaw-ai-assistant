#!/bin/bash
# Post a welcome announcement to Slack for a new hire
# Usage: ./notify-slack-welcome.sh <name> <title> <department> <start_date>

set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <name> <title> <department> <start_date>" >&2
  exit 1
fi

NAME="$1"
TITLE="$2"
DEPARTMENT="$3"
START_DATE="$4"

: "${SLACK_WEBHOOK_URL:?SLACK_WEBHOOK_URL environment variable is required}"

curl -s -X POST "${SLACK_WEBHOOK_URL}" \
  -H "Content-Type: application/json" \
  -d "{
    \"text\": \"👋 Welcome to the team, *${NAME}*! They're joining as *${TITLE}* in *${DEPARTMENT}* starting ${START_DATE}. Please give them a warm welcome!\"
  }"
