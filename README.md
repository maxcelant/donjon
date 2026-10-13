# Donjon

A small CLI for naming, tracking, and attaching to [Pi](https://github.com/badlogic/pi-mono), [Claude Code](https://docs.anthropic.com/en/docs/claude-code), and [Codex](https://github.com/openai/codex) sessions.

## Requirements

- Python 3
- `pi`, `claude`, and/or `codex` available on `PATH`
- [`fzf`](https://github.com/junegunn/fzf) for the interactive session picker

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/maxcelant/donjon/main/install.sh | sh
```

This installs `donjon` in `~/.local/bin` and creates `~/.donjon/config.yaml`. Ensure `~/.local/bin` is on your `PATH`.

To install elsewhere, set `DONJON_INSTALL_DIR`. Set `DONJON_VERSION` to install a tag or branch.

## Configuration

Edit `~/.donjon/config.yaml` to configure executable and data paths:

```yaml
defaultHarness: "pi"

pi:
  path: ""
  sessionDir: ""

claude:
  path: ""
  sessionDir: ""

codex:
  path: ""
  sessionDir: ""

tools:
  fzf:
    path: ""
```

Set `defaultHarness` to `pi`, `claude`, or `codex`. Leave path values empty to use their defaults. Command paths default to names available on `PATH`; session directories default to `~/.pi/agent/sessions`, `~/.claude/projects`, and `~/.codex/sessions`. Donjon creates this file on first run if the installer has not already created it.

Environment variables override configuration. Existing variables `DONJON_STATE`, `PI_CODING_AGENT_SESSION_DIR`, `PI_CODING_AGENT_DIR`, `CLAUDE_CONFIG_DIR`, and `CODEX_HOME` remain supported. `DONJON_DEFAULT_HARNESS`, `DONJON_PI_PATH`, `DONJON_CLAUDE_PATH`, `DONJON_CODEX_PATH`, and `DONJON_FZF_PATH` provide direct overrides. Set `DONJON_CONFIG` to use another config file.

## Usage

Start and register a new session (Pi is the default harness):

```bash
donjon new --name "Some task" --dir /path/to/project --custom-id abc
donjon new --name "Claude task" --dir /path/to/project --harness claude
donjon new --name "Codex task" --dir /path/to/project --harness codex
```

`--custom-id` is optional. `--harness` accepts `pi`, `claude`, or `codex` and defaults to `defaultHarness` from the config.

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
donjon onboard --name "Existing Codex task" --id 019c33da-d5bf-7073-9f86-abe7f9a4f1c1 --harness codex
```

Donjon finds the session and reads its project directory from the transcript. Pi lookup honors `PI_CODING_AGENT_SESSION_DIR` and `PI_CODING_AGENT_DIR`; Claude Code lookup honors `CLAUDE_CONFIG_DIR`; Codex lookup honors `CODEX_HOME`.

List registered sessions:

```bash
donjon ls
```

```text
ID        TASK                   PROJECT                         HARNESS
abc       Fix bug                /path/to/project                pi
019f90b0  Add mTLS to feature X  /path/to/another-project        claude
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
