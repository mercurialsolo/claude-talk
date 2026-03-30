---
description: Share a progress update with a calm voice notification
argument-hint: "[status message]"
allowed-tools: Bash(/usr/bin/say *), Bash(osascript *), Bash(git log *)
---

Share a calm progress update using macOS TTS.

Voice: Karen (casual Australian). Override via `.claudetalk.json` key `voices.update`.

If $ARGUMENTS provided, announce that. Otherwise auto-detect from `git log -1 --pretty=%s`.

## Update examples (pick one, adapt)

- "Quick update. [status]. Moving along nicely."
- "FYI everyone. [status]. Nothing blocking, just keeping you in the loop."
- "Status check. [status]. All systems go."

## Steps

1. Get the status message (from $ARGUMENTS or last commit)
2. Craft a brief, calm 1 sentence update
3. Run: `/usr/bin/say -v Karen "message"`
4. Show notification: `osascript -e 'display notification "message" with title "Claude: Update"'`
