# Sequence Work into Verifiable Units

**Applies to** multi-step work (sweeps, migrations, runs of similar edits) and to how you stack commits and PRs.

Order work as small units that each end in a state you can check. Don't advance until the current unit is green.

**Why:** a break caught at the unit that caused it is cheap to localize. A break caught after a batch is buried under work built on a broken base.

**Execution.** Each unit is a bracket: known-good state, one change, run the check, proceed. Rebase onto a clean trunk first so every check measures against the real baseline.

**Delivery.** Stack commits in the order that proves the work. The canonical shape is the failing test first, then the fix on top. Others: a subtraction before the reshape, a baseline capture before the change, the scaffold before the feature. Each commit stands on its own, and the sequence reads as an argument.

- Pick the smallest unit that ends in a check.
- Verify before advancing. Red to green per unit, never deferred to a final batch.
- Order units so the sequence builds confidence for you and for a reviewer.
