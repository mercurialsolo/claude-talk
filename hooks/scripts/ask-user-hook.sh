#!/bin/bash
# ClaudeTalk AskUserQuestion hook — notify when Claude needs user input
# Fires after Claude calls AskUserQuestion tool.
# Sets "waiting" status indicator, focuses terminal, and speaks.

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

CONFIG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claudetalk.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$HOME/.config/claudetalk/config.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/defaults.json"

# Enabled check only — this hook is critical (fires in all verbosity modes)
ENABLED=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    print(json.load(f).get('enabled', True))
" 2>/dev/null || echo True)
[ "$ENABLED" = "False" ] && exit 0

# Set status + focus + speak
bash "$PLUGIN_ROOT/scripts/status.sh" "waiting" 2>/dev/null
bash "$PLUGIN_ROOT/scripts/focus-terminal.sh" 2>/dev/null

VOICE=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    print(json.load(f).get('voices',{}).get('stuck','Junior'))
" 2>/dev/null || echo Junior)

/usr/bin/say -v "$VOICE" "I have a question for you."

exit 0
