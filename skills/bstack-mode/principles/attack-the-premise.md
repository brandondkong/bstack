# Attack the Premise

**Applies when** two or more fixes that share one premise have failed the same gate.

Suspect the premise, not the fixes. Each failure under a shared premise is evidence about the premise.

- **Write the premise down.** It is the one sentence every failed fix assumed.
- **Take a census before the next fix.** Count the imbalance per actor. The census shows which actors hold the imbalance, not how large it is. Write it as a rerunnable script (`principles/build-the-lever.md`).
- **Read the skew.** If the same few actors hold most of the imbalance on every run, something assigns them that role. Find what assigns it. That assignment is the next "why" (`principles/fix-root-causes.md`).
- **Remove the asymmetry instead of compensating for it** (`principles/laziness-protocol.md`). Rotate the role between actors, randomize the assignment, or move the role so no actor holds it on every run. A return path, a shared pool, a batched hand-off, or a periodic rebalance leaves the assignment in place and adds work on every run.

**Stop:**
- Do not start the next fix before the premise is written down and the census exists.
- If the census is even across actors, the premise is not the cause. Look elsewhere and keep the census as evidence.

Distinct from `principles/redesign-from-first-principles.md`, which rebuilds a design around a new requirement. This questions a fact the current design assumes.
