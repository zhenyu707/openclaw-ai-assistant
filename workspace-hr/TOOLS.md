# Available HR Agent Tools

## HRIS API Integration
- Endpoint: $HRIS_API_URL
- Auth: Bearer $HRIS_API_KEY
- Key endpoints:
  - GET /employees/{id} — employee record
  - GET /employees/{id}/leave-balance — leave balances
  - POST /leave-requests — submit leave request
  - GET /leave-requests/{id} — check request status
  - POST /onboarding — trigger onboarding workflow

## Email (via AgentMail / Gmail)
- Only send emails with explicit user confirmation
- Template-based responses for common scenarios

## Calendar (Google Calendar / MS Calendar)
- Schedule meetings and HR appointments
- Check manager availability for approvals

## Slack / Microsoft Teams
- Send notifications to HR channels
- DM employees with status updates

## Files
- Company policies stored in: ~/.openclaw/workspace-hr/policies/
- Employee memory: ~/.openclaw/workspace-hr/memory/
