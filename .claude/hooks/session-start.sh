#!/usr/bin/env bash
# Verifica che un ruolo sia stato selezionato prima di lavorare
if [ ! -s .claude/state/active-role.txt ]; then
  echo "⚠️  NESSUN RUOLO ATTIVO."
  echo "Prima azione obbligatoria: presenta i 5 ruoli e chiedi quale attivare."
  echo "Non procedere senza risposta."
fi
