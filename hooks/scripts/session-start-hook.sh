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

mkdir -p /tmp/claudetalk
echo "$(date +%s)" > "/tmp/claudetalk/session-${SESSION_ID}.start"

exit 0
