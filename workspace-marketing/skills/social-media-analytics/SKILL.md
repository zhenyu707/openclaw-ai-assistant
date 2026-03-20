---
name: social-media-analytics
description: Pull and summarize social media performance metrics
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["MARKETING_API_KEY", "MARKETING_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Social Media Analytics

## When to Use
When someone requests social media performance data, engagement metrics, or channel reports.

## Steps
1. Identify scope: channel, time range, specific metric
2. Call: GET $MARKETING_API_URL/social/analytics?channel={channel}&range={range}
3. Summarize key metrics: reach, engagement, clicks, conversions
4. Compare to prior period if available
