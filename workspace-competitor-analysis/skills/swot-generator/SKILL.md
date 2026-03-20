---
name: swot-generator
description: Generate SWOT analyses from competitor data and internal context
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INTEL_API_KEY", "INTEL_API_URL"], "bins": ["curl", "jq"] } }
}
---

# SWOT Generator

## When to Use
When someone requests a SWOT analysis for a competitor or for our own position.

## Steps
1. Identify subject: specific competitor or our company
2. Gather data: competitor profile, market trends, internal context
3. Generate SWOT matrix: Strengths, Weaknesses, Opportunities, Threats
4. Include actionable recommendations
5. Cite all data sources
