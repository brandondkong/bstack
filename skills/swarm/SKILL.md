---
name: swarm
description: Swarm this. Split a job into slices, one parallel worker per slice, drain them, return one report. Running the same task N times to pick a winner is arena, not swarm.
disable-model-invocation: true
---

# Swarm

Partition a job into different slices, run one worker per slice in parallel, and aggregate their results into a single report. Each worker covers a different piece, and the report is the deliverable. Running N attempts at the same task and keeping the best artifact is the `arena` skill, not this.

Open a todo list with one entry per phase: Frame, Fan out, Aggregate, Report.

## Phase A: Frame

1. State the done predicate and the report the swarm must return.
2. Cut the slices. Each slice has a clear boundary and a result a worker can produce alone. A race, N workers on an identical brief with a selection rule declared up front (`first pass`, `rank all`, or `best-of`), belongs here only when the output is a verdict or a measurement. When the winning artifact is what you keep, use `arena`.
3. Set N from the user or from the slice count. N is the total, and every worker launches in one message.
4. Pick the worker model by role from `../bstack-mode/references/models.md`: the `Explore` agent for read-only slices, the mechanical-edits model for bulk sweeps and log digging, the code-delegate model for slices that write code. For a model race, name each arm's model up front. The arms are different Claude models, so agreement across them is signal, but it is not vendor diversity.
5. Every worker that writes gets `isolation: "worktree"` (`../bstack-mode/principles/separate-before-serializing-shared-state.md`).

## Phase B: Fan out

Spawn all N workers in one message with the `Agent` tool, `subagent_type: "bstack-agent"` (or `Explore` for read-only slices) and the chosen model.

Every brief stands alone, since a worker cannot ask you anything. Include the goal, the scope, its exact slice or race arm, how to verify, and what to report. Reports end with `PASS`, `ISSUES`, or `BLOCKED` and cite evidence: a file and line, a command and its output, or an artifact path.

If a worker drops out, proceed with N-1 and note the gap.

## Phase C: Aggregate

Read every terminal result yourself. For coverage, every slice needs a result, and a missing slice is a named gap, never silently absorbed. For a race, apply the rule declared in Phase A and no other. Never paste raw worker output into the report (`../bstack-mode/principles/guard-the-context-window.md`).

Build a compact result table (slice, status, one-line evidence), a list of one-line evidenced issues, and an explicit list of gaps and dropouts.

## Phase D: Report

Return one consolidated in-chat report: the table, the issue one-liners, the gaps and dropouts, and the race rule when one was used. State whether the Phase A predicate is met.
