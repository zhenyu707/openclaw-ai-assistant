---
name: payroll-query
description: Answer payroll questions (pay dates, deductions, tax forms) — read-only
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["FINANCE_API_KEY", "FINANCE_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Payroll Query

## When to Use
When an employee asks about pay dates, deductions, tax forms, or payroll summaries. READ-ONLY — never modify payroll data.

## Steps

1. **Identify Query Type**
   - Pay dates and schedule
   - Deductions breakdown
   - Tax form requests (W-2, 1099, etc.)
   - Year-to-date earnings summary

2. **Verify Identity**
   - Confirm employee ID before sharing personal payroll data
   - Only share data for the requesting employee

3. **Retrieve Data**
   - Call: GET $FINANCE_API_URL/payroll/{employee_id}/summary
   - NEVER call write/update endpoints

4. **Respond**
   - Present clear, formatted payroll information
   - Direct to Payroll team for corrections or disputes

## Important
- This skill is READ-ONLY — never submit changes to payroll
- Never share one employee's payroll data with another
- For payroll corrections: "Please contact Payroll directly"
