---
name: how
description: "Use for \"how does X work\", a code walkthrough before changing something, or placement questions like \"where should this live\". Explains a subsystem's architecture and runtime flow with cited files."
disable-model-invocation: true
---

# How

Answer "how does X work" at the level of a senior engineer onboarding onto the subsystem. Enough to build a working mental model, not annotated source. For "why is it shaped this way", use the `why` skill instead.

## 1. Size the question

If the scope is ambiguous, state your interpretation in one line and proceed. The user can redirect.

- **Simple.** One module, one utility, one function. No explorers. One explainer explores and explains in a single pass. Go to step 3.
- **Complex.** A subsystem across several files or services, a cross-cutting feature, a full architectural overview. Explorers first, then the explainer. Go to step 2.

When in doubt, take the simple path.

## 2. Explore (complex only)

Split the question into 2 to 4 angles, each a distinct slice: the entry point and call flow, the data model, the boundaries with neighboring subsystems, configuration and failure paths. One message, one `Agent` per angle with `subagent_type: "Explore"` and the model inherited (`../bstack-mode/references/models.md`). Each gets `references/explorer-prompt.md` with the question and its angle filled in. Raw file dumps stay in the explorers. Only their findings come back here (`../bstack-mode/principles/guard-the-context-window.md`).

## 3. Explain

One `Agent` with `subagent_type: "bstack-agent"` on the judgment and prose model (`../bstack-mode/references/models.md`). Build its prompt from `references/explainer-prompt.md`. For a complex question, inline every explorer's full output where marked. For a simple question, put the no-explorers sentence there instead, and the explainer does its own reading. The prompt forbids writes.

## 4. Present

Hand the explainer's output to the user. Light edits for clarity or for context from the conversation are fine. Do not rewrite it. Sections, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.

**Reply:** the explanation itself, with `file:line` references the reader can open.
