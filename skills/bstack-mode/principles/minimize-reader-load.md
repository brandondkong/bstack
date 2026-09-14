# Minimize Reader Load

**Applies when** reviewing or shaping code that is hard to trace.

Maintainability is the work a reader must do to understand the code. Track two independent axes:

1. **Layers to trace.** How many indirections sit between the question and the answer.
2. **State to hold.** How much hidden or mutable context the reader must keep in their head.

**Why:** code is read far more than it is written. Line count, cyclomatic complexity, and "clean architecture" are proxies. A flat file with 50 globals is as hard to reason about as a 6-layer adapter stack, so guard both axes. This is the human analog of `principles/guard-the-context-window.md`. Working memory is finite for readers too.

- **Collapse layers that cost more than they save:** wrappers with one caller, adapters with no second implementation, speculative indirection never used. Inline them.
- **Make adjacent layers change the abstraction.** A layer that repeats the same methods and arguments adds load without compression. Collapse pass-throughs.
- **Demand interface compression.** A broad interface that hides little makes readers learn both the surface and the implementation. Prefer boundaries that hide meaningful decisions.
- **Shrink state scope:** pure functions over mutations, locals over fields, fields over module state, module state over globals. Derive instead of sync.
- **Name the invariant at the boundary,** not in every consumer, so the reader learns it once.
- Before adding a layer or a piece of state, ask whether it reduces reader load somewhere else by at least as much.

**The test:** can a new reader answer "where does X come from?" and "what can change X?" in under 30 seconds? If not, cut layers or cut state.
