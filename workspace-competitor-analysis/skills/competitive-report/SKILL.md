---
name: competitive-report
description: Generate periodic competitive landscape reports
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INTEL_API_KEY", "INTEL_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Competitive Report

## When to Use
When someone requests a competitive landscape report or periodic competitive summary.

## Steps
1. Determine scope: all competitors or subset, time range
2. Pull landscape data: GET $INTEL_API_URL/reports/competitive-landscape
3. Structure report: executive summary, per-competitor updates, market trends, recommendations
4. Apply reporting standards from policies/reporting-standards.md
5. Label with date, confidence level, and classification
