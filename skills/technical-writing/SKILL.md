---
name: technical-writing
description: Write or review docs, RFCs, readmes, PR descriptions, and commit messages to a layered standard. Diátaxis mode, Google developer style, STE instruction rules, Global English syntax.
disable-model-invocation: true
---

# Technical writing

Write for a tired engineer reading once. Four layers, one question each. What kind of document is this? How do sentences address the reader? How much does each sentence carry? Can any sentence be read two ways? Apply all four, then run the `unslop` skill over the result. It owns word choice, filler, passive voice, and formatting tells, so this skill does not repeat them.

Above the layers:

- Cut every word that does no work. If the sentence survives without it, it goes.
- Use the short everyday word. A long word has to buy its length with precision.
- When a rule makes a sentence worse, fix the sentence another way or leave it alone. A sentence that follows every rule and sounds machine-written has failed.

The codebase is the word list. Write the real symbol, file, flag, or command name, never a synonym or a description of it. A named pattern is fine when the doc defines it on first use. When you meet a metaphor word that belongs in rule 26 of the `unslop` skill, propose it and its replacement in your reply. Don't edit that skill.

Vary the rhythm. A short sentence lands a point. A longer one carries a fact with its condition or consequence. Split the sentence that carries two thoughts and keep the long one that carries one. Prefer the specific sentence. "A column rename fails the build" beats "schema changes can cause issues".

## Pick the mode first (Diátaxis)

One document, one mode. Does the content inform action or understanding? Does it serve learning or work?

| | Learning | Work |
|---|---|---|
| Action | Tutorial | How-to |
| Understanding | Explanation | Reference |

**Tutorial.** The learner's success is your job. Open with what they will build. Every step produces a visible result, and you say what they should see. Explanation gets one clause and a link. Write as "we", in commands.

**How-to.** Solve a problem a person has, not an operation the machine can perform. Assume competence. Action only, with links instead of background. Allow forks ("If you want x, do y"). Name it by the task, "How to calibrate the radar array", not "Radar array calibration".

**Reference.** Describe, and only describe. Dry, complete, sure, no hedging, no opinion. Mirror the structure of the thing described. Generate from code where possible.

**Explanation.** One bounded topic anchored on a real why question. Design decisions, history, constraints, alternatives. Opinion is allowed here and nowhere else.

Don't mix modes. No reference tables in a tutorial, no hand-holding in reference, no arguing in a how-to. Split and link.

## Address the reader (Google developer style)

- "You", in the present tense. "Will" only for things that happen later.
- Instructions are commands. "Click Submit." Never "should be done".
- Condition before instruction. "To delete the document, click Delete."
- Common case first, exceptions after.
- Never "simply", "easy", or "quickly" in a procedure. No "please".
- Don't pre-announce future support. Don't start consecutive sentences with the same phrase.
- Link text says where the link goes. Never "click here".
- Headings carry the point, in sentence case. A task heading is a bare verb phrase ("Create an instance"). A concept heading is a noun phrase. One h1, no skipped levels.
- Numbered lists for sequences, bullets otherwise. Introduce a list with a complete sentence. Keep items parallel.
- Code in code font, UI elements in bold, serial commas. Drop "etc." and say up front that a list is partial.

## One statement at a time (STE)

- One instruction per sentence. One thought per sentence elsewhere.
- Split instructions over about 20 words and other sentences over about 25.
- The warning or condition comes before the step it guards.
- Keep "the" and "a". "Remove backup file" reads two ways. "Remove the backup file" reads one.
- One meaning per word, one word per action. If "check" means inspect, don't also use it for restrain. "Start" everywhere, never "initiate" in the next paragraph.

## Leave no sentence open to two readings (Global English)

- Keep "only" and "not" next to the word they change. "Only fails on growth" and "fails only on growth" differ.
- Break long noun strings. "The proto import budget check script" becomes "the script that checks the proto-import budget".
- Every "it", "they", and "this" points at one obvious noun. Repeat the noun when in doubt. Never point "this" or "which" at a whole clause.
- Give every clause its verb. "Phase 1 moves the converters and Phase 2 the runtime" leaves Phase 2 without one.
- Keep the small words that show structure ("Ensure that the switch is off"). Repeat the article when two things could read as one ("the client and the host").
- Say which parts "and" or "or" joins when a sentence can group two ways. "Both...and", "either...or", and "if...then" are free.
- Periods, not semicolons. Parentheses hold a full grammatical unit. No "(s)" plurals. No slashes, so "a, b, or both", not "a/b".
- One name per thing, everywhere. "The gate", "the ratchet", and "the budget check" for one thing teaches three things. Don't reword a sentence whose meaning did not change.
- No idioms, Latin abbreviations, or metaphors.

## Repo specifics

- PR descriptions and commit messages are writing. Every layer except Diátaxis applies. A PR body is a briefing a reviewer reads in under a minute, with the sections in `../bstack-mode/playbooks/opening-a-pr.md`. Link logs and metric tables, never paste them.
- Product UI strings are not documentation.
- Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.

Sources: diataxis.fr, developers.google.com/style, asd-ste100.org (Issue 9), and Kohl's The Global English Style Guide.
