### Trace forensics

**You own the diagnosis from the artifact. Load it, shape it, narrow to the cause, attribute to source.**

Distinct from **Runtime forensics** (`playbooks/runtime-forensics.md`), which instruments the live process. Here the capture already exists. The artifact is a fixed dataset. Read it, don't re-run it. Pick the tool by format. A trace parser or short script for a cpuprofile or Chrome trace `.json.gz`, `pstats` for a Python `.prof`, a text editor for `sample` or spindump output, your heap tooling for a heap snapshot.

1. Identify the format and load it with the right tool. Parse large artifacts in a `bstack-agent` on the mechanical model (`references/models.md`) and keep the reduced finding here (`principles/guard-the-context-window.md`).
2. Transform the raw artifact into a form you can query. Dump the trace or heap snapshot into sqlite, one row per sample, frame, or node. Reach the queryable shape before you read.
3. Narrow to the cause. Query for the frames that hold the most time and walk the call tree to the hot path. For a leak, follow the retainer chain from the leaked object to a root. For a spindump, find the thread stuck on-CPU or blocked and its wait reason.
4. Attribute to source. Map the hot frame to file, symbol, and line through the artifact's own symbols. Symbolicate a stripped native frame with `atos` against the matching dSYM. A frame with no source mapping is not yet a diagnosis. Resolve it, or say plainly the artifact does not carry the symbols.
5. Confirm against a paired capture when you have one. Diff a before and an after artifact. Without one, mark the finding as the strongest hypothesis the artifact supports, not a confirmed cause.
6. Hand back a cited diagnosis, no fix unless asked. Route to **Bug fix** (`playbooks/bug-fix.md`) or **Perf issue** (`playbooks/perf-issue.md`) once the cause is known. Throughput checkpoint is the one line `throughput checkpoint: n/a, read-only forensics`.

**Reply:** the artifact and its format, the reduced finding, the source location, the artifact paths, and whether a paired capture confirmed it.
