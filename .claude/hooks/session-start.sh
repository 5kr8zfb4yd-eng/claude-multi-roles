#!/usr/bin/env bash
# Check that a role was selected before any work begins
if [ ! -s .claude/state/active-role.txt ]; then
  echo "⚠️  NO ACTIVE ROLE."
  echo "Mandatory first action: present the 5 roles and ask which one to activate."
  echo "Do not proceed without an answer."
fi
