---
name: competitor-profiler
description: Maintain and query competitor profiles (products, pricing, market share)
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INTEL_API_KEY", "INTEL_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Competitor Profiler

## When to Use
When someone asks about a specific competitor's profile, products, or market position.

## Steps
1. Identify the competitor
2. Call: GET $INTEL_API_URL/competitors/{id}
3. Present profile: overview, products, market share, recent news
4. Cite data sources and freshness dates
