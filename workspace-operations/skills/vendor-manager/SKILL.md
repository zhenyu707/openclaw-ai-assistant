---
name: vendor-manager
description: Lookup vendor info, contract status, and SLA compliance
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["OPS_API_KEY", "OPS_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Vendor Manager

## When to Use
When someone asks about vendor information, contract status, or SLA compliance.

## Steps
1. Identify the vendor or query scope
2. Call: GET $OPS_API_URL/vendors/{id} or /vendors/{id}/contracts
3. Present vendor details, contract dates, and SLA status
4. Flag contracts expiring within 60 days
