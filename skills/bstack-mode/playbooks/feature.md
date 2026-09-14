### Feature

**You own the design. Plan, review, verify.** Delegate implementation. Stay in the lead.

1. Map the affected subsystem with `Explore` agents.
2. Name the data shape before any logic. Choose its organizing structure: a state machine over scattered booleans, a table or registry over branching, a typed model over repeated shape assumptions. If the change crosses a function boundary, sketch two or three candidate shapes (caller usage, types, module layout) and pick one with a one-line reason. Record a skip as `design skipped: <reason>`. Don't fold the design decision silently into implementation.
3. Write the throughput checkpoint as four todo items. An item that doesn't apply stays with `n/a: <reason>`:
   - **Blocking first steps.** Gates that run before any fan-out.
   - **Independent workstreams.** Disjoint files or layers parallelize. Shared writes serialize.
   - **Shared mutable state.** Split the target first. Serialize only for a real invariant.
   - **Smallest safe decomposition.** If one worker is best, say why.
4. Delegate code-writing to a `bstack-agent` on the code-delegate model (`references/models.md`). The brief names the file paths, the data shape, and the success criteria. Parallel writers each get `isolation: worktree`. Review every diff yourself. Keep comments to non-obvious whys.
5. Verify on the real surface (`principles/prove-it-works.md`). "Inconclusive" is not a pass.
6. Shape the history into small ordered commits, each building and passing on its own (`principles/sequence-verifiable-units.md`).
7. If the design is contested or the diff is risky, run `/code-review` on it and act on real findings.
8. Run **Opening a PR** (`playbooks/opening-a-pr.md`).

Code-coupled work goes to a single owner with the checkpoint inline. Parent-level fan-out is for slices that produce independent artifacts. Spawn a fresh delegate with consolidated scope rather than chaining corrections into an old one.

**Reply:** what you built, what you chose and why, the throughput checkpoint, and open decisions. Use a table for design alternatives.
