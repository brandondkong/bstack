# Subtract Before You Add

**Applies when** sequencing an addition, refactor, or rewrite.

Remove complexity first, then build on the simpler base.

**Why:** adding to a complex system compounds complexity. Removing first leaves less code, reveals the essential structure, and usually makes the next design obvious.

- Sequence removal before construction. Delete dead code, redundant validators, and stub references, then add.
- Cut before you polish. Get to the minimum before investing in quality.
- Design for observed usage, not speculative edge cases. No validators, parsers, or guards beyond what the spec demands.
- Simplify prompts and instructions the same way. Remove redundant instructions and excess templates.
- When a reference has no novel content, delete it rather than leaving a stub.

Treat simplification as a continual investment. Leave the design slightly simpler and more capable, behind the same or smaller surface, than you found it.
