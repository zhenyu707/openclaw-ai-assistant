---
name: leave-request-processor
description: Submit, validate, and track employee leave requests via HRIS
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["HRIS_API_KEY", "HRIS_API_URL"], "bins": ["curl", "jq"] } }
}
---

# Leave Request Processor

## When to Use
Whenever an employee asks to submit or check status of a leave request.

## Steps

1. **Parse Request**
   - Extract: start_date, end_date, leave_type (vacation/sick/personal/parental), reason
   - Confirm details with employee before proceeding

2. **Validate Employee**
   - Use bash to call: GET $HRIS_API_URL/employees/{id}/leave-balance
   - Confirm employment status = active
   - Show current leave balance to employee

3. **Check Policy**
   - Minimum notice: 2 business days (except sick leave)
   - Maximum consecutive: 14 days without manager pre-approval
   - Blackout dates: check /policies/leave-policy.md

4. **Get Employee Confirmation**
   - Show summary: dates, type, reason, days requested
   - Ask: "Confirm submission? (yes/no)"
   - Only proceed after explicit YES

5. **Submit to HRIS**
   - Call: POST $HRIS_API_URL/leave-requests
   - Body: { employee_id, start_date, end_date, leave_type, reason }
   - Log reference number to memory/YYYY-MM-DD.md

6. **Notify**
   - Send confirmation message to employee with reference number
   - Optionally: notify manager via Slack
