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

## How to bring terminal to focus

Detect terminal from `$TERM_PROGRAM`:
- `iTerm.app` / `iTerm2` -> "iTerm2"
- `Apple_Terminal` -> "Terminal"
- `WarpTerminal` -> "Warp"
- `ghostty` -> "Ghostty"

```bash
osascript -e 'tell application "Terminal" to activate'
```

## Automatic behavior (hooks)

- **SessionStart**: Records start time for elapsed-time gating
- **PostToolUse (Bash)**: Auto-celebrates git commits, merges, pushes with voice
- **Stop**: Announces completion + focuses terminal — only if task ran longer than `min_task_seconds` (default 30s)
- **Multi-agent safe**: Lock file prevents overlapping TTS from parallel agents

## Guidelines

- Keep TTS messages to 1-2 sentences
- Don't speak during rapid successive operations
- Use voice for meaningful milestones, not every small step
- The Stop hook handles "done" — don't double up manually
- When stuck after 2-3 attempts, use the stuck skill to vocally ask for help
