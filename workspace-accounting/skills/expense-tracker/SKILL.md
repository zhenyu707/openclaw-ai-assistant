---
name: expense-tracker
description: Submit, categorize, and track expense claims with policy validation
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["FINANCE_API_KEY", "FINANCE_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Expense Tracker

## When to Use
When an employee submits an expense claim, checks expense status, or queries past expenses.

## Steps

1. **Parse Request**
   - Extract: amount, category, date, description, receipt info
   - Confirm details with employee before proceeding

2. **Validate Against Policy**
   - Check approval threshold (self-service vs manager approval)
   - Verify category is eligible per expense policy
   - Check receipt requirement (above $[X] threshold)

3. **Get Employee Confirmation**
   - Show summary: amount, category, date, description
   - Ask: "Confirm submission? (yes/no)"
   - Only proceed after explicit YES

4. **Submit Expense**
   - Call: POST $FINANCE_API_URL/expenses
   - Log reference number to memory/YYYY-MM-DD.md

5. **Notify**
   - Send confirmation with reference number
   - If above threshold: notify manager for approval
