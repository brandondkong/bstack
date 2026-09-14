---
name: figure-it-out
description: Figure it out. When no bstack-mode playbook fits, design a bespoke one with a framing, rigor level, verification harness, hypothesis loop, and committed decision trail. For migrations and step-away work.
disable-model-invocation: true
---

# Figure it out

Check the playbooks first. Open `../bstack-mode/SKILL.md`, match the task against its Playbooks section, and route there when one fits. A large migration is usually `../bstack-mode/playbooks/multi-phase-plan.md` or `../bstack-mode/playbooks/orchestrate.md`. One task driven to a predicate is `../bstack-mode/playbooks/autonomous-run.md`. This skill is the fallback when none matches, not a first choice.

When you do land here, design the playbook before any code. The deliverable is a sequence of phases that scales rigor to the task, runs the scientific method, and leaves a trail a human can audit after stepping away.

Open a todo list whose first item is to read the Principles section of `../bstack-mode/SKILL.md`, then add the phases below.

## Phase A: Frame

Do not start until you can state:

- Done as a falsifiable predicate (`../bstack-mode/principles/prove-it-works.md`).
- Scope, quantified: rough units and effort, plus the blockers grounding surfaced.
- The rigor level, biased high. One-way doors and high blast radius get more, reversible low-stakes steps less. Rigor means gates and artifacts, not "try harder".

Present the framing once. Reversible work proceeds without waiting (`../bstack-mode/principles/never-block-on-the-human.md`), but a multi-hour run earns one checkpoint here.

## Phase B: Design the workflow

Decompose into atomic, independently landable units. Sequence riskiest unknown first. Scaffold and verification come before features (`../bstack-mode/principles/foundational-thinking.md`).

- Build the verification harness before the work, with the baseline captured from the pre-change state, so every check reads as old value against new value.
- For a one-way-door design decision, run the `architect` skill, which runs `arena`. Skip it for mechanical work whose shape is already concrete (`../bstack-mode/principles/laziness-protocol.md`).
- Parallelize only across seams, each writer with `isolation: "worktree"` (`../bstack-mode/principles/separate-before-serializing-shared-state.md`). Do not over-fan.
- Write the phase list down. That list is what the human reviews.

Add the designed steps to the todo list as concrete items between the Phase C and Phase D entries. Run each under the Phase C loop and log its Phase D row as it lands.

## Phase C: Run the loop

Each unit is an experiment. State the hypothesis, make the smallest change, measure against the predicate on the real artifact, keep it if it advanced, revert it if it did not. Verify each unit before starting the next (`../bstack-mode/principles/sequence-verifiable-units.md`).

- Verify by inspecting the artifact, never a self-report. When something passes too easily, suspect the observation before the system.
- Pair delegated work with a judge on a different model (`../bstack-mode/references/models.md`) and audit the delegates' artifacts yourself. If a worker games the gate, reset and harden the brief. If the gate is wrong, fix it in its own change.
- A verdict is VERIFIED, NOT VERIFIED, or INCONCLUSIVE. Inconclusive is not a pass. Never hide a negative.

## Phase D: Keep the trail

Log the run with the `show-me-your-work` skill, one TSV with a row per decision and per unit, evidence as links. Work that lands here is usually ambitious enough to commit the trail so the reviewer reads it in the PR. Prefer evidence produced by committed scripts.

## Phase E: Verify and hand back

Check the whole against the Phase A predicate on the real product, not only the harness. Encode any recurring correction as a gate, lint rule, check, or script (`../bstack-mode/principles/encode-lessons-in-structure.md`).

**Reply:** the playbook you designed, the rigor level and why, the trail path, what is verified against the predicate, and what is still open.
