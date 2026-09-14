---
name: create-verification-skill
description: Generate a project-local verification skill (.claude/skills/verify-<app>) that launches the app, drives it like a user across CLI, daemon, service, or GUI surfaces, and captures proof of behavior.
disable-model-invocation: true
---

# Create a verification skill

Generate a skill that launches the real app, drives a feature the way a user would, and captures evidence, so behavior gets proven instead of asserted. It lives inside the target project at `.claude/skills/verify-<app>/`. That directory is project code, committed to the project's repo, never to bstack. Write it for the next agent, who reads it cold, mid-task, having never seen the app.

## 1. Interview the repo, not the user

Answer from the codebase. Ask with `AskUserQuestion` only what you cannot observe.

- **Surface.** What does a user touch? CLI, daemon, HTTP service, desktop GUI, web UI, library. Pick the primary one and note the rest. Confirm with the user when the repo has two plausible answers, such as a daemon that also ships a Qt settings window.
- **Host.** Where can the app run for verification? This machine, a compose container, a VM, a Linux box over ssh. A daemon that needs systemd, udev, or a system bus rarely runs on a laptop as-is. The generated skill names the host.
- **Run.** How does it start? Prefer the repo's documented command (meson target, package script, Makefile, compose service, README). The `run` skill finds it for most projects. Note ports, env vars, bus names, config paths, seed data, auth.
- **Drive.** How can an agent interact with it? Existing harnesses first: a CLI client, test clients, Playwright specs, expect scripts, a debug port, D-Bus introspection. Only then pick from the table.
- **Observe.** What evidence exists? Logs, exit codes, response bodies, bus signals, files written, rows, unit state, screenshots.
- **Isolate.** Can two instances run side by side (ports, state dirs, bus names, profiles)? If not, the generated skill says so. Refusing to double-drive a shared instance beats corrupting the user's session.

| Surface | Launch and drive | Evidence |
|---|---|---|
| Short-lived CLI | Build once. One fresh invocation per drive in its own scratch dir. A TUI gets a tmux or PTY session per drive. | stdout, stderr, exit code, files written |
| Daemon, no HTTP | Foreground, disposable state dir, private session bus (`dbus-run-session`) for a bus daemon. Drive its real interface: CLI client, `busctl`, socket, signal. | log lines, bus properties and signals, state files |
| HTTP or RPC service | Free port. `curl` or the repo's client. | status codes, bodies, logs, stored rows |
| Desktop GUI (Qt, Electron, native) | Drive a non-GUI seam the app already has (CLI, bus, IPC, debug port); the window is evidence. Electron takes CDP. With no seam, mark those features `manual`. | screenshots showing app identity, plus the seam's evidence |
| Web UI | Existing Playwright or Cypress, else a small Playwright script the skill ships. ARIA roles and names over coordinates. | ARIA snapshot, screenshot |
| Library | A scratch program calling the public API as a consumer would, built against the checkout. | program output, exit code |

If the checkout does not build or start as-is, fix that first or report it precisely. A skill written against a broken base teaches wrong steps. When an irrelevant missing asset blocks startup (a sample config), the generated skill may create it, marked as scaffolding, and remove it in cleanup.

## 2. Generate the skill

Write `.claude/skills/verify-<app>/SKILL.md`. Frontmatter: `name: verify-<app>` and a `description` naming the app, the surface, and when to reach for it. Without frontmatter the skill never registers. Then these sections, grounded in the interview, no placeholders:

- **Launch.** The exact start command on the named host, and how to tell it is ready (a log line, a port answering, a bus name owned, a prompt). Include teardown. The `run` skill defers to a project skill that covers launching, so this section stands on its own.
- **Doctor.** One read-only check that answers "is this instance worth driving?" Process up, right build, port or bus name owned by us, auth valid. Run it whenever anything looks off.
- **Drive.** The recipe with real commands, bus paths, endpoints, or selectors from this repo. Stable handles over coordinates.
- **Evidence.** What to capture and where. Exercise the real user path, not internal setters or test-only endpoints. Capture the action and the resulting state, not just the final screen. Verify side effects (files, rows, signals, messages) alongside what is visible. Mock only where a production boundary already isolates the external system. Treat a dry-run or test mode as a claim and observe what it actually skips (files, network, git refs).
- **Cleanup.** Kill what you started, by PID, unit, or container name, never by process name. Remove instances and scratch state, never the evidence. Proof artifacts survive teardown at a named location.
- **Helpers.** Every script the skill ships is executable and its invocation appears in the skill body.

## 3. Seed the feature map

Create `features/README.md` beside the SKILL.md, plus one file per user-facing feature (the top 3 to 5 to start, from commands, bus methods, routes, menus, or docs). Follow `references/feature-map-example/`, a README index and one file per feature with the H2s `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. Every entry names how to drive it and what observable end state proves it worked. The map is the project's maintained verification source. A proof that drives one convenient entry point is incomplete when the map lists others.

## 4. Prove it before handing it over

Run the generated skill end to end once (`../bstack-mode/principles/prove-it-works.md`): launch, doctor, drive one mapped feature, capture evidence, clean up. One feature is enough. After cleanup, confirm the evidence still exists at the named location. A cleanup that eats the proof fails this step. Fix what fails, and run the generated cleanup after every failed iteration so broken attempts do not strand processes, ports, or bus names. A skill that was never executed is a draft, not a deliverable.

## 5. Hand over

Commit the new directory on its own, in the project's repo. Point the user at the `maintain-verification-skill` skill for keeping the map honest as the app changes.

**Reply:** the path written, the surface and host chosen, the features mapped, and where the proof run's evidence lives. Paste the doctor output verbatim.
