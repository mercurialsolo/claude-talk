#!/bin/bash
# ClaudeTalk config reader — source this to get config_get function
# Usage:
#   source "$PLUGIN_ROOT/scripts/config.sh"
#   voice=$(config_get "voices.done" "Samantha")
#
# Config precedence (first match wins):
#   1. Project-local:  $CLAUDE_PROJECT_DIR/.claudetalk.json
#   2. User global:    ~/.config/claudetalk/config.json
#   3. Plugin defaults: defaults.json

_CT_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

config_get() {
    local key="$1"
    local default="${2:-}"

    local configs=(
        "${CLAUDE_PROJECT_DIR:-.}/.claudetalk.json"
        "$HOME/.config/claudetalk/config.json"
        "$_CT_PLUGIN_ROOT/defaults.json"
    )

    for cfg in "${configs[@]}"; do
        [ -f "$cfg" ] || continue
        local val
        val=$(python3 -c "
import json
with open('$cfg') as f:
    d = json.load(f)
keys = '$key'.split('.')
v = d
for k in keys:
    v = v[k]
print(v)
" 2>/dev/null) || continue
        if [ -n "$val" ]; then
            echo "$val"
            return 0
        fi
    done

    echo "$default"
}
