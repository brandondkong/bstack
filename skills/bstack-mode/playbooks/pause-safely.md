### Pause safely

**You own a clean stop. Leave a checkpoint a cold-start agent can resume from.** The complement of `playbooks/session-pickup.md`. What this playbook writes down, that one reads back. This is explicit only. On "keep going", "going to bed, keep going", or "don't stop", do not pause.

1. Stop at a safe boundary. Finish the current atomic step or back out of it. Never stop mid-edit in a known-broken state. Start nothing new, and stop any running subagents.
2. Take no outward-facing action to pause. No push and no PR unless you already had one out and the user asked for it in this conversation.
3. Make the work durable. Commit uncommitted edits as one `wip:` commit on the current branch so nothing is lost. If the tree is broken, say so in the commit body in one line.
4. Write the resume note to `.audit/<slug>-resume.md` in the work directory, uncommitted. Capture intent, what you were doing, progress and what is verified, current state, next steps, key files, gotchas, and which outward-facing actions the user did or did not ask for. Run `bstack-trace` and copy its `transcript:` line into the note so pickup can trace this session by path. If a `show-me-your-work` trail exists, point at it instead of duplicating it. For a compaction, write the note before the context compacts.

**Reply:** where you are in the loop, what is on disk versus still in your head (paths, no diff dumps), the commits you made and whether the tree is clean, and the first action on resume. This is a pause, not a final report.
