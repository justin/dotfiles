# LLM Context Guide for Justin Williams' Dotfiles

This file is the repository-wide source of truth for all LLM tools. Verify facts
against the repository when they may have changed. Tool-specific files may add
behavior unique to that tool, but must not duplicate, replace, or weaken these
rules. Direct user instructions and higher-priority safety requirements win.

## Critical Constraints

- Edit chezmoi source state under `files/`, not rendered files in the home
  directory. `.chezmoiroot` maps the source root to `files`.
- Preserve unrelated working-tree changes.
- Do not run `chezmoi apply`, bootstrap/install scripts, package upgrades, or
  other state-changing commands unless the task requires them and the user has
  authorized their effects.
- Never hardcode or commit passwords, API keys, tokens, or other secrets.
- Assume Apple silicon (`arm64`) on macOS. Keep Linux behavior explicit and
  detect its architecture.
- Use `.yml`, never `.yaml`, for new YAML files.

## Repository Model

- This is Justin's cross-platform dotfiles repository, managed by
  [chezmoi](https://www.chezmoi.io/).
- The primary platform is macOS. Debian and Ubuntu are also supported,
  including Codespaces and containers.
- Z shell (`zsh`) is the primary shell on every supported platform.
- Follow the XDG Base Directory Specification where applicable.

## Decision Rules

1. Make the smallest change that satisfies the request.
2. Inspect the relevant source-state file and nearby examples before editing.
3. Keep platform-specific behavior isolated with chezmoi templates, directory
   layout, or Just attributes.
4. Validate proportionally to the change, starting with read-only checks.
5. Report checks that were not run and why.

## Task Routing

| Task | Start here |
| --- | --- |
| Managed file | Matching target path under `files/` |
| Package change | `files/.chezmoidata/<platform>.yml` |
| Apply-time behavior | `files/.chezmoiscripts/<platform>/` |
| Shared shell behavior | `files/functions/` |
| General executable | `files/dot_local/bin/` |
| Automation command | `files/private_dot_config/just/justfile` |
| GitHub Actions | `.github/workflows/AGENTS.md` |

Chezmoi filename attributes encode target behavior: `private_` restricts
permissions, `dot_` maps to a leading dot, `executable_` sets the executable
bit, and `.tmpl` enables templating. When a command, attribute, template
function, or filename convention is uncertain, consult the official
[user guide](https://www.chezmoi.io/user-guide/) and
[reference](https://www.chezmoi.io/reference/) rather than inventing behavior.

## Platform and Architecture

- Do not add Intel macOS branches unless the task explicitly requires backward
  compatibility.
- On Linux, detect architecture. Use `.chezmoi.arch` in chezmoi templates.
- In Just recipes, use `[macos]` and `[linux]` as demonstrated in
  `files/private_dot_config/just/justfile`.
- In templates, use `.chezmoi.os` for operating-system checks and existing data
  such as `.osid` for distribution-specific checks.

## Shell Conventions

- Use `#!/usr/bin/env zsh` for zsh scripts and `set -euo pipefail` unless the
  surrounding scripts intentionally use different error handling.
- Use `#!/usr/bin/env sh` only for genuinely portable POSIX shell scripts; do
  not use zsh syntax in them.
- In zsh, `path` is a special array tied to `PATH`. Do not use `path` as a local
  or loop variable name.
- General-purpose executables under `files/dot_local/bin/` must use the
  `executable_` attribute. They may omit a filename extension.
- Chezmoi scripts belong under `files/.chezmoiscripts/`, must use a valid
  `run_`, `run_once_`, or `run_onchange_` attribute, and should match the
  existing `.sh.tmpl` naming convention. They do not need an executable bit.
- Scripts should be idempotent, including `run_once_` and `run_onchange_`
  scripts. Use `before_` or `after_` only when ordering matters.
- Source `_logging` and `_utilities` with `joinPath .chezmoi.sourceDir`.
- Use `files/functions/_logging`; ask before adding another logging abstraction.
- Comments and documentation must be in English and explain intent or
  non-obvious constraints.

## Package and Tool Conventions

- Homebrew manages macOS packages from `files/.chezmoidata/macos.yml`.
- APT manages Debian and Ubuntu packages from
  `files/.chezmoidata/ubuntu.yml`. Prefer `apt` over `apt-get` in user-facing
  commands.
- `uv` manages Python versions, environments, dependencies, and tools.
- 1Password and `op` provide secrets on non-ephemeral machines. Reference
  1Password or environment data from templates; never commit credentials.
- Core tools are `zsh`, `chezmoi`, `just`, `git`, and `gh`. Check availability
  before use and do not install missing tools unless authorized.

## Validation

Use the narrowest read-only check that exercises the change.

| Change | Required validation |
| --- | --- |
| Documentation | Diff/readability check; Markdown checker when available |
| Chezmoi data | `chezmoi data \| jq .` |
| Managed file or template | `chezmoi diff` and relevant template rendering |
| Apply-time script | Shell syntax check plus `chezmoi apply --dry-run --verbose` |
| `.chezmoi.toml.tmpl` | `chezmoi execute-template --init --promptString email=test@example.com < files/.chezmoi.toml.tmpl` |
| Justfile | `just --justfile files/private_dot_config/just/justfile --list` |

Use `chezmoi doctor` for repository or environment health. Network warnings may
be non-fatal.

`chezmoi diff` and `chezmoi apply --dry-run` can include unrelated local
target-state differences. Review and report them; do not overwrite or "fix"
them as part of an unrelated task. Dry-run mode renders scripts but does not
execute them, so it does not replace syntax checks or focused script tests.

## Security and Reliability

- Validate external input and quote shell expansions.
- Prefer secure temporary directories with cleanup traps.
- Treat `chezmoi apply`, bootstrap scripts, package recipes, `sudo`, and network
  downloads as state-changing operations, not validation commands.
- Test fresh installation only in an explicitly disposable environment or when
  the user specifically requests it.
