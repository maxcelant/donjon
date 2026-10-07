# Bakery

A small Bash wrapper for naming, tracking, and resuming [Pi](https://github.com/badlogic/pi-mono) sessions.

## Requirements

- Bash
- Python 3
- `pi` available on `PATH`

## Install

```bash
chmod +x bakery
ln -s "$(pwd)/bakery" ~/.local/bin/bakery
```

Ensure `~/.local/bin` is on your `PATH`, or run `./bakery` directly.

## Usage

Start and register a new Pi session:

```bash
bakery new --name "Some task" --dir /path/to/project --custom-id abc
```

`--custom-id` is optional. `--harness pi` is accepted for compatibility; Pi is currently the only supported harness.

Bakery starts Pi in the specified directory and stores its registry in `~/.bakery/state.json`:

```json
[
  {
    "name": "Some task",
    "dir": "/path/to/project",
    "harness": "pi",
    "id": "019f90b0-7871-7827-a180-8c02fe990cac",
    "customId": "abc"
  }
]
```

Add an existing Pi session to Bakery's registry:

```bash
bakery onboard --name "Existing task" --id 019f90b0-7871-7827-a180-8c02fe990cac
```

Bakery finds the session in Pi's session directory and reads its project directory from the session file. It honors `PI_CODING_AGENT_SESSION_DIR` and `PI_CODING_AGENT_DIR`.

List registered sessions:

```bash
bakery ls
```

```text
TASK                   PROJECT                         ID
Fix bug                /path/to/project                abc
Add mTLS to feature X  /path/to/another-project        019f90b0-7871-7827-a180-8c02fe990dad
```

Resume by custom ID or a unique session-ID prefix:

```bash
bakery resume --id abc
bakery resume --id 019f90b0
```

Remove a session from Bakery's registry:

```bash
bakery rm abc
```

This only removes the registry entry; it does not delete Pi's session data.

Run `bakery --help` for a command summary.
