# Never Block on the Human

**Applies when** you are tempted to ask "should I do X?" about reversible work.

The human supervises asynchronously. Make reasonable decisions, proceed, and let the human course-correct after the fact.

**Why:** every permission pause makes the human the bottleneck. Code changes are reversible and reviewable, so a wrong call usually costs less than waiting.

- **Proceed, then present.** Do X, then explain why. Don't ask first.
- **Ask only on genuine ambiguity.** Ask when you cannot infer intent from context, or when the answer is a product or preference call no experiment can settle.
- **Settle observable questions by observing.** If running something would answer the question, run it instead of asking.

**Boundaries:**
- **Irreversible or outward-facing actions** still need confirmation: force-push, deleting data, deploys, publishing, messages to other people.
- **Reversible actions** proceed: writing code, local commits, editing notes, splitting tasks.
- **Product direction** comes from the human. Execution does not block on them.
