---
description: Set ClaudeTalk verbosity mode (quiet, normal, verbose)
argument-hint: "<quiet|normal|verbose>"
allowed-tools: Bash(python3 *), Bash(/usr/bin/say *)
---

Set the ClaudeTalk verbosity mode in `.claudetalk.json`.

## Modes

| Mode | What fires |
|------|-----------|
| **quiet** | Only critical: questions (AskUserQuestion), /stuck |
| **normal** | Quiet + git events (commit/push/merge) + long task completion |
| **verbose** | Normal + proactive celebrations and updates |

If $ARGUMENTS is one of `quiet`, `normal`, or `verbose`, set it. Otherwise show the current mode.

To set:
```bash
python3 -c "
import json, os
path = '.claudetalk.json'
d = {}
if os.path.exists(path):
    with open(path) as f:
        d = json.load(f)
d['verbosity'] = '$ARGUMENTS'
with open(path, 'w') as f:
    json.dump(d, f, indent=2)
print(f'ClaudeTalk verbosity set to: $ARGUMENTS')
"
```

To read current mode:
```bash
python3 -c "
import json, os
for p in ['.claudetalk.json', os.path.expanduser('~/.config/claudetalk/config.json')]:
    if os.path.exists(p):
        with open(p) as f:
            d = json.load(f)
        if 'verbosity' in d:
            print(f'Current verbosity: {d[\"verbosity\"]}')
            exit()
print('Current verbosity: normal (default)')
"
```

After setting, confirm with voice: `/usr/bin/say -v Samantha "Verbosity set to [mode]."`
