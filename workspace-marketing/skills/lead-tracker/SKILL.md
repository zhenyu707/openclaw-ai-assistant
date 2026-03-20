---
name: lead-tracker
description: Query and report on lead pipeline status and conversion metrics
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["MARKETING_API_KEY", "MARKETING_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Lead Tracker

## When to Use
When someone asks about lead pipeline, conversion rates, or lead status.

## Steps
1. Identify query: pipeline overview, specific lead, or conversion metrics
2. Call: GET $MARKETING_API_URL/leads/pipeline
3. Present pipeline stages, counts, and conversion rates
4. Flag leads stuck in a stage for >X days
