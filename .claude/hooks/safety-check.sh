#!/usr/bin/env bash
# Backstop deterministico — blocca operazioni irreversibili
# Attivo anche con --dangerously-skip-permissions
INPUT="$(cat)"
block() { echo "🛑 safety-check: $1 — bloccato. Serve conferma manuale." >&2; exit 2; }

echo "$INPUT" | grep -Eqi 'rm[[:space:]]+-[a-z]*r[a-z]*f|rm[[:space:]]+-[a-z]*f[a-z]*r' \
  && block "rm ricorsivo forzato"
echo "$INPUT" | grep -Eqi 'DROP[[:space:]]+(TABLE|DATABASE|SCHEMA)|TRUNCATE' \
  && block "DROP/TRUNCATE su database"
echo "$INPUT" | grep -Eqi 'git[[:space:]]+push.*(--force|-f)([[:space:]]|$)' \
  && block "git push forzato"
echo "$INPUT" | grep -Eqi 'git[[:space:]]+push.*(main|master)' \
  && block "push su main/master = deploy produzione"
exit 0
