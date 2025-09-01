# dotfiles

Opinionated personal dotfiles and machine bootstrap, optimized for my workflow. This repository is intended for my own use; you’re welcome to read or adapt, but nothing here is designed to be a general-purpose starter kit.

Everything is managed with chezmoi and follows the XDG Base Directory Specification (config in ~/.config, data in ~/.local/share, etc.).


## Platform compatibility

Supported:
- macOS (Intel and Apple Silicon)
- Linux (Debian/Ubuntu-family)

Not supported:
- Windows (including native PowerShell). WSL may work with Linux paths, but is not a target.

Environment-aware behavior:
- CI/Codespaces: certain interactive steps (e.g., 1Password CLI setup) are skipped.
- Host-specific exceptions: some scripts conditionally skip on specific hosts (e.g., “nas”).


## What this repo configures

High-level, opinionated setup of:

- Dotfiles manager
  - chezmoi: sources, templating, and apply lifecycle (run_once, run_onchange scripts)
- Shell and tasking
  - zsh as primary shell
  - just as task runner for routine maintenance (updates, npm, Python tools)
- Package management
  - macOS: Homebrew (formulae, casks), mas (Mac App Store via Brewfile)
  - Linux: apt and snap (via scripts and just tasks)
- Version control and CLIs
  - git, gh (GitHub CLI); optional Copilot CLI gh extension
- Secrets
  - 1Password CLI (op) for retrieving secrets in templates/scripts (skipped in ephemeral environments)
- Editors
  - Vim and Neovim configs with XDG-aware paths, custom color scheme, statusline, fzf integration
- Terminal/CLI tooling (installed via Brewfile and/or apt)
  - Examples: fzf, ripgrep, eza, fd, jq, htop, bat, wget, aria2, tree, tmux, tmuxinator, git-lfs, zoxide, less
- Language/tooling helpers
  - Node: npm globals update tasks
  - Python: uv for tool/venv/dependency management (via just tasks)
- macOS developer setup
  - xcodes CLI to install Xcode
  - Rosetta install on Apple Silicon when needed

Notes:
- Package lists for macOS are kept in Brewfiles under ~/.config; Linux package selections live in chezmoi data/templates.
- Post-apply provisioning is handled by scripts in files/.chezmoiscripts/* (e.g., run_once_before/after, run_onchange).

## Install

This will install prerequisites (macOS: Xcode Command Line Tools, Homebrew; Linux: chezmoi into ~/.local/bin) and then apply the dotfiles via chezmoi.

Warning:
- This may overwrite existing configuration files. Back up anything important before proceeding.
- You will be prompted for system credentials (e.g., sudo) and to authorize installs on macOS.

Run:

```sh
sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/justin/dotfiles/main/install.sh')"
```

What the installer does, at a glance:
- Detects platform (macOS vs Linux)
- macOS: installs Xcode CLTs if missing, installs or initializes Homebrew, installs chezmoi, then applies the repo
- Linux: fetches chezmoi to ~/.local/bin and applies the repo from the local source directory


## Day-2 operations (for me)

Use just to keep things current:

- macOS:
  - just update-all
    - Updates Homebrew (upgrade/cleanup), gh extensions, Mac App Store apps, npm globals, Python tools (via uv)
- Linux:
  - just update-all
    - Updates apt and snap packages, npm globals, Python tools (via uv)

Additional tasks are defined in ~/.config/just/justfile.


## Repository layout (simplified)

- files/ … chezmoi-managed sources, mapped into:
  - private_dot_config/ → ~/.config/
    - homebrew/ → Brewfiles and bundle lists
    - just/ → justfile and automation
    - vim/, nvim/ → editor configs
    - macOS bundle files (Brewfile, Brewfile-CLI, Brewfile-Fonts, Brewfile-MacAppStore)
  - dot_local/ → ~/.local/
  - .chezmoiscripts/ → lifecycle scripts (run_once_*, run_onchange_*)
  - .chezmoidata/ → templating data (e.g., ubuntu.yml, macos.yml)
- install.sh → bootstrap entrypoint for new machines


## Assumptions and caveats

- Network access is required to fetch tools (Homebrew, packages, GitHub assets).
- Some steps are interactive (e.g., App Store installs, 1Password CLI sign-in).
- Templates assume zsh and XDG directories.
- Linux scripts assume Debian/Ubuntu-family hosts for apt; other distros are not targeted.


## License

The Unlicense — see LICENSE.
