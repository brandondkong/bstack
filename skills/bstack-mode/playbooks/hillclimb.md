### Hillclimb

**You own the metric and the experiment's integrity. Supervise and review. Delegate the attempts.** Sustained, iterative improvement of one measurable thing against a target. A one-off fix is Bug fix or Perf issue. This is the loop.

One change, one measurement, keep or revert. Never stack untested changes, and never claim a win from code inspection (`principles/prove-it-works.md`).

1. Ground the workload before choosing the metric. Map the target with `Explore` agents, one specific question each. Name the workload dimensions that can move the result (data size, history, state, concurrency) and pick a case that reproduces the user's complaint. If no case reproduces it, fix the repro instead of hillclimbing. Then fix one metric, the direction that counts as better, and a stop predicate that pairs a target with a floor on attempts, so a lucky early win cannot end the run. "At least 50% better than baseline and at least 10 iterations" is the shape. Use the user's numbers when given, otherwise propose them and proceed.
2. Build the measurement harness, prove its sensitivity, then freeze it. Run contrasting workloads and confirm the target case shows the symptom while easier cases separate. If the harness cannot tell them apart, revise the workload or the metric. Once frozen, one repeatable command emits the metric, sampled enough to clear the noise (median of N). Record the baseline and a green run of the regression gate (the tests that must keep passing) before any change.
3. Open the decision log with the `show-me-your-work` skill, a `decisions.tsv` kept out of the tree. One row per attempt. The hypothesis and change go in `decision`, the mechanism in `why`, the before, after, delta, and gate run in `evidence`, and `kept` or `reverted` in `result`. Read it before each attempt.
4. Each hypothesis names a specific mechanism from step 1 ("defer X off the boot path because it blocks first paint"), not "try memoizing something".
5. Loop, one hypothesis per iteration:
   - Hand the change to a `bstack-agent` on the code-delegate model (`references/models.md`) with a tight scope. Review the diff rather than typing it (`principles/guard-the-context-window.md`). When several independent hypotheses are live, fan them out in one message, each with `isolation: "worktree"`.
   - Measure before and after with the frozen harness, and run the regression gate.
   - Accept only when the metric moves past the noise and the gate stays green. Otherwise revert in full. A tweak that "might help" is not kept.
   - One commit per accepted fix, staging only the files you changed (`git add <files>`, never `-A`). Log the row either way.
   Each iteration ends in a check before the next begins (`principles/sequence-verifiable-units.md`). If the run is unattended, drive it with the `loop` skill. The stop predicate from step 1 stays the only stop rule.
6. Push past the first plateau. After several rejects in a row, change strategy family, combine near-misses, re-read the source, or try something more radical before concluding the hill is climbed. Correctness and simplicity outrank the number. Revert a win that breaks behavior, and keep a simplification that holds the number (`principles/laziness-protocol.md`).
7. Stop when the predicate is met, or when the remaining ideas are marginal and not worth their cost. Don't relax the predicate to meet it, and don't quit while cheap untried hypotheses remain. If you are stuck, say so instead of spinning.
8. Run **Opening a PR** (`playbooks/opening-a-pr.md`) with the accepted commits stacked in the order they landed.

**Reply:** the metric and target, baseline to final with the percent delta, iterations run (kept vs reverted), each accepted fix on one line, the `decisions.tsv` path, and the best idea you would try next if pushed further.
