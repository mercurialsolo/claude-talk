---
description: Enable ClaudeTalk voice announcements for this project
allowed-tools: Bash(python3 *), Bash(/usr/bin/say *)
---

Enable ClaudeTalk by setting `enabled: true` in the project's `.claudetalk.json`.

Run:
```bash
python3 -c "
import json, os
path = '.claudetalk.json'
d = {}
if os.path.exists(path):
    with open(path) as f:
        d = json.load(f)
d['enabled'] = True
with open(path, 'w') as f:
    json.dump(d, f, indent=2)
print('ClaudeTalk enabled.')
"
```

Then confirm with voice: `/usr/bin/say -v Samantha "ClaudeTalk re-enabled."`
