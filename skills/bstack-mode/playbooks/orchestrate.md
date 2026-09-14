### Orchestrate

**You own the program, never the code. Author briefs, drain the queue, keep the frontier green, decide.** For a whole project handed to one standing coordinator session: multi-day, many stacked and coupled PRs, dozens of delegates, the human checking in twice a day. The coordinator lands verified units itself and no worker merges. One task driven to a predicate is `playbooks/autonomous-run.md`. A queue of independent PRs with one owner each is `playbooks/autopilot-full.md` or `playbooks/autopilot-stack.md`. Work one agent could finish inside a session's budget is not a program.

Ceremony scales with the program. On cheap near-identical units, collapse it as each section directs.

Three rules carry the rest.

- Completions are queue events, not interrupts.
- Every spawn carries the standing orders verbatim.
- The brief is the product. A vague brief fails quietly, because a worker cannot ask you a question.

#### Roles

- **Coordinator (this session).** Frames, authors briefs, drains the inbox, owns the human report, makes judgment calls. It never authors or edits code. Conflicted merges, restacks, and code changes are always delegated units. Mechanically landing a verified unit (fast-forward or clean cherry-pick of a worker's commit, then push and merge) is bookkeeping the coordinator does itself, and only because the user asked for the program to land PRs in this conversation. Without that ask, verified units stop at pushed branches, and open PRs are the ceiling. Spawn, resume, and drain only through the `Agent` tool.
- **Sub-coordinator.** A `bstack-agent` that owns one track, authors its workers' briefs, and spawns its own workers and verifiers. Add one only when the program exceeds what one coordinator's drains can manage. Each nested layer re-pays a full orientation, and a blocked sub-coordinator hides its children while the parent idles. It rolls up aggregates at wave boundaries and never forwards raw child reports. Cap in-flight children at roughly ten as a rolling window, never as blocking batches, which cost the slowest child of every batch.
- **Worker / verifier.** A `bstack-agent` per unit. Writers get `isolation: "worktree"`, one writer per branch. Prefer fewer, broader workers. A unit's verifier runs on a model other than its worker's (`references/models.md`). Workers see nothing but their brief, so the brief inlines or points at everything they need.

Depth stays at coordinator, track, worker. Decompose tracks per project. Build, landing, and verification are common cuts, not a required shape.

#### Store

Create `.orchestrate/<project-slug>/` in the work directory, uncommitted (list it in `.git/info/exclude`). Every file has exactly one writer. Owners publish facts, readers aggregate at read time. Plain TSV, JSON, and Markdown, readable with `column -s$'\t' -t` and `jq`.

- `preferences.md` is the standing-orders register: numbered lines, one constraint each (model policy, stack shape and count, verification bar, forbidden paths, escalation policy, whether landing is authorized). Paste it verbatim into every brief. When you catch yourself restating an instruction, append the line before you act (`principles/encode-lessons-in-structure.md`).
- `overview.md` is the durable PR and issue record. Append only.
- `units.tsv` has one row per unit: id, track, state, branch, PR, head SHA, brief path. Update rows in place.
- `frontier.json` is the computed merge frontier, per Stack safety.
- `ledger.tsv` is the verification ledger, per Verification.
- `inbox/` holds completion pointers. `gates.md` parks human gates (question, options, default on no answer).
- `decisions.tsv` is the trail via the `show-me-your-work` skill.
- `status.md` is regenerated from `units.tsv` and `ledger.tsv` at each drain, never hand-narrated.

#### The brief

Every spawn carries all of it. A field you cannot fill is a unit you have not scoped yet.

```
GOAL         one sentence, the outcome, executable by a stranger with no chat access
SCOPE        paths this unit may write; paths it may not; its exclusive worktree or branch
CONTEXT      pointers to files and PRs; upstream reports pasted in full when this unit
             depends on them, because workers cannot see siblings
ACCEPTANCE   checkable criteria, one per line
VERIFY       exact commands, or the `run` skill path, plus known gotchas
TIMEBOX      rough cap on runtime; on expiry, return partial findings and stop
FORBIDDEN    no rebase, no force-push, no push or PR unless the brief grants it,
             no fixes outside scope, plus unit-specific bans
REPORT       status, branch, head SHA, PRs, verdict, what you actually ran, deviations,
             suggested follow-ups
STANDING     <preferences.md pasted verbatim>
```

Size the brief to the unit. A one-command unit gets the template collapsed to a paragraph that still names goal, scope, the verify command, and the report shape. A dependency is a context relay, not just ordering. Missing fields are a refuse-to-spawn condition. Audit one sampled worker brief per sub-coordinator per wave, alongside the wave, never as a gate in front of it. A failing brief stops that track and fixes the sub-coordinator's instructions, because brief quality decays late in a run. Never chain corrections into an old delegate. Respawn fresh with consolidated scope.

#### Steps

1. **Frame.** State the done predicate as something countable ("all 126 units merged, each ledger-verified `unit-test-verified` or better"). Quantify units, effort, expected stacks, and the wall-clock budget. If one agent could finish inside that budget, stop here and run `playbooks/autonomous-run.md` instead. By roughly 70% of the budget, stop spawning and land what is verified. Name the tracks. For a contested decomposition or a one-way door, spawn two or three delegates on the same framing brief, read every result, and pick before the pilot. Present the framing once. Reversible prep proceeds without waiting.
2. **Install the runtime.** Create the store, open the trail, write the standing orders before any spawn, and seed `frontier.json` from existing PRs with `gh pr list --json number,baseRefName,headRefName,headRefOid`.
3. **Pilot.** Push one unit through the whole path: brief, worker, verification, stack entry, ledger row, land. The pilot falsifies the brief template, the verify recipe, and the unit size while that costs one agent instead of fifty. Fix the contract from pilot evidence before any fan-out. On programs of near-identical cheap units, the first unit is the pilot and fan-out starts the moment it lands.
4. **Scale.** Spawn a rolling window of workers up to the in-flight cap, refilling as children finish, all independent spawns in one message. Recompute ready work after each drain. Relay upstream reports into downstream briefs. Sibling communication goes upward only.
5. **Drain.** Run the queue discipline below at every drain point.
6. **Land.** Landing is continuous, never a terminal phase. Integrate from the first verified unit alongside the remaining waves. Keep the frontier green before upper-stack work. Advance `frontier.json` only on merge or reported new head SHAs.
7. **Close.** Drain the final inbox, reconcile every spawned agent to a terminal row (done, abandoned, zombie-reconciled), confirm the predicate on the real artifact (`principles/prove-it-works.md`), confirm every landed PR has a verdict for its current head SHA, audit the trail per `show-me-your-work` including its cross-model review, and encode recurring corrections into `preferences.md` or the brief template. Leave the store intact. It is the postmortem.

#### Queue and drain

- On a completion notification, write one pointer file into `inbox/` (agent, unit, status, report path) and return to what you were doing. Never deep-review inline. A completion that needs review becomes a verifier unit.
- Drain in batches at four points: the end of a critical section, a track rollup, a frontier watcher wake (a background `gh pr checks <pr> --watch`, with a long `loop` heartbeat as fallback), and before a human report. Arrivals during a drain wait for the next one.
- Critical sections you finish first: authoring a brief, a stack operation, a conflict decision, writing a gate, updating ledger or frontier.
- Each drain classifies every pointer (landed, needs-verify, failed, zombie, noise), updates `units.tsv` and `ledger.tsv`, regenerates `status.md`, then spawns the next wave in one message.
- Account for every spawned child at its track's rollup: arrived, respawned, or its scope explicitly absorbed. Silently redoing a missing child's work hides both the wasted spend and the coverage gap.
- A drain turn ends with three lines: counts against the states, what changed, gates open. Detail lives in `status.md`.

#### Stack safety

- The frontier is a computed object, never narrative. Recompute `frontier.json` after every merge and stack mutation from `gh pr view <pr> --json baseRefName,headRefOid,state` over every PR: ordered PR list, branch names, head SHAs, a generation number, the lowest unmerged PR.
- Exactly one stacker per stack rebases or retargets, serialized within its stack. Record the holder in the standing orders. Workers never rebase. Babysitters follow `playbooks/babysit.md`, one per stack, scoped to one frontier generation, and report conflicts to the stacker.
- PR closes and retargets go through the stacker only. Closing a base PR orphans every chain above it. Merges and stack surgery are units with briefs like any other.
- One retro watcher follows merged PRs for reverts, post-merge CI breaks, and orphaned follow-ups.

#### Verification

Scale it to the unit. When VERIFY is a single cheap command, the worker runs it and reports the output, and the coordinator spot-checks receipts. A dedicated verifier agent is for units whose verification is expensive, judgment-laden, or high-blast-radius.

`ledger.tsv` has one row per verdict, keyed by PR number plus head SHA: `live-ui-verified | unit-test-verified | type-check-only | verifier-blocked | verifier-failed`. CI green is an input, not a verdict. Behavioral work needs better than `type-check-only`. `verifier-blocked` is not a pass. `verifier-failed` gets a fix unit, not a re-verify. A verifier overrides a worker's self-report on the same key. A new head SHA voids the row. The ledger answers "was this verified", not memory and not the transcript.

A unit is done when its output is externalized the moment it lands: branch pushed, ledger row written, receipts in the store. Work that exists only in one delegate's context when that delegate dies was never done.

#### Liveness and failure

- Never resume an agent to check on it. Probe read-only: the ledger, `units.tsv`, `gh`, pushed branches, `bstack-trace` on its transcript. Transcript mtime is not liveness.
- A silent death gets a synthetic postmortem row in the inbox (unit, failure mode, last evidence, options). Replan on evidence as it arrives. Never wait for full quiescence.
- Retry by mode. Context or budget exhaustion, respawn with smaller scope. Tool error, retry on a different model. Unknown, retry once. Two retries, then abandon the unit and replan around it.
- A zombie that returns late reconciles against the current frontier and ledger before anything is accepted. Salvage unique findings through a fresh unit, never a blind merge.
- When continued spawning would produce garbage tree-wide, write a stop line at the top of the standing orders, let in-flight work finish, fix the cause, clear it.
- Bound your own retries the same way. After a few consecutive tool aborts, write a terminal handoff per `playbooks/pause-safely.md` and end the run.
- After a session restart, pick up per `playbooks/session-pickup.md`. Re-read the standing orders and `units.tsv`, recompute the frontier, reattach work by PR and branch rather than agent id, respawn one sub-coordinator per track from its stored brief plus current state, drain, resume.

#### Escalation

Reaches the human, batched into `status.md` rather than per item: irreversible or outward-facing actions the user did not already authorize for this program, product or preference calls no experiment settles, a standing order that contradicts observed reality, a program-level dead end that survived a replan. Park each as a `gates.md` entry before asking, and route work around it.

Never reaches the human: frontier nudges, restack mechanics, retries, CI flake triage, review-thread triage, format fixes, scope the brief already forbids (refuse and continue), and "should I keep going". When in doubt, act and log.

Mid-run discoveries fix only what blocks the frontier. Everything else parks in follow-ups.

**Reply:** at checkpoints and close: the predicate and the count against it from `units.tsv` and `ledger.tsv`, tracks and what each landed, the frontier (PR list plus SHAs), verdicts summary, what was abandoned and why, gates awaiting the human (the only asks), the store path, and the trail path. Numbers from the tables, not narrative. PR links.
