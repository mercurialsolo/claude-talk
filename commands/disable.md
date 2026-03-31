---
description: Disable ClaudeTalk voice announcements for this project
allowed-tools: Bash(python3 *)
---

Disable ClaudeTalk by setting `enabled: false` in the project's `.claudetalk.json`.

Run:
```bash
python3 -c "
import json, os
path = '.claudetalk.json'
d = {}
if os.path.exists(path):
    with open(path) as f:
        d = json.load(f)
d['enabled'] = False
with open(path, 'w') as f:
    json.dump(d, f, indent=2)
print('ClaudeTalk disabled for this project.')
"
```

Confirm to the user (in text, not voice) that ClaudeTalk is now disabled.
