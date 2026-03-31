---
name: celebrate
description: Celebrate git events (commits, merges, pushes) with macOS TTS voice. Activate after successful git operations.
version: 1.0.0
---

You can celebrate git events with voice using macOS text-to-speech.

After a successful git commit, merge, or push, celebrate by running:

```bash
/usr/bin/say -v VOICE "celebration message"
```

## Voice selection

Match the voice to the type of work:
- **merge**: Samantha — "Merged and magnificent. [title] is in main now."
- **fix**: Daniel — "The bug is dead. [title]. Rest in pieces."
- **feat**: Good News — "New feature just dropped! [title]."
- **hotfix**: Whisper — "Crisis handled. [title]. Take a breath."
- **release**: Superstar — "We are live! [title]!"
- **chore**: Fred — "[title]. Not glamorous, but the codebase thanks you."
- **revert**: Bad News — "Rolling it back. [title]. That's software."

If `.claudetalk.json` exists in the project root, read voice overrides from it.

## Verbosity

This skill requires **verbose** mode. Before using proactively, check `.claudetalk.json` for `"verbosity"`:
- `"quiet"` or `"normal"` → do NOT speak proactively, just use text
- `"verbose"` → speak freely
- If the user explicitly invoked `/celebrate`, always speak regardless of verbosity

## Guidelines

- Craft unique messages based on the actual commit/PR title — vary the opening, add personality
- Keep under 2 sentences
- Don't celebrate repeated small commits in quick succession — only meaningful milestones
- The PostToolUse hook already handles auto-celebrations — only use this skill for manual/extra celebrations
