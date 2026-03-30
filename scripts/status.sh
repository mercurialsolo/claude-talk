#!/bin/bash
# ClaudeTalk status — set visual indicators in the terminal tab/title
# Usage: status.sh waiting ["custom message"]
#        status.sh done ["custom message"]
#        status.sh clear
#
# Sets: terminal title, terminal bell, iTerm2 badge, tmux window name
set -euo pipefail

ACTION="${1:-clear}"
MESSAGE="${2:-}"

case "$ACTION" in
    waiting)
        TITLE="${MESSAGE:-⏳ Claude: Waiting for input}"
        ;;
    done)
        TITLE="${MESSAGE:-✅ Claude: Done — your turn}"
        ;;
    clear)
        TITLE=""
        ;;
    *)
        TITLE="$ACTION"
        ;;
esac

# 1. Set terminal title (universal — shows in tab bar of all terminals)
if [ -n "$TITLE" ]; then
    printf '\033]0;%s\007' "$TITLE" > /dev/tty 2>/dev/null || true
else
    printf '\033]0;%s\007' "${SHELL##*/}" > /dev/tty 2>/dev/null || true
fi

# 2. Ring terminal bell on non-clear (flashes/bounces the correct tab)
if [ "$ACTION" != "clear" ]; then
    printf '\a' > /dev/tty 2>/dev/null || true
fi

# 3. iTerm2 badge (floating overlay text in the terminal pane)
if [ "${TERM_PROGRAM:-}" = "iTerm.app" ]; then
    if [ -n "$TITLE" ]; then
        printf '\033]1337;SetBadgeFormat=%s\007' "$(printf '%s' "$TITLE" | base64)" > /dev/tty 2>/dev/null || true
    else
        printf '\033]1337;SetBadgeFormat=\007' > /dev/tty 2>/dev/null || true
    fi
fi

# 4. tmux — rename window to show status, or restore auto-rename
if [ -n "${TMUX:-}" ]; then
    if [ -n "$TITLE" ]; then
        tmux rename-window "$TITLE" 2>/dev/null || true
    else
        tmux set-window-option automatic-rename on 2>/dev/null || true
    fi
fi
