# 🛠️ Guida Setup Completa

Questa guida ti accompagna passo-passo nella configurazione del sistema Voice-to-Obsidian con Claude AI.

## 📦 Installazione Componenti

### 1. Obsidian

```bash
# Scarica da: https://obsidian.md/
# Oppure con Homebrew:
brew install --cask obsidian
```

**Prima configurazione:**
1. Apri Obsidian
2. Crea un nuovo vault o apri uno esistente
3. Clona questo repository nel vault o copia i file

### 2. SuperWhisper

```bash
# Scarica da: https://superwhisper.com/
```

**Configurazione:**
1. Apri SuperWhisper
2. Vai in **Settings**
3. **Hotkey:** Imposta `Cmd+Shift+Space` (o la shortcut che preferisci)
4. **Model:** Seleziona il modello di trascrizione (consigliato: large-v3)
5. **Language:** Italian (o Auto-detect)

**IMPORTANTE - Configurazione Output:**
1. In Settings → **Actions**
2. Cambia da "Type" a **"Run Command"**
3. Inserisci questo comando:
```bash
/Users/[TUOUSERNAME]/bin/whisper-to-claude.sh
```
(Sostituisci `[TUOUSERNAME]` con il tuo username macOS)

### 3. Claude Code CLI

```bash
# Verifica se hai Homebrew
brew --version

# Se non hai Homebrew, installalo:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Installa Claude Code
brew install anthropics/claude-code/claude-code

# Verifica installazione
claude-code --version

# Primo accesso: login
claude-code auth login
```

## 🔧 Configurazione Script Bridge

Crea lo script che collega SuperWhisper a Claude:

```bash
# Crea la directory bin se non esiste
mkdir -p ~/bin

# Crea lo script
cat > ~/bin/whisper-to-claude.sh << 'SCRIPT'
#!/bin/bash

# === Configurazione ===
VAULT_PATH="$HOME/Library/CloudStorage/OneDrive-WPP365x02/Documents/Obsidian Vault"
LOG_FILE="$HOME/.whisper-claude.log"

# Funzione di log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# === Inizio Script ===
log "Script avviato"

# Leggi trascrizione dagli appunti
TRANSCRIPTION=$(pbpaste)

if [ -z "$TRANSCRIPTION" ]; then
    log "ERRORE: Nessun testo negli appunti"
    osascript -e 'display notification "Nessun testo trascritto" with title "Errore SuperWhisper"'
    exit 1
fi

log "Trascrizione ricevuta: ${TRANSCRIPTION:0:50}..."

# Vai nel vault
cd "$VAULT_PATH" || {
    log "ERRORE: Impossibile accedere al vault"
    osascript -e 'display notification "Vault non trovato" with title "Errore Claude"'
    exit 1
}

# Invia a Claude
echo "$TRANSCRIPTION" | claude-code 2>&1 | tee -a "$LOG_FILE"

# Verifica successo
if [ $? -eq 0 ]; then
    log "Successo: nota catalogata"
    osascript -e 'display notification "Nota aggiunta a Obsidian ✓" with title "Claude"'
else
    log "ERRORE: Claude ha fallito"
    osascript -e 'display notification "Errore durante catalogazione" with title "Claude"'
    exit 1
fi

SCRIPT

# Rendi eseguibile
chmod +x ~/bin/whisper-to-claude.sh

# Testa lo script
echo "Test script" | pbcopy
~/bin/whisper-to-claude.sh
```

**Personalizzazione:**
- Se il tuo vault è in un percorso diverso, modifica `VAULT_PATH`
- I log vengono salvati in `~/.whisper-claude.log`

## 📁 Struttura Vault

Crea le cartelle necessarie nel tuo vault:

```bash
cd "/path/to/VaultObsidian"

# Crea struttura cartelle
mkdir -p "Daily Journal"
mkdir -p "Projects"
mkdir -p "Work"
mkdir -p "Work/Projects"
mkdir -p "Health"
mkdir -p "Templates"

# Verifica struttura
tree -L 1
```

Dovresti avere:
```
VaultObsidian/
├── CLAUDE.md          ⬅️ File istruzioni per Claude (ESSENZIALE!)
├── README.md          ⬅️ Documentazione
├── SETUP.md           ⬅️ Questa guida
├── Daily Journal/     ⬅️ Note giornaliere
├── Projects/          ⬅️ Progetti
├── Work/              ⬅️ Lavoro
├── Health/            ⬅️ Salute (opzionale)
└── Templates/         ⬅️ Template note
```

## ✅ Test del Sistema

### Test 1: Claude Code

```bash
cd "/path/to/VaultObsidian"

# Test base
claude-code ask "Ciao, puoi confermare che funzioni?"

# Test catalogazione
echo "Task: testare il sistema entro oggi" | claude-code
```

Claude dovrebbe:
1. Rispondere al saluto
2. Aggiungere il task alla nota di oggi

### Test 2: Script Bridge

