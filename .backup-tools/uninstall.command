#!/bin/bash
# Double-click this in Finder to stop and remove the auto-backup watcher.
LABEL="com.akiramartha.cyclebreaker.backup"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"

if [ -f "$PLIST" ]; then
  launchctl unload "$PLIST" 2>/dev/null || true
  rm -f "$PLIST"
  echo "Removed $PLIST"
  echo "Watcher stopped."
else
  echo "No plist at $PLIST — nothing to do."
fi
echo "Existing backups in ~/cycle-breaker/backups are untouched."
echo
read -n 1 -s -r -p "Press any key to close..."
