#!/usr/bin/env bash
# backup.sh <directory> — makes <name>_<timestamp>.tar.gz in the current dir.
# Every run (success or failure) is logged to ~/backup.log.

set -euo pipefail

# Validate: exactly one argument, and it must be an existing directory.
if [[ $# -ne 1 || ! -d $1 ]]; then
    printf '[%s] FAILED: invalid input\n' "$(date '+%F %T')" >> ~/backup.log
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

OUT="$(basename "$1")_$(date '+%Y%m%d_%H%M%S').tar.gz"

if tar -czf "$OUT" -C "$(dirname "$1")" "$(basename "$1")"; then
    printf '[%s] SUCCESS: backed up %s to %s\n' "$(date '+%F %T')" "$1" "$OUT" >> ~/backup.log
    echo "Backup created: $OUT"
else
    printf '[%s] FAILED: tar error creating %s\n' "$(date '+%F %T')" "$OUT" >> ~/backup.log
    exit 1
fi
