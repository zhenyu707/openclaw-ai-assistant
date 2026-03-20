# Multi-Department AI Agents · OpenClaw

> A self-hosted, multi-agent AI assistant platform covering **6 departments** — HR, Accounting, Marketing, Operations, Competitive Intelligence, and Inventory Management — running entirely on your infrastructure.

---

## What Is This?

This project deploys a production-grade **multi-department AI agent system** on [OpenClaw](https://github.com/openclaw/openclaw) — an open-source, self-hosted AI assistant platform. Each department has its own trio of agents (main coordinator + user-facing bot + manager bot) with specialized skills, integrating with your enterprise systems, messaging channels (Slack/Teams), and internal documents to give employees instant, private support without any data leaving your network.

**Departments covered:**

| Department | Emoji | Focus |
|---|---|---|
| HR | 🤝 | Leave requests, policy Q&A, onboarding, attendance, scheduled reports |
| Accounting | 💰 | Expense approvals, invoice processing, budget tracking, financial reports |
| Marketing | 📣 | Campaign management, content calendar, analytics, brand guidelines |
| Operations | ⚙️ | Workflow automation, resource allocation, SLA tracking, incident response |
| Competitor Analysis | 🔍 | Market research, competitor tracking, pricing intelligence, SWOT analysis |
| Inventory | 📦 | Stock levels, reorder alerts, warehouse management, supply chain tracking |

---

## Architecture

```
Users (Slack / Teams / Telegram / DM)
            │
            ▼
  ┌─────────────────────┐
  │   OpenClaw Gateway   │   ws://127.0.0.1:18789
  │   (control plane)    │   auth: token
  └─────────────────────┘
            │
  ┌─────────┼─────────────────────────────────────────────┐
  │         │         │         │         │               │
  ▼         ▼         ▼         ▼         ▼               ▼
 HR 🤝   Acctg 💰  Mktg 📣  Ops ⚙️   Comp 🔍        Inv 📦
  │         │         │         │         │               │
  ├─User    ├─User    ├─User    ├─User    ├─User          ├─User
  └─Mgr     └─Mgr     └─Mgr     └─Mgr    └─Mgr           └─Mgr
```

**Total agents: 18 (6 departments × 3 agents each)**

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
nvm use 22 --silent
openclaw gateway start

# 3. Open the dashboard
# Navigate to: http://127.0.0.1:18789/?token=<YOUR_GATEWAY_TOKEN>

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
nvm use 22 --silent
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
- Monitor active agent sessions across all 6 departments
- View conversation history
- Inspect skill invocations and tool calls
- Trigger manual agent messages
- Review gateway logs in real time

---

## Get Started Tour

The dashboard includes an iOS-inspired onboarding tour with a **department picker** that lets new users choose which department to explore first.

**How it works:**

- **Auto-opens** on first visit when you navigate to `http://127.0.0.1:18789/?token=<token>`
- **Department picker** lets you select any of the 6 departments to see relevant example prompts
- **Guided steps** walk through core tasks for the selected department
- **"Try it" buttons** pre-fill the chat input with example prompts — just press Enter
- **"?" button** (top-right corner) re-opens the tour anytime
- **Token persistence** — the `?token=` URL parameter is saved to `localStorage` so you don't need to re-enter it
- **Mobile-friendly** — responsive layout works on screens 375px and up

### Customizing the Tour

Edit `control-ui-custom/tour.js` to modify steps, prompts, or behavior. The tour uses a versioned localStorage key (`TOUR_VERSION`), so bumping the version will re-trigger the tour for all users.

The tour CSS is in `control-ui-custom/tour.css` — theming uses CSS custom properties (`--oc-tour-accent`, `--oc-tour-surface`, etc.).

---

## Agents

### HR 🤝

| Agent ID | Workspace | Role |
|---|---|---|
| `main` | `workspace-hr` | Primary HR agent — routes all employee requests |
| `hr-employee-bot` | `workspace-hr-employee` | Employee self-service (leave, lookup, policy, onboarding) |
| `hr-manager-bot` | `workspace-hr-manager` | Manager approvals, escalations, compliance reports |

**Skills:** leave-request-processor, employee-data-lookup, hr-policy-qa, employee-onboarding, attendance-tracker, scheduled-hr-report

### Accounting 💰

| Agent ID | Workspace | Role |
|---|---|---|
| `acctg-main` | `workspace-accounting` | Primary accounting agent — routes financial requests |
| `acctg-employee-bot` | `workspace-accounting-user` | Employee self-service (expenses, invoices, budget queries) |
| `acctg-manager-bot` | `workspace-accounting-manager` | Manager approvals, budget oversight, financial reporting |

**Skills:** expense-processor, invoice-manager, budget-tracker, financial-report, receipt-scanner

### Marketing 📣

| Agent ID | Workspace | Role |
|---|---|---|
| `mktg-main` | `workspace-marketing` | Primary marketing agent — routes campaign requests |
| `mktg-employee-bot` | `workspace-marketing-user` | Self-service (content calendar, analytics, brand assets) |
| `mktg-manager-bot` | `workspace-marketing-manager` | Campaign approvals, budget allocation, performance reviews |

**Skills:** campaign-manager, content-calendar, analytics-reporter, brand-guidelines-qa, social-scheduler

### Operations ⚙️

| Agent ID | Workspace | Role |
|---|---|---|
| `ops-main` | `workspace-operations` | Primary operations agent — routes workflow requests |
| `ops-employee-bot` | `workspace-operations-user` | Self-service (task tracking, resource requests, SLA queries) |
| `ops-manager-bot` | `workspace-operations-manager` | Escalations, resource allocation, incident management |

**Skills:** workflow-automator, resource-allocator, sla-tracker, incident-responder, ops-report

### Competitor Analysis 🔍

| Agent ID | Workspace | Role |
|---|---|---|
| `comp-main` | `workspace-competitor-analysis` | Primary competitive intel agent — routes research requests |
| `comp-analyst-bot` | `workspace-competitor-analysis-user` | Analyst self-service (market data, competitor profiles, pricing) |
| `comp-manager-bot` | `workspace-competitor-analysis-manager` | Strategic briefings, SWOT reviews, executive summaries |

**Skills:** competitor-tracker, market-researcher, pricing-intel, swot-analyzer, comp-report

### Inventory 📦

| Agent ID | Workspace | Role |
|---|---|---|
| `inv-main` | `workspace-inventory` | Primary inventory agent — routes stock and supply requests |
| `inv-employee-bot` | `workspace-inventory-user` | Self-service (stock checks, reorder requests, receiving) |
| `inv-manager-bot` | `workspace-inventory-manager` | Reorder approvals, warehouse oversight, supply chain reports |

**Skills:** stock-level-monitor, reorder-manager, warehouse-tracker, supply-chain-analyzer, inv-report

All 18 agents share the model `google/gemini-2.5-flash` and communicate via OpenClaw's internal agent-to-agent routing.

---

## Skills

Six HR skills are deployed in `workspace-hr/skills/`:

| Skill | Description |
|---|---|
| `leave-request-processor` | Submit, validate, and track employee leave requests via HRIS. Enforces minimum notice, blackout dates, and balance checks. Requires explicit employee confirmation before API submission. |
| `employee-data-lookup` | Safely retrieve employee info (name, department, title, manager, hire date). Strips all sensitive fields (salary, SSN, health data). Writes a full audit log entry on every lookup. |
| `hr-policy-qa` | Answer HR policy questions by reading authoritative policy docs in `workspace-hr/policies/`. Cites source document and section for every answer. |
| `employee-onboarding` | Automate new-hire workflow: create HRIS record → provision IT → send welcome email → schedule orientation → add to Slack channels → set 30-day check-in cron. |
| `attendance-tracker` | Query leave balances and time-off records. Generates team attendance summaries for managers and flags anomalies (3+ unplanned absences in 30 days). |
| `scheduled-hr-report` | Generate daily/weekly HR summaries (new hires, exits, leave taken, open positions, onboarding status) and post to Slack or Teams. |

Each additional department follows the same pattern with its own skill set (see [Agents](#agents) above for per-department skill lists).

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
cd workspace-hr
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

The webhook token is stored in your `.env` file (see `.env.template`). It is distinct from the gateway dashboard token.

---

## Key Configuration Files

| File | Purpose |
|---|---|
| `$OPENCLAW_HOME/openclaw.json` | Main gateway + agent + tools config (runtime, not in git) |
| `$OPENCLAW_HOME/.env` | All secrets: API keys, webhook tokens, HRIS URL (never commit) |
| `.env.template` | Template for `.env` — copy to `$OPENCLAW_HOME/.env` and fill in |
| `workspace-hr/SOUL.md` | HR agent persona, ethics, tone, boundaries |
| `workspace-hr/AGENTS.md` | Operating instructions and escalation rules |
| `workspace-hr/TOOLS.md` | Tool documentation injected into system prompt |
| `workspace-hr/USER.md` | Company context (fill in real values) |
| `workspace-hr/MEMORY.md` | Durable facts: org structure, key contacts |
| `workspace-hr/HEARTBEAT.md` | Periodic proactive checks (every 30 min) |
| `workspace-hr/policies/` | Company policy documents (leave, benefits, CoC, etc.) |
| `workspace-hr/skills/` | All 6 HR skill directories |
| `setup-crons.sh` | Registers all scheduled cron jobs |
| `QUICKSTART.md` | Condensed startup reference |
| `/tmp/openclaw-gateway.log` | Gateway log (background mode), configurable |

### Config key notes

- `gateway.mode` must be `"local"` or the gateway will refuse to start
- `tools.allow` should **not** be set — it acts as a global allowlist and blocks coding-profile tools
- `tools.profile: "coding"` with `tools.deny: ["group:ui"]` is the correct setup
- Config is hot-reloaded; run `openclaw doctor` after any changes

---

## Go-Live Checklist

Before connecting to production channels, complete these steps:

- [ ] **1. Set `ANTHROPIC_API_KEY`** in `$OPENCLAW_HOME/.env` — the agent cannot run without it
- [ ] **2. Fill policy placeholders** — replace all `[X]` markers in the policy docs under each department's `policies/` directory
- [ ] **3. Update `USER.md`** — add real company name, org structure, key contacts in each workspace
- [ ] **4. Replace placeholder tokens** — update gateway token and webhook token in `openclaw.json` and `.env` with cryptographically random values
- [ ] **5. Create workspace symlinks** — symlink all `workspace-*` directories into `$OPENCLAW_HOME/` (see [OpenClaw Configuration](#openclaw-configuration-openclawjson) below)
- [ ] **6. Register all agents** — add all 18 agents to `agents.list` in `$OPENCLAW_HOME/openclaw.json` and set `allowedAgentIds`
- [ ] **7. Register cron jobs** — run `./setup-crons.sh` (from this repo root) to activate scheduled reports for all departments
- [ ] **8. Connect channels** — run `openclaw connect slack` and/or `openclaw connect teams` and complete the OAuth flow

---

## Troubleshooting

### Rate limits (Gemini free tier)

Gemini 2.5 Flash free tier hits RPM limits quickly during bursts. If you see `429 Too Many Requests`:
- Wait 1-2 minutes between test bursts
- For production, use a paid Gemini API tier or switch to `anthropic/claude-haiku-4-5` for high-volume interactions

### Missing `ANTHROPIC_API_KEY`

```
Error: ANTHROPIC_API_KEY is not set
```

Add to `$OPENCLAW_HOME/.env`:

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
openclaw skills list   # verify all skills are registered
```

If missing, check that each skill directory contains a valid `SKILL.md` with the correct frontmatter `name` field.

---

## Project Structure

Source files live in this git repo. The OpenClaw runtime home (`$OPENCLAW_HOME`) holds symlinks to the workspace directories here, plus its own runtime state.

```
<repo-root>/                            ← THIS REPO (version-controlled)
├── .env.template                       ← Copy to $OPENCLAW_HOME/.env and fill in secrets
├── setup-crons.sh                      ← Registers all scheduled cron jobs
├── QUICKSTART.md                       ← Condensed startup reference
├── README.md
├── control-ui-custom/                  ← Custom dashboard UI overlays
│   ├── tour.js                         ← Get Started tour (department picker)
│   └── tour.css                        ← Tour styling (iOS-inspired cards)
│
├── workspace-hr/                       ← 🤝 HR department workspace
│   ├── SOUL.md / AGENTS.md / TOOLS.md / USER.md / MEMORY.md / HEARTBEAT.md / IDENTITY.md
│   ├── policies/                       ← leave-policy, benefits, CoC, remote-work, expense
│   └── skills/                         ← 6 skills (leave, lookup, policy-qa, onboarding, attendance, report)
│
├── workspace-hr-employee/              ← HR employee self-service agent
├── workspace-hr-manager/               ← HR manager approvals + escalation agent
│
├── workspace-accounting/                    ← 💰 Accounting department workspace
├── workspace-accounting-user/           ← Accounting employee agent
├── workspace-accounting-manager/            ← Accounting manager agent
│
├── workspace-marketing/                     ← 📣 Marketing department workspace
├── workspace-marketing-user/            ← Marketing employee agent
├── workspace-marketing-manager/             ← Marketing manager agent
│
├── workspace-operations/                      ← ⚙️ Operations department workspace
├── workspace-operations-user/             ← Operations employee agent
├── workspace-operations-manager/              ← Operations manager agent
│
├── workspace-competitor-analysis/       ← 🔍 Competitive intelligence workspace
├── workspace-competitor-analysis-user/             ← Competitor analysis analyst agent
├── workspace-competitor-analysis-manager/             ← Competitive intel manager agent
│
├── workspace-inventory/                      ← 📦 Inventory management workspace
├── workspace-inventory-user/             ← Inventory employee agent
└── workspace-inventory-manager/              ← Inventory manager agent

$OPENCLAW_HOME/                         ← Shared OpenClaw runtime (NOT in git)
├── openclaw.json                       ← Global config: gateway, agents, tools, hooks
├── .env                                ← All secrets for all projects (never commit)
├── workspace-hr -> <repo-root>/workspace-hr                    (symlink)
├── workspace-hr-employee -> <repo-root>/workspace-hr-employee  (symlink)
├── workspace-hr-manager -> <repo-root>/workspace-hr-manager    (symlink)
├── workspace-accounting -> <repo-root>/workspace-accounting              (symlink)
├── workspace-accounting-user -> ...                             (symlink)
├── workspace-accounting-manager -> ...                              (symlink)
├── workspace-marketing -> ...                                       (symlink)
├── workspace-marketing-user -> ...                              (symlink)
├── workspace-marketing-manager -> ...                               (symlink)
├── workspace-operations -> ...                                        (symlink)
├── workspace-operations-user -> ...                               (symlink)
├── workspace-operations-manager -> ...                                (symlink)
├── workspace-competitor-analysis -> ...                         (symlink)
├── workspace-competitor-analysis-user -> ...                               (symlink)
├── workspace-competitor-analysis-manager -> ...                               (symlink)
├── workspace-inventory -> ...                                        (symlink)
├── workspace-inventory-user -> ...                               (symlink)
├── workspace-inventory-manager -> ...                                (symlink)
├── agents/                             ← Runtime: session history (OpenClaw-managed)
├── memory/                             ← Runtime: SQLite databases (OpenClaw-managed)
├── cron/                               ← Runtime: cron job registry
└── logs/                               ← Runtime: audit logs
```

> **Setup pattern for future OpenClaw projects:** create a new git repo, put workspace files there, then symlink `workspace-*` directories into `$OPENCLAW_HOME/`. Each project is isolated and version-controlled; `$OPENCLAW_HOME/` is the shared runtime engine.

> **Skills** are defined in the main department workspace (e.g., `workspace-hr`) and shared via OpenClaw's skill routing. The employee and manager workspaces contain only agent-specific persona/instruction files.

---

## OpenClaw Configuration (openclaw.json)

### Workspace symlinks

Create symlinks from your repo workspaces into the OpenClaw runtime home:

```bash
# HR department
ln -s "$(pwd)/workspace-hr" ~/.openclaw/workspace-hr
ln -s "$(pwd)/workspace-hr-employee" ~/.openclaw/workspace-hr-employee
ln -s "$(pwd)/workspace-hr-manager" ~/.openclaw/workspace-hr-manager

# Accounting department
ln -s "$(pwd)/workspace-accounting" ~/.openclaw/workspace-accounting
ln -s "$(pwd)/workspace-accounting-user" ~/.openclaw/workspace-accounting-user
ln -s "$(pwd)/workspace-accounting-manager" ~/.openclaw/workspace-accounting-manager

# Marketing department
ln -s "$(pwd)/workspace-marketing" ~/.openclaw/workspace-marketing
ln -s "$(pwd)/workspace-marketing-user" ~/.openclaw/workspace-marketing-user
ln -s "$(pwd)/workspace-marketing-manager" ~/.openclaw/workspace-marketing-manager

# Operations department
ln -s "$(pwd)/workspace-operations" ~/.openclaw/workspace-operations
ln -s "$(pwd)/workspace-operations-user" ~/.openclaw/workspace-operations-user
ln -s "$(pwd)/workspace-operations-manager" ~/.openclaw/workspace-operations-manager

# Competitive intelligence department
ln -s "$(pwd)/workspace-competitor-analysis" ~/.openclaw/workspace-competitor-analysis
ln -s "$(pwd)/workspace-competitor-analysis-user" ~/.openclaw/workspace-competitor-analysis-user
ln -s "$(pwd)/workspace-competitor-analysis-manager" ~/.openclaw/workspace-competitor-analysis-manager

# Inventory department
ln -s "$(pwd)/workspace-inventory" ~/.openclaw/workspace-inventory
ln -s "$(pwd)/workspace-inventory-user" ~/.openclaw/workspace-inventory-user
ln -s "$(pwd)/workspace-inventory-manager" ~/.openclaw/workspace-inventory-manager
```

### agents.list configuration

Add all 18 agents to `$OPENCLAW_HOME/openclaw.json` under `agents.list`:

```json
{
  "agents": {
    "defaults": {
      "model": { "primary": "google/gemini-2.5-flash" }
    },
    "list": [
      { "id": "main", "workspace": "workspace-hr" },
      { "id": "hr-employee-bot", "workspace": "workspace-hr-employee" },
      { "id": "hr-manager-bot", "workspace": "workspace-hr-manager" },
      { "id": "acctg-main", "workspace": "workspace-accounting" },
      { "id": "acctg-employee-bot", "workspace": "workspace-accounting-user" },
      { "id": "acctg-manager-bot", "workspace": "workspace-accounting-manager" },
      { "id": "mktg-main", "workspace": "workspace-marketing" },
      { "id": "mktg-employee-bot", "workspace": "workspace-marketing-user" },
      { "id": "mktg-manager-bot", "workspace": "workspace-marketing-manager" },
      { "id": "ops-main", "workspace": "workspace-operations" },
      { "id": "ops-employee-bot", "workspace": "workspace-operations-user" },
      { "id": "ops-manager-bot", "workspace": "workspace-operations-manager" },
      { "id": "comp-main", "workspace": "workspace-competitor-analysis" },
      { "id": "comp-analyst-bot", "workspace": "workspace-competitor-analysis-user" },
      { "id": "comp-manager-bot", "workspace": "workspace-competitor-analysis-manager" },
      { "id": "inv-main", "workspace": "workspace-inventory" },
      { "id": "inv-employee-bot", "workspace": "workspace-inventory-user" },
      { "id": "inv-manager-bot", "workspace": "workspace-inventory-manager" }
    ]
  }
}
```

### allowedAgentIds

Set `allowedAgentIds` in the gateway config to restrict which agents can be triggered via webhooks:

```json
{
  "hooks": {
    "allowedAgentIds": [
      "main", "hr-employee-bot", "hr-manager-bot",
      "acctg-main", "acctg-employee-bot", "acctg-manager-bot",
      "mktg-main", "mktg-employee-bot", "mktg-manager-bot",
      "ops-main", "ops-employee-bot", "ops-manager-bot",
      "comp-main", "comp-analyst-bot", "comp-manager-bot",
      "inv-main", "inv-employee-bot", "inv-manager-bot"
    ]
  }
}
```

### Verify configuration

```bash
openclaw doctor          # validate config
openclaw doctor --fix    # auto-repair common issues
openclaw skills list     # verify all skills are registered
openclaw status          # check gateway and agent status
```

---

*Built on [OpenClaw](https://github.com/openclaw/openclaw) · 6 departments · 18 agents · 31 skills · Model: google/gemini-2.5-flash*
