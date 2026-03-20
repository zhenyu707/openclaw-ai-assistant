const TOUR_VERSION = '2026-03-20-v5';
const STATE_KEY = `openclaw.getStarted.${TOUR_VERSION}`;
const SETTINGS_KEY = 'openclaw.control.settings.v1';
const OPEN_DELAY_MS = 900;

const departments = [
  {
    id: 'hr',
    icon: '🤝',
    label: 'HR',
    desc: 'Leave, employees, policies',
    color: '#14b8a6',
    agentId: 'main',
    steps: [
      { title: 'Ask About Leave', subtitle: 'Check balances, submit requests, or ask about leave policies.', tryPrompt: 'What is the leave balance for EMP-001?' },
      { title: 'Look Up Employees', subtitle: 'Find employee details, team rosters, or reporting chains.', tryPrompt: 'Look up employee EMP-001' },
      { title: 'Get HR Reports', subtitle: 'Weekly stats, attendance summaries, and onboarding status.', tryPrompt: 'Show me the weekly HR stats' },
    ],
  },
  {
    id: 'accounting',
    icon: '💰',
    label: 'Accounting',
    desc: 'Expenses, budgets, invoices',
    color: '#f59e0b',
    agentId: 'acctg-main',
    steps: [
      { title: 'Track Expenses', subtitle: 'Submit expense claims, check status, or review policy limits.', tryPrompt: 'Submit an expense claim for $150 lunch meeting' },
      { title: 'Budget Reports', subtitle: 'Get department budget vs actual, variance analysis.', tryPrompt: 'Show me the Q1 budget report' },
    ],
  },
  {
    id: 'marketing',
    icon: '📣',
    label: 'Marketing',
    desc: 'Campaigns, content, analytics',
    color: '#ec4899',
    agentId: 'mktg-main',
    steps: [
      { title: 'Campaign Status', subtitle: 'Check active campaigns, deadlines, and performance KPIs.', tryPrompt: 'What campaigns are running this month?' },
      { title: 'Content Calendar', subtitle: 'View upcoming content schedule across all channels.', tryPrompt: 'Show me the content calendar for this week' },
    ],
  },
  {
    id: 'operations',
    icon: '⚙️',
    label: 'Operations',
    desc: 'Tasks, facilities, workflows',
    color: '#8b5cf6',
    agentId: 'ops-main',
    steps: [
      { title: 'Track Tasks', subtitle: 'Check task assignments, deadlines, and operational workflows.', tryPrompt: 'Show me open tasks assigned to my team' },
      { title: 'Facility Requests', subtitle: 'Submit maintenance requests or check vendor SLAs.', tryPrompt: 'Submit a facility request for broken AC in room 301' },
    ],
  },
  {
    id: 'competitor-analysis',
    icon: '🔍',
    label: 'Competitors',
    desc: 'Profiles, trends, intel',
    color: '#06b6d4',
    agentId: 'comp-main',
    steps: [
      { title: 'Competitor Profiles', subtitle: 'Look up competitor products, pricing, and market position.', tryPrompt: 'Show me the competitor profile for Acme Corp' },
      { title: 'Market Trends', subtitle: 'Get industry trend summaries and competitive landscape reports.', tryPrompt: 'What are the top market trends this quarter?' },
    ],
  },
  {
    id: 'inventory',
    icon: '📦',
    label: 'Inventory',
    desc: 'Stock, orders, receiving',
    color: '#22c55e',
    agentId: 'inv-main',
    steps: [
      { title: 'Check Stock Levels', subtitle: 'Query current inventory, low-stock alerts, and reorder status.', tryPrompt: 'What items are below reorder threshold?' },
      { title: 'Track Orders', subtitle: 'Check purchase order status, delivery ETAs, and receiving logs.', tryPrompt: 'Show me the status of PO-2026-0312' },
    ],
  },
];

const state = { view: 'welcome', deptIndex: 0, stepIndex: 0, overlay: null, button: null, initialized: false, open: false };

