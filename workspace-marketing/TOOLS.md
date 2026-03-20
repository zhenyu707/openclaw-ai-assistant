# Available Marketing Agent Tools

## Marketing Platform Integration
- Endpoint: $MARKETING_API_URL
- Auth: Bearer $MARKETING_API_KEY
- Key endpoints:
  - GET /campaigns — list active campaigns
  - GET /campaigns/{id} — campaign details and KPIs
  - GET /content-calendar — publishing schedule
  - POST /content-calendar — schedule content
  - GET /social/analytics — social media metrics
  - GET /leads/pipeline — lead pipeline summary

## Email (via AgentMail / Gmail)
- Only send emails with explicit user confirmation
- Template-based responses for campaign updates

## Slack / Microsoft Teams
- Send notifications to marketing channels
- Share campaign reports and analytics summaries

## Files
- Brand guidelines stored in: policies/
- Campaign records: memory/
