---
description: Celebrate a git event with voice announcement
argument-hint: "[message or --auto]"
allowed-tools: Bash(/usr/bin/say *), Bash(osascript *), Bash(git log *)
---

Celebrate with a macOS TTS voice announcement.

If $ARGUMENTS contains a message, celebrate that. If it contains "--auto" or is empty, auto-detect from the last git commit with `git log -1 --pretty=%s`.

## Voice mapping

Detect event type from the message and pick a voice:
- **merge**: Samantha — "Oh snap! [title] just got merged. That's what I'm talking about."
- **fix/bugfix**: Daniel — "The bug is dead. [title]. Rest in pieces."
- **feat/feature**: Good News — "Fresh off the press. [title]. The users are gonna love this."
- **hotfix**: Whisper — "Crisis handled. [title]. Take a breath."
- **release**: Superstar — "It's release day! [title] is going out to the world!"
- **chore/refactor**: Fred — "[title]. Not glamorous, but the codebase thanks you."
- **revert**: Bad News — "Rolling it back. [title]. That's software."
- **default**: Samantha — "Committed. [title]."

Check for `.claudetalk.json` in the project root — if it exists, read voice overrides from `voices.*` keys.

## Steps

1. Get the message (from $ARGUMENTS or git log)
2. Detect event type from conventional commit prefix or keywords
3. Craft a personalized 1-2 sentence celebration — vary the opening, reference the work
4. Run: `/usr/bin/say -v VOICE "message"`
5. Show notification: `osascript -e 'display notification "message" with title "ClaudeTalk"'`
