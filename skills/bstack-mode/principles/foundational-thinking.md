# Foundational Thinking

**Applies when** choosing core types and data structures before writing logic, sequencing scaffold against feature work, or deciding what concurrent actors share.

Structural decisions protect option value. Code-level decisions protect simplicity.

- **Data structures first.** Define the core types before the logic. Trace every access pattern and pick the structure that matches the dominant paths. Get the shape right and the downstream code becomes obvious (`principles/model-the-domain.md`).
- **DRY the structure, not every line.** Types and data models should converge. Three similar statements still beat a premature abstraction. Prefer explicit over clever.
- **Ask what concurrent actors share.** Before two actors touch one piece of state, ask what happens if the other modifies it at the same time. If the answer is not "nothing", isolate it (`principles/separate-before-serializing-shared-state.md`).
- **Scaffold first.** If something helps every later phase, build it first: CI, linting, test infrastructure, shared types. Setup before features, tests before fixes.
- **Subtract before scaffolding.** Remove dead code, then lay foundations (`principles/subtract-before-you-add.md`).
- **Land coherent increments.** Each commit lands one abstraction or deepens an existing one. Do not spread a new capability across callers as special-case coordination (`principles/sequence-verifiable-units.md`).