```bash
# Copia un testo negli appunti
echo "Devo comprare il latte" | pbcopy

# Esegui lo script
~/bin/whisper-to-claude.sh
```

Dovresti vedere:
- Notifica macOS "Nota aggiunta a Obsidian ✓"
- Task nella nota di oggi

### Test 3: SuperWhisper End-to-End

1. Premi `Cmd+Shift+Space`
2. Detti: "Devo testare il sistema"
3. SuperWhisper trascrive
4. Script invia a Claude
5. Ricevi notifica
6. Verifica in Obsidian → Daily Journal → oggi

## 🔐 Permessi macOS

Potrebbero essere necessari questi permessi:

### Accessibility
```
System Settings → Privacy & Security → Accessibility
→ Aggiungi SuperWhisper ✓
```

### Automation
```
System Settings → Privacy & Security → Automation
→ SuperWhisper → Terminal ✓
→ SuperWhisper → Calendar ✓ (if using macOS Calendar)
→ SuperWhisper → Microsoft Outlook ✓ (if using Outlook)
→ Terminal → Microsoft Outlook ✓ (if using Outlook)
```

### Full Disk Access (se necessario)
```
System Settings → Privacy & Security → Full Disk Access
→ Terminal ✓
```

## 🎨 Plugin Obsidian Consigliati

Questi plugin migliorano l'esperienza:

1. **Templater** - Template dinamici con variabili
2. **Calendar** - Vista calendario delle note giornaliere
3. **Tasks** - Gestione task avanzata
4. **Dataview** - Query sulle note
5. **Daily Notes** - Creazione automatica note giornaliere

**Installazione:**
1. Settings → Community plugins
2. Browse → Cerca il plugin
3. Install → Enable

## 🧪 Troubleshooting

### "Command not found: claude-code"

```bash
# Verifica installazione
which claude-code

# Se non trovato, aggiungi al PATH
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "Nota non viene aggiunta"

```bash
# Controlla i log
tail -f ~/.whisper-claude.log

# Verifica che CLAUDE.md esista
ls "/path/to/VaultObsidian/CLAUDE.md"

# Test manuale di Claude
cd "/path/to/VaultObsidian"
echo "Test" | claude-code
```

### "SuperWhisper non esegue lo script"

```bash
# Verifica permessi
ls -la ~/bin/whisper-to-claude.sh
# Dovrebbe essere: -rwxr-xr-x

# Verifica shebang
head -1 ~/bin/whisper-to-claude.sh
# Dovrebbe essere: #!/bin/bash

# Test diretto
bash ~/bin/whisper-to-claude.sh
```

### "Meetings non si aggiornano"

```bash
# Per utenti Microsoft Outlook:
# 1. Verifica che Outlook sia installato e in esecuzione
# 2. Test AppleScript per Outlook
osascript -e 'tell application "Microsoft Outlook" to get name of calendars'

# Se non funziona, dai permessi:
# System Settings → Privacy → Automation → Script Editor → Microsoft Outlook ✓
# System Settings → Privacy → Automation → Terminal → Microsoft Outlook ✓

# Per utenti macOS Calendar:
# Test AppleScript per calendario
osascript -e 'tell application "Calendar" to get name of calendars'

# Se non funziona, dai permessi:
# System Settings → Privacy → Automation → Script Editor → Calendar ✓
```

## 🔄 Manutenzione

### Aggiornamenti

```bash
# Aggiorna Claude Code
brew upgrade claude-code

# Aggiorna SuperWhisper
# (Controlla automaticamente gli aggiornamenti all'avvio)

# Aggiorna Obsidian
# Settings → About → Check for updates
```

### Backup

```bash
# Backup manuale del vault
cp -r "/path/to/VaultObsidian" "/path/to/backup/VaultObsidian-$(date +%Y%m%d)"

# Oppure usa git
cd "/path/to/VaultObsidian"
git init
git add CLAUDE.md README.md SETUP.md Templates/
git commit -m "Initial commit"
git remote add origin https://github.com/username/vault-backup.git
git push -u origin main
```

### Log Cleanup

```bash
# Pulisci log vecchi (oltre 30 giorni)
find ~/.whisper-claude.log -mtime +30 -delete
```

## 📞 Supporto

**Problemi comuni:**
- Leggi questa guida per intero
- Controlla i log: `tail -f ~/.whisper-claude.log`
- Verifica permessi macOS
- Testa ogni componente singolarmente

**Risorse:**
- [Documentazione Claude Code](https://github.com/anthropics/claude-code)
- [Community SuperWhisper](https://superwhisper.com/community)
- [Forum Obsidian](https://forum.obsidian.md/)

## 🎯 Prossimi Passi

Ora che hai configurato tutto:

1. ✅ Testa il sistema con alcune note vocali
2. ✅ Personalizza `CLAUDE.md` con le tue regole
3. ✅ Aggiungi i tuoi template in `Templates/`
4. ✅ Configura i plugin Obsidian
5. ✅ Crea backup del vault

**Divertiti con il tuo assistente vocale! 🎙️**
