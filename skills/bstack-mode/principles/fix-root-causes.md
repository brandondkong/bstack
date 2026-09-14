# Fix Root Causes

**Applies when** debugging.

Do not fix symptoms. Trace every problem to its root cause and fix it there.

**Why:** symptom fixes accumulate. Each workaround makes the system harder to reason about, and the real bug stays.

- Reproduce first.
- Ask "why" until you reach the root cause.
- Do not add guards that silence a failure. A nil check that hides a crash is a symptom fix.
- If a workaround needs a paragraph-long comment to justify it, fix the code instead.
- Fix the pattern, not only the instance. Grep for the same shape and fix every occurrence.
- When stuck, instrument. Add logging and read the actual error. Don't guess.

**Restart bugs.** When something fails only after a restart, suspect stale persistent state first: config files, caches, lock files, serialized state. If clearing a state file restores behavior, the fix is validating that state.
