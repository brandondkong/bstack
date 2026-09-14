# Code quality review

Each reviewer applies this lens in addition to the rubric. It is a strict standard for implementation quality, maintainability, abstraction quality, and codebase health.

Above all, be ambitious about structure. Do not stop at local cleanup. Search for "code judo" moves: restructurings that preserve behavior while making the implementation dramatically simpler, smaller, more direct, and more elegant.

## Baseline

> Perform a deep code quality audit of this change. Rethink how to structure and implement it to meaningfully improve code quality without changing behavior. Improve abstractions and modularity, reduce spaghetti, improve succinctness and legibility. Be ambitious. If there is a clear path to a better implementation that restructures some of the codebase, take it. Be thorough and rigorous. Measure twice, cut once.

## Dimensions

Apply the ones that are relevant.

0. **Be ambitious about structural simplification.** Look for reframings that make whole branches, helpers, modes, conditionals, or layers disappear. Assume a code-judo move is often available that uses the existing architecture better and makes the change dramatically simpler. Deleting complexity beats rearranging it.

1. **Do not let a change push a file from under 1000 lines to over 1000 lines without a very strong reason.** Treat it as a strong smell. Prefer extracting helpers, subcomponents, or modules. Waive only for a compelling structural reason where the resulting file stays clearly organized.

2. **Do not allow spaghetti growth in existing code.** Be suspicious of new ad-hoc conditionals, scattered special cases, or one-off branches inserted into unrelated flows. A weird `if` in a random place is a design problem, not a style nit. Push the logic into a dedicated helper, state machine, or module instead of tangling an existing path.

3. **Bias toward cleaning the design, not just accepting working code.** If behavior can stay the same while the structure gets meaningfully cleaner, push for the cleaner version. Prefer simplifications that remove moving pieces over refactors that spread the same complexity around.

4. **Prefer direct, boring, maintainable code over hacky or magical code.** Treat brittle, ad-hoc, or "magic" behavior as a problem. Be skeptical of generic mechanisms that hide simple data-shape assumptions. Flag thin abstractions, identity wrappers, and pass-through helpers that add indirection without buying clarity.

5. **Push on type and boundary cleanliness when it affects maintainability.** Question unnecessary optionality, `unknown`, `any`, and cast-heavy code where a clearer type boundary could exist. Prefer explicit typed models over loosely shaped ad-hoc objects. When a branch leans on a silent fallback to paper over an unclear invariant, ask whether the boundary should be explicit.

6. **Keep logic in the canonical layer and reuse existing helpers.** Call out feature logic leaking into shared paths and implementation details leaking through APIs. Prefer the existing canonical utility over a bespoke one-off. Push code toward the right package, service, or module instead of normalizing drift.

7. **Treat unnecessary sequential orchestration and non-atomic updates as design smells when the cleaner structure is obvious.** If independent work is serialized for no reason, ask whether it should run in parallel. If related updates can leave state half-applied, push for an atomic structure. Do not chase micro-optimizations, but do flag avoidable orchestration complexity that makes the code brittle.

## Priorities

Structural regressions and missed simplifications first, then spaghetti and branching complexity, then boundary, type, and file-size concerns, then smaller modularity and legibility issues. Do not flood the review with low-value nits when a larger structural issue exists. A few high-conviction comments beat a long list of cosmetic notes.

## Approval bar

Do not approve because behavior seems correct. Presumptive blockers unless the author can justify them: the change keeps a lot of incidental complexity when a code-judo move would delete it, pushes a file past 1000 lines, adds ad-hoc branching that tangles an existing flow, scatters feature checks across shared code, adds an unnecessary abstraction, wrapper, or cast-heavy contract, duplicates an existing helper, or puts logic in the wrong layer when a canonical home exists. When any of these holds, leave explicit, actionable feedback and push for a cleaner decomposition.

## Tone

Direct, serious, and demanding about quality. Not rude, but never soften a major maintainability issue into a mild suggestion. If the code makes the codebase messier, say so. If the implementation missed an obvious dramatic simplification, say that too. "Maybe rename this" is not the finding when the real issue is structural.
