# Model the Domain

**Applies when** writing stateful logic, or when code branches a lot or repeats a shape assumption across files.

Encode the domain in a data structure instead of scattering it across conditionals.

**Why:** scattered booleans and repeated shape assumptions are accidental complexity. A structure that matches the domain makes invalid states unrepresentable and deletes branches. Choosing it at write time is cheap. Recovering it later reads as a refactor and gets deferred.

Reach for structures like these:

- A state machine instead of scattered booleans, phases, or lifecycle checks.
- A typed object instead of loose parameters or repeated shape assumptions.
- A map, registry, lookup table, or sum type instead of branching spread across files.
- A reducer or command/event model instead of ad hoc state mutations.
- A module organized around one body of domain knowledge instead of a sequence such as load, validate, transform, save. Execution order is not ownership.
- A small module boundary that gathers repeated behavior, ownership, or invariants.
- A queue, cache, index, graph, or normalized collection where the access pattern calls for it.
- When none fits, write down what the code must never allow and how the data gets read, then find the structure that encodes exactly that.

Do not force an abstraction. Boring code that is already clear, local, and unlikely to grow stays. Be skeptical of any abstraction that adds indirection without removing branches, duplicated rules, invalid states, or lifecycle risk.

**Signs you skipped this:** a new feature grows an existing if/else chain by one branch. A second boolean must stay in sync with the first. Phase-named modules repeat the same domain rules across steps.
