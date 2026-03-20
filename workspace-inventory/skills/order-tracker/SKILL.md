---
name: order-tracker
description: Track purchase orders, delivery status, and ETAs
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INVENTORY_API_KEY", "INVENTORY_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Order Tracker

## When to Use
When someone asks about purchase order status, delivery ETAs, or order history.

## Steps
1. Identify the PO or scope (all active POs, specific PO, vendor POs)
2. Call: GET $INVENTORY_API_URL/orders/{id} or /orders?status=active
3. Present order details: status, ETA, items, quantities
4. Flag overdue orders
