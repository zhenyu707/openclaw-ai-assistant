---
name: task-tracker
description: Track operational tasks, assignments, and deadlines
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["OPS_API_KEY", "OPS_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Task Tracker

## When to Use
When someone asks about operational tasks, assignments, deadlines, or wants to create/update tasks.

## Steps
1. Identify action: query tasks, create task, or update status
2. For querying: GET $OPS_API_URL/tasks?assignee={id}&status={status}
3. For creating: confirm details → POST $OPS_API_URL/tasks
4. Present tasks with priority, assignee, deadline, and status
