#!/bin/bash
# Register all OpenClaw cron jobs for the HR AI Agent
# Run this AFTER openclaw is installed and running: openclaw onboard --install-daemon
#
# Usage: ./setup-crons.sh

set -euo pipefail

echo "Registering HR Agent cron jobs..."

# Daily: Review pending leave approvals (9 AM weekdays)
openclaw cron add "0 9 * * 1-5" \
  --agent hr-manager-bot \
  --message "Review all pending leave requests. Approve routine ones (sufficient balance, adequate notice, no coverage conflict). Flag complex or borderline cases for the human HR Manager."

echo "[OK] Registered: daily leave review (Mon-Fri 9 AM)"

# Weekly: HR Summary to Slack (Friday 5 PM)
openclaw cron add "0 17 * * 5" \
  --agent main \
  --message "Generate weekly HR summary using the scheduled-hr-report skill: new hires this week, departures, leave taken, pending leave requests, open onboardings, attendance anomalies. Post to Slack #hr-weekly channel." \
  --deliver slack

echo "[OK] Registered: weekly HR summary (Fri 5 PM)"

# Monthly: Compliance Check (1st of month, 9 AM)
openclaw cron add "0 9 1 * *" \
  --agent hr-manager-bot \
  --message "Monthly compliance review: check benefits enrollment deadlines, policy acknowledgment requirements, any regulatory changes this month, and open compliance items. Summarize findings and flag any actions needed."

echo "[OK] Registered: monthly compliance check (1st of month 9 AM)"

# Daily: Onboarding Follow-up (10 AM weekdays)
openclaw cron add "0 10 * * 1-5" \
  --agent hr-employee-bot \
  --message "Check all in-progress employee onboardings in memory/onboarding-*.md. Flag any blocked or overdue steps. Notify responsible parties via Slack if action is needed."

echo "[OK] Registered: daily onboarding check (Mon-Fri 10 AM)"

echo ""
echo "All cron jobs registered. Verify with: openclaw cron list"
