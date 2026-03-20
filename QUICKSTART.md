# HR AI Agent — Quickstart Guide

## Prerequisites
- Node.js ≥ 22
- macOS / Linux (or Windows WSL2)
- Anthropic API key (Pro/Max recommended for Claude Opus 4.6)

---

## Step 1: Install OpenClaw

```bash
npm install -g openclaw@latest
openclaw onboard --install-daemon
```

---

## Step 2: Set Environment Variables

```bash
cp .env.template ~/.openclaw/.env
# Edit .env and fill in all values
source ~/.openclaw/.env
```

Add to your shell profile so vars persist across sessions:
```bash
echo 'source ~/.openclaw/.env' >> ~/.bashrc  # or ~/.zshrc
```

---

## Step 3: Update Placeholder Content

Before going live, edit these files with your real company data:

| File | What to fill in |
|------|----------------|
| `workspace-hr/USER.md` | Company name, HR team, systems, org structure |
| `workspace-hr/MEMORY.md` | Real leave allowances, key contacts |
| `workspace-hr/IDENTITY.md` | Your company name, HR email |
| `policies/*.md` | Replace all `[X]` placeholders with real policy values |
| `openclaw.json` | Replace token placeholders with real random tokens |

---

## Step 4: Register Cron Jobs

```bash
./setup-crons.sh
```

---

## Step 5: Connect Messaging Channels

```bash
# Slack
openclaw connect slack

# Microsoft Teams
openclaw connect teams

# Telegram
openclaw connect telegram
```

---

## Step 6: Test the Agent

```bash
# Verify gateway is running
curl http://127.0.0.1:18789/health

# Test policy Q&A
openclaw agent --message "What is our vacation policy?"

# Test leave request flow
openclaw agent --message "I want to take vacation March 20-22"

# Test employee lookup
openclaw agent --message "What department is Jane Smith in?"

# Test webhook
curl -X POST http://localhost:18789/hooks/agent \
  -H "Authorization: Bearer ${OPENCLAW_WEBHOOK_SECRET}" \
  -H "Content-Type: application/json" \
  -d '{"agentId":"main","message":"Run a test of the leave request skill for employee EMP-001"}'

# Security audit
openclaw security audit
```

---

## Agent Architecture

```
Employees (Slack / Teams / Telegram)
          │
          ▼
  ┌──────────────────┐
  │  OpenClaw Gateway │  ws://127.0.0.1:18789
  └──────────────────┘
          │
    ┌─────┴──────────┐
    │                │
    ▼                ▼
hr-employee-bot   hr-manager-bot
(self-service)    (approvals + escalations)
```

## What Employees Can Ask

| Employee Says | HR Bot Does |
|---|---|
| "I need 3 days off next week" | Checks balance → confirms → submits |
| "What's our parental leave policy?" | Reads policy doc → summarizes |
| "How many vacation days do I have left?" | Queries HRIS → reports balance |
| "I need bereavement leave" | Empathetic response + routes to HR Manager |
| "I just joined. What do I need to do?" | Runs onboarding checklist |
| "Can I work remotely full time?" | Quotes remote work policy |
