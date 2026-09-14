---
name: blast-radius
description: "Use for \"what could this break\", \"blast radius of X\", or a diff you don't trust. Finds breakage past the diff and proves its one safety fact by running code."
disable-model-invocation: true
---

# Blast radius

Find what a change breaks somewhere else, before it ships. The `how` skill says what the code does, the `why` skill says why it is shaped that way, and this one says what it breaks elsewhere. Listing the callers is not the job. Grep does that in a second. The job is the breakage grep will not show you.

## Do not trust your own writeup

A blast-radius writeup that sounds right is worthless, because it reads as convincing whether or not it is true. Find the one or two facts the whole thing depends on and prove them by running code (`../bstack-mode/principles/prove-it-works.md`). For each such fact, get it as far down this ladder as is cheap, and say where it stopped.

1. You said so. Worthless on its own.
2. You pointed at the line. A real `file:line`, or the library's own source.
3. You showed the bad case cannot happen. You walked the failure step by step and it does not reach.
4. You ran it. A script or test that calls the real code and fails loud if you are wrong.
5. You reproduced it in the running app.

A fact you cannot get to step 4 is unproven. Say so. Step 4 is usually one small script that imports the library version the app ships and calls the exact function you are worried about.

## Steps

1. Read the change. The diff, the symbols it adds, changes, and deletes, and what it now does differently, including the part the diff does not spell out. Pull history with `git log -p` on the touched files and `gh pr view <number> --json body,comments,reviews` when there is a PR.
2. Find the one fact it is safe because of. Most risky-looking changes are safe because of a single fact, like "this call only drops already-dead cache entries and does nothing else". If it holds, most risky cases clear at once. Spend your time here, not on a list of maybes.
3. Look where grep stops. Read the library's source at its pinned version, with any local patch. Work out when things run: microtasks, unmount and teardown, one framework's reactivity versus another's. Follow what a symbol search misses: the JSON an API returns, a database column, a wire format, another language reading the same bytes, a feature flag, code three hops downstream.
4. Be honest about each risk. A real chance of happening and a real cost if it does. Keep the confirmed risks and list the cleared ones separately. Cite a real `file:line`. A search that finds nothing is still an answer. Never invent a caller or an API.
5. Prove the one fact. Write a script or test that runs the real code, run it, and paste what happened. If you cannot prove it cheaply, mark it unproven.
6. For a wide change, run a panel. Two or three `bstack-agent`s on different Claude models (`../bstack-mode/references/models.md`), same brief, answers merged. Same prompt on different models, not different vendors. A risk two models raise is signal. A risk one raises is a lead to check.

## What to hand back

- **What it does.** What changed, including the part that is not obvious.
- **The one fact it is safe because of.** State it, name the ladder step reached, show the proof. Unproven if you could not.
- **Risks.** Only the real ones. Each names how it breaks, the `file:line`, how likely and how bad, and how to check. Paste the proof for the ones that matter.
- **Cleared.** What you checked and why it is fine.
- **Before you merge.** The cheapest test or repro that catches the real bug, including the script you wrote.

**Reply:** the writeup above, private context stripped, with the one safety fact either proven or marked unproven.
