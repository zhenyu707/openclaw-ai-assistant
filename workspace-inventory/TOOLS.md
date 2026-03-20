# Available Inventory Management Agent Tools

## Inventory System Integration
- Endpoint: $INVENTORY_API_URL
- Auth: Bearer $INVENTORY_API_KEY
- Key endpoints:
  - GET /items — list inventory items
  - GET /items/{sku} — item details and stock level
  - GET /items/{sku}/history — stock movement history
  - GET /orders — list purchase orders
  - GET /orders/{id} — PO details and status
  - POST /reorders — submit reorder request
  - GET /reports/turnover — inventory turnover report
  - GET /reports/aging — inventory aging report
  - GET /reports/valuation — inventory valuation report

## Email (via AgentMail / Gmail)
- Only send emails with explicit user confirmation

## Slack / Microsoft Teams
- Send low-stock alerts to inventory channels
- Notify on delivery arrivals and delays

## Files
- Inventory SOPs stored in: policies/
- Inventory records: memory/
