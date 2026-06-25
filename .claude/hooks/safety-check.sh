#!/usr/bin/env bash
# Deterministic backstop — blocks irreversible operations
# Active even with --dangerously-skip-permissions
INPUT="$(cat)"
block() { echo "🛑 safety-check: $1 — blocked. Manual confirmation required." >&2; exit 2; }

echo "$INPUT" | grep -Eqi 'rm[[:space:]]+-[a-z]*r[a-z]*f|rm[[:space:]]+-[a-z]*f[a-z]*r' \
  && block "recursive force rm"
echo "$INPUT" | grep -Eqi 'DROP[[:space:]]+(TABLE|DATABASE|SCHEMA)|TRUNCATE' \
  && block "DROP/TRUNCATE on database"
echo "$INPUT" | grep -Eqi 'git[[:space:]]+push.*(--force|-f)([[:space:]]|$)' \
  && block "force git push"
echo "$INPUT" | grep -Eqi 'git[[:space:]]+push.*(main|master)' \
  && block "push to main/master = production deploy"
exit 0
