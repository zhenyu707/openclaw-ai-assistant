---
name: scheduled-hr-report
description: Generate weekly and monthly HR summary reports for leadership
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["HRIS_API_KEY", "HRIS_API_URL", "SLACK_WEBHOOK_URL"], "bins": ["curl", "jq"] } }
}
---

# Scheduled HR Report

## When to Use
When triggered by a cron job or manual request for a periodic HR summary.

## Weekly Report (Fridays)
Generate a summary of the past 7 days:

1. Run scripts/weekly-stats.sh to pull data
2. Format report with sections:
   - **New Hires This Week:** name, role, department, start date
   - **Departures:** name, role, last day (if any)
   - **Leave Taken:** total employee-days of leave across company
   - **Pending Leave Requests:** count and names
   - **Open Onboardings:** in-progress new hire setups with status
   - **Anomalies:** attendance flags from this week
3. Post to Slack #hr-weekly channel via SLACK_WEBHOOK_URL
4. Save report copy to memory/weekly-report-YYYY-MM-DD.md

## Monthly Report (1st of month)
Compile broader metrics:
1. Headcount: total, by department, net change vs prior month
2. Attrition rate: voluntary vs involuntary
3. Leave utilization: average days taken per employee
4. Compliance: benefits enrollment, policy acknowledgments due
5. Open requisitions / hiring pipeline status
6. Post to Slack and email to HR Director

## Format Guidelines
- Use clear headers and bullet points
- Keep each section under 5 bullet points
- Flag anything requiring action with: ⚠️
- Keep total report under 400 words
