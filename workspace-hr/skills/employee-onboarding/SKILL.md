---
name: employee-onboarding
description: Automate new employee onboarding workflow
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["HRIS_API_KEY", "HRIS_API_URL", "SLACK_WEBHOOK_URL"], "bins": ["curl", "jq"] } }
}
---

# Employee Onboarding Automation

## When to Use
When HR triggers a new employee onboarding, or when following up on in-progress onboarding.

## Onboarding Checklist

1. **Create HRIS Record**
   - POST $HRIS_API_URL/employees with employee data
   - Store employee_id in memory/onboarding-{employee_id}.md

2. **Trigger IT Provisioning**
   - POST to IT webhook with: name, email, department, start_date
   - IT will provision: laptop, email account, software licenses

3. **Send Welcome Email**
   - Use email skill to send welcome message
   - Include: start date, office location, manager contact, Slack invite

4. **Schedule Orientation**
   - Create calendar events: day 1 orientation, 30-day check-in, 90-day review
   - Invite: employee, manager, HR buddy

5. **Add to Team Channels**
   - Add to department Slack channel
   - Add to #announcements, #general

6. **Send First-Week Guide**
   - Share company wiki link, org chart, key contacts

7. **Set 30-day Check-in Cron**
   - Schedule follow-up reminder for 30 days post start

## Track Status
- Log each completed step in memory/onboarding-{employee_id}.md
- Report blockers immediately to HR Manager via Slack
- Mark each step as [DONE] or [BLOCKED: reason]
