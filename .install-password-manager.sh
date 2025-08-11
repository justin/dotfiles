#!/usr/bin/env zsh
#
# Install 1Password CLI upon launch.

set -e

source "$HOME/.local/share/chezmoi/files/functions/_logging"
source "$HOME/.local/share/chezmoi/files/functions/_utilities"

if [ -n "${CODESPACES}" ] || [ -n "${CI}" ]; then
  info "Exit. Skip install-password-manager for non interactive shells."
  exit
fi

if [ "$(hostname)" = "nas" ]; then
  info "Exit. Skip install-password-manager for NAS."
  exit
fi

if type_exists 'op'; then
  exit 0
fi

is_macos || is_linux || fail "Unsupported OS. Only macOS and Linux are supported."
info "Installing 1Password CLI on Linux"
brew install 1password-cli
