# Exhaust the Design Space

**Applies when** facing a novel UI interaction or architectural decision with no precedent in the codebase.

Build two or three competing prototypes or sketches. Compare them side by side. Only then commit. Building the wrong thing costs more than exploring three options.

A second flavor of the first shape does not count. Each candidate must differ in structure, not in parameters. To build them in parallel, spawn one `bstack-agent` per candidate on the same brief, each with `isolation: "worktree"`, then read every result before choosing.

**It applies to:**
- Novel UI interactions with no prior art in the codebase.
- Architectural choices with multiple viable approaches.
- Product decisions where the experience depends on feel, not logic.

**It does not apply to:**
- Mechanical implementation where the pattern is established.
- Bug fixes or refactors with a clear target state.
- Changes where constraints dictate a single viable approach.
