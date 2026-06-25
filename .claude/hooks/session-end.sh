#!/usr/bin/env bash
# Deterministic end-of-session trigger
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
ROLE=$(cat .claude/state/active-role.txt 2>/dev/null || echo "unknown")
echo "[$TIMESTAMP] Session end — Role: $ROLE" >> .claude/state/session-log.txt
echo "session-end hook executed. Claude: update MEMORY, BUS, STATE and write next-session."
