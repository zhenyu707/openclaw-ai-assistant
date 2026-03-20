---
name: facility-request
description: Submit and track facility/maintenance requests
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["OPS_API_KEY", "OPS_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Facility Request

## When to Use
When someone needs to submit or check status of a facility/maintenance request.

## Steps
1. Parse request: category, description, priority, location
2. Confirm details with requester
3. Submit: POST $OPS_API_URL/facility-requests
4. Provide reference number and expected SLA
