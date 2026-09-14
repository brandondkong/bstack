# Boundary Discipline

**Applies when** wiring validation, error handling, or framework adapters.

Validate, narrow, and handle errors at system boundaries. Trust internal code unconditionally. Keep business logic in pure functions and the shell thin and mechanical.

**Why:** scattered validation is noisy, redundant, and gives a false sense of safety. Logic kept out of framework wiring can be tested without the framework.

- **At boundaries** (CLI args, config files, external APIs, network protocols, database rows): validate, return errors, handle defensively. Parse raw data into domain types here, once.
- **Inside the system:** typed data, error propagation, no re-validation. No redundant null checks deep in call chains for what the boundary already checked.
- **Across the boundary:** expose domain concepts, not the boundary's private representation. Do not re-export transport, storage, framework, or wire types through the public surface. General-purpose mechanism stays inside. Special-purpose policy sits at the edge.
- **Pure functions do the work.** Parsing is a pure transform from raw bytes to typed state. Prompt construction is structured state in, string out. Scoring is a pure transform from state to results. The shell just calls them.

**The tests:**
- Is this data crossing a system boundary right now? If not, validation here is redundant.
- Can this be a pure function that the shell just calls? If yes, extract it.
