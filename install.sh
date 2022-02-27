#!/usr/bin/env sh
#
# Configure a new machine with the dotfiles and configuration from this repository.

set -e

CHEZMOI="/usr/local/bin/chezmoi"
CHEZMOI_DIR="$(dirname "$CHEZMOI")"

if [ -x "$(command -v brew)" ]; then
    CHEZMOI="$(command -v chezmoi)"
    CHEZMOI_DIR="$(dirname "$CHEZMOI")"
else
    echo "Downloading chezmoi project for dotfiles management."
    mkdir -p "$CHEZMOI_DIR"
    sh -c "$(curl -fsLS git.io/chezmoi)" -- -b "$CHEZMOI_DIR"
fi

echo "Configuring dotfiles."
"$CHEZMOI" init --apply justin
