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

Only the `SKILL.md` descriptions are always in context, about 1,650 tokens per session as measured by `claude plugin details bstack`. Everything else is read on demand, by the path the skill names.

| Path | What it is | Loads when |
|---|---|---|
| `skills/bstack-mode/SKILL.md` | The router: non-negotiables, principle index, autonomy rules, delegation rules, reply style, playbook list | You type `/bstack-mode` |
| `skills/bstack-mode/playbooks/*.md` | 23 playbooks, grouped as understanding and diagnosis, changing code, process and delivery, long-running and unattended, and housekeeping | The router matches one to the task |
| `skills/bstack-mode/principles/*.md` | 23 one-rule files, grouped as core, architecture, verification, delegation, and meta | A playbook or the router cites one. Citing a principle you didn't read is against the rules |
| `skills/bstack-mode/references/models.md` | Which model each role uses | A skill picks a model for a subagent |
| `skills/show-me-your-work/` | Decision-trail TSV, its `log.sh` helper, the transcript audit, the cross-model review | You type `/show-me-your-work`, or a long unattended run starts |
| `skills/reflect/` | Three reviewer prompts and a synthesizer that turn a session into proposed skill edits | You type `/reflect` |
| `skills/how/`, `why/`, `teach/`, `recall/`, `blast-radius/` | Understanding: how a subsystem works, why it is like this, an explanation you actually follow, your own prior context, and what a change could break | You invoke one, or the router's triggers send you there |
| `skills/architect/`, `arena/`, `swarm/`, `figure-it-out/` | Design and fan-out: settle the shape first, N attempts at one task, N slices in parallel, or design a bespoke playbook when none fits | Same |
| `skills/interrogate/`, `no-comments/` + the `comment-sicko` agent | Adversarial review against a quality rubric, and a deep comment pass | Same |
| `skills/unslop/`, `technical-writing/`, `bro/` | Prose: cut AI tells, structure a document to a standard, or restate the last message in plain words | Same |
| `skills/tdd/` | Failing test first, when the user asks or the bug has a cheap local test target | Same |
| `skills/create-verification-skill/`, `maintain-verification-skill/` | Generate a project-local `verify-<app>` skill that drives your real app (CLI, daemon, service, or GUI) and prove behavior, then keep it honest as the app drifts | Same |
| `skills/cpp-discipline/`, `skills/python-discipline/` | Ownership, lifetime, typing at boundaries, error handling, and test honesty | Automatically, via `paths:`, only when the session touches a matching file |
| `agents/bstack-agent.md`, `agents/comment-sicko.md` | The delegate the playbooks spawn, and a read-only comment reviewer | A playbook or skill spawns one |
| `bin/bstack-trace` | Prints what a session actually did from its transcript: files read, commands run, skills invoked, subagents spawned | You or a skill runs it |
| `bin/bstack-check` | Validates frontmatter, relative links, the router index, the manifest, and two prose rules (no stray dashes, no reference to a skill nothing ships) | Before any skill change is committed |
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

## Where it came from

pstack's structure, ported by hand and trimmed. What was dropped and why:

| Dropped | Reason |
|---|---|
| `setup-pstack` | Replaced by `references/models.md`, one table instead of a generated config rule |
| `typescript-best-practices` | Wrong language for this stack. `cpp-discipline` and `python-discipline` replace it |
| `make-bot-ui` | Grok Bot webhooks over Tailscale, specific to another vendor |
| Origin CLI, Graphite, bugbot, Cursor cloud agents | No Claude Code equivalent. Every forge operation is `gh`, and review triage is `/code-review` |

Everything else is ported. `bstack-check` derives the set of real skills from disk, so any reference to a skill that does not ship fails the build.

## Adding to it

Use the authoring playbook: `/bstack-mode add a skill for <x>`. It keeps the voice consistent, runs `bstack-check`, and asks for an eval case when the rule is structural. When a rule could be a script or a check instead of prose, make it one.

`BACKLOG.md` holds mechanisms worth building later. `/reflect` files rows there.

## License

MIT. Portions adapted from pstack, also MIT. See `LICENSE`.
