---
name: interrogate
description: Interrogate, adversarial review, challenge this, tear this apart. Two reviewers stress-test a change against a strict quality rubric, then you triage every finding into act on, consider, noted, or dismissed.
disable-model-invocation: true
---

# Interrogate

An adversarial design-and-quality review that ends in a verdict, not a list. `/code-review` already fans out finders for correctness bugs and `/security-review` covers security, so run those for bugs. Interrogate asks what they do not: is this the root cause or a symptom, does the shape fit the system, is the complexity earned, would a demanding reviewer accept this file, and which findings deserve action. Nothing is auto-applied.

## 1. Scope

When the user points at files or a diff, review that. On a feature branch, run `git diff main...HEAD` (or the real base branch) for the full changeset. When the user means recent work, gather those files. Package the diff plus the surrounding files a reviewer needs to follow calls and types.

## 2. Intent

Write one paragraph stating what the change is for, drawn from the user's message, commit messages, the PR description, and the code. If the intent is unclear, ask with `AskUserQuestion` before spawning anyone. Reviewers judge the execution against this intent and never question the intent itself.

## 3. Reviewers

Spawn two reviewers in one message, one on the judgment model and one on the code-delegate model (`../bstack-mode/references/models.md`). They are two Claude models on the identical prompt, not two vendors. A finding both raise independently is the consensus signal. A finding one raises alone is still read, and weighted accordingly. Add a third reviewer on either model only for a large or contested change.

Each reviewer gets `references/reviewer-prompt.md` with the placeholders filled: the intent, the diff or files, `references/rubric.md`, and `references/code-quality-review.md`. Tell each it may read and search but must edit nothing.

## 4. Synthesize

Parse every finding. Merge findings that describe the same issue in different words and note which reviewers raised each. Mark consensus findings, lone findings, and direct disagreements where one reviewer flags something and the other says the opposite.

## 5. Lead judgment

You are the lead reviewer, a pragmatic senior engineer with the whole conversation in view, not a neutral aggregator. Read `references/lead-judgment.md`. Sort every finding into one bucket with a one-line reason and the reviewers who raised it:

- **Act on.** Real issues of correctness, security, or maintainability given the actual goals. These would block a PR. More than five means you are not filtering.
- **Consider.** Legitimate, but the cost of addressing it now is unclear. Worth the user's attention.
- **Noted.** Valid but not actionable now.
- **Dismissed.** Wrong, nitpicky, or missing context, with the reason.

## Output

```
### Intent
> the Step 2 paragraph

### Reviewers
- Reviewer A: <model>, N findings
- Reviewer B: <model>, N findings

### Act on
### Consider
### Noted
### Dismissed
### Agreement map
```

Under each bucket, one entry per finding with the description, who raised it, and why it landed there. The agreement map says where the reviewers agreed, where they diverged, and what that pattern says about the change.
