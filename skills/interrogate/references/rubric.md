# Review rubric

Review through the lenses that apply. Not every lens applies to every change.

Bug hunting at scale and security scanning are handled by other tools before this review. Under Correctness, cover only what needs the whole change in view.

## Correctness

- Idempotency. What happens if this operation runs twice, or a previous run crashed halfway? If the answer depends on what state was left behind, a reconciliation step is missing.
- Concurrency. If several actors can touch the same mutable state (files, branches, shared data), is access serialized structurally (locks, sequential phases, exclusive ownership) or by a convention that will not hold?
- Error handling. Are errors caught, propagated, or silently swallowed? Does the sad path work, not only the happy path?

When you find a bug, trace the execution path and show the call chain that triggers it. "This could be nil" is not a finding.

## Root causes vs. symptoms

Is the code fixing the actual problem or papering over a symptom? Answering this needs more than the changed files. Read the callers, callees, type definitions, and sibling modules. Understand why the code exists before judging whether the change lands at the right layer.

- Guard clauses that mask a deeper invariant violation.
- Retry logic that hides a broken contract.
- Type casts that silence a modeling error.
- A workaround. Ask why it is needed and what a proper fix would look like.
- A fix in module A that belongs in module B's contract.
- An instruction where structure would do. If the fix is a comment saying "don't do X" or a convention to remember, ask whether a type constraint, lint rule, or runtime check could make the wrong thing impossible.

## Structural integrity

Does the code fit the system it lives in?

- Boundary discipline. Is validation at the system boundary, or scattered through business logic? Validate once where data enters, then trust it inside.
- Abstraction level. Does the code mix high-level orchestration with low-level detail?
- Coupling. Does the change add dependencies that make future changes harder?
- Data model fit. Do the data structures match the actual access patterns? The right structure makes downstream code obvious. The wrong one fights at every turn.
- Bolted-on vs. integrated. Does the change read as if the design always accounted for it? If the requirement had been known from the start, would the code look like this?
- Legacy dual paths. Does the change add a new API while keeping the old one alive? With no external consumers, migrate callers and delete the old path in the same wave.

Do not penalize simple code for lacking abstraction. Premature abstraction is worse than duplication.

## Verification

Can you tell this code works from reading it?

- Are there tests? Do they test behavior or implementation details?
- Are there assertions or invariants that would catch a regression?
- For a bug fix, is there a test for the bug?
- For an integration boundary, is the full path tested?
- Does it check the real thing, not a proxy? Liveness read from a file mtime or a cache instead of the actual value is a gap.
- For delegated or async work, does the code verify actual output artifacts, or trust self-reports and summaries?

## Complexity budget

Is the complexity justified by what the code accomplishes?

- Code that could be simpler without losing correctness or clarity.
- Abstractions that serve one call site.
- Configuration or parameters for cases that do not exist yet.
- Dead code, unused imports, vestigial parameters.
- "Just in case" paths with no current caller.
- Compatibility scaffolding kept alive after the migration finished.
- Features, controls, or options that do not earn their place. A half-finished feature is worse than a missing one.

Simpler is better unless simpler is wrong. Three lines of duplication beat a premature abstraction.
