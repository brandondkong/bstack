---
name: unslop
description: Cut AI tells from prose. Filler, hedging, AI vocabulary, metaphor jargon, passive voice, and formatting tells. Use when asked to unslop or deslop text, or when writing reads machine-made.
disable-model-invocation: true
---

# Unslop

Edit text to remove the patterns that mark it as machine-written. Keep the meaning and the intended tone.

The "Writing the reply" section of `../bstack-mode/SKILL.md` is the always-on subset. This is the full catalog behind it. Run it on a doc, a PR description, a reply, or a skill before handing it over.

## Process

1. Scan for every pattern below.
2. Rewrite. Same meaning, same tone, no tells.
3. Self-audit. Ask "what makes this obviously AI generated?" and fix what remains.

## Patterns

Rule numbers are stable ids that other skills cite. A removed rule leaves a gap, so the numbering has holes.

### Content

3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete, or expand with a real source.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Use the plain word.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Say "is" or "has".
9. **"Not just X, but Y."** State the point directly.
10. **Rule of three.** Ideas forced into groups of three. Use the natural number.
11. **Synonym cycling.** Protagonist, main character, central figure, and hero in one paragraph. Pick one word and repeat it.
12. **False ranges.** "from X to Y" where X and Y are not on one scale. List the items.

### Style

13. **Em and en dashes.** None, anywhere. Don't swap in parentheses, an en dash, or a spaced hyphen. End the sentence or use a comma. `bstack-check` fails the build on a dash in bstack's own skill and agent files, so there the rule is mechanical. Everywhere else, apply it by hand.
14. **Colons as connectors.** A colon before a list or an example is fine. A colon joining two clauses is a crutch. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" becomes "Describing when the scheduler should fire works best as plain English." Same meaning, no comparison framing.
15. **Boldface overuse.** Don't bold every proper noun or acronym.
16. **Inline-header lists.** The tell is a bold label and colon that restates the line, "**Performance:** Performance improved...". Convert to prose. A bold lead-in that ends in a period, names the item, and is followed by new detail ("**Schema in TypeScript.** Tables live in one file.") is fine.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove from headings and bullets.
19. **Curly quotes.** Replace with straight quotes.

### Communication artifacts

20. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
22. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler

23. **Filler phrases.** "In order to" is "To". "Due to the fact that" is "Because". "It is important to note that" is nothing.
24. **Excessive hedging.** "could potentially possibly be argued that it might" is "may".
25. **Generic conclusions.** "The future looks bright." State the specific plan or fact.

### Jargon

26. **Abstract metaphor nouns.** Substrate, wedge, vector, locus, vantage, nexus, primitive (as noun), harness (as metaphor), surface (as in "API surface"), bedrock, scaffolding (as metaphor), modality, paradigm, gold-plating, ratchet (as metaphor), evacuate (for moving code), endgame, north star, flywheel. Each has a plainer concrete word. "Substrate" is "base". "Wedge in" is "add". "Vector" is "way" or "method". "Gold-plating" is "more than the job needs". "Ratchet" is the mechanism's real name or "a limit that only tightens". "Evacuate" is "move out". "Endgame" is "the last phase".

### Plain speech

27. **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", "types that follow your schema" name a feeling. Name the mechanism or a number instead. "`.toSQL()` returns the exact string sent to the database." "A column rename fails the build." If a sentence cannot be restated as a concrete instruction, fact, or number, cut it. If it could appear unchanged in another project's docs, it says nothing about this one. Cut it.
28. **Dense sentences.** If the reader has to backtrack, split the sentence or drop clauses. One idea per sentence.
29. **Passive voice.** Catch "is/are/was/were + past participle" and name the actor. "queries are validated" becomes "the compiler validates queries". Passive is fine only when the actor is unknown or does not matter.
30. **Adverbs.** "runs quickly" is "is fast" or the number. "significantly improves" is the measured delta. An adverb propping up a weak verb means the verb is wrong.
31. **Fancy synonyms.** "utilize" is "use", "leverage" is "use", "facilitate" is "help", "numerous" is "many", "in the event that" is "if".
32. **Mannered prose.** Aphorisms ("wire it or delete it"), rhetorical fragments, personified code ("the plan holds it"), figurative verbs ("rides along", "stands on"), stock framing phrases. "A dial worth turning" is "a parameter worth varying". Say what you mean. Rule 26 covers the metaphor nouns.
33. **Over-compression.** Dropped articles, verbless fragments, arrows, and abbreviations the reader must decode. "Parser rejects bad date → exit 2, no write" becomes "The parser rejects a bad date, exits with code 2, and writes nothing." Whole sentences, with their articles and verbs.
