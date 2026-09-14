---
description: /bstack-mode matches a defect report to the bug-fix playbook and opens it before proposing a fix.
tags: [mode]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite]
---

/bstack-mode our CSV importer drops the last row of every file. Here is the reader:

```python
def read_rows(path):
    rows = []
    with open(path) as f:
        line = f.readline()
        while True:
            line = f.readline()
            if not line:
                break
            rows.append(line.rstrip("\n").split(","))
    return rows
```

Tell me how you'd go about this and what you'd do first.
