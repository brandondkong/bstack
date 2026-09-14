# Reload config

Reload config lets a user apply an edited config file to the running daemon without restarting it, and keeps the running config when the new file is invalid.

## Sub-features

- `reload-apply` re-reads the config file and applies new limits.
- `reload-invalid` rejects a broken file, names the problem, and keeps the running config.
- `reload-sighup` performs the same reload when the daemon receives `SIGHUP`.

## How to get to it (user POV)

- Run `lampctl reload` in a terminal.
- Call `Reload` on `org.example.Lamp1` at `/org/example/Lamp` over the bus.
- Send `SIGHUP` to the daemon process.

## Driving it with lampctl and busctl

Preconditions:

- `./scripts/doctor.sh` passes for this run's instance.
- `"$LAMPD_STATE_DIR/lampd.toml"` contains `max_brightness = 100`.
- `lampctl status --json` reports `"max_brightness": 100`.
- `artifacts/reload-config/` exists and is empty.

- **Edit config.** Run `sed -i 's/^max_brightness = 100/max_brightness = 60/' "$LAMPD_STATE_DIR/lampd.toml"`. Nothing changes yet. `lampctl status --json` still reports `100`.
- **Reload from CLI.** Run `lampctl reload`. Exit code `0` and stdout `config reloaded`.
- **Read back.** Run `lampctl status --json`. The output contains `"max_brightness": 60`.
- **New limit holds.** Run `lampctl set-brightness 80`. Exit code `2` and stderr contains `above max_brightness 60`.
- **Side effect.** Run `grep 'config reloaded from' "$LAMPD_STATE_DIR/lampd.log"`. One line names the config path.
- **Invalid config.** Run `sed -i 's/^max_brightness = 60/max_brightness = "lots"/' "$LAMPD_STATE_DIR/lampd.toml"`, then `lampctl reload`. Exit code `1`, stderr names `max_brightness` and a line number, and `lampctl status --json` still reports `60`.
- **Rejection logged.** Run `grep 'config rejected' "$LAMPD_STATE_DIR/lampd.log"`. One matching line.
- **Reload by signal.** Restore the file with `sed -i 's/^max_brightness = "lots"/max_brightness = 100/' "$LAMPD_STATE_DIR/lampd.toml"`, then run `kill -HUP "$(cat "$LAMPD_STATE_DIR/lampd.pid")"`. Within two seconds `lampctl status --json` reports `100` and the log gains a second `config reloaded from` line.
- **Reload from bus.** Run `busctl --user call org.example.Lamp1 /org/example/Lamp org.example.Lamp1 Reload`. Exit code `0` and a third `config reloaded from` line appears.
- **Proof.** Copy `"$LAMPD_STATE_DIR/lampd.log"` and the final `lampd.toml` into `artifacts/reload-config/`, and save each command's stdout, stderr, and exit code beside them.

## Gotchas

- The daemon re-reads the path given at launch, not a file in the current directory. Edit `"$LAMPD_STATE_DIR/lampd.toml"`, nothing else.
- `lampd.pid` is written after the bus name is acquired. If it is missing, doctor has not passed yet.
- Never `pkill -HUP lampd`. The user may be running their own instance. Signal the PID from this run's pid file only.
- A reload does not change the current brightness, only the limit. Test the limit with a new `set-brightness`, not by reading brightness.
- Restore `max_brightness = 100` and reload once more after the recipe. Keep the artifacts.
