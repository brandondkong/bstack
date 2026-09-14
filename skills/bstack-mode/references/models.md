# Model roles

The single source of truth for which model each role uses. Pass the value as the `model` parameter of the `Agent` tool. Edit a line here to change it everywhere. `inherit` means omit `model` so the subagent runs on the parent's model.

| Role | Model |
|---|---|
| Code delegates (feature, bug fix, refactoring) | `opus` |
| Hardest changes (cross-cutting design, concurrency, subtle algorithms) | `fable` |
| Judgment, prose, synthesis | `fable` |
| Mechanical edits, bulk reading, log digging | `sonnet` |
| Read-only codebase search | `Explore` agent, `inherit` |
| Eval candidates | at least two of `opus`, `sonnet`, `fable` |
| Eval judge | a model no candidate used; `fable` when candidates are `opus` + `sonnet` |
| Reflect reviewers | judgment `fable`, tooling `opus`, divergent `fable`; synthesizer `fable` |
| Decision-trail reviewer | any model other than the one that did the work |

A second opinion is the same prompt on a different model. Agreement is high signal.
