# Set brightness

Set brightness lets a user change the lamp's brightness from the terminal or the bus, get an error for an out-of-range value, and find the value still applied after the daemon restarts.

## Sub-features

- `brightness-set` applies a value from 0 to 100 and reports it back.
- `brightness-reject` refuses a value above 100 and leaves the current value alone.
- `brightness-signal` emits `PropertiesChanged` for `Brightness` on every applied change.
- `brightness-persist` restores the last applied value after a restart.

## How to get to it (user POV)

- Run `lampctl set-brightness <0-100>` in a terminal.
- Call `SetBrightness` on `org.example.Lamp1` at `/org/example/Lamp` over the bus.

## Driving it with lampctl and busctl

Preconditions:

- `./scripts/doctor.sh` passes for this run's instance.
- `lampctl status --json` reports `"brightness": 100`, the simulator default.
- `artifacts/set-brightness/` exists and is empty.

- **Watch signals.** Start a monitor before changing anything. Run `busctl --user monitor org.example.Lamp1 > artifacts/set-brightness/signals.txt &` and record its PID for cleanup.
- **Set from CLI.** Run `lampctl set-brightness 40`. Exit code `0` and stdout `brightness: 40`.
- **Read back.** Run `lampctl status --json`. The output contains `"brightness": 40`.
- **Side effects.** Run `grep '^brightness' "$LAMPD_STATE_DIR/state.toml"` and `grep 'brightness 100 -> 40' "$LAMPD_STATE_DIR/lampd.log"`. Both print one matching line.
- **Set from bus.** Run `busctl --user call org.example.Lamp1 /org/example/Lamp org.example.Lamp1 SetBrightness u 55`. Exit code `0`. Then run `busctl --user get-property org.example.Lamp1 /org/example/Lamp org.example.Lamp1 Brightness`. Output is `u 55`.
- **Reject.** Run `lampctl set-brightness 101`. Exit code `2`, stderr contains `out of range`, and `lampctl status --json` still reports `55`.
- **Signal.** Stop the monitor by its PID. `artifacts/set-brightness/signals.txt` contains two `PropertiesChanged` messages naming `Brightness`, none for the rejected call.
- **Persist.** Tear down and relaunch with the skill's Launch section, keeping `LAMPD_STATE_DIR`. Run `./scripts/doctor.sh`, then `lampctl status --json`. The output reports `55`.
- **Proof.** Copy `"$LAMPD_STATE_DIR/lampd.log"` and `"$LAMPD_STATE_DIR/state.toml"` into `artifacts/set-brightness/`, and save each command's stdout, stderr, and exit code beside them.

## Gotchas

- `set-brightness 0` is valid and is not the same as `Powered=false`. Do not read a zero as an error.
- `busctl` without `--user` talks to the system bus and reports no such name. That is a wrong-bus error, not a daemon failure.
- The simulator applies changes instantly. Real hardware fades over about a second, so poll `lampctl status --json` instead of sleeping.
- A relaunch kills the signal monitor with the bus. Start a new monitor after any restart.
- Restore brightness to `100` after the recipe. Keep the artifacts.
