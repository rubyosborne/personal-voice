#!/usr/bin/env bash
# Install (or refresh) the weekly launchd job that drains the voice inbox.
# Runs scripts/ingest-run.sh every Monday at 17:00 local time. launchd runs a
# missed Monday on the next wake, so the Mac doesn't need to be awake at 5pm.
#
#   ./scripts/install-schedule.sh           # install / reload
#   ./scripts/install-schedule.sh --remove  # uninstall
#
# Run once per machine (launchd agents are per-user, not stored in the repo).

set -euo pipefail

LABEL="com.ruby.voice-ingest"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
REPO="/Users/rubyosborne/Documents/Claude/Projects/personal-voice"
RUNNER="$REPO/scripts/ingest-run.sh"
DOMAIN="gui/$(id -u)"

if [ "${1:-}" = "--remove" ]; then
  launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
  rm -f "$PLIST"
  echo "Removed $LABEL"
  exit 0
fi

mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-lc</string>
    <string>$RUNNER</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Weekday</key><integer>1</integer>   <!-- 1 = Monday -->
    <key>Hour</key><integer>17</integer>     <!-- 17:00 local -->
    <key>Minute</key><integer>0</integer>
  </dict>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>$HOME/.local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    <key>HOME</key><string>$HOME</string>
  </dict>
  <key>StandardOutPath</key><string>$HOME/Library/Logs/voice-ingest.out.log</string>
  <key>StandardErrorPath</key><string>$HOME/Library/Logs/voice-ingest.err.log</string>
</dict>
</plist>
EOF

# Reload cleanly (bootout first in case it's already loaded).
launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
launchctl bootstrap "$DOMAIN" "$PLIST"

echo "Installed $LABEL — runs Mondays at 17:00 (missed runs fire on next wake)."
echo "Test it now: launchctl kickstart -k $DOMAIN/$LABEL"
echo "Logs: ~/Library/Logs/voice-ingest.log"
