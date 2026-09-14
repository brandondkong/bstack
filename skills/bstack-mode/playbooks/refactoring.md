### Refactoring

**You own the contract. The structure changes. The behavior does not.**

If the cleanup reveals a missing feature or a real bug, split it out. Ship the structural change first against the pinned contract, then route the rest to Feature or Bug fix.

1. Pin the behavior first. Learn the contract with `Explore` agents, then write a characterization test, snapshot, or equivalence script that captures current behavior before any structure moves. Type check and lint are not a pin.
2. Name the structure the code is missing and the target shape: module layout, types, and call graph as if built today. The reshape must delete branches or invalid states, not add indirection. Boring code that is already clear stays.
3. Subtract before you add. Delete dead code, collapse one-caller wrappers, and remove orphan references before introducing the new shape (`principles/laziness-protocol.md`).
4. Move in small steps that keep the pin green. For an API reshape, migrate every caller and delete the old API in the same change. No compatibility shims or parallel paths. Grep for every renamed symbol in code, strings, and docs. Delegate mechanical edits to a `bstack-agent` on the mechanical model (`references/models.md`) with the paths, names, and behavior to hold. Review the diff yourself.
5. Prove behavior is unchanged on the real artifact: rerun the pin, and for larger reshapes diff old-versus-new output (`principles/prove-it-works.md`).
6. Confirm the change earns its place. It must lower reader load: fewer layers, less hidden state, fewer places to look. If it doesn't, revert it.
7. Shape commits as subtraction, then reshape, then follow-on cleanup, each green (`principles/sequence-verifiable-units.md`). Run **Opening a PR** (`playbooks/opening-a-pr.md`).

**Reply:** the structure that changed, the pin, the equivalence proof, the reader-load change, and what shipped versus what got reverted. No new behavior.
