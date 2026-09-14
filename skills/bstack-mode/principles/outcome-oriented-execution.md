# Outcome-Oriented Execution

**Applies when** running planned rewrites and migrations with explicit phase boundaries.

Converge on the target architecture. Do not preserve smooth intermediate states with throwaway compatibility code.

**Why:** keeping every intermediate step fully stable creates temporary compatibility code that becomes long-lived debt. Prove correctness at explicit verification boundaries instead.

- Prioritize end-state integrity over transitional stability.
- Intermediate breakage is acceptable when it is planned, scoped, and reversible. Declare up front where it is allowed.
- Keep high-signal checks running for the areas being actively touched while migrating.
- Require full static and runtime verification at plan completion, before declaring done (`principles/prove-it-works.md`).

Use this only for planned rewrites and migrations with phase boundaries. The phases are the verifiable units (`principles/sequence-verifiable-units.md`). Outside that setting, every step stays green.
