#!/bin/bash
# ClaudeTalk notify — show a macOS notification
# Usage: notify.sh "title" "message"
set -euo pipefail

MESSAGE="${2:-}"
TITLE="${1:-Claude Code}"

[ -z "$MESSAGE" ] && exit 0

SAFE_TITLE=$(printf '%s' "$TITLE" | sed 's/\\/\\\\/g; s/"/\\"/g')
SAFE_MSG=$(printf '%s' "$MESSAGE" | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript -e "display notification \"$SAFE_MSG\" with title \"$SAFE_TITLE\""
