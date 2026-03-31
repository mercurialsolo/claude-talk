#!/bin/bash
# ClaudeTalk Stop hook — announce completion for long-running tasks
# Skips voice if task was shorter than min_task_seconds.
# Kept lightweight (no config.sh) to stay within hook timeout.

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('session_id', 'unknown'))
except:
    print('unknown')
" 2>/dev/null)

# Read config once if it exists
CONFIG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claudetalk.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$HOME/.config/claudetalk/config.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/defaults.json"

MIN_SECONDS=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    print(json.load(f).get('min_task_seconds', 30))
" 2>/dev/null || echo 30)

VOICE=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    print(json.load(f).get('voices',{}).get('done','Samantha'))
" 2>/dev/null || echo Samantha)

# Check elapsed time — skip short tasks
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

# Long-running task — status, focus, speak
bash "$PLUGIN_ROOT/scripts/status.sh" "done" 2>/dev/null
bash "$PLUGIN_ROOT/scripts/focus-terminal.sh" 2>/dev/null
/usr/bin/say -v "$VOICE" "Done. Your turn."

echo '{"decision": "approve"}'
exit 0
