---
name: reorder-processor
description: Generate and submit reorder requests when stock hits threshold
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INVENTORY_API_KEY", "INVENTORY_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Reorder Processor

## When to Use
When stock levels trigger a reorder or when manually requested.

## Steps
1. Identify items needing reorder (below ROP or manually specified)
2. Calculate reorder quantity (EOQ or specified)
3. Confirm details with requester: items, quantities, supplier, estimated cost
4. Get explicit confirmation before submitting
5. Submit: POST $INVENTORY_API_URL/reorders
6. Log reference number and notify inventory-manager-bot for approval
