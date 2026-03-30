---
name: stuck
description: Announce when stuck after multiple attempts. Uses macOS TTS, terminal focus, and status indicator to draw user attention.
version: 1.0.0
---

When you've been stuck on a problem after 2-3 attempts, vocally ask for help.

## How to announce

Run all of these in a single bash command:

```bash
# 1. Set status indicator — marks this tab as needing attention
#    Terminal title (all terminals) + iTerm2 badge + tmux window name
printf '\033]0;⏳ Claude: Waiting for input\007' > /dev/tty 2>/dev/null
printf '\a' > /dev/tty 2>/dev/null

# 2. iTerm2 badge (if in iTerm2)
if [ "${TERM_PROGRAM:-}" = "iTerm.app" ]; then
    printf '\033]1337;SetBadgeFormat=%s\007' "$(printf '⏳ Waiting' | base64)" > /dev/tty 2>/dev/null
fi

# 3. tmux window rename (if in tmux)
if [ -n "${TMUX:-}" ]; then
    tmux rename-window "⏳ Claude: Waiting" 2>/dev/null
fi

# 4. Bring terminal to foreground
osascript -e 'tell application "Terminal" to activate' 2>/dev/null

# 5. Speak
/usr/bin/say -v Junior "I'm stuck on [problem]. Fresh perspective needed."

# 6. Notify
osascript -e 'display notification "Stuck on [problem]" with title "Claude: Need Help"'
```

Detect the correct terminal app from `$TERM_PROGRAM` for step 4:
- `iTerm.app` → "iTerm2"
- `Apple_Terminal` → "Terminal"
- `WarpTerminal` → "Warp"
- `ghostty` → "Ghostty"

If `.claudetalk.json` exists in the project root, read voice override from `voices.stuck`.

## When to use

- After 2-3 failed attempts at solving a problem
- When you need user input to proceed
- When you've hit an ambiguous decision point

## Message style

Be specific about what you're stuck on. Keep it conversational and direct. One sentence.
