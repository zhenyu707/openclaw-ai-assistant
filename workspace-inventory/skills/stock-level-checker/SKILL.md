---
name: stock-level-checker
description: Query current inventory levels and flag low-stock items
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["INVENTORY_API_KEY", "INVENTORY_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Stock Level Checker

## When to Use
When someone asks about current stock levels, low-stock alerts, or item availability.

## Steps
1. Identify the item(s) or scope (all items, specific SKU, category)
2. Call: GET $INVENTORY_API_URL/items/{sku} or /items?category={cat}
3. Present stock levels with reorder points
4. Flag items below reorder point
