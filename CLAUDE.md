# claude-multi-roles — Multi-role Claude Code Orchestration Framework
# Dynamic MCP per session · Async inter-role communication · Deterministic safety backstop

---

## RULE ZERO

If `.claude/state/active-role.txt` does not exist or is empty, your first and only
action is to present the 5 roles as a numbered list and ask which one to activate.
Do nothing else until you receive an answer.

```
1. Product Manager    — the why/what, roadmap, specs (NO code)
2. UI/UX Developer    — design, frontend, design system, brand assets
3. SWE                — backend, DB, API, integrations, mock replacement
4. Security Engineer  — RLS, auth, OWASP, application-role isolation
5. Growth Marketer    — acquisition, retention, analytics, social
```

Preferred mode: `./multiroles` from the terminal (sets the role and launches Claude).
Fallback: bare `claude` → Rule Zero triggers automatically.

---

## PROJECT IDENTITY

> ⚙️  TEMPLATE — Fill this section in during the first PM session (role 1).
> Replace every `<...>` placeholder with your project's real values.
> While it still holds placeholders, the framework is in an "unconfigured" state.

**Product:**          <one line: what you're building and for whom>
**Stack:**            <e.g. Next.js + Supabase + TypeScript>
**Current state:**    <e.g. MVP with mock data, no backend yet>
**30-day goal:**      <a measurable outcome, e.g. "first 50 real users">

<!--
Worked example (remove when you insert your own values):
**Product:** Marketplace for local artisans — mobile-first web app.
**Stack:** Next.js 15 + Supabase + TypeScript + Tailwind.
**Current state:** Frontend on mock data, waiting for a real backend.
**30-day goal:** Replace mocks with Supabase and onboard 20 artisans.
-->

---

## SESSION PROTOCOL

### On startup
1. Read this CLAUDE.md.
2. Read `.claude/roles/<role>/ROLE.md` → who you are and what you may do.
3. Read `.claude/roles/<role>/MEMORY.md` → your private memory.
4. Read `.claude/shared/STATE.md` → project state.
5. Read `.claude/shared/DECISIONS.md` → architectural decisions in force.
6. Read the last 20 events of `.claude/shared/BUS.md` → what the other roles did.
7. If `.claude/commands/next-session-<role>.md` exists → run it.
   Otherwise → wait for the human's prompt.

### At session end (the Stop hook fires automatically)
1. Quality gate → score 0-10 (rubric in its dedicated section).
2. Update `.claude/roles/<role>/MEMORY.md` (only your own).
3. If other roles are affected → write a broadcast to `.claude/shared/BUS.md`:
   `[YYYY-MM-DD | ROLE] {what changed}. NEEDS: {role} → {action}`
4. Update `.claude/shared/STATE.md`.
5. If PM → update `.claude/shared/DECISIONS.md` for any new architectural decisions.
6. Score ≥ 7 → write `.claude/commands/next-session-<role>.md`.
   Score < 7 → write KNOWN_ISSUES, no next-session.
7. Propose a commit: `chore(claude): [<role>] session [DATE] — {short title}`.

### Memory invariants
- Write ONLY your own MEMORY.md.
- Read the others via BUS / STATE / DECISIONS (never their MEMORY directly).
- PM is the only role allowed to read all MEMORY.md files when necessary.

---

## QUALITY GATE (rubric 0-10, threshold ≥ 7)

| Criterion | Weight |
|---|---|
| Stays within role scope (no invasions) | 2 |
| Respects the DECISIONS in force | 2 |
| Build green, TypeScript clean, zero `any` | 2 |
| Security: no exposed secrets, accesses verified | 2 |
| Memory / BUS / STATE updated correctly | 2 |

---

## ABSOLUTE RULES

1. **One role per session.** No role invades another role's scope.
2. **Communication via the BUS.** Don't read other roles' private MEMORY.
3. **STOP on DB schema, Auth, deploy.** Human confirmation is mandatory.
4. **The AI never publishes autonomously** to external channels (social, email, store).
5. **Score < 7 blocks progress.** Better to stop than to accumulate debt.
6. **The loop closes with the commit.** A session is incomplete until committed.

---

## CURRENT_STATE
> Updated at the end of every session.

```
DATE:
PHASE:
ACTIVE ROLE: none
KNOWN_ISSUES:
```

## EVOLUTION_LOG
> Append-only.

```
[DATE] — Initial bootstrap.
```
