# Outlook Calendar Integration - Migration Guide

## What Changed?

We've added **Microsoft Outlook** support to the calendar integration feature. Previously, the system only worked with macOS Calendar. Now it supports both!

## New Behavior

When you say **"aggiorna meetings"** or **"update meetings"**, the system will:

1. **First, try Microsoft Outlook** (if installed and running)
2. **Fall back to macOS Calendar** (if Outlook is not available)
3. **Create/update** `Meetings Today.md` with your meetings

## For Existing Users

If you're already using macOS Calendar, **nothing changes**! The system will continue to work exactly as before. Outlook is tried first, but if it's not available, macOS Calendar will be used automatically.

## For New Outlook Users

### Requirements

- macOS with Microsoft Outlook installed
- Outlook must be running when you use the "update meetings" command

### Setup Steps

1. **Install Microsoft Outlook** (if not already installed)

2. **Grant Permissions:**
   - Go to: **System Settings → Privacy & Security → Automation**
   - Enable these permissions:
     - `SuperWhisper → Microsoft Outlook ✓`
     - `Terminal → Microsoft Outlook ✓`
     - `Script Editor → Microsoft Outlook ✓`

3. **Test the Integration:**
   ```bash
   cd "/path/to/your/VaultObsidian"
   bash scripts/test-calendar-integration.sh
   ```

4. **Try it out:**
   - Press your SuperWhisper hotkey (e.g., `Cmd+Shift+Space`)
   - Say: "aggiorna meetings" or "update meetings"
   - Check `Meetings Today.md` for your meetings

## Troubleshooting

### Outlook Integration Not Working?

Run the test script to diagnose:
```bash
bash scripts/test-calendar-integration.sh
```

Common issues:

1. **Outlook is not running**
   - Solution: Start Microsoft Outlook before using the command

2. **Permission denied errors**
   - Solution: Grant automation permissions in System Settings

3. **No meetings showing**
   - Check if you have events in your Outlook calendar for today
   - Verify the calendar is synced and not offline

### Still Using macOS Calendar?

No problem! The system automatically falls back to macOS Calendar if:
- Outlook is not installed
- Outlook is not running
- Outlook permission is denied

Just make sure Calendar.app has the necessary permissions.

## Technical Details

### AppleScript Commands

**For Outlook:**
```applescript
tell application "Microsoft Outlook"
    try
        set today to current date
        set tomorrow to today + 1 * days
        set output to ""
        set todayEvents to calendar events whose start time >= today and start time < tomorrow
        repeat with evt in todayEvents
            set timeStr to time string of (start time of evt)
            set output to output & "- " & timeStr & " | " & subject of evt & linefeed
        end repeat
        return output
    on error
        return ""
    end try
end tell
```

**For macOS Calendar:**
```applescript
set today to current date
set tomorrow to today + 1 * days
set output to ""
tell application "Calendar"
    try
        repeat with cal in calendars
            set todayEvents to (every event of cal whose start date >= today and start date < tomorrow)
            repeat with evt in todayEvents
                set timeStr to time string of start date of evt
                set output to output & "- " & timeStr & " | " & summary of evt & linefeed
            end repeat
        end repeat
        return output
    on error
        return ""
    end try
end tell
```

## Benefits of Outlook Integration

1. **Work Calendar Integration**: Most corporate users use Outlook for work calendars
2. **Unified Experience**: Use the same system for both personal and work meetings
3. **Automatic Fallback**: No configuration needed - works with whatever you have
4. **Better Meeting Details**: Outlook provides richer meeting metadata

## Support

If you encounter any issues:

1. Run the test script: `bash scripts/test-calendar-integration.sh`
2. Check the logs: `tail -f ~/.whisper-claude.log`
3. Verify permissions in System Settings
4. Open an issue on GitHub with the error details

## Changelog

- ✅ Added Microsoft Outlook support via AppleScript
- ✅ Implemented automatic fallback to macOS Calendar
- ✅ Added comprehensive test script
- ✅ Updated documentation (README, SETUP, EXAMPLES, CLAUDE.md)
- ✅ Added error handling for both calendar sources

---

**Enjoy your enhanced calendar integration! 📅**
