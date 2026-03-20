---
name: invoice-processor
description: Process incoming/outgoing invoices with PO matching and discrepancy flagging
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["FINANCE_API_KEY", "FINANCE_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Invoice Processor

## When to Use
When processing invoices, matching to purchase orders, or checking invoice status.

## Steps

1. **Parse Invoice Details**
   - Extract: vendor, invoice number, amount, PO number, due date
   - Identify line items and quantities

2. **Match to Purchase Order**
   - Call: GET $FINANCE_API_URL/purchase-orders/{po_number}
   - Compare invoice amount to PO amount
   - Flag discrepancies >5% for review

3. **Validate**
   - Check vendor is in approved vendor list
   - Verify payment terms
   - Check for duplicate invoices

4. **Process or Escalate**
   - If matched and within tolerance: mark for payment
   - If discrepancy found: escalate to accounting-manager-bot
   - Log all actions to memory/YYYY-MM-DD.md
