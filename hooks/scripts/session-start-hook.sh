#!/bin/bash
# ClaudeTalk SessionStart — record start time for elapsed-time gating
set -euo pipefail

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('session_id', 'unknown'))
except:
    print('unknown')
" 2>/dev/null)

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

mkdir -p /tmp/claudetalk
echo "$(date +%s)" > "/tmp/claudetalk/session-${SESSION_ID}.start"

# Clear any leftover status indicator from a previous session
bash "$PLUGIN_ROOT/scripts/status.sh" "clear" </dev/null &>/dev/null &

exit 0
