# Inventory Agent Heartbeat (runs every 30 min)

Quick checks — respond HEARTBEAT_OK if nothing needs action:

- [ ] Any items below reorder point without active PO?
- [ ] Any purchase orders overdue for delivery?
- [ ] Any receiving inspections pending >24 hours?

Only act if something is truly urgent. Otherwise reply: HEARTBEAT_OK