function loadTourState() { try { return JSON.parse(localStorage.getItem(STATE_KEY) || '{}'); } catch { return {}; } }
function saveTourState(next) { localStorage.setItem(STATE_KEY, JSON.stringify({ ...loadTourState(), ...next })); }
function appRoot() { const host = document.querySelector('openclaw-app'); return host?.shadowRoot || host || document.body || null; }

function getExploredDepts() { return loadTourState().exploredDepts || []; }
function markDeptExplored(deptId) {
  const explored = getExploredDepts();
  if (!explored.includes(deptId)) { explored.push(deptId); saveTourState({ exploredDepts: explored }); }
}

function switchToAgent(agentId) {
  const sessionKey = `agent:${agentId}:main`;
  try {
    const raw = localStorage.getItem(SETTINGS_KEY);
    if (raw) {
      const settings = JSON.parse(raw);
      settings.sessionKey = sessionKey;
      settings.lastActiveSessionKey = sessionKey;
      localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
    }
  } catch (_) { /* best effort */ }
}

function showToast(message) {
  const existing = document.getElementById('oc-tour-toast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.id = 'oc-tour-toast';
  toast.textContent = message;
  document.body.appendChild(toast);
  requestAnimationFrame(() => { toast.dataset.visible = 'true'; });
  setTimeout(() => {
    toast.dataset.visible = 'false';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

function tryPrompt(text, agentId) {
  closeTour();
  if (agentId) switchToAgent(agentId);
  setTimeout(() => {
    const r = appRoot();
    const input = r?.querySelector('textarea, [contenteditable], input[type="text"]');
    if (input) {
      if (input.hasAttribute('contenteditable')) {
        input.textContent = text;
      } else {
        const nativeSetter = Object.getOwnPropertyDescriptor(
          input.tagName === 'TEXTAREA' ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype,
          'value'
        )?.set;
        if (nativeSetter) nativeSetter.call(input, text);
        else input.value = text;
      }
      input.dispatchEvent(new Event('input', { bubbles: true }));
      input.focus();
    }
    showToast('Prompt loaded \u2014 press Enter to send');
  }, 400);
}

function closeTour({ completed = false } = {}) {
  state.open = false;
  if (state.overlay) state.overlay.dataset.open = 'false';
  saveTourState({ seen: true, completed: completed || !!loadTourState().completed });
}

function openTour({ resetToStart = false } = {}) {
  if (!state.overlay) return;
  if (resetToStart) { state.view = 'welcome'; state.deptIndex = 0; state.stepIndex = 0; }
  state.open = true;
  state.overlay.dataset.open = 'true';
  render();
}

function render() {
  const dialog = state.overlay?.querySelector('#oc-tour-dialog');
  if (!dialog) return;
  switch (state.view) {
    case 'welcome': renderWelcome(dialog); break;
    case 'picker': renderPicker(dialog); break;
    case 'dept': renderDept(dialog); break;
    case 'done': renderDone(dialog); break;
  }
  manageFocus(dialog);
}

function manageFocus(dialog) {
  requestAnimationFrame(() => {
    const primary = dialog.querySelector('.oc-tour-btn--primary, .oc-tour-dept-card');
    if (primary) primary.focus();
  });
}

function renderWelcome(dialog) {
  const deptNames = departments.map(d => d.label).join(', ');
  dialog.innerHTML = `
    <div id="oc-tour-icon">👋</div>
    <h2 id="oc-tour-step-title">Your AI Assistants Are Ready</h2>
    <p id="oc-tour-step-subtitle"><strong>${departments.length} departments</strong> are set up and waiting: ${deptNames}. Each one can answer questions, run tasks, and generate reports.</p>
    <div id="oc-tour-actions">
      <button class="oc-tour-btn oc-tour-btn--primary" id="oc-tour-explore" type="button">Explore Departments</button>
    </div>
    <button class="oc-tour-btn--skip" id="oc-tour-skip" type="button">Skip tour</button>`;
  dialog.querySelector('#oc-tour-explore').addEventListener('click', () => { state.view = 'picker'; render(); });
  dialog.querySelector('#oc-tour-skip').addEventListener('click', () => closeTour());
}

function renderPicker(dialog) {
  const explored = getExploredDepts();
  const cards = departments.map((dept, i) => {
    const done = explored.includes(dept.id);
    return `<button class="oc-tour-dept-card${done ? ' oc-tour-dept-card--done' : ''}" data-dept="${i}" style="--dept-color:${dept.color}" tabindex="0">
      <span class="oc-tour-dept-icon">${dept.icon}</span>
      <span class="oc-tour-dept-label">${dept.label}</span>
      <span class="oc-tour-dept-desc">${dept.desc}</span>
      <span class="oc-tour-dept-agents">${dept.steps.length} topics</span>
      ${done ? '<span class="oc-tour-dept-check">✓</span>' : ''}
    </button>`;
  }).join('');

  dialog.innerHTML = `
    <h2 id="oc-tour-step-title">Choose a Department</h2>
    <p id="oc-tour-step-subtitle">Tap a department to see what it can do. Explore as many as you like.</p>
    <div id="oc-tour-dept-grid">${cards}</div>
    <div id="oc-tour-actions">
      <button class="oc-tour-btn oc-tour-btn--primary" id="oc-tour-finish" type="button">I'm Done</button>
    </div>`;
  dialog.querySelectorAll('.oc-tour-dept-card').forEach((card) => {
    card.addEventListener('click', () => {
      state.deptIndex = parseInt(card.dataset.dept, 10);
      state.stepIndex = 0;
      state.view = 'dept';
      render();
    });
  });
  dialog.querySelector('#oc-tour-finish').addEventListener('click', () => { state.view = 'done'; render(); });
}

function renderDept(dialog) {
  const dept = departments[state.deptIndex];
  const step = dept.steps[state.stepIndex];
  const isLast = state.stepIndex === dept.steps.length - 1;

  const dots = dept.steps.map((_, i) =>
    `<span class="oc-tour-dot" data-active="${i === state.stepIndex}"></span>`
  ).join('');

  dialog.innerHTML = `
    <div id="oc-tour-icon" style="color:${dept.color}">${dept.icon}</div>
    <h2 id="oc-tour-step-title">${step.title}</h2>
    <p id="oc-tour-step-subtitle">${step.subtitle}</p>
    <div id="oc-tour-actions">
      ${step.tryPrompt ? `<button class="oc-tour-btn oc-tour-btn--try" id="oc-tour-try" type="button" style="--try-color:${dept.color}">Try it</button>` : ''}
      <div id="oc-tour-nav">
        ${state.stepIndex > 0 ? '<button class="oc-tour-btn oc-tour-btn--ghost" id="oc-tour-prev" type="button">Back</button>' : ''}
        <button class="oc-tour-btn oc-tour-btn--primary" id="oc-tour-next" type="button" style="background:${dept.color}">${isLast ? 'Back to Departments' : 'Next'}</button>
      </div>
    </div>
    <div id="oc-tour-progress">
      <span class="oc-tour-progress-label" style="color:${dept.color}">${dept.label} \u2014 Step ${state.stepIndex + 1} of ${dept.steps.length}</span>
      <div class="oc-tour-dots">${dots}</div>
    </div>`;

  if (step.tryPrompt) {
    dialog.querySelector('#oc-tour-try').addEventListener('click', () => tryPrompt(step.tryPrompt, dept.agentId));
  }
  const prevBtn = dialog.querySelector('#oc-tour-prev');
  if (prevBtn) prevBtn.addEventListener('click', () => { state.stepIndex--; render(); });
  dialog.querySelector('#oc-tour-next').addEventListener('click', () => {
    if (isLast) {
      markDeptExplored(dept.id);
      state.view = 'picker';
    } else {
      state.stepIndex++;
    }
    render();
  });
}

function renderDone(dialog) {
  const explored = getExploredDepts();
  const grid = departments.map((d) => {
    const done = explored.includes(d.id);
    return `<div class="oc-tour-done-cell${done ? ' oc-tour-done-cell--done' : ''}" style="--dept-color:${d.color}">
      <span class="oc-tour-done-icon">${d.icon}</span>
      <span class="oc-tour-done-label">${d.label}</span>
      ${done ? '<span class="oc-tour-done-check">✓</span>' : '<span class="oc-tour-done-pending">\u2013</span>'}
    </div>`;
  }).join('');

  dialog.innerHTML = `
    <div id="oc-tour-icon">✅</div>
    <h2 id="oc-tour-step-title">You're All Set</h2>
    <p id="oc-tour-step-subtitle">Use the sidebar to navigate between departments. The <strong>?</strong> button is always in the top-right if you want this tour again.</p>
    <div id="oc-tour-done-grid">${grid}</div>
    <div id="oc-tour-actions">
      <button class="oc-tour-btn oc-tour-btn--primary" id="oc-tour-close" type="button">Get Started</button>
    </div>`;
  dialog.querySelector('#oc-tour-close').addEventListener('click', () => closeTour({ completed: true }));
}

function buildUi() {
  const button = document.createElement('button');
  button.id = 'oc-tour-button';
  button.type = 'button';
  button.textContent = '?';
  button.title = 'Get Started tour';
  button.addEventListener('click', () => openTour({ resetToStart: true }));

  const overlay = document.createElement('div');
  overlay.id = 'oc-tour-overlay';
  overlay.dataset.open = 'false';
  overlay.innerHTML = '<div id="oc-tour-dialog" role="dialog" aria-modal="true" aria-labelledby="oc-tour-step-title"></div>';
  overlay.addEventListener('click', (e) => { if (e.target === overlay) closeTour(); });

  document.body.append(button, overlay);
  state.button = button;
  state.overlay = overlay;
}

function persistUrlToken() {
  const urlToken = new URLSearchParams(window.location.search).get('token');
  if (urlToken) {
    try {
      const raw = localStorage.getItem(SETTINGS_KEY);
      if (raw) {
        const settings = JSON.parse(raw);
        settings.token = urlToken;
        localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
      } else {
        const protocol = location.protocol === 'https:' ? 'wss' : 'ws';
        localStorage.setItem(SETTINGS_KEY, JSON.stringify({
          gatewayUrl: `${protocol}://${location.host}/ws`,
          token: urlToken,
          sessionKey: 'main',
          lastActiveSessionKey: 'main',
        }));
      }
    } catch (_) { /* best effort */ }

    try {
      const root = appRoot();
      if (root) {
        const tokenInput = root.querySelector('input[placeholder*="token" i], input[name*="token" i], input[type="password"]');
        if (tokenInput) {
          const nativeSetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value')?.set;
          if (nativeSetter) nativeSetter.call(tokenInput, urlToken);
          else tokenInput.value = urlToken;
          tokenInput.dispatchEvent(new Event('input', { bubbles: true }));
          tokenInput.dispatchEvent(new Event('change', { bubbles: true }));
        }
      }
    } catch (_) { /* best effort */ }

    const clean = new URL(window.location.href);
    clean.searchParams.delete('token');
    history.replaceState(null, '', clean.toString());
  }
}

function handleKeydown(e) {
  if (!state.open) return;
  if (e.key === 'Escape') { closeTour(); return; }
  if (state.view === 'dept') {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
      e.preventDefault();
      const dept = departments[state.deptIndex];
      if (state.stepIndex < dept.steps.length - 1) { state.stepIndex++; render(); }
    } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
      e.preventDefault();
      if (state.stepIndex > 0) { state.stepIndex--; render(); }
    }
  }
  if (state.view === 'picker') {
    const num = parseInt(e.key, 10);
    if (num >= 1 && num <= departments.length) {
      e.preventDefault();
      state.deptIndex = num - 1;
      state.stepIndex = 0;
      state.view = 'dept';
      render();
    }
  }
}

function installWhenReady() {
  if (state.initialized) return;
  const root = appRoot();
  if (!document.body || !root) return;
  state.initialized = true;

  persistUrlToken();
  buildUi();

  const stored = loadTourState();
  if (!stored.seen && !stored.completed) {
    window.setTimeout(() => openTour({ resetToStart: true }), OPEN_DELAY_MS);
  }

  document.addEventListener('keydown', handleKeydown);
}

const readyTimer = window.setInterval(function () {
  installWhenReady();
  if (state.initialized) window.clearInterval(readyTimer);
}, 250);
window.addEventListener('load', installWhenReady);
