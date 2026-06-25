# Architecture

claude-multi-roles is a thin orchestration layer around Claude Code. There is no
server and no daemon — just a launcher, a few hooks, per-role config, and a set of
shared Markdown files that act as durable memory.

## Components

| Path | Role |
|---|---|
| `multiroles` | Launcher. Picks a role, renders `.mcp.json`, records the active role, execs Claude Code. |
| `CLAUDE.md` | The constitution. Rule Zero, session protocol, quality gate, absolute rules. Loaded into every session. |
| `.claude/roles/<role>/ROLE.md` | Per-role scope: persona, what it owns, what is off-limits, its north star. |
| `.claude/roles/<role>/MEMORY.md` | Per-role **private** memory. Only that role writes it. |
| `.claude/mcp-configs/<role>.json` | Per-role MCP server set, with `${VAR}` placeholders. |
| `.claude/shared/BUS.md` | Append-only event bus. All roles read; a role writes a broadcast when it affects others. |
| `.claude/shared/STATE.md` | Current project state, refreshed at session end. |
| `.claude/shared/DECISIONS.md` | Architectural Decision Records. Only the PM writes here. |
| `.claude/hooks/*.sh` | `session-start` (Rule Zero guard), `safety-check` (PreToolUse backstop), `session-end` (Stop trigger). |
| `.claude/settings.json` | Wires the three hooks into Claude Code. |

## Lifecycle of a session

```
./multiroles
  → render .mcp.json from mcp-configs/<role>.json (envsubst)
  → write .claude/state/active-role.txt
  → exec claude --dangerously-skip-permissions
       → SessionStart hook: enforce Rule Zero (a role must be selected)
       → read CLAUDE.md, ROLE.md, MEMORY.md, STATE, DECISIONS, last 20 BUS events
       → work (every Bash call passes through safety-check.sh)
       → Stop hook: quality gate → update MEMORY/BUS/STATE → next-session → commit
```

## Design principles

- **Scope isolation.** One role per session; a role never edits another role's files
  or reads another role's private memory. Coordination happens only through the BUS.
- **Durable over ephemeral.** Memory is files on disk, versioned in git — it survives
  across sessions, days and machines.
- **Least-privilege tooling.** Each role boots with only the MCP servers it needs.
- **Deterministic safety.** Irreversible operations are blocked by a regex hook that
  runs regardless of permission mode (see [README → Safety](../README.md#safety)).

## Trust model

The framework leans on Claude following `CLAUDE.md` for *soft* guarantees (scope,
quality gate, memory hygiene). The `safety-check.sh` hook provides the *hard*
guarantee: even a fully autonomous session cannot run a blocked command.
