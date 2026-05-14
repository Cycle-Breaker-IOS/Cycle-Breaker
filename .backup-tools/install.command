#!/bin/bash
# Double-click this file in Finder to install the auto-backup watcher.
# It copies the launchd plist into ~/Library/LaunchAgents and loads it.

set -e

LABEL="com.akiramartha.cyclebreaker.backup"
SRC_PLIST="$HOME/cycle-breaker/.backup-tools/${LABEL}.plist"
DEST_PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"

echo "Installing cycle-breaker auto-backup watcher..."
echo

if [ ! -f "$SRC_PLIST" ]; then
  echo "ERROR: missing $SRC_PLIST"
  echo "Re-run the Claude setup."
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents"

# If a previous version is loaded, unload it first
if launchctl list | grep -q "$LABEL"; then
  echo "Unloading previous version..."
  launchctl unload "$DEST_PLIST" 2>/dev/null || true
fi

cp "$SRC_PLIST" "$DEST_PLIST"
echo "Copied plist -> $DEST_PLIST"

launchctl load "$DEST_PLIST"
echo "Loaded launchd job: $LABEL"
echo

if launchctl list | grep -q "$LABEL"; then
  echo "SUCCESS. Watching ~/cycle-breaker/index.html"
  echo "Backups go to ~/cycle-breaker/backups/ (keeps last 10)."
  echo "Logs: ~/cycle-breaker/.backup-tools/backup.log"
  echo
  echo "To uninstall later: double-click .backup-tools/uninstall.command"
else
  echo "WARNING: job did not appear in launchctl list."
  echo "Check ~/cycle-breaker/.backup-tools/launchd.err.log"
fi

echo
read -n 1 -s -r -p "Press any key to close..."
