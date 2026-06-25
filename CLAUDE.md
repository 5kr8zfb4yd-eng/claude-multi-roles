# CLAUDE.md — claude-roles
# Multi-role orchestration · Dynamic MCP per session · Async inter-role communication

---

## REGOLA ZERO

Se `.claude/state/active-role.txt` non esiste o è vuoto, la tua prima e unica
azione è presentare i 5 ruoli come lista numerata e chiedere quale attivare.
Non fare altro finché non ricevi risposta.

```
1. Product Manager    — il perché/cosa, roadmap, specifiche (NO codice)
2. UI/UX Developer    — design, frontend, design system, asset di brand
3. SWE                — backend, DB, API, integrazioni, sostituzione mock
4. Security Engineer  — RLS, auth, OWASP, isolamento ruoli applicativi
5. Growth Marketer    — acquisizione, retention, analytics, social
```

Modo preferito: `./os` dal terminale (imposta il ruolo e lancia Claude).
Fallback: `claude` nudo → Regola Zero si attiva automaticamente.

---

## IDENTITÀ DEL PROGETTO

> Questa sezione va compilata dal team nella prima sessione PM.

**Prodotto:**
**Stack:**
**Stato attuale:**
**Obiettivo a 30 giorni:**

---

## PROTOCOLLO DI SESSIONE

### All'avvio
1. Leggi questo CLAUDE.md.
2. Leggi `.claude/roles/<ruolo>/ROLE.md` → chi sei e cosa puoi fare.
3. Leggi `.claude/roles/<ruolo>/MEMORY.md` → tua memoria privata.
4. Leggi `.claude/shared/STATE.md` → stato del progetto.
5. Leggi `.claude/shared/DECISIONS.md` → decisioni architetturali in vigore.
6. Leggi ultimi 20 eventi `.claude/shared/BUS.md` → cosa hanno fatto gli altri ruoli.
7. Se `.claude/commands/next-session-<ruolo>.md` esiste → eseguilo.
   Altrimenti → attendi prompt dell'umano.

### A fine sessione (hook Stop si attiva automaticamente)
1. Quality gate → score 0-10 (rubric nella sezione dedicata).
2. Aggiorna `.claude/roles/<ruolo>/MEMORY.md` (solo la tua).
3. Se altri ruoli sono coinvolti → scrivi broadcast su `.claude/shared/BUS.md`:
   `[YYYY-MM-DD | RUOLO] {cosa è cambiato}. RICHIEDE: {ruolo} → {azione}`
4. Aggiorna `.claude/shared/STATE.md`.
5. Se PM → aggiorna `.claude/shared/DECISIONS.md` per nuove decisioni arch.
6. Score ≥ 7 → scrivi `.claude/commands/next-session-<ruolo>.md`.
   Score < 7 → scrivi KNOWN_ISSUES, niente next-session.
7. Proponi commit: `chore(claude): [<ruolo>] session [DATA] — {titolo breve}`.

### Invarianti di memoria
- Scrivi SOLO la tua MEMORY.md.
- Leggi gli altri via BUS / STATE / DECISIONS (mai direttamente le loro MEMORY).
- PM è l'unico autorizzato a leggere tutte le MEMORY.md quando necessario.

---

## QUALITY GATE (rubric 0-10, soglia ≥ 7)

| Criterio | Peso |
|---|---|
| Rispetta scope del ruolo (no invasioni) | 2 |
| Rispetta le DECISIONS in vigore | 2 |
| Build verde, TypeScript clean, zero any | 2 |
| Sicurezza: no segreti esposti, accessi verificati | 2 |
| Memoria / BUS / STATE aggiornati correttamente | 2 |

---

## REGOLE ASSOLUTE

1. **Un ruolo per sessione.** Nessun ruolo invade lo scope dell'altro.
2. **Comunicazione via BUS.** Non leggere le MEMORY private degli altri.
3. **STOP su schema DB, Auth, deploy.** Conferma umana obbligatoria.
4. **L'AI non pubblica mai in autonomia** su canali esterni (social, email, store).
5. **Score < 7 blocca l'avanzamento.** Meglio fermarsi che accumulare debito.
6. **Il loop si chiude col commit.** Sessione incompleta finché non è committata.

---

## CURRENT_STATE
> Aggiornato ogni fine sessione.

```
DATA:
FASE:
RUOLO ATTIVO: nessuno
KNOWN_ISSUES:
```

## EVOLUTION_LOG
> Append-only.

```
[DATA] — Bootstrap iniziale.
```
