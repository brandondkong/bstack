---
name: why
description: "Use for \"why does X work this way\", \"why did we pick Y\", design rationale, or regression history. Cited, confidence-tiered answers from git history and connected tracker or docs MCPs."
disable-model-invocation: true
---

# Why

Find the motivation behind code. The `how` skill says what the code does. This one says what forces gave it its shape.

Operate as a careful, cautious, precise investigator. Code is mechanics, not motivation, so never cite code as evidence of its own intent. A hypothesis embedded in the user's question ("I assume it's for performance?") is a candidate to test, not a conclusion to confirm. The confidence rules in `references/epistemics.md` bind the synthesizer and your presentation.

## 1. Pin the target and the question

The target is a chunk of code, a pattern, a feature, or a named decision. The question is a rationale, a tradeoff, a motivating edge case, an external constraint, suspected dead code, or a history sweep. If the target is vague, pick the most likely referent from the conversation, state it in one line, and proceed.

## 2. Build the code anchor

Do this inline before spawning anyone.

```bash
git blame -L <start>,<end> <file>
git log --oneline -20 -- <file>
git log -S '<literal from the code>' -- <file>
git log -1 --format=%B <commit>      # PR numbers as (#1234), ticket IDs
gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews
```

The anchor is the file paths with line ranges, the key symbols, the commits, the PR numbers, and any ticket IDs. Trace past the most recent commit. The current shape is an accretion, and the newest commit is rarely the whole answer.

## 3. Discover sources, then spawn one investigator per source

Follow `references/source-playbook.md` to find which sources exist in this session. Git and `gh` always do. Then spawn all investigators in one message, one `Agent` per source with `subagent_type: "bstack-agent"` on the bulk-reading model (`../bstack-mode/references/models.md`). Never give one investigator two sources.

Each investigator gets `references/investigator-prompt.md` filled in, with the one matching `references/sources/<source>.md` appended, plus the anchor and the user's question.

Skip a source only with a written reason that lands in Sources Consulted. Two reasons qualify: no MCP is connected for it (a gap, not a choice), or it is provably irrelevant (a build-time script has no production error history). Answer inline without investigators only when one commit's PR body answers the question completely, and say that you did.

## 4. Synthesize

One `Agent`, `subagent_type: "bstack-agent"`, on the judgment and synthesis model. Build its prompt from `references/synthesizer-prompt.md` with every investigator's full output inlined, the skipped sources with their reasons, the anchor, and the question. It reads code and calls MCP tools to spot-check citations. It writes nothing.

## 5. Present

Hand over the synthesizer's output with light edits for clarity. Do not rewrite the confidence language. A hedge is a finding. If the question is a precursor to changing this code, add a Preserve / Change / Avoid / Risk constraint set after Sources Consulted.

**Reply:** the synthesizer's sections: The Question, The Code in Question, What We Found, What We Can Reasonably Infer, Competing Hypotheses, What We Don't Know, Sources Consulted with one line per source including the empty and skipped ones, and Confidence Summary.
