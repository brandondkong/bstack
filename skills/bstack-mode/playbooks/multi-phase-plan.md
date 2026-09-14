### Multi-phase or multi-PR plan

**You own the plan, not the code. The plan is a checklist an owner runs box by box and the user audits from the evidence.** The plan is the deliverable. Do not implement.

1. When the change is one or two files with an obvious approach, skip the plan. Say so and stop.
2. Settle open questions by prototype before you write. Run **Prototype** (`playbooks/prototype.md`) for each. Keep the branch, the SHA, and the screenshots for Appendix A. Ask the user only about a product or preference call that no run can settle, and give options (`principles/never-block-on-the-human.md`).
3. Explore with `Explore` agents, one specific question each (`principles/guard-the-context-window.md`). Each returns file pointers, conventions, test commands, and entry points. No inlined dumps.
4. Copy the skeleton below into the plan file and fill every placeholder. Unless the user names a path, write it under the repo's `docs/`. Keep every heading and sub-block in the order shown. One section per PR. One PR is one change with its own evidence (`principles/sequence-verifiable-units.md`).
5. Write the body as a how-to. Appendices hold explanation and reference. Each heading states the task or the finding. Short declarative sentences. No long dashes. No mid-sentence colons. Then read the whole file and cut every sentence that does not change what the owner does.
6. Check the file mechanically before handing it back (`principles/encode-lessons-in-structure.md`). `grep -n '<[A-Za-z]' <plan.md>` finds unfilled placeholders. `grep -n -e $'\xe2\x80\x93' -e $'\xe2\x80\x94' <plan.md>` finds dashes. Confirm every PR section has all three verify blocks and a review gate line, and that every verify block opens with the verification rule. Fix every hit.
7. Hand back. Post the plan path and the check output, then stop. Execution starts on the user's explicit go.

**Verification.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked (`principles/prove-it-works.md`). That sentence is the verification rule. Every verification block opens with it. The live block is mandatory. Live lanes are one `bstack-agent` per scenario, launched in one message at the PR head, each with `isolation: "worktree"`, driving the real surface through the `run` skill. Each lane is one box with a concrete scenario, the screenshot it saves, and its pass predicate. One lane is always the **Regression lane against trunk.** It runs the same load-bearing scenario on trunk and head. If trunk lacks the feature, the lane records that fact and gates the behavior the diff adds plus the end state the user waits for, instead of inventing a trunk result. The perf gate is dual-sided. Trunk and head must both produce the named metric. If trunk lacks the feature, also isolate the work the diff adds and set an absolute budget for that work plus the end-to-end state the user waits for. Never claim a ratio between unlike scenarios. The perf block names the metric, the interleaved probe, the trunk baseline measured first, and the rule with the number that fails. A PR that changes an interaction is review-gated. The user reviews it in chat with screenshots before merge. A PR that changes no interaction writes `**Review gate.** None. <PR id> is not review-gated.` and no boxes under it. A surface the `run` skill cannot drive is a risk in Appendix C, and its live block still names how each lane drives it.

````markdown
# <Program> plan

<Under ten lines. What changes, for whom, the rule the program enforces, and the PR ids in order.>

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists, a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

Every PR runs **Opening a PR** from bstack-mode. <Who merges, and which PR ids stop at merge-ready for the user.>

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program

- [ ] State this plan to the user, then stop. Start execution only on the user's explicit go.
- [ ] Open the decision trail with the `show-me-your-work` skill. Log one row per PR state change and per verdict.
- [ ] Re-read this plan and **Opening a PR** at the start of every PR.
- [ ] Arm a status cadence with the `loop` skill, every 30 minutes while owners run. Never leave it to memory. Each tick posts to the user, whether or not anything changed, the queue table of PR, owner, state, and head SHA, the verdicts since the last tick, what merged, open user gates, and blockers.
- [ ] On the user's hold or stand-down, stop every owner at once with a zero-writes order.

### Spawn owners

- [ ] Spawn one `bstack-agent` per PR on the code-delegate model, each with `isolation: "worktree"`, briefed with its PR section of this plan.
- [ ] Follow this dependency graph. Start dependent work only after its parent merges, or base it on the parent branch when the PRs stack.
  - [ ] <PR id> and <PR id> are independent and first. Both branch from `main`.
  - [ ] <PR id> after <PR id>.
