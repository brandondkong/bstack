### Bug fix

**You own this task. Plan, review, verify.** Delegate the investigation and the fix to subagents. Stay in the lead.

Be scientific. Every shipped line traces to runtime evidence. A change that "might help" is a hypothesis, not a fix, and it does not ship. When evidence refutes a hypothesis, revert what it motivated (`principles/fix-root-causes.md`).

1. Reproduce it yourself on the surface where the user saw it: run the test, the CLI, the server, or the app (the `run` skill launches most projects). Don't hand the repro to the user. If it won't reproduce, force it: synthesize the trigger, tighten conditions, or instrument until it fires. Ask the user only with a specific reason you cannot reach the surface, after driving it as far as it goes.
2. Binary-search the cause. List candidate hypotheses, then eliminate them. Each pass, take the split that cuts the most remaining space and get runtime evidence. Seed hypotheses with `Explore` agents over the subsystem and `git log` over the area for regressions. When state is unclear, add logging and read it as the code runs. Confirm the surviving mechanism with evidence before planning the fix.
3. Plan the smallest fix the evidence justifies (`principles/laziness-protocol.md`). Delegate it to a `bstack-agent` on the code-delegate model (`references/models.md`) with file paths, the root cause, and the success criterion. Review the diff yourself.
4. Verify on the same surface. The original repro now passes. "Inconclusive" or a different surface is not a pass. Say so. Unit tests show branch behavior, not bug absence (`principles/prove-it-works.md`).
5. Commit the failing repro or test before the fix when there is a cheap local test path (`principles/sequence-verifiable-units.md`). The `tdd` skill is the full procedure. Skip it when the test would be expensive or brittle, and say why.
6. Run **Opening a PR** (`playbooks/opening-a-pr.md`).

**Reply:** what was broken, the root cause, the fix, and how you verified it. Paste the failing-then-passing repro output verbatim.
