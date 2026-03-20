# Available Accounting Agent Tools

## Financial System Integration
- Endpoint: $FINANCE_API_URL
- Auth: Bearer $FINANCE_API_KEY
- Key endpoints:
  - GET /expenses/{id} — expense claim details
  - POST /expenses — submit expense claim
  - GET /invoices/{id} — invoice details
  - POST /invoices/match — match invoice to PO
  - GET /budgets/{dept} — department budget report
  - GET /payroll/{employee_id}/summary — payroll summary (read-only)

## Email (via AgentMail / Gmail)
- Only send emails with explicit user confirmation
- Template-based responses for common scenarios

## Slack / Microsoft Teams
- Send notifications to finance channels
- DM employees with expense status updates

## Files
- Company policies stored in: policies/
- Financial records: memory/
