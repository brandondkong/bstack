# Source control history (git and in-repo)

## What this source holds

- Commit history: messages, dates, authors, diffs
- PR descriptions, review comments, and discussion threads, via `gh`
- Inline comments, TODOs, FIXMEs, deprecation notes
- ADRs, if the repo keeps them
- Tests. Names and assertions encode the edge cases that motivated a change
- Files that change together in the same commits
- CHANGELOG entries and in-repo release notes
- Ticket IDs mentioned in commit messages and PR bodies

The most trustworthy source and the most complete. Everything that went through the repo is here.

## How to search it

Expand the seed commits:

```bash
git log --follow --oneline -- <file>          # history through renames
git log -S '<exact string from the code>' -- <file>   # commits that added or removed this text
git log -G '<regex>' -- <file>                # same, by pattern
git blame -L <start>,<end> <file>             # who wrote each line and when
git show <hash>                               # the full diff
git log <old>..<new> -p -- <file>             # everything between two points
```

For each substantive commit, pull the PR:

```bash
git log -1 --format=%B <hash>                 # PR number as (#1234), ticket IDs
gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews,files
```

The `reviews` and `comments` fields are where the real signal is. Read them in full.

Look for out-of-band material in the repo:

```bash
rg -l -i 'architecture.decision' --glob '*.md'        # ADRs
rg -n -C2 '(TODO|FIXME|HACK|XXX|NOTE)' <target_file>  # notes near the target
rg -l '<symbol>' --glob '*test*'                      # tests that name the why
```

## If the target looks defensive

Search the history for the incident that motivated it. `git log --grep` for "incident", "outage", "hotfix", "revert", "guard", "defensive". A revert followed by a re-apply with a new condition is a strong signal. Read the PR that introduced the guard and the PR immediately before it.

## What good evidence looks like

- A PR description that explains the problem, not only the change
- A long review thread where alternatives were debated
- An inline comment near the target line naming a non-obvious constraint
- A test named for the edge case it guards
- A commit message that cites a ticket or incident
- A CHANGELOG entry with the user-visible rationale

## Pitfalls

- **Squash merges.** Branch commits are gone. Fall back to the PR body and comments.
- **Misleading messages.** "Small refactor" sometimes hides an intentional behavior change. Read the diff.
- **Cargo-culted patterns.** The author may have copied a pattern without knowing why. Find where it first appeared and investigate that commit.
- **Bot commits.** Dependabot, Renovate, and automated backports carry no motivation. Skip them.
- **Code as evidence of intent.** "The function is named X" is not a reason. Reasons come from messages, PRs, comments, tests, and docs.

## What to return

Every commit, PR, comment, or test that bears on the question, with the exact text quoted, the hash or PR number or `file:line`, author and date, and whether it is direct or circumstantial.
