# Getting Started

This guide takes you from zero to your first role session in about five minutes.

## 1. Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- Node.js ≥ 18
- `envsubst` (`brew install gettext` on macOS; usually preinstalled on Linux)

Check them:

```bash
node --version          # v18+
command -v envsubst      # prints a path
claude --version         # Claude Code present
```

## 2. Install

Clone the repo (or run the one-liner installer into an existing project — see the
[README](../README.md#installation)):

```bash
git clone https://github.com/5kr8zfb4yd-eng/claude-multi-roles.git
cd claude-multi-roles
cp .claude/.env.mcp.example .claude/.env.mcp
chmod +x multiroles
```

## 3. Configure the project identity

Open `CLAUDE.md` and complete the **PROJECT IDENTITY** section. Replace every
`<...>` placeholder with your real product, stack, current state and 30-day goal.
Until you do, the framework is intentionally in an "unconfigured" state.

## 4. (Optional) Add MCP credentials

Only needed for the SWE/Security (Supabase) and Growth (Instagram) roles. Edit
`.claude/.env.mcp` — see [mcp-setup.md](./mcp-setup.md). The Product and UI/UX
roles need nothing here.

## 5. Run your first session

```bash
./multiroles
```

Pick **1 (Product Manager)** for the very first session — it writes the roadmap and
the architectural decisions the other roles will build on. The launcher writes
`.mcp.json` for that role, records the active role, and hands off to Claude Code,
which reads its `ROLE.md`, `MEMORY.md`, and the shared `STATE` / `DECISIONS` / `BUS`.

## 6. End the session

When you stop, the `Stop` hook reminds Claude to run the quality gate, update its
private `MEMORY.md`, broadcast to `BUS.md` if other roles are affected, update
`STATE.md`, and (if the score is ≥ 7) write a `next-session-<role>.md`. Finally it
proposes a commit — the loop only closes once the work is committed.

Next: [roles.md](./roles.md) · [architecture.md](./architecture.md) · [mcp-setup.md](./mcp-setup.md)
