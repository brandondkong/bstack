# Long-form documents (Notion)

## What this source holds

- PRDs, technical specs, RFCs
- Architectural decision records
- Design review and meeting notes
- Postmortems
- Runbooks that explain defensive code
- Team pages with domain context

Notion is where the why is written out before it becomes code. A significant feature usually has a doc.

## How to search it

Tools are under `mcp__claude_ai_Notion__`.

1. **Orient.** `notion-fetch` with `id: "self"` once. It reports whether `notion-ai-search` is available on this connection. If it is, use it for every content search. If not, use `notion-search` with short, specific keywords.
2. **Search.** Try the feature name, key symbols and class names, error strings and user-visible terms, and the PR author's name. Bracket the ship date with `filters.created_date_range` when the search returns too much.
3. **Read the whole page.** `notion-fetch` each candidate. Rationale is often mid-document. Check `truncated` and `unknown_block_count` before trusting the content is complete.
4. **Read the discussion.** `notion-fetch` with `include_discussions: true`, then `notion-get-comments` with the `page_id`. Reviewers' objections and the author's replies live there.
5. **Follow child pages and links.** Design docs keep "alternatives considered" and implementation notes in sub-pages.
6. **Check meeting notes.** `notion-query-meeting-notes` with a `title` filter for the feature, or a `created_time` window around the ship date.
7. **Search the author's space.** `notion-search` with `query_type: "user"` to get the author's user ID, then a content search with `filters.created_by_user_ids`.

## If the target looks defensive

Search for "postmortem" and "incident" together with the feature name, the file name, and the error string. A postmortem's action items section ties directly to code changes.

## What good evidence looks like

- A PRD with a problem statement matching the target's purpose
- An "alternatives considered" or "rejected approaches" section
- A postmortem naming the target as the fix for a specific incident
- Meeting notes recording "we decided X because Y" in the same date range as the PR
- An ADR with non-trivial context, decision, and consequences

## Pitfalls

- **Outdated docs.** Specs are written before implementation and rarely updated. Cross-check the plan against the PR.
- **Doc versus reality.** A spec says X, the code does Y. Flag the divergence for the synthesizer.
- **Multiple drafts.** Find the finalized or most recently edited one. Check dates.
- **Unlinked docs.** The relevant page may not be linked from anywhere. Broad keyword searches help.
- **Access.** A page you cannot open is a gap. Say so.

## What to return

For each relevant doc: title and URL, authors and last-edited date, the motivation text quoted verbatim with its section, linked pages worth citing, and whether the doc was final or draft.
