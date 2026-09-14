---
type: llm
---
PASS if the response says the first step is to reproduce the bug by running the code, and treats the fix as something that comes after evidence. Naming a specific root cause is fine as long as reproduction still comes first.
FAIL if the response jumps straight to a patch as the first action, or lists no reproduction step at all.
