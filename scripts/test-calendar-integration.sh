#!/bin/bash

# ============================================
# Calendar Integration Test Script
# ============================================
# Tests Microsoft Outlook and macOS Calendar
# integration for the "aggiorna meetings" command
# ============================================

echo "🧪 Testing Calendar Integration for Voice-to-Obsidian"
echo "======================================================"
echo ""

# === Test Microsoft Outlook ===
echo "1️⃣ Testing Microsoft Outlook..."
echo ""

# Check if Outlook is installed
if [ -d "/Applications/Microsoft Outlook.app" ]; then
    echo "✅ Microsoft Outlook is installed"
    
    # Check if Outlook is running
    if pgrep -x "Microsoft Outlook" > /dev/null; then
        echo "✅ Microsoft Outlook is running"
        
        # Test AppleScript access to Outlook
        echo "   Testing AppleScript access..."
        OUTLOOK_TEST=$(osascript -e 'tell application "Microsoft Outlook"' -e 'try' -e 'set today to current date' -e 'set tomorrow to today + 1 * days' -e 'set output to ""' -e 'set todayEvents to calendar events whose start time >= today and start time < tomorrow' -e 'repeat with evt in todayEvents' -e 'set timeStr to time string of (start time of evt)' -e 'set output to output & "- " & timeStr & " | " & subject of evt & linefeed' -e 'end repeat' -e 'return output' -e 'on error errMsg' -e 'return "ERROR: " & errMsg' -e 'end try' -e 'end tell' 2>&1)
        
        if [[ $OUTLOOK_TEST == ERROR:* ]]; then
            echo "❌ AppleScript access to Outlook failed"
            echo "   Error: $OUTLOOK_TEST"
            echo "   Fix: System Settings → Privacy & Security → Automation → Grant access to Microsoft Outlook"
            OUTLOOK_OK=false
        else
            echo "✅ AppleScript access to Outlook works!"
            if [ -z "$OUTLOOK_TEST" ]; then
                echo "   📭 No meetings found for today"
            else
                echo "   📅 Found meetings:"
                echo "$OUTLOOK_TEST"
            fi
            OUTLOOK_OK=true
        fi
    else
        echo "⚠️  Microsoft Outlook is not running"
        echo "   Please start Outlook and run this test again"
        OUTLOOK_OK=false
    fi
else
    echo "⚠️  Microsoft Outlook is not installed"
    echo "   Will use macOS Calendar as fallback"
    OUTLOOK_OK=false
fi

echo ""
echo "2️⃣ Testing macOS Calendar..."
echo ""

# Test macOS Calendar
CALENDAR_TEST=$(osascript -e 'set today to current date' -e 'set tomorrow to today + 1 * days' -e 'set output to ""' -e 'tell application "Calendar"' -e 'try' -e 'repeat with cal in calendars' -e 'set todayEvents to (every event of cal whose start date >= today and start date < tomorrow)' -e 'repeat with evt in todayEvents' -e 'set timeStr to time string of start date of evt' -e 'set output to output & "- " & timeStr & " | " & summary of evt & linefeed' -e 'end repeat' -e 'end repeat' -e 'return output' -e 'on error errMsg' -e 'return "ERROR: " & errMsg' -e 'end try' -e 'end tell' 2>&1)

if [[ $CALENDAR_TEST == ERROR:* ]]; then
    echo "❌ AppleScript access to Calendar failed"
    echo "   Error: $CALENDAR_TEST"
    echo "   Fix: System Settings → Privacy & Security → Automation → Grant access to Calendar"
    CALENDAR_OK=false
else
    echo "✅ AppleScript access to Calendar works!"
    if [ -z "$CALENDAR_TEST" ]; then
        echo "   📭 No meetings found for today"
    else
        echo "   📅 Found meetings:"
        echo "$CALENDAR_TEST"
    fi
    CALENDAR_OK=true
fi

echo ""
echo "======================================================"
echo "📊 Test Summary"
echo "======================================================"
echo ""

if [ "$OUTLOOK_OK" = true ]; then
    echo "✅ Microsoft Outlook: READY"
    echo "   Your calendar integration will use Outlook"
elif [ "$CALENDAR_OK" = true ]; then
    echo "✅ macOS Calendar: READY (fallback)"
    echo "   Your calendar integration will use macOS Calendar"
    echo "   💡 Install and configure Outlook for primary calendar support"
else
    echo "❌ No calendar source available"
    echo "   Please:"
    echo "   1. Install Microsoft Outlook OR ensure macOS Calendar is set up"
    echo "   2. Grant necessary permissions in System Settings"
    echo "   3. Run this test again"
    exit 1
fi

echo ""
echo "✅ Calendar integration is ready!"
echo "   You can now use 'aggiorna meetings' with Claude"
echo ""

exit 0
