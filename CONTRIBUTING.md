# 🤝 Contributing

Grazie per il tuo interesse nel contribuire a Voice-to-Obsidian!

## Come Contribuire

### 🐛 Segnalare Bug

Se trovi un bug:
1. Controlla che non sia già stato segnalato nelle Issues
2. Crea una nuova Issue con:
   - Descrizione chiara del problema
   - Passi per riprodurlo
   - Comportamento atteso vs attuale
   - Sistema operativo e versioni software
   - Log rilevanti (da `~/.whisper-claude.log`)

### 💡 Suggerire Funzionalità

Per suggerire nuove funzionalità:
1. Apri una Issue con tag "enhancement"
2. Descrivi la funzionalità e il caso d'uso
3. Spiega perché sarebbe utile

### 🔧 Pull Request

Per contribuire con codice:

1. **Fork** il repository
2. **Crea un branch** per la tua feature:
   ```bash
   git checkout -b feature/nome-feature
   ```
3. **Fai le modifiche** e testa
4. **Commit** con messaggi chiari:
   ```bash
   git commit -m "Add: nuova funzionalità X"
   ```
5. **Push** al tuo fork:
   ```bash
   git push origin feature/nome-feature
   ```
6. **Apri una Pull Request** su GitHub

### 📝 Linee Guida

**Codice:**
- Scrivi codice chiaro e commentato
- Segui lo stile esistente
- Testa le modifiche prima del commit

**Documentazione:**
- Aggiorna README.md se necessario
- Documenta nuove funzionalità
- Includi esempi pratici

**Commit:**
- Usa commit atomici (una modifica per commit)
- Messaggi descrittivi
- Formato: `Tipo: descrizione breve`
  - `Add:` nuove funzionalità
  - `Fix:` correzioni bug
  - `Update:` aggiornamenti
  - `Docs:` documentazione

## 🌍 Internazionalizzazione

Vuoi tradurre il progetto?
1. Crea una copia di `CLAUDE.md` (es. `CLAUDE.en.md`)
2. Traduci i trigger e le istruzioni
3. Aggiorna il README con le lingue supportate
4. Invia una PR

## 🧪 Testing

Prima di inviare una PR, testa:
- Script bash con `shellcheck`
- Funzionalità end-to-end
- Compatibilità con diverse versioni di macOS

## 📜 Licenza

Contribuendo, accetti che il tuo codice sia rilasciato sotto la licenza MIT del progetto.

## 💬 Hai Domande?

- Apri una Discussion su GitHub
- Contatta i maintainer

Grazie per contribuire! 🎉
