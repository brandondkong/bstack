# lampd verification map

This directory is the maintained source for verifying the user-facing behavior of lampd, a device daemon with a D-Bus interface and a `lampctl` client. Read the index before driving the daemon, then use the matching feature file as the recipe.

This map is an illustration for a fictional daemon. Copy its shape, not its commands. A generated map names the real app's commands, paths, and handles.

## Baseline preconditions

- Launch lampd inside a private bus with the verification skill's Launch section: `dbus-run-session -- lampd --device sim --bus session --config "$LAMPD_STATE_DIR/lampd.toml" --log-file "$LAMPD_STATE_DIR/lampd.log"`.
- Set `LAMPD_STATE_DIR=/tmp/lampd-verify-$RUN_ID` so concurrent runs do not share state. Copy `contrib/lampd.example.toml` into it as `lampd.toml` before launch.
- Run every `lampctl` and `busctl` command with the run's own `DBUS_SESSION_BUS_ADDRESS`, so they reach this instance and not the user's.
- Run `./scripts/doctor.sh` and require the expected state directory, the expected build revision, and `org.example.Lamp1` owned by the PID this run started.
- Never drive an instance that was not started by this verification run.

## Driving conventions

- Start every recipe from the baseline state unless its preconditions say otherwise.
- Treat every command as literal. Keep quoted names, flags, and bus paths unchanged.
- Run terminal actions through `lampctl`. Run bus actions through `busctl --user`.
- Read state back through a user-visible path (`lampctl status --json`, `busctl --user get-property`) and through the side effect (the state file, the log line). Both.
- Wait for the observable, not a fixed sleep. Poll `lampctl status --json` or tail the log.
- Restore mutated state after a recipe. Do not remove proof artifacts during cleanup.

## Proof and skip reporting

- Capture the user action and the resulting state, not only the final readback.
- CLI proof includes the command, stdout, stderr, and exit code.
- Bus proof includes the `busctl` command and its output verbatim.
- Mutation proof includes a read-only second view of the stored value and the log line the daemon wrote.
- Record the feature ID and entry point used with every artifact, under `artifacts/<feature>/`.
- Report an unreachable path with the attempted command and the unmet precondition.
- Do not report a skipped entry point as verified through a different path.

## Feature entry contract

Each feature file starts with an H1 title and one paragraph describing the user-visible behavior. It then uses exactly four H2 sections in this order.

1. `Sub-features` lists short IDs with one line for each behavior.
2. `How to get to it (user POV)` lists every user entry point.
3. `Driving it with <harness>` starts with `Preconditions:` and uses labeled bullets that pair each user action with an exact command and an observable result.
4. `Gotchas` lists traps that can waste or invalidate a verification run.

Keep implementation details out of the map. Name only user paths, stable handles, required state, commands, and observable proof.

## Features

- [Set brightness](./set-brightness.md) covers CLI and bus entry, range rejection, the emitted signal, and persistence across restart.
- [Reload config](./reload-config.md) covers reload by CLI, bus, and SIGHUP, and rejection of an invalid config without losing the running one.
