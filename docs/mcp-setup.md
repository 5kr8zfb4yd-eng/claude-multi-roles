# MCP Setup

Each role loads only the MCP servers it needs. Credentials live in
`.claude/.env.mcp` (git-ignored) and are injected into `.mcp.json` at launch via
`envsubst`. Start from the template:

```bash
cp .claude/.env.mcp.example .claude/.env.mcp
```

| Role | MCP server | Required env vars |
|---|---|---|
| Product Manager | — | none |
| UI/UX Developer | — | none |
| SWE | `supabase` | `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_REF` |
| Security Engineer | `supabase` | `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_REF` |
| Growth Marketer | `instagram` | `INSTAGRAM_ACCESS_TOKEN`, `INSTAGRAM_USER_ID` |

## Supabase (SWE + Security)

1. Create a personal access token at
   <https://supabase.com/dashboard/account/tokens>.
2. Find your project ref in the project's URL / settings.
3. Add them to `.claude/.env.mcp`:

   ```bash
   SUPABASE_ACCESS_TOKEN="sbp_xxx"
   SUPABASE_PROJECT_REF="your-project-ref"
   ```

The server is [`@supabase/mcp-server-supabase`](https://github.com/supabase-community/supabase-mcp),
launched via `npx` — no global install needed.

## Instagram / Meta (Growth)

1. Create a Meta Developer App with an Instagram Business account.
2. Generate a long-lived access token and find your Instagram user ID.
3. Add them to `.claude/.env.mcp`:

   ```bash
   INSTAGRAM_ACCESS_TOKEN="xxx"
   INSTAGRAM_USER_ID="xxx"
   ```

The server is [`@mikusnuz/meta-mcp`](https://github.com/mikusnuz/meta-mcp) — see that
repo for the exact token scopes.

## Adding your own MCP

Edit the relevant `.claude/mcp-configs/<role>.json`, referencing secrets as
`${VAR}`, and add those vars to both `.env.mcp.example` and `.env.mcp`:

```jsonc
// .claude/mcp-configs/2-uiux.json — give UI/UX a Vercel connector
{ "mcpServers": { "vercel": {
  "command": "npx", "args": ["-y", "<vercel-mcp-package>"],
  "env": { "VERCEL_TOKEN": "${VERCEL_TOKEN}" } } } }
```

`envsubst` substitutes the values at launch. Verify with:

```bash
set -a; source .claude/.env.mcp; set +a
envsubst < .claude/mcp-configs/2-uiux.json | python3 -m json.tool
```
