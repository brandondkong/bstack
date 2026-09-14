# Laziness Protocol

**Applies when** refactoring, sizing a diff, or tempted to add abstractions, layers, or signal threading.

Aim for the most result with the least code and complexity.

- **Prefer deletion.** When asked to refactor or improve, look for removals before additions.
- **Keep the call hierarchy flat.** If answering a question means tracing through more than 3 files or layers, flatten it. A rich interface that hides real work is not a deep chain.
- **Consolidate decisions.** Make each choice in one place and pass the result as a simple value.
- **Minimize the diff.** Make the smallest change that solves the problem. Fewer lines beat elegant boilerplate.
- **Question the threading.** If a task asks you to pass a new signal through types, schemas, or pipelines, stop and look for a more direct path.
- **Fix small leaks early.** Remove tiny pass-throughs, representation leaks, and duplicated choices before they spread.

**The test:** if a human would find the code exhausting to maintain, it is a bad solution.
