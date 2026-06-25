# Roles

Five roles, one per session. Each has a `ROLE.md` (its scope) and a private
`MEMORY.md`. The table below is a summary; the authoritative definition is each
role's `ROLE.md` under `.claude/roles/`.

| # | Role | Owns | Off-limits | MCP |
|---|---|---|---|---|
| 1 | Product Manager | Roadmap, specs, acceptance criteria, `DECISIONS.md` | Code, DB/schema, bash | — |
| 2 | UI/UX Developer | Components, design system, brand assets | Backend, schema, auth, product calls | — |
| 3 | SWE | Backend, data layer, APIs, real auth, schema | UI/JSX, product priorities, prod deploy w/o sign-off | `supabase` |
| 4 | Security Engineer | RLS/auth review, OWASP, role isolation | New features, unannounced schema changes | `supabase` (read) |
| 5 | Growth Marketer | Acquisition, retention, analytics, social | Code, DB, autonomous publishing | `instagram` |

## Boundaries

- **One role per session.** A role never invades another role's scope.
- **No cross-reads of private memory.** Roles learn what others did via `BUS.md`,
  `STATE.md` and `DECISIONS.md` — never by reading another role's `MEMORY.md`.
  The Product Manager is the only exception, and only when coordination requires it.
- **Hard stops.** Schema changes, auth changes, production deploys, and any external
  publishing require explicit human confirmation.

## Handoffs

A role signals work for another role by appending a broadcast to `BUS.md`:

```
[YYYY-MM-DD | ROLE] {what changed}. NEEDS: {role} → {action}
```

The next session for that role reads the BUS at startup and knows exactly what to
pick up. See [examples/uiux-to-swe-handoff](../examples/uiux-to-swe-handoff/) for a
worked end-to-end handoff.

## Adding a sixth role

1. Create `.claude/roles/6-<name>/ROLE.md` and `MEMORY.md`.
2. Add `.claude/mcp-configs/6-<name>.json` (use `{ "mcpServers": {} }` if it needs no MCP).
3. Append the role to the `ROLES` and `MCP_CONFIGS` arrays in `multiroles`.
4. Add it to the **RULE ZERO** list in `CLAUDE.md`.
