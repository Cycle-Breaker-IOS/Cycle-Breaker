#!/bin/bash
# Stop and remove the cycle-breaker backup watcher.
LABEL="com.akiramartha.cyclebreaker.backup"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"

if [ -f "$PLIST" ]; then
  launchctl unload "$PLIST" 2>/dev/null || true
  rm -f "$PLIST"
  echo "Removed $PLIST"
else
  echo "No plist at $PLIST — nothing to do."
fi
echo "Done. Existing backups in ~/cycle-breaker/backups are untouched."
