#!/usr/bin/env bash
# install.sh — Scaffolding claude-multi-roles in un nuovo progetto
# Uso: curl -fsSL https://raw.githubusercontent.com/GiuseppeFarruggia/claude-multi-roles/main/install.sh | bash
# Oppure: bash install.sh

set -e

REPO_URL="https://raw.githubusercontent.com/GiuseppeFarruggia/claude-multi-roles/main"
TARGET="${1:-.}"  # directory target, default: cartella corrente

echo "═══════════════════════════════════════════════════"
echo "  claude-multi-roles — Installazione"
echo "  Target: $TARGET"
echo "═══════════════════════════════════════════════════"

# Crea struttura
mkdir -p "$TARGET/.claude/"{hooks,shared,state,assets/{logos,brand,refs,svg},mcp-configs}
for role in 1-product 2-uiux 3-swe 4-security 5-growth; do
  mkdir -p "$TARGET/.claude/roles/$role"
done
mkdir -p "$TARGET/docs"

echo "✅ Struttura cartelle creata"

# Scarica file da GitHub
for file in \
  "CLAUDE.md" \
  "multiroles" \
  ".gitignore" \
  ".claude/settings.json" \
  ".claude/hooks/safety-check.sh" \
  ".claude/hooks/session-start.sh" \
  ".claude/hooks/session-end.sh" \
  ".claude/shared/BUS.md" \
  ".claude/shared/STATE.md" \
  ".claude/shared/DECISIONS.md" \
  ".claude/.env.mcp.example" \
  ".claude/mcp-configs/1-product.json" \
  ".claude/mcp-configs/2-uiux.json" \
  ".claude/mcp-configs/3-swe.json" \
  ".claude/mcp-configs/4-security.json" \
  ".claude/mcp-configs/5-growth.json" \
  ".claude/roles/1-product/ROLE.md" \
  ".claude/roles/2-uiux/ROLE.md" \
  ".claude/roles/3-swe/ROLE.md" \
  ".claude/roles/4-security/ROLE.md" \
  ".claude/roles/5-growth/ROLE.md"; do
  mkdir -p "$TARGET/$(dirname $file)"
  curl -fsSL "$REPO_URL/$file" -o "$TARGET/$file"
done

# Inizializza MEMORY.md vuoti
for role in 1-product 2-uiux 3-swe 4-security 5-growth; do
  echo "# MEMORY — $role" > "$TARGET/.claude/roles/$role/MEMORY.md"
  echo "Memoria privata. Solo questo ruolo scrive qui." >> "$TARGET/.claude/roles/$role/MEMORY.md"
done

# Rendi eseguibili
chmod +x "$TARGET/multiroles"
chmod +x "$TARGET/.claude/hooks/"*.sh

# Copia .env.mcp.example
cp "$TARGET/.claude/.env.mcp.example" "$TARGET/.claude/.env.mcp"

echo ""
echo "✅ claude-multi-roles installato in: $TARGET"
echo ""
echo "Prossimi passi:"
echo "  1. Riempi .claude/.env.mcp con le tue credenziali MCP"
echo "  2. Compila la sezione IDENTITÀ DEL PROGETTO in CLAUDE.md"
echo "  3. cd $TARGET && ./multiroles"
echo "     → scegli 1-Product Manager per la prima sessione"
