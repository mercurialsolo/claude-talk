---
description: Ask for help — voice announcement + status indicator to draw attention
argument-hint: "[what you're stuck on]"
allowed-tools: Bash(/usr/bin/say *), Bash(osascript *), Bash(git branch *), Bash(printf *), Bash(tmux *)
---

Play a "need help" voice announcement and set a visible status indicator on the terminal tab.

Voice: Junior (earnest, pleading). Override via `.claudetalk.json` key `voices.stuck`.

If $ARGUMENTS provided, announce that. Otherwise auto-detect from `git branch --show-current` (replace hyphens with spaces).

## Announcement examples (pick one, adapt to context)

- "Alright team, I need some eyes on this. [problem]. Anyone got ideas?"
- "Heads up. I'm stuck on [problem]. If you've seen this before, throw me a line."
- "I've tried a few approaches and they all fail. [problem]. Fresh perspective needed."

## Steps

1. Get the problem description (from $ARGUMENTS or branch name)
2. Craft a specific, honest 1-2 sentence message about what you're stuck on
3. Set status indicator — marks this tab as needing attention:
   - Terminal title: `printf '\033]0;⏳ Claude: Waiting for input\007' > /dev/tty`
   - Ring bell: `printf '\a' > /dev/tty` (flashes the correct tab in multi-tab)
   - iTerm2 badge (if `$TERM_PROGRAM` is `iTerm.app`): `printf '\033]1337;SetBadgeFormat=%s\007' "$(printf '⏳ Waiting' | base64)" > /dev/tty`
   - tmux (if `$TMUX` is set): `tmux rename-window "⏳ Claude: Waiting"`
4. Bring terminal to focus: detect from `$TERM_PROGRAM` (iTerm.app→iTerm2, Apple_Terminal→Terminal, WarpTerminal→Warp, ghostty→Ghostty), then `osascript -e 'tell application "APP" to activate'`
5. For iTerm2 with `$ITERM_SESSION_ID` set, also select the specific session/tab via AppleScript
6. Run: `/usr/bin/say -v Junior "message"`
7. Show notification: `osascript -e 'display notification "message" with title "Claude: Need Help"'`
