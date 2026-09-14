---
name: reflect
description: Mine this session's transcript for durable lessons with three parallel reviewers, then route each into a concrete skill edit, a backlog item, or a rejection. Use for /reflect, or after a task that took longer than it should have.
disable-model-invocation: true
---

# Reflect

Turn what this session taught into changes that make the next session better. Nothing is applied without approval.

Skip when the session was trivial, off-topic, or already covered by a skill the parent followed correctly. One weird session is an anecdote, not a rule.

## 1. Locate the transcript

```
bstack-trace
```

With no argument it finds the newest transcript for the current directory and prints the path plus what actually happened. Confirm the path is this session: its first user prompt should match how this conversation began. If no transcript resolves, write a tight digest of the session yourself and pass that to the reviewers instead of a path.

## 2. Spawn three reviewers in parallel

One message, three `Agent` calls, models per `../bstack-mode/references/models.md`. Pass each reference prompt verbatim, substituting the transcript path where marked.

| Lens | Model | Prompt |
|---|---|---|
| Judgment | `fable` | `references/judgment-reviewer.md` |
| Tooling | `opus` | `references/tooling-reviewer.md` |
| Divergent | `fable` | `references/divergent-reviewer.md` |

## 3. Synthesize

One `Agent` on `fable` with `references/synthesizer.md`, with each reviewer's full output inlined where marked. It returns Accepted, Rejected, and Backlog.

## 4. Structural enforcement check

Read the Accepted list yourself. Move any item to Backlog that a script, check, lint rule, or `evals/` case would enforce more reliably than prose (`../bstack-mode/principles/encode-lessons-in-structure.md`). Skill text is for what mechanisms cannot enforce.

## 5. Present and wait

Show the full Accepted, Rejected, and Backlog lists and stop. A skill edit changes every future session, so do not apply anything before the user picks. The user approves row by row and may redirect a routing.

## 6. Apply what was approved

- A tightened sentence, corrected fact, or one-line rule: edit the skill directly.
- A new section, pattern table, or anything over about ten lines: route through the **Authoring or modifying a skill** playbook (`../bstack-mode/playbooks/authoring-a-skill.md`).
- `tune description: <skill path>`: the skill exists but didn't fire. Rewrite its `description` to front-load the words the user actually typed, then add an `evals/` case that fails on the old description and passes on the new one.
- A genuinely new skill: also the authoring playbook.

One commit per approved item, in the repo that owns the skill. Run `bstack-check <plugin-root>` before committing. Backlog items become lines in bstack's `BACKLOG.md`.

## 7. Summarize

Short list, no preamble: edits applied with one line each, new skills, backlog lines filed, and one line per rejected finding with its reason.
