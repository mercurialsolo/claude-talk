---
name: stuck
description: Announce when stuck after multiple attempts. Uses macOS TTS and terminal focus to draw user attention.
version: 1.0.0
---

When you've been stuck on a problem after 2-3 attempts, vocally ask for help.

## How to announce

```bash
# Speak with Junior voice (earnest, pleading)
/usr/bin/say -v Junior "I'm stuck on [problem]. Fresh perspective needed."

# Show macOS notification
osascript -e 'display notification "Stuck on [problem]" with title "Claude: Need Help"'

# Bring terminal to foreground (detect from $TERM_PROGRAM)
# iTerm.app → iTerm2, Apple_Terminal → Terminal, WarpTerminal → Warp, ghostty → Ghostty
osascript -e 'tell application "Terminal" to activate'
```

If `.claudetalk.json` exists in the project root, read voice override from `voices.stuck`.

## When to use

- After 2-3 failed attempts at solving a problem
- When you need user input to proceed
- When you've hit an ambiguous decision point

## Message style

Be specific about what you're stuck on. Keep it conversational and direct. One sentence.
