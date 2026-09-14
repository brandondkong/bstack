# Issue tracker (Linear)

## What this source holds

- Issues describing features and bugs, and their motivation
- Comments recording clarifications, scope changes, and decisions
- Parent and sub-issue relationships, from initiative down to task
- Projects with attached documents, often the PRD or spec
- Labels (`compliance`, `customer-request`, `perf`, `incident`) that classify the motivation
- Blocking, related, and duplicate relations
- Linked GitHub PRs and attachments

Linear is where the product and business forcing function lives: "customer X asked" or "this is for the Q3 compliance push".

## How to search it

Tools are under `mcp__plugin_linear_linear__`. Issue identifiers look like `ENG-123`. A `P-` prefix is a project, not an issue.

1. **Start from linked tickets.** For every ticket ID in the anchor, `get_issue` with `includeRelations: true`, then `list_comments` with `issueId`. Read every comment.
2. **Search by keyword.** `list_issues` with `query` set to the feature name, a key symbol, an error string, or the business term. Try several phrasings. Add `createdAt` as an ISO date to bracket the ship date, and `includeArchived: true` for old work.
3. **Walk the tree.** A sub-issue is tactical. Its parent often carries the why. Use `parentId` on `list_issues` to see siblings, and `get_issue` on the parent.
4. **Read the project.** `get_project` with `includeResources: true` lists attached documents and links. `list_documents` with `query` or `projectId`, then `get_document`, reads the specs.
5. **Follow relations.** Duplicates chain back to a canonical ticket. Blocking relations point at the constraint.
6. **Check labels and milestones.** `list_issue_labels` for the label vocabulary, then `list_issues` with `label`. Milestones tie work to a deadline, which often is the motivation.

## If the target looks defensive

`list_issues` with `label` set to each of `incident`, `sev`, `postmortem`, `reliability` (whichever exist in `list_issue_labels`), and with `query` set to the error string the code guards against, bracketed to the weeks before the ship date.

## What good evidence looks like

- A description stating the business problem: "Acme needs X for their SOC2 audit"
- A comment recording a decision: "going with B because A would touch the billing service"
- A parent issue titled like an initiative: "Reduce payment failures"
- An attached PRD or spec
- Labels like `customer:acme`, `incident-followup`, `perf-regression`

## Pitfalls

- **Scope drift.** The ticket a PR cites may have been reopened with a different scope. Read the whole history.
- **Template boilerplate.** A required "Why" section filled with "improve user experience" is not an answer.
- **Stale tickets.** Old tickets describe a plan that changed. Compare dates against the code's ship date.
- **Access.** An issue you cannot open is a gap. Say so, do not guess.

## What to return

For each relevant ticket: identifier and title, the motivation quoted verbatim from the description or a comment, labels, parent, project, author, created and closed dates, and the URL.
