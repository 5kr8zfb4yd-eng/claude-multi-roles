#!/usr/bin/env bash
# install.sh — Scaffold claude-multi-roles into a new project
# Usage: curl -fsSL https://raw.githubusercontent.com/GiuseppeFarruggia/claude-multi-roles/main/install.sh | bash
# Or: bash install.sh

set -e

REPO_URL="https://raw.githubusercontent.com/GiuseppeFarruggia/claude-multi-roles/main"
TARGET="${1:-.}"  # target directory, default: current folder

echo "═══════════════════════════════════════════════════"
echo "  claude-multi-roles — Installation"
echo "  Target: $TARGET"
echo "═══════════════════════════════════════════════════"

# Create the directory structure
mkdir -p "$TARGET/.claude/"{hooks,shared,state,assets/{logos,brand,refs,svg},mcp-configs}
for role in 1-product 2-uiux 3-swe 4-security 5-growth; do
  mkdir -p "$TARGET/.claude/roles/$role"
done
mkdir -p "$TARGET/docs"

echo "✅ Directory structure created"

# Download files from GitHub
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

# Initialize empty MEMORY.md files
for role in 1-product 2-uiux 3-swe 4-security 5-growth; do
  echo "# MEMORY — $role" > "$TARGET/.claude/roles/$role/MEMORY.md"
  echo "Private memory. Only this role writes here." >> "$TARGET/.claude/roles/$role/MEMORY.md"
done

# Make scripts executable
chmod +x "$TARGET/multiroles"
chmod +x "$TARGET/.claude/hooks/"*.sh

# Copy .env.mcp.example
cp "$TARGET/.claude/.env.mcp.example" "$TARGET/.claude/.env.mcp"

echo ""
echo "✅ claude-multi-roles installed in: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Fill .claude/.env.mcp with your MCP credentials"
echo "  2. Complete the PROJECT IDENTITY section in CLAUDE.md"
echo "  3. cd $TARGET && ./multiroles"
echo "     → choose 1-Product Manager for the first session"
