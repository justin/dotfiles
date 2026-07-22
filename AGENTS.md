# LLM Context Guide for Justin Williams' Dotfiles

Use this file as the repository-specific source of truth. Verify details against
the repository when they may have changed or when the requested work exposes a
conflict. Do not let these instructions override direct user instructions or
higher-priority safety requirements.

## Repository Model

- This is Justin's cross-platform dotfiles repository, managed by
  [chezmoi](https://www.chezmoi.io/).
- `.chezmoiroot` contains `files`, so `files/` is the chezmoi source-state root.
  Edit source-state files under `files/`, not their rendered copies in the home
  directory.
- The primary platform is Apple silicon macOS. Debian and Ubuntu are also
  supported, including ephemeral environments such as Codespaces and
  containers.
- Z shell (`zsh`) is the primary shell on every supported platform.
- Follow the XDG Base Directory Specification where applicable.
- Use `.yml`, never `.yaml`, for new YAML files.
- Preserve unrelated working-tree changes. Do not run a non-dry-run
  `chezmoi apply`, package upgrades, installation scripts, or other
  state-changing commands unless the task requires them and the user has
  authorized their effects.

## Decision Rules

1. Make the smallest change that satisfies the request.
2. Inspect the relevant source-state file and nearby examples before editing.
3. Keep platform-specific behavior isolated with chezmoi templates, directory
   layout, or Just attributes.
4. Validate proportionally to the change, starting with read-only checks.
5. Report checks that were not run and why.

When a chezmoi command, attribute, template function, or filename convention is
uncertain, consult the official
[user guide](https://www.chezmoi.io/user-guide/) and
[reference](https://www.chezmoi.io/reference/). Do not invent unsupported
chezmoi behavior.

## Important Paths

```text
repo-root/
├── .codex/environments/environment.toml # Codex workspace setup and actions
├── .chezmoiroot                         # Points chezmoi at files/
├── .github/workflows/                   # CI workflows
├── AGENTS.md                            # Repository instructions for LLMs
├── files/                               # Chezmoi source-state root
│   ├── .chezmoi.toml.tmpl               # Chezmoi configuration template
│   ├── .chezmoidata/                    # Template data
│   │   ├── macos.yml
│   │   ├── shared.yml
│   │   └── ubuntu.yml
│   ├── .chezmoiexternals/               # External source definitions
│   ├── .chezmoiscripts/                 # Scripts run by chezmoi apply
│   │   ├── darwin/
│   │   └── ubuntu/
│   ├── dot_local/bin/                   # Maps to ~/.local/bin/
│   ├── functions/                       # Shared zsh functions
│   └── private_dot_config/              # Maps to ~/.config/
│       └── just/justfile
└── install.sh                           # Fresh-machine bootstrap script
```

Chezmoi filename attributes encode target behavior. For example,
`private_dot_config` maps to `.config`, `executable_` sets the executable bit,
and `.tmpl` marks a template. Consult the
[source-state attributes reference](https://www.chezmoi.io/reference/source-state-attributes/)
before introducing an unfamiliar attribute.

## Platform and Architecture

- On macOS, assume Apple silicon (`arm64`). Do not add Intel macOS branches
  unless the task explicitly requires backward compatibility.
- On Linux, detect architecture rather than assuming it. Common values include
  `amd64` or `x86_64` for Intel/AMD 64-bit systems and `arm64` or `aarch64` for
  ARM 64-bit systems. Use `.chezmoi.arch` when the logic belongs in a chezmoi
  template.
- In Just recipes, use `[macos]` and `[linux]` as demonstrated in
  `files/private_dot_config/just/justfile`.
- In templates, prefer `.chezmoi.os` for operating-system checks and existing
  repository data such as `.osid` when a distribution-specific check is
  required.

```gotemplate
{{- if eq .chezmoi.os "darwin" -}}
  ...
{{- else if eq .chezmoi.os "linux" -}}
  ...
{{- end -}}
```

## Shell Conventions

- Use `#!/usr/bin/env zsh` for zsh scripts and `set -euo pipefail` unless the
  surrounding scripts intentionally use different error handling.
- Use `#!/usr/bin/env sh` only for genuinely portable POSIX shell scripts; do
  not use zsh syntax in them.
- In zsh, `path` is a special array tied to `PATH`. Do not use `path` as a local
  or loop variable name.
- General-purpose executables installed into `~/.local/bin` belong under
  `files/dot_local/bin/` and use the `executable_` chezmoi attribute. They may
  intentionally have no filename extension so the installed command has a
  clean name.
- Chezmoi scripts belong under `files/.chezmoiscripts/`, must use a valid
  `run_`, `run_once_`, or `run_onchange_` attribute, and should follow the
  repository's existing `.sh.tmpl` naming convention. They do not need their
  executable bit set; chezmoi renders and executes them.
- Make scripts idempotent wherever practical, including `run_once_` and
  `run_onchange_` scripts.
- Source shared helpers in chezmoi templates using `.chezmoi.sourceDir`, as the
  existing scripts do:

```zsh
#!/usr/bin/env zsh

set -euo pipefail

source {{ joinPath .chezmoi.sourceDir "functions/_logging" }}
source {{ joinPath .chezmoi.sourceDir "functions/_utilities" }}
```

- Use the logging helpers in `files/functions/_logging` instead of defining a
  second logging abstraction. Ask before adding a new logging helper.
- Match nearby script headers and comments. Comments and documentation must be
  in English and should explain intent or non-obvious constraints.

## Package and Tool Conventions

- Homebrew manages macOS command-line tools and applications. Package data
  lives in `files/.chezmoidata/macos.yml` and is consumed by the Homebrew
  script under `files/.chezmoiscripts/darwin/`.
- APT manages Debian and Ubuntu packages. Package data lives in
  `files/.chezmoidata/ubuntu.yml`; prefer `apt` over `apt-get` in user-facing
  commands.
- `uv` manages Python versions, environments, dependencies, and tools.
- 1Password and its `op` CLI provide secrets on non-ephemeral machines. Never
  commit credentials; use chezmoi templates that reference 1Password or
  environment data.
- `git` is the version-control tool. `gh` is used for GitHub operations.
- Core tools used by this repository include `zsh`, `chezmoi`, `just`, and
  `gh`. Check for a tool before relying on it; do not install a missing tool
  unless the task authorizes installation.

## Validation

Run checks that exercise the changed area without unexpectedly changing the
machine. For documentation-only changes, inspect the diff and run an available
Markdown checker; the full chezmoi suite is not required.

In the Codex app, the project environment provides **Validate** and **Dry Run**
actions for the common read-only checks. Its setup hook verifies prerequisites
but intentionally does not install packages or apply the dotfiles.

For source-state or template changes, use the applicable read-only checks:

```bash
# Repository and environment health; network warnings may be non-fatal.
chezmoi doctor

# Confirm that chezmoi data is valid JSON.
chezmoi data | jq .

# Show content differences between the target and destination states.
chezmoi diff

# Exercise the apply plan without modifying the destination or running scripts.
chezmoi apply --dry-run --verbose

# Validate the initial configuration template with a test email.
chezmoi execute-template --init --promptString email=test@example.com \
  < files/.chezmoi.toml.tmpl

# Confirm that Just can parse the repository justfile.
just --justfile files/private_dot_config/just/justfile --list
```

`chezmoi diff` and `chezmoi apply --dry-run` can include unrelated local
target-state differences. Review and report them; do not overwrite or "fix"
them as part of an unrelated task. Dry-run mode renders scripts but does not
execute them, so it does not replace syntax checks or focused script tests.

The following are integration or maintenance operations, not routine
validation. Run them only when the task calls for their side effects:

```bash
chezmoi apply       # Modifies the destination state and may run scripts.
just update-all     # Upgrades installed packages.
just up             # Alias for update-all.
```

A fresh installation downloads software and changes the machine. Test it only
in an explicitly disposable environment or when the user specifically requests
an installation test:

```bash
sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/justin/dotfiles/main/install.sh')"
```

## Common Changes

### Add or Modify a Managed File

1. Find the target's source-state path under `files/`.
2. Follow existing chezmoi attributes and nearby platform conventions.
3. Edit the source-state file, not the rendered file in the home directory.
4. Run the relevant read-only validation from the previous section.
5. Apply the change only when applying it is part of the requested task.

### Add a Chezmoi Script

1. Put it in `files/.chezmoiscripts/` or the appropriate platform subdirectory.
2. Choose `run_`, `run_once_`, or `run_onchange_` based on the required
   lifecycle; add `before_` or `after_` only when ordering matters.
3. Use a zsh shebang, strict mode where compatible, and the shared helpers.
4. Make the operation idempotent and guard platform-specific commands.
5. Validate template rendering and inspect `chezmoi apply --dry-run --verbose`.
   Because dry-run mode does not execute scripts, run an appropriate syntax
   check separately. Do not run a real `chezmoi apply` merely to test a script.

### Update Packages

Use the existing platform-aware Just recipes when package maintenance is the
requested task:

```bash
just update-all
just update-apt      # Linux only
just update-snap     # Linux only
just npm-upgrade
just py-upgrade
```

These commands can use the network, elevate privileges, and alter installed
software. Do not treat them as validation commands.

## Security and Reliability

- Never hardcode passwords, API keys, tokens, or other secrets.
- Validate external input and quote shell expansions.
- Prefer secure temporary directories with cleanup traps.
- Use chezmoi attributes for target permissions: `private_` for restricted
  files and `executable_` for executable files.
- Treat `chezmoi apply`, bootstrap scripts, package recipes, `sudo`, and network
  downloads as state-changing operations. Inspect their scope before running
  them.
