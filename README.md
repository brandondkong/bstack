# bstack

My Claude Code working setup, as a plugin. Adapted from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan, rewritten for Claude Code and trimmed to rules that change a decision.

Two ideas hold it together. **Route the work**: a task matches a playbook, and the playbook's steps become the todo list, so the process is visible instead of improvised. **Prove the change**: a skill edit is an experiment, and it ships only after an eval says it helped.

## Install

```bash
claude plugin marketplace add ~/dev/personal/bstack
claude plugin install bstack@bstack
```

To iterate without installing, start a session with `claude --plugin-dir ~/dev/personal/bstack`, and run `/reload-plugins` after an edit.

## Use

```
/bstack-mode the CSV importer drops the last row of every file
```

It matches a playbook, copies its steps into the todo list verbatim, and works through them. It stays on for the rest of the conversation.

```
/show-me-your-work    keep a decision trail I can audit in the morning
/reflect              turn this session's lessons into skill edits, after I approve them
bstack-trace          what did this session's agent actually read, run, and spawn
bstack-check <dir>    validate a plugin's skills, links, and manifest
```

## What is in it, and when each part loads

Only the three `SKILL.md` descriptions are always in context, about 370 tokens per session as measured by `claude plugin details bstack`. Everything else is read on demand, by the path the skill names.

| Path | What it is | Loads when |
|---|---|---|
| `skills/bstack-mode/SKILL.md` | The router: non-negotiables, principle index, autonomy rules, delegation rules, reply style, playbook list | You type `/bstack-mode` |
| `skills/bstack-mode/playbooks/*.md` | Investigation, bug fix, feature, refactoring, authoring a skill, eval, opening a PR | The router matches one to the task |
| `skills/bstack-mode/principles/*.md` | Eight one-rule files: laziness protocol, fix root causes, prove it works, test behavior not implementation, sequence verifiable units, guard the context window, never block on the human, encode lessons in structure | A playbook or the router cites one. Citing a principle you didn't read is against the rules |
| `skills/bstack-mode/references/models.md` | Which model each role uses | A skill picks a model for a subagent |
| `skills/show-me-your-work/` | Decision-trail TSV, its `log.sh` helper, the transcript audit, the cross-model review | You type `/show-me-your-work`, or a long unattended run starts |
| `skills/reflect/` | Three reviewer prompts and a synthesizer that turn a session into proposed skill edits | You type `/reflect` |
| `agents/bstack-agent.md` | The delegate the playbooks spawn. Reads the router before working | A playbook spawns a subagent |
| `bin/bstack-trace` | Prints what a session actually did from its transcript: files read, commands run, skills invoked, subagents spawned | You or a skill runs it |
| `bin/bstack-check` | Validates frontmatter, relative links, the router index, and the manifest | Before any skill change is committed |
| `evals/` | Eval cases, one directory each | `claude plugin eval` |

`bin/` is on `PATH` whenever the plugin is enabled.

## Evals

Two layers, because they answer different questions.

**Unit tests.** `evals/<case>/` holds a `prompt.md` and a `graders/` directory. Graders check the transcript and the files produced: which tools were called, which files were read, what the output contains. Each case runs with the plugin and again without it, and reports the delta.

```bash
claude plugin eval . --allow-tools Bash Write --no-publish
claude plugin eval . --case mode-routes-bug-fix --ablation none   # while iterating
```

Cases today:

| Case | Asserts |
|---|---|
| `mode-routes-bug-fix` | A defect report opens `playbooks/bug-fix.md`, and the answer reproduces before fixing |
| `mode-reads-principles-before-citing` | A principle file is read, and the reply ties a named principle to a specific choice |
| `decision-log-format` | `/show-me-your-work` writes `decisions.tsv` with the documented header and a row whose evidence points at a real path |

**Blind comparison.** `skills/bstack-mode/playbooks/eval.md` handles "is this wording better than that one". Candidates run in sanitized directories with an organic-looking prompt and no idea they are being measured, a judge on a different model scores them by label, and chain-following is graded from transcripts rather than from what an agent claims it did.

## Adding to it

Use the authoring playbook: `/bstack-mode add a skill for <x>`. It keeps the voice consistent, runs `bstack-check`, and asks for an eval case when the rule is structural. When a rule could be a script or a check instead of prose, make it one.

`BACKLOG.md` holds mechanisms worth building later. `/reflect` files rows there.

## License

MIT. Portions adapted from pstack, also MIT. See `LICENSE`.
