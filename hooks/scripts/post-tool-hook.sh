#!/bin/bash
# ClaudeTalk PostToolUse — celebrate git events with voice
# Fires after Bash commands, detects git commits/merges/pushes.
# Kept lightweight (no config.sh) to stay within hook timeout.

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except:
    pass
" 2>/dev/null)

[ -z "$COMMAND" ] && exit 0

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Read config once if it exists
CONFIG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claudetalk.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$HOME/.config/claudetalk/config.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/defaults.json"

# Check enabled + verbosity (this hook requires "normal" or "verbose")
eval "$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    d = json.load(f)
print(f'ENABLED={d.get(\"enabled\", True)}')
print(f'VERBOSITY={d.get(\"verbosity\", \"normal\")}')
" 2>/dev/null || echo -e 'ENABLED=True\nVERBOSITY=normal')"

[ "$ENABLED" = "False" ] && exit 0
[ "$VERBOSITY" = "quiet" ] && exit 0

read_voice() {
    local key="$1" default="$2"
    local val
    val=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    print(json.load(f).get('voices',{}).get('$key',''))
" 2>/dev/null)
    echo "${val:-$default}"
}

# Git commit
if echo "$COMMAND" | grep -q 'git commit'; then
    MSG=$(git log -1 --pretty=%s 2>/dev/null || echo "new commit")
    CLEAN=$(echo "$MSG" | sed 's/^[^:]*: *//')

    case "$MSG" in
        fix*|Fix*|bugfix*)  VOICE=$(read_voice fix Daniel);       ANNOUNCE="Bug squashed. $CLEAN" ;;
        feat*|Feat*)        VOICE=$(read_voice feature "Good News"); ANNOUNCE="New feature! $CLEAN" ;;
        chore*|refactor*)   VOICE=$(read_voice chore Fred);        ANNOUNCE="Housekeeping done. $CLEAN" ;;
        revert*|Revert*)    VOICE=$(read_voice revert "Bad News"); ANNOUNCE="Rolled back. $CLEAN" ;;
        Merge*|merge*)      VOICE=$(read_voice celebrate Samantha); ANNOUNCE="Merged and magnificent. $CLEAN" ;;
        *)                  VOICE=$(read_voice celebrate Samantha); ANNOUNCE="Committed. $MSG" ;;
    esac

    /usr/bin/say -v "$VOICE" "$ANNOUNCE"
    exit 0
fi

# Git merge
if echo "$COMMAND" | grep -q 'git merge'; then
    VOICE=$(read_voice celebrate Samantha)
    /usr/bin/say -v "$VOICE" "Branches united. Ship it!"
    exit 0
fi

# Git push
if echo "$COMMAND" | grep -q 'git push'; then
    VOICE=$(read_voice release Superstar)
    /usr/bin/say -v "$VOICE" "Shipped! To production and beyond."
    exit 0
fi

exit 0
