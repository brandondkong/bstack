# Separate Before Serializing Shared State

**Applies when** concurrent actors might write to the same file, branch, key, or state object.

First ask whether the actors need the same mutable object. If not, eliminate the sharing. Only when one shared writer is a real invariant, serialize access structurally. Instructions and conventions are not concurrency control.

**Why:** concurrent writes to shared state produce races that are intermittent, hard to reproduce, and expensive to debug.

1. **Identify the shared mutable state:** files both read and write, branches both push to, APIs both define and consume.
2. **Default: eliminate the shared write target.** Do these actors need one canonical object, or are they publishing independent facts? Give each actor its own file, key, branch, or state directory, and merge only at the read or reporting boundary. Two workers writing their own field into one `state.json` is still shared mutation. `indexer-state.json` plus `metrics-state.json` is not.
3. **Only when one shared target is a real invariant, serialize structurally:** lockfiles, sequential phases, a single-writer actor, or atomic compare-and-swap. Treat "we need a lock" as a design smell to check, not the default answer.

For parallel subagents this means one `isolation: "worktree"` per writer, with disjoint file ownership stated in each brief.
