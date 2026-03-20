---
name: warehouse-reporter
description: Generate inventory turnover, aging, and valuation reports
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INVENTORY_API_KEY", "INVENTORY_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Warehouse Reporter

## When to Use
When someone requests inventory reports: turnover, aging, valuation, or movement summary.

## Steps
1. Identify report type and scope (date range, category, location)
2. Call appropriate endpoint:
   - Turnover: GET $INVENTORY_API_URL/reports/turnover
   - Aging: GET $INVENTORY_API_URL/reports/aging
   - Valuation: GET $INVENTORY_API_URL/reports/valuation
3. Present formatted report with key metrics
4. Highlight items needing attention (slow movers, aged stock, valuation changes)
