const TOUR_VERSION = '2026-03-20-v3';
const STATE_KEY = `openclaw.getStarted.${TOUR_VERSION}`;
const OPEN_DELAY_MS = 900;

const steps = [
  {
    id: 'welcome',
    icon: '👋',
    title: 'Your HR Assistant is Ready',
    subtitle: 'This dashboard lets you chat with an AI that handles leave requests, employee lookups, onboarding, and more.',
    route: '/chat',
  },
  {
    id: 'ask',
    icon: '💬',
    title: 'Ask a Question',
    subtitle: 'Type a question in plain English. Try asking about leave balances, company policies, or employee info.',
    route: '/chat',
    tryPrompt: 'What is the leave balance for EMP-001?',
  },
  {
    id: 'team',
    icon: '👥',
    title: 'Look Up Your Team',
    subtitle: 'Find employee details, team rosters, or attendance records — just ask.',
    route: '/chat',
    tryPrompt: 'Look up employee EMP-001',
  },
  {
    id: 'reports',
    icon: '📊',
    title: 'Check Reports',
    subtitle: 'Get weekly HR stats, attendance summaries, and team reports on demand.',
    route: '/chat',
    tryPrompt: 'Show me the weekly HR stats',
  },
  {
    id: 'done',
    icon: '✅',
    title: "You're All Set",
    subtitle: 'Use the sidebar to explore more. The help button is always in the top-right if you need this tour again.',
    route: '/chat',
  },
];

const state = { stepIndex: 0, overlay: null, button: null, initialized: false, open: false };

function loadTourState() { try { return JSON.parse(localStorage.getItem(STATE_KEY) || '{}'); } catch { return {}; } }
function saveTourState(next) { localStorage.setItem(STATE_KEY, JSON.stringify({ ...loadTourState(), ...next })); }
function appRoot() { const host = document.querySelector('openclaw-app'); return host?.shadowRoot || host || document.body || null; }
function normalizeText(text) { return (text || '').replace(/\s+/g, ' ').trim().toLowerCase(); }

function findTextNode(text, root = appRoot()) {
  if (!root) return null;
  const want = normalizeText(text);
  const nodes = root.querySelectorAll('a,button,[role="tab"],h1,h2,h3,[title],label');
  for (const node of nodes) {
    const label = normalizeText(node.textContent || node.getAttribute('aria-label') || node.getAttribute('title') || '');
    if (label === want || label.startsWith(want)) return node;
  }
  return null;
}

function navigateTo(route, text) {
  const root = appRoot();
  if (!root) return false;
  const link = [...root.querySelectorAll('a[href]')].find((node) => {
    const href = node.getAttribute('href') || '';
    const label = normalizeText(node.textContent || '');
    return href === route || label === normalizeText(text);
  }) || findTextNode(text, root);
  if (link) { link.click(); return true; }
  return false;
}

function currentRoute() { return window.location.pathname; }

function closeTour({ completed = false } = {}) {
  state.open = false;
  if (state.overlay) state.overlay.dataset.open = 'false';
  saveTourState({ seen: true, completed: completed || loadTourState().completed || false, lastStep: state.stepIndex });
}

function openTour({ resetToStart = false } = {}) {
  if (!state.overlay) return;
  const stored = loadTourState();
  if (resetToStart) state.stepIndex = 0;
  else if (typeof stored.lastStep === 'number' && stored.lastStep >= 0 && stored.lastStep < steps.length) state.stepIndex = stored.lastStep;
  state.open = true;
  state.overlay.dataset.open = 'true';
  renderStep();
}

function tryPrompt(text) {
  closeTour();
  if (currentRoute() !== '/chat') navigateTo('/chat', 'Chat');
  setTimeout(() => {
    const root = appRoot();
    const input = root?.querySelector('textarea, [contenteditable], input[type="text"]');
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
  }, 400);
}

