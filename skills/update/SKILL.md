---
name: update
description: Share progress updates with calm macOS TTS voice during long-running tasks.
version: 1.0.0
---

During long-running tasks, share progress updates using macOS text-to-speech.

## How to announce

```bash
# Speak with Karen voice (casual Australian)
/usr/bin/say -v Karen "Quick update. [status]. Moving along nicely."

# Show macOS notification
osascript -e 'display notification "[status]" with title "Claude: Update"'
```

If `.claudetalk.json` exists in the project root, read voice override from `voices.update`.

## When to use

- After completing a major step in a multi-step task
- At natural milestones worth noting
- Before starting a notably different phase of work

## When NOT to use

- For every small step (too noisy)
- When the user is actively watching
- During quick tasks under a minute

## Message style

Brief and calm. One sentence. Karen voice, steady pace.
