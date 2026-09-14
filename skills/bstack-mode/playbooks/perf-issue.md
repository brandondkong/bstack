### Perf issue

**You own the measurement story. Plan, review, verify the numbers.** Every fix ties to a measurement. Don't read source in place of measuring.

1. Capture a baseline on the surface where the user feels it. Launch it with the `run` skill when needed, then take a profile or a timed run, median of N, not one sample. Save the artifact path. No baseline, no perf claim.
2. Ground hypotheses with `Explore` agents, one specific question each. Don't claim a perf ceiling without running it. Most fixes come from eight strategy families. Use them as hypothesis generators, not a checklist. A family earns an attempt only when the trace shows the signal it names.
   - **Elimination.** Ask whether the hot path needs to exist. A computation nobody consumes, a gate always off for this user, a redundant sync, a legacy path kept "just in case". The trace shows what is slow, never that it is deletable, so this family needs the `Explore` pass, not the profiler.
   - **Divide and conquer.** The dominant cost scales with input size. Split the work so each piece touches less (chunk, shard, prune the search space) or so independent pieces run in parallel.
   - **Caching.** The same computation or fetch repeats on identical inputs. Store and reuse the result. Name what invalidates it before claiming the win.
   - **Indirection.** A cheaper intermediate could absorb the expensive work. An index instead of a scan, a queue that moves work off the interactive thread. Add the hop only when it removes more from the critical path than it adds.
   - **Batching.** Many small operations each pay a fixed overhead (RPC, query, syscall, draw call). Coalesce them to pay it once per batch.
   - **Redundancy.** The wait hangs on one slow instance or attempt. Duplicate the work (replicas, hedged requests, speculative execution) and take the fastest result. The trace must show the wait dominates and the system has headroom.
   - **Lazy evaluation.** Cost lands on results never used or not needed yet (eager init on the boot path, rendering offscreen items). Defer until first use.
   - **Scheduling.** The work must happen, but not during the interactive moment. Move it to idle time, a background warmup, a precompute, or cleanup after the frame commits. The win is perceived latency, so measure the interactive path, not total work.
3. Plan the fix from the trace. If it crosses a function boundary, settle the caller's usage, the types, and the module shape before writing the body. Delegate to a `bstack-agent` on the code-delegate model (`references/models.md`) with the file paths, the hot frame, and the number to beat. Review the diff yourself. Capture a post-fix trace with the same command. Verify each attempt before trying the next (`principles/sequence-verifiable-units.md`).
4. Parse and compare the artifacts, not your impression of them. Dump both into sqlite or diff the parsed output. "Inconclusive" or a different surface is not a pass. Say so.
5. Cite the measurement in the PR as one `before → after` number with its unit. Run **Opening a PR** (`playbooks/opening-a-pr.md`).

For sustained improvement against a metric rather than a one-off fix, run **Hillclimb** (`playbooks/hillclimb.md`).

**Reply:** baseline number, post-fix number, delta, and the artifact paths.
