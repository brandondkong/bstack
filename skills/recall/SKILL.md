---
name: recall
description: "Use for \"catch me up\", \"what was I working on\", \"where did I leave off\". Rebuilds recent context from past sessions, git, and Linear into a current-state brief."
disable-model-invocation: true
---

# Recall

**Before you start or resume work, rebuild the user's recent working context and hand back a tight capsule of where things stand and what to do next.**

Context lives in two records. Your own transcripts hold what you did and decided. The shared record (git, PRs, Linear) holds what happened around the same code under other names: fixes reverted, tickets still open, symptoms users keep reporting. Never reconstruct a feature with a bug tail from transcripts alone.

Transcripts live at `~/.claude/projects/<cwd-slug>/<session-id>.jsonl`, one JSON message per line. The slug is the working directory with every character that is not a letter or digit replaced by `-`, so `/Users/you/proj` becomes `-Users-you-proj`. Subagent transcripts under `<session-id>/subagents/` are noise here. `bstack-trace <path>` prints the first prompt, files read, commands run, skills invoked, subagents spawned, and files written. Pass the full path. A bare session id searches every project's directory.

1. Classify, then route. One specific prior session to resume is **Session pickup** (`../bstack-mode/playbooks/session-pickup.md`). Turning a habit into a skill is **Authoring a skill** (`../bstack-mode/playbooks/authoring-a-skill.md`). If the user already gave a full state capsule (paths, branch, the change), use it and skip the mining.
2. Lock the scope. Pin the window ("recent" is a real range, default the last 7 days), the topic if named, and the project (default the current directory). Never read another project's transcripts unless asked, and never glob across `~/.claude/projects/*`. State the scope back. Never quietly turn "all" into "recent N".
3. Fan out across your own transcripts. `ls -t` the project directory for order by modification time, never by file name, then `grep -l` the topic to pick candidates. Spawn parallel `bstack-agent`s on the bulk-reading model (`../bstack-mode/references/models.md`), each taking a slice. Each runs `bstack-trace` on its files, reads only the matching regions, skips the current session, and returns one block per session: topic, goal, decisions, open threads, struggles and corrections, artifacts (PRs, tickets, branches), citing the session id. For one or two sessions, read directly. Raw transcripts stay in the subagents (`../bstack-mode/principles/guard-the-context-window.md`).
4. Sweep the shared record in parallel whenever the topic names a feature, file, subsystem, or bug. "My work on X" does not exempt it. `git log --author=<user> --since=<window>` and `git log -S` on the touched files, `gh pr list --author @me --state all` then `gh pr view` on the hits, and the Linear MCP (`list_issues` with `assignee: "me"` or `query` set to the topic, then `list_comments`). Skip an unconnected MCP and say so. For a deep history, hand it to the `why` skill's investigators with the question reframed to "what is the current state, what did not hold, what are users still reporting". Skip this step only for activity recall with no named target.
5. Verify against live state. Check every PR, branch, and ticket that surfaced with `git` and `gh`. When the answer hinges on what an agent actually did, read that session's full transcript, not its summary.
6. Write the brief to the contract below. Group by thread. Stay on the named topic.

## Output contract

- **Capsule.** At most 5 bullets. What this work is and where it stands.
- **Threads.** One line each, prefixed with exactly one tag: `[merged #N]`, `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`, `[reverted #N]`, or `[planned, not started]`.
- **Problems.** At most 5, the recurring ones, including any fix that shipped and was reverted so the next attempt starts where the last failed.
- **Next move.** The single most useful next action, concrete.

An adjacent ticket stays out unless it blocks this one. When the brief outgrows a screen, cut detail before threads. Cite session findings by session id and shared-record findings by PR number, ticket ID, or commit. Strip private context before anything goes public.

**Reply:** the brief, to the contract above.
