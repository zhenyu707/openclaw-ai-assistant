---
name: market-trend-tracker
description: Summarize industry trends and market movements
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INTEL_API_KEY", "INTEL_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Market Trend Tracker

## When to Use
When someone asks about industry trends, market movements, or sector analysis.

## Steps
1. Identify scope: industry segment, time range
2. Call: GET $INTEL_API_URL/market-trends?segment={segment}&range={range}
3. Summarize key trends with data points
4. Note implications for our business
