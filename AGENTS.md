# LLM Context Guide for Justin Williams' dotfiles

**CRITICAL**: Always reference these instructions first and fallback to search or shell commands only when you encounter unexpected information that does not match the info here.

## General Instructions

- This repository contains my dotfiles for various command line tools. The repository is managed by [chezmoi](https://www.chezmoi.io).
- These dotfiles are primarily used on macOS hosts, but are also intended to work on Debian/Ubuntu hosts.
- These dotfiles can also work on ephemeral machines such as those used in GitHub Codespaces, Docker, or other cloud-based development environments.
- These dotfiles primarly support Z shell (`zsh`) configuration on all platforms.
- When creating YAML files, **always** use the file extension `.yml` (_never_ `.yaml`).
- The user guide for chezmoi is located at [https://www.chezmoi.io/user-guide/](https://www.chezmoi.io/user-guide/).
- The chezmoi reference documentation is located at [https://www.chezmoi.io/reference/](https://www.chezmoi.io/reference/).
- When working with chezmoi, the user guide and reference documentation should be consulted to understand the available commands, templates, and configuration options. If it is not listed in the user guide or reference documentation, it is not a valid command, template, or configuration option.

## Working Effectively

### Bootstrap, Build, and Test the Repository

**IMPORTANT**: All the following commands work and have been validated. Follow them exactly.

#### Fresh Installation (New Machine)
```bash
# Install everything from scratch. NEVER CANCEL.
sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/justin/dotfiles/main/install.sh')"
```
- This installs Homebrew (on macOS), chezmoi, and applies all dotfiles
- On Linux: installs chezmoi to `~/.local/bin/chezmoi`
- On macOS: installs via Homebrew to `/opt/homebrew/bin/chezmoi`

#### Working with Existing Installation
```bash
# Check system health
chezmoi doctor

# See what would change. NEVER CANCEL.
chezmoi diff

# Apply changes. NEVER CANCEL.
chezmoi apply

# Validate the installation worked
chezmoi data
```

#### Platform-Specific Setup Commands
```bash
# Update all packages. NEVER CANCEL.
just update-all

# macOS: Ensure Homebrew is loaded
eval "$(/opt/homebrew/bin/brew shellenv)"

# Linux (Ubuntu/Debian): Individual updates
just update-apt
just update-snap
```

### Key Automation Commands (Just)

The repository uses [Just](https://github.com/casey/just) for task automation. All commands are platform-aware.

```bash
# List all available commands
just --justfile files/private_dot_config/just/justfile --list

# Common commands (all measured and validated):
just update-all     # Update everything
just up             # Alias for update-all
just py-upgrade     # Update Python tools
just npm-upgrade    # Update global npm packages
```

## Validation

**ALWAYS** run validation steps after making any changes to ensure the system still works correctly.

### Required Validation Steps
1. **System Health Check**:
   ```bash
   chezmoi doctor
   ```
   Should show mostly "ok" results. Network-related failures are acceptable in restricted environments.

2. **Configuration Validation**:
   ```bash
   chezmoi data | jq .
   ```
   Should output valid JSON with system configuration data.

3. **Dry Run Changes**:
   ```bash
   chezmoi diff --dry-run
   ```
   Shows what would change without applying. NEVER CANCEL.

4. **Template Validation**:
   ```bash
   chezmoi execute-template --init --promptString email=test@example.com < files/.chezmoi.toml.tmpl
   ```
   Validates that templates can be rendered without errors.

### Manual Testing Scenarios

**ALWAYS** test these scenarios after making changes:

1. **Fresh Installation Simulation**:
   ```bash
   # In a clean environment, validate that this completes successfully:
   sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/justin/dotfiles/main/install.sh')"
   ```
   Should complete without errors.

2. **Configuration Update Workflow**:
   ```bash
   chezmoi diff     # See changes
   chezmoi apply    # Apply changes
   chezmoi data     # Verify configuration
   ```

3. **Just Command Validation**:
   ```bash
   just --justfile files/private_dot_config/just/justfile --list
   ```
   Should show available commands without errors.

## Machine Architecture Instructions

- All my macOS machines are now Apple silicon (also known as _darwin-arm64_ or _macos-arm64_). This repository should assume Apple silicon architecture on macOS.
- On Debian/Ubuntu machines, we cannot assume an architecture. Debian/Ubuntu machines will either be ARM architecture (_amd64_) or Intel architecture (*x86_64*). Where machine architecture may be a factor, there should be a chezmoi test to determine the machine architecture.

## Shell Instructions

- When creating files meant to be executed, read, or sourced by `zsh`, use the `.zsh` filename extension.
- When creating general purpose shell scripts, prefer basic Bourne shell (also known as `sh`) without a filename extension. Make the script executable (for example: `chmod 755 example-script-name`) by starting its name with 'executable_' as per the chezmoi guidelines. Use the file header `#!/usr/bin/env sh` to ensure finding the correct `sh` executable.
- For scripts that are under .chezmoiscripts directory, use `#!/usr/bin/env zsh` as the file header and the `.zsh` filename extension. Any scripts in it are executed as normal scripts without creating a corresponding directory in the target state. The `run_` attribute is still required. For more information, see the [chezmoi documentation on scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/).

## File Structure Context

**Key directories and their purposes:**

```
repo-root/                           # Repository root (managed by chezmoi)
├── files/                           # chezmoi-managed dotfiles (becomes ~/.config/, ~/.local/, etc.)
│   ├── private_dot_config/          # Maps to ~/.config/
│   │   ├── just/                    # Task automation commands
│   │   │   └── justfile             # Justfile for tasks
│   │   └── homebrew/                # Homebrew package lists
│   │       └── Brewfile             # Brewfile for macOS packages
│   ├── dot_local/                   # Maps to ~/.local/
│   │   └── bin/                     # Executables
│   ├── .chezmoiscripts/             # Scripts that run during chezmoi apply
│   ├── .chezmoidata/                # Data files used by templates
│   │   ├── ubuntu.yml              # Linux-specific settings and package definitions
│   │   └── macos.yml               # macOS-specific settings
│   ├── functions/                   # Shared shell functions used by scripts
│   └── .chezmoi.toml.tmpl           # chezmoi configuration template
├── .github/                         # GitHub-related files
│   └── workflows/                   # CI/CD workflows
│       ├── ci.yml                  # CI/CD pipeline that tests installation
│       └── copilot-setup-steps.yml  # GitHub Copilot environment setup instructions
└── install.sh                       # Main installation script
```

Everything is built to conform to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

## Tool Instructions

### Core Dependencies
**ALWAYS** ensure these are installed before working with the repository:
- `zsh` - Required for all scripts and functions
- `chezmoi` - The dotfiles manager. The minimum required version is set in `.chezmoiroot`
- `just` - Task runner for automation
- `gh` - Version control

### Package Managers and Tools
- [`1Password`](https://1password.com) is used to store secrets that should not be stored in version control. The [`op`](https://developer.1password.com/docs/cli/) should be installed on each machine that is not ephemeral. chezmoi has built-in support for retrieving secrets from 1Password.
- `apt` is preferred to `apt-get` when installing software on Debian/Ubuntu hosts. Packages to be installed on Debian/Ubuntu hosts are listed in `files/.chezmoidata/ubuntu.yaml`.
- [Homebrew](https://brew.sh) is use for installing command line tools and graphical user interface applications (using the `--cask` option) on macOS. Package lists are in `files/private_dot_config/homebrew/Brewfile`.
- [`uv`](https://docs.astral.sh/uv/) is used for Python version management, Python virtual environment management, and Python dependency management.

### Troubleshooting Common Issues

1. **Network connectivity issues**:
   - External downloads (GitHub, Homebrew, etc.) may fail in restricted environments
   - Use `chezmoi diff --dry-run` to test without network operations

## Coding Standards

### Shell Scripts (Mandatory)

**Always use this exact template for new scripts:**

```zsh
#!/usr/bin/env zsh
## @file script.name
## Brief description of script functionality
##
## Usage:
##     @script.name [OPTIONS] [ARGUMENTS...]
##

set -euo pipefail

source "$XDG_DATA_HOME/chezmoi/files/functions/_logging"
source "$XDG_DATA_HOME/chezmoi/files/functions/_utilities"
```

### Formatting

Please use the editorconfig file `.editorconfig` in the root of this repository to ensure consistent formatting across all files. This file is used by many code editors and IDEs to apply consistent formatting rules.

### Variable Naming

```zsh
# Local variables and functions
config_file="/path/to/config"
process_data() { ... }

# Constants and environment variables
readonly CONFIG_DIR="$HOME/.config"
export POLYBAR_PROFILE="default"
```

### Logging

The logging functions are located in `files/functions/_logging.zsh`. These should be used for all logging and scripts. Do not create a new logging function without explicitly asking me and explaining why it is needed.

## Security Notes

- **Never hardcode secrets** in version control
- **Use chezmoi templates** for sensitive data that references 1Password or environment variables
- **Validate all user inputs** before processing
- **Set appropriate file permissions** (755 for executables, 644 for configs). If these can be set by chezmoi, use the file naming conventions in the [chezmoi documentation](https://www.chezmoi.io/reference/source-state-attributes/)
- **Use secure temp files** with proper cleanup

## Common Development Tasks

### Adding New Configuration Files
1. Add file to appropriate location in `files/` directory
2. Use chezmoi naming conventions (e.g., `dot_config` for `.config`)
3. Run validation: `chezmoi diff` then `chezmoi apply`

### Modifying Existing Configurations
1. Edit files in the `files/` directory (not the applied versions in home directory)
2. Test changes: `chezmoi diff`
3. Apply: `chezmoi apply`
4. Validate: `chezmoi data`

### Platform-Specific Changes
- Use chezmoi attributes: `[macos]`, `[linux]` in justfile
- Use template conditionals in `.tmpl` files: `{{- if eq .chezmoi.os "darwin" -}}`, `{{- if eq .chezmoi.os "linux" -}}` or `{{- if eq .osid "linux-ubuntu" -}}` if you need to target a specific linux flavor.

### Adding New Scripts
1. Place in `files/.chezmoiscripts/` with appropriate `run_` prefix
2. Use the standard script template (see Coding Standards below)
3. Make executable: `chmod +x filename`
4. Test with: `chezmoi diff` then `chezmoi apply`
