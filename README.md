# Bakery

A small Bash wrapper for naming, tracking, and resuming [Pi](https://github.com/badlogic/pi-mono) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code) sessions.

## Requirements

- Bash
- Python 3
- `pi` and/or `claude` available on `PATH`

## Install

```bash
chmod +x bakery
ln -s "$(pwd)/bakery" ~/.local/bin/bakery
```

Ensure `~/.local/bin` is on your `PATH`, or run `./bakery` directly.

## Usage

Start and register a new session (Pi is the default harness):

```bash
bakery new --name "Some task" --dir /path/to/project --custom-id abc
bakery new --name "Claude task" --dir /path/to/project --harness claude
```

`--custom-id` is optional. `--harness` accepts `pi` or `claude`.

Bakery starts the selected harness in the specified directory and stores its registry in `~/.bakery/state.json`:

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

Add an existing Pi or Claude Code session to Bakery's registry:

```bash
bakery onboard --name "Existing Pi task" --id 019f90b0-7871-7827-a180-8c02fe990cac
bakery onboard --name "Existing Claude task" --id 550e8400-e29b-41d4-a716-446655440000 --harness claude
```

Bakery finds the session and reads its project directory from the transcript. Pi lookup honors `PI_CODING_AGENT_SESSION_DIR` and `PI_CODING_AGENT_DIR`; Claude Code lookup honors `CLAUDE_CONFIG_DIR`.

List registered sessions:

```bash
bakery ls
```

```text
TASK                   PROJECT                         HARNESS  ID
Fix bug                /path/to/project                pi       abc
Add mTLS to feature X  /path/to/another-project        claude   019f90b0-7871-7827-a180-8c02fe990dad
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
