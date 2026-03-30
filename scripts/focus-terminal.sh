#!/bin/bash
# ClaudeTalk focus — bring the hosting terminal to the foreground
set -euo pipefail

TERM_APP="${TERM_PROGRAM:-}"

case "$TERM_APP" in
    iTerm*|iTerm.app)   APP="iTerm2" ;;
    Apple_Terminal)      APP="Terminal" ;;
    WarpTerminal)        APP="Warp" ;;
    ghostty)             APP="Ghostty" ;;
    kitty)               APP="kitty" ;;
    alacritty)           APP="Alacritty" ;;
    *)                   APP="Terminal" ;;
esac

osascript -e "tell application \"$APP\" to activate" 2>/dev/null || true