- [ ] Hold the file boundaries. <PR id or class> touches only `<glob>`.
- [ ] Hold the review gate. <PR ids> change an interaction. They wait for the user's review in chat with screenshots before merge.

### PR mechanics, for every PR

- [ ] Open the PR ready, never draft, with `gh pr create --base <base-branch>`. A stack child targets its parent branch.
- [ ] Run the repo's lint and typecheck once before the PR-facing push. Push with hooks on.
- [ ] Read the whole diff before review and cut comments that narrate what the code does.
- [ ] Run `/code-review` and `/security-review` on the diff and act on every real finding.
- [ ] Rebase onto current trunk before verification and again before the merge-ready report.

### Verdict and merge, for every PR

- [ ] At the merge-ready head SHA, launch the lanes in one message. One gates lane that runs the unit block. The live lanes from the PR's **Verify, live** block. The perf lane from its **Verify, perf** block. One audit lane that reads the diff and the receipts and distrusts the PR body.
- [ ] Clean only when every lane is `PASS`. Findings go back to the owner. A new head gets fresh lanes and a fresh verdict.
- [ ] <The merge rule. Who merges, squash or stack, and in what order.>

### Boot recipe, for every live lane

Each live lane runs in its own worktree at the PR head and drives the surface through the `run` skill.

- [ ] `git fetch origin <head-branch> && git checkout <head SHA>`.
- [ ] <Start the backend and the surface. Wait for ready.>
- [ ] <Deliver input only through the surface. Name the read-only diagnostics.>
- [ ] Save every screenshot to `<media path>/<pr-id>/lane-<n>/<slug>.png` and return the paths with the report.

## <Task as a verb phrase> (<PR id>)

**Depends on.** <PR id, or None.>

**Files.**

- [ ] Edit `<path>`.
- [ ] Create `<path>`.
- [ ] Delete `<path>`.

**Build.**

- [ ] <One change. Name the symbol and the file.>

**You see.**

- [ ] <One observable result, with the exact log line or screen state.>

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] <Test file and the case it gains.> Run `<command>`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. One lane per load-bearing scenario, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run <the same load-bearing scenario> at trunk and head. If trunk lacks the feature, record that and gate <the behavior the diff adds plus the end state the user waits for>. Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 2. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane <n>. <Scenario.> Save `<slug>.png`. Pass when <predicate>.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. <What is measured at both trunk and head. If trunk lacks the feature, also name the diff-added work and the end-to-end state the user waits for.>
- [ ] Probe. <The command or procedure, run at trunk and at the head, interleaved. Both sides must produce the metric.>
- [ ] Baseline. Record the trunk <value> first.
- [ ] Rule. <Head against trunk, with the number that fails. If the scenarios differ, add absolute budgets for the diff-added work and the user-visible end state instead of an invalid ratio.>

**Review gate.** The user reviews before merge.

- [ ] Copy lane <n> screenshots into `<media path>/<pr-id>-review-<slug>.png`.
- [ ] Post the screenshots in chat. Stop at merge-ready. Wait for the user's go.

**Merge.**

- [ ] Clean verdict at the exact head SHA.
- [ ] Every review finding triaged.
- [ ] Rebased onto current trunk after the verdict, `git patch-id` unchanged.
- [ ] <The owner merges its own PR, or the user lands the stack bottom-up.>

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Audit the decision trail against the transcript per the `show-me-your-work` skill. Reply with the queue table, what merged, and the **Attention** section.

## Appendix A. Prototype evidence

<Each open question a prototype answered, with the branch, the SHA, and the artifact paths. Each question that stays unproven.>

## Appendix B. Alternatives rejected

<Each approach weighed and why it lost.>

## Appendix C. Risks

<Each risk with the PR it lands in and what the owner watches.>

## Appendix D. Links and reading list

<Docs to read before editing. The decision trail path.>
````

**Reply:** the plan path, the PR ids with their dependencies and the review-gated set, what the prototypes proved and what stays unproven, and the check output.
