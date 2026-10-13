# Donjon

A small Bash wrapper for naming, tracking, and attaching to [Pi](https://github.com/badlogic/pi-mono) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code) sessions.

## Requirements

- Bash
- Python 3
- `pi` and/or `claude` available on `PATH`
- [`fzf`](https://github.com/junegunn/fzf) for the interactive session picker

## Install

```bash
chmod +x donjon
ln -s "$(pwd)/donjon" ~/.local/bin/donjon
```

Ensure `~/.local/bin` is on your `PATH`, or run `./donjon` directly.

## Usage

Start and register a new session (Pi is the default harness):

```bash
donjon new --name "Some task" --dir /path/to/project --custom-id abc
donjon new --name "Claude task" --dir /path/to/project --harness claude
```

`--custom-id` is optional. `--harness` accepts `pi` or `claude`.

Donjon starts the selected harness in the specified directory and stores its registry in `~/.donjon/state.json`:

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

Add an existing Pi or Claude Code session to Donjon's registry:

```bash
donjon onboard --name "Existing Pi task" --id 019f90b0-7871-7827-a180-8c02fe990cac
donjon onboard --name "Existing Claude task" --id 550e8400-e29b-41d4-a716-446655440000 --harness claude
```

Donjon finds the session and reads its project directory from the transcript. Pi lookup honors `PI_CODING_AGENT_SESSION_DIR` and `PI_CODING_AGENT_DIR`; Claude Code lookup honors `CLAUDE_CONFIG_DIR`.

List registered sessions:

```bash
donjon ls
```

```text
TASK                   PROJECT                         HARNESS  ID
Fix bug                /path/to/project                pi       abc
Add mTLS to feature X  /path/to/another-project        claude   019f90b0-7871-7827-a180-8c02fe990dad
```

Interactively choose and attach to a session with fuzzy search. Press Enter or click a row:

```bash
donjon sessions
```

Attach directly by custom ID or a unique session-ID prefix:

```bash
donjon attach --id abc
donjon attach --id 019f90b0
```

Remove a session from Donjon's registry:

```bash
donjon rm abc
```

This only removes the registry entry; it does not delete Pi or Claude Code session data.

Set `DONJON_STATE` to use a different registry file.

Run `donjon --help` for a command summary.
