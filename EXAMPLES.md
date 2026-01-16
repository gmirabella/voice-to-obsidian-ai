# 💡 Esempi di Utilizzo

Questa guida mostra esempi pratici di come usare Voice-to-Obsidian.

## 🎙️ Esempi di Dettatura

### Task con Scadenza

**Detti:**
> "Devo chiamare il dentista entro venerdì per prenotare la visita"

**Risultato in `Daily Journal/2026-01-16.md`:**
```markdown
## Task
- [ ] Chiamare il dentista per prenotare la visita 📅 2026-01-19
```

---

**Detti:**
> "Task: finire il report entro lunedì"

**Risultato:**
```markdown
## Task
- [ ] Finire il report 📅 2026-01-20
```

### Journal Personale

**Detti:**
> "Oggi mi sono sentita molto produttiva. Ho completato 3 task importanti e ho trovato il tempo per una passeggiata."

**Risultato in `Daily Journal/2026-01-16.md`:**
```markdown
## Note
- Oggi mi sono sentita molto produttiva. Ho completato 3 task importanti e ho trovato il tempo per una passeggiata.
```

---

**Detti:**
> "Riflessione: è importante prendersi delle pause durante la giornata per non bruciare tutte le energie"

**Risultato:**
```markdown
## Journal
- Riflessione: è importante prendersi delle pause durante la giornata per non bruciare tutte le energie
```

### Idee per Progetti

**Detti:**
> "Idea per il progetto dashboard: aggiungere una sezione con i grafici delle performance settimanali"

**Risultato in `Projects/Dashboard.md`:**
```markdown
# Dashboard

## Idee
- Aggiungere una sezione con i grafici delle performance settimanali
```

---

**Detti:**
> "Per il progetto app mobile: considerare l'integrazione con HealthKit per tracciare l'attività fisica"

**Risultato in `Projects/App Mobile.md`:**
```markdown
# App Mobile

## Note
- Considerare l'integrazione con HealthKit per tracciare l'attività fisica
```

### Note Generiche

**Detti:**
> "Ricetta consigliata da Marco: pasta al pesto con pomodorini e mozzarella"

**Risultato in `Daily Journal/2026-01-16.md`:**
```markdown
## Note
- Ricetta consigliata da Marco: pasta al pesto con pomodorini e mozzarella
```

### Meetings

**Dici:**
> "Aggiorna meetings"

**Claude esegue:**
1. Legge il calendario macOS
2. Estrae eventi di oggi

**Risultato in `Meetings Today.md`:**
```markdown
# Meetings - 2026-01-16

- 09:00 | Team Standup
- 11:00 | Client Review
- 14:30 | Sprint Planning
- 16:00 | 1-on-1 con Manager
```

## 🎯 Casi d'Uso Avanzati

### Combinazione Task + Progetto

**Detti:**
> "Devo implementare la funzionalità di login entro mercoledì per il progetto Website Redesign"

**Risultato:**
1. **Task in Daily Journal:**
   ```markdown
   - [ ] Implementare la funzionalità di login per Website Redesign 📅 2026-01-18
   ```

2. **Nota in Projects/Website Redesign.md:**
   ```markdown
   ## Note
   - Funzionalità di login da implementare (scadenza: 2026-01-18)
   ```

### Quick Capture

**Detti:**
> "Libro consigliato: Atomic Habits di James Clear"

**Risultato:**
```markdown
## Note
- Libro consigliato: Atomic Habits di James Clear
```

**Detti:**
> "Link utile: https://example.com/tutorial per imparare TypeScript"

**Risultato:**
```markdown
## Note
- Link utile: https://example.com/tutorial per imparare TypeScript
```

### Tracciamento Abitudini

**Detti:**
> "Oggi ho fatto yoga e meditazione per 20 minuti"

**Risultato in Health/ o Daily Journal:**
```markdown
## Note
- Oggi ho fatto yoga e meditazione per 20 minuti
```

**Detti:**
> "Devo ricordarmi di fare stretching ogni sera prima di dormire"

**Risultato:**
```markdown
## Task
- [ ] Fare stretching ogni sera prima di dormire
```

## 🔧 Personalizzazioni Esempio

### Aggiungere Categoria "Shopping"

Modifica `CLAUDE.md`:

```markdown
### Shopping List
Se contiene: "comprare", "shopping", "da comprare", "acquistare"
→ Aggiungi alla nota `Shopping List.md`
→ Formato: `- [ ] item`
```

**Detti:**
> "Comprare latte, uova e pane"

**Risultato in `Shopping List.md`:**
```markdown
# Shopping List

- [ ] Latte
- [ ] Uova
- [ ] Pane
```

