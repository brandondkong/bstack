---
name: show-me-your-work
description: "Keep a reviewable decision trail for long-running or unattended work: a TSV log with one row per decision (what, why, evidence, result), audited against the session transcript at the end. Use for /show-me-your-work, autonomous or multi-phase runs, or work the user reviews after stepping away."
disable-model-invocation: true
---

# Show me your work

Keep one log. One row per decision or checkpoint.

## The format

A single TSV file. Cells stay on one line. Evidence is a pointer, not prose. Columns:

- **ts.** ISO8601 timestamp.
- **phase.** The phase or workstream.
- **decision.** What was chosen or done, one line.
- **why.** The reason in plain words.
- **evidence.** A link or path that proves it: a commit SHA, PR number, `file:line`, a script output path, a screenshot. Never a paragraph.
- **result.** The outcome: `tests green`, `reverted`, `INCONCLUSIVE`, `open`.

An illustration, plain-spoken enough to read at a glance. Don't copy these rows into a real log.

```
ts	phase	decision	why	evidence	result
2026-09-14T09:02:00Z	frame	counted the work first, about 100 components	wanted the size before starting a long run	commit 3a9f1c2	found 5 things to sort out first
2026-09-14T09:40:00Z	harness	screenshotted the old version before changing anything	so we can compare old against new	scripts/snapshot.sh, baseline/	120 reference screenshots
2026-09-14T11:15:00Z	widget	moved the widget styles over without changing how it looks	keep the change small and the result identical	commit 7c21e0a, pixel-diff 0	identical, tests pass
2026-09-14T12:30:00Z	widget	threw out a helper's work because its screenshots were blank	checked the real files instead of its summary	worktree reset	reverted, tightened the brief
```

## Logging a row

Use `scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>`. It stamps the time, writes the header on first use, strips stray tabs and newlines, and quotes any cell starting with `=`, `+`, `-`, or `@` so a spreadsheet can't execute it.

Write each entry the way you would tell a teammate what you did. Plain words, concrete actions.

Log forks, completed units with their verification result, pivots and reverts with what triggered them, blockers, and fixed gates. One row per loop iteration. Skip the trivial.

## Where it lives

A working artifact by default, not committed: `decisions.tsv` in the work directory, or `.audit/<task-slug>.tsv` when several efforts run at once. Commit it only when the work is ambitious enough that a reviewer needs the trail to trust the result.

## Rules

- One row is one decision or checkpoint.
- Append only. A wrong call gets a new row that supersedes it. Never edit history.
- Prefer evidence produced by a committed script over a hand-made one-off (the **encode-lessons-in-structure** principle).

## Audit the log against the transcript

Before handing back, check the log told the truth. Run `bstack-trace` on this session's transcript and walk the log against what actually happened:

- Every row maps to a real action. Cut invented or aspirational rows.
- Each row's evidence resolves and shows what the row claims.
- A fork, pivot, or abandoned approach that shaped the work but isn't logged is a gap. Add it.

Fix the log, not the story. If the work diverged from what a row claims, the row is wrong.

## Cross-model review of the trail

Spawn one `Agent` on a model other than the one that did the work (`../bstack-mode/references/models.md`). Self-review does not substitute. Give it the log path and the transcript path. It reads both and flags what the user should look at. Not a redo of the work, a scan for risk:

- Decisions logged with weak or absent evidence.
- Verification claimed but absent from the transcript.
- Choices that look risky in hindsight: premature, scope-creeping, or papering over a symptom.
- Gaps a casual skim would miss.

Every reply for a run with a trail ends with an **Attention** section. First line names the reviewing model (`reviewed by <model>`), then one line per flag pointing at specific rows or moments. "No flags" is a valid value.

## Reading the trail

`column -s$'\t' -t decisions.tsv` renders it in a terminal. GitHub renders a committed TSV as a table.
