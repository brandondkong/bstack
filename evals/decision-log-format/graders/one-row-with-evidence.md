---
type: regex
target: { source: file, path: decisions.tsv }
pattern: '^\d{4}-\d{2}-\d{2}T[\d:]+Z\t[^\t]+\t[^\t]+\t[^\t]+\tconfig/cron\.yaml[^\t]*\t[^\t]+$'
flags: m
---