### Tracking Libri

Modifica `CLAUDE.md`:

```markdown
### Libri
Se contiene: "libro", "lettura", "leggere", "reading"
→ Aggiungi a `Reading List.md`
→ Formato: `- [ ] Titolo - Autore`
```

**Detti:**
> "Voglio leggere 'Deep Work' di Cal Newport"

**Risultato in `Reading List.md`:**
```markdown
# Reading List

## Da Leggere
- [ ] Deep Work - Cal Newport
```

### Idee Imprenditoriali

Modifica `CLAUDE.md`:

```markdown
### Business Ideas
Se contiene: "business idea", "startup idea", "idea imprenditoriale"
→ Aggiungi a `Business Ideas.md`
→ Formato dettagliato con data
```

**Detti:**
> "Business idea: app per connettere freelancer con piccole imprese locali"

**Risultato in `Business Ideas.md`:**
```markdown
# Business Ideas

## 2026-01-16
- App per connettere freelancer con piccole imprese locali
```

## 🌊 Workflow Quotidiano

### Mattina

**9:00 - Prima di iniziare:**
> "Aggiorna meetings"

**9:05 - Planning giornaliero:**
> "Oggi devo: completare il design della landing page, chiamare il cliente per feedback, e preparare la presentazione per domani"

**Risultato:**
```markdown
## Task
- [ ] Completare il design della landing page
- [ ] Chiamare il cliente per feedback
- [ ] Preparare la presentazione per domani
```

### Durante il Giorno

**11:30 - Quick idea:**
> "Idea: usare animazioni CSS invece di JavaScript per migliorare le performance"

**14:00 - Task urgente:**
> "Devo fixare il bug del login entro oggi"

**16:30 - Note da meeting:**
> "Meeting con cliente: vuole aggiungere sezione testimonials e integrare newsletter"

### Sera

**19:00 - Journal:**
> "Oggi ho fatto progressi sul progetto principale. Mi sono sentita un po' stressata nel pomeriggio ma la passeggiata ha aiutato."

**21:00 - Task per domani:**
> "Domani devo iniziare la giornata con il task più importante: finire la presentazione"

## 💭 Tips e Tricks

### Sii Specifico

**❌ Poco chiaro:**
> "Fare quella cosa"

**✅ Chiaro:**
> "Devo aggiornare la documentazione API entro venerdì"

### Usa Trigger Espliciti

**Per garantire catalogazione corretta:**
- "Task:" per task espliciti
- "Idea per progetto X:" per progetti
- "Journal:" per note personali
- "Nota:" per note generiche

### Date Naturali

Claude capisce date naturali:
- "entro venerdì" → calcola il venerdì successivo
- "domani" → giorno successivo
- "la prossima settimana" → lunedì prossimo

### Multi-Task

**Detti:**
> "Devo fare tre cose: chiamare Maria, comprare il latte, e mandare email al team"

**Risultato:**
```markdown
## Task
- [ ] Chiamare Maria
- [ ] Comprare il latte
- [ ] Mandare email al team
```

## 🎨 Formattazione Avanzata

### Con Link

**Detti:**
> "Leggere l'articolo su obsidian.md/blog sulla nuova feature di canvas"

**Risultato:**
```markdown
## Note
- Leggere l'articolo su obsidian.md/blog sulla nuova feature di canvas
```

### Con Persone

**Detti:**
> "Parlare con @Giovanni del progetto X"

**Risultato:**
```markdown
## Task
- [ ] Parlare con @Giovanni del progetto X
```

### Con Tag Manuali

**Detti:**
> "Idea per blog post: come ottimizzare il workflow con Obsidian, tag: productivity, obsidian"

**Risultato:**
```markdown
## Note
- Idea per blog post: come ottimizzare il workflow con Obsidian #productivity #obsidian
```

## 🚀 Casi d'Uso Professionali

### Developer Workflow

> "Bug trovato: il componente header non si aggiorna quando cambio tema. Da fixare prima del deploy."

> "Code review note: il file utils.js ha troppa complessità ciclomatica, considerare refactoring"

### Content Creator

> "Video idea: tutorial su come configurare un vault Obsidian da zero"

> "Post Instagram: carousel su 5 tips per la produttività con la tecnica Pomodoro"

### Student

> "Studiare capitolo 3 di matematica entro martedì per l'esame"

> "Appunti lezione: le tre leggi della termodinamica..."

### Manager

> "Follow-up con il team sul progetto Alpha dopo la retrospettiva"

> "Idea: implementare check-in settimanali one-on-one con ogni team member"

---

**Hai altri esempi da condividere? Apri una PR! 🎉**
