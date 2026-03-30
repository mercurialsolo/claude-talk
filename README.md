# ClaudeTalk

Give Claude Code agents a voice. macOS TTS announcements, notifications, and terminal focus switching.

When Claude finishes a long task, it speaks, sends a notification, and brings your terminal to the foreground. When it commits code, it celebrates. When it's stuck, it calls for help.

## Install

**From marketplace:**
```bash
claude plugin add claude-talk
```

**Global (all projects):**
```bash
git clone https://github.com/Mason/claude-talk ~/.claude/plugins/claude-talk
```

**Local (single project):**
```bash
git clone https://github.com/Mason/claude-talk .claude/plugins/claude-talk
```

## What it does

**Automatic (hooks):**
- `git commit` / `git merge` / `git push` — voice celebration with personality
- Task completion — speaks "Done. Your turn.", shows notification, brings terminal to focus
- Only announces after long-running tasks (configurable, default 30s)
- Multi-agent safe — one agent speaks at a time, others skip silently

**Slash commands:**
- `/celebrate [message]` — celebrate a git event with voice
- `/stuck [description]` — announce you need help, bring terminal to focus
- `/update [status]` — share a calm progress update

**Proactive skills:**
- Claude uses voice for meaningful milestones during work
- Calls for help vocally after 2-3 failed attempts
- Shares progress on long-running multi-step tasks

## Voices

| Context | Voice | Personality |
|---------|-------|-------------|
| celebrate | Samantha | Warm celebration |
| fix | Daniel | Confident British |
| feature | Good News | Upbeat |
| hotfix | Whisper | Tense, dramatic |
| release | Superstar | Flashy |
| chore | Fred | Monotone |
| revert | Bad News | Downer |
| stuck | Junior | Earnest plea |
| update | Karen | Casual Aussie |
| done | Samantha | Task completion |

## Configure

Drop a `.claudetalk.json` in your project root or `~/.config/claudetalk/config.json` globally:

```json
{
  "voices": {
    "done": "Daniel",
    "stuck": "Samantha",
    "celebrate": "Karen"
  },
  "rate": 180,
  "min_task_seconds": 60,
  "enabled": true
}
```

Set `"enabled": false` to silence a project without uninstalling.

**Config precedence:** project `.claudetalk.json` > `~/.config/claudetalk/config.json` > plugin defaults.

## Requirements

- macOS (uses `/usr/bin/say` and `osascript`)
- python3 (for JSON parsing in hooks — ships with macOS)
- No compilation or dependencies

## Supported terminals

Terminal.app, iTerm2, Warp, Ghostty, kitty, Alacritty. Detected via `$TERM_PROGRAM`.

## License

MIT
