#!/bin/bash
# ClaudeTalk PostToolUse — celebrate git events with voice
# Fires after Bash commands, detects git commits/merges/pushes.
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
source "$PLUGIN_ROOT/scripts/config.sh"

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

# Git commit
if echo "$COMMAND" | grep -qE 'git commit'; then
    MSG=$(git log -1 --pretty=%s 2>/dev/null || echo "new commit")
    CLEAN=$(echo "$MSG" | sed 's/^[^:]*: *//')

    case "$MSG" in
        fix*|Fix*|bugfix*)  VOICE=$(config_get "voices.fix" "Daniel");       ANNOUNCE="Bug squashed. $CLEAN" ;;
        feat*|Feat*)        VOICE=$(config_get "voices.feature" "Good News"); ANNOUNCE="New feature! $CLEAN" ;;
        chore*|refactor*)   VOICE=$(config_get "voices.chore" "Fred");        ANNOUNCE="Housekeeping done. $CLEAN" ;;
        revert*|Revert*)    VOICE=$(config_get "voices.revert" "Bad News");   ANNOUNCE="Rolled back. $CLEAN" ;;
        Merge*|merge*)      VOICE=$(config_get "voices.celebrate" "Samantha"); ANNOUNCE="Merged and magnificent. $CLEAN" ;;
        *)                  VOICE=$(config_get "voices.celebrate" "Samantha"); ANNOUNCE="Committed. $MSG" ;;
    esac

    nohup bash "$PLUGIN_ROOT/scripts/notify.sh" "ClaudeTalk" "$MSG" </dev/null &>/dev/null &
    bash "$PLUGIN_ROOT/scripts/speak.sh" "$ANNOUNCE" "$VOICE"
    exit 0
fi

# Git merge
if echo "$COMMAND" | grep -qE 'git merge'; then
    VOICE=$(config_get "voices.celebrate" "Samantha")
    nohup bash "$PLUGIN_ROOT/scripts/notify.sh" "ClaudeTalk" "Branch merged" </dev/null &>/dev/null &
    bash "$PLUGIN_ROOT/scripts/speak.sh" "Branches united. Ship it!" "$VOICE"
    exit 0
fi

# Git push
if echo "$COMMAND" | grep -qE 'git push'; then
    VOICE=$(config_get "voices.release" "Superstar")
    nohup bash "$PLUGIN_ROOT/scripts/notify.sh" "ClaudeTalk" "Code pushed to remote" </dev/null &>/dev/null &
    bash "$PLUGIN_ROOT/scripts/speak.sh" "Shipped! To production and beyond." "$VOICE"
    exit 0
fi

exit 0
