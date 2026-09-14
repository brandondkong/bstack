# Type System Discipline

**Applies when** designing types, reviewing a function signature, or writing code in any language with a type checker.

The type checker is a proof assistant. Use it to rule out impossible states, mismatched primitives, and unhandled variants before the code runs. A case the types let you ignore becomes a runtime failure the checker could have stopped. Define errors and special cases out of existence instead of adding handlers.

The patterns:

- **Make illegal states unrepresentable.** Model variants as a sum type (`std::variant` in C++, a `Union` of dataclasses in Python), not as a bag of optional fields where contradictory combinations compile. A struct with `completed: bool` and `completed_at: Optional[datetime]` admits completed with no timestamp. Derive the bool from the timestamp, or make the two states two types. If a bug forces the question "can this combination actually happen?", the type is too loose.
- **Build types up, do not carve them down.** A non-empty list is a head plus a rest, not a list with a length check. A valid time range is a start plus a duration, not two timestamps you must keep ordered. Choose the shape that cannot build the illegal value and expose the interface callers need on top.
- **Brand semantic primitives.** `UserId` and `OrderId` are both strings underneath and must not be interchangeable. Wrap them in a single-field struct, or `NewType` in Python. Validate once at construction, trust the type downstream.
- **External data is untyped until parsed.** RPC payloads, JSON, IPC messages, CLI args, config, environment variables, database rows. One parse function at each boundary turns raw input into the typed model (`principles/boundary-discipline.md`).
- **Do not lie to the type checker.** Casts, unchecked coercions, `# type: ignore`, and `reinterpret_cast` are latent runtime crashes. If the checker cannot prove a fact, prove it by validating, narrowing, or refining the model, or accept that the cast is a hazard.
- **Exhaustive matching is the checker's job.** Adding a variant must fail the build until every match handles it. A `switch` over an enum with no `default` and switch warnings as errors in C++, `assert_never` in the fall-through branch in Python.
- **Derive types from authoritative schemas.** When a protobuf, OpenAPI spec, database migration, or design token file defines a shape, generate from it instead of hand-writing a parallel type (`principles/encode-lessons-in-structure.md`).
- **Strengthen a type only where partiality appears.** A runtime assertion, null check, or "this should never happen" marks a type that is too weak. Push that check into the type, then stop. `sum` of an empty list is 0, so it takes the plain list. `head` of an empty list has no answer, so it demands the non-empty one.

The tests:

- Can I write a comment explaining when this combination of fields is valid? Split it into a sum type.
- Do two arguments share a primitive type but mean different things? Brand them.
- Where did this cast or ignore directive come from? Trace it to the boundary and validate there.
- If a variant is added next month, will the checker tell the next agent where to add a case? If no, the match is not exhaustive.
- Is this type duplicating a shape another file owns? Derive instead.
- Am I strengthening this type to keep an operation total, or just to be more precise? If nothing would otherwise fail, keep the plain type.
