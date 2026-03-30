---
description: Ask for help — voice announcement to draw attention
argument-hint: "[what you're stuck on]"
allowed-tools: Bash(/usr/bin/say *), Bash(osascript *), Bash(git branch *)
---

Play a "need help" voice announcement to draw the user's attention. Also brings the terminal to the foreground.

Voice: Junior (earnest, pleading). Override via `.claudetalk.json` key `voices.stuck`.

If $ARGUMENTS provided, announce that. Otherwise auto-detect from `git branch --show-current` (replace hyphens with spaces).

## Announcement examples (pick one, adapt to context)

- "Alright team, I need some eyes on this. [problem]. Anyone got ideas?"
- "Heads up. I'm stuck on [problem]. If you've seen this before, throw me a line."
- "I've tried a few approaches and they all fail. [problem]. Fresh perspective needed."

## Steps

1. Get the problem description (from $ARGUMENTS or branch name)
2. Craft a specific, honest 1-2 sentence message about what you're stuck on
3. Bring terminal to focus: detect terminal from `$TERM_PROGRAM` (iTerm.app→iTerm2, Apple_Terminal→Terminal, WarpTerminal→Warp, ghostty→Ghostty), then `osascript -e 'tell application "APP" to activate'`
4. Run: `/usr/bin/say -v Junior "message"`
5. Show notification: `osascript -e 'display notification "message" with title "Claude: Need Help"'`
