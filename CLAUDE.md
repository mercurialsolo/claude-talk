# ClaudeTalk — Voice for Claude Code

You have voice capabilities via this plugin. You can speak, send notifications, and bring the terminal to focus on macOS.

## How to speak

```bash
/usr/bin/say -v VOICE "message"
```

## Voices

| Context | Voice | Use for |
|---------|-------|---------|
| celebrate | Samantha | Warm, general celebrations |
| fix | Daniel | Confident, satisfying |
| feature | Good News | Upbeat, exciting |
| hotfix | Whisper | Tense, dramatic |
| release | Superstar | Flashy, maximum hype |
| chore | Fred | Monotone, boring work |
| revert | Bad News | Downer, oops |
| stuck | Junior | Earnest, asking for help |
| update | Karen | Casual, status update |
| done | Samantha | Task completion |

## Configuration

Users can override voices and behavior with `.claudetalk.json` in their project root:

```json
{
  "voices": { "done": "Karen", "stuck": "Samantha" },
  "rate": 180,
  "min_task_seconds": 60,
  "enabled": true
}
```

Config precedence: project `.claudetalk.json` > `~/.config/claudetalk/config.json` > plugin `defaults.json`.

## How to notify

```bash
osascript -e 'display notification "message" with title "title"'
```

## Status indicator (tab title / badge)

Set a visible indicator on the terminal tab so the user knows which tab needs attention:

```bash
# Set "waiting" status — title + bell + iTerm2 badge + tmux
printf '\033]0;⏳ Claude: Waiting for input\007' > /dev/tty 2>/dev/null
printf '\a' > /dev/tty 2>/dev/null

# iTerm2 badge (only if $TERM_PROGRAM is iTerm.app)
printf '\033]1337;SetBadgeFormat=%s\007' "$(printf '⏳ Waiting' | base64)" > /dev/tty 2>/dev/null

# tmux (only if $TMUX is set)
tmux rename-window "⏳ Claude: Waiting" 2>/dev/null

# Clear status when no longer needed
printf '\033]0;%s\007' "${SHELL##*/}" > /dev/tty 2>/dev/null
```

Use the "waiting" status when stuck or asking for user input.
The Stop hook automatically sets "done" status and clears it on next SessionStart.

## How to bring terminal to focus

The focus system handles multi-tab and split-pane setups:

1. **Terminal bell** (`\a`) — flashes/highlights the correct tab
2. **tmux** — selects the right pane via `$TMUX_PANE`
3. **App activation** — brings the terminal app to foreground
4. **iTerm2 session** — uses `$ITERM_SESSION_ID` to select the exact tab/split

Detect terminal from `$TERM_PROGRAM`:
- `iTerm.app` → "iTerm2"
- `Apple_Terminal` → "Terminal"
- `WarpTerminal` → "Warp"
- `ghostty` → "Ghostty"

## Automatic behavior (hooks)

- **SessionStart**: Records start time, clears leftover status indicators
- **PostToolUse (Bash)**: Auto-celebrates git commits, merges, pushes with voice
- **Stop**: Sets "done" status indicator + announces completion + focuses terminal — only if task ran longer than `min_task_seconds` (default 30s)
- **Multi-agent safe**: Lock file prevents overlapping TTS; bell targets the correct tab

## Guidelines

- Keep TTS messages to 1-2 sentences
- Don't speak during rapid successive operations
- Use voice for meaningful milestones, not every small step
- The Stop hook handles "done" — don't double up manually
- When stuck after 2-3 attempts, use the stuck skill to vocally ask for help and set the "waiting" status indicator
- Always set status indicator when asking for user input — it's how users find the right tab
