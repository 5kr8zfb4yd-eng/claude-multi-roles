#!/usr/bin/env bash
# Trigger deterministico di fine sessione
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
ROLE=$(cat .claude/state/active-role.txt 2>/dev/null || echo "sconosciuto")
echo "[$TIMESTAMP] Fine sessione — Ruolo: $ROLE" >> .claude/state/session-log.txt
echo "Hook session-end eseguito. Claude: aggiorna MEMORY, BUS, STATE e scrivi next-session."
