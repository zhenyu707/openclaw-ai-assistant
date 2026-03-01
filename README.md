# HR AI Agent · OpenClaw

> A self-hosted, multi-agent HR assistant that handles leave requests, policy Q&A, onboarding, attendance tracking, and scheduled HR reports — running entirely on your infrastructure.

---

## What Is This?

This project deploys a production-grade **HR AI Agent** on [OpenClaw](https://github.com/openclaw/openclaw) — an open-source, self-hosted AI assistant platform. The agent integrates with your HRIS, messaging channels (Slack/Teams), and company policy documents to give employees instant, private HR support without any data leaving your network.

**What it handles:**

| Capability | Description |
|---|---|
| Leave Requests | Submit, validate balance, confirm, and track via HRIS API |
| Policy Q&A | Answer questions from authoritative company policy docs |
| Employee Lookup | Safely retrieve non-sensitive employee info |
| Onboarding | Automate new-hire workflows (IT, email, calendar, Slack) |
| Attendance | Query time-off balances and flag attendance anomalies |
| Scheduled Reports | Daily/weekly HR summaries posted to Slack/Teams |

---

## Architecture

```
Employees (Slack / Teams / Telegram / DM)
            │
            ▼
  ┌─────────────────────┐
  │   OpenClaw Gateway  │   ws://127.0.0.1:18789
  │   (control plane)   │   auth: token
  └─────────────────────┘
            │
    ┌───────┴────────────────┐
    │                        │
    ▼                        ▼
hr-employee-bot         hr-manager-bot
(self-service)          (approvals + escalation)
    │
    ├── leave-request-processor
    ├── employee-data-lookup
    ├── hr-policy-qa
    ├── employee-onboarding
    ├── attendance-tracker
    └── scheduled-hr-report
            │
            ▼
  HRIS API  http://127.0.0.1:8888
  (mock during dev / real URL in prod)
```

**Model:** `google/gemini-2.5-flash`
**Session isolation:** `per-channel-peer` — each employee's DM is a private session

---

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Node.js | ≥ 22.12.0 | Use nvm; Node 20 does **not** work |
| OpenClaw | 2026.2.26+ | Installed globally via npm |
| ANTHROPIC_API_KEY | — | Required for agent turns |
| curl + jq | any | Used by skill scripts |

Install Node 22 via nvm:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 22
nvm use 22
```

---

## Quick Start

```bash
# 1. Load environment variables
source ~/.openclaw/.env

# 2. Start the gateway
export PATH="$HOME/.nvm/versions/node/v22.22.0/bin:$PATH"
openclaw gateway start

# 3. Open the dashboard
# Navigate to: http://127.0.0.1:18789/?token=<your-gateway-token>

# 4. Send a test message
curl -s -X POST http://127.0.0.1:18789/hooks/agent \
  -H "Authorization: Bearer $WEBHOOK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"agentId":"main","message":"What is our vacation policy?"}'
```

---

## Starting the Gateway

### Foreground (development)

```bash
source ~/.nvm/nvm.sh && nvm use 22 --silent
source ~/.openclaw/.env
openclaw gateway start
```

### Background (production / persistent)

```bash
source ~/.openclaw/.env
export PATH="$HOME/.nvm/versions/node/v22.22.0/bin:$PATH"
nohup openclaw gateway --force > /tmp/openclaw-gateway.log 2>&1 &
```

Check the log:

```bash
tail -f /tmp/openclaw-gateway.log
```

### Health check

```bash
curl http://127.0.0.1:18789/health
```

### Gateway status and diagnostics

```bash
openclaw status
openclaw doctor
openclaw doctor --fix   # auto-repair common config issues
```

---

## Dashboard

The OpenClaw dashboard is available at:

```
http://127.0.0.1:18789/?token=<YOUR_GATEWAY_TOKEN>
```

> **Note:** The token is stored in your browser's `localStorage` after first visit. Bookmark the URL with the token included.

From the dashboard you can:
- Monitor active agent sessions
- View conversation history
- Inspect skill invocations and tool calls
- Trigger manual agent messages
- Review gateway logs in real time

---

## Agents

| Agent ID | Workspace | Role |
|---|---|---|
| `main` | `workspace-hr` | Primary HR agent — routes all employee requests |
| `hr-employee-bot` | `workspace-hr-employee` | Employee self-service (leave, lookup, policy, onboarding) |
| `hr-manager-bot` | `workspace-hr-manager` | Manager approvals, escalations, compliance reports |

All three agents share the model `google/gemini-2.5-flash` and communicate via OpenClaw's internal agent-to-agent routing.

---

## Skills

Six skills are deployed in `~/.openclaw/workspace-hr/skills/`:

| Skill | Description |
|---|---|
| `leave-request-processor` | Submit, validate, and track employee leave requests via HRIS. Enforces minimum notice, blackout dates, and balance checks. Requires explicit employee confirmation before API submission. |
| `employee-data-lookup` | Safely retrieve employee info (name, department, title, manager, hire date). Strips all sensitive fields (salary, SSN, health data). Writes a full audit log entry on every lookup. |
| `hr-policy-qa` | Answer HR policy questions by reading authoritative policy docs in `workspace-hr/policies/`. Cites source document and section for every answer. |
| `employee-onboarding` | Automate new-hire workflow: create HRIS record → provision IT → send welcome email → schedule orientation → add to Slack channels → set 30-day check-in cron. |
| `attendance-tracker` | Query leave balances and time-off records. Generates team attendance summaries for managers and flags anomalies (3+ unplanned absences in 30 days). |
| `scheduled-hr-report` | Generate daily/weekly HR summaries (new hires, exits, leave taken, open positions, onboarding status) and post to Slack or Teams. |

---

## Example Conversations

Once connected to Slack or Teams, employees interact naturally:

| Employee Says | What the Agent Does |
|---|---|
| `"I need 3 days off next week"` | Checks leave balance → confirms dates → submits request to HRIS |
| `"What's our parental leave policy?"` | Reads `leave-policy.md` → summarizes with citation |
| `"How many vacation days do I have left?"` | Queries HRIS leave-balance endpoint → reports remaining days |
| `"Who is Jane Smith's manager?"` | Looks up employee record (safe fields only) → responds |
| `"I need bereavement leave"` | Responds with empathy → routes to `hr-manager-bot` |
| `"I just started. What do I need to do?"` | Runs employee-onboarding skill checklist |
| `"Can I work remotely full time?"` | Reads `remote-work-policy.md` → summarizes policy |
| `"What's my attendance record this month?"` | Queries HRIS attendance records → presents summary |

---

## Testing with Mock HRIS

A mock HRIS server runs at `http://127.0.0.1:8888` for local development.

### Start the mock server

```bash
# If using the included mock (Node/Python)
cd ~/.openclaw/workspace-hr
node mock-hris/server.js
# — or —
python3 mock-hris/server.py
```

### Test a leave request end-to-end

```bash
# 1. Check employee leave balance
curl -s http://127.0.0.1:8888/employees/EMP-001/leave-balance \
  -H "Authorization: Bearer $HRIS_API_KEY" | jq '.'

# 2. Submit leave request
curl -s -X POST http://127.0.0.1:8888/leave-requests \
  -H "Authorization: Bearer $HRIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "employee_id": "EMP-001",
    "start_date": "2026-03-20",
    "end_date": "2026-03-22",
    "leave_type": "vacation",
    "reason": "Spring break"
  }' | jq '.'

# 3. Verify via HR agent webhook
curl -s -X POST http://127.0.0.1:18789/hooks/agent \
  -H "Authorization: Bearer $WEBHOOK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"agentId":"hr-employee-bot","message":"Check status of my leave request for March 20-22"}'
```

---

## Webhook Testing

OpenClaw accepts incoming webhooks to trigger agent actions. Useful for HRIS-initiated events (leave approved, new hire added, etc.).

### Trigger an agent message

```bash
curl -s -X POST http://127.0.0.1:18789/hooks/agent \
  -H "Authorization: Bearer $WEBHOOK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "main",
    "message": "Leave request REF-12345 for John Doe has been approved by manager. Dates: March 15-19. Send employee confirmation.",
    "deliver": true,
    "channel": "slack"
  }'
```

### Trigger onboarding from HRIS new-hire event

```bash
curl -s -X POST http://127.0.0.1:18789/hooks/agent \
  -H "Authorization: Bearer $WEBHOOK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "hr-employee-bot",
    "message": "New employee onboarding: Jane Smith, Software Engineer, starts 2026-04-01, manager: Bob Chen (EMP-045). Run employee-onboarding skill.",
    "deliver": false
  }'
```

### Token

The webhook token is stored in `~/.openclaw/.env` as `WEBHOOK_TOKEN`. It is distinct from the gateway dashboard token.

---

## Key Configuration Files

| File | Purpose |
|---|---|
| `~/.openclaw/openclaw.json` | Main gateway + agent + tools config |
| `~/.openclaw/.env` | All secrets: API keys, webhook tokens, HRIS URL |
| `~/.openclaw/.env.template` | Template for `.env` — copy and fill in |
| `~/.openclaw/workspace-hr/SOUL.md` | HR agent persona and ethical boundaries |
| `~/.openclaw/workspace-hr/AGENTS.md` | Operating instructions and escalation rules |
| `~/.openclaw/workspace-hr/TOOLS.md` | Tool documentation injected into system prompt |
| `~/.openclaw/workspace-hr/USER.md` | Company context (name, org structure, etc.) |
| `~/.openclaw/workspace-hr/MEMORY.md` | Durable facts: policies, org, key contacts |
| `~/.openclaw/workspace-hr/HEARTBEAT.md` | Periodic proactive checks (every 30 min) |
| `~/.openclaw/workspace-hr/policies/` | Company policy documents (leave, benefits, CoC, etc.) |
| `~/.openclaw/workspace-hr/skills/` | All 6 skill directories |
| `~/.openclaw/setup-crons.sh` | Registers all scheduled cron jobs |
| `~/.openclaw/QUICKSTART.md` | Condensed startup reference |
| `/tmp/openclaw-gateway.log` | Gateway log (background mode) |

### Config key notes

- `gateway.mode` must be `"local"` or the gateway will refuse to start
- `tools.allow` should **not** be set — it acts as a global allowlist and blocks coding-profile tools
- `tools.profile: "coding"` with `tools.deny: ["group:ui"]` is the correct setup
- Config is hot-reloaded; run `openclaw doctor` after any changes

---

## Go-Live Checklist

Before connecting to production channels, complete these steps:

- [ ] **1. Set `ANTHROPIC_API_KEY`** in `~/.openclaw/.env` — the agent cannot run without it
- [ ] **2. Fill policy placeholders** — replace all `[X]` markers in the 5 policy docs under `workspace-hr/policies/`
- [ ] **3. Update `USER.md`** — add real company name, org structure, key contacts
- [ ] **4. Replace placeholder tokens** — update gateway token and webhook token in `openclaw.json` and `.env` with cryptographically random values
- [ ] **5. Register cron jobs** — run `~/.openclaw/setup-crons.sh` to activate scheduled reports
- [ ] **6. Connect channels** — run `openclaw connect slack` and/or `openclaw connect teams` and complete the OAuth flow

---

## Troubleshooting

### Rate limits (Gemini free tier)

Gemini 2.5 Flash free tier hits RPM limits quickly during bursts. If you see `429 Too Many Requests`:
- Wait 1–2 minutes between test bursts
- For production, use a paid Gemini API tier or switch to `anthropic/claude-haiku-4-5` for high-volume interactions

### Missing `ANTHROPIC_API_KEY`

```
Error: ANTHROPIC_API_KEY is not set
```

Add to `~/.openclaw/.env`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

Then `source ~/.openclaw/.env` before starting the gateway.

### Gateway auth errors (401)

Ensure the `Authorization: Bearer` token in your curl/webhook matches exactly what is in `openclaw.json` → `gateway.auth.token`. Tokens are case-sensitive.

### Node version errors

```
Error: Requires Node.js >= 22.12.0
```

```bash
source ~/.nvm/nvm.sh
nvm use 22
node --version   # should be v22.x.x
```

Add `source ~/.nvm/nvm.sh && nvm use 22 --silent` to `~/.bashrc` to activate automatically.

### Only `cron` tool available (all other tools missing)

This is caused by setting `tools.allow` in `openclaw.json`. Remove the `tools.allow` key entirely — the `coding` profile already grants the correct tools. `tools.allow` acts as a global override allowlist and will block everything not explicitly listed.

### Gateway won't start (`port in use`)

```bash
lsof -i :18789        # find the process
kill <PID>            # stop it
openclaw gateway --force   # restart
```

### Skills not found

```bash
openclaw skills list   # verify all 6 skills are registered
```

If missing, check that each skill directory contains a valid `SKILL.md` with the correct frontmatter `name` field.

---

## Project Structure

Actual deployed file tree (as of 2026-03-01):

```
~/.openclaw/
├── openclaw.json                          ← Main config (gateway, agents, tools, hooks)
├── openclaw.json.bak                      ← Auto-backup on each config write
├── .env                                   ← Secrets: API keys, tokens, HRIS URL
├── .env.template                          ← Copy this to create .env
├── QUICKSTART.md                          ← Condensed startup reference
├── setup-crons.sh                         ← Registers all cron jobs
├── cron/
│   └── jobs.json                          ← Active cron job definitions
├── agents/
│   ├── main/sessions/                     ← Conversation history for main agent
│   ├── hr-employee-bot/sessions/          ← Conversation history (employee sessions)
│   └── hr-manager-bot/sessions/           ← Conversation history (manager sessions)
├── logs/
│   └── config-audit.jsonl                 ← Audit log of config changes
├── memory/
│   └── main.sqlite                        ← Agent long-term memory (SQLite)
│
├── workspace-hr/                          ← Main HR agent workspace
│   ├── SOUL.md                            ← HR persona, ethics, tone, boundaries
│   ├── AGENTS.md                          ← Operating instructions, escalation rules
│   ├── TOOLS.md                           ← Tool documentation for agent
│   ├── USER.md                            ← Company context (fill in real values)
│   ├── MEMORY.md                          ← Durable facts: org structure, key contacts
│   ├── HEARTBEAT.md                       ← Periodic proactive checks (every 30 min)
│   ├── IDENTITY.md                        ← Branding ("HRBot by [Company]")
│   ├── policies/
│   │   ├── leave-policy.md
│   │   ├── benefits.md
│   │   ├── code-of-conduct.md
│   │   ├── remote-work-policy.md
│   │   └── expense-policy.md
│   └── skills/
│       ├── leave-request-processor/
│       │   ├── SKILL.md
│       │   └── scripts/
│       │       ├── submit-leave.sh
│       │       ├── check-leave-balance.sh
│       │       └── check-leave-status.sh
│       ├── employee-data-lookup/
│       │   ├── SKILL.md
│       │   └── scripts/
│       │       ├── lookup-employee.sh
│       │       └── lookup-team.sh
│       ├── hr-policy-qa/
│       │   ├── SKILL.md
│       │   └── references/
│       │       └── policy-index.md
│       ├── employee-onboarding/
│       │   ├── SKILL.md
│       │   └── scripts/
│       │       ├── trigger-onboarding.sh
│       │       └── notify-slack-welcome.sh
│       ├── attendance-tracker/
│       │   ├── SKILL.md
│       │   └── scripts/
│       │       ├── get-attendance.sh
│       │       └── get-team-attendance.sh
│       └── scheduled-hr-report/
│           ├── SKILL.md
│           └── scripts/
│               └── weekly-stats.sh
│
├── workspace-hr-employee/                 ← Employee self-service agent
│   ├── SOUL.md
│   ├── AGENTS.md
│   ├── TOOLS.md
│   ├── USER.md
│   ├── HEARTBEAT.md
│   └── IDENTITY.md
│
└── workspace-hr-manager/                  ← Manager approvals + escalation agent
    ├── SOUL.md
    └── AGENTS.md
```

> **Note:** Skills are defined in `workspace-hr` and shared via OpenClaw's skill routing. The employee and manager workspaces contain only agent-specific persona/instruction files.

---

*Built on [OpenClaw](https://github.com/openclaw/openclaw) · Model: google/gemini-2.5-flash · Gateway: ws://127.0.0.1:18789*