function renderStep() {
  const step = steps[state.stepIndex];
  if (!state.overlay || !step) return;

  state.overlay.querySelector('#oc-tour-icon').textContent = step.icon;
  state.overlay.querySelector('#oc-tour-step-title').textContent = step.title;
  state.overlay.querySelector('#oc-tour-step-subtitle').textContent = step.subtitle;

  // Progress dots
  [...state.overlay.querySelector('#oc-tour-progress').children].forEach((dot, i) => {
    dot.dataset.active = String(i === state.stepIndex);
  });

  // Try-it button
  const tryBtn = state.overlay.querySelector('#oc-tour-try');
  if (step.tryPrompt) {
    tryBtn.hidden = false;
    tryBtn.onclick = () => tryPrompt(step.tryPrompt);
  } else {
    tryBtn.hidden = true;
    tryBtn.onclick = null;
  }

  // Nav buttons
  state.overlay.querySelector('#oc-tour-prev').hidden = state.stepIndex === 0;
  const nextBtn = state.overlay.querySelector('#oc-tour-next');
  nextBtn.textContent = state.stepIndex === steps.length - 1 ? 'Done' : 'Next';
}

function buildUi() {
  // "?" help button — top-right to avoid chat input overlap
  const button = document.createElement('button');
  button.id = 'oc-tour-button';
  button.type = 'button';
  button.textContent = '?';
  button.title = 'Get Started tour';
  button.addEventListener('click', () => openTour({ resetToStart: true }));

  const overlay = document.createElement('div');
  overlay.id = 'oc-tour-overlay';
  overlay.dataset.open = 'false';
  overlay.innerHTML = `
    <div id="oc-tour-dialog" role="dialog" aria-modal="true" aria-labelledby="oc-tour-step-title">
      <div id="oc-tour-icon"></div>
      <h2 id="oc-tour-step-title"></h2>
      <p id="oc-tour-step-subtitle"></p>
      <div id="oc-tour-actions">
        <button class="oc-tour-btn" id="oc-tour-try" type="button" hidden>Try it</button>
        <div id="oc-tour-nav">
          <button class="oc-tour-btn oc-tour-btn--ghost" id="oc-tour-prev" type="button">Back</button>
          <button class="oc-tour-btn oc-tour-btn--primary" id="oc-tour-next" type="button">Next</button>
        </div>
      </div>
      <div id="oc-tour-progress">${steps.map(() => '<span class="oc-tour-dot"></span>').join('')}</div>
      <button class="oc-tour-btn--skip" id="oc-tour-skip" type="button">Skip tour</button>
    </div>`;

  overlay.addEventListener('click', (e) => { if (e.target === overlay) closeTour(); });
  overlay.querySelector('#oc-tour-skip').addEventListener('click', () => closeTour());
  overlay.querySelector('#oc-tour-prev').addEventListener('click', () => {
    state.stepIndex = Math.max(0, state.stepIndex - 1);
    saveTourState({ lastStep: state.stepIndex });
    renderStep();
  });
  overlay.querySelector('#oc-tour-next').addEventListener('click', () => {
    if (state.stepIndex >= steps.length - 1) {
      state.stepIndex = 0;
      closeTour({ completed: true });
      return;
    }
    state.stepIndex += 1;
    saveTourState({ lastStep: state.stepIndex });
    renderStep();
  });

  document.body.append(button, overlay);
  state.button = button;
  state.overlay = overlay;
}

function persistUrlToken() {
  const urlToken = new URLSearchParams(window.location.search).get('token');
  if (urlToken) {
    localStorage.setItem('openclaw.gateway.token', urlToken);
    // Also try to set the token via the app's shadow DOM input
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
    // Clean token from URL bar
    const clean = new URL(window.location.href);
    clean.searchParams.delete('token');
    history.replaceState(null, '', clean.toString());
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

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && state.open) closeTour();
  });
}

const readyTimer = window.setInterval(() => { installWhenReady(); if (state.initialized) window.clearInterval(readyTimer); }, 250);
window.addEventListener('load', installWhenReady);
