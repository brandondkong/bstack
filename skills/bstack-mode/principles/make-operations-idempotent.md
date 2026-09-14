# Make Operations Idempotent

**Applies when** designing commands, lifecycle steps, or processing loops that run amid crashes, restarts, and retries.

Design every state-mutating operation to converge to the same end state regardless of how many times it runs or where it starts from.

**Why:** crashes, restarts, and retries are normal. If partial state changes the next run's outcome, every restart becomes a debugging session.

- **Convergent startup:** scan for existing state, clean stale artifacts, adopt live sessions.
- **Content-based cleanup:** compare by content equivalence, not creation order.
- **Self-healing locks:** detect a stale lock by checking whether the owning PID is still alive, and clear it.
- **Idempotent scheduling:** failed work respawns cleanly, and fresh input is regenerated after each cycle.

**The test:**
1. What happens if this runs twice in a row?
2. What happens if the previous run crashed at every possible point?
3. Does re-execution converge to the same end state?

If any answer is "it depends on what state was left behind," the operation needs a reconciliation step.
