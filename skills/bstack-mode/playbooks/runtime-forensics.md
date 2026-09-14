### Runtime forensics

**You own the diagnosis. Instrument the live process. Don't theorize from source.** The deliverable is a cited diagnosis, not a fix.

1. Capture the live signal on the surface where it happens. A CPU profile for a spinning process (`sample <pid>` or `spindump` for native, `cProfile` or `py-spy record` for Python). A heap snapshot or allocation log for a leak (`leaks <pid>` for native, `tracemalloc` for Python). A real artifact on disk, not a guess.
2. Reduce the artifact to the smoking gun. The function on the hot path, the retainer chain from the leaked object to a root, the loop firing without input. Parse large artifacts in a `bstack-agent` on the mechanical model (`references/models.md`) and keep only the reduced finding here (`principles/guard-the-context-window.md`).
3. Prove the mechanism before believing it. Attach to a native process with `lldb -p <pid>` and break on the suspect symbol. For Python, `py-spy dump <pid>`, or add one log line at the suspect site and re-trigger. The cheap confirmation comes before any fix.
4. Map the finding back to source. File, symbol, and the line that allocates or schedules.
5. Throughput checkpoint is the one line `throughput checkpoint: n/a, read-only forensics`.

**Reply:** the signal captured, the reduced finding, how you proved the mechanism, the source location, and the artifact paths. No fix unless asked. Hand back to **Bug fix** (`playbooks/bug-fix.md`) or **Perf issue** (`playbooks/perf-issue.md`) once the cause is known.
