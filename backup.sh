#!/usr/bin/env bash
#
# backup.sh <directory>
# Creates a timestamped .tar.gz archive of <directory>.
# Every run (success or failure) is logged to /var/log/backup.log
# (falls back to ~/backup.log if /var/log is not writable).

set -euo pipefail

LOG_FILE="/var/log/backup.log"
# Fallback when not run as root (cron runs as the owner of the crontab).
[[ -w /var/log ]] || LOG_FILE="$HOME/backup.log"

# Log a line with a timestamp. Safe even before argument validation.
log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_FILE"
}

# --- Input validation -------------------------------------------------------
if [[ $# -ne 1 ]]; then
    log "FAILED: expected exactly 1 argument (a directory path)"
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

SRC_DIR="$1"

if [[ ! -d "$SRC_DIR" ]]; then
    log "FAILED: '$SRC_DIR' is not an existing directory"
    echo "Error: '$SRC_DIR' is not an existing directory" >&2
    exit 1
fi

# --- Backup -----------------------------------------------------------------
# Archive destination: parent of the source dir, named after it.
SRC_DIR="${SRC_DIR%/}"                       # strip trailing slash if present
PARENT_DIR="$(dirname "$SRC_DIR")"
DIR_NAME="$(basename "$SRC_DIR")"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
ARCHIVE="$PARENT_DIR/${DIR_NAME}_${TIMESTAMP}.tar.gz"

if tar -czf "$ARCHIVE" -C "$PARENT_DIR" "$DIR_NAME"; then
    log "SUCCESS: backed up '$SRC_DIR' to '$ARCHIVE'"
    echo "Backup created: $ARCHIVE"
else
    log "FAILED: tar exited with an error while creating '$ARCHIVE'"
    echo "Error: backup failed" >&2
    exit 1
fi
