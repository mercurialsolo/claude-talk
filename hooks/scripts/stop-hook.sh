#!/bin/bash
# ClaudeTalk Stop hook — notify on long tasks or when waiting for user input
# Fires when: task ran longer than min_task_seconds OR Claude asked a question.
# Kept lightweight (no config.sh) to stay within hook timeout.

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

INPUT=$(cat)

# Parse session_id and transcript_path in one python3 call
eval "$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(f'SESSION_ID={d.get(\"session_id\",\"unknown\")}')
    print(f'TRANSCRIPT={d.get(\"transcript_path\",\"\")}')
except:
    print('SESSION_ID=unknown')
    print('TRANSCRIPT=')
" 2>/dev/null)"

# Read config once
CONFIG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claudetalk.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$HOME/.config/claudetalk/config.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/defaults.json"

eval "$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    d = json.load(f)
print(f'MIN_SECONDS={d.get(\"min_task_seconds\", 120)}')
print(f'VOICE_DONE={d.get(\"voices\",{}).get(\"done\",\"Samantha\")}')
print(f'VOICE_STUCK={d.get(\"voices\",{}).get(\"stuck\",\"Junior\")}')
" 2>/dev/null || echo -e 'MIN_SECONDS=120\nVOICE_DONE=Samantha\nVOICE_STUCK=Junior')"

# Check if Claude's last message is a question (waiting for user input)
WAITING=false
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    # Get the last assistant text content, check if it ends with ?
    LAST_TEXT=$(python3 -c "
import json, sys
lines = open('$TRANSCRIPT').readlines()
# Walk backwards to find last assistant message
for line in reversed(lines):
    try:
        msg = json.loads(line)
        if msg.get('role') == 'assistant':
            # Extract text from content blocks
            content = msg.get('content', [])
            for block in reversed(content):
                if isinstance(block, dict) and block.get('type') == 'text':
                    text = block.get('text', '').strip()
                    if text:
                        print(text[-1])
                        sys.exit(0)
            break
    except:
        continue
" 2>/dev/null)
    if [ "$LAST_TEXT" = "?" ]; then
        WAITING=true
    fi
fi

# Check elapsed time
START_FILE="/tmp/claudetalk/session-${SESSION_ID}.start"
LONG_TASK=false

if [ -f "$START_FILE" ]; then
    START_TIME=$(cat "$START_FILE")
    NOW=$(date +%s)
    ELAPSED=$((NOW - START_TIME))
    rm -f "$START_FILE"

    if [ "$ELAPSED" -ge "$MIN_SECONDS" ]; then
        LONG_TASK=true
    fi
fi

# Skip if short task AND not waiting for input
if [ "$LONG_TASK" = "false" ] && [ "$WAITING" = "false" ]; then
    echo '{"decision": "approve"}'
    exit 0
fi

# Announce — different message for waiting vs done
bash "$PLUGIN_ROOT/scripts/focus-terminal.sh" 2>/dev/null

if [ "$WAITING" = "true" ]; then
    bash "$PLUGIN_ROOT/scripts/status.sh" "waiting" 2>/dev/null
    /usr/bin/say -v "$VOICE_STUCK" "I have a question for you."
else
    bash "$PLUGIN_ROOT/scripts/status.sh" "done" 2>/dev/null
    /usr/bin/say -v "$VOICE_DONE" "Done. Your turn."
fi

echo '{"decision": "approve"}'
exit 0
