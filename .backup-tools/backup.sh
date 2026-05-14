#!/bin/bash
# Auto-backup script for ~/cycle-breaker/index.html
# Triggered by launchd whenever index.html changes.
# Keeps the 10 most recent backups; older ones are pruned.

set -euo pipefail

SRC="$HOME/cycle-breaker/index.html"
BACKUP_DIR="$HOME/cycle-breaker/backups"
LOG="$HOME/cycle-breaker/.backup-tools/backup.log"
KEEP=10

mkdir -p "$BACKUP_DIR"

# Bail out quietly if the source file is missing
if [ ! -f "$SRC" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] source missing, skipping" >> "$LOG"
  exit 0
fi

TS="$(date '+%Y-%m-%d_%H-%M')"
DEST="$BACKUP_DIR/index_backup_${TS}.html"

# If a backup with this exact minute already exists and is identical, skip.
if [ -f "$DEST" ] && cmp -s "$SRC" "$DEST"; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] no change since last backup, skipping" >> "$LOG"
  exit 0
fi

# Find the newest existing backup; if it's identical to current, skip.
LATEST="$(ls -1t "$BACKUP_DIR"/index_backup_*.html 2>/dev/null | head -n 1 || true)"
if [ -n "$LATEST" ] && cmp -s "$SRC" "$LATEST"; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] identical to latest backup ($LATEST), skipping" >> "$LOG"
  exit 0
fi

cp -p "$SRC" "$DEST"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] backed up -> $DEST" >> "$LOG"

# Prune: keep the $KEEP newest backups, delete the rest
cd "$BACKUP_DIR"
ls -1t index_backup_*.html 2>/dev/null | tail -n +$((KEEP + 1)) | while read -r OLD; do
  rm -f -- "$OLD"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] pruned -> $OLD" >> "$LOG"
done

exit 0
