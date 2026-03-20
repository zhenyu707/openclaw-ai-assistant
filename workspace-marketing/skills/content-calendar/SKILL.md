---
name: content-calendar
description: Manage content publishing schedule across channels
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["MARKETING_API_KEY", "MARKETING_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Content Calendar

## When to Use
When managing the content publishing schedule — viewing, adding, or updating entries.

## Steps
1. Identify the action: view schedule, add entry, or update entry
2. For viewing: GET $MARKETING_API_URL/content-calendar?range={range}
3. For adding: confirm details → POST $MARKETING_API_URL/content-calendar
4. Present calendar in clear date/channel/topic format
