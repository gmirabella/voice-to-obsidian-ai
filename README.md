<div align="center">
  <img src="voice-to-obsidian-icon.png" alt="Voice to Obsidian Icon" width="200"/>

  # 🎙️ Voice-to-Obsidian with Claude AI

  An intelligent system to transform voice notes into structured notes in Obsidian, using SuperWhisper for dictation and Claude Code for automatic organization.
</div>

## ✨ What It Does

This system allows you to:
- **Dictate voice notes** with SuperWhisper
- **Automatically organize** content based on context
- **Manage tasks, journal entries, projects** without thinking about where to put things
- **Sync meetings** from macOS Calendar

Claude analyzes the dictated content and automatically catalogs it in the right location in your Obsidian vault.

## 🎯 Usage Examples

**You say:** "I need to call Mark by Friday"
→ Claude adds the task to today's note with a due date

**You say:** "Today I felt very productive"
→ Claude adds the note to today's journal

**You say:** "Idea for project X: use an interactive dashboard"
→ Claude adds the idea to the project file

**You say:** "Update meetings"
→ Claude reads the calendar (Outlook or macOS Calendar) and creates today's meeting list

## 📋 Prerequisites

- **macOS** (for Calendar integration via AppleScript)
- **[Obsidian](https://obsidian.md/)** - Markdown notes editor
- **[SuperWhisper](https://superwhisper.com/)** - Local voice transcription
- **[Claude Code](https://claude.ai/download)** - Claude CLI for automation

Important: Install and enable these Obsidian community plugins: Tasks, Templater, Dataview (enable javascript) 

## 🚀 Installation

### 1. Obsidian Setup

```bash
# Clone this repository
git clone https://github.com/gmirabella/voice-to-obsidian-ai

# Or download and copy files to your Obsidian vault
```

**Required folder structure:**
```
VaultObsidian/
├── Daily Journal/     # Daily notes (YYYY-MM-DD.md)
├── Projects/          # Project files
├── Work/              # Work notes
├── Health/            # Health notes (optional)
├── Templates/         # Note templates
└── CLAUDE.md          # Instructions for Claude (IMPORTANT!)
```

### 2. SuperWhisper Setup

1. Download and install [SuperWhisper](https://superwhisper.com/)
2. Configure the shortcut (recommended: `Cmd+Shift+Space`)
3. **Set the action:** Instead of "Type", select "Copy to clipboard"
4. **Configure post-recording command:**
   - Go to Preferences → Commands
   - Add a command that executes:
   ```bash
   echo "$(pbpaste)" | /usr/local/bin/claude-code ask "$(cat)"
   ```
   - Or use a helper script (see below)

### 3. Claude Code Setup

```bash
# Install Claude Code
brew install claude-code

# Configure Claude in the vault
cd /path/to/VaultObsidian

# Verify that the CLAUDE.md file is present
# This file contains the instructions for Claude
```

**Important:** The `CLAUDE.md` file in the vault root contains all cataloging rules. Claude automatically reads it when working in the vault.

**Testing Calendar Integration:**
```bash
# Test your calendar setup (Outlook + macOS Calendar)
bash scripts/test-calendar-integration.sh
```

### 4. Helper Script (Optional but Recommended)

Create a script to simplify SuperWhisper + Claude integration:

```bash
# Create the file ~/bin/whisper-to-claude.sh
mkdir -p ~/bin
cat > ~/bin/whisper-to-claude.sh << 'EOF'
#!/bin/bash
# Script to send SuperWhisper transcriptions to Claude

VAULT_PATH="$HOME/Documents/Obsidian Vault"
TRANSCRIPTION="$1"

# If no text is passed, read from clipboard
if [ -z "$TRANSCRIPTION" ]; then
    TRANSCRIPTION=$(pbpaste)
fi

# Go to vault and send to Claude
cd "$VAULT_PATH"
echo "$TRANSCRIPTION" | claude code

# Optional: notification
osascript -e 'display notification "Note added to Obsidian" with title "Claude"'
EOF

chmod +x ~/bin/whisper-to-claude.sh
```

Configure SuperWhisper to run this script after each transcription.

## 📖 How It Works

### Automatic Cataloging Rules

Claude analyzes the dictated content and applies these rules:

#### 🔲 Tasks
**Trigger:** "need to", "task", "to do", "remind me", "by", "due", "deadline"

**Action:** Adds task to today's note in `Daily Journal/YYYY-MM-DD.md`

**Format:** `- [ ] description 📅 YYYY-MM-DD`

#### 📔 Journal / Thoughts
**Trigger:** "today I", "I feel", "reflection", "thought", "journal", "diary"

**Action:** Adds to the Notes section of the day

#### 📁 Projects
**Trigger:** "project", "idea for", "for the project"

**Action:** Creates/updates file in `Projects/ProjectName.md`

**Note:** Tasks related to projects still go in the Daily Journal (not duplicated)

#### 📝 General Notes
**Trigger:** Everything else

**Action:** Adds to the current day's Notes

### Special Command: Meetings

When you say **"update meetings"**, Claude:
1. Reads your calendar (Microsoft Outlook or macOS Calendar)
2. Extracts all today's meetings
3. Creates/updates the `Meetings Today.md` file

**Supported calendars:**
- Microsoft Outlook (primary)
- macOS Calendar (fallback)

## 🎨 Daily Note Template

Daily notes follow this format:

```markdown
# YYYY-MM-DD

## Task
- [ ] Task to complete 📅 YYYY-MM-DD

## Meetings
- HH:MM | Meeting name

## Note
- Various annotations
- Thoughts
- Reflections

## Journal
Personal diary of the day
```

## 🔧 Customization

### Modify Cataloging Rules

Edit the `CLAUDE.md` file to change how Claude organizes notes:

```markdown
### Your New Category
If contains: "keyword1", "keyword2"
→ Action to perform
→ Specific format
```

### Add New Folders

Add folders to the vault and document in `CLAUDE.md`:

```markdown
## Vault Structure
- `Daily Journal/` - Daily notes
- `YourNewFolder/` - Description
```

### Change SuperWhisper Shortcut

Modify the shortcut in SuperWhisper → Preferences → Hotkey

## 🤝 Recommended Workflow

1. **Press `Cmd+Shift+Space`** (or your shortcut)
2. **Dictate your note**
3. **SuperWhisper transcribes** and sends to Claude
4. **Claude analyzes and catalogs** automatically
5. **Receive confirmation** of where the note was saved

## 🐛 Troubleshooting

### Claude doesn't respond
- Verify Claude Code is installed: `claude-code --version`
- Check you're in the vault: `cd /path/to/vault`
- Verify `CLAUDE.md` exists in the root

### SuperWhisper doesn't execute the script
- Check permissions: `chmod +x ~/bin/whisper-to-claude.sh`
- Verify the path in SuperWhisper Settings
- Check SuperWhisper logs

### Notes aren't cataloged correctly
- Verify folders exist (`Daily Journal/`, `Projects/`, etc.)
- Check that the `CLAUDE.md` file is updated
- Try dictating more explicitly ("task: do X" instead of "do X")

### Meetings don't update
- **For Outlook users:**
  - Ensure Microsoft Outlook is installed and running
  - Verify Outlook permissions: System Settings → Privacy & Security → Automation
  - Grant Script Editor/Terminal access to Microsoft Outlook
- **For macOS Calendar users:**
  - Verify Calendar permissions: System Settings → Privacy → Automation
  - Make sure the script has calendar access

## 📝 Limitations

- **macOS only**: Calendar integration uses AppleScript for both Outlook and macOS Calendar
- **Language-specific**: Optimized for English and Italian triggers (but customizable)
- **Internet connection**: Claude Code requires connection to work
- **Calendar support**: Works with Microsoft Outlook (preferred) and macOS Calendar (fallback)

## 🔮 Future Ideas

- [ ] Multi-language support
- [x] Microsoft Outlook integration
- [ ] Google Calendar integration
- [ ] Customizable templates per note type
- [ ] Automatic weekly summary export
- [ ] Todoist/Things integration
- [ ] AI-powered semantic search in notes

## 📄 License

MIT License - Feel free to use, modify, and share!

## 🙏 Credits

- **Obsidian** - [obsidian.md](https://obsidian.md/)
- **SuperWhisper** - [superwhisper.com](https://superwhisper.com/)
- **Claude** - [claude.ai](https://claude.ai/)

## 💬 Support

If you have questions or suggestions:
- Open an Issue on GitHub
- Contribute with a Pull Request
- Share your setup!

---

**Made with 🎙️ by Graziana**
