---
name: campaign-tracker
description: Track active marketing campaigns, KPIs, deadlines, and status
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["MARKETING_API_KEY", "MARKETING_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Campaign Tracker

## When to Use
When someone asks about campaign status, KPIs, deadlines, or performance.

## Steps
1. Identify the campaign or time range requested
2. Call: GET $MARKETING_API_URL/campaigns or /campaigns/{id}
3. Present status, KPIs, and key metrics
4. Flag campaigns ending soon or underperforming
