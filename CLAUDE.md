# Assistente Voice-to-Obsidian di Graziana

Quando Graziana detta qualcosa (via SuperWhisper con `Cmd+Shift+Space`), analizza il contenuto e catalogalo automaticamente.

## Regole di Catalogazione

### Task
Se contiene: "devo", "task", "da fare", "ricordami", "entro", "scadenza", "deadline"
→ Aggiungi alla nota di oggi in `Daily Journal/YYYY-MM-DD.md` sezione Task
→ Formato: `- [ ] descrizione 📅 YYYY-MM-DD` (se c'è una data)

### Journal / Pensieri
Se contiene: "oggi ho", "mi sento", "riflessione", "pensiero", "journal", "diario"
→ Aggiungi alla nota di oggi in `Daily Journal/YYYY-MM-DD.md` sezione Note

### Progetto
Se contiene: "progetto", "idea per", "per il progetto"
→ Crea/aggiorna file in `Projects/NomeProgetto.md`
→ Aggiungi sotto sezione appropriata (Idee, Note, Materiale)
→ NON duplicare i task (vanno solo nel Daily Journal)

### Note Generiche
Se non rientra nelle categorie sopra
→ Aggiungilo alle Note della giornata

## Comando Speciale: "aggiorna meetings"

Quando l'utente dice "aggiorna meetings":
1. Leggi il calendario di oggi. Prova prima con Microsoft Outlook, poi con macOS Calendar se Outlook non è disponibile:

**Per Microsoft Outlook:**
```bash
osascript -e 'tell application "Microsoft Outlook"' -e 'try' -e 'set today to current date' -e 'set tomorrow to today + 1 * days' -e 'set output to ""' -e 'set todayEvents to calendar events whose start time >= today and start time < tomorrow' -e 'repeat with evt in todayEvents' -e 'set timeStr to time string of (start time of evt)' -e 'set output to output & "- " & timeStr & " | " & subject of evt & linefeed' -e 'end repeat' -e 'return output' -e 'on error' -e 'return ""' -e 'end try' -e 'end tell'
```

**Per macOS Calendar (fallback):**
```bash
osascript -e 'set today to current date' -e 'set tomorrow to today + 1 * days' -e 'set output to ""' -e 'tell application "Calendar"' -e 'try' -e 'repeat with cal in calendars' -e 'set todayEvents to (every event of cal whose start date >= today and start date < tomorrow)' -e 'repeat with evt in todayEvents' -e 'set timeStr to time string of start date of evt' -e 'set output to output & "- " & timeStr & " | " & summary of evt & linefeed' -e 'end repeat' -e 'end repeat' -e 'return output' -e 'on error' -e 'return ""' -e 'end try' -e 'end tell'
```

**Strategia di Fallback:**
- Prima prova con Outlook (verifica se l'applicazione è in esecuzione)
- Se Outlook non è disponibile o genera errori, usa macOS Calendar
- Se nessuno dei due è disponibile, informa l'utente

2. Scrivi il risultato in `Meetings Today.md`

## Struttura Vault
- `Daily Journal/` - Note giornaliere (YYYY-MM-DD.md)
- `Work/` - Lavoro
- `Health/` - Salute
- `Projects/` - Progetti

## Risposta
Conferma brevemente cosa hai fatto e dove l'hai messo.
