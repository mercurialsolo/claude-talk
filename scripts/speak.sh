#!/bin/bash
# ClaudeTalk TTS — speak with lock to prevent overlapping agents
# Usage: speak.sh "message" [voice] [rate]
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$PLUGIN_ROOT/scripts/config.sh"

MESSAGE="${1:-}"
VOICE="${2:-$(config_get "voices.done" "Samantha")}"
RATE="${3:-$(config_get "rate" "")}"

[ -z "$MESSAGE" ] && exit 0

# Check if enabled
ENABLED=$(config_get "enabled" "true")
[ "$ENABLED" != "true" ] && exit 0

# Lock to prevent multiple agents speaking simultaneously
LOCK="/tmp/claudetalk-speaking.lock"
if ! mkdir "$LOCK" 2>/dev/null; then
    exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

ARGS=(-v "$VOICE")
[ -n "$RATE" ] && ARGS+=(-r "$RATE")
ARGS+=("$MESSAGE")

/usr/bin/say "${ARGS[@]}"
