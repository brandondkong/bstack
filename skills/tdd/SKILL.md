---
name: tdd
description: TDD, failing test first, regression test. Use only when the user asks for one, or a bug has an obvious cheap local test target. Otherwise skip it and say why.
disable-model-invocation: true
---

# TDD

Make the broken behavior executable before touching production code. The deliverable is one focused regression test that fails before the fix, passes after it, and is committed ahead of it.

This runs inside **Bug fix** (`../bstack-mode/playbooks/bug-fix.md`). That playbook's step 5 is the one-line summary of this skill. Reproduce and root-cause first, its steps 1 and 2. Then this skill sets the order of the rest. The test goes red before the fix is delegated, not only before it is committed.

## When it applies

Only when the user asked for TDD, a failing test, or a regression test, or when the bug has an obvious cheap local test target. Skip it, and say why in one line, when the test would need broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state, vague reproduction steps, or fixture churn unrelated to the bug. Prefer no new test over a bad one.

## Steps

1. Name the intended behavior, the current behavior, the affected path, and the smallest observable repro.
2. Pick the narrowest executable check. Prefer the test file that already covers that path. If no practical test path is obvious, don't build one from scratch to satisfy the workflow.
3. Write the smallest test that would have caught the bug. It encodes the intended behavior and asserts a literal observed value (`../bstack-mode/principles/test-behavior-not-implementation.md`). It does not mirror the current implementation.
4. Run it before the fix. It must fail for the intended reason. If it passes, or fails for an unrelated reason, fix the test or the repro before editing production code.
5. Commit the failing test on its own (`../bstack-mode/principles/sequence-verifiable-units.md`).
6. Make the smallest production change that satisfies the intended behavior. Delegate it per the playbook's step 3.
7. Rerun the test. When the change has wider risk, also run the adjacent tests, the type check, and lint.

## When a failing test is impractical

Don't skip the regression step silently. Say why, then use the closest executable check. A targeted script, a repro command, browser automation, a snapshot comparison, a log assertion, or a focused integration check.

A bad test mostly tests mocks, encodes implementation details, depends on timing or global state, needs expensive infrastructure for a small fix, or would be deleted right after proving the fix. Don't write it.

## Guardrails

- Never change a test to match a wrong implementation.
- Never weaken an existing assertion unless the expected behavior changed and the reason is clear.
- Keep the test on the bug. No unrelated coverage expansion.
- A flaky bug gets a deterministic test where possible, and the test names the signal it locks down.
- A bug that exposes a class of failures gets the focused test first. Sibling coverage comes after.

**Reply:** the failing-before test or check and the failure it produced, then the passing-after run and any nearby validation. When failing-before could not be shown, say why and name the closest check used instead. Paste the red-then-green output verbatim, as the playbook's reply requires.
