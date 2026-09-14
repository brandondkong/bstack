# Build the Lever

**Applies when** doing any non-trivial work, not just bulk work: edits, migrations, analyses, checks.

Build the tool that does the work or proves it instead of doing it by hand. A codemod, script, generator, or a skill your subagents follow.

**Why:** the tool does the work the same way every time and reruns for free. It is also one artifact a reviewer can read and rerun. Hand-done changes can only be re-verified by redoing them. A deterministic script turns "trust me" into "run this".

- Default to building the lever. Skip it only when the task is trivial, a couple of obvious edits you can see at a glance.
- Do the first unit by hand to learn the recipe, then build the tool. Rerun it on that unit and diff against your hand-done version. Make it safe to rerun.
- Codemod or script for edits, generator for repetitive files, a dump-to-sqlite query for analysis, a rerunnable check for verification.
- A deterministic lever beats fan-out. If the tool can process every unit in one pass, run it yourself. Do not fan out delegates to hand-apply what a script can do.
- When you do fan out to subagents, write the lever as a skill they all read: the recipe, the verification contract, and the do-not-touch fences in one file. Keep it outside the delegates' write scope so they cannot quietly edit the contract.
- Applying this principle produces a file. If you cited it and there is no codemod, script, generator, or delegate skill in the diff, you did not apply it.
- Commit the lever when the work outlives the session.

**Balance:** the bar is triviality, not repetition. A one-off still earns a lever when the lever is what makes the work checkable. Build the smallest script that does or proves the job, never a framework (`principles/laziness-protocol.md`).

Distinct from `principles/encode-lessons-in-structure.md`, which turns a recurring instruction into a durable guardrail. This is throughput and reviewability on the work in front of you. For scripting the verification itself, see `principles/prove-it-works.md`.
