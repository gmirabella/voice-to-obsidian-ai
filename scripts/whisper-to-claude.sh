#!/bin/bash

# ============================================
# Voice-to-Obsidian Bridge Script
# ============================================
# Collega SuperWhisper con Claude Code per
# catalogare automaticamente note vocali
# ============================================

# === CONFIGURAZIONE ===
# Modifica questo path con il percorso del tuo vault
VAULT_PATH="$HOME/Library/CloudStorage/OneDrive-WPP365x02/Documents/Obsidian Vault"

# File di log (opzionale, commentare se non serve)
LOG_FILE="$HOME/.whisper-claude.log"

# Abilita notifiche macOS
ENABLE_NOTIFICATIONS=true

# === FUNZIONI ===

# Funzione di log
log() {
    if [ -n "$LOG_FILE" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    fi
}

# Funzione per notifiche macOS
notify() {
    local title="$1"
    local message="$2"

    if [ "$ENABLE_NOTIFICATIONS" = true ]; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null
    fi
}

# === SCRIPT PRINCIPALE ===

log "=== Inizio esecuzione script ==="

# Leggi trascrizione dagli appunti di sistema
TRANSCRIPTION=$(pbpaste)

# Verifica che ci sia del testo
if [ -z "$TRANSCRIPTION" ]; then
    log "ERRORE: Nessun testo negli appunti"
    notify "Errore SuperWhisper" "Nessun testo trascritto"
    exit 1
fi

log "Trascrizione ricevuta (${#TRANSCRIPTION} caratteri): ${TRANSCRIPTION:0:100}..."

# Verifica che il vault esista
if [ ! -d "$VAULT_PATH" ]; then
    log "ERRORE: Vault non trovato: $VAULT_PATH"
    notify "Errore Claude" "Vault Obsidian non trovato"
    exit 1
fi

# Vai nella directory del vault
cd "$VAULT_PATH" || {
    log "ERRORE: Impossibile accedere al vault"
    notify "Errore Claude" "Impossibile accedere al vault"
    exit 1
}

log "Accesso al vault: OK"

# Verifica che claude-code sia installato
if ! command -v claude-code &> /dev/null; then
    log "ERRORE: claude-code non trovato nel PATH"
    notify "Errore Claude" "Claude Code non installato"
    exit 1
fi

log "Claude Code trovato: $(which claude-code)"

# Invia la trascrizione a Claude
log "Invio a Claude Code..."
CLAUDE_OUTPUT=$(echo "$TRANSCRIPTION" | claude-code 2>&1)
CLAUDE_EXIT_CODE=$?

# Log dell'output completo
log "Output Claude: $CLAUDE_OUTPUT"

# Verifica il risultato
if [ $CLAUDE_EXIT_CODE -eq 0 ]; then
    log "Successo: nota catalogata correttamente"
    notify "Claude ✓" "Nota aggiunta a Obsidian"
else
    log "ERRORE: Claude exit code $CLAUDE_EXIT_CODE"
    notify "Errore Claude" "Errore durante la catalogazione"
    exit 1
fi

log "=== Fine esecuzione script ==="
exit 0
