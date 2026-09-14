# Redesign From First Principles

**Applies when** integrating a new requirement into an existing design.

Do not bolt the requirement onto the existing design. Redesign as if it had been a foundational assumption from day one.

1. Read every affected file and understand the current design.
2. Ask: if we were writing this from scratch with this requirement, what would we build?
3. Propagate the change through every reference: types, docs, examples, and rationale sections.
4. Think through the whole redesign, then deliver it incrementally (`principles/sequence-verifiable-units.md`).

This preserves option value when a design must absorb a change. It questions the design's shape. `principles/attack-the-premise.md` questions a fact the design assumes.
