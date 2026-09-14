# Epistemics

How to reason about confidence when the evidence is historical, fragmentary, and sometimes contradictory, and how to report it without flattening it into false certainty.

Code does not carry its own motivation. You can read what code does. You cannot read why it exists. That lives in commits, PRs, tickets, and docs, all incomplete, biased, and sometimes missing. Pretending otherwise produces confident guesses the user will act on.

## Confidence tiers

Every claim in the final output sits in one tier. The tier decides which section the claim goes in and how it is phrased.

### 1. Direct

An explicit, textual statement that answers the question. Something an author wrote that says why. Not "the code does X so the author must have wanted X."

- A PR description: "this fixes the bug where users with more than 1000 items could not paginate"
- A ticket: "customer Acme requested this in their security review"
- A code comment: "clamp to 100 because the upstream API rejects larger values"
- A design doc: "we chose A over B because we need persistence across restarts"
- A review comment from the author: "switching approaches since the old one was flaky in tests"

Phrasing: confident, present tense. "This exists because X." Cite the source.

### 2. Supported

Several pieces of indirect evidence converge. No single source states it, but the pattern makes it likely.

- The PR title says "improve performance", the ticket is labeled `perf`, and the neighboring commits all touch the same hot path
- Several tests were added alongside the change, all exercising very large inputs
- The author's other PRs that week all mention the same incident

Phrasing: confident but visibly derived. "The evidence points strongly to X: [the specific pieces]." Cite each piece.

### 3. Inferred

A reasonable reading of the context that nothing states explicitly. The reader must be able to see it is your interpretation.

- The PR does not say why, but the ticket was filed the same morning and the fix merged the same day, so it was likely a hotfix.
- The retry count is 3, matching the convention used elsewhere in the codebase.

Phrasing: hedged. "Appears", "likely", "suggests", "is consistent with", "one reading is". Make the chain explicit: "Given A and B, C seems likely because D."

### 4. Speculative

A plausible hypothesis on thin evidence, with other explanations fitting equally well. Worth presenting, clearly marked as a guess.

- "This might be a workaround for a browser bug since fixed, but we found no contemporary evidence."
- "The threshold may match an SLA commitment, but no SLA doc references it."

Phrasing: "One possibility is X, but there is no direct evidence." Usually lives in Competing Hypotheses.

### 5. Unknown

You looked and could not find out. A valid and valuable outcome. Document it.

Phrasing: name what you searched. "We searched the tracker for A and B, read the 6 PRs that touched this file since 2023, and grepped the repo for the threshold literal. None gave a rationale." That is useful. "We could not find out" is not.

## Phrasing

**Words that claim evidence.** "Because", "the reason is", "was designed to", "fixes", "addresses", "the team decided". These imply Direct or Supported. A citation must sit next to them.

**Words that hedge.** "Appears to", "seems to", "likely", "suggests", "is consistent with", "one reading is", "may have been", "the evidence points toward". Use them for Inferred and Speculative claims.

**Words to avoid.** "Obviously" and "clearly" almost always precede a claim that is not. "Just" ("it's just for performance") hides uncertainty. "I think" turns evidence into opinion; write "the evidence suggests" instead.

## Do not rationalize

Code that makes sense today may have been written for reasons that no longer apply, or that were wrong at the time. Do not retrofit a clean rationale onto messy history. Do not assume the author did the right thing and work backward. Do not assume a consistent pattern was intentional when it may be copy-paste. Do not turn absence of evidence into evidence of absence ("nobody mentioned security, so it was not a concern").

## The sycophancy trap

Users often phrase the question with a guess attached. Treat the guess as one candidate among others and check the evidence independently. If it holds, say so with citations. If not, say so and report what the evidence does support.

## When evidence contradicts

If the PR says one thing and the ticket another, surface both with citations. Both may be true (the ticket motivated the work, the PR is the author's framing), or one may be wrong. Do not pick the one that fits the tidier story.

## When evidence is missing

An honest "we don't know" tells the user the answer is not in the obvious places and that a human (the author, the product owner) is the next step. Filling the gap with a confident guess harms them. Name the gap concretely: the question, the sources searched, the queries run, what came back.

## Calibration check before finalizing

For every claim in What We Found and What We Can Reasonably Infer:

1. Does it have a citation? If not, add one or move it down a tier.
2. Is the phrasing matched to the tier? A Direct claim may say "because". An Inferred claim may not.
3. Is the code itself the evidence for its intent? Then it is not evidence. Remove or reclassify.
4. Is there a What We Don't Know section with specific gaps? An empty one is suspicious. Either the record was unusually complete or something is being swept aside.
