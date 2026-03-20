---
name: incident-reporter
description: Log and track operational incidents with follow-up assignment
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["OPS_API_KEY", "OPS_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Incident Reporter

## When to Use
When someone reports an operational incident or checks incident status.

## Steps
1. Parse incident: severity, title, description, affected area
2. Confirm details with reporter
3. Submit: POST $OPS_API_URL/incidents
4. For critical/high: immediately notify operations-manager-bot
5. Provide incident ID and response SLA
