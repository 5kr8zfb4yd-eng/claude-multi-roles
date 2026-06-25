#!/usr/bin/env bash
# ═══ claude-roles — Selettore ruolo con MCP dinamico ═══
# Uso: ./os
# Repo: github.com/YOUR_USERNAME/claude-roles
set -e
cd "$(dirname "$0")"

# Carica credenziali MCP (non va su git)
if [ -f .claude/.env.mcp ]; then
  set -a; source .claude/.env.mcp; set +a
fi

ROLES=(
  "1-Product Manager"
  "2-UI/UX Developer"
  "3-SWE"
  "4-Security Engineer"
  "5-Growth Marketer"
)
MCP_CONFIGS=(
  "1-product"
  "2-uiux"
  "3-swe"
  "4-security"
  "5-growth"
)

echo "═══════════════════════════════════════════════════════════"
echo "  claude-roles — Seleziona il ruolo della sessione"
echo "═══════════════════════════════════════════════════════════"
PS3="Ruolo > "
select R in "${ROLES[@]}"; do
  [ -n "$R" ] && break
  echo "Scelta non valida. Digita il numero del ruolo."
done

IDX=$((REPLY - 1))
CONFIG_FILE=".claude/mcp-configs/${MCP_CONFIGS[$IDX]}.json"

# Scrivi configurazione MCP per questo ruolo
if [ -f "$CONFIG_FILE" ]; then
  if command -v envsubst &>/dev/null; then
    envsubst < "$CONFIG_FILE" > .mcp.json
  else
    cp "$CONFIG_FILE" .mcp.json
    echo "⚠️  envsubst non trovato — variabili d'ambiente non sostituite nel config MCP."
    echo "   Installa con: brew install gettext"
  fi
fi

# Mostra MCP attivi
MCP_NAMES=$(python3 -c "
import json
try:
    cfg = json.load(open('.mcp.json'))
    s = list(cfg.get('mcpServers', {}).keys())
    print(', '.join(s) if s else 'nessuno')
except: print('nessuno')
" 2>/dev/null || echo "nessuno")

echo ""
echo "◆ Ruolo attivo:      $R"
echo "◆ MCP connettori:    ${MCP_NAMES}"
echo ""

mkdir -p .claude/state
echo "$R" > .claude/state/active-role.txt

exec claude --dangerously-skip-permissions \
  "Attiva il ruolo: $R. Leggi CLAUDE.md, esegui il Protocollo di lettura memoria \
(ROLE.md → MEMORY.md → shared/STATE.md → shared/DECISIONS.md → ultimi 20 eventi \
shared/BUS.md). Se ci sono MCP attivi, elenca i tool disponibili. Poi avvia la sessione."
