---
name: attendance-tracker
description: Check leave balances, attendance records, and time-off requests
version: 1.0
metadata: {
  "openclaw": { "requires": { "env": ["HRIS_API_KEY", "HRIS_API_URL"] } }
}
---

# Attendance Tracker

## When to Use
When employees or managers ask about time-off balances, attendance patterns,
or need attendance reports.

## Steps

**For employee self-lookup:**
1. GET $HRIS_API_URL/employees/{id}/leave-balance using scripts/get-attendance.sh
2. Show: vacation days used, remaining, sick days, personal days
3. Show pending leave requests and their status

**For manager team reports:**
1. Verify requester is a manager (check their title/role in HRIS)
2. GET $HRIS_API_URL/teams/{team_id}/attendance-summary using scripts/get-team-attendance.sh
3. Format as table: employee | days taken | days remaining | pending requests
4. Flag employees with: >3 unplanned absences in rolling 30 days

## Anomaly Flags (manager reports only)
- >3 unplanned absences in 30 days → flag for wellness check-in
- Leave balance < 2 days remaining → flag, suggest planning
- >10 consecutive sick days → suggest HR manager outreach
