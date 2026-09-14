### Prototype

**You own the design decision, not the code. The prototype is a throwaway instrument. The real build follows Feature.**

This is the playbook behind "don't ask what you can observe". About to ask the user which approach? Build the cheapest thing that shows the answer and let the result decide. Ask only for a product or preference call no sketch can settle (`principles/never-block-on-the-human.md`).

The one playbook where the Laziness Protocol's "smallest change" and the verification bar invert. Speed over polish. Code quality does not matter. No planning. The rigor is in picking the right design cheaply. Propose variations the user didn't ask for. Throw an approach away and try another.

1. Scope the decision the prototype exists to make. Which layout, which interaction, which density, or for an empirical fork which behavior, timing, or approach. No decision means no prototype. Route to **Feature** (`playbooks/feature.md`).
2. Gather references when the design space is open. Search prior art, summarize a short moodboard of themes, palettes, and layouts, and let the user pick directions before building. Skip when the direction is set.
3. Build throwaway in the session scratchpad directory, never in production source. For a visual decision, vanilla HTML/CSS/JS or the lightest stack that renders the idea, CDN deps, a dev server with hot reload. For a behavioral or timing decision, the smallest script that exercises the question. No production framework, no tests, no abstractions.
4. When comparing alternatives, build them behind one switcher (buttons or a keypress), each variant labeled. Build the variants you would otherwise only describe, so the design space is exhausted cheaply instead of argued.
5. Verify on the matching surface. For a visual decision, launch it (the `run` skill), drive the interaction, and screenshot each variant yourself. For a behavioral or timing decision, log the timing, print the output, or watch the render. The observation is the test here, not an assertion.
6. Present alternatives, tradeoffs, and a recommendation. The output is the decision plus the throwaway artifact, not shippable code. Hand the chosen direction to **Feature** (`playbooks/feature.md`) for the real build.

**Reply:** the variants explored, the evidence (screenshots for a visual decision, the observed output or timing for a behavioral one), tradeoffs, your recommendation, and the scratch path. Say plainly that the prototype is throwaway.
