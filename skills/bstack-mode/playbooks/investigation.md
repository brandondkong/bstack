### Investigation

**You own the answer. Plan, route, write.**

Investigation is read-only. It produces a cited explanation or a recommendation, not a code change.

1. Map the mechanics. Fan out `Explore` agents in parallel over the relevant subsystems. Give each a specific question, not "look around". Keep raw file dumps in the agents (`principles/guard-the-context-window.md`).
2. For "why is it like this" questions, also gather history: `git log -S`, `git blame` on the load-bearing lines, linked PRs via `gh`, and tickets via the Linear MCP when the history cites one.
3. Write the answer in this shape: Overview / Key Concepts / How It Works / Where Things Live (`file:line`) / Gotchas. For a decision between alternatives, write a recommendation with a tradeoffs table instead.
4. Label each claim measured, read in code, or inferred. Anything you could check by running a command, run it.

No edits and no commits. If the answer shows a change is needed, say so and stop. The user re-routes to Bug fix or Feature.

**Reply:** the investigation output. For "are we sure?" questions, give your real judgment with reasons, and push back if the premise is wrong.
