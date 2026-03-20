---
name: budget-reporter
description: Generate department budget vs actual reports with variance highlighting
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["FINANCE_API_KEY", "FINANCE_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Budget Reporter

## When to Use
When a manager or employee requests budget reports, variance analysis, or spending summaries.

## Steps

1. **Identify Scope**
   - Determine: department, time period (month/quarter/year)
   - Confirm reporting parameters with requester

2. **Pull Budget Data**
   - Call: GET $FINANCE_API_URL/budgets/{dept}?period={period}
   - Retrieve both budget and actual figures

3. **Analyze Variances**
   - Calculate budget vs actual for each category
   - Flag variances >10% for attention
   - Flag variances >25% as critical

4. **Generate Report**
   - Format summary table with budget, actual, variance, % variance
   - Highlight over-budget categories
   - Include trend comparison to prior period if available
