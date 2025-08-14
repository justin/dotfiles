# GitHub Copilot Instructions

## General Instructions

- This repository contains my dotfiles for various command line tools. The repository is managed by [Chezmoi](https://www.chezmoi.io).
- These dotfiles are primarily used on macOS hosts, but are also intended to work on Debian/Ubuntu hosts.
- These dotfiles can also work on ephemeral machines such as those used in GitHub Codespaces, Docker, or other cloud-based development environments.
- These dotfiles primarly support Z shell (`zsh`) configuration since this is the default shell on macOS. This shell is also used on Debian/Ubuntu hosts.
- When creating YAML files, **always** use the file extension `.yaml` (_never_ `.yml`).
- The user guide for Chezmoi is located at [https://www.chezmoi.io/user-guide/](https://www.chezmoi.io/user-guide/).
- The Chezmoi reference documentation is located at [https://www.chezmoi.io/reference/](https://www.chezmoi.io/reference/).
- When working with Chezmoi, the user guide and reference documentation should be consulted to understand the available commands, templates, and configuration options. If it is not listed in the user guide or reference documentation, it is not a valid command, template, or configuration option.

## Machine Architecture Instructions

- All my macOS machines are now Apple silicon (also known as _darwin-arm64_ or _macos-arm64_). This repository should assume Apple silicon architecture on macOS.
- On Debian/Ubuntu machines, we cannot assume an architecture. Debian/Ubuntu machines will either be ARM architecture (_amd64_) or Intel architecture (*x86_64*). Where machine architecture may be a factor, there should be a Chezmoi test to determine the machine architecture.

## Shell Instructions

- When creating files meant to be executed, read, or sourced by `zsh`, use the `.zsh` filename extension.
- When creating general purpose shell scripts, prefer basic Bourne shell (also known as `sh`) without a filename extension. Make the script executable (for example: `chmod 755 example-script-name`). Use the file header `#!/usr/bin/env sh` to ensure finding the correct `sh` executable.

## File Structure Context

- `files/` → Chezmoi-managed dotfiles (becomes `~/.config/`, `~/.local/`, etc.)
- Everything is built to conform to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).
- `home/dot_config/` → Maps to `~/.config/`
- `home/dot_local/bin/` → Maps to `~/.local/bin/` (executables)

## Tool Instructions

- [`1Password`](https://1password.com) is used to store secrets that should not be stored in version control. The [`op`](https://developer.1password.com/docs/cli/) should be installed on each machine that is not ephemeral. Chezmoi has built-in support for retrieving secrets from 1Password.
- `apt` is preferred to `apt-get` when installing software on Debian/Ubuntu hosts.
- [Homebrew](https://brew.sh) is use for installing command line tools and graphical user interface applications (using the `--cask` option) on macOS.
- [`uv`](https://docs.astral.sh/uv/) is used for Python version management, Python virtual environment management, and Python dependency management.

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

### Variable Naming

```zsh
# Local variables and functions
config_file="/path/to/config"
rice_name="gruvbox-dark"
process_data() { ... }

# Constants and environment variables
readonly CONFIG_DIR="$HOME/.config"
readonly RICE_DIR="$HOME/.local/share/wtf/bbq"
export POLYBAR_PROFILE="default"
```

### Logging

The logging functions are located in `files/functions/_logging.zsh`. These should be used for all logging and scripts. Do not create a new logging function without explicitly asking me and explaining why it is needed.

## Security Notes

- **Never hardcode secrets** in version control
- **Use chezmoi templates** for sensitive data
- **Validate all user inputs** before processing
- **Set appropriate file permissions** (755 for executables, 644 for configs)
- **Use secure temp files** with proper cleanup
