#!/bin/bash
# ClaudeTalk Stop hook — announce completion for long-running tasks
# Skips voice if task was shorter than min_task_seconds (default 30s).
# Uses lock to prevent multiple agents speaking at once.
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
source "$PLUGIN_ROOT/scripts/config.sh"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('session_id', 'unknown'))
except:
    print('unknown')
" 2>/dev/null)

# Check elapsed time — skip short tasks
MIN_SECONDS=$(config_get "min_task_seconds" "30")
START_FILE="/tmp/claudetalk/session-${SESSION_ID}.start"

if [ -f "$START_FILE" ]; then
    START_TIME=$(cat "$START_FILE")
    NOW=$(date +%s)
    ELAPSED=$((NOW - START_TIME))
    rm -f "$START_FILE"

    if [ "$ELAPSED" -lt "$MIN_SECONDS" ]; then
        echo '{"decision": "approve"}'
        exit 0
    fi
fi

# Long-running task — set status indicator, announce, notify, and bring terminal to focus
VOICE=$(config_get "voices.done" "Samantha")
bash "$PLUGIN_ROOT/scripts/status.sh" "done" </dev/null &>/dev/null &
bash "$PLUGIN_ROOT/scripts/focus-terminal.sh" </dev/null &>/dev/null &
bash "$PLUGIN_ROOT/scripts/speak.sh" "Done. Your turn." "$VOICE" </dev/null &>/dev/null &
bash "$PLUGIN_ROOT/scripts/notify.sh" "Claude Code" "Task complete — ready for input" </dev/null &>/dev/null &

echo '{"decision": "approve"}'
exit 0
