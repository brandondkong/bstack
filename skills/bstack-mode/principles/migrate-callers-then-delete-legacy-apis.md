# Migrate Callers Then Delete Legacy APIs

**Applies when** introducing a new internal API while old callers still exist.

Migrate the callers and delete the old API in the same wave. Do not preserve compatibility layers.

**Why:** keeping both paths creates dual-path complexity, slows cleanup, and makes the codebase feel append-only.

- Do not keep a legacy path only because internal callers still exist.
- Inventory the callers, migrate them, and delete the old API in the same change. Grep for the old symbol in code, strings, and docs.
- Treat a temporary adapter as exceptional and time-boxed, never default architecture.
- Update tests to assert the new contract. Delete tests that only protected pre-refactor implementation details (`principles/test-behavior-not-implementation.md`).

**It applies when:**
- No external users depend on backward compatibility.
- The project can absorb a coordinated breaking change.
- The new API is part of a simplification or refactor (`playbooks/refactoring.md`).
