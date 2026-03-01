---
name: employee-data-lookup
description: Safely retrieve employee information (non-sensitive fields only)
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["HRIS_API_KEY", "HRIS_API_URL"] } }
}
---

# Employee Data Lookup

## When to Use
When someone asks for employee information (name, department, manager, title, contact).

## IMPORTANT SECURITY RULES
- NEVER return: salary, SSN, health data, performance reviews, disciplinary records
- Only return: name, employee_id, department, title, manager, work_email, office_location, hire_date
- Verify requester is authorized (self-lookup is always allowed; manager can see direct reports)
- Log every lookup in memory/YYYY-MM-DD.md with: who requested, who was looked up, timestamp

## Steps

1. Identify the employee (by name or ID)
2. Verify requester authorization:
   - Is this a self-lookup? → Always allowed
   - Is the requester a manager of the target employee? → Allowed
   - Is the requester HR? → Allowed for non-sensitive fields
   - Anyone else? → Deny and explain
3. Call: GET $HRIS_API_URL/employees/{id} using scripts/lookup-employee.sh
4. Filter response — remove ALL sensitive fields before displaying
5. Return only the safe fields listed above
6. Write audit log entry to memory/YYYY-MM-DD.md
