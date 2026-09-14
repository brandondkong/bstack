### Autonomous run

**You own the exit condition. Define done, then drive to it without stopping.** One task, one predicate, one session. A program that outlives a session is `playbooks/orchestrate.md`.

1. State the exit condition as a checkable predicate before the first iteration (tests green, repro fixed, all N PRs merged, pixel-diff zero). If the predicate needs pushing, opening PRs, or merging, confirm the user asked for that in this conversation. An overnight run the user set up to land PRs is that permission. Otherwise the predicate stops at local commits.
2. Pick the wake mechanism. An event to watch (CI, a merge, a ref advancing) gets a background Bash command that exits on the event, such as `gh pr checks <pr> --watch` or `gh run watch <run-id>`, which wakes you when it returns. Add a long time-based heartbeat with the `loop` skill as fallback. No event gets a fixed-interval `loop` sized to when the result is worth re-checking. Never stack a second sleep loop on top.
3. Each iteration makes the smallest change the evidence justifies, verifies it against the predicate, commits if it advanced, and discards what did not help. Belt-and-suspenders that "might help" gets reverted, not left to ride. Verify each unit before the next (`principles/sequence-verifiable-units.md`).
4. Mid-run discoveries are yours. Fix broken skills, related bugs, flaky verifiers, review noise, tooling failures, orphaned follow-ups, and fixable drift yourself through the matching playbook. Put out-of-band fixes in their own commits or PR. Do not park reversible work for the human or call `AskUserQuestion` for it (`principles/never-block-on-the-human.md`). Surface only irreversible actions, product or preference calls no experiment can settle, or a real dead end. Return to the predicate after each side fix.
5. Checkpoint every iteration with the `show-me-your-work` skill, one row for what changed and whether the predicate moved.
6. Stop when the predicate is met. A plateau is not a stop. Pivot the approach to push past it. Surface a genuine dead end rather than spinning, and never relax the predicate to declare victory.

**Reply:** the exit condition, iterations run, what landed, what was discarded, final predicate state.
