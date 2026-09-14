---
name: no-comments
description: Deep comment pass. Spawn Comment Sicko on a diff or files, delete every comment that is not a proven exception, and fix the code the comments covered for.
disable-model-invocation: true
---

# No comments

The "Comments" section of `../bstack-mode/SKILL.md` and the "Before review" step of `../bstack-mode/playbooks/opening-a-pr.md` are the always-on pass over your own diff. This is the deep pass, with a fresh reviewer who owes the comments nothing. Defer to its verdicts unless you can refute one.

## Scope

The caller's files or diff. Otherwise the current diff against the base branch, default `main`, including the working tree. Nothing outside the scope changes.

## Steps

1. Spawn one `Agent` with `subagent_type: "comment-sicko"` on the judgment model (`../bstack-mode/references/models.md`). Pass the scope and nothing else. Do not restate its rules. It is read-only and returns a kill list, keeps with the exception each invokes, and `MUST KILL` flags on code.
2. Audit the report before acting. Reject a flag that names code outside the scope, a kill that hits one of its listed exceptions, a `MUST KILL` whose stated reason is false, or a flag that treats kept intentional code as guilty. A reshape flag on a surprise in our own code stays, and its comment does not come back. A keep survives only with proof the comment is about something we cannot change. Check for suppressions it missed (`eslint-disable`, `@ts-ignore`, `@ts-expect-error`, `# noqa`, `# type: ignore`). One that hides a correctness or safety rule is a `MUST KILL`. Before accepting a thin verdict on an `IMPORTANT` or `do not remove` comment, check the symbol yourself with an `Explore` agent for how it works and `git log -S` plus `git blame` for why it exists. An ambiguous kill stands. A refuted or still-ambiguous keep dies. If the report is wrong in more than one place, rerun it once with the failures named. Reject a second bad report, leave the scope open, and say the pass failed.
3. Apply the accepted kill list. Delete the comments yourself, or hand a large list to a `bstack-agent` on the mechanical model with the exact file and line list. Fix trivial `MUST KILL` flags directly by deleting the dead path, dropping the parameter, or using the real API.
4. For flags that need a shape, settle the caller's usage, the types, and the module shape once for the whole accepted set before writing any body. Then land the smallest root-cause fix in scope and remove every named workaround. `../bstack-mode/principles/fix-root-causes.md` and `../bstack-mode/principles/redesign-from-first-principles.md` guide intent only. Neither widens the scope or fixes instances outside it. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. Never bolt on a symptom guard.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Keep the ones about things we cannot change. For each other one, offer the cheapest in-scope encoding, a type, a runtime check, a test, or a CI lint (`../bstack-mode/principles/encode-lessons-in-structure.md`), and wait for approval with `AskUserQuestion`. An unattended run needs the caller's pre-approval in its brief. Approved, encode it and delete the comment. Declined, delete the comment, report the constraint open, and sketch the out-of-scope work in one line.
6. Run the always-on pass yourself over the final diff, then verify the build and tests still pass (`../bstack-mode/principles/prove-it-works.md`).

**Reply:** deletion count, comments restored and why, reruns, the shape sketch if any, fixes landed, encoding offers and encodings, constraints left unenforced, and other open work.
