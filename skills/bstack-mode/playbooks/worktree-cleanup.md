### Worktree and simulator cleanup

**You own the disk and the safety gate.** Prune merged or abandoned git worktrees and stale iOS simulators to reclaim space. Deletion is irreversible, so every step guards against deleting something in use or holding uncommitted or unpushed work.

1. Snapshot and audit. Record `df -h /`. Take the worktree paths from `git worktree list --porcelain`, never hand-typed, since a hand-typed `myrepo-worktrees/x` misses one that lives somewhere else (`principles/encode-lessons-in-structure.md`). Build one table with a row per worktree and these columns. Delegate the collection to a `bstack-agent` on the mechanical model (`references/models.md`) when there are many.
   - Size, `du -sh <path>`.
   - Age, `git -C <path> log -1 --format=%cr`.
   - Merge state, `git -C <path> merge-base --is-ancestor HEAD origin/main`.
   - Unpushed commits, `git -C <path> log --oneline @{u}..HEAD`. An error means no upstream, so nothing on that branch was ever pushed.
   - Tracked uncommitted edits and untracked files, `git -C <path> status --porcelain`.
   - PR state, `gh pr list --head <branch> --state all`.
   - Newest session that ran there. Under `~/.claude/projects/` find the directory named for that path, `ls -t` it for recency, and run `bstack-trace` from inside the worktree to see what that session did.
   - A suggested bucket, one of `safe`, `wip:N`, `scratch:N`, `unpushed:N`, `verify-in-use`.
2. The bucket is advice, not permission. The user's live sessions are the real artifact (`principles/prove-it-works.md`). Ask which sessions and worktrees are active and cross-check every candidate against that set. A classifier has marked `safe` a worktree the user was actively working in, so the user's set wins.
3. Verify usage before deleting. For every `verify-in-use` row, or anything you doubt, check `lsof +d <path>` for processes with files open there, and read the `bstack-trace` output for the newest session there. Delegate the reading when there are many, since transcripts are bulk (`principles/guard-the-context-window.md`). A running session spawns repro and comparison trees into sibling worktrees through `isolation: "worktree"` subagents, and those are in use even when their names never came up.
4. Pause on irreversible loss. `wip:N` is N tracked uncommitted edits. Show the diff and get a decision first. `unpushed:N` is N commits on no remote. Show them and get a decision first. `scratch:N` is untracked throwaway, safe to drop, but name the files. The user asked for the cleanup, so clean, merged, not in use, and nothing unpushed proceeds. `wip`, `unpushed`, and in-use pause.
5. Prune the confirmed set. Per path, `git worktree remove --force <path>`. If the directory survives on ignored build artifacts, `rm -rf` it, then `git worktree prune`. Never `git branch -D` in this playbook. The branch ref survives, so committed work stays recoverable. Confirm with `df -h /` and `git worktree list`.
6. Simulators and other reclaimers. Simulators are usually the next-biggest win when Xcode is installed. `xcrun simctl --set testing delete all` (XCTestDevices clones), `xcrun simctl delete unavailable`, and `xcrun simctl runtime list` then `xcrun simctl runtime delete <id>` for old runtimes. More when needed, Xcode `DerivedData` and `iOS DeviceSupport`, build directories inside worktrees, and package caches (uv, pip, brew, and any node caches). Clear only caches the user has not said to keep.

This is the one playbook that deletes user state with no code review to catch a slip, so the gates above are the review.

**Reply:** `df -h /` before and after with space reclaimed, the worktrees pruned, and a one-line reason for each held back (in use by which session, uncommitted edits, or unpushed commits).
