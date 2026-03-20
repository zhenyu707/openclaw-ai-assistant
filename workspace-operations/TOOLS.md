# Available Operations Agent Tools

## Operations Platform Integration
- Endpoint: $OPS_API_URL
- Auth: Bearer $OPS_API_KEY
- Key endpoints:
  - GET /tasks — list operational tasks
  - POST /tasks — create task
  - GET /tasks/{id} — task details
  - GET /vendors/{id} — vendor info
  - GET /vendors/{id}/contracts — vendor contracts
  - POST /facility-requests — submit facility request
  - GET /facility-requests/{id} — request status
  - POST /incidents — log incident

## Email (via AgentMail / Gmail)
- Only send emails with explicit user confirmation

## Slack / Microsoft Teams
- Send notifications to operations channels
- Alert on incidents and urgent requests

## Files
- SOPs stored in: policies/
- Operational records: memory/
