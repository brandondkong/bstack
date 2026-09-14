---
name: arena
description: Arena this. N parallel attempts at the same task, pick the strongest as base, graft the best of the rest in. Splitting a job into slices is swarm, not arena.
disable-model-invocation: true
---

# Arena

N independent attempts at the same task, merged into one result. Every candidate gets the identical brief and produces the whole artifact. You pick a base and graft the best of the others into it. Splitting a job into different slices and aggregating a report is the `swarm` skill, not this.

Use it for one artifact where a single attempt would lock in the wrong shape.

Open a todo list with one entry per phase: Frame, Fan out, Cross-judge, Pick, Graft, Verify.

## Phase A: Frame

The prompt is the contract, since every candidate receives it unchanged.

1. State the artifact each candidate produces.
2. Derive the rubric: what success looks like for this task as 3 to 6 gradeable criteria. It is for you and the judge. Candidates see only the task.
3. Pick the runners. Default is one candidate on each of two different Claude models from the eval-candidates row of `../bstack-mode/references/models.md`. The diversity is across Claude models and briefs, not vendors. Add runners when the arena covers several design directions, naming each direction in its brief. Use one model N times when the work is generation-bound rather than judgment-sensitive.
4. Give each candidate `isolation: "worktree"` (`../bstack-mode/principles/separate-before-serializing-shared-state.md`).

## Phase B: Fan out

Spawn all N `bstack-agent`s in one message, each with the task, the path to the shared grounding, its own output location, and the instruction to produce the artifact plus a short rationale naming the alternatives it considered and rejected.

If a candidate produces nothing, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

After every candidate has finished, spawn one read-only judge on the eval-judge row of `../bstack-mode/references/models.md`, a model no candidate used. When every model in the row was a candidate, run the judge on the judgment model and take its independence from the brief instead. Either way it sees the rubric and the candidates by path label only, never the rationales or the model names. It scores each criterion and recommends a base with reasons. It runs alongside your own reading in Phase D.

## Phase D: Pick a base

Read every candidate end to end. Score each against the rubric criterion by criterion, not on feel. Compare with the judge. Agreement confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous, so read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants. On a tie, prefer the cleaner boundary or smaller API (`../bstack-mode/principles/laziness-protocol.md`). Record the pick, the reason, and the judge's verdict in a synthesis note beside the base.

## Phase E: Graft

Walk each losing candidate once more for what is worth porting, usually one or two things, not most of it. Fold each graft in by hand so the result stays coherent under one mental model (`../bstack-mode/principles/redesign-from-first-principles.md`). Record each graft with its source, and each rejection with its reason.

Convergence on one shape is a strong signal. Note it and ship the consensus without grafting. Wild divergence means Phase A was under-specified. Reframe and re-run instead of averaging.

## Phase F: Verify

The synthesized artifact meets the same bar as any other output (`../bstack-mode/principles/prove-it-works.md`). A problem the arena missed means Phase A was wrong (reframe and re-run) or a candidate caught it and you missed the graft (back to Phase E). Do not paper over it.

## Outputs

One synthesized artifact and one synthesis note naming the base, each graft with its source candidate, the rejections, any dropouts, and the verification result.
