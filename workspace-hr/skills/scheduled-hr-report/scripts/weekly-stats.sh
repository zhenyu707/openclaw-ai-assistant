#!/bin/bash
# Pull weekly HR stats from HRIS for the report
# Usage: ./weekly-stats.sh [YYYY-MM-DD]  (defaults to today)

set -euo pipefail

: "${HRIS_API_URL:?HRIS_API_URL environment variable is required}"
: "${HRIS_API_KEY:?HRIS_API_KEY environment variable is required}"

SINCE="${1:-$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d)}"
TODAY=$(date +%Y-%m-%d)

echo "=== Weekly HR Stats: ${SINCE} to ${TODAY} ==="

echo ""
echo "--- New Hires ---"
curl -s "${HRIS_API_URL}/employees?hired_after=${SINCE}" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '[.[] | {name: .full_name, role: .job_title, department: .department, start_date: .start_date}]'

echo ""
echo "--- Leave Taken ---"
curl -s "${HRIS_API_URL}/leave-requests?status=approved&start_after=${SINCE}" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{total_requests: length, total_days: ([.[] | (.end_date | split("-") | map(tonumber)) as $e | (.start_date | split("-") | map(tonumber)) as $s | ($e[2] - $s[2] + 1)] | add // 0)}'

echo ""
echo "--- Pending Requests ---"
curl -s "${HRIS_API_URL}/leave-requests?status=pending" \
  -H "Authorization: Bearer ${HRIS_API_KEY}" \
  | jq '{pending_count: length, requests: [.[] | {employee: .employee_name, dates: "\(.start_date) to \(.end_date)", type: .leave_type}]}'
