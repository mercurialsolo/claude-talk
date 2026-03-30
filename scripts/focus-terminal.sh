#!/bin/bash
# ClaudeTalk focus — bring the correct terminal tab/pane to the foreground
# Handles: multi-tab, split panes, tmux, iTerm2 sessions, standard terminals
set -uo pipefail

# Detect output target — /dev/tty if available, stdout otherwise
TTY="/dev/stdout"
if (printf '' > /dev/tty) 2>/dev/null; then
    TTY="/dev/tty"
fi

# 1. Ring terminal bell — flashes/highlights the correct tab in multi-tab setups
#    Most terminals bounce the dock icon or highlight the tab on bell
printf '\a' > "$TTY" 2>/dev/null || true

# 2. tmux: select the right pane and window if inside tmux
if [ -n "${TMUX:-}" ]; then
    PANE="${TMUX_PANE:-}"
    if [ -n "$PANE" ]; then
        tmux select-pane -t "$PANE" 2>/dev/null || true
        tmux select-window 2>/dev/null || true
    fi
fi

# 3. Activate the terminal application (brings app to foreground from other apps)
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

# 4. iTerm2: select the specific tab and session using its unique session ID
#    This finds the RIGHT tab/split in a multi-tab or split-pane iTerm2 setup
if [ "$TERM_APP" = "iTerm.app" ] && [ -n "${ITERM_SESSION_ID:-}" ]; then
    osascript -e "
        tell application \"iTerm2\"
            repeat with aWindow in windows
                repeat with aTab in tabs of aWindow
                    repeat with aSession in sessions of aTab
                        if unique ID of aSession is \"$ITERM_SESSION_ID\" then
                            select aTab
                            select aSession
                            return
                        end if
                    end repeat
                end repeat
            end repeat
        end tell
    " 2>/dev/null || true
fi
